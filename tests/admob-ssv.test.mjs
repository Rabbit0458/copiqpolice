import test from 'node:test';
import assert from 'node:assert/strict';
import { generateKeyPairSync, sign } from 'node:crypto';
import { parseCallback, verifyCallback, rewardFromCallback } from '../supabase/functions/admob_reward_ssv/verify.mjs';

const { publicKey, privateKey } = generateKeyPairSync('ec', { namedCurve: 'prime256v1' });
const pem = publicKey.export({ type: 'spki', format: 'pem' });
const content = 'ad_unit=3779020910&custom_data=12345678-1234-1234-1234-123456789abc&reward_amount=1&reward_item=access&timestamp=' + Date.now() + '&transaction_id=abcdef1234567890';
const signature = sign('sha256', Buffer.from(content), privateKey).toString('base64url');
const url = 'https://example.invalid/ssv?' + content + '&signature=' + signature + '&key_id=123';

test('valid DER ECDSA signature verifies against exact query bytes', () => {
  const callback = parseCallback(url);
  assert.equal(verifyCallback(callback, pem), true);
  assert.equal(rewardFromCallback(callback).challenge, '12345678-1234-1234-1234-123456789abc');
});
test('tampered amount fails signature verification', () => {
  assert.equal(verifyCallback(parseCallback(url.replace('reward_amount=1', 'reward_amount=2')), pem), false);
});
test('untrusted key cannot validate callback', () => {
  const other = generateKeyPairSync('ec', { namedCurve: 'prime256v1' });
  assert.equal(verifyCallback(parseCallback(url), other.publicKey.export({ type: 'spki', format: 'pem' })), false);
});
test('duplicate parameters and unsigned appended data are rejected', () => {
  assert.throws(() => parseCallback(url.replace('ad_unit=', 'custom_data=x&ad_unit=')));
  assert.throws(() => parseCallback(url + '&custom_data=forged'));
});
test('missing signature, invalid unit and forged challenge are rejected', () => {
  assert.throws(() => parseCallback('https://example.invalid/ssv?' + content));
  assert.throws(() => rewardFromCallback(parseCallback(url.replace('3779020910', '1234567890'))));
  assert.throws(() => rewardFromCallback(parseCallback(url.replace('12345678-1234-1234-1234-123456789abc', 'forged'))));
});

test('percent-encoded signature padding is accepted without altering signed content', () => {
  const padded = sign('sha256', Buffer.from(content), privateKey).toString('base64url') + '=';
  const encodedUrl = 'https://example.invalid/?' + content + '&signature=' + encodeURIComponent(padded) + '&key_id=123';
  assert.equal(verifyCallback(parseCallback(encodedUrl), pem), true);
});

test('percent-encoded reward text matches the Google URI.getQuery reference', () => {
  const encoded = content.replace('reward_item=access', 'reward_item=acc%C3%A8s%20quiz');
  const sig = sign('sha256', Buffer.from(decodeURIComponent(encoded)), privateKey).toString('base64url');
  assert.equal(verifyCallback(parseCallback('https://example.invalid/?' + encoded + '&signature=' + sig + '&key_id=123'), pem), true);
});

test('AdMob form-encoded plus spaces verify without reordering parameters', () => {
  const encoded = content.replace('reward_item=access', 'reward_item=quiz+d%C3%A9bloqu%C3%A9');
  const sig = sign('sha256', Buffer.from(decodeURIComponent(encoded.replaceAll('+', ' '))), privateKey).toString('base64url');
  assert.equal(verifyCallback(parseCallback('https://example.invalid/?' + encoded + '&signature=' + sig + '&key_id=123'), pem), true);
});
