-- Relais push (messages, réponses, mentions) : le trigger insère toujours la
-- notification interne, puis déclenche un appel HTTP asynchrone (pg_net) vers
-- l'edge function send_push_notification pour réveiller le téléphone.
-- Les réactions/likes ne sont volontairement jamais branchées sur ce relais.

create extension if not exists pg_net with schema extensions;

create table if not exists public.push_dispatch_config (
  singleton boolean primary key default true check (singleton),
  invocation_token text not null,
  updated_at timestamptz not null default now()
);
insert into public.push_dispatch_config (singleton, invocation_token)
values (true, encode(gen_random_bytes(32), 'hex'))
on conflict (singleton) do nothing;

alter table public.push_dispatch_config enable row level security;
revoke all on public.push_dispatch_config from anon, authenticated;

alter table public.community_comments
  add column if not exists mentioned_user_ids uuid[] not null default '{}';
alter table public.community_comments
  add constraint community_comments_mentions_limit
  check (array_length(mentioned_user_ids, 1) is null or array_length(mentioned_user_ids, 1) <= 20);

alter table public.community_messages
  add column if not exists mentioned_user_ids uuid[] not null default '{}';
alter table public.community_messages
  add constraint community_messages_mentions_limit
  check (array_length(mentioned_user_ids, 1) is null or array_length(mentioned_user_ids, 1) <= 20);

create or replace function public.community_dispatch_push(p_notification_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_token text;
begin
  select invocation_token into v_token from public.push_dispatch_config where singleton;
  if v_token is null then
    return;
  end if;
  perform net.http_post(
    url := 'https://nuoonagnkhbeeymtvrcn.supabase.co/functions/v1/send_push_notification',
    headers := jsonb_build_object('Content-Type', 'application/json'),
    body := jsonb_build_object('token', v_token, 'notification_id', p_notification_id),
    timeout_milliseconds := 8000
  );
exception when others then
  -- Un souci d'envoi push ne doit jamais faire échouer le message/commentaire.
  null;
end;
$$;

revoke all on function public.community_dispatch_push(uuid) from public, anon, authenticated;

create or replace function public.community_message_notification_trigger()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  v_mentioned uuid[] := coalesce(new.mentioned_user_ids, '{}');
  v_rec record;
begin
  for v_rec in
    insert into public.community_notifications(recipient_id, actor_id, space_id, type, target_type, target_id, payload)
    select m.user_id, new.sender_id, r.space_id,
      case when m.user_id = any(v_mentioned) then 'mention' else 'message' end,
      'room', new.room_id, jsonb_build_object('message_id', new.id)
    from public.community_room_members m
    join public.community_rooms r on r.id = m.room_id
    where m.room_id = new.room_id and m.user_id <> new.sender_id and m.left_at is null
      and not exists (select 1 from public.community_blocks b where b.blocker_id = m.user_id and b.blocked_id = new.sender_id)
    returning id
  loop
    perform public.community_dispatch_push(v_rec.id);
  end loop;
  return new;
end $$;

create or replace function public.community_comment_notification_trigger()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  v_post_author uuid; v_parent_author uuid; v_space text;
  v_mentioned uuid[] := coalesce(new.mentioned_user_ids, '{}');
  v_notified uuid[] := '{}';
  v_new_id uuid;
  v_rec record;
begin
  select p.author_id, p.space_id into v_post_author, v_space
  from public.community_posts p where p.id = new.post_id;

  if new.parent_id is not null then
    select c.author_id into v_parent_author
    from public.community_comments c where c.id = new.parent_id and c.post_id = new.post_id;

    if v_parent_author is not null and v_parent_author <> new.author_id
      and not (v_parent_author = any(v_mentioned))
      and not exists (select 1 from public.community_blocks b where b.blocker_id = v_parent_author and b.blocked_id = new.author_id)
    then
      insert into public.community_notifications(recipient_id, actor_id, space_id, type, target_type, target_id, payload)
      values (v_parent_author, new.author_id, v_space, 'comment_reply', 'post', new.post_id,
              jsonb_build_object('comment_id', new.id, 'parent_id', new.parent_id))
      returning id into v_new_id;
      perform public.community_dispatch_push(v_new_id);
      v_notified := v_notified || v_parent_author;
    end if;
  end if;

  if v_post_author <> new.author_id and v_post_author is distinct from v_parent_author
    and not (v_post_author = any(v_mentioned))
    and not exists (select 1 from public.community_blocks b where b.blocker_id = v_post_author and b.blocked_id = new.author_id)
  then
    insert into public.community_notifications(recipient_id, actor_id, space_id, type, target_type, target_id)
    values (v_post_author, new.author_id, v_space, 'post_reply', 'post', new.post_id)
    returning id into v_new_id;
    perform public.community_dispatch_push(v_new_id);
    v_notified := v_notified || v_post_author;
  end if;

  if array_length(v_mentioned, 1) > 0 then
    for v_rec in
      insert into public.community_notifications(recipient_id, actor_id, space_id, type, target_type, target_id, payload)
      select mentioned_id, new.author_id, v_space, 'mention', 'post', new.post_id, jsonb_build_object('comment_id', new.id)
      from unnest(v_mentioned) as mentioned_id
      where mentioned_id <> new.author_id
        and not (mentioned_id = any(v_notified))
        and not exists (select 1 from public.community_blocks b where b.blocker_id = mentioned_id and b.blocked_id = new.author_id)
      returning id
    loop
      perform public.community_dispatch_push(v_rec.id);
    end loop;
  end if;

  return new;
end
$$;
