do $$
declare definition text;
begin
  select pg_get_functiondef(oid) into definition from pg_proc
    where pronamespace='public'::regnamespace and proname='admin_subscription_sources';
  definition:=replace(definition,'when s.user_id is null then',
    'when s.user_id is null or (s.tier=''free'' and s.stripe_subscription_id is null and s.revenuecat_product_id is null and s.status not in (''canceled'',''cancelled'')) then');
  definition:=replace(definition,'''status'',s.status,''expires_at''',
    '''status'',case when s.current_period_end<=now() then ''expired'' else s.status end,''expires_at''');
  definition:=replace(definition,'and jsonb_array_length(sources)>0)',
    'and exists(select 1 from jsonb_array_elements(sources) x where x->>''status'' in (''expired'',''revoked'',''canceled'',''cancelled'')))');
  execute definition;
end $$;
