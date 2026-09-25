-- COP'IQ admin analytics: live counts instead of the unrefreshed May 2026
-- materialized view. Only aggregate values leave the database.

create or replace function public.admin_dashboard_stats_live()
returns jsonb
language plpgsql
stable
security definer
set search_path = public, auth
as $$
begin
  if not public.has_admin_role('owner','admin','moderator','helper')
     or not public.has_admin_permission('dashboard')
     or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;

  return jsonb_build_object(
    'users_total', (select count(*) from public.user_profiles),
    'users_active_30d', (
      select count(distinct user_id) from public.app_logs
      where user_id is not null
        and created_at >= now() - interval '30 days'
        and event in ('app:bootstrap:done','nav:push','nav:pop','nav:replace','nav:goto')
    ),
    'users_24h', (
      select count(distinct user_id) from public.app_logs
      where user_id is not null
        and created_at >= now() - interval '24 hours'
        and event in ('app:bootstrap:done','nav:push','nav:pop','nav:replace','nav:goto')
    ),
    'users_premium', (
      select count(*) from public.cas_pratique_subscriptions
      where tier = 'premium' and status = 'active'
    ),
    'users_trial', (
      select count(*) from public.cas_pratique_subscriptions
      where status = 'trialing'
    ),
    'subs_expired_30d', (
      select count(*) from public.cas_pratique_subscriptions
      where status in ('canceled','expired')
        and updated_at >= now() - interval '30 days'
    ),
    'reports_open_cg', (
      select count(*) from public.report_culture_generale
      where status in ('new','in_progress')
    ),
    'reports_open_psy', (
      select count(*) from public.tests_psycotechnique_report
      where status in ('new','in_progress')
    ),
    'bug_reports_open', (
      select count(*) from public.bug_reports
      where status in ('new','triage','in_progress')
    ),
    'contact_open', (
      select count(*) from public.contact_messages where status = 'new'
    ),
    'forum_reports_open', (
      select count(*) from public.forum_reports where status = 'open'
    ),
    'staff_total', (
      select count(*) from public.admin_users where disabled = false
    ),
    'staff_locked', (
      select count(*) from public.admin_users
      where locked_until is not null and locked_until > now()
    ),
    'audit_logs_24h', (
      select count(*) from public.admin_audit_logs
      where created_at >= now() - interval '24 hours'
    ),
    'critical_events_7d', (
      select count(*) from public.admin_audit_logs
      where severity = 'critical' and created_at >= now() - interval '7 days'
    ),
    'quiz_questions', (
      select reltuples::bigint from pg_class
      where oid = 'public.quiz_questions'::regclass
    ),
    'app_logs_total', (select count(*) from public.app_logs),
    'refreshed_at', now()
  );
end;
$$;

comment on function public.admin_dashboard_stats_live() is
  'Live owner/staff summary; active users are identified app activity, not recent registrations.';
revoke all on function public.admin_dashboard_stats_live() from public, anon;
grant execute on function public.admin_dashboard_stats_live() to authenticated;

create or replace function public.admin_app_analytics(p_days integer default 30)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, auth
as $$
declare
  v_today date := (now() at time zone 'Europe/Paris')::date;
  v_start date;
  v_result jsonb;
