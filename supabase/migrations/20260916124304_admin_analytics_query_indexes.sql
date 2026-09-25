-- Targeted indexes for the owner analytics functions. These predicates match
-- the dashboard filters and avoid indexing drafts/deleted community content.
create index if not exists quiz_history_analytics_started_at_idx
  on public.quiz_history (started_at)
  where started_at is not null;

create index if not exists quiz_answer_history_analytics_answered_at_idx
  on public.quiz_answer_history (answered_at)
  include (is_correct)
  where answered_at is not null;

create index if not exists community_posts_analytics_created_at_idx
  on public.community_posts (created_at)
  where status = 'published' and deleted_at is null;

create index if not exists community_comments_analytics_created_at_idx
  on public.community_comments (created_at)
  where status = 'published' and deleted_at is null;

create index if not exists community_messages_analytics_created_at_idx
  on public.community_messages (created_at)
  where status = 'published' and deleted_at is null;

create index if not exists app_logs_analytics_incidents_idx
  on public.app_logs (created_at)
  where app_env = 'production'
    and lower(platform) in ('ios','android')
    and (event in ('flutter_error','fatal_zone_error') or upper(level) = 'ERROR');
