-- Aggregated diagnostics for the owner. Logged errors are not necessarily crashes.
create or replace function public.admin_quality_analytics(p_days integer default 30)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, auth
as $$
declare
  v_start timestamptz;
  v_result jsonb;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  if p_days is null or p_days not in (7, 30, 90) then
    raise exception 'Période invalide.' using errcode = '22023';
  end if;
  v_start := (((now() at time zone 'Europe/Paris')::date - (p_days - 1))::timestamp at time zone 'Europe/Paris');

  with logs as (
    select user_id, session_id, lower(platform) platform,
           coalesce(nullif(os_version,''),'Non renseignée') os_version,
           coalesce(nullif(app_version,''),'Non renseignée') version,
           event, level,
           (created_at at time zone 'Europe/Paris')::date as day,
           (event in ('flutter_error','fatal_zone_error') or upper(level) = 'ERROR') as is_error
    from public.app_logs
    where created_at >= v_start and created_at <= now()
      and lower(platform) in ('ios','android')
      and app_env = 'production'
  )
  select jsonb_build_object(
    'days', p_days,
    'refreshed_at', now(),
    'definition', 'Incidents = événements d’erreur consignés. Un incident ne signifie pas nécessairement un crash ; une session avec erreur est dédupliquée par identifiant de session.',
    'summary', (
      select jsonb_build_object(
        'events', count(*)::integer,
        'incident_events', count(*) filter (where is_error)::integer,
        'affected_users', count(distinct user_id) filter (where is_error)::integer,
        'sessions', count(distinct session_id) filter (where session_id is not null and session_id <> '')::integer,
        'affected_sessions', count(distinct session_id) filter (where is_error and session_id is not null and session_id <> '')::integer
      ) from logs
    ),
    'daily', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'date', x.day, 'incidents', x.incidents, 'affected_users', x.affected_users
      ) order by x.day), '[]'::jsonb)
      from (select day, count(*) filter (where is_error)::integer incidents,
                   count(distinct user_id) filter (where is_error)::integer affected_users
            from logs group by day) x
    ),
    'versions', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'version', x.version, 'users', x.users, 'events', x.events,
        'incidents', x.incidents
      ) order by x.users desc, x.version), '[]'::jsonb)
      from (select version, count(distinct user_id)::integer users,
                   count(*)::integer events,
                   count(*) filter (where is_error)::integer incidents
            from logs group by version) x
    ),
    'platforms', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'platform', x.platform, 'users', x.users,
        'affected_users', x.affected_users, 'incidents', x.incidents
      ) order by x.users desc, x.platform), '[]'::jsonb)
      from (select platform, count(distinct user_id)::integer users,
                   count(distinct user_id) filter (where is_error)::integer affected_users,
                   count(*) filter (where is_error)::integer incidents
            from logs where platform in ('ios','android') group by platform) x
    ),
    'os_versions', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'platform', x.platform, 'os_version', x.os_version,
        'users', x.users, 'affected_users', x.affected_users,
        'incidents', x.incidents
      ) order by x.users desc, x.platform, x.os_version), '[]'::jsonb)
      from (select platform, os_version,
                   count(distinct user_id)::integer users,
                   count(distinct user_id) filter (where is_error)::integer affected_users,
                   count(*) filter (where is_error)::integer incidents
            from logs where platform in ('ios','android')
            group by platform, os_version
            having count(distinct user_id) >= 5) x
    ),
    'incident_types', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'type', x.type, 'events', x.events, 'users', x.users
      ) order by x.events desc, x.type), '[]'::jsonb)
      from (select case when event in ('flutter_error','fatal_zone_error') then event
                        else 'Autres erreurs consignées' end type,
                   count(*)::integer events, count(distinct user_id)::integer users
            from logs where is_error group by 1) x
    )
  ) into v_result;

  return v_result;
end;
$$;

comment on function public.admin_quality_analytics(integer) is
  'Owner/AAL2 aggregated incident, app version and platform diagnostics. No raw log content.';
revoke all on function public.admin_quality_analytics(integer) from public, anon;
grant execute on function public.admin_quality_analytics(integer) to authenticated;
