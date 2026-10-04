-- Legacy setters must never grant Premium from a client request.
-- Native billing uses the verified RevenueCat webhook / apply_store_snapshot.
begin;
revoke execute on function public.set_subscription_tier(text) from public, anon, authenticated;
revoke execute on function public.set_user_subscription(uuid,text,text,timestamptz,text,text,text,boolean) from public, anon, authenticated;
grant execute on function public.set_subscription_tier(text) to service_role;
grant execute on function public.set_user_subscription(uuid,text,text,timestamptz,text,text,text,boolean) to service_role;
commit;
