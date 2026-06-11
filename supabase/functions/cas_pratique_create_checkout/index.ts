// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Création session Stripe Checkout                 ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-085             ║
// ║                                                                           ║
// ║  Crée une Checkout Session Stripe (mode subscription) et retourne l'URL  ║
// ║  à ouvrir côté client.                                                    ║
// ║                                                                           ║
// ║  POST /functions/v1/cas_pratique_create_checkout                           ║
// ║  Headers : Authorization: Bearer <user_jwt>                               ║
// ║  Body    : {                                                               ║
// ║              "price_id": "price_xxx",                                      ║
// ║              "success_url": "copiqpolice://paywall/success",              ║
// ║              "cancel_url":  "copiqpolice://paywall/cancel",               ║
// ║              "allow_promotion_codes": true                                ║
// ║            }                                                               ║
// ║                                                                           ║
// ║  Réponse :                                                                 ║
// ║    { "url": "https://checkout.stripe.com/c/pay/...", "id": "cs_..." }     ║
// ║                                                                           ║
// ║  Side effect :                                                             ║
// ║   - Crée un Stripe Customer si l'user n'en a pas encore                   ║
// ║   - Lie `supabase_user_id` dans le metadata du customer                   ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";
import Stripe from "https://esm.sh/stripe@14.21.0?target=deno";

interface CheckoutRequest {
  price_id: string;
  success_url?: string;
  cancel_url?: string;
  allow_promotion_codes?: boolean;
  trial_period_days?: number;
}

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const DEFAULT_SUCCESS_URL = "copiqpolice://paywall/success";
const DEFAULT_CANCEL_URL = "copiqpolice://paywall/cancel";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const STRIPE_SECRET_KEY = Deno.env.get("STRIPE_SECRET_KEY")!;

const stripe = new Stripe(STRIPE_SECRET_KEY, {
  apiVersion: "2023-10-16",
  httpClient: Stripe.createFetchHttpClient(),
});

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

/**
 * Trouve ou crée le Stripe Customer pour cet utilisateur Supabase.
 * Stocke `supabase_user_id` dans les metadata pour que le webhook puisse remonter.
 */
async function getOrCreateCustomer(
  userId: string,
  userEmail: string | undefined,
  adminClient: ReturnType<typeof createClient>,
): Promise<string> {
  // 1. Vérifie si on a déjà un customer en DB
  const { data: existing } = await adminClient
    .from("cas_pratique_subscriptions")
    .select("stripe_customer_id")
    .eq("user_id", userId)
    .maybeSingle();

  if (existing?.stripe_customer_id) {
    return existing.stripe_customer_id;
  }

  // 2. Recherche côté Stripe par email (au cas où on l'a perdu en DB)
  if (userEmail) {
    const search = await stripe.customers.list({
      email: userEmail,
      limit: 1,
    });
    if (search.data.length > 0) {
      const existingCustomer = search.data[0];
      // Vérifie / met à jour la metadata supabase_user_id
      if (existingCustomer.metadata?.supabase_user_id !== userId) {
        await stripe.customers.update(existingCustomer.id, {
          metadata: { ...existingCustomer.metadata, supabase_user_id: userId },
        });
      }
      return existingCustomer.id;
    }
  }

  // 3. Sinon, créer
  const created = await stripe.customers.create({
    email: userEmail,
    metadata: { supabase_user_id: userId, source: "copiq_mobile" },
  });
  return created.id;
}

// ──────────────────────────────────────────────────────────────────────────
//  Handler
// ──────────────────────────────────────────────────────────────────────────

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  // ── Auth ───────────────────────────────────────────────────────────────
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return jsonResponse({ error: "missing_authorization" }, 401);
  }
  const jwt = authHeader.replace("Bearer ", "").trim();

  // ── Body ───────────────────────────────────────────────────────────────
  let body: CheckoutRequest;
  try {
    body = (await req.json()) as CheckoutRequest;
  } catch {
    return jsonResponse({ error: "invalid_json_body" }, 400);
  }

  if (!body.price_id || typeof body.price_id !== "string") {
    return jsonResponse({ error: "price_id_required" }, 400);
  }

  // ── Identification du user ─────────────────────────────────────────────
  const userClient = createClient(SUPABASE_URL, SERVICE_KEY, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const { data: userInfo, error: userErr } = await userClient.auth.getUser(jwt);
  if (userErr || !userInfo?.user) {
    return jsonResponse({ error: "invalid_jwt" }, 401);
  }
  const userId = userInfo.user.id;
  const userEmail = userInfo.user.email;

  const adminClient = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // ── Customer Stripe ────────────────────────────────────────────────────
  let customerId: string;
  try {
    customerId = await getOrCreateCustomer(userId, userEmail, adminClient);
  } catch (e) {
    console.error("[create_checkout] customer error:", e);
    return jsonResponse({ error: "stripe_customer_failed" }, 500);
  }

  // ── Création de la session ─────────────────────────────────────────────
  try {
    const session = await stripe.checkout.sessions.create({
      mode: "subscription",
      customer: customerId,
      line_items: [{ price: body.price_id, quantity: 1 }],
      success_url: body.success_url ?? DEFAULT_SUCCESS_URL,
      cancel_url: body.cancel_url ?? DEFAULT_CANCEL_URL,
      allow_promotion_codes: body.allow_promotion_codes ?? true,
      automatic_tax: { enabled: true },
      subscription_data: {
        trial_period_days: body.trial_period_days,
        metadata: { supabase_user_id: userId },
      },
      metadata: {
        supabase_user_id: userId,
        source: "copiq_mobile",
      },
      // Localization
      locale: "fr",
    });

    return jsonResponse(
      {
        url: session.url,
        id: session.id,
        customer_id: customerId,
      },
      200,
    );
  } catch (e) {
    console.error("[create_checkout] session error:", e);
    return jsonResponse(
      { error: "stripe_session_failed", details: String(e) },
      500,
    );
  }
});
