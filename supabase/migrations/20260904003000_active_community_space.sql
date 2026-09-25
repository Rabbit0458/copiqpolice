begin;

alter table public.community_spaces
  drop constraint if exists community_spaces_id_check;
alter table public.community_spaces
  add constraint community_spaces_id_check
  check (id in ('global','pa_exam','gpx_exam','pa_school','gpx_school','active'));

insert into public.community_spaces(id,label,description,color_hex,icon_key,sort_order,is_active)
values ('active','Policiers actifs','Espace professionnel réservé aux gardiens de la paix en activité','#1769E8','verified',50,true)
on conflict (id) do update set
  label=excluded.label,
  description=excluded.description,
  color_hex=excluded.color_hex,
  icon_key=excluded.icon_key,
  sort_order=excluded.sort_order,
  is_active=excluded.is_active;

insert into public.community_categories(space_id,slug,label,description,icon_key,sort_order,posting_role)
values
  ('active','actualites-service','Actualités du service','Échanges sur l’actualité et la vie des services.','campaign',0,'user'),
  ('active','pratiques-professionnelles','Pratiques professionnelles','Retours d’expérience et échanges entre policiers actifs.','shield',10,'user'),
  ('active','entraide','Entraide entre collègues','Questions et entraide réservées aux policiers actifs.','groups',20,'user'),
  ('active','formation-continue','Formation continue','Révisions, formations et évolutions professionnelles.','school',30,'user'),
  ('active','mobilite-carriere','Mobilité et carrière','Affectations, examens professionnels et évolution de carrière.','badge',40,'user')
on conflict(space_id,slug) do update set
  label=excluded.label,
  description=excluded.description,
  icon_key=excluded.icon_key,
  sort_order=excluded.sort_order,
  posting_role=excluded.posting_role,
  is_active=true;

create or replace function public.active_community_access()
returns boolean
language sql
stable
security definer
set search_path=''
as $$
  select (select auth.uid()) is not null
    and exists (
      select 1
      from public.user_profiles profile
      join public.active_access_verifications access
        on access.user_id=profile.user_id and access.status='granted'
      where profile.user_id=(select auth.uid())
        and profile.user_mode='active'
        and profile.user_track='gpx'
    );
$$;
revoke all on function public.active_community_access() from public,anon;
grant execute on function public.active_community_access() to authenticated;

drop policy if exists community_spaces_read on public.community_spaces;
create policy community_spaces_read on public.community_spaces for select to authenticated using(
  (id<>'active' and is_active) or
  (id='active' and public.active_community_access()) or
  public.community_is_staff(id)
);

drop policy if exists community_categories_read on public.community_categories;
create policy community_categories_read on public.community_categories for select to authenticated using(
  (space_id<>'active' and is_active) or
  (space_id='active' and is_active and public.active_community_access()) or
  public.community_is_staff(space_id)
);

drop policy if exists community_memberships_own_read on public.community_memberships;
create policy community_memberships_own_read on public.community_memberships for select to authenticated using(
  (space_id<>'active' or public.active_community_access() or public.community_is_staff(space_id))
  and (user_id=(select auth.uid()) or public.community_is_staff(space_id))
);
drop policy if exists community_memberships_own_insert on public.community_memberships;
create policy community_memberships_own_insert on public.community_memberships for insert to authenticated with check(
  user_id=(select auth.uid()) and (space_id<>'active' or public.active_community_access())
);
drop policy if exists community_memberships_own_update on public.community_memberships;
create policy community_memberships_own_update on public.community_memberships for update to authenticated
using(user_id=(select auth.uid()) and (space_id<>'active' or public.active_community_access()))
with check(user_id=(select auth.uid()) and (space_id<>'active' or public.active_community_access()));

drop policy if exists community_posts_read on public.community_posts;
create policy community_posts_read on public.community_posts for select to authenticated using(
  (space_id<>'active' or public.active_community_access() or public.community_is_staff(space_id))
  and (
    (status in ('published','locked','archived') and not exists(
      select 1 from public.community_blocks block
      where block.blocker_id=(select auth.uid()) and block.blocked_id=author_id
    ))
    or author_id=(select auth.uid())
    or public.community_is_staff(space_id)
  )
);
drop policy if exists community_posts_insert on public.community_posts;
create policy community_posts_insert on public.community_posts for insert to authenticated with check(
  author_id=(select auth.uid())
  and (space_id<>'active' or public.active_community_access())
  and public.community_can_publish(space_id,'post')
  and exists(
    select 1 from public.community_categories category
    where category.id=category_id
      and category.space_id=community_posts.space_id
      and category.is_active
      and (category.posting_role='user' or public.community_is_staff(space_id,array[category.posting_role,'admin','owner']))
  )
);
drop policy if exists community_posts_owner_update on public.community_posts;
create policy community_posts_owner_update on public.community_posts for update to authenticated
using((space_id<>'active' or public.active_community_access() or public.community_is_staff(space_id)) and (author_id=(select auth.uid()) or public.community_is_staff(space_id)))
with check((space_id<>'active' or public.active_community_access() or public.community_is_staff(space_id)) and (author_id=(select auth.uid()) or public.community_is_staff(space_id)));

