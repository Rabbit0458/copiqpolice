// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Edge Function : admin_delete_user_account                     ║
// ║  Suppression complète d'un compte TIERS par un administrateur owner.    ║
// ║                                                                          ║
// ║  Contrairement à cas_pratique_delete_user_data (RGPD auto-service, un   ║
// ║  utilisateur supprime SON PROPRE compte), cette fonction est réservée   ║
// ║  au panel admin : un owner supprime le compte d'un TIERS.               ║
// ║                                                                          ║
// ║  Sécurité :                                                              ║
// ║    • Le rôle (owner strict), le compte cible n'étant pas lui-même staff,║
// ║      et la confirmation par email exact sont TOUS vérifiés côté base   ║
// ║      par la RPC `admin_delete_user_data_completely` (SECURITY DEFINER). ║
// ║      Cette edge function n'accorde donc aucun droit : elle relaie le    ║
// ║      token de l'appelant tel quel vers PostgREST pour cet appel.        ║
// ║    • La clé service_role n'est utilisée QUE pour l'étape finale         ║
// ║      (auth.admin.deleteUser), jamais pour la vérification de droits.    ║
// ║                                                                          ║
// ║  POST { target_user_id: uuid, confirm_email: string }                   ║
// ║    → supprime toutes les données applicatives (RPC), puis le compte     ║
// ║      Auth (API admin GoTrue officielle), retourne le rapport.           ║
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

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: CORS_HEADERS });
  }
  if (req.method !== "POST") {
    return json({ error: "method_not_allowed" }, 405);
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return json({ error: "not_authenticated", message: "Token Bearer manquant." }, 401);
  }
  const callerToken = authHeader.slice(7);

  // Client "appelant" : porte le JWT de l'admin, jamais la clé service_role.
  // La RPC ci-dessous revalide elle-même le rôle owner en base.
  const callerClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: `Bearer ${callerToken}` } } },
  );

  const { data: { user: caller }, error: callerErr } = await callerClient.auth.getUser();
  if (callerErr || !caller) {
    return json({ error: "not_authenticated", message: "Session invalide ou expirée." }, 401);
  }

  let body: { target_user_id?: string; confirm_email?: string } = {};
  try {
    body = await req.json();
  } catch {
    return json({ error: "invalid_json" }, 400);
  }

  const targetUserId = (body.target_user_id ?? "").trim();
  const confirmEmail = (body.confirm_email ?? "").trim();
  if (!targetUserId || !confirmEmail) {
    return json(
      { error: "missing_fields", message: "target_user_id et confirm_email sont requis." },
      400,
    );
  }
  if (targetUserId === caller.id) {
    return json(
      { error: "cannot_self_delete", message: "Utilisez le mécanisme de suppression de compte personnel." },
      400,
    );
  }

  // Étape 1 — nettoyage des données applicatives. La RPC vérifie owner,
  // refuse une cible staff, et exige l'email exact. Toute erreur (droits,
  // confirmation, contrainte non résolue) arrête tout ici : rien n'est
  // supprimé côté Auth si cette étape échoue.
  const { data: dataReport, error: dataErr } = await callerClient.rpc(
    "admin_delete_user_data_completely",
    { p_user_id: targetUserId, p_confirm_email: confirmEmail },
  );

  if (dataErr) {
    console.error("[admin_delete_user_account] data cleanup error:", dataErr);
    return json(
      {
        error: "deletion_failed",
        message: dataErr.message ?? "Suppression des données échouée.",
      },
      dataErr.code === "42501" ? 403 : 400,
    );
  }

  // Étape 2 — suppression du compte Auth via l'API admin officielle
  // (gère proprement identities, sessions, refresh tokens internes à auth.*).
  const serviceClient = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const { error: authDeleteErr } = await serviceClient.auth.admin.deleteUser(targetUserId);
  if (authDeleteErr) {
    console.error("[admin_delete_user_account] auth.admin.deleteUser error:", authDeleteErr);
    return json({
      success: true,
      partial: true,
      message:
        "Les données applicatives ont été supprimées, mais la suppression du compte Auth a échoué. Contactez le support technique.",
      report: dataReport,
    });
  }

  return json({
    success: true,
    partial: false,
    message: "Compte et données définitivement supprimés.",
    report: dataReport,
  });
});
