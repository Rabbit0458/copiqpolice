-- Runtime operations that must be atomic and cannot safely be assembled by a client.

create or replace function public.community_get_or_create_direct_room(p_other_user_id uuid,p_client_id uuid)
returns uuid language plpgsql security definer set search_path='' as $$
declare v_me uuid:=(select auth.uid()); v_room uuid;
begin
 if v_me is null or p_other_user_id is null or v_me=p_other_user_id then raise exception 'Participants invalides' using errcode='22023'; end if;
 if not exists(select 1 from auth.users where id=p_other_user_id) then raise exception 'Utilisateur introuvable'; end if;
 if exists(select 1 from public.community_blocks b where (b.blocker_id=v_me and b.blocked_id=p_other_user_id) or (b.blocker_id=p_other_user_id and b.blocked_id=v_me)) then
  raise exception 'Conversation indisponible' using errcode='42501';
 end if;
 select r.id into v_room from public.community_rooms r
 where r.kind='direct' and exists(select 1 from public.community_room_members a where a.room_id=r.id and a.user_id=v_me and a.left_at is null)
 and exists(select 1 from public.community_room_members b where b.room_id=r.id and b.user_id=p_other_user_id and b.left_at is null)
 and (select count(*) from public.community_room_members m where m.room_id=r.id and m.left_at is null)=2 limit 1;
 if v_room is not null then return v_room; end if;
 insert into public.community_rooms(client_id,created_by,kind) values(p_client_id,v_me,'direct')
 on conflict(created_by,client_id) do update set updated_at=now() returning id into v_room;
 insert into public.community_room_members(room_id,user_id,role) values(v_room,v_me,'owner'),(v_room,p_other_user_id,'member') on conflict(room_id,user_id) do update set left_at=null;
 return v_room;
end $$;

create or replace function public.community_mark_room_read(p_room_id uuid,p_message_id uuid default null)
returns void language plpgsql security invoker set search_path='' as $$
begin
 update public.community_room_members set last_read_message_id=p_message_id,last_read_at=now()
 where room_id=p_room_id and user_id=(select auth.uid()) and left_at is null;
 if not found then raise exception 'Conversation inaccessible' using errcode='42501'; end if;
end $$;

create or replace function public.community_notification_trigger() returns trigger
language plpgsql security definer set search_path='' as $$
declare v_author uuid; v_space text;
begin
 if tg_table_name='community_comments' then
  select p.author_id,p.space_id into v_author,v_space from public.community_posts p where p.id=new.post_id;
  if v_author<>new.author_id and not exists(select 1 from public.community_blocks b where b.blocker_id=v_author and b.blocked_id=new.author_id) then
   insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id)
   values(v_author,new.author_id,v_space,'post_reply','post',new.post_id);
  end if;
 elsif tg_table_name='community_reactions' and new.post_id is not null then
  select p.author_id,p.space_id into v_author,v_space from public.community_posts p where p.id=new.post_id;
  if v_author<>new.user_id then
   insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id,payload)
   values(v_author,new.user_id,v_space,'reaction','post',new.post_id,jsonb_build_object('kind',new.kind));
  end if;
 elsif tg_table_name='community_messages' then
  insert into public.community_notifications(recipient_id,actor_id,space_id,type,target_type,target_id,payload)
  select m.user_id,new.sender_id,r.space_id,'message','room',new.room_id,jsonb_build_object('message_id',new.id)
  from public.community_room_members m join public.community_rooms r on r.id=m.room_id
  where m.room_id=new.room_id and m.user_id<>new.sender_id and m.left_at is null
  and not exists(select 1 from public.community_blocks b where b.blocker_id=m.user_id and b.blocked_id=new.sender_id);
 end if;
 return new;
end $$;

create trigger community_comments_notify after insert on public.community_comments for each row execute function public.community_notification_trigger();
create trigger community_reactions_notify after insert on public.community_reactions for each row execute function public.community_notification_trigger();
create trigger community_messages_notify after insert on public.community_messages for each row execute function public.community_notification_trigger();

revoke all on function public.community_get_or_create_direct_room(uuid,uuid) from public,anon;
revoke all on function public.community_mark_room_read(uuid,uuid) from public,anon;
revoke all on function public.community_notification_trigger() from public,anon,authenticated;
grant execute on function public.community_get_or_create_direct_room(uuid,uuid),public.community_mark_room_read(uuid,uuid) to authenticated;
