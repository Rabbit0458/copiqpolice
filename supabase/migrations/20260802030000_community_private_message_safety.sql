-- COP'IQ — Safety-by-design for private community messaging.
-- Moderators cannot browse rooms. A report freezes only the reported message
-- and a bounded context (3 before / 3 after); every evidence access is audited.

alter table public.community_reports
  add column if not exists room_id uuid references public.community_rooms(id) on delete set null,
  add column if not exists subject_user_id uuid references auth.users(id) on delete restrict,
  add column if not exists priority text not null default 'normal'
    check (priority in ('normal','high','urgent')),
  add column if not exists acknowledged_at timestamptz,
  add column if not exists appeal_text text check (char_length(appeal_text) <= 2000),
  add column if not exists appealed_at timestamptz;

create table if not exists public.community_message_report_evidence (
  report_id uuid not null references public.community_reports(id) on delete cascade,
  position smallint not null check (position between 1 and 7),
  source_message_id uuid,
  sender_id uuid not null references auth.users(id) on delete restrict,
  content text not null check (char_length(content) <= 5000),
  source_created_at timestamptz not null,
  captured_at timestamptz not null default now(),
  primary key (report_id, position)
);

alter table public.community_message_report_evidence enable row level security;
revoke all on public.community_message_report_evidence from public, anon, authenticated;
grant select, insert, update, delete on public.community_message_report_evidence to service_role;

create index if not exists community_reports_message_queue_idx
  on public.community_reports(priority, status, created_at)
  where target_type = 'message';

create or replace function public.community_report_message(
  p_message_id uuid,
  p_reason text,
  p_details text default null
) returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := (select auth.uid());
  v_message public.community_messages%rowtype;
  v_space text;
  v_report uuid;
  v_priority text;
begin
  if v_me is null then
    raise exception 'Connexion requise' using errcode = '42501';
  end if;
  if p_reason not in ('spam','harassment','hate','threat','sexual','personal_data','fraud','impersonation','advertising','dangerous_misinformation','off_topic','other') then
    raise exception 'Motif invalide' using errcode = '22023';
  end if;
  if p_details is not null and char_length(trim(p_details)) > 2000 then
    raise exception 'Détails trop longs' using errcode = '22023';
  end if;

  select m.* into v_message
  from public.community_messages m
  where m.id = p_message_id;
  if not found or not public.community_is_room_member(v_message.room_id) then
    raise exception 'Message inaccessible' using errcode = '42501';
  end if;
  if v_message.sender_id = v_me then
    raise exception 'Vous ne pouvez pas signaler votre propre message' using errcode = '22023';
  end if;

  select coalesce(r.space_id, 'global') into v_space
  from public.community_rooms r where r.id = v_message.room_id;
  v_priority := case
    when p_reason in ('threat','sexual') then 'urgent'
    when p_reason in ('harassment','hate','personal_data') then 'high'
    else 'normal'
  end;

  select r.id into v_report
  from public.community_reports r
  where r.reporter_id = v_me and r.target_type = 'message'
    and r.target_id = p_message_id
    and r.status in ('new','triaged','in_progress')
  limit 1;
  if v_report is not null then return v_report; end if;

  insert into public.community_reports(
    reporter_id, space_id, target_type, target_id, reason, details,
    room_id, subject_user_id, priority
  ) values (
    v_me, v_space, 'message', p_message_id, p_reason, nullif(trim(p_details), ''),
    v_message.room_id, v_message.sender_id, v_priority
  ) returning id into v_report;

  insert into public.community_message_report_evidence(
    report_id, position, source_message_id, sender_id, content, source_created_at
  )
  select v_report, row_number() over(order by c.created_at, c.id)::smallint,
         c.id, c.sender_id, c.content, c.created_at
  from (
    (select m.id, m.sender_id, m.content, m.created_at
     from public.community_messages m
     where m.room_id = v_message.room_id
       and (m.created_at, m.id) < (v_message.created_at, v_message.id)
     order by m.created_at desc, m.id desc limit 3)
    union all
    select v_message.id, v_message.sender_id, v_message.content, v_message.created_at
    union all
    (select m.id, m.sender_id, m.content, m.created_at
     from public.community_messages m
     where m.room_id = v_message.room_id
       and (m.created_at, m.id) > (v_message.created_at, v_message.id)
     order by m.created_at, m.id limit 3)
  ) c;

  return v_report;
end;
$$;

create or replace function public.community_leave_room(p_room_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
begin
  update public.community_room_members
  set left_at = now()
  where room_id = p_room_id and user_id = (select auth.uid()) and left_at is null;
  if not found then raise exception 'Conversation inaccessible' using errcode = '42501'; end if;
end;
$$;

create or replace function public.community_block_room_member(
  p_room_id uuid,
  p_user_id uuid
) returns void language plpgsql security definer set search_path = '' as $$
declare v_me uuid := (select auth.uid());
begin
  if v_me is null or p_user_id is null or p_user_id = v_me then
    raise exception 'Utilisateur invalide' using errcode = '22023';
  end if;
  if not public.community_is_room_member(p_room_id)
     or not exists(select 1 from public.community_room_members m
                   where m.room_id = p_room_id and m.user_id = p_user_id and m.left_at is null) then
    raise exception 'Conversation inaccessible' using errcode = '42501';
  end if;
  insert into public.community_blocks(blocker_id, blocked_id)
  values(v_me, p_user_id) on conflict do nothing;
  update public.community_room_members set left_at = now()
  where room_id = p_room_id and user_id = v_me;
end;
$$;

create or replace function public.community_open_message_report(
  p_report_id uuid,
  p_access_reason text
) returns table(
  context_position smallint,
  message_id uuid,
  sender_id uuid,
  content text,
  created_at timestamptz,
  is_reported boolean
)
language plpgsql security definer set search_path = '' as $$
declare v_report public.community_reports%rowtype;
begin
  select * into v_report from public.community_reports where id = p_report_id;
  if not found or v_report.target_type <> 'message'
     or not public.community_is_staff(coalesce(v_report.space_id, 'global')) then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;
  if char_length(trim(coalesce(p_access_reason, ''))) < 10 then
    raise exception 'Motif de consultation obligatoire' using errcode = '22023';
  end if;

  insert into public.community_moderation_log(
    actor_id, space_id, action, target_type, target_id, reason, report_id
  ) values (
    (select auth.uid()), v_report.space_id, 'view_report_evidence', 'message',
    v_report.target_id::text, trim(p_access_reason), p_report_id
  );

  return query
  select e.position, e.source_message_id, e.sender_id, e.content,
         e.source_created_at, e.source_message_id = v_report.target_id
  from public.community_message_report_evidence e
  where e.report_id = p_report_id order by e.position;
end;
$$;

revoke all on function public.community_report_message(uuid,text,text) from public, anon;
revoke all on function public.community_leave_room(uuid) from public, anon;
revoke all on function public.community_block_room_member(uuid,uuid) from public, anon;
revoke all on function public.community_open_message_report(uuid,text) from public, anon;
grant execute on function public.community_report_message(uuid,text,text) to authenticated;
grant execute on function public.community_leave_room(uuid) to authenticated;
grant execute on function public.community_block_room_member(uuid,uuid) to authenticated;
grant execute on function public.community_open_message_report(uuid,text) to authenticated;

comment on table public.community_message_report_evidence is
  'Immutable bounded snapshots: reported private message plus at most three messages before and after. No direct client access.';
comment on function public.community_open_message_report(uuid,text) is
  'Only scoped staff may open bounded evidence; every access requires a reason and is audited.';
