-- Centre d'activité complet des quatre forums COP'IQ.
-- Lecture admin uniquement, filtrée par les scopes communautaires existants.

create or replace function public.community_admin_space_summary()
returns table(
  space_id text, space_label text, color_hex text,
  posts bigint, comments bigint, likes bigint, reports bigint,
  removed bigint, active_sanctions bigint, last_activity_at timestamptz
)
language plpgsql stable security definer set search_path = '' as $$
begin
  perform public.community_admin_guard();
  return query
  select s.id, s.label, s.color_hex,
    (select count(*) from public.community_posts p where p.space_id = s.id),
    (select count(*) from public.community_comments c join public.community_posts p on p.id = c.post_id where p.space_id = s.id),
    (select count(*) from public.community_reactions r left join public.community_posts p on p.id = r.post_id left join public.community_comments c on c.id = r.comment_id left join public.community_posts cp on cp.id = c.post_id where coalesce(p.space_id, cp.space_id) = s.id),
    (select count(*) from public.community_reports r where r.space_id = s.id),
    (select count(*) from public.community_posts p where p.space_id = s.id and (p.deleted_at is not null or p.status = 'removed'))
      + (select count(*) from public.community_comments c join public.community_posts p on p.id = c.post_id where p.space_id = s.id and (c.deleted_at is not null or c.status = 'removed')),
    (select count(*) from public.community_sanctions x where x.space_id = s.id and x.status = 'active' and (x.ends_at is null or x.ends_at > now())),
    greatest(
      (select max(p.created_at) from public.community_posts p where p.space_id = s.id),
      (select max(c.created_at) from public.community_comments c join public.community_posts p on p.id = c.post_id where p.space_id = s.id),
      (select max(r.created_at) from public.community_reactions r left join public.community_posts p on p.id = r.post_id left join public.community_comments c on c.id = r.comment_id left join public.community_posts cp on cp.id = c.post_id where coalesce(p.space_id, cp.space_id) = s.id)
    )
  from public.community_spaces s
  where s.id in ('pa_exam','gpx_exam','pa_school','gpx_school')
    and public.community_is_staff(s.id)
  order by s.sort_order;
end;
$$;

