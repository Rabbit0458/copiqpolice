import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0';
import { affectedUsers, normalizeSubscriber } from './normalize.mjs';

const json = (body: unknown, status = 200) => Response.json(body, { status });
const hash = async (value: string) => new Uint8Array(await crypto.subtle.digest('SHA-256', new TextEncoder().encode(value)));
async function equalSecret(a: string, b: string) {
  const [left, right] = await Promise.all([hash(a), hash(b)]);
  let different = 0;
  for (let i = 0; i < left.length; i++) different |= left[i] ^ right[i];
  return different === 0;
}

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') return json({ error: 'method_not_allowed' }, 405);
  const authorization = Deno.env.get('REVENUECAT_WEBHOOK_AUTH');
  const apiKey = Deno.env.get('REVENUECAT_SERVER_API_KEY');
  if (!authorization || !apiKey) return json({ error: 'webhook_not_configured' }, 503);
  if (!await equalSecret(req.headers.get('authorization') ?? '', authorization)) {
    return json({ error: 'unauthorized' }, 401);
  }
  const raw = await req.text();
  if (raw.length > 262144) return json({ error: 'payload_too_large' }, 413);
  let event;
  try { event = JSON.parse(raw).event; } catch { return json({ error: 'invalid_json' }, 400); }
  if (!event || typeof event.id !== 'string' || !event.id || event.id.length > 255 || typeof event.type !== 'string') {
    return json({ error: 'invalid_event' }, 400);
  }
  if (event.type === 'TEST') return json({ received: true, test: true });
  const allowedApps = (Deno.env.get('REVENUECAT_APP_IDS') ?? '').split(',').filter(Boolean);
  if (!allowedApps.length) return json({ error: 'apps_not_configured' }, 503);
  if (!allowedApps.includes(event.app_id)) return json({ error: 'unrecognized_app' }, 400);
  let users: string[];
  try { users = affectedUsers(event); }
  catch { return json({ error: 'multiple_account_aliases_require_review' }, 409); }
  if (!users.length) return json({ received: true, ignored: 'no_authenticated_user' });
  if (users.length > 20) return json({ error: 'too_many_aliases' }, 400);
  const admin = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  try {
    const { data: previous, error: lookupError } = await admin.from('store_sync_events').select('event_id').eq('event_id', event.id).maybeSingle();
    if (lookupError) throw new Error('event_lookup_failed');
    if (previous) return json({ received: true, duplicate: true });
    const snapshots = [];
    for (const userId of users) {
      const { data, error } = await admin.auth.admin.getUserById(userId);
      if (error && error.status !== 404) throw new Error('identity_lookup_failed');
      if (!data.user) continue; // Deleted accounts must never be recreated.
      const verifiedAt = new Date().toISOString();
      const response = await fetch(`https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(userId)}`, {
        headers: { Authorization: `Bearer ${apiKey}`, Accept: 'application/json' },
        signal: AbortSignal.timeout(10000),
      });
      if (!response.ok) throw new Error('provider_lookup_failed');
      snapshots.push(normalizeSubscriber(await response.json(), userId, verifiedAt));
    }
    const { error } = await admin.rpc('apply_store_snapshot', {
      p_event_id: event.id, p_event_type: event.type, p_snapshots: snapshots,
    });
    if (error) throw new Error('snapshot_transaction_failed');
    return json({ received: true });
  } catch (error) {
    // No payloads, credentials or customer identities in logs/responses.
    console.error('RevenueCat synchronization failed:', error instanceof Error ? error.message : 'unknown');
    return json({ error: 'synchronization_failed' }, 500);
  }
});
