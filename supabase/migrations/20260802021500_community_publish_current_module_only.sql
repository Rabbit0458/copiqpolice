create or replace function public.community_can_publish(p_space_id text,p_kind text default 'post')
returns boolean language sql stable security definer set search_path='' as $$
 select (select auth.uid()) is not null
 and (
   p_kind = 'message'
   or p_space_id = (
     select case
       when u.user_mode='exam' and u.user_track='pa' then 'pa_exam'
       when u.user_mode='exam' and u.user_track='gpx' then 'gpx_exam'
       when u.user_mode='school' and u.user_track='pa' then 'pa_school'
       when u.user_mode='school' and u.user_track='gpx' then 'gpx_school'
       else null
     end
     from public.user_profiles u
     where u.user_id=(select auth.uid())
   )
 )
 and not exists(
  select 1 from public.community_sanctions s where s.user_id=(select auth.uid()) and s.status='active'
  and (s.space_id is null or s.space_id in ('global',p_space_id))
  and (s.ends_at is null or s.ends_at>now())
  and (s.kind in ('suspension','ban') or (p_kind='post' and s.kind='post_restriction') or (p_kind='comment' and s.kind='comment_restriction') or (p_kind='message' and s.kind='message_restriction'))
 );
$$;

revoke all on function public.community_can_publish(text,text) from public,anon;
grant execute on function public.community_can_publish(text,text) to authenticated;
