-- Tighten Data API grants. This project still has legacy automatic grants,
-- therefore CREATE TABLE granted more than the forum clients require.
revoke all on table
 public.community_spaces, public.community_categories, public.community_memberships,
 public.community_posts, public.community_comments, public.community_reactions,
 public.community_bookmarks, public.community_subscriptions, public.community_blocks,
 public.community_rooms, public.community_room_members, public.community_messages,
 public.community_reports, public.community_sanctions, public.community_moderator_scopes,
 public.community_moderation_log, public.community_notifications
from anon, authenticated;

grant select on public.community_spaces, public.community_categories to authenticated;
grant select,insert,update on public.community_memberships to authenticated;
grant select,insert,update on public.community_posts, public.community_comments to authenticated;
grant select,insert,delete on public.community_reactions, public.community_bookmarks,
 public.community_subscriptions, public.community_blocks to authenticated;
grant select,insert on public.community_rooms to authenticated;
grant select,insert,update on public.community_room_members, public.community_messages,
 public.community_reports, public.community_notifications to authenticated;
grant select,insert,update on public.community_sanctions to authenticated;
grant select on public.community_moderator_scopes, public.community_moderation_log to authenticated;

revoke all on sequence public.community_moderation_log_id_seq from anon,authenticated;

revoke all on function public.community_is_staff(text,text[]) from public,anon;
revoke all on function public.community_can_publish(text,text) from public,anon;
revoke all on function public.community_is_room_member(uuid,text[]) from public,anon;
revoke all on function public.community_admin_dashboard(text) from public,anon;
revoke all on function public.community_moderate_post(uuid,text,text) from public,anon;
revoke all on function public.community_resolve_report(uuid,text,text) from public,anon;

grant execute on function public.community_is_staff(text,text[]),
 public.community_can_publish(text,text), public.community_is_room_member(uuid,text[]),
 public.community_admin_dashboard(text), public.community_moderate_post(uuid,text,text),
 public.community_resolve_report(uuid,text,text) to authenticated;
