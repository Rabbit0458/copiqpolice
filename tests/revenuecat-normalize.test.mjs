import test from 'node:test';
import assert from 'node:assert/strict';
import { normalizeSubscriber, affectedUsers } from '../supabase/functions/cas_pratique_revenuecat_webhook/normalize.mjs';
const uid = '11111111-1111-4111-8111-111111111111';
const other = '22222222-2222-4222-8222-222222222222';
const date = '2026-09-25T00:00:00Z';
const body = (sub = {}, premium = {}) => ({ subscriber: {
  entitlements: { premium }, subscriptions: { 'fr.copiq.premium.monthly': {
    store: 'app_store', is_sandbox: false, expires_date: '2026-10-01T00:00:00Z', ...sub,
  } },
} });
test('cancellation retains access until expiration', () => {
  const [row] = normalizeSubscriber(body({unsubscribe_detected_at: date}), uid, date).entitlements;
  assert.equal(row.revoked, false); assert.equal(row.cancel_at_period_end, true);
  assert.equal(row.expires_at, '2026-10-01T00:00:00.000Z');
});
test('refund is revoked even with future expiry', () => {
  assert.equal(normalizeSubscriber(body({refunded_at: date}), uid, date).entitlements[0].revoked, true);
});
test('sandbox stays separate from production', () => {
  assert.equal(normalizeSubscriber(body({is_sandbox:true}), uid, date).entitlements[0].environment, 'SANDBOX');
});
test('grace period extends the verified expiration', () => {
  assert.equal(normalizeSubscriber(body({grace_period_expires_date:'2026-10-05T00:00:00Z'}), uid, date).entitlements[0].expires_at, '2026-10-05T00:00:00.000Z');
});
test('unknown products and unrelated entitlements cannot unlock premium', () => {
  const data=body(); data.subscriber.subscriptions={'unknown':Object.values(data.subscriber.subscriptions)[0]};
  assert.deepEqual(normalizeSubscriber(data,uid,date).entitlements,[]);
  assert.deepEqual(normalizeSubscriber(body({},null),uid,date).entitlements,[]);
});
test('malformed responses fail instead of clearing valid rights', () => {
  assert.throws(()=>normalizeSubscriber({},uid,date));
  assert.throws(()=>normalizeSubscriber(body({expires_date:null}),uid,date));
  assert.throws(()=>normalizeSubscriber(body({is_sandbox:null}),uid,date));
});
test('transfers resynchronize both accounts and ignore anonymous IDs', () => {
  assert.deepEqual(affectedUsers({type:'TRANSFER',transferred_from:[uid],transferred_to:[other,'$RCAnonymousID:test']}),[uid,other]);
});
test('merged authenticated aliases cannot grant one receipt to two accounts', () => {
  assert.throws(()=>affectedUsers({type:'RENEWAL',app_user_id:uid,aliases:[uid,other]}));
});
