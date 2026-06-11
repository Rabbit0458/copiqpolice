// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Endpoint /health                                 ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-083             ║
// ║                                                                           ║
// ║  Pingé par Uptime Kuma toutes les 60s pour valider que :                  ║
// ║   • Postgres répond (index lookup rapide sur cas_pratique_themes)         ║
// ║   • Le service_role peut signer une requête                              ║
// ║   • La latence reste sous le seuil                                        ║
// ║                                                                           ║
// ║  GET /functions/v1/cas_pratique_health                                     ║
// ║  Réponse 200 OK :                                                          ║
// ║    {                                                                       ║
// ║      "status": "ok",                                                       ║
// ║      "latency_ms": 42,                                                     ║
// ║      "checks": {                                                           ║
// ║        "db_themes_count": 12,                                              ║
// ║        "db_latency_ms": 38                                                 ║
// ║      },                                                                    ║
// ║      "version": "1.0.0",                                                   ║
// ║      "checked_at": "2026-06-05T15:30:00.000Z"                              ║
// ║    }                                                                       ║
// ║                                                                           ║
// ║  Réponse 503 si :                                                          ║
// ║   • Postgres ne répond pas                                                 ║
// ║   • latence DB > 2000 ms                                                   ║
// ║   • env vars manquantes                                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const VERSION = "1.0.0";
const DB_LATENCY_THRESHOLD_MS = 2000;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, HEAD, OPTIONS",
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (!["GET", "HEAD"].includes(req.method)) {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  const startedAt = Date.now();

  // ── Vérification env vars ──────────────────────────────────────────────
  const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
  const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!SUPABASE_URL || !SERVICE_KEY) {
    return jsonResponse(
      {
        status: "down",
        reason: "env_missing",
        checked_at: new Date().toISOString(),
        version: VERSION,
      },
      503,
    );
  }

  const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // ── Check DB : count rapide sur les thèmes (index PK) ──────────────────
  const dbStart = Date.now();
  let dbHealthy = true;
  let dbLatency = 0;
  let themesCount = 0;

  try {
    const { count, error } = await sb
      .from("cas_pratique_themes")
      .select("id", { count: "exact", head: true });

    dbLatency = Date.now() - dbStart;
    if (error) {
      dbHealthy = false;
    } else {
      themesCount = count ?? 0;
    }
  } catch (e) {
    dbLatency = Date.now() - dbStart;
    dbHealthy = false;
    console.error("[health] db error:", e);
  }

  // ── Verdict ────────────────────────────────────────────────────────────
  const totalLatency = Date.now() - startedAt;
  const isHealthy = dbHealthy && dbLatency < DB_LATENCY_THRESHOLD_MS;

  const payload = {
    status: isHealthy ? "ok" : (dbHealthy ? "degraded" : "down"),
    latency_ms: totalLatency,
    checks: {
      db_healthy: dbHealthy,
      db_latency_ms: dbLatency,
      db_themes_count: themesCount,
      db_latency_threshold_ms: DB_LATENCY_THRESHOLD_MS,
    },
    version: VERSION,
    checked_at: new Date().toISOString(),
  };

  return jsonResponse(payload, isHealthy ? 200 : 503);
});

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
      "Cache-Control": "no-store, no-cache, must-revalidate",
    },
  });
}
