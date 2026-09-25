-- COP'IQ — Centre sécurisé de gestion des versions mobiles.
-- Toutes les écritures passent par des RPC owner + AAL2 et sont auditées.

alter table public.cp_app_version_config
  add column if not exists release_available boolean not null default false,
  add column if not exists available_build_number integer,
  add column if not exists availability_confirmed_at timestamptz,
  add column if not exists availability_confirmed_by uuid references auth.users(id);

alter table public.cp_app_version_config
  drop constraint if exists cp_app_version_available_build_check;
alter table public.cp_app_version_config
  add constraint cp_app_version_available_build_check
  check (available_build_number is null or available_build_number >= 0);

revoke insert, update, delete on table public.cp_app_version_config from public, anon, authenticated;

create or replace function public.admin_mobile_release_guard()
returns public.admin_users
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_admin public.admin_users;
begin
  select * into v_admin
  from public.admin_users a
  where a.auth_uid = auth.uid()
    and not a.disabled
    and (a.locked_until is null or a.locked_until <= now())
    and (a.expires_at is null or a.expires_at > now())
  limit 1;

  if v_admin.id is null then
    raise exception 'Accès refusé : compte administrateur actif requis.' using errcode = '42501';
  end if;
  if lower(v_admin.role) <> 'owner' then
    raise exception 'Accès refusé : seul le propriétaire peut piloter les versions mobiles.' using errcode = '42501';
  end if;
  if not public.admin_require_aal2() then
    raise exception 'Accès refusé : double authentification requise.' using errcode = '42501';
  end if;
  return v_admin;
end;
$$;

create or replace function public.admin_mobile_release_list()
returns setof public.cp_app_version_config
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform public.admin_mobile_release_guard();
  return query
    select c.* from public.cp_app_version_config c
    where c.platform in ('ios', 'android')
    order by c.platform;
end;
$$;