drop policy if exists community_comments_read on public.community_comments;
create policy community_comments_read on public.community_comments for select to authenticated using(
  ((select post.space_id from public.community_posts post where post.id=post_id)<>'active'
    or public.active_community_access()
    or public.community_is_staff((select post.space_id from public.community_posts post where post.id=post_id)))
  and (status='published' or author_id=(select auth.uid()) or public.community_is_staff((select post.space_id from public.community_posts post where post.id=post_id)))
);
drop policy if exists community_comments_insert on public.community_comments;
create policy community_comments_insert on public.community_comments for insert to authenticated with check(
  author_id=(select auth.uid())
  and ((select post.space_id from public.community_posts post where post.id=post_id)<>'active' or public.active_community_access())
  and public.community_can_publish((select post.space_id from public.community_posts post where post.id=post_id),'comment')
);
drop policy if exists community_comments_update on public.community_comments;
create policy community_comments_update on public.community_comments for update to authenticated
using(
  ((select post.space_id from public.community_posts post where post.id=post_id)<>'active' or public.active_community_access() or public.community_is_staff((select post.space_id from public.community_posts post where post.id=post_id)))
  and (author_id=(select auth.uid()) or public.community_is_staff((select post.space_id from public.community_posts post where post.id=post_id)))
)
with check(
  ((select post.space_id from public.community_posts post where post.id=post_id)<>'active' or public.active_community_access() or public.community_is_staff((select post.space_id from public.community_posts post where post.id=post_id)))
  and (author_id=(select auth.uid()) or public.community_is_staff((select post.space_id from public.community_posts post where post.id=post_id)))
);

drop policy if exists community_reactions_read on public.community_reactions;
create policy community_reactions_read on public.community_reactions for select to authenticated using(
  coalesce(
    (select post.space_id from public.community_posts post where post.id=post_id),
    (select post.space_id from public.community_comments comment join public.community_posts post on post.id=comment.post_id where comment.id=comment_id)
  )<>'active' or public.active_community_access()
);
drop policy if exists community_reactions_own_insert on public.community_reactions;
create policy community_reactions_own_insert on public.community_reactions for insert to authenticated with check(
  user_id=(select auth.uid()) and (
    coalesce(
      (select post.space_id from public.community_posts post where post.id=post_id),
      (select post.space_id from public.community_comments comment join public.community_posts post on post.id=comment.post_id where comment.id=comment_id)
    )<>'active' or public.active_community_access()
  )
);
drop policy if exists community_reactions_own_delete on public.community_reactions;
create policy community_reactions_own_delete on public.community_reactions for delete to authenticated using(
  user_id=(select auth.uid()) and (
    coalesce(
      (select post.space_id from public.community_posts post where post.id=post_id),
      (select post.space_id from public.community_comments comment join public.community_posts post on post.id=comment.post_id where comment.id=comment_id)
    )<>'active' or public.active_community_access()
  )
);

drop policy if exists community_bookmarks_own_all on public.community_bookmarks;
create policy community_bookmarks_own_all on public.community_bookmarks for all to authenticated
using(user_id=(select auth.uid()) and ((select post.space_id from public.community_posts post where post.id=post_id)<>'active' or public.active_community_access()))
with check(user_id=(select auth.uid()) and ((select post.space_id from public.community_posts post where post.id=post_id)<>'active' or public.active_community_access()));
drop policy if exists community_subscriptions_own_all on public.community_subscriptions;
create policy community_subscriptions_own_all on public.community_subscriptions for all to authenticated
using(user_id=(select auth.uid()) and ((select post.space_id from public.community_posts post where post.id=post_id)<>'active' or public.active_community_access()))
with check(user_id=(select auth.uid()) and ((select post.space_id from public.community_posts post where post.id=post_id)<>'active' or public.active_community_access()));

commit;
