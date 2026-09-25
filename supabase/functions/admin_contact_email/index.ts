import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const LOGO_URL = "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png";
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

type CampaignType = "product_update" | "service_information" | "individual_message";
type AudienceKind = "all" | "individual";
type OwnerContext = { admin_id: string; auth_uid: string; email: string; role: string };
type CampaignInput = {
  campaign_type?: CampaignType;
  audience_kind?: AudienceKind;
  target_user_id?: string | null;
  subject?: string;
  headline?: string;
  body_text?: string;
  cta_label?: string | null;
  cta_url?: string | null;
};
type Delivery = {
  id: number;
  recipient_email: string;
  recipient_name: string | null;
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

function clean(value: unknown, max: number): string {
  return String(value ?? "").trim().slice(0, max);
}

function maskEmail(value: string): string {
  const [local, domain] = value.split("@");
  if (!local || !domain) return "Adresse indisponible";
  return `${local.slice(0, 2)}${"•".repeat(Math.min(5, Math.max(2, local.length - 2)))}@${domain}`;
}

function validateInput(raw: CampaignInput): Required<Omit<CampaignInput, "target_user_id" | "cta_label" | "cta_url">> & Pick<CampaignInput, "target_user_id" | "cta_label" | "cta_url"> {
  const campaignType = raw.campaign_type;
  const audienceKind = raw.audience_kind;
  const subject = clean(raw.subject, 160);
  const headline = clean(raw.headline, 180);
  const bodyText = clean(raw.body_text, 8000);
  const ctaLabel = clean(raw.cta_label, 48) || null;
  const ctaUrl = clean(raw.cta_url, 500) || null;
  const targetUserId = clean(raw.target_user_id, 80) || null;

  if (!campaignType || !["product_update", "service_information", "individual_message"].includes(campaignType)) {
    throw new Error("Type de message invalide.");
  }
  if (!audienceKind || !["all", "individual"].includes(audienceKind)) {
    throw new Error("Audience invalide.");
  }
  if (audienceKind === "individual" && !targetUserId) throw new Error("Choisissez un destinataire.");
  if (subject.length < 3) throw new Error("L’objet doit contenir au moins 3 caractères.");
  if (headline.length < 3) throw new Error("Le titre doit contenir au moins 3 caractères.");
  if (bodyText.length < 10) throw new Error("Le message doit contenir au moins 10 caractères.");
  if ((ctaLabel && !ctaUrl) || (!ctaLabel && ctaUrl)) throw new Error("Le libellé et le lien du bouton doivent être renseignés ensemble.");
  if (ctaUrl && !/^https:\/\//i.test(ctaUrl)) throw new Error("Le lien du bouton doit commencer par https://");

  return {
    campaign_type: campaignType,
    audience_kind: audienceKind,
    target_user_id: targetUserId,
    subject,
    headline,
    body_text: bodyText,
    cta_label: ctaLabel,
    cta_url: ctaUrl,
  };
}

function renderEmail(campaign: Record<string, unknown>, isTest = false): string {
  const body = escapeHtml(campaign.body_text).replace(/\r?\n/g, "<br />");
  const cta = campaign.cta_label && campaign.cta_url
    ? `<div style="margin:28px 0;text-align:center"><a href="${escapeHtml(campaign.cta_url)}" style="display:inline-block;padding:14px 24px;border-radius:14px;background:#155eef;color:#fff;font-weight:700;text-decoration:none">${escapeHtml(campaign.cta_label)}</a></div>`
    : "";
  const test = isTest
    ? '<div style="margin:0 0 18px;padding:10px 14px;border-radius:10px;background:#fff7ed;color:#9a3412;font-size:13px;font-weight:700">APERÇU TEST — aucun utilisateur n’a reçu ce message</div>'
    : "";
  return `<!doctype html><html lang="fr"><body style="margin:0;background:#f4f7fb;color:#111827;font-family:Arial,Helvetica,sans-serif"><div style="display:none;max-height:0;overflow:hidden">${escapeHtml(campaign.headline)}</div><div style="padding:28px 14px"><div style="max-width:640px;margin:auto;overflow:hidden;border:1px solid #e5e7eb;border-radius:24px;background:#fff;box-shadow:0 16px 48px rgba(15,23,42,.08)"><div style="height:5px;background:linear-gradient(90deg,#155eef 0 33%,#f8fafc 33% 66%,#ef4444 66%)"></div><div style="padding:30px 34px"><div style="text-align:center;margin-bottom:26px"><img src="${LOGO_URL}" width="142" alt="COP’IQ" style="display:inline-block;width:142px;max-width:52%;height:auto" /></div>${test}<p style="margin:0 0 10px;color:#155eef;font-size:12px;font-weight:800;letter-spacing:.12em;text-transform:uppercase">Information COP’IQ</p><h1 style="margin:0 0 22px;font-size:28px;line-height:1.2;letter-spacing:-.02em">${escapeHtml(campaign.headline)}</h1><p style="margin:0 0 18px;font-size:16px;line-height:1.7">Bonjour {{params.PRENOM}},</p><div style="font-size:16px;line-height:1.75;color:#374151">${body}</div>${cta}<p style="margin:28px 0 0;font-size:15px;line-height:1.6">L’équipe COP’IQ</p></div><div style="padding:18px 30px;background:#f8fafc;border-top:1px solid #e5e7eb;text-align:center;color:#64748b;font-size:12px;line-height:1.5">Message de service envoyé depuis COP’IQ · Merci de ne pas répondre à cet e-mail.</div></div></div></body></html>`;
}

async function listAllRecipients(serviceClient: ReturnType<typeof createClient>) {
  const rows: Record<string, unknown>[] = [];
  for (let offset = 0; ; offset += 500) {
    const { data, error } = await serviceClient.from("user_profiles")
      .select("user_id,email,first_name,last_name,username")
      .not("email", "is", null)
      .order("created_at", { ascending: true })
      .range(offset, offset + 499);
    if (error) throw new Error(`Chargement des destinataires impossible : ${error.message}`);
    rows.push(...(data ?? []));
    if ((data?.length ?? 0) < 500) break;
  }
  return rows.filter((row) => EMAIL_RE.test(String(row.email ?? "").trim()));
}

async function sendBrevo(campaign: Record<string, unknown>, recipients: Delivery[], idempotencyKey: string, isTest = false) {
  const brevoKey = Deno.env.get("BREVO_API_KEY");
  const senderEmail = Deno.env.get("BREVO_SENDER_EMAIL") ?? "no-reply@copiq.fr";
  if (!brevoKey) throw new Error("Configuration Brevo manquante.");
  const response = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: { "api-key": brevoKey, Accept: "application/json", "Content-Type": "application/json" },
    body: JSON.stringify({
      sender: { name: "COP’IQ", email: senderEmail },
      subject: isTest ? `[TEST] ${campaign.subject}` : campaign.subject,
      htmlContent: renderEmail(campaign, isTest),
      headers: { idempotencyKey },
      tags: [isTest ? "admin-contact-test" : "admin-contact"],
      messageVersions: recipients.map((recipient) => ({
        to: [{ email: recipient.recipient_email, name: recipient.recipient_name || undefined }],
        params: { PRENOM: recipient.recipient_name || "à vous" },
      })),
    }),
  });
  const providerBody = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(`Brevo a refusé l’envoi (${response.status}) : ${JSON.stringify(providerBody).slice(0, 600)}`);
  return providerBody as { messageId?: string; messageIds?: string[] };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: CORS_HEADERS });
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);

  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) return json({ error: "not_authenticated", message: "Session propriétaire requise." }, 401);
  const accessToken = authHeader.slice(7).trim();
  const url = Deno.env.get("SUPABASE_URL")!;
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const callerClient = createClient(url, anonKey, { global: { headers: { Authorization: authHeader } } });
  const serviceClient = createClient(url, serviceKey);

  const { data: { user }, error: userError } = await callerClient.auth.getUser(accessToken);
  if (userError || !user) return json({ error: "not_authenticated", message: "Session invalide ou expirée." }, 401);
  const { data: ownerData, error: ownerError } = await callerClient.rpc("admin_contact_owner_context");
  if (ownerError || !ownerData) return json({ error: "forbidden", message: ownerError?.message ?? "Accès propriétaire refusé." }, 403);
  const owner = ownerData as OwnerContext;

  let body: Record<string, unknown>;
  try { body = await req.json(); } catch { return json({ error: "invalid_json", message: "Requête invalide." }, 400); }
  const action = clean(body.action, 40);

  try {
    if (action === "overview") {
      const [{ count }, { data: campaigns, error }] = await Promise.all([
        serviceClient.from("user_profiles").select("user_id", { count: "exact", head: true }).not("email", "is", null),
        serviceClient.from("admin_email_campaigns")
          .select("id,campaign_type,audience_kind,target_user_id,subject,headline,body_text,cta_label,cta_url,status,recipient_count,submitted_count,failed_count,created_at,completed_at")
          .order("created_at", { ascending: false }).limit(30),
      ]);
      if (error) throw new Error(error.message);
      return json({ ok: true, emailable_count: count ?? 0, campaigns: campaigns ?? [], sender: "no-reply@copiq.fr" });
    }

    if (action === "search_users") {
      const query = clean(body.query, 80).replace(/[^\p{L}\p{N}@._' -]/gu, "");
      if (query.length < 2) return json({ ok: true, users: [] });
      const pattern = `%${query.replace(/[%_]/g, "")}%`;
      const { data, error } = await serviceClient.from("user_profiles")
        .select("user_id,email,first_name,last_name,username")
        .not("email", "is", null)
        .or(`email.ilike.${pattern},first_name.ilike.${pattern},last_name.ilike.${pattern},username.ilike.${pattern}`)
        .limit(8);
      if (error) throw new Error(error.message);
      return json({ ok: true, users: (data ?? []).map((row) => ({
        user_id: row.user_id, email: row.email,
        name: [row.first_name, row.last_name].filter(Boolean).join(" ") || row.username || "Utilisateur COP’IQ",
      })) });
    }

    if (action === "create_draft") {
      const input = validateInput(body.campaign as CampaignInput);
      let recipients: Record<string, unknown>[];
      if (input.audience_kind === "all") {
        recipients = await listAllRecipients(serviceClient);
      } else {
        const { data, error } = await serviceClient.from("user_profiles")
          .select("user_id,email,first_name,last_name,username")
          .eq("user_id", input.target_user_id!).maybeSingle();
        if (error || !data || !EMAIL_RE.test(String(data.email ?? ""))) throw new Error("Le destinataire sélectionné n’a pas d’adresse valide.");
        recipients = [data];
      }
      if (!recipients.length) throw new Error("Aucun destinataire joignable dans cette audience.");

      const { data: campaign, error: campaignError } = await serviceClient.from("admin_email_campaigns").insert({
        ...input, recipient_count: recipients.length, created_by: owner.auth_uid, created_by_email: owner.email,
      }).select("*").single();
      if (campaignError) throw new Error(campaignError.message);
      const deliveries = recipients.map((row) => ({
        campaign_id: campaign.id,
        user_id: row.user_id,
        recipient_email: String(row.email).trim().toLowerCase(),
        recipient_name: String(row.first_name || row.username || "").trim() || null,
      }));
      const { error: deliveryError } = await serviceClient.from("admin_email_deliveries").insert(deliveries);
      if (deliveryError) {
        await serviceClient.from("admin_email_campaigns").delete().eq("id", campaign.id);
        throw new Error(deliveryError.message);
      }
      await serviceClient.from("admin_audit_logs").insert({
        actor_admin_id: owner.admin_id, actor_auth_uid: owner.auth_uid, actor_email: owner.email, actor_role: owner.role,
        target_table: "admin_email_campaigns", target_id: campaign.id, action: "contact_email.draft_created",
        severity: "info", success: true, comment: "Brouillon de communication créé ; aucun e-mail envoyé.",
        meta: { audience_kind: input.audience_kind, recipient_count: recipients.length, campaign_type: input.campaign_type },
      });
      return json({ ok: true, campaign });
    }

    const campaignId = clean(body.campaign_id, 80);
    if (!campaignId) throw new Error("Campagne introuvable.");
    const { data: campaign, error: campaignError } = await serviceClient.from("admin_email_campaigns").select("*").eq("id", campaignId).maybeSingle();
    if (campaignError || !campaign) throw new Error("Campagne introuvable.");

    if (action === "send_test") {
      if (campaign.status !== "draft") throw new Error("Seul un brouillon peut être testé.");
      if (!EMAIL_RE.test(owner.email)) throw new Error("L’adresse du propriétaire est invalide.");
      await sendBrevo(campaign, [{ id: 0, recipient_email: owner.email, recipient_name: "Kaïs" }], crypto.randomUUID(), true);
      await serviceClient.from("admin_audit_logs").insert({
        actor_admin_id: owner.admin_id, actor_auth_uid: owner.auth_uid, actor_email: owner.email, actor_role: owner.role,
        target_table: "admin_email_campaigns", target_id: campaign.id, action: "contact_email.test_sent",
        severity: "info", success: true, comment: "E-mail test envoyé uniquement au propriétaire.", meta: {},
      });
      return json({ ok: true, sent_to: maskEmail(owner.email) });
    }

    if (action === "cancel") {
      if (campaign.status !== "draft") throw new Error("Cette campagne ne peut plus être annulée.");
      await serviceClient.from("admin_email_campaigns").update({ status: "cancelled", completed_at: new Date().toISOString() }).eq("id", campaign.id).eq("status", "draft");
      return json({ ok: true });
    }

    if (action === "launch") {
      if (campaign.status !== "draft") throw new Error("Cette campagne a déjà été lancée ou annulée.");
      const expected = `ENVOYER ${campaign.recipient_count}`;
      if (clean(body.confirmation, 80).toUpperCase() !== expected) throw new Error(`Saisissez exactement « ${expected} » pour confirmer.`);
      if (Number(body.confirmed_recipient_count) !== campaign.recipient_count) throw new Error("Le nombre de destinataires a changé. Rechargez l’aperçu.");

      const { data: claimed, error: claimError } = await serviceClient.from("admin_email_campaigns")
        .update({ status: "sending", started_at: new Date().toISOString(), last_error: null })
        .eq("id", campaign.id).eq("status", "draft").select("id").maybeSingle();
      if (claimError || !claimed) throw new Error("La campagne est déjà en cours ou a déjà été envoyée.");

      const { data: deliveries, error: deliveriesError } = await serviceClient.from("admin_email_deliveries")
        .select("id,recipient_email,recipient_name").eq("campaign_id", campaign.id).eq("status", "pending").order("id");
      if (deliveriesError || !deliveries?.length) throw new Error("Aucun destinataire en attente.");

      let submitted = 0;
      let failed = 0;
      let lastError: string | null = null;
      for (let offset = 0, batchNumber = 0; offset < deliveries.length; offset += 500, batchNumber += 1) {
        const batchRecipients = deliveries.slice(offset, offset + 500) as Delivery[];
        const { data: batch, error: batchError } = await serviceClient.from("admin_email_batches").upsert({
          campaign_id: campaign.id, batch_number: batchNumber, recipient_count: batchRecipients.length,
        }, { onConflict: "campaign_id,batch_number", ignoreDuplicates: true }).select("*").maybeSingle();
        let batchRow = batch;
        if (batchError || !batchRow) {
          const result = await serviceClient.from("admin_email_batches").select("*").eq("campaign_id", campaign.id).eq("batch_number", batchNumber).single();
          batchRow = result.data;
        }
        if (!batchRow) throw new Error("Impossible de préparer le lot d’envoi.");
        if (batchRow.status === "submitted") continue;
        try {
          const provider = await sendBrevo(campaign, batchRecipients, batchRow.id);
          await serviceClient.from("admin_email_batches").update({
            status: "submitted", provider_ids: provider.messageIds ?? (provider.messageId ? [provider.messageId] : []), submitted_at: new Date().toISOString(), error: null,
          }).eq("id", batchRow.id);
          await serviceClient.from("admin_email_deliveries").update({ status: "submitted", submitted_at: new Date().toISOString(), error: null })
            .in("id", batchRecipients.map((item) => item.id));
          submitted += batchRecipients.length;
        } catch (error) {
          lastError = error instanceof Error ? error.message : "Envoi refusé par le prestataire.";
          failed += batchRecipients.length;
          await serviceClient.from("admin_email_batches").update({ status: "failed", error: lastError.slice(0, 1000) }).eq("id", batchRow.id);
          await serviceClient.from("admin_email_deliveries").update({ status: "failed", error: lastError.slice(0, 1000) })
            .in("id", batchRecipients.map((item) => item.id));
        }
      }

      const status = failed === 0 ? "sent" : submitted === 0 ? "failed" : "partial";
      await serviceClient.from("admin_email_campaigns").update({
        status, submitted_count: submitted, failed_count: failed, last_error: lastError, completed_at: new Date().toISOString(),
      }).eq("id", campaign.id);
      await serviceClient.from("admin_audit_logs").insert({
        actor_admin_id: owner.admin_id, actor_auth_uid: owner.auth_uid, actor_email: owner.email, actor_role: owner.role,
        target_table: "admin_email_campaigns", target_id: campaign.id, action: "contact_email.launch",
        severity: failed ? "warning" : "info", success: submitted > 0,
        comment: "Communication remise au prestataire d’e-mail.",
        meta: { recipient_count: campaign.recipient_count, submitted_count: submitted, failed_count: failed },
      });
      return json({ ok: submitted > 0, status, submitted_count: submitted, failed_count: failed });
    }

    return json({ error: "unknown_action", message: "Action inconnue." }, 400);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Erreur inattendue.";
    return json({ error: "contact_email_failed", message }, 400);
  }
});
