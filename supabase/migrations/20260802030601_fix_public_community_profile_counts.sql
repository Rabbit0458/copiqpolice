-- Public forum contributions must have the same totals for the profile owner
-- and every other signed-in member. Only non-deleted public statuses count.

create or replace function public.community_public_profile(p_user_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  result jsonb;
begin
  if (select auth.uid()) is null then
    raise exception 'Connexion requise' using errcode = '42501';
  end if;
  if exists(
    select 1 from public.community_blocks b
    where (b.blocker_id = (select auth.uid()) and b.blocked_id = p_user_id)
       or (b.blocker_id = p_user_id and b.blocked_id = (select auth.uid()))
  ) then
    raise exception 'Profil indisponible' using errcode = '42501';
  end if;

  select jsonb_build_object(
    'user_id', u.user_id,
    'username', coalesce(nullif(trim(u.username), ''), 'membre'),
    'display_name', case
      when coalesce(cp.show_display_name, true) or u.user_id = (select auth.uid())
        then coalesce(nullif(trim(concat_ws(' ', u.first_name, u.last_name)), ''),
                      nullif(trim(u.username), ''), 'Membre COP’IQ')
      else coalesce(nullif(trim(u.username), ''), 'Membre COP’IQ')
    end,
    'show_display_name', coalesce(cp.show_display_name, true),
    'avatar_index', u.avatar_index,
    'bio', coalesce(cp.bio, ''),
    'joined_at', case
      when coalesce(cp.show_joined_at, true) or u.user_id = (select auth.uid())
        then u.created_at else null
    end,
    'primary_space', case
      when coalesce(cp.show_spaces, true) or u.user_id = (select auth.uid())
        then (
          select m.space_id from public.community_memberships m
          where m.user_id = u.user_id and m.is_primary and m.status = 'active'
          limit 1
        )
      else null
    end,
    'post_count', (
      select count(*) from public.community_posts p
      where p.author_id = u.user_id
        and p.status in ('published', 'locked', 'archived')
    ),
    'comment_count', (
      select count(*) from public.community_comments c
      where c.author_id = u.user_id and c.status = 'published'
    ),
    'solutions_count', (
      select count(*) from public.community_comments c
      where c.author_id = u.user_id and c.is_solution and c.status = 'published'
    ),
    'staff_role', (
      select s.role from public.community_moderator_scopes s
      where s.user_id = u.user_id
        and (s.expires_at is null or s.expires_at > now())
      order by case s.role
        when 'owner' then 1 when 'admin' then 2
        when 'moderator' then 3 else 4
      end
      limit 1
    )
  ) into result
  from public.user_profiles u
  left join public.community_profiles cp on cp.user_id = u.user_id
  where u.user_id = p_user_id;

  if result is null then raise exception 'Profil introuvable'; end if;
  return result;
end;
$$;

revoke all on function public.community_public_profile(uuid) from public, anon;
grant execute on function public.community_public_profile(uuid) to authenticated;

comment on function public.community_public_profile(uuid) is
  'Authenticated public profile. Contribution totals include only public, non-deleted forum statuses and are viewer-independent.';
