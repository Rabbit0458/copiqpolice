-- Observed 90-day activity query: the old created_at index scanned 10,666
-- matching activity events with 3,430 heap-buffer hits. This narrow partial
-- index allows the distinct user/day scan to avoid wide log rows.
create index if not exists app_logs_analytics_activity_idx
  on public.app_logs (created_at, user_id)
  where user_id is not null
    and event in ('app:bootstrap:done','nav:push','nav:pop','nav:replace','nav:goto');
