alter table public.community_profiles
  add column if not exists show_display_name boolean not null default true;

create or replace function public.community_public_identities(p_user_ids uuid[])
returns setof jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    raise exception 'Connexion requise' using errcode = '42501';
  end if;
  if coalesce(cardinality(p_user_ids), 0) > 100 then
    raise exception 'Trop de profils demandés' using errcode = '22023';
  end if;

  return query
  select jsonb_build_object(
    'user_id', u.user_id,
    'username', coalesce(nullif(trim(u.username), ''), 'membre'),
    'display_name', case
      when coalesce(cp.show_display_name, true)
        then coalesce(nullif(trim(concat_ws(' ', u.first_name, u.last_name)), ''),
                      nullif(trim(u.username), ''), 'Membre COP’IQ')
      else coalesce(nullif(trim(u.username), ''), 'Membre COP’IQ')
    end,
    'avatar_index', coalesce(u.avatar_index, 0),
    'badge_type', b.badge_type
  )
  from public.user_profiles u
  left join public.community_profiles cp on cp.user_id = u.user_id
  left join public.get_public_profile_badges(p_user_ids) b on b.user_id = u.user_id
  where u.user_id = any(p_user_ids)
    and not exists (
      select 1 from public.community_blocks block
      where (block.blocker_id = (select auth.uid()) and block.blocked_id = u.user_id)
         or (block.blocker_id = u.user_id and block.blocked_id = (select auth.uid()))
    );
end;
$$;

create or replace function public.community_public_profile(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;begin
 if (select auth.uid()) is null then raise exception 'Connexion requise' using errcode='42501';end if;
 if exists(select 1 from public.community_blocks b where (b.blocker_id=(select auth.uid()) and b.blocked_id=p_user_id) or (b.blocker_id=p_user_id and b.blocked_id=(select auth.uid()))) then raise exception 'Profil indisponible' using errcode='42501';end if;
 select jsonb_build_object(
  'user_id',u.user_id,'username',coalesce(nullif(trim(u.username),''),'membre'),
  'display_name',case when coalesce(cp.show_display_name,true) then coalesce(nullif(trim(concat_ws(' ',u.first_name,u.last_name)),''),nullif(trim(u.username),''),'Membre COP’IQ') else coalesce(nullif(trim(u.username),''),'Membre COP’IQ') end,
  'show_display_name',coalesce(cp.show_display_name,true),
  'avatar_index',u.avatar_index,'bio',coalesce(cp.bio,''),
  'joined_at',case when coalesce(cp.show_joined_at,true) then u.created_at else null end,
  'primary_space',case when coalesce(cp.show_spaces,true) then (select m.space_id from public.community_memberships m where m.user_id=u.user_id and m.is_primary and m.status='active' limit 1) else null end,
  'post_count',case when coalesce(cp.show_activity,true) then (select count(*) from public.community_posts p where p.author_id=u.user_id and p.status in ('published','locked','archived')) else null end,
  'comment_count',case when coalesce(cp.show_activity,true) then (select count(*) from public.community_comments c where c.author_id=u.user_id and c.status='published') else null end,
  'solutions_count',case when coalesce(cp.show_activity,true) then (select count(*) from public.community_comments c where c.author_id=u.user_id and c.is_solution and c.status='published') else null end,
  'staff_role',(select s.role from public.community_moderator_scopes s where s.user_id=u.user_id and (s.expires_at is null or s.expires_at>now()) order by case s.role when 'owner' then 1 when 'admin' then 2 when 'moderator' then 3 else 4 end limit 1)
 ) into result from public.user_profiles u left join public.community_profiles cp on cp.user_id=u.user_id where u.user_id=p_user_id;
 if result is null then raise exception 'Profil introuvable';end if;return result;
end $$;

create or replace function public.community_search_profiles(p_query text,p_limit integer default 20)
returns setof jsonb language sql stable security definer set search_path='' as $$
 select public.community_public_profile(u.user_id) from public.user_profiles u
 where char_length(trim(p_query))>=2
 and concat_ws(' ',coalesce(u.first_name,''),coalesce(u.last_name,''),coalesce(u.username,'')) ilike '%'||replace(replace(trim(p_query),'%','\%'),'_','\_')||'%' escape '\'
 and u.user_id<>(select auth.uid())
 and not exists(select 1 from public.community_blocks b where (b.blocker_id=(select auth.uid()) and b.blocked_id=u.user_id) or (b.blocker_id=u.user_id and b.blocked_id=(select auth.uid())))
 order by case when lower(coalesce(u.username,''))=lower(trim(p_query)) then 0 else 1 end,u.username limit least(greatest(p_limit,1),30);
$$;

revoke all on function public.community_public_identities(uuid[]) from public, anon;
grant execute on function public.community_public_identities(uuid[]) to authenticated;
revoke all on function public.community_public_profile(uuid), public.community_search_profiles(text,integer) from public, anon;
grant execute on function public.community_public_profile(uuid), public.community_search_profiles(text,integer) to authenticated;
