-- Rich messaging inbox + user-controlled community notification mute.

create table if not exists public.community_notification_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  enabled boolean not null default true,
  messages_enabled boolean not null default true,
  forum_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.community_notification_preferences enable row level security;

drop policy if exists community_notification_preferences_read on public.community_notification_preferences;
create policy community_notification_preferences_read
on public.community_notification_preferences for select to authenticated
using (user_id = (select auth.uid()));

drop policy if exists community_notification_preferences_insert on public.community_notification_preferences;
create policy community_notification_preferences_insert
on public.community_notification_preferences for insert to authenticated
with check (user_id = (select auth.uid()));

drop policy if exists community_notification_preferences_update on public.community_notification_preferences;
create policy community_notification_preferences_update
on public.community_notification_preferences for update to authenticated
using (user_id = (select auth.uid()))
with check (user_id = (select auth.uid()));

revoke all on public.community_notification_preferences from public, anon;
grant select, insert, update on public.community_notification_preferences to authenticated;

create or replace function public.community_notification_preferences_touch()
returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end;
$$;
drop trigger if exists community_notification_preferences_touch
  on public.community_notification_preferences;
create trigger community_notification_preferences_touch
before update on public.community_notification_preferences
for each row execute function public.community_notification_preferences_touch();
revoke all on function public.community_notification_preferences_touch()
  from public, anon, authenticated;

create or replace function public.community_my_rooms()
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

  return query
  select jsonb_build_object(
    'id', r.id,
    'title', case when r.kind = 'direct'
      then coalesce(nullif(trim(concat_ws(' ', u.first_name, u.last_name)), ''),
                    nullif(trim(u.username), ''), 'Membre COP’IQ')
      else coalesce(nullif(trim(r.title), ''), 'Conversation') end,
    'space_id', coalesce(r.space_id, 'global'),
    'updated_at', r.updated_at,
    'other_user_id', other_member.user_id,
    'other_username', coalesce(nullif(trim(u.username), ''), 'membre'),
    'other_avatar_index', coalesce(u.avatar_index, 0),
    'last_message', coalesce(last_message.content, ''),
    'last_message_at', last_message.created_at,
    'unread_count', (
      select count(*) from public.community_messages unread
      where unread.room_id = r.id
        and unread.sender_id <> (select auth.uid())
        and unread.status = 'published'
        and unread.created_at > coalesce(me.last_read_at, me.joined_at)
    )
  )
  from public.community_room_members me
  join public.community_rooms r on r.id = me.room_id
  left join lateral (
    select member.user_id
    from public.community_room_members member
    where member.room_id = r.id
      and member.user_id <> (select auth.uid())
      and member.left_at is null
    order by member.joined_at
    limit 1
  ) other_member on true
  left join public.user_profiles u on u.user_id = other_member.user_id
  left join lateral (
    select msg.content, msg.created_at
    from public.community_messages msg
    where msg.room_id = r.id and msg.status = 'published'
    order by msg.created_at desc, msg.id desc
    limit 1
  ) last_message on true
  where me.user_id = (select auth.uid()) and me.left_at is null
  order by coalesce(last_message.created_at, r.updated_at) desc;
end;
$$;

revoke all on function public.community_my_rooms() from public, anon;
grant execute on function public.community_my_rooms() to authenticated;

comment on table public.community_notification_preferences is
  'Per-user community alert preferences. Notifications remain in the in-app center while alerts can be muted.';
comment on function public.community_my_rooms() is
  'Returns only the caller rooms enriched with the other public identity, latest message and unread count.';
