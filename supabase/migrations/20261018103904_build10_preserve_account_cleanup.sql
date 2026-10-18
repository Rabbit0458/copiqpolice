-- Preserve owner account deletion and FK cascades; clients still have no DELETE grant.
drop trigger guard_subscription_server_write on public.store_entitlements;
create trigger guard_subscription_server_write before insert or update on public.store_entitlements
for each row execute function public.guard_subscription_server_write();
