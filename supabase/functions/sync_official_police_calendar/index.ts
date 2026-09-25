import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SOURCES = [
  { track: "gpx", url: "https://www.police-nationale.interieur.gouv.fr/nous-rejoindre/dates-a-retenir-concours-gardien-de-paix" },
  { track: "pa", url: "https://www.police-nationale.interieur.gouv.fr/nous-rejoindre/dates-a-retenir-selections-policier-adjoint" },
] as const;

const entities: Record<string, string> = { amp: "&", nbsp: " ", eacute: "é", egrave: "è", ecirc: "ê", agrave: "à", rsquo: "’", laquo: "«", raquo: "»" };
const clean = (html: string) => html
  .replace(/<(script|style)[\s\S]*?<\/\1>/gi, " ")
  .replace(/<\/(h[1-6]|li|p|div|section|article)>/gi, "\n")
  .replace(/<br\s*\/?>/gi, "\n")
  .replace(/<[^>]+>/g, " ")
  .replace(/&(#x?[0-9a-f]+|[a-z]+);/gi, (_, key) => {
    if (key[0] === "#") return String.fromCodePoint(key[1].toLowerCase() === "x" ? parseInt(key.slice(2), 16) : parseInt(key.slice(1), 10));
    return entities[key.toLowerCase()] ?? " ";
  })
  .split("\n").map((line) => line.replace(/\s+/g, " ").trim()).filter(Boolean);

function typeOf(line: string) {
  const v = line.toLowerCase();
  if (v.includes("inscription")) return "registration";
  if (v.includes("écrit")) return "written";
  if (v.includes("sport")) return "sport";
  if (v.includes("oral") || v.includes("entretien")) return "oral";
  if (v.includes("résultat")) return "result";
  return "other";
}

function isoDate(raw?: string) {
  if (!raw) return null;
  const m = raw.match(/(\d{1,2})\/(\d{1,2})\/(20\d{2})/);
  return m ? `${m[3]}-${m[2].padStart(2, "0")}-${m[1].padStart(2, "0")}` : null;
}

async function digest(value: string) {
  const bytes = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return Array.from(new Uint8Array(bytes)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function parse(track: "gpx" | "pa", url: string, html: string) {
  const lines = clean(html);
  const rows: Record<string, unknown>[] = [];
  let session = track === "gpx" ? "Gardien de la paix" : "Policier adjoint";
  let region: string | null = null;
  for (const rawLine of lines) {
    const line = rawLine.replace(/^#{1,6}\s*/, "").replace(/^\*+\s*/, "").trim();
    if (/^(zone |outre-mer|départements et collectivités)/i.test(line)) region = line;
    if (/session|concours externe|concours interne|emplois réservés/i.test(line) && line.length < 180 && !/[•:]/.test(line)) session = line;
    if (!/(inscriptions?|écrits?|sport|oraux?|résultats?|entretien)/i.test(line)) continue;
    if (!/(\d{1,2}\/\d{1,2}\/20\d{2}|non renseign|à partir|du \d|le \d)/i.test(line)) continue;
    const dates = [...line.matchAll(/\d{1,2}\/\d{1,2}\/20\d{2}/g)].map((m) => m[0]);
    const fingerprint = await digest([track, session, region ?? "", typeOf(line), line].join("|"));
    rows.push({ track, session_label: session, region_label: region, event_type: typeOf(line), date_text: line, starts_on: isoDate(dates[0]), ends_on: isoDate(dates.at(-1)), source_url: url, source_fingerprint: fingerprint, is_provisional: true, is_active: true, last_seen_at: new Date().toISOString(), updated_at: new Date().toISOString() });
  }
  return [...new Map(rows.map((row) => [row.source_fingerprint as string, row])).values()];
}

function errorText(error: unknown) {
  if (error instanceof Error) return error.message;
  try { return JSON.stringify(error); } catch { return String(error); }
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });
  const supabase = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const body = await req.json().catch(() => ({}));
  const { data: config } = await supabase.from("official_calendar_sync_config").select("invocation_token").eq("singleton", true).single();
  if (!config || body.token !== config.invocation_token) return new Response("Forbidden", { status: 403 });
  const { data: run, error: runError } = await supabase.from("official_calendar_sync_runs").insert({ status: "running" }).select("id").single();
  if (runError) return Response.json({ error: runError.message }, { status: 500 });
  try {
    const sourceStatus: Record<string, unknown> = {};
    let total = 0;
    for (const source of SOURCES) {
      let response = await fetch(source.url, { headers: { "User-Agent": "Mozilla/5.0 COPIQ calendar monitor", "Accept-Language": "fr-FR,fr;q=0.9" } });
      let transport = "direct";
      if (!response.ok) {
        // The official site is protected by Cloudflare and can reject server
        // datacentres. Jina Reader is used only as a read-through transport;
        // every stored record still names and links the official source.
        response = await fetch(`https://r.jina.ai/http://${new URL(source.url).host}${new URL(source.url).pathname}`);
        transport = "reader_fallback";
      }
      if (!response.ok) throw new Error(`${source.track}: HTTP ${response.status}`);
      const rows = await parse(source.track, source.url, await response.text());
      const minimum = source.track === "gpx" ? 4 : 12;
      if (rows.length < minimum) throw new Error(`${source.track}: extraction insuffisante (${rows.length})`);
      await supabase.from("official_competition_events").update({ is_active: false, updated_at: new Date().toISOString() }).eq("track", source.track);
      const { error } = await supabase.from("official_competition_events").upsert(rows, { onConflict: "source_fingerprint" });
      if (error) throw error;
      total += rows.length;
      sourceStatus[source.track] = { ok: true, events: rows.length, url: source.url, transport };
    }
    await supabase.from("official_calendar_sync_runs").update({ status: "success", events_found: total, source_status: sourceStatus, finished_at: new Date().toISOString() }).eq("id", run.id);
    return Response.json({ ok: true, events: total, sources: sourceStatus });
  } catch (error) {
    const message = errorText(error);
    await supabase.from("official_calendar_sync_runs").update({ status: "failed", error_message: message, finished_at: new Date().toISOString() }).eq("id", run.id);
    return Response.json({ error: message }, { status: 500 });
  }
});
