// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Notifications business (Slack)                   ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-088             ║
// ║                                                                           ║
// ║  Drain la queue `cp_business_events_queue` et envoie sur Slack.           ║
// ║                                                                           ║
// ║  À déclencher via Supabase pg_cron toutes les 5 minutes :                 ║
// ║    select cron.schedule(                                                  ║
// ║      'cp_business_notify',                                                 ║
// ║      '*/5 * * * *',                                                        ║
// ║      $$ select net.http_post(                                              ║
// ║        url := 'https://<proj>.supabase.co/functions/v1/cas_pratique_business_notify',
// ║        headers := jsonb_build_object(                                     ║
// ║          'Authorization', 'Bearer <service_role_key>',                    ║
// ║          'Content-Type', 'application/json'                                ║
// ║        ),                                                                  ║
// ║        body := '{}'::jsonb                                                ║
// ║      ); $$                                                                 ║
// ║    );                                                                      ║
// ║                                                                           ║
// ║  Env vars requises :                                                       ║
// ║    SLACK_WEBHOOK_URL : https://hooks.slack.com/services/...               ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const SLACK_WEBHOOK_URL = Deno.env.get("SLACK_WEBHOOK_URL");

const adminClient = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

interface QueueEvent {
  id: string;
  event_kind: string;
  user_id: string | null;
  payload: Record<string, unknown>;
  created_at: string;
}

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function emojiFor(kind: string): string {
  switch (kind) {
    case "new_subscription":
      return "🎉";
    case "churned":
      return "😢";
    case "past_due":
      return "⚠️";
    default:
      return "📌";
  }
}

function formatSlackMessage(event: QueueEvent): Record<string, unknown> {
  const emoji = emojiFor(event.event_kind);
  let mainText = "";

  switch (event.event_kind) {
    case "new_subscription": {
      const tier = event.payload.tier ?? "premium";
      const priceId = event.payload.stripe_price_id ?? "unknown";
      mainText = `${emoji} *Nouveau premium* — tier *${tier}* (\`${priceId}\`)`;
      break;
    }
    case "churned": {
      const prev = event.payload.previous_tier ?? "premium";
      mainText = `${emoji} *Churn* — utilisateur a quitté (était *${prev}*)`;
      break;
    }
    case "past_due": {
      mainText = `${emoji} *Paiement en échec* — abonnement passé en past_due`;
      break;
    }
    default:
      mainText = `${emoji} Event \`${event.event_kind}\``;
  }

  return {
    blocks: [
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: mainText,
        },
      },
      {
        type: "context",
        elements: [
          {
            type: "mrkdwn",
            text: `User: \`${event.user_id ?? "?"}\` · ${event.created_at}`,
          },
        ],
      },
    ],
  };
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (!["POST", "GET"].includes(req.method)) {
    return jsonResponse({ error: "method_not_allowed" }, 405);
  }

  if (!SLACK_WEBHOOK_URL) {
    return jsonResponse(
      { error: "slack_webhook_not_configured" },
      500,
    );
  }

  // ── 1. Récup les events non traités ────────────────────────────────────
  const { data: events, error } = await adminClient
    .from("cp_business_events_queue")
    .select("id, event_kind, user_id, payload, created_at")
    .is("processed_at", null)
    .eq("notify_slack", true)
    .order("created_at", { ascending: true })
    .limit(50);

  if (error) {
    console.error("[business_notify] fetch error:", error);
    return jsonResponse({ error: "fetch_failed" }, 500);
  }

  if (!events || events.length === 0) {
    return jsonResponse({ processed: 0 }, 200);
  }

  let success = 0;
  const processedIds: string[] = [];
  const failedIds: string[] = [];

  // ── 2. Envoi sur Slack ─────────────────────────────────────────────────
  for (const ev of events as QueueEvent[]) {
    try {
      const message = formatSlackMessage(ev);
      const slackRes = await fetch(SLACK_WEBHOOK_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(message),
      });

      if (slackRes.ok) {
        processedIds.push(ev.id);
        success++;
      } else {
        const body = await slackRes.text();
        console.error(`[business_notify] slack ${slackRes.status}: ${body}`);
        failedIds.push(ev.id);
      }
    } catch (e) {
      console.error("[business_notify] send error:", e);
      failedIds.push(ev.id);
    }
  }

  // ── 3. Marque les events traités ───────────────────────────────────────
  if (processedIds.length > 0) {
    const { error: updErr } = await adminClient
      .from("cp_business_events_queue")
      .update({ processed_at: new Date().toISOString() })
      .in("id", processedIds);

    if (updErr) {
      console.error("[business_notify] update error:", updErr);
    }
  }

  return jsonResponse(
    {
      processed: success,
      failed: failedIds.length,
      total_seen: events.length,
    },
    200,
  );
});
