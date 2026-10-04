const plans = new Map([
  ['fr.copiq.premium.monthly', 'month'], ['fr.copiq.premium.yearly', 'year'],
  ['copiq_premium_monthly', 'month'], ['copiq_premium_yearly', 'year'],
]);
export const isUserId = value => typeof value === 'string' &&
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value);

// The current REST snapshot, not the event type, determines access. This covers
// refunds, grace periods, transfers and delayed cancellation notifications.
export function normalizeSubscriber(body, userId, verifiedAt) {
  if (!isUserId(userId) || !body?.subscriber || !Number.isFinite(Date.parse(verifiedAt))) {
    throw new Error('invalid_subscriber');
  }
  const subscriber = body.subscriber;
  if (!subscriber.subscriptions || typeof subscriber.subscriptions !== 'object' ||
      !subscriber.entitlements || typeof subscriber.entitlements !== 'object') {
    throw new Error('incomplete_subscriber');
  }
  const entitlements = [];
  if (subscriber.entitlements.premium) {
    for (const [productId, sub] of Object.entries(subscriber.subscriptions)) {
      const plan = plans.get(productId.split(':')[0]);
      if (!plan || !['app_store', 'play_store'].includes(sub.store)) continue;
      if (typeof sub.is_sandbox !== 'boolean') throw new Error('missing_environment');
      const expiry = Date.parse(sub.expires_date);
      if (!Number.isFinite(expiry)) throw new Error('missing_expiration');
      const grace = Date.parse(sub.grace_period_expires_date);
      entitlements.push({
        environment: sub.is_sandbox ? 'SANDBOX' : 'PRODUCTION',
        product_id: productId, store: sub.store, plan,
        expires_at: new Date(Number.isFinite(grace) ? Math.max(expiry, grace) : expiry).toISOString(),
        revoked: sub.refunded_at != null,
        cancel_at_period_end: sub.unsubscribe_detected_at != null,
      });
    }
  }
  return { user_id: userId, verified_at: verifiedAt, entitlements };
}

export function affectedUsers(event) {
  const values = event.type === 'TRANSFER'
    ? [...(event.transferred_from ?? []), ...(event.transferred_to ?? [])]
    : [event.app_user_id, event.original_app_user_id, ...(event.aliases ?? [])];
  const users = [...new Set(values.filter(isUserId))].sort();
  if (event.type !== 'TRANSFER' && users.length > 1) {
    throw new Error('multiple_account_aliases_require_review');
  }
  return users;
}
