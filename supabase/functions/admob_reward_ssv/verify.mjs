import { verify } from 'node:crypto';
import { Buffer } from 'node:buffer';

export function parseCallback(rawUrl) {
  if (rawUrl.length > 8192) throw new Error('invalid_callback');
  const url = new URL(rawUrl);
  const query = url.search.slice(1);
  const match = /^(.*)&signature=([^&]+)&key_id=(\d+)$/.exec(query);
  if (!match) throw new Error('invalid_callback');
  const params = new URLSearchParams(match[1]);
  const names = [...params.keys()];
  if (new Set(names).size !== names.length || params.has('signature') || params.has('key_id')) {
    throw new Error('duplicate_parameter');
  }
  const signature = new URLSearchParams('signature=' + match[2]).get('signature');
  if (!signature || !/^[A-Za-z0-9_-]+={0,2}$/.test(signature)) throw new Error('invalid_signature');
  return { content: match[1], signature, keyId: match[3], params };
}

export function rewardFromCallback(callback) {
  const params = callback.params;
  const challenge = params.get('custom_data') ?? '';
  const transaction = params.get('transaction_id') ?? '';
  const adUnit = (params.get('ad_unit') ?? '').split('/').pop();
  const timestamp = Number(params.get('timestamp'));
  if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(challenge) ||
      !/^[A-Za-z0-9_-]{8,256}$/.test(transaction) ||
      !['3779020910', '5012211534'].includes(adUnit) ||
      !(Number(params.get('reward_amount')) > 0) || !Number.isFinite(timestamp) ||
      timestamp <= 0 || timestamp > Date.now() + 300000) {
    throw new Error('invalid_reward');
  }
  return { challenge, transaction, adUnit };
}

export function verifyCallback(callback, pem) {
  // Google signs the decoded form query; preserve its original parameter order.
  const content = decodeURIComponent(callback.content.replaceAll('+', ' '));
  return verify('sha256', Buffer.from(content, 'utf8'),
    { key: pem, dsaEncoding: 'der' }, Buffer.from(callback.signature, 'base64url'));
}
