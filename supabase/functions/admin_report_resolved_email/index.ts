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

function escapeHtml(value: unknown): string {
  return String(value ?? "").replace(/[&<>'"]/g, (char) => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", "'": "&#39;", '"': "&quot;",
  })[char]!);
}

function emailHtml(reference: string): string {
  return `<div style="font-family:Arial,Helvetica,sans-serif;line-height:1.6;color:#111827;max-width:620px;margin:auto">
    <div style="padding:24px;border:1px solid #e5e7eb;border-radius:16px">
      <div style="text-align:center;margin:4px 0 24px">
        <img src="https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png" width="150" alt="COP’IQ" style="display:inline-block;width:150px;max-width:55%;height:auto" />
      </div>
      <h1 style="margin:0 0 18px;font-size:22px;color:#155eef;text-align:center">Félicitations et merci pour votre contribution !</h1>
      <p>Bonjour,</p>
      <p><strong>Votre signalement a bien été traité</strong> et le problème vient d’être corrigé sur l’application COP’IQ.</p>
      <p style="padding:12px 16px;background:#f3f4f6;border-radius:10px"><strong>Référence du signalement :</strong> ${escapeHtml(reference)}</p>
      <p>Félicitations pour votre vigilance et merci d’avoir pris le temps de nous aider. Votre contribution améliore directement la qualité des questions proposées à toute la communauté COP’IQ.</p>
      <p style="padding:14px 16px;background:#eff6ff;border-left:4px solid #155eef;border-radius:8px;color:#1e3a8a"><strong>Grâce à vous, COP’IQ devient chaque jour plus fiable et plus utile.</strong></p>
      <p style="margin-top:24px">L’équipe COP’IQ</p>
    </div>
    <p style="font-size:12px;color:#6b7280;text-align:center">Cet email est envoyé automatiquement après le traitement de votre signalement.</p>
  </div>`;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: CORS_HEADERS });
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);

  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) return json({ error: "not_authenticated", message: "Session administrateur requise." }, 401);

  const url = Deno.env.get("SUPABASE_URL")!;
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const callerClient = createClient(url, anonKey, { global: { headers: { Authorization: authHeader } } });
  const serviceClient = createClient(url, serviceKey);

  const { data: { user }, error: userError } = await callerClient.auth.getUser();
  if (userError || !user) return json({ error: "not_authenticated", message: "Session invalide ou expirée." }, 401);

  let body: { kind?: string; id?: string; archive?: boolean; note?: string };
  try { body = await req.json(); } catch { return json({ error: "invalid_json" }, 400); }
  const kind = String(body.kind ?? "").trim();
  const id = String(body.id ?? "").trim();
  if (!kind || !id) return json({ error: "missing_fields", message: "kind et id sont requis." }, 400);

  // Ces deux RPC relaient le JWT de l'appelant et vérifient reports.read/reports.manage en base.
  const { data: inspection, error: inspectError } = await callerClient.rpc("admin_report_inspect", { p_kind: kind, p_id: id });
  if (inspectError) return json({ error: "forbidden", message: inspectError.message }, inspectError.code === "42501" ? 403 : 400);

  const { data: statusResult, error: statusError } = await callerClient.rpc("admin_report_set_status", {
    p_kind: kind, p_id: id, p_status: "resolved", p_archive: body.archive === true, p_note: body.note?.trim() || null,
  });
  if (statusError) return json({ error: "status_failed", message: statusError.message }, statusError.code === "42501" ? 403 : 400);

  const report = (inspection?.report ?? {}) as Record<string, unknown>;
  let recipient = String(report.email ?? "").trim().toLowerCase();
  const authUserId = String(report.user_id ?? report.user_uid ?? report.reporter_id ?? "").trim();
  if (!recipient && authUserId) {
    const { data } = await serviceClient.auth.admin.getUserById(authUserId);
    recipient = data.user?.email?.trim().toLowerCase() ?? "";
  }
  if (!recipient || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(recipient)) {
    return json({ ok: true, report: statusResult?.report, email_sent: false, email_reason: "missing_recipient" });
  }

  const normalizedKind = kind === "cg" ? "culture" : kind;
  const reference = `${normalizedKind.toUpperCase()}-${id}`;
  const { data: previous } = await serviceClient.from("admin_report_email_notifications")
    .select("id,status").eq("report_kind", normalizedKind).eq("report_id", id).eq("template", "resolved").maybeSingle();
  if (previous?.status === "sent") {
    return json({ ok: true, report: statusResult?.report, email_sent: true, already_sent: true });
  }

  const { data: logRow, error: logError } = await serviceClient.from("admin_report_email_notifications").upsert({
    report_kind: normalizedKind, report_id: id, recipient_email: recipient, template: "resolved",
    status: "pending", error: null, triggered_by: user.id,
  }, { onConflict: "report_kind,report_id,template" }).select("id").single();
  if (logError) return json({ ok: true, report: statusResult?.report, email_sent: false, email_reason: "log_failed" });

  const brevoKey = Deno.env.get("BREVO_API_KEY");
  const senderEmail = Deno.env.get("BREVO_SENDER_EMAIL") ?? "no-reply@copiq.fr";
  if (!brevoKey || !senderEmail) {
    await serviceClient.from("admin_report_email_notifications").update({ status: "failed", error: "Configuration email manquante" }).eq("id", logRow.id);
    return json({ ok: true, report: statusResult?.report, email_sent: false, email_reason: "email_not_configured" });
  }

  const response = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: { "api-key": brevoKey, Accept: "application/json", "Content-Type": "application/json" },
    body: JSON.stringify({
      sender: { name: "COP’IQ", email: senderEmail },
      to: [{ email: recipient }],
      subject: `COP’IQ — Signalement ${reference} traité`,
      htmlContent: emailHtml(reference),
    }),
  });
  const providerBody = await response.json().catch(() => ({}));
  if (!response.ok) {
    await serviceClient.from("admin_report_email_notifications").update({ status: "failed", error: JSON.stringify(providerBody).slice(0, 1000) }).eq("id", logRow.id);
    return json({ ok: true, report: statusResult?.report, email_sent: false, email_reason: "provider_failed" });
  }

  await serviceClient.from("admin_report_email_notifications").update({ status: "sent", provider_id: providerBody.id ?? null, sent_at: new Date().toISOString() }).eq("id", logRow.id);
  return json({ ok: true, report: statusResult?.report, email_sent: true, reference });
});
