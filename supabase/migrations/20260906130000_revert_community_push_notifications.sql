-- Annule intégralement 20260906120000_community_push_notifications.sql :
-- retour aux triggers de notification interne d'origine, suppression du
-- relais push (config, colonnes de mentions, fonction de dispatch).
-- pg_net n'est pas désactivé : il est utilisé indépendamment par
-- official_police_calendar_sync.

create or replace function public.community_message_notification_trigger()
returns trigger language plpgsql security definer set search_path='' as $$
begin
 insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id,payload)
 select m.user_id,new.sender_id,r.space_id,'message','room',new.room_id,jsonb_build_object('message_id',new.id)
 from public.community_room_members m join public.community_rooms r on r.id=m.room_id
 where m.room_id=new.room_id and m.user_id<>new.sender_id and m.left_at is null
 and not exists(select 1 from public.community_blocks b where b.blocker_id=m.user_id and b.blocked_id=new.sender_id);
 return new;end $$;

create or replace function public.community_comment_notification_trigger()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  v_post_author uuid; v_parent_author uuid; v_space text;
begin
  select p.author_id, p.space_id into v_post_author, v_space
  from public.community_posts p where p.id = new.post_id;

  if new.parent_id is not null then
    select c.author_id into v_parent_author
    from public.community_comments c where c.id = new.parent_id and c.post_id = new.post_id;

    if v_parent_author is not null and v_parent_author <> new.author_id
      and not exists (select 1 from public.community_blocks b where b.blocker_id = v_parent_author and b.blocked_id = new.author_id)
    then
      insert into public.community_notifications(recipient_id, actor_id, space_id, type, target_type, target_id, payload)
      values (v_parent_author, new.author_id, v_space, 'comment_reply', 'post', new.post_id,
              jsonb_build_object('comment_id', new.id, 'parent_id', new.parent_id));
    end if;
  end if;

  if v_post_author <> new.author_id and v_post_author is distinct from v_parent_author
    and not exists (select 1 from public.community_blocks b where b.blocker_id = v_post_author and b.blocked_id = new.author_id)
  then
    insert into public.community_notifications(recipient_id, actor_id, space_id, type, target_type, target_id)
    values (v_post_author, new.author_id, v_space, 'post_reply', 'post', new.post_id);
  end if;

  return new;
end
$$;

drop function if exists public.community_dispatch_push(uuid);

alter table public.community_comments drop column if exists mentioned_user_ids;
alter table public.community_messages drop column if exists mentioned_user_ids;

drop table if exists public.push_dispatch_config;
