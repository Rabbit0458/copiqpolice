// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — RevenueCat webhook (achats iOS/Android)                         ║
// ║                                                                           ║
// ║  Reçoit les events RevenueCat et UPSERT la table                          ║
// ║  cas_pratique_subscriptions — même table que le webhook Stripe, avec      ║
// ║  payment_source='revenuecat', pour garder is_user_premium() et            ║
// ║  SubscriptionService/EntitlementService inchangés côté client.            ║
// ║                                                                           ║
// ║  POST /functions/v1/cas_pratique_revenuecat_webhook                       ║
// ║  Headers : authorization: <valeur statique configurée dans RevenueCat>    ║
// ║  Body    : { api_version, event: { id, type, app_user_id, ... } }         ║
// ║                                                                           ║
// ║  app_user_id DOIT être le user_id Supabase — l'app appelle                ║
// ║  Purchases.logIn(supabaseUserId) au démarrage (voir                       ║
// ║  revenuecat_payment_service.dart), donc pas besoin de table de mapping.   ║
// ║                                                                           ║
// ║  Env vars requises :                                                       ║
// ║    SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY                                ║
// ║    REVENUECAT_WEBHOOK_AUTH (valeur exacte du header Authorization envoyé  ║
// ║      par RevenueCat — configurée dans RevenueCat → Project → Webhooks)    ║
// ║                                                                           ║
// ║  ⚠️ Sans REVENUECAT_WEBHOOK_AUTH configuré, la fonction refuse tout       ║
// ║     event (fail-closed) pour éviter des UPSERT non authentifiés.          ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const REVENUECAT_WEBHOOK_AUTH = Deno.env.get("REVENUECAT_WEBHOOK_AUTH");

const adminClient = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

// ──────────────────────────────────────────────────────────────────────────
//  Types (sous-ensemble utile du payload RevenueCat)
// ──────────────────────────────────────────────────────────────────────────

interface RevenueCatEvent {
  id: string;
  type: string;
  app_user_id: string;
  product_id?: string;
  original_transaction_id?: string;
  transaction_id?: string;
  period_type?: string; // 'NORMAL' | 'TRIAL' | 'INTRO'
  store?: string; // 'APP_STORE' | 'PLAY_STORE' | 'STRIPE' | ...
  purchased_at_ms?: number;
  expiration_at_ms?: number | null;
  entitlement_ids?: string[] | null;
}

interface RevenueCatPayload {
  api_version?: string;
  event: RevenueCatEvent;
}

// ──────────────────────────────────────────────────────────────────────────
//  Helpers
// ──────────────────────────────────────────────────────────────────────────

const DEFAULT_ENTITLEMENTS = [
  "unlimited_cases",
  "concours_blanc",
  "pdf_export",
  "leaderboard",
  "annales_full",
  "edge_correction",
  "support_priority",
];

function storeFromEvent(store: string | undefined): string | null {
  if (store === "APP_STORE") return "app_store";
  if (store === "PLAY_STORE") return "play_store";
  return null;
}

function msToIso(ms: number | null | undefined): string | null {
  if (ms === null || ms === undefined) return null;
  return new Date(ms).toISOString();
}

async function upsertSubscription(args: {
  userId: string;
  tier: string;
  status: string;
  cancelAtPeriodEnd: boolean;
  currentPeriodEnd: string | null;
  productId: string | null;
  originalTransactionId: string | null;
  store: string | null;
}): Promise<{ ok: boolean; error?: string }> {
  const { error } = await adminClient
    .from("cas_pratique_subscriptions")
    .upsert(
      {
        user_id: args.userId,
        tier: args.tier,
        status: args.status,
        payment_source: "revenuecat",
        revenuecat_app_user_id: args.userId,
        revenuecat_product_id: args.productId,
        revenuecat_original_transaction_id: args.originalTransactionId,
        store: args.store,
        current_period_end: args.currentPeriodEnd,
        cancel_at_period_end: args.cancelAtPeriodEnd,
        entitlements: DEFAULT_ENTITLEMENTS,
        updated_at: new Date().toISOString(),
      },
      { onConflict: "user_id" },
    );

  if (error) {
    console.error("[revenuecat_webhook] upsert failed:", error.message);
    return { ok: false, error: error.message };
  }
  return { ok: true };
}

/**
 * Ne change QUE cancel_at_period_end (l'accès reste actif jusqu'à
 * expiration_at_ms — Apple/Google interdisent de couper l'accès avant la fin
 * de la période déjà payée).
 */
