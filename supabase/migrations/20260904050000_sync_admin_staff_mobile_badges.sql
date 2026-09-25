-- Synchronise les rôles du panel avec les badges publics/mobile.
-- L'autorisation reste contrôlée par les RPC/RLS dédiées : cette migration
-- n'utilise le rôle panel que pour l'identité publique et l'entitlement.

update public.admin_users a
set auth_uid = u.id,
    updated_at = now()
from auth.users u
where a.auth_uid is null
  and lower(a.email) = lower(u.email);

create or replace function public.create_admin_staff(
  p_email text,
  p_role text,
  p_auth_uid uuid default null,
  p_first_name text default null,
  p_last_name text default null,
  p_username text default null,
  p_permissions jsonb default null,
  p_second_factor_enabled boolean default true,
  p_disabled boolean default false,
  p_expires_at timestamptz default null,
  p_notes text default null
) returns jsonb
language plpgsql
security definer
set search_path to 'public', 'auth'
as $$
declare
  v_actor public.admin_users;
  v_role text;
  v_email text;
  v_perms jsonb;
  v_id uuid;
  v_auth_uid uuid;
begin
  v_actor := public.current_admin();
  if v_actor.id is null or lower(v_actor.role) <> 'owner' then
    perform public.audit_log_write(
      'create_staff','warning',false,'admin_users',null,null,null,
      jsonb_build_object('attempted_role',p_role,'email',p_email),
      'Tentative refusée — owner requis'
    );
    raise exception 'Accès refusé : seul un owner peut créer un staff.'
      using errcode='42501';
  end if;

  v_role := lower(coalesce(p_role,''));
  if v_role not in ('admin','moderator','helper') then
    raise exception 'Rôle invalide.' using errcode='22023';
  end if;

  v_email := lower(trim(coalesce(p_email,'')));
  if v_email = '' or position('@' in v_email) = 0 then
    raise exception 'Email invalide.' using errcode='22023';
  end if;
  if exists(select 1 from public.admin_users where lower(email)=v_email) then
    raise exception 'Un staff avec cet email existe déjà.' using errcode='23505';
  end if;

  v_auth_uid := coalesce(
    p_auth_uid,
    (select u.id from auth.users u where lower(u.email)=v_email limit 1)
  );
  v_perms := coalesce(p_permissions, public.admin_default_permissions(v_role));

  insert into public.admin_users(
    email, role, auth_uid, first_name, last_name, username,
    disabled, second_factor_enabled, permissions,
    expires_at, notes, created_by, password_hash
  ) values (
    v_email, v_role, v_auth_uid, p_first_name, p_last_name, p_username,
    coalesce(p_disabled,false), coalesce(p_second_factor_enabled,true), v_perms,
    p_expires_at, p_notes, v_actor.id, ''
  ) returning id into v_id;

  perform public.audit_log_write(
    'create_staff','info',true,'admin_users',v_id::text,v_auth_uid,null,
    jsonb_build_object(
      'email',v_email,'role',v_role,'permissions',v_perms,
      'second_factor_enabled',coalesce(p_second_factor_enabled,true),
      'disabled',coalesce(p_disabled,false),'expires_at',p_expires_at,
      'mobile_account_linked',v_auth_uid is not null
    ),
    p_notes
  );

  return jsonb_build_object(
    'ok',true,'id',v_id,'email',v_email,'role',v_role,
    'auth_uid',v_auth_uid,'mobile_account_linked',v_auth_uid is not null
  );
end;
$$;

create or replace function public.get_public_profile_badges(p_user_ids uuid[])
returns table(
  user_id uuid,
  username text,
  avatar_index integer,
  role text,
  quiz_attempts_count integer,
  badge_type text
)
language sql
stable
security definer
set search_path to 'public'
as $$
  select
    p.user_id,
    p.username,
    p.avatar_index,
    effective.role,
    public.count_quiz_attempts(p.user_id) as quiz_attempts_count,
    public.compute_badge_type(
      effective.role::public.user_role,
      public.count_quiz_attempts(p.user_id)
    ) as badge_type
  from public.user_profiles p
  cross join lateral (
    select coalesce(
      (
        select case lower(a.role)
          when 'owner' then 'owner'
          when 'superadmin' then 'admin'
          when 'admin' then 'admin'
          when 'moderator' then 'moderator'
          else null
        end
        from public.admin_users a
        where a.auth_uid = p.user_id
          and not a.disabled
          and (a.expires_at is null or a.expires_at > now())
        order by case lower(a.role)
          when 'owner' then 1 when 'superadmin' then 2
          when 'admin' then 3 when 'moderator' then 4 else 5 end
        limit 1
      ),
      p.role::text,
      'user'
    ) as role
  ) effective
  where p.user_id = any(p_user_ids);
$$;

revoke all on function public.get_public_profile_badges(uuid[]) from public, anon;
grant execute on function public.get_public_profile_badges(uuid[]) to authenticated;

create or replace function public.get_my_entitlement()
returns json
language plpgsql
stable
security definer
set search_path to 'public'
as $$
declare
  v_uid uuid := auth.uid();
  v_role text;
  v_plan text;
  v_status text;
  v_valid_until timestamptz;
  v_cancel_at_period_end boolean;
  v_used integer;
  v_resets_at timestamptz;
  v_premium boolean;
  v_quiz_count integer;
begin
  if v_uid is null then
    return json_build_object('authenticated', false);
  end if;

  select coalesce(
    (
      select case lower(a.role)
        when 'owner' then 'owner'
        when 'superadmin' then 'admin'
        when 'admin' then 'admin'
        when 'moderator' then 'moderator'
        else null
      end
      from public.admin_users a
      where a.auth_uid = v_uid
        and not a.disabled
        and (a.expires_at is null or a.expires_at > now())
      order by case lower(a.role)
        when 'owner' then 1 when 'superadmin' then 2
        when 'admin' then 3 when 'moderator' then 4 else 5 end
      limit 1
    ),
    p.role::text,
    'user'
  ) into v_role
  from public.user_profiles p
  where p.user_id = v_uid;

  v_role := coalesce(v_role, 'user');

  select plan::text, status::text, valid_until, cancel_at_period_end
  into v_plan, v_status, v_valid_until, v_cancel_at_period_end
  from public.subscription_payement
  where user_id = v_uid
  order by updated_at desc
  limit 1;

  v_premium := public.is_user_premium(v_uid);

  select used, window_start + interval '7 days'
  into v_used, v_resets_at
  from public.free_weekly_usage
  where user_id = v_uid;

  v_quiz_count := public.count_quiz_attempts(v_uid);

  return json_build_object(
    'authenticated', true,
    'user_id', v_uid,
    'role', v_role,
    'is_owner', (v_role = 'owner'),
    'is_admin', (v_role in ('owner','admin')),
    'premium', v_premium,
    'plan', coalesce(v_plan, 'free'),
    'status', coalesce(v_status, 'active'),
    'valid_until', v_valid_until,
    'cancel_at_period_end', coalesce(v_cancel_at_period_end, false),
    'free_used', coalesce(v_used, 0),
    'free_limit', 10,
    'free_remaining', greatest(0, 10 - coalesce(v_used, 0)),
    'free_resets_at', v_resets_at,
    'quiz_attempts_count', v_quiz_count,
    'badge_type', public.compute_badge_type(
      v_role::public.user_role,
      v_quiz_count
    )
  );
end;
$$;

revoke all on function public.get_my_entitlement() from public, anon;
grant execute on function public.get_my_entitlement() to authenticated;

