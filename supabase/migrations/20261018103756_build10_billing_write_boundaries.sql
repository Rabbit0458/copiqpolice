create or replace function public.guard_subscription_server_write()
returns trigger language plpgsql security definer set search_path='' as $$
begin
  if auth.uid() is not null then
    if tg_table_name='store_entitlements' or not coalesce(public.has_admin_role('owner'),false) then
      raise exception 'Les achats sont geres par le serveur; les cadeaux par le fondateur' using errcode='42501';
    end if;
  end if;
  if tg_op='DELETE' then return old; else return new; end if;
end $$;
revoke all on function public.guard_subscription_server_write() from public,anon,authenticated;
create trigger guard_subscription_server_write before insert or update or delete on public.cas_pratique_subscriptions
for each row execute function public.guard_subscription_server_write();
create trigger guard_subscription_server_write before insert or update or delete on public.store_entitlements
for each row execute function public.guard_subscription_server_write();

do $$
declare f record; definition text;
begin
  for f in select oid from pg_proc where pronamespace='public'::regnamespace
    and proname in ('admin_grant_access','admin_revoke_access') loop
    definition:=pg_get_functiondef(f.oid);
    definition:=replace(definition,'and stripe_subscription_id is not null)',
      'and (stripe_subscription_id is not null or revenuecat_product_id is not null))');
    definition:=replace(definition,'Abonnement Stripe gere par son prestataire','Abonnement payant gere par son prestataire');
    execute definition;
  end loop;
  select pg_get_functiondef(oid) into definition from pg_proc
    where pronamespace='public'::regnamespace and proname='admin_subscription_sources';
  definition:=replace(definition,'''source'',e.store','''source'',upper(e.store)');
  definition:=replace(definition,'and s.stripe_subscription_id is null,false)',
    'and s.stripe_subscription_id is null and s.revenuecat_product_id is null,false)');
  definition:=replace(definition,'when s.stripe_subscription_id is null then ''MANUAL'' else ''STRIPE''',
    'when s.revenuecat_product_id is not null then upper(coalesce(s.store,''REVENUECAT'')) when s.stripe_subscription_id is null then ''MANUAL'' else ''STRIPE''');
  execute definition;
end $$;
