-- Same-length period comparison for the owner dashboard.
-- Only aggregate values are returned; no user profile or raw log is exposed.
create or replace function public.admin_period_comparison(p_days integer default 30)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, auth
as $$
declare
  v_today date := (now() at time zone 'Europe/Paris')::date;
  v_current_start timestamptz;
  v_current_end timestamptz;
  v_previous_start timestamptz;
  v_result jsonb;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;

  if p_days is null or p_days not in (7, 30, 90) then
    raise exception 'Période invalide.' using errcode = '22023';
  end if;

  v_current_start := ((v_today - (p_days - 1))::timestamp at time zone 'Europe/Paris');
  v_current_end := ((v_today + 1)::timestamp at time zone 'Europe/Paris');
  v_previous_start := (((v_today - (p_days - 1)) - p_days)::timestamp at time zone 'Europe/Paris');

  with periods(label, start_at, end_at) as (
    values
      ('current'::text, v_current_start, v_current_end),
      ('previous'::text, v_previous_start, v_current_start)
  ), totals as (
    select
      p.label,
      (
        select count(distinct l.user_id)::integer
        from public.app_logs l
        where l.user_id is not null
          and l.created_at >= p.start_at and l.created_at < p.end_at
          and l.event in ('app:bootstrap:done','nav:push','nav:pop','nav:replace','nav:goto')
      ) as active_users,
      (
        select count(*)::integer
        from public.user_profiles u
        where u.created_at >= p.start_at and u.created_at < p.end_at
      ) as registrations,
      (
        select count(*)::integer
        from public.quiz_history q
        where q.started_at >= p.start_at and q.started_at < p.end_at
      ) as quiz_sessions,
      (
        select count(*)::integer
        from public.quiz_answer_history a
        where a.answered_at >= p.start_at and a.answered_at < p.end_at
      ) as answers_saved,
      (
        select count(*) filter (where a.is_correct)::integer
        from public.quiz_answer_history a
        where a.answered_at >= p.start_at and a.answered_at < p.end_at
      ) as correct_answers,
      (
        select count(*)::integer
        from public.app_logs l
        where l.created_at >= p.start_at and l.created_at < p.end_at
          and lower(l.platform) in ('ios','android')
          and l.app_env = 'production'
          and (l.event in ('flutter_error','fatal_zone_error') or upper(l.level) = 'ERROR')
      ) as incident_events,
      (
        (select count(*) from public.community_posts c
          where c.created_at >= p.start_at and c.created_at < p.end_at
            and c.status = 'published' and c.deleted_at is null)
        + (select count(*) from public.community_comments c
          where c.created_at >= p.start_at and c.created_at < p.end_at
            and c.status = 'published' and c.deleted_at is null)
        + (select count(*) from public.community_messages c
          where c.created_at >= p.start_at and c.created_at < p.end_at
            and c.status = 'published' and c.deleted_at is null)
      )::integer as community_contributions
    from periods p
  ), paired as (
    select
      max(active_users) filter (where label = 'current') as current_active_users,
      max(active_users) filter (where label = 'previous') as previous_active_users,
      max(registrations) filter (where label = 'current') as current_registrations,
      max(registrations) filter (where label = 'previous') as previous_registrations,
      max(quiz_sessions) filter (where label = 'current') as current_quiz_sessions,
      max(quiz_sessions) filter (where label = 'previous') as previous_quiz_sessions,
      max(answers_saved) filter (where label = 'current') as current_answers_saved,
      max(answers_saved) filter (where label = 'previous') as previous_answers_saved,
      max(correct_answers) filter (where label = 'current') as current_correct_answers,
      max(correct_answers) filter (where label = 'previous') as previous_correct_answers,
      max(incident_events) filter (where label = 'current') as current_incident_events,
      max(incident_events) filter (where label = 'previous') as previous_incident_events,
      max(community_contributions) filter (where label = 'current') as current_community_contributions,
      max(community_contributions) filter (where label = 'previous') as previous_community_contributions
    from totals
  ), metric_rows as (
    select m.key, m.current_value, m.previous_value
    from paired p
    cross join lateral (values
      ('active_users', p.current_active_users, p.previous_active_users),
      ('registrations', p.current_registrations, p.previous_registrations),
      ('quiz_sessions', p.current_quiz_sessions, p.previous_quiz_sessions),
      ('answers_saved', p.current_answers_saved, p.previous_answers_saved),
      ('correct_answers', p.current_correct_answers, p.previous_correct_answers),
      ('incident_events', p.current_incident_events, p.previous_incident_events),
      ('community_contributions', p.current_community_contributions, p.previous_community_contributions)
    ) as m(key, current_value, previous_value)
  )
  select jsonb_build_object(
    'days', p_days,
    'refreshed_at', now(),
    'current_start', v_current_start,
    'current_end', v_current_end,
    'previous_start', v_previous_start,
    'previous_end', v_current_start,
    'definition', 'Comparaison de deux périodes consécutives de même durée, en heure de Paris. La période actuelle inclut la journée en cours.',
    'metrics', coalesce(jsonb_object_agg(
      key,
      jsonb_build_object(
        'current', current_value,
        'previous', previous_value,
        'delta', current_value - previous_value,
        'change_pct', case
          when previous_value = 0 then null
          else round(100.0 * (current_value - previous_value) / previous_value, 1)
        end
      ) order by key
    ), '{}'::jsonb)
  ) into v_result
  from metric_rows;

  return v_result;
end;
$$;

comment on function public.admin_period_comparison(integer) is
  'Owner/AAL2 aggregate comparison of two consecutive same-length periods.';
revoke all on function public.admin_period_comparison(integer) from public, anon;
grant execute on function public.admin_period_comparison(integer) to authenticated;
