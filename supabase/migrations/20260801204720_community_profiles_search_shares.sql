create table public.community_profiles (
 user_id uuid primary key references auth.users(id) on delete cascade,
 bio text not null default '' check(char_length(bio)<=300),
 show_activity boolean not null default true,
 show_joined_at boolean not null default true,
 show_spaces boolean not null default true,
 created_at timestamptz not null default now(),updated_at timestamptz not null default now()
);
alter table public.community_profiles enable row level security;
create policy community_profiles_own_read on public.community_profiles for select to authenticated using(user_id=(select auth.uid()));
create policy community_profiles_own_insert on public.community_profiles for insert to authenticated with check(user_id=(select auth.uid()));
create policy community_profiles_own_update on public.community_profiles for update to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));

create table public.community_shares (
 id uuid primary key default gen_random_uuid(),client_id uuid not null,
 user_id uuid not null references auth.users(id) on delete cascade,
 post_id uuid not null references public.community_posts(id) on delete cascade,
 channel text not null check(channel in ('system','internal','copy_link')),
 created_at timestamptz not null default now(),unique(user_id,client_id)
);
create index community_shares_post_idx on public.community_shares(post_id,created_at desc);
alter table public.community_shares enable row level security;
create policy community_shares_own_read on public.community_shares for select to authenticated using(user_id=(select auth.uid()));

create or replace function public.community_public_profile(p_user_id uuid)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;begin
 if (select auth.uid()) is null then raise exception 'Connexion requise' using errcode='42501';end if;
 if exists(select 1 from public.community_blocks b where (b.blocker_id=(select auth.uid()) and b.blocked_id=p_user_id) or (b.blocker_id=p_user_id and b.blocked_id=(select auth.uid()))) then raise exception 'Profil indisponible' using errcode='42501';end if;
 select jsonb_build_object(
  'user_id',u.user_id,'username',coalesce(nullif(trim(u.username),''),'Membre COP’IQ'),
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
 where char_length(trim(p_query))>=2 and coalesce(u.username,'') ilike '%'||replace(replace(trim(p_query),'%','\%'),'_','\_')||'%' escape '\'
 and u.user_id<>(select auth.uid())
 and not exists(select 1 from public.community_blocks b where (b.blocker_id=(select auth.uid()) and b.blocked_id=u.user_id) or (b.blocker_id=u.user_id and b.blocked_id=(select auth.uid())))
 order by case when lower(coalesce(u.username,''))=lower(trim(p_query)) then 0 else 1 end,u.username limit least(greatest(p_limit,1),30);
$$;

create or replace function public.community_search_posts(p_query text,p_space_id text default null,p_before timestamptz default null,p_limit integer default 20)
returns setof public.community_posts language sql stable security invoker set search_path='' as $$
 select p.* from public.community_posts p where p.status in ('published','locked')
 and (p_space_id is null or p_space_id='global' or p.space_id=p_space_id)
 and (p_before is null or p.created_at<p_before)
 and char_length(trim(p_query))>=2
 and to_tsvector('french',p.title||' '||p.content) @@ websearch_to_tsquery('french',trim(p_query))
 order by ts_rank_cd(to_tsvector('french',p.title||' '||p.content),websearch_to_tsquery('french',trim(p_query))) desc,p.created_at desc,p.id desc
 limit least(greatest(p_limit,1),50);
$$;

create or replace function public.community_toggle_subscription(p_post_id uuid,p_level text default 'all')
returns boolean language plpgsql security invoker set search_path='' as $$
declare removed boolean:=false;begin
 if p_level not in ('all','important','none') then raise exception 'Niveau invalide';end if;
 delete from public.community_subscriptions where user_id=(select auth.uid()) and post_id=p_post_id;
 if found then removed:=true;else insert into public.community_subscriptions(user_id,post_id,level) values((select auth.uid()),p_post_id,p_level);end if;
 return not removed;
end $$;

create or replace function public.community_record_share(p_post_id uuid,p_client_id uuid,p_channel text)
returns integer language plpgsql security definer set search_path='' as $$
declare total integer;begin
 if (select auth.uid()) is null or p_channel not in ('system','internal','copy_link') then raise exception 'Partage invalide';end if;
 if not exists(select 1 from public.community_posts p where p.id=p_post_id and p.status in ('published','locked')) then raise exception 'Publication indisponible';end if;
 insert into public.community_shares(client_id,user_id,post_id,channel) values(p_client_id,(select auth.uid()),p_post_id,p_channel) on conflict(user_id,client_id) do nothing;
 select count(*) into total from public.community_shares where post_id=p_post_id;
 update public.community_posts set share_count=total where id=p_post_id;
 return total;
end $$;

create or replace function public.community_comment_notification_trigger() returns trigger language plpgsql security definer set search_path='' as $$
declare v_author uuid;v_space text;begin
 select p.author_id,p.space_id into v_author,v_space from public.community_posts p where p.id=new.post_id;
 if v_author<>new.author_id and not exists(select 1 from public.community_blocks b where b.blocker_id=v_author and b.blocked_id=new.author_id) then
  insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id) values(v_author,new.author_id,v_space,'post_reply','post',new.post_id);
 end if;
 insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id)
 select s.user_id,new.author_id,v_space,'followed_post_reply','post',new.post_id from public.community_subscriptions s
 where s.post_id=new.post_id and s.level<>'none' and s.user_id not in(new.author_id,v_author)
 and not exists(select 1 from public.community_blocks b where b.blocker_id=s.user_id and b.blocked_id=new.author_id);
 return new;end $$;

revoke all on table public.community_profiles,public.community_shares from anon,authenticated;
grant select,insert,update on public.community_profiles to authenticated;
grant select on public.community_shares to authenticated;
revoke all on function public.community_public_profile(uuid),public.community_search_profiles(text,integer),public.community_search_posts(text,text,timestamptz,integer),public.community_toggle_subscription(uuid,text),public.community_record_share(uuid,uuid,text) from public,anon;
grant execute on function public.community_public_profile(uuid),public.community_search_profiles(text,integer),public.community_search_posts(text,text,timestamptz,integer),public.community_toggle_subscription(uuid,text),public.community_record_share(uuid,uuid,text) to authenticated;
revoke all on function public.community_comment_notification_trigger() from public,anon,authenticated;
