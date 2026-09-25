-- Read-only, audited-access Coach dashboard. The browser never receives
-- service credentials or mutation rights.
create or replace function public.admin_coach_overview()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_admin public.admin_users;
begin
  v_admin := public.admin_mobile_release_guard();
  return jsonb_build_object(
    'users_configured', (select count(*) from public.coach_user_preferences),
    'users_with_exam_date', (select count(*) from public.coach_user_preferences where target_exam_date is not null),
    'reflections', (select count(*) from public.coach_answer_reflections),
    'weekly_summaries', (select count(*) from public.coach_weekly_summaries),
    'calendar_events', (select count(*) from public.official_competition_events where is_active),
    'calendar_last_run', (
      select jsonb_build_object(
        'status', r.status,
        'events_found', r.events_found,
        'started_at', r.started_at,
        'finished_at', r.finished_at,
        'error_message', r.error_message,
        'source_status', r.source_status
      )
      from public.official_calendar_sync_runs r
      order by r.id desc limit 1
    ),
    'generated_at', now()
  );
end;
$$;

revoke all on function public.admin_coach_overview() from public, anon;
grant execute on function public.admin_coach_overview() to authenticated, service_role;

comment on function public.admin_coach_overview() is
  'Owner+AAL2 read-only operational metrics for COPIQ Coach and official calendar sync.';
