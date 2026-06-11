// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Stripe webhook                                   ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-085             ║
// ║                                                                           ║
// ║  Reçoit les events Stripe et UPSERT la table cas_pratique_subscriptions.  ║
// ║                                                                           ║
// ║  POST /functions/v1/cas_pratique_stripe_webhook                            ║
// ║  Headers : stripe-signature: t=...,v1=...                                  ║
// ║  Body    : raw Stripe event JSON                                          ║
// ║                                                                           ║
// ║  Events gérés :                                                            ║
// ║    • checkout.session.completed                                            ║
// ║    • customer.subscription.created                                         ║
// ║    • customer.subscription.updated                                         ║
// ║    • customer.subscription.deleted                                         ║
// ║    • invoice.payment_failed                                                ║
// ║    • invoice.payment_succeeded                                             ║
// ║                                                                           ║
// ║  Env vars requises :                                                       ║
// ║    SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY                                ║
// ║    STRIPE_SECRET_KEY (sk_live_... ou sk_test_...)                         ║
// ║    STRIPE_WEBHOOK_SECRET (whsec_...)                                       ║
// ║                                                                           ║
// ║  ⚠️ La vérification de signature Stripe est CRITIQUE — refuse tout event   ║
// ║     non signé pour éviter les UPSERT frauduleux.                          ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";
import Stripe from "https://esm.sh/stripe@14.21.0?target=deno";

// ──────────────────────────────────────────────────────────────────────────
//  Config
// ──────────────────────────────────────────────────────────────────────────

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "stripe-signature, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const STRIPE_SECRET_KEY = Deno.env.get("STRIPE_SECRET_KEY")!;
const STRIPE_WEBHOOK_SECRET = Deno.env.get("STRIPE_WEBHOOK_SECRET")!;

const stripe = new Stripe(STRIPE_SECRET_KEY, {
  apiVersion: "2023-10-16",
  httpClient: Stripe.createFetchHttpClient(),
});

const cryptoProvider = Stripe.createSubtleCryptoProvider();

const adminClient = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

// ──────────────────────────────────────────────────────────────────────────
//  Helpers
// ──────────────────────────────────────────────────────────────────────────

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

/**
 * Mappe un status Stripe vers notre enum DB.
 */
function mapStripeStatus(stripeStatus: string): string {
  const allowed = [
    "active",
    "past_due",
    "canceled",
    "incomplete",
    "unpaid",
    "trialing",
  ];
  return allowed.includes(stripeStatus) ? stripeStatus : "incomplete";
}

/**
 * Calcule le tier à partir du status Stripe.
 */
function tierFromStatus(stripeStatus: string): string {
  if (stripeStatus === "trialing") return "premium_trial";
  if (stripeStatus === "active") return "premium";
  return "free";
}

/**
 * UPSERT la souscription dans Supabase.
 */
async function upsertSubscription(args: {
  userId: string;
  stripeCustomerId: string | null;
  stripeSubscriptionId: string;
  stripePriceId: string | null;
  stripeProductId: string | null;
  status: string;
  currentPeriodStart: Date | null;
  currentPeriodEnd: Date | null;
  cancelAtPeriodEnd: boolean;
  canceledAt: Date | null;
  trialEndsAt: Date | null;
  entitlements: string[];
}): Promise<{ ok: boolean; error?: string }> {
  const tier = tierFromStatus(args.status);
  const dbStatus = mapStripeStatus(args.status);

  const { error } = await adminClient
    .from("cas_pratique_subscriptions")
    .upsert(
      {
        user_id: args.userId,
        tier,
        status: dbStatus,
        stripe_customer_id: args.stripeCustomerId,
        stripe_subscription_id: args.stripeSubscriptionId,
        stripe_price_id: args.stripePriceId,
        stripe_product_id: args.stripeProductId,
        current_period_start: args.currentPeriodStart?.toISOString() ?? null,
        current_period_end: args.currentPeriodEnd?.toISOString() ?? null,
        cancel_at_period_end: args.cancelAtPeriodEnd,
        canceled_at: args.canceledAt?.toISOString() ?? null,
        trial_ends_at: args.trialEndsAt?.toISOString() ?? null,
        entitlements: args.entitlements,
        updated_at: new Date().toISOString(),
      },
      { onConflict: "user_id" },
    );

  if (error) {
    console.error("[stripe_webhook] upsert failed:", error.message);
    return { ok: false, error: error.message };
  }
  return { ok: true };
}

/**
 * Récupère le user_id COP'IQ associé à un Stripe customer_id.
 * Convention : on stocke supabase_user_id dans metadata du Customer Stripe.
 */
async function userIdFromCustomer(customerId: string): Promise<string | null> {
  try {
    const customer = await stripe.customers.retrieve(customerId);
    if (customer.deleted) return null;
    const userId =
      (customer as Stripe.Customer).metadata?.supabase_user_id ?? null;
    return userId || null;
  } catch (e) {
    console.error("[stripe_webhook] customer fetch failed:", e);
    return null;
  }
}

/**
 * Extraction des entitlements à partir des metadata produit Stripe.
 * Convention : tu peux mettre `entitlements: "concours_blanc,pdf_export"` dans
 * la metadata du Stripe Product. Sinon, fallback sur des entitlements par défaut.
 */
