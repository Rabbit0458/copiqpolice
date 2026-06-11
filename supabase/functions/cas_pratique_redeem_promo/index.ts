// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Validation & application d'un code promo         ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-087             ║
// ║                                                                           ║
// ║  POST /functions/v1/cas_pratique_redeem_promo                              ║
// ║  Headers : Authorization: Bearer <user_jwt>                               ║
// ║  Body    : { "code": "STUDENT50", "price_id"?: "price_xxx" }              ║
// ║                                                                           ║
// ║  Mode :                                                                    ║
// ║   • validate_only=true  → vérifie sans consommer (UI feedback)           ║
// ║   • validate_only=false → consomme (crée une redemption + Stripe coupon) ║
// ║                                                                           ║
// ║  Réponse :                                                                 ║
// ║    {                                                                       ║
// ║      "valid": true,                                                        ║
// ║      "reason": "valid",                                                    ║
// ║      "discount": { "kind": "percent", "value": 50 },                      ║
// ║      "stripe_coupon_id": "<id>"  // à passer au checkout                  ║
// ║    }                                                                       ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

interface RedeemRequest {
  code: string;
  price_id?: string;
  validate_only?: boolean;
}

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return jsonResponse({ error: "missing_authorization" }, 401);
  }
  const jwt = authHeader.replace("Bearer ", "").trim();

  let body: RedeemRequest;
  try {
    body = (await req.json()) as RedeemRequest;
  } catch {
    return jsonResponse({ error: "invalid_json_body" }, 400);
  }

  if (!body.code || typeof body.code !== "string") {
    return jsonResponse({ error: "code_required" }, 400);
  }
  const code = body.code.trim().toUpperCase();
  if (code.length < 4 || code.length > 32) {
    return jsonResponse({ error: "code_length_invalid" }, 400);
  }

  const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
  const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

  const userClient = createClient(SUPABASE_URL, SERVICE_KEY, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const { data: userInfo, error: userErr } = await userClient.auth.getUser(jwt);
  if (userErr || !userInfo?.user) {
    return jsonResponse({ error: "invalid_jwt" }, 401);
  }
  const userId = userInfo.user.id;

  const adminClient = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // ── 1. Validation côté serveur via la fonction RPC ─────────────────────
  const { data: validation, error: valErr } = await adminClient.rpc(
    "cp_validate_promo_code",
    {
      p_code: code,
      p_user_id: userId,
      p_price_id: body.price_id ?? null,
    },
  );

  if (valErr) {
    console.error("[redeem_promo] rpc error:", valErr);
    return jsonResponse({ error: "validation_failed" }, 500);
  }

  const row = Array.isArray(validation) ? validation[0] : validation;
  if (!row) {
    return jsonResponse(
      { valid: false, reason: "code_not_found" },
      200,
    );
  }

  if (!row.valid) {
    return jsonResponse(
      {
        valid: false,
        reason: row.reason,
      },
      200,
    );
  }

  // ── 2. Si validate_only → on retourne le résultat sans consommer ──────
  if (body.validate_only) {
    return jsonResponse(
      {
        valid: true,
        reason: "valid",
        discount: {
          kind: row.discount_kind,
          value: row.discount_value,
        },
        stripe_coupon_id: row.stripe_coupon_id ?? null,
      },
      200,
    );
  }

  // ── 3. Consommation : crée une entrée redemption ──────────────────────
  const { error: insertErr } = await adminClient
    .from("cas_pratique_promo_redemptions")
    .insert({
      promo_code_id: row.promo_id,
      user_id: userId,
      metadata: { price_id: body.price_id ?? null },
    });

  if (insertErr) {
    console.error("[redeem_promo] insert error:", insertErr);
    return jsonResponse(
      { error: "redemption_failed", details: insertErr.message },
      500,
    );
  }

  console.log(
    `[redeem_promo] OK userId=${userId} code=${code} kind=${row.discount_kind} value=${row.discount_value}`,
  );

  return jsonResponse(
    {
      valid: true,
      reason: "applied",
      discount: {
        kind: row.discount_kind,
        value: row.discount_value,
      },
      stripe_coupon_id: row.stripe_coupon_id ?? null,
    },
    200,
  );
});