async function markCancelAtPeriodEnd(
  userId: string,
  currentPeriodEnd: string | null,
): Promise<{ ok: boolean; error?: string }> {
  const { error } = await adminClient
    .from("cas_pratique_subscriptions")
    .update({
      cancel_at_period_end: true,
      current_period_end: currentPeriodEnd,
      updated_at: new Date().toISOString(),
    })
    .eq("user_id", userId);

  if (error) {
    console.error("[revenuecat_webhook] cancel-flag update failed:", error.message);
    return { ok: false, error: error.message };
  }
  return { ok: true };
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

  // ── 1. Authentification par header statique (fail-closed) ───────────────
  if (!REVENUECAT_WEBHOOK_AUTH) {
    console.error("[revenuecat_webhook] REVENUECAT_WEBHOOK_AUTH not configured");
    return jsonResponse({ error: "webhook_not_configured" }, 500);
  }
  const receivedAuth = req.headers.get("authorization");
  if (receivedAuth !== REVENUECAT_WEBHOOK_AUTH) {
    console.error("[revenuecat_webhook] invalid authorization header");
    return jsonResponse({ error: "invalid_authorization" }, 401);
  }

  // ── 2. Parse body ─────────────────────────────────────────────────────
  let payload: RevenueCatPayload;
  try {
    payload = (await req.json()) as RevenueCatPayload;
  } catch {
    return jsonResponse({ error: "invalid_json_body" }, 400);
  }

  const event = payload.event;
  if (!event?.id || !event?.type || !event?.app_user_id) {
    return jsonResponse({ error: "missing_event_fields" }, 400);
  }

  console.log(`[revenuecat_webhook] received event: ${event.type} (${event.id})`);

  // ── 3. Idempotence ───────────────────────────────────────────────────
  const { error: eventInsertError } = await adminClient
    .from("cp_revenuecat_webhook_events")
    .insert({ event_id: event.id, event_type: event.type });
  if (eventInsertError) {
    if (eventInsertError.code === "23505") {
      return jsonResponse({ received: true, duplicate: true }, 200);
    }
    console.error("[revenuecat_webhook] idempotency insert failed:", eventInsertError);
    return jsonResponse({ error: "idempotency_failed" }, 500);
  }

  const userId = event.app_user_id;
  const store = storeFromEvent(event.store);
  const periodEnd = msToIso(event.expiration_at_ms);
  const productId = event.product_id ?? null;
  const originalTransactionId = event.original_transaction_id ?? null;

  // ── 4. Routage par type d'event ──────────────────────────────────────
  try {
    switch (event.type) {
      case "INITIAL_PURCHASE":
      case "RENEWAL":
      case "UNCANCELLATION":
      case "PRODUCT_CHANGE":
      case "SUBSCRIPTION_EXTENDED": {
        const isTrial = event.period_type === "TRIAL";
        const result = await upsertSubscription({
          userId,
          tier: isTrial ? "premium_trial" : "premium",
          status: isTrial ? "trialing" : "active",
          cancelAtPeriodEnd: false,
          currentPeriodEnd: periodEnd,
          productId,
          originalTransactionId,
          store,
        });
        if (!result.ok) throw new Error(`upsert failed: ${result.error}`);
        break;
      }

      case "CANCELLATION": {
        // Apple/Google : l'accès reste actif jusqu'à expiration_at_ms.
        // On marque juste l'intention d'annulation, sans couper l'accès.
        const result = await markCancelAtPeriodEnd(userId, periodEnd);
        if (!result.ok) throw new Error(`cancel-flag failed: ${result.error}`);
        break;
      }

      case "EXPIRATION": {
        const result = await upsertSubscription({
          userId,
          tier: "free",
          status: "canceled",
          cancelAtPeriodEnd: false,
          currentPeriodEnd: periodEnd,
          productId,
          originalTransactionId,
          store,
        });
        if (!result.ok) throw new Error(`upsert failed: ${result.error}`);
        break;
      }

      case "BILLING_ISSUE": {
        const { error } = await adminClient
          .from("cas_pratique_subscriptions")
          .update({ status: "past_due", updated_at: new Date().toISOString() })
          .eq("user_id", userId);
        if (error) throw new Error(`billing_issue update failed: ${error.message}`);
        break;
      }

      case "REFUND": {
        // Révocation immédiate — RevenueCat/Apple/Google retirent l'accès
        // tout de suite en cas de remboursement.
        const result = await upsertSubscription({
          userId,
          tier: "free",
          status: "canceled",
          cancelAtPeriodEnd: false,
          currentPeriodEnd: periodEnd,
          productId,
          originalTransactionId,
          store,
        });
        if (!result.ok) throw new Error(`upsert failed: ${result.error}`);
        break;
      }

      default:
        console.log(`[revenuecat_webhook] unhandled event type: ${event.type}`);
    }
  } catch (e) {
    console.error("[revenuecat_webhook] handler error:", e);
    await adminClient.from("cp_revenuecat_webhook_events")
      .delete().eq("event_id", event.id);
    return jsonResponse({ error: "handler_failed", details: String(e) }, 500);
  }

  return jsonResponse({ received: true, event: event.type }, 200);
});