function entitlementsFromMetadata(
  productMetadata: Stripe.Metadata | null,
): string[] {
  const raw = productMetadata?.entitlements;
  if (typeof raw === "string" && raw.length > 0) {
    return raw.split(",").map((s) => s.trim()).filter(Boolean);
  }
  // Fallback : tout débloquer
  return [
    "unlimited_cases",
    "concours_blanc",
    "pdf_export",
    "leaderboard",
    "annales_full",
    "edge_correction",
    "support_priority",
  ];
}

// ──────────────────────────────────────────────────────────────────────────
//  Handler principal
// ──────────────────────────────────────────────────────────────────────────

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  // ── 1. Récupération de la signature ────────────────────────────────────
  const signature = req.headers.get("stripe-signature");
  if (!signature) {
    return jsonResponse({ error: "missing_signature" }, 401);
  }

  const rawBody = await req.text();

  // ── 2. Vérification de signature (CRITIQUE) ────────────────────────────
  let event: Stripe.Event;
  try {
    event = await stripe.webhooks.constructEventAsync(
      rawBody,
      signature,
      STRIPE_WEBHOOK_SECRET,
      undefined,
      cryptoProvider,
    );
  } catch (e) {
    console.error("[stripe_webhook] signature invalid:", e);
    return jsonResponse({ error: "invalid_signature" }, 401);
  }

  console.log(`[stripe_webhook] received event: ${event.type} (${event.id})`);

  // ── 3. Routage par type d'event ────────────────────────────────────────
  try {
    switch (event.type) {
      case "checkout.session.completed": {
        const session = event.data.object as Stripe.Checkout.Session;
        const userId = session.metadata?.supabase_user_id ?? null;
        if (!userId) {
          console.warn(
            "[stripe_webhook] checkout.session.completed without user_id metadata",
          );
          break;
        }

        // Récup la souscription complète
        if (session.subscription) {
          const sub = await stripe.subscriptions.retrieve(
            session.subscription as string,
            { expand: ["items.data.price.product"] },
          );
          await handleSubscription(userId, sub);
        }
        break;
      }

      case "customer.subscription.created":
      case "customer.subscription.updated":
      case "customer.subscription.deleted": {
        const sub = event.data.object as Stripe.Subscription;
        const userId = await userIdFromCustomer(sub.customer as string);
        if (!userId) {
          console.warn(
            `[stripe_webhook] no supabase_user_id in customer ${sub.customer}`,
          );
          break;
        }
        await handleSubscription(userId, sub);
        break;
      }

      case "invoice.payment_failed": {
        const invoice = event.data.object as Stripe.Invoice;
        const userId = await userIdFromCustomer(invoice.customer as string);
        if (!userId) break;

        await adminClient
          .from("cas_pratique_subscriptions")
          .update({
            status: "past_due",
            updated_at: new Date().toISOString(),
          })
          .eq("user_id", userId);

        console.log(
          `[stripe_webhook] marked past_due userId=${userId} invoice=${invoice.id}`,
        );
        break;
      }

      case "invoice.payment_succeeded": {
        const invoice = event.data.object as Stripe.Invoice;
        if (!invoice.subscription) break;
        const userId = await userIdFromCustomer(invoice.customer as string);
        if (!userId) break;

        const sub = await stripe.subscriptions.retrieve(
          invoice.subscription as string,
          { expand: ["items.data.price.product"] },
        );
        await handleSubscription(userId, sub);
        break;
      }

      default:
        console.log(`[stripe_webhook] unhandled event type: ${event.type}`);
    }
  } catch (e) {
    console.error("[stripe_webhook] handler error:", e);
    return jsonResponse({ error: "handler_failed", details: String(e) }, 500);
  }

  return jsonResponse({ received: true, event: event.type }, 200);
});

// ──────────────────────────────────────────────────────────────────────────
//  Helper : gestion d'une souscription Stripe complète
// ──────────────────────────────────────────────────────────────────────────

async function handleSubscription(
  userId: string,
  sub: Stripe.Subscription,
): Promise<void> {
  const item = sub.items.data[0];
  const price = item?.price;
  const product = price?.product as Stripe.Product | undefined;

  const result = await upsertSubscription({
    userId,
    stripeCustomerId:
      typeof sub.customer === "string" ? sub.customer : sub.customer?.id ?? null,
    stripeSubscriptionId: sub.id,
    stripePriceId: price?.id ?? null,
    stripeProductId: product?.id ?? null,
    status: sub.status,
    currentPeriodStart: sub.current_period_start
      ? new Date(sub.current_period_start * 1000)
      : null,
    currentPeriodEnd: sub.current_period_end
      ? new Date(sub.current_period_end * 1000)
      : null,
    cancelAtPeriodEnd: sub.cancel_at_period_end,
    canceledAt: sub.canceled_at ? new Date(sub.canceled_at * 1000) : null,
    trialEndsAt: sub.trial_end ? new Date(sub.trial_end * 1000) : null,
    entitlements: entitlementsFromMetadata(product?.metadata ?? null),
  });

  if (!result.ok) {
    throw new Error(`upsert failed: ${result.error}`);
  }

  console.log(
    `[stripe_webhook] upsert OK userId=${userId} status=${sub.status} subId=${sub.id}`,
  );
}
