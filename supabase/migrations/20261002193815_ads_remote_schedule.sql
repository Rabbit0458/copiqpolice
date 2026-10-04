alter table public.app_runtime_config
  add column ads_enabled boolean not null default true,
  add column ads_interval_minutes integer not null default 20 check (ads_interval_minutes between 5 and 1440),
  add column ads_starts_at timestamptz,
  add column ads_ends_at timestamptz,
  add constraint ads_schedule_valid check (ads_ends_at is null or ads_starts_at is null or ads_ends_at > ads_starts_at);

-- Existing public read policy exposes only non-secret runtime configuration.
-- Writes remain available only through the owner + MFA guarded function.
create or replace function public.admin_ads_config_set(
  p_enabled boolean, p_interval_minutes integer,
  p_starts_at timestamptz, p_ends_at timestamptz
) returns public.app_runtime_config
language plpgsql security definer set search_path = ''
as $$
declare
  v_admin public.admin_users;
  v_old jsonb;
  v_new public.app_runtime_config;
begin
  if auth.uid() is null then raise exception 'AUTH_REQUIRED' using errcode='42501'; end if;
  v_admin := public.active_admin_guard();
  if lower(v_admin.role) <> 'owner' then
    raise exception 'OWNER_REQUIRED' using errcode='42501';
  end if;
  if p_enabled is null or p_interval_minutes is null or p_interval_minutes not between 5 and 1440
     or (p_starts_at is not null and p_ends_at is not null and p_ends_at <= p_starts_at) then
    raise exception 'INVALID_AD_SCHEDULE' using errcode='22023';
  end if;
  select to_jsonb(c) into v_old from public.app_runtime_config c where id=1 for update;
  update public.app_runtime_config set ads_enabled=p_enabled,
    ads_interval_minutes=p_interval_minutes, ads_starts_at=p_starts_at,
    ads_ends_at=p_ends_at, updated_at=now(), updated_by=auth.uid()
  where id=1 returning * into v_new;
  insert into public.admin_audit_logs(
    actor_admin_id,actor_auth_uid,actor_email,actor_role,target_table,target_id,
    action,severity,success,old_value,new_value,meta)
  values(v_admin.id,auth.uid(),v_admin.email,v_admin.role,'app_runtime_config','1',
    'ads_schedule_update','info',true,v_old,to_jsonb(v_new),'{"source":"admin_panel"}'::jsonb);
  return v_new;
end;
$$;
revoke all on function public.admin_ads_config_set(boolean,integer,timestamptz,timestamptz) from public,anon;
grant execute on function public.admin_ads_config_set(boolean,integer,timestamptz,timestamptz) to authenticated;
