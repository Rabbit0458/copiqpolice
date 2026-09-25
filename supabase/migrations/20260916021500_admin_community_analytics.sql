-- Published community activity; deleted/moderated content is excluded.
create or replace function public.admin_community_analytics(p_days integer default 30)
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

  with posts as (
    select id, author_id, created_at, view_count
    from public.community_posts
    where status = 'published' and deleted_at is null
  ), comments as (
    select id, author_id, created_at
    from public.community_comments
    where status = 'published' and deleted_at is null
  ), messages as (
    select sender_id, created_at
    from public.community_messages
    where status = 'published' and deleted_at is null
  ), participants as (
    select author_id user_id from posts where created_at >= v_start
    union select author_id from comments where created_at >= v_start
    union select sender_id from messages where created_at >= v_start
  )
  select jsonb_build_object(
    'days', p_days,
    'refreshed_at', now(),
    'summary', jsonb_build_object(
      'visible_posts', (select count(*)::integer from posts),
      'new_posts', (select count(*)::integer from posts where created_at >= v_start),
      'new_comments', (select count(*)::integer from comments where created_at >= v_start),
      'new_messages', (select count(*)::integer from messages where created_at >= v_start),
      'new_reactions', (
        select count(*)::integer from public.community_reactions r
        where r.created_at >= v_start
          and (exists (select 1 from posts p where p.id = r.post_id)
            or exists (select 1 from comments c where c.id = r.comment_id))
      ),
      'contributors', (select count(*)::integer from participants where user_id is not null),
      'visible_post_views', (select coalesce(sum(view_count),0)::integer from posts),
      'active_spaces', (select count(*)::integer from public.community_spaces where is_active)
    ),
    'definition', 'Publications et commentaires actuellement publiés ; contenus supprimés exclus. Les vues sont un cumul des publications toujours visibles.'
  ) into v_result;
  return v_result;
end;
$$;

comment on function public.admin_community_analytics(integer) is
  'Owner/AAL2 aggregate community activity excluding deleted or moderated content.';
revoke all on function public.admin_community_analytics(integer) from public, anon;
grant execute on function public.admin_community_analytics(integer) to authenticated;