begin
  if not public.has_admin_role('owner')
     or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  if p_days is null or p_days not in (7, 30, 90) then
    raise exception 'Période invalide.' using errcode = '22023';
  end if;
  v_start := v_today - (p_days - 1);

  with
  activity_days as (
    select distinct l.user_id, (l.created_at at time zone 'Europe/Paris')::date as day
    from public.app_logs l
    where l.user_id is not null
      and l.event in ('app:bootstrap:done','nav:push','nav:pop','nav:replace','nav:goto')
  ),
  activity_users as (select distinct user_id from activity_days),
  quiz_users as (
    select distinct q.uid
    from public.quiz_history q
    where q.uid is not null and q.uid <> ''
  ),
  paying_users as (
    select distinct s.user_id
    from public.cas_pratique_subscriptions s
    where s.tier = 'premium' and s.status = 'active'
  ),
  daily_active as (
    select day, count(*)::integer as users
    from activity_days where day >= v_start and day <= v_today
    group by day
  ),
  daily_signups as (
    select (created_at at time zone 'Europe/Paris')::date as day,
           count(*)::integer as users
    from public.user_profiles
    where created_at >= (v_start::timestamp at time zone 'Europe/Paris')
    group by 1
  ),
  daily_quizzes as (
    select (started_at at time zone 'Europe/Paris')::date as day,
           count(*)::integer as sessions
    from public.quiz_history
    where started_at >= (v_start::timestamp at time zone 'Europe/Paris')
    group by 1
  ),
  current_journeys as (
    select user_track as track, user_mode as mode, count(*)::integer as users
    from public.user_profiles group by 1,2
  ),
  quiz_journeys as (
    select track, mode, count(*)::integer as sessions,
           count(distinct uid)::integer as learners
    from public.quiz_history group by 1,2
  )
  select jsonb_build_object(
    'days', p_days,
    'refreshed_at', now(),
    'activity_definition', 'App ouverte ou navigation identifiée; renouvellement de jeton et erreurs exclus',
    'daily', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'date', d.day::date,
        'active_users', coalesce(a.users,0),
        'registrations', coalesce(s.users,0),
        'quiz_sessions', coalesce(q.sessions,0)
      ) order by d.day), '[]'::jsonb)
      from generate_series(v_start,v_today,interval '1 day') as d(day)
      left join daily_active a on a.day = d.day
      left join daily_signups s on s.day = d.day
      left join daily_quizzes q on q.day = d.day
    ),
    'retention', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'day', r.day_offset,
        'eligible', r.eligible,
        'returned', r.returned,
        'rate', case when r.eligible = 0 then null
                     else round(100.0 * r.returned / r.eligible,1) end
      ) order by r.day_offset), '[]'::jsonb)
      from (
        select o.day_offset,
               count(*)::integer as eligible,
               count(*) filter (where exists (
                 select 1 from activity_days a
                 where a.user_id = p.user_id
                   and a.day = (p.created_at at time zone 'Europe/Paris')::date + o.day_offset
               ))::integer as returned
        from (values (1),(7),(30)) as o(day_offset)
        cross join public.user_profiles p
        where (p.created_at at time zone 'Europe/Paris')::date
          <= v_today - o.day_offset
        group by o.day_offset
      ) r
    ),
    'funnel', (
      select jsonb_build_object(
        'registered', count(*)::integer,
        'opened_app', count(*) filter (where a.user_id is not null)::integer,
        'practiced_quiz', count(*) filter (
          where a.user_id is not null and q.uid is not null
        )::integer,
        'paying_active_after_quiz', count(*) filter (
          where a.user_id is not null and q.uid is not null and s.user_id is not null
        )::integer
      )
      from public.user_profiles p
      left join activity_users a on a.user_id = p.user_id
      left join quiz_users q on q.uid = p.user_id::text
      left join paying_users s on s.user_id = p.user_id
    ),
    'engagement', (
      select jsonb_build_object(
        'active_1d', (select count(distinct user_id) from activity_days where day = v_today),
        'active_7d', (select count(distinct user_id) from activity_days where day >= v_today - 6),
        'active_30d', (select count(distinct user_id) from activity_days where day >= v_today - 29),
        'logged_sessions', (
          select count(distinct session_id) from public.app_logs
          where created_at >= (v_start::timestamp at time zone 'Europe/Paris')
            and user_id is not null
            and session_id is not null and session_id <> ''
            and event in ('app:bootstrap:done','nav:push','nav:pop','nav:replace','nav:goto')
        ),
        'quiz_sessions', (
          select count(*) from public.quiz_history
          where started_at >= (v_start::timestamp at time zone 'Europe/Paris')
        ),
        'quiz_learners', (
          select count(distinct uid) from public.quiz_history
          where started_at >= (v_start::timestamp at time zone 'Europe/Paris')
        ),
        'answers_saved', (
          select count(*) from public.quiz_answer_history
          where answered_at >= (v_start::timestamp at time zone 'Europe/Paris')
        ),
        'practical_attempts', (
          select count(*) from public.cas_pratique_attempts
          where created_at >= (v_start::timestamp at time zone 'Europe/Paris')
        ),
        'paywall_visitors', (
          select count(distinct user_id) from public.app_logs
          where created_at >= (v_start::timestamp at time zone 'Europe/Paris')
            and user_id is not null
            and event in ('nav:push','nav:replace','nav:goto')
            and route in ('/abonnement','/premium-required')
        ),
        'paid_active', (select count(*) from paying_users),
        'trials_active', (
          select count(*) from public.cas_pratique_subscriptions
          where status = 'trialing'
        )
      )
    ),
    'journeys', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'track', j.track, 'mode', j.mode, 'label', j.label,
        'current_users', coalesce(c.users,0),
        'quiz_sessions', coalesce(q.sessions,0),
        'quiz_learners', coalesce(q.learners,0)
      ) order by j.position), '[]'::jsonb)
      from (values
        (1,'gpx','school','Scolarité GPX'),
        (2,'pa','school','Scolarité PA'),
        (3,'gpx','exam','Concours GPX'),
        (4,'pa','exam','Concours PA'),
        (5,'gpx','active','Je suis actif')
      ) as j(position,track,mode,label)
      left join current_journeys c on c.track = j.track and c.mode = j.mode
      left join quiz_journeys q on q.track = j.track and q.mode = j.mode
    ),
    'platforms', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'platform', x.platform, 'users', x.users, 'sessions', x.sessions
      ) order by x.users desc), '[]'::jsonb)
      from (
        select lower(l.platform) as platform,
               count(distinct l.user_id)::integer as users,
               count(distinct l.session_id)::integer as sessions
        from public.app_logs l
        where l.created_at >= (v_start::timestamp at time zone 'Europe/Paris')
          and l.user_id is not null
          and lower(l.platform) in ('ios','android')
          and l.event in ('app:bootstrap:done','nav:push','nav:pop','nav:replace','nav:goto')
        group by lower(l.platform)
      ) x
    ),
    'top_content', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'route', x.route, 'users', x.users, 'views', x.views
      ) order by x.views desc, x.route), '[]'::jsonb)
      from (
        select l.route,
               count(distinct l.user_id)::integer as users,
               count(*)::integer as views
        from public.app_logs l
        where l.created_at >= (v_start::timestamp at time zone 'Europe/Paris')
          and l.user_id is not null
          and l.event in ('nav:push','nav:replace','nav:goto')
          and l.route is not null and l.route <> ''
          and l.route not in (
            '/','/home-bootstrap','/picker','/mode_picker','/login','/signup',
            '/welcome','/placement-intro'
          )
        group by l.route order by views desc limit 10
      ) x
    ),
    'stores', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'store', x.store, 'paid_active', x.paid_active
      ) order by x.paid_active desc), '[]'::jsonb)
      from (
        select coalesce(nullif(store,''),nullif(payment_source,''),'non renseigné') as store,
               count(*)::integer as paid_active
        from public.cas_pratique_subscriptions
        where tier = 'premium' and status = 'active'
        group by 1
      ) x
    )
  ) into v_result;

  return v_result;
end;
$$;

comment on function public.admin_app_analytics(integer) is
  'Owner-only aggregated activity, exact-day retention, journey and Premium status. No personal rows or revenue estimates.';
revoke all on function public.admin_app_analytics(integer) from public, anon;
grant execute on function public.admin_app_analytics(integer) to authenticated;
