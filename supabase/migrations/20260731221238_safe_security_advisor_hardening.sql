-- Pin function lookup paths without changing their bodies or permissions.
alter function archive.archive_practical_case(uuid, uuid)
  set search_path = archive, public, extensions, pg_temp;
alter function archive.create_practical_case_snapshot(uuid, uuid)
  set search_path = archive, public, extensions, pg_temp;
alter function archive.lock_practical_case(uuid, uuid)
  set search_path = archive, public, extensions, pg_temp;
alter function archive.publish_practical_case(uuid, uuid)
  set search_path = archive, public, extensions, pg_temp;
alter function archive.recalculate_practical_case_total_points(uuid)
  set search_path = archive, public, extensions, pg_temp;
alter function archive.trg_recalculate_total_points()
  set search_path = archive, public, extensions, pg_temp;
alter function beta.get_remaining_places()
  set search_path = beta, public, extensions, pg_temp;

-- Admin aggregates must only be read through the permission-checked RPC.
revoke all on public.mv_admin_dashboard_stats from anon, authenticated;

comment on table public.cp_rate_limit_buckets is
  'Internal rate-limit state. RLS intentionally has no client policy; access is restricted to SECURITY DEFINER functions/service roles.';
