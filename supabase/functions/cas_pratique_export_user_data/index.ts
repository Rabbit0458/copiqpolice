// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Edge Function : cas_pratique_export_user_data                 ║
// ║  Tâche : CODE-079 — RGPD Art. 20 (portabilité des données)              ║
// ║                                                                          ║
// ║  POST → retourne un JSON signé avec toutes les données CP du user.      ║
// ║  Pas de PII en dehors du JSON (le texte des réponses y est inclus       ║
// ║  car c'est précisément l'objet de l'export RGPD).                       ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
  });
}

function jsonDownload(data: unknown, filename: string): Response {
  return new Response(JSON.stringify(data, null, 2), {
    status: 200,
    headers: {
      ...CORS_HEADERS,
      "Content-Type": "application/json",
      "Content-Disposition": `attachment; filename="${filename}"`,
    },
  });
}

Deno.serve(async (req: Request) => {
  // Preflight
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: CORS_HEADERS });
  }

  if (req.method !== "POST") {
    return json({ error: "method_not_allowed" }, 405);
  }

  // ── Auth ───────────────────────────────────────────────────────────────
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return json({ error: "not_authenticated", message: "Token Bearer manquant." }, 401);
  }
  const userToken = authHeader.slice(7);

  const callerClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: `Bearer ${userToken}` } } },
  );

  const { data: { user }, error: userErr } = await callerClient.auth.getUser();
  if (userErr || !user) {
    return json({ error: "not_authenticated", message: "Session invalide ou expirée." }, 401);
  }

  // ── Service-role client (lecture de toutes les données) ────────────────
  const serviceClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  // ── Export via fonction SQL ─────────────────────────────────────────────
  const { data: exportData, error: exportErr } = await serviceClient.rpc(
    "fn_cp_export_user_data",
    { p_user_id: user.id },
  );

  if (exportErr) {
    console.error("[export_user_data] rpc error:", exportErr);
    return json(
      { error: "export_failed", message: "Impossible d'exporter vos données. Réessayez." },
      500,
    );
  }

  // Ajouter l'email du user à l'export (RGPD : le user veut ses données)
  const enrichedExport = {
    ...exportData,
    email: user.email ?? null,
    export_generated_by: "COP'IQ — app.copiq.fr",
    rgpd_contact: "privacy@copiq.fr",
  };

  const now = new Date().toISOString().slice(0, 10);
  const filename = `copiq_mes_donnees_${now}.json`;

  // Retourner le JSON en téléchargement direct
  return jsonDownload(enrichedExport, filename);
});
