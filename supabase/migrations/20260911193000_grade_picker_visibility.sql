-- Visibilité distante de la carte Réserviste dans le sélecteur de grade.
-- Masquée par défaut tant que le parcours n'est pas prêt.

create table if not exists public.grade_picker_config (
  id boolean primary key default true check (id = true),
  reserve_enabled boolean not null default false,
  revision integer not null default 1 check (revision > 0),
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id) on delete set null
);

insert into public.grade_picker_config (id, reserve_enabled)
values (true, false)
on conflict (id) do nothing;

alter table public.grade_picker_config enable row level security;
alter table public.grade_picker_config force row level security;
revoke all on public.grade_picker_config from public, anon, authenticated;

create or replace function public.grade_picker_public_config()
returns jsonb
language plpgsql
stable
security definer
set search_path=public,auth
as $$
declare v_config public.grade_picker_config;
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED' using errcode='42501';
  end if;
  select * into v_config from public.grade_picker_config where id=true;
  return jsonb_build_object(
    'reserve_enabled', coalesce(v_config.reserve_enabled, false),
    'revision', coalesce(v_config.revision, 1),
    'updated_at', v_config.updated_at
  );
end;
$$;

create or replace function public.admin_grade_picker_config_state()
returns jsonb
language plpgsql
security definer
set search_path=public,auth
as $$
declare v_admin public.admin_users;
begin
  v_admin := public.active_admin_guard();
  if lower(v_admin.role) <> 'owner' then
    raise exception 'OWNER_REQUIRED' using errcode='42501';
  end if;
  return (select to_jsonb(c) from public.grade_picker_config c where id=true);
end;
$$;

create or replace function public.admin_grade_picker_reserve_set(p_enabled boolean)
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
  v_admin := public.active_admin_guard();
  if lower(v_admin.role) <> 'owner'
    or lower(v_admin.email) <> lower('kaisouartani@gmail.com') then
    raise exception 'OWNER_REQUIRED' using errcode='42501';
  end if;

  select to_jsonb(c) into v_old
  from public.grade_picker_config c where id=true;

  update public.grade_picker_config
  set reserve_enabled = p_enabled,
      revision = revision + 1,
      updated_at = now(),
      updated_by = auth.uid()
  where id=true;

  select to_jsonb(c) into v_new
  from public.grade_picker_config c where id=true;

  insert into public.admin_audit_logs(
    actor_admin_id, actor_auth_uid, actor_email, actor_role,
    target_table, target_id, action, severity, success, old_value, new_value, meta
  ) values (
    v_admin.id, auth.uid(), v_admin.email, v_admin.role,
    'grade_picker_config', 'true', 'grade_picker_reserve_visibility', 'warning', true,
    v_old, v_new, jsonb_build_object('source','admin_panel')
  );

  return v_new;
end;
$$;

revoke all on function public.grade_picker_public_config() from public, anon;
grant execute on function public.grade_picker_public_config() to authenticated;
revoke all on function public.admin_grade_picker_config_state() from public, anon;
grant execute on function public.admin_grade_picker_config_state() to authenticated;
revoke all on function public.admin_grade_picker_reserve_set(boolean) from public, anon;
grant execute on function public.admin_grade_picker_reserve_set(boolean) to authenticated;

comment on table public.grade_picker_config is
  'Réglages distants du sélecteur de grade. La carte Réserviste est masquée par défaut.';
comment on function public.admin_grade_picker_reserve_set(boolean) is
  'Interrupteur propriétaire de la visibilité de la carte Réserviste dans tous les parcours.';
