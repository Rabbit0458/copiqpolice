-- Une réponse ne peut cibler qu'un commentaire publié du même post.
drop policy if exists community_comments_insert on public.community_comments;
create policy community_comments_insert
on public.community_comments
for insert
to authenticated
with check (
  author_id = (select auth.uid())
  and public.community_can_publish(
    (select p.space_id from public.community_posts p where p.id = post_id),
    'comment'
  )
  and (
    parent_id is null
    or exists (
      select 1
      from public.community_comments parent
      where parent.id = parent_id
        and parent.post_id = post_id
        and parent.status = 'published'
    )
  )
);

-- Une réponse ciblée prévient l'auteur du commentaire. L'auteur du post reste
-- prévenu, sans doublon lorsqu'il s'agit de la même personne.
create or replace function public.community_comment_notification_trigger()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_post_author uuid;
  v_parent_author uuid;
  v_space text;
begin
  select p.author_id, p.space_id
  into v_post_author, v_space
  from public.community_posts p
  where p.id = new.post_id;

  if new.parent_id is not null then
    select c.author_id
    into v_parent_author
    from public.community_comments c
    where c.id = new.parent_id and c.post_id = new.post_id;

    if v_parent_author is not null
      and v_parent_author <> new.author_id
      and not exists (
        select 1 from public.community_blocks b
        where b.blocker_id = v_parent_author and b.blocked_id = new.author_id
      )
    then
      insert into public.community_notifications(
        recipient_id, actor_id, space_id, type, target_type, target_id, payload
      ) values (
        v_parent_author, new.author_id, v_space, 'comment_reply', 'post',
        new.post_id, jsonb_build_object('comment_id', new.id, 'parent_id', new.parent_id)
      );
    end if;
  end if;

  if v_post_author <> new.author_id
    and v_post_author is distinct from v_parent_author
    and not exists (
      select 1 from public.community_blocks b
      where b.blocker_id = v_post_author and b.blocked_id = new.author_id
    )
  then
    insert into public.community_notifications(
      recipient_id, actor_id, space_id, type, target_type, target_id
    ) values (
      v_post_author, new.author_id, v_space, 'post_reply', 'post', new.post_id
    );
  end if;

  return new;
end
$$;

revoke all on function public.community_comment_notification_trigger()
from public, anon, authenticated;
