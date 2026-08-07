import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";
import Stripe from "https://esm.sh/stripe@14.21.0?target=deno";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), {
  status, headers: { ...corsHeaders, "Content-Type": "application/json" },
});

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);
  const token = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return json({ error: "missing_authorization" }, 401);

  const url = Deno.env.get("SUPABASE_URL")!;
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const auth = createClient(url, serviceKey, { auth: { persistSession: false } });
  const { data, error } = await auth.auth.getUser(token);
  if (error || !data.user) return json({ error: "invalid_jwt" }, 401);

  const admin = createClient(url, serviceKey, { auth: { persistSession: false } });
  const { data: subscription } = await admin.from("cas_pratique_subscriptions")
    .select("stripe_customer_id").eq("user_id", data.user.id).maybeSingle();
  if (!subscription?.stripe_customer_id) return json({ error: "stripe_customer_not_found" }, 404);

  let body: { return_url?: string } = {};
  try { body = await req.json(); } catch { /* optional body */ }
  const returnUrl = body.return_url ?? Deno.env.get("STRIPE_PORTAL_RETURN_URL")
    ?? "https://copiqpolice.app/abonnement";
  if (!returnUrl.startsWith("https://") && !returnUrl.startsWith("copiqpolice://")) {
    return json({ error: "invalid_return_url" }, 400);
  }

  const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY")!, {
    apiVersion: "2023-10-16", httpClient: Stripe.createFetchHttpClient(),
  });
  const session = await stripe.billingPortal.sessions.create({
    customer: subscription.stripe_customer_id, return_url: returnUrl,
  });
  return json({ url: session.url });
});
