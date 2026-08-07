-- File de modération unifiée du forum COP'IQ.
-- Un modérateur ne voit que les signalements des espaces sur lesquels il a
-- réellement un scope. Le contenu privé n'est jamais joint ici : il demeure
-- accessible uniquement via community_open_message_report(), qui exige un
-- motif et journalise chaque consultation.

create or replace function public.community_admin_list_reports(
  p_status text default null,
  p_target_type text default null,
  p_space_id text default null,
  p_priority text default null,
  p_search text default null,
  p_limit integer default 50,
  p_offset integer default 0
) returns table(
  id uuid,
  created_at timestamptz,
  status text,
  priority text,
  space_id text,
  space_label text,
  target_type text,
  target_id uuid,
  reason text,
  details text,
  reporter_id uuid,
  reporter_name text,
  reporter_username text,
  reporter_avatar_index integer,
  subject_user_id uuid,
  subject_name text,
  subject_username text,
  subject_avatar_index integer,
  target_title text,
  target_content text,
  target_status text,
  resolution text,
  resolved_at timestamptz,
  appealed_at timestamptz,
  appeal_text text,
  total_count bigint
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_limit integer := least(greatest(coalesce(p_limit, 50), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  if (select auth.uid()) is null or not exists (
    select 1 from public.community_moderator_scopes s
    where s.user_id = (select auth.uid())
      and s.role in ('helper', 'moderator', 'admin', 'owner')
      and (s.expires_at is null or s.expires_at > now())
  ) then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;

  if p_status is not null and p_status not in ('new','triaged','in_progress','resolved','rejected','appealed') then
    raise exception 'Statut invalide' using errcode = '22023';
  end if;
  if p_target_type is not null and p_target_type not in ('post','comment','message','profile','attachment','room') then
    raise exception 'Type de cible invalide' using errcode = '22023';
  end if;
  if p_priority is not null and p_priority not in ('normal','high','urgent') then
    raise exception 'Priorité invalide' using errcode = '22023';
  end if;

  return query
  select
    r.id,
    r.created_at,
    r.status,
    r.priority,
    r.space_id,
    coalesce(s.label, 'Tout le monde') as space_label,
    r.target_type,
    r.target_id,
    r.reason,
    r.details,
    r.reporter_id,
    nullif(trim(concat_ws(' ', reporter.first_name, reporter.last_name)), '') as reporter_name,
    reporter.username as reporter_username,
    reporter.avatar_index as reporter_avatar_index,
    coalesce(r.subject_user_id, post.author_id, comment.author_id) as subject_user_id,
    nullif(trim(concat_ws(' ', subject.first_name, subject.last_name)), '') as subject_name,
    subject.username as subject_username,
    subject.avatar_index as subject_avatar_index,
    case
      when r.target_type = 'post' then post.title
      when r.target_type = 'comment' then 'Réponse signalée'
      when r.target_type = 'message' then 'Message privé signalé'
      when r.target_type = 'profile' then 'Profil communautaire signalé'
      else initcap(r.target_type) || ' signalé'
    end as target_title,
    case
      when r.target_type = 'post' then left(post.content, 1200)
      when r.target_type = 'comment' then left(comment.content, 1200)
      else null
    end as target_content,
    coalesce(post.status, comment.status) as target_status,
    r.resolution,
    r.resolved_at,
    r.appealed_at,
    r.appeal_text,
    count(*) over() as total_count
  from public.community_reports r
  left join public.community_spaces s on s.id = r.space_id
  left join public.community_posts post on r.target_type = 'post' and post.id = r.target_id
  left join public.community_comments comment on r.target_type = 'comment' and comment.id = r.target_id
  left join public.user_profiles reporter on reporter.user_id = r.reporter_id
  left join public.user_profiles subject on subject.user_id = coalesce(r.subject_user_id, post.author_id, comment.author_id)
  where public.community_is_staff(coalesce(r.space_id, 'global'))
    and (p_status is null or r.status = p_status)
    and (p_target_type is null or r.target_type = p_target_type)
    and (p_space_id is null or r.space_id = p_space_id)
    and (p_priority is null or r.priority = p_priority)
    and (
      nullif(trim(coalesce(p_search, '')), '') is null
      or r.details ilike '%' || trim(p_search) || '%'
      or r.reason ilike '%' || trim(p_search) || '%'
      or reporter.username ilike '%' || trim(p_search) || '%'
      or subject.username ilike '%' || trim(p_search) || '%'
      or post.title ilike '%' || trim(p_search) || '%'
      or post.content ilike '%' || trim(p_search) || '%'
      or comment.content ilike '%' || trim(p_search) || '%'
    )
  order by
    case r.priority when 'urgent' then 0 when 'high' then 1 else 2 end,
    r.created_at asc,
    r.id
  limit v_limit offset v_offset;
end;
$$;

revoke all on function public.community_admin_list_reports(text,text,text,text,text,integer,integer) from public, anon;
grant execute on function public.community_admin_list_reports(text,text,text,text,text,integer,integer) to authenticated;

comment on function public.community_admin_list_reports(text,text,text,text,text,integer,integer) is
  'Scoped moderation queue. Private-message content is intentionally excluded and must be opened through the audited bounded-evidence RPC.';
