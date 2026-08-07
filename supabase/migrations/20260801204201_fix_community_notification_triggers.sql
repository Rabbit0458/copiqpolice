drop trigger if exists community_comments_notify on public.community_comments;
drop trigger if exists community_reactions_notify on public.community_reactions;
drop trigger if exists community_messages_notify on public.community_messages;
drop function if exists public.community_notification_trigger();

create function public.community_comment_notification_trigger() returns trigger language plpgsql security definer set search_path='' as $$
declare v_author uuid;v_space text;begin
 select p.author_id,p.space_id into v_author,v_space from public.community_posts p where p.id=new.post_id;
 if v_author<>new.author_id and not exists(select 1 from public.community_blocks b where b.blocker_id=v_author and b.blocked_id=new.author_id) then
  insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id) values(v_author,new.author_id,v_space,'post_reply','post',new.post_id);
 end if;return new;end $$;

create function public.community_reaction_notification_trigger() returns trigger language plpgsql security definer set search_path='' as $$
declare v_author uuid;v_space text;begin
 if new.post_id is not null then
  select p.author_id,p.space_id into v_author,v_space from public.community_posts p where p.id=new.post_id;
  if v_author<>new.user_id then insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id,payload) values(v_author,new.user_id,v_space,'reaction','post',new.post_id,jsonb_build_object('kind',new.kind));end if;
 end if;return new;end $$;

create function public.community_message_notification_trigger() returns trigger language plpgsql security definer set search_path='' as $$
begin
 insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id,payload)
 select m.user_id,new.sender_id,r.space_id,'message','room',new.room_id,jsonb_build_object('message_id',new.id)
 from public.community_room_members m join public.community_rooms r on r.id=m.room_id
 where m.room_id=new.room_id and m.user_id<>new.sender_id and m.left_at is null
 and not exists(select 1 from public.community_blocks b where b.blocker_id=m.user_id and b.blocked_id=new.sender_id);
 return new;end $$;

create trigger community_comments_notify after insert on public.community_comments for each row execute function public.community_comment_notification_trigger();
create trigger community_reactions_notify after insert on public.community_reactions for each row execute function public.community_reaction_notification_trigger();
create trigger community_messages_notify after insert on public.community_messages for each row execute function public.community_message_notification_trigger();

revoke all on function public.community_comment_notification_trigger(),public.community_reaction_notification_trigger(),public.community_message_notification_trigger() from public,anon,authenticated;