create or replace function public.community_admin_activity_feed(
  p_space_id text default null,
  p_event_type text default null,
  p_search text default null,
  p_limit integer default 50,
  p_offset integer default 0
) returns table(
  event_id text, event_type text, event_at timestamptz,
  space_id text, space_label text, actor_id uuid, actor_name text, actor_email text,
  target_type text, target_id text, title text, content text,
  status text, metadata jsonb, total_count bigint
)
language plpgsql stable security definer set search_path = '' as $$
declare
  v_limit integer := least(greatest(coalesce(p_limit, 50), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  perform public.community_admin_guard();
  if p_space_id is not null and p_space_id not in ('pa_exam','gpx_exam','pa_school','gpx_school') then
    raise exception 'Espace invalide' using errcode = '22023';
  end if;
  if p_event_type is not null and p_event_type not in ('post','comment','like','deletion','report','moderation','sanction') then
    raise exception 'Type d’événement invalide' using errcode = '22023';
  end if;

  return query
  with events as (
    select 'post:' || p.id::text event_id, case when p.deleted_at is not null or p.status = 'removed' then 'deletion' else 'post' end event_type,
      coalesce(p.deleted_at, p.created_at) event_at, p.space_id, p.author_id actor_id,
      'post'::text target_type, p.id::text target_id, p.title,
      left(p.content, 1000) content, p.status,
      jsonb_build_object('reactions',p.reaction_count,'comments',p.comment_count,'shares',p.share_count,'views',p.view_count,'deleted_at',p.deleted_at,'edited_at',p.edited_at) metadata
    from public.community_posts p
    union all
    select 'comment:' || c.id::text, case when c.deleted_at is not null or c.status = 'removed' then 'deletion' else 'comment' end,
      coalesce(c.deleted_at, c.created_at), p.space_id, c.author_id, 'comment', c.id::text, p.title,
      left(c.content, 1000), c.status,
      jsonb_build_object('post_id',c.post_id,'reactions',c.reaction_count,'replies',c.reply_count,'deleted_at',c.deleted_at,'edited_at',c.edited_at)
    from public.community_comments c join public.community_posts p on p.id = c.post_id
    union all
    select 'reaction:' || coalesce(r.post_id::text,r.comment_id::text) || ':' || r.user_id::text || ':' || extract(epoch from r.created_at)::bigint,
      'like', r.created_at, coalesce(p.space_id,cp.space_id), r.user_id,
      case when r.post_id is not null then 'post' else 'comment' end,
      coalesce(r.post_id::text,r.comment_id::text), coalesce(p.title,cp.title), r.kind, 'active',
      jsonb_build_object('kind',r.kind,'post_id',r.post_id,'comment_id',r.comment_id)
    from public.community_reactions r
    left join public.community_posts p on p.id = r.post_id
    left join public.community_comments c on c.id = r.comment_id
    left join public.community_posts cp on cp.id = c.post_id
    union all
    select 'report:' || r.id::text, 'report', r.created_at, r.space_id, r.reporter_id,
      r.target_type, r.target_id::text, 'Signalement · ' || r.reason, left(r.details,1000), r.status,
      jsonb_build_object('priority',r.priority,'resolution',r.resolution,'resolved_at',r.resolved_at,'subject_user_id',r.subject_user_id)
    from public.community_reports r
    union all
    select 'moderation:' || m.id::text, 'moderation', m.created_at, m.space_id, m.actor_id,
      m.target_type, m.target_id, initcap(replace(m.action,'_',' ')), m.reason, m.action,
      jsonb_build_object('old_state',m.old_state,'new_state',m.new_state,'report_id',m.report_id)
    from public.community_moderation_log m
    union all
    select 'sanction:' || s.id::text, 'sanction', s.created_at, s.space_id, s.imposed_by,
      'user', s.user_id::text, initcap(replace(s.kind,'_',' ')), s.reason, s.status,
      jsonb_build_object('starts_at',s.starts_at,'ends_at',s.ends_at,'revoked_at',s.revoked_at)
    from public.community_sanctions s
  ), visible as (
    select e.*, sp.label space_label, u.first_name, u.last_name, u.username, u.email
    from events e
    join public.community_spaces sp on sp.id = e.space_id
    left join public.user_profiles u on u.user_id = e.actor_id
    where e.space_id in ('pa_exam','gpx_exam','pa_school','gpx_school')
      and public.community_is_staff(e.space_id)
      and (p_space_id is null or e.space_id = p_space_id)
      and (p_event_type is null or e.event_type = p_event_type)
      and (nullif(trim(coalesce(p_search,'')),'') is null
        or e.title ilike '%' || trim(p_search) || '%'
        or e.content ilike '%' || trim(p_search) || '%'
        or u.email ilike '%' || trim(p_search) || '%'
        or u.username ilike '%' || trim(p_search) || '%')
  )
  select v.event_id,v.event_type,v.event_at,v.space_id,v.space_label,v.actor_id,
    coalesce(nullif(trim(concat_ws(' ',v.first_name,v.last_name)),''),nullif(v.username,''),'Compte inconnu'),
    v.email,v.target_type,v.target_id,v.title,v.content,v.status,v.metadata,count(*) over()
  from visible v order by v.event_at desc, v.event_id desc limit v_limit offset v_offset;
end;
$$;

revoke all on function public.community_admin_space_summary() from public, anon;
revoke all on function public.community_admin_activity_feed(text,text,text,integer,integer) from public, anon;
grant execute on function public.community_admin_space_summary() to authenticated;
grant execute on function public.community_admin_activity_feed(text,text,text,integer,integer) to authenticated;

comment on function public.community_admin_space_summary() is 'Complete scoped metrics for the four COPIQ community spaces.';
comment on function public.community_admin_activity_feed(text,text,text,integer,integer) is 'Complete scoped admin history: posts, comments, likes, deletions, reports, moderation and sanctions.';
