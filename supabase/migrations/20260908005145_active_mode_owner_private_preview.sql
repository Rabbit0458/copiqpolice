begin;

-- La visibilité publique reste la source de vérité pour tous les utilisateurs.
-- Ce second état ouvre uniquement un aperçu privé au compte owner COP'IQ.
alter table public.active_mode_config
  add column if not exists owner_preview_enabled boolean not null default false;

create or replace function public.active_owner_preview_allowed()
returns boolean
language sql
stable
security definer
set search_path=''
as $$
  select (select auth.uid()) is not null
    and exists (
      select 1
      from public.admin_users admin
      where admin.auth_uid=(select auth.uid())
        and lower(admin.email)=lower('kaisouartani@gmail.com')
        and lower(admin.role)='owner'
        and coalesce(admin.disabled,false)=false
        and (admin.locked_until is null or admin.locked_until<=now())
        and (admin.expires_at is null or admin.expires_at>now())
    );
$$;

revoke all on function public.active_owner_preview_allowed() from public,anon,authenticated;

create or replace function public.active_mode_public_config()
returns jsonb
language plpgsql
stable
security definer
set search_path=public,auth
as $$
declare
  v_config public.active_mode_config;
  v_owner_preview_active boolean;
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED' using errcode='42501';
  end if;

  select * into v_config from public.active_mode_config where id=true;
  v_owner_preview_active := not coalesce(v_config.enabled,false)
    and coalesce(v_config.owner_preview_enabled,false)
    and public.active_owner_preview_allowed();

  return jsonb_build_object(
    'enabled',v_config.enabled,
    'available',v_config.enabled or v_owner_preview_active,
    'owner_preview_active',v_owner_preview_active,
    'revision',v_config.revision,
    'disable_message',v_config.disable_message,
    'countdown_seconds',v_config.countdown_seconds,
    'updated_at',v_config.updated_at
  );
end;
$$;

create or replace function public.active_user_guard(p_require_enabled boolean default true)
returns void
language plpgsql
security definer
set search_path=public,auth
as $$
declare
  v_enabled boolean;
  v_owner_preview_enabled boolean;
  v_owner_preview_active boolean;
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED' using errcode='42501';
  end if;

  select enabled,owner_preview_enabled
    into v_enabled,v_owner_preview_enabled
  from public.active_mode_config
  where id=true;

  v_owner_preview_active := not coalesce(v_enabled,false)
    and coalesce(v_owner_preview_enabled,false)
    and public.active_owner_preview_allowed();

  if p_require_enabled
    and not coalesce(v_enabled,false)
    and not v_owner_preview_active then
    raise exception 'ACTIVE_MODE_DISABLED' using errcode='42501';
  end if;

  if not v_owner_preview_active
    and not exists(
      select 1
      from public.active_access_verifications
      where user_id=auth.uid() and status='granted'
    ) then
    raise exception 'ACTIVE_ACCESS_REQUIRED' using errcode='42501';
  end if;

  if not exists(
    select 1
    from public.user_profiles
    where user_id=auth.uid() and user_mode='active' and user_track='gpx'
  ) then
    raise exception 'ACTIVE_GPX_PROFILE_REQUIRED' using errcode='42501';
  end if;
end;
$$;

create or replace function public.active_community_access()
returns boolean
language sql
stable
security definer
set search_path=''
as $$
  select (select auth.uid()) is not null
    and exists (
      select 1
      from public.user_profiles profile
      where profile.user_id=(select auth.uid())
        and profile.user_mode='active'
        and profile.user_track='gpx'
    )
    and (
      exists (
        select 1
        from public.active_access_verifications access
        where access.user_id=(select auth.uid()) and access.status='granted'
      )
      or (
        exists (
          select 1
          from public.active_mode_config config
          where config.id=true
            and not config.enabled
            and config.owner_preview_enabled
        )
        and public.active_owner_preview_allowed()
      )
    );
$$;

create or replace function public.admin_active_owner_preview_set(p_enabled boolean)
returns jsonb
language plpgsql
security definer
set search_path=public,auth
as $$
declare
  v_admin public.admin_users;
  v_old jsonb;
  v_new jsonb;
begin
  v_admin:=public.active_admin_guard();
  if lower(v_admin.role)<>'owner'
    or lower(v_admin.email)<>lower('kaisouartani@gmail.com') then
    raise exception 'OWNER_REQUIRED' using errcode='42501';
  end if;

  select to_jsonb(config) into v_old
  from public.active_mode_config config where id=true;

  update public.active_mode_config
  set owner_preview_enabled=p_enabled,
      revision=revision+1,
      updated_at=now(),
      updated_by=auth.uid()
  where id=true;

  select to_jsonb(config) into v_new
  from public.active_mode_config config where id=true;

  insert into public.admin_audit_logs(
    actor_admin_id,actor_auth_uid,actor_email,actor_role,
    target_table,target_id,action,severity,success,old_value,new_value,meta
  ) values (
    v_admin.id,auth.uid(),v_admin.email,v_admin.role,
    'active_mode_config','true','active_mode_owner_preview_toggle','info',true,
    v_old,v_new,jsonb_build_object('source','admin_panel','private_preview',true)
  );

  return v_new;
end;
$$;

revoke all on function public.admin_active_owner_preview_set(boolean) from public,anon;
grant execute on function public.admin_active_owner_preview_set(boolean) to authenticated;

comment on column public.active_mode_config.owner_preview_enabled is
  'Autorise uniquement le compte owner COP''IQ à prévisualiser le module lorsque la visibilité publique est désactivée.';
comment on function public.admin_active_owner_preview_set(boolean) is
  'Interrupteur owner + AAL2 distinct de la visibilité publique du module actif.';

commit;