create or replace function public.admin_mobile_release_prepare(
  p_build integer,
  p_version text,
  p_message text,
  p_ios_url text,
  p_android_url text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_admin public.admin_users;
  v_before jsonb;
  v_after jsonb;
begin
  v_admin := public.admin_mobile_release_guard();
  if p_build is null or p_build < 1 then
    raise exception 'Le numéro de build doit être supérieur à zéro.';
  end if;
  if nullif(btrim(p_version), '') is null then
    raise exception 'La version publique est obligatoire.';
  end if;
  if nullif(btrim(p_message), '') is null then
    raise exception 'Le message de mise à jour est obligatoire.';
  end if;
  if nullif(btrim(p_ios_url), '') is null or not (btrim(p_ios_url) ~* '^(https://|itms-beta://)') then
    raise exception 'Une URL iOS valide est obligatoire.';
  end if;
  if nullif(btrim(p_android_url), '') is null or not (btrim(p_android_url) ~* '^https://') then
    raise exception 'Une URL Google Play HTTPS valide est obligatoire.';
  end if;
  if exists (
    select 1 from public.cp_app_version_config c
    where c.platform in ('ios','android') and p_build < c.min_build_number
  ) then
    raise exception 'Le build préparé ne peut pas être inférieur au build minimal déjà exigé.';
  end if;

  select jsonb_object_agg(c.platform, to_jsonb(c)) into v_before
  from public.cp_app_version_config c where c.platform in ('ios','android');

  update public.cp_app_version_config c
  set latest_version = btrim(p_version),
      latest_build_number = p_build,
      store_url = case c.platform when 'ios' then btrim(p_ios_url) else btrim(p_android_url) end,
      message = btrim(p_message),
      release_available = false,
      available_build_number = null,
      availability_confirmed_at = null,
      availability_confirmed_by = null,
      updated_at = now()
  where c.platform in ('ios','android');

  select jsonb_object_agg(c.platform, to_jsonb(c)) into v_after
  from public.cp_app_version_config c where c.platform in ('ios','android');

  insert into public.admin_audit_logs
    (actor_admin_id, actor_auth_uid, actor_email, actor_role, target_table,
     target_id, action, severity, success, old_value, new_value, comment, meta)
  values
    (v_admin.id, auth.uid(), v_admin.email, v_admin.role, 'cp_app_version_config',
     p_build::text, 'mobile_release.prepare', 'warning', true, v_before, v_after,
     'Préparation d’une version mobile depuis le panel administrateur.',
     jsonb_build_object('build', p_build, 'version', btrim(p_version)));

  return jsonb_build_object('ok', true, 'build', p_build, 'version', btrim(p_version));
end;
$$;

create or replace function public.admin_mobile_release_mark_available(
  p_platform text,
  p_build integer
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_admin public.admin_users;
  v_row public.cp_app_version_config;
  v_before jsonb;
begin
  v_admin := public.admin_mobile_release_guard();
  if p_platform not in ('ios','android') then
    raise exception 'Plateforme invalide.';
  end if;
  select * into v_row from public.cp_app_version_config c where c.platform = p_platform for update;
  if v_row.platform is null then raise exception 'Configuration de plateforme introuvable.'; end if;
  if p_build is distinct from v_row.latest_build_number then
    raise exception 'Le build confirmé (%) ne correspond pas au build préparé (%).', p_build, v_row.latest_build_number;
  end if;
  if nullif(btrim(v_row.store_url), '') is null
     or (p_platform = 'ios' and not (v_row.store_url ~* '^(https://|itms-beta://)'))
     or (p_platform = 'android' and not (v_row.store_url ~* '^https://')) then
    raise exception 'Impossible de confirmer : URL de téléchargement absente ou invalide.';
  end if;
  v_before := to_jsonb(v_row);

  update public.cp_app_version_config
  set release_available = true,
      available_build_number = p_build,
      availability_confirmed_at = now(),
      availability_confirmed_by = auth.uid(),
      updated_at = now()
  where platform = p_platform
  returning * into v_row;

  insert into public.admin_audit_logs
    (actor_admin_id, actor_auth_uid, actor_email, actor_role, target_table,
     target_id, action, severity, success, old_value, new_value, comment, meta)
  values
    (v_admin.id, auth.uid(), v_admin.email, v_admin.role, 'cp_app_version_config',
     p_platform, 'mobile_release.mark_available', 'warning', true, v_before, to_jsonb(v_row),
     'Disponibilité sur la boutique confirmée manuellement.',
     jsonb_build_object('platform', p_platform, 'build', p_build));

  return jsonb_build_object('ok', true, 'platform', p_platform, 'build', p_build);
end;
$$;

create or replace function public.admin_mobile_release_activate(p_build integer)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_admin public.admin_users;
  v_before jsonb;
  v_after jsonb;
  v_ready integer;
begin
  v_admin := public.admin_mobile_release_guard();
  select count(*) into v_ready
  from public.cp_app_version_config c
  where c.platform in ('ios','android')
    and c.latest_build_number = p_build
    and c.release_available
    and c.available_build_number = p_build
    and nullif(btrim(c.store_url), '') is not null
    and ((c.platform = 'ios' and c.store_url ~* '^(https://|itms-beta://)')
      or (c.platform = 'android' and c.store_url ~* '^https://'));

  if v_ready <> 2 then
    raise exception 'Activation refusée : le build % doit être marqué disponible sur iOS ET Android avec des URL valides.', p_build;
  end if;

  select jsonb_object_agg(c.platform, to_jsonb(c)) into v_before
  from public.cp_app_version_config c where c.platform in ('ios','android');

  update public.cp_app_version_config
  set min_version = latest_version,
      min_build_number = p_build,
      force_update = true,
      updated_at = now()
  where platform in ('ios','android') and latest_build_number = p_build;

  select jsonb_object_agg(c.platform, to_jsonb(c)) into v_after
  from public.cp_app_version_config c where c.platform in ('ios','android');

  insert into public.admin_audit_logs
    (actor_admin_id, actor_auth_uid, actor_email, actor_role, target_table,
     target_id, action, severity, success, old_value, new_value, comment, meta)
  values
    (v_admin.id, auth.uid(), v_admin.email, v_admin.role, 'cp_app_version_config',
     p_build::text, 'mobile_release.force_activate', 'critical', true, v_before, v_after,
     'Mise à jour obligatoire activée simultanément sur iOS et Android.',
     jsonb_build_object('build', p_build, 'platforms', jsonb_build_array('ios','android')));

  return jsonb_build_object('ok', true, 'build', p_build, 'forced', true);
end;
$$;

create or replace function public.admin_mobile_release_disable_force()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_admin public.admin_users;
  v_before jsonb;
  v_after jsonb;
begin
  v_admin := public.admin_mobile_release_guard();
  select jsonb_object_agg(c.platform, to_jsonb(c)) into v_before
  from public.cp_app_version_config c where c.platform in ('ios','android');
  update public.cp_app_version_config set force_update = false, updated_at = now()
  where platform in ('ios','android');
  select jsonb_object_agg(c.platform, to_jsonb(c)) into v_after
  from public.cp_app_version_config c where c.platform in ('ios','android');
  insert into public.admin_audit_logs
    (actor_admin_id, actor_auth_uid, actor_email, actor_role, target_table,
     target_id, action, severity, success, old_value, new_value, comment, meta)
  values
    (v_admin.id, auth.uid(), v_admin.email, v_admin.role, 'cp_app_version_config',
     'ios+android', 'mobile_release.force_disable', 'critical', true, v_before, v_after,
     'Blocage obligatoire désactivé en urgence.', '{}'::jsonb);
  return jsonb_build_object('ok', true, 'forced', false);
end;
$$;

revoke all on function public.admin_mobile_release_guard() from public, anon, authenticated;
revoke all on function public.admin_mobile_release_list() from public, anon;
revoke all on function public.admin_mobile_release_prepare(integer,text,text,text,text) from public, anon;
revoke all on function public.admin_mobile_release_mark_available(text,integer) from public, anon;
revoke all on function public.admin_mobile_release_activate(integer) from public, anon;
revoke all on function public.admin_mobile_release_disable_force() from public, anon;

grant execute on function public.admin_mobile_release_list() to authenticated;
grant execute on function public.admin_mobile_release_prepare(integer,text,text,text,text) to authenticated;
grant execute on function public.admin_mobile_release_mark_available(text,integer) to authenticated;
grant execute on function public.admin_mobile_release_activate(integer) to authenticated;
grant execute on function public.admin_mobile_release_disable_force() to authenticated;
grant execute on function public.admin_mobile_release_list() to service_role;
grant execute on function public.admin_mobile_release_prepare(integer,text,text,text,text) to service_role;
grant execute on function public.admin_mobile_release_mark_available(text,integer) to service_role;
grant execute on function public.admin_mobile_release_activate(integer) to service_role;
grant execute on function public.admin_mobile_release_disable_force() to service_role;

comment on function public.admin_mobile_release_activate(integer) is
  'Active atomiquement un build obligatoire uniquement s’il est disponible sur iOS et Android avec des URL valides.';
