// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Edge Function : app_minimum_version                            ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-098            ║
// ║                                                                           ║
// ║  Retourne la version minimale requise pour chaque plateforme.             ║
// ║  L'app vérifie cela au boot et affiche un écran bloquant si elle est      ║
// ║  trop vieille.                                                             ║
// ║                                                                           ║
// ║  GET /functions/v1/app_minimum_version?platform=android|ios              ║
// ║  Réponse 200 :                                                             ║
// ║    {                                                                       ║
// ║      "min_version": "1.0.0",                                              ║
// ║      "latest_version": "1.2.0",                                           ║
// ║      "force_update": false,                                               ║
// ║      "store_url": "https://play.google.com/store/apps/details?id=...",   ║
// ║      "message_fr": "Une mise à jour est requise pour continuer.",         ║
// ║      "checked_at": "2026-06-06T12:00:00.000Z"                            ║
// ║    }                                                                       ║
// ║                                                                           ║
// ║  Source de vérité : table `cp_app_version_config` (migration CODE-098)   ║
// ║  Pas d'auth requise — appelé avant login.                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
};

// Valeurs par défaut si la table n'est pas encore peuplée ou si DB down.
// À mettre à jour ici en dernier recours.
const DEFAULT_CONFIG: Record<
  string,
  { min_version: string; latest_version: string; store_url: string }
> = {
  android: {
    min_version: "1.0.0",
    latest_version: "1.0.0",
    store_url:
      "https://play.google.com/store/apps/details?id=fr.copiq.app",
  },
  ios: {
    min_version: "1.0.0",
    latest_version: "1.0.0",
    store_url: "https://apps.apple.com/app/copiq/id000000000",
  },
};

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return jsonResponse({ ok: true }, 200);
  }

  if (req.method !== "GET") {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  // ── Paramètre plateforme ────────────────────────────────────────────────
  const url = new URL(req.url);
  const platform = (url.searchParams.get("platform") ?? "android")
    .toLowerCase()
    .trim();

  if (!["android", "ios"].includes(platform)) {
    return jsonResponse(
      { error: "invalid_platform", hint: "Use ?platform=android or ?platform=ios" },
      400,
    );
  }

  // ── Tentative de lecture en base ────────────────────────────────────────
  const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
  const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  let config = DEFAULT_CONFIG[platform];
  let forceUpdate = false;
  let messageFr =
    "Une nouvelle version de COP'IQ est disponible. Mets à jour l'application pour continuer.";

  if (SUPABASE_URL && SERVICE_KEY) {
    try {
      const sb = createClient(SUPABASE_URL, SERVICE_KEY, {
        auth: { autoRefreshToken: false, persistSession: false },
      });

      const { data, error } = await sb
        .from("cp_app_version_config")
        .select(
          "min_version, latest_version, store_url, force_update, message_fr",
        )
        .eq("platform", platform)
        .maybeSingle();

      if (!error && data) {
        config = {
          min_version: data.min_version ?? config.min_version,
          latest_version: data.latest_version ?? config.latest_version,
          store_url: data.store_url ?? config.store_url,
        };
        forceUpdate = data.force_update ?? false;
        messageFr = data.message_fr ?? messageFr;
      }
    } catch (e) {
      // DB down → fallback sur les defaults. On log mais on répond 200.
      console.error("[app_minimum_version] db error:", e);
    }
  }

  return jsonResponse(
    {
      platform,
      min_version: config.min_version,
      latest_version: config.latest_version,
      force_update: forceUpdate,
      store_url: config.store_url,
      message_fr: messageFr,
      checked_at: new Date().toISOString(),
    },
    200,
  );
});

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
      "Cache-Control": "public, max-age=300", // cache 5 min côté client
    },
  });
}
