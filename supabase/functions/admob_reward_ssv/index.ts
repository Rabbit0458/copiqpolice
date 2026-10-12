import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.0';
import { parseCallback, verifyCallback, rewardFromCallback } from './verify.mjs';

let keys: Array<{ keyId: number; pem: string }> = [];
let keysExpireAt = 0;

async function publicKey(keyId: string) {
  if (Date.now() >= keysExpireAt) {
    const response = await fetch('https://www.gstatic.com/admob/reward/verifier-keys.json', {
      signal: AbortSignal.timeout(5000),
    });
    if (!response.ok) throw new Error('key_service_unavailable');
    const data = await response.json();
    if (!Array.isArray(data.keys) || !data.keys.length) throw new Error('invalid_keys');
    keys = data.keys;
    keysExpireAt = Date.now() + 3600000;
  }
  return keys.find((key) => String(key.keyId) === keyId)?.pem;
}

// This public webhook authenticates Google's ECDSA signature, not a user JWT.
Deno.serve(async (req: Request) => {
  if (req.method !== 'GET') return new Response('Method not allowed', { status: 405 });
  let callback;
  try { callback = parseCallback(req.url); }
  catch { return new Response('Invalid callback', { status: 400 }); }
  try {
    let pem = await publicKey(callback.keyId);
    if (!pem) {
      keysExpireAt = 0;
      pem = await publicKey(callback.keyId);
    }
    if (!pem || !verifyCallback(callback, pem)) {
      return new Response('Invalid signature', { status: 403 });
    }
    let reward;
    try { reward = rewardFromCallback(callback); }
    catch { return new Response('Ignored'); }
    const admin = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { data, error } = await admin.rpc('grant_verified_reward', {
      p_challenge: reward.challenge, p_transaction: reward.transaction, p_ad_unit: reward.adUnit,
    });
    if (error) throw new Error('grant_failed');
    // Acknowledge signed but expired/unknown challenges without granting credit.
    // Retrying these cannot help; this also permits AdMob's URL validation probe.
    if (data?.allowed !== true) return new Response('Ignored');
    return new Response('OK');
  } catch {
    // Never log callbacks: they contain reward tokens and provider identifiers.
    return new Response('Verification unavailable', { status: 503 });
  }
});
