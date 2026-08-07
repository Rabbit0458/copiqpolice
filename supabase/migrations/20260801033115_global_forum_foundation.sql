-- COP'IQ global community foundation.
-- Additive migration: legacy forum_*_exam_gpx tables are intentionally kept.

create extension if not exists pg_trgm with schema extensions;

create table if not exists public.community_spaces (
  id text primary key check (id in ('global','pa_exam','gpx_exam','pa_school','gpx_school')),
  label text not null,
  description text not null default '',
  color_hex text not null check (color_hex ~ '^#[0-9A-Fa-f]{6}$'),
  icon_key text not null,
  sort_order smallint not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

insert into public.community_spaces(id,label,description,color_hex,icon_key,sort_order) values
 ('global','Toute la communauté','Tous les espaces COP’IQ','#173B57','groups',0),
 ('pa_exam','PA Exam','Préparation au recrutement de policier adjoint','#E33D4F','shield',10),
 ('gpx_exam','GPX Exam','Préparation au concours de gardien de la paix','#2463EB','badge',20),
 ('pa_school','PA School','Formation initiale des policiers adjoints','#0F9F82','school',30),
 ('gpx_school','GPX School','Formation initiale des gardiens de la paix','#7C4DDB','academy',40)
on conflict (id) do update set label=excluded.label, description=excluded.description,
 color_hex=excluded.color_hex, icon_key=excluded.icon_key, sort_order=excluded.sort_order;

create table if not exists public.community_categories (
  id uuid primary key default gen_random_uuid(),
  space_id text not null references public.community_spaces(id),
  slug text not null,
  label text not null check (char_length(label) between 2 and 80),
  description text not null default '',
  icon_key text not null default 'chat',
  color_hex text,
  sort_order smallint not null default 0,
  posting_role text not null default 'user' check (posting_role in ('user','moderator','admin','owner')),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique(space_id,slug)
);

insert into public.community_categories(space_id,slug,label,sort_order,posting_role) values
 ('global','annonces','Annonces officielles',0,'admin'),
 ('global','copiq','Actualités COP’IQ',10,'admin'),
 ('global','entraide','Entraide générale',20,'user'),
 ('global','suggestions','Suggestions',30,'user'),
 ('pa_exam','psychotechniques','Tests psychotechniques',0,'user'),
 ('pa_exam','culture-generale','Culture générale',10,'user'),
 ('pa_exam','francais','Français',20,'user'),
 ('pa_exam','mathematiques-logique','Mathématiques et logique',30,'user'),
 ('pa_exam','entretien','Entretien',40,'user'),
 ('pa_exam','photolangage','Photolangage',50,'user'),
 ('pa_exam','sport','Sport',60,'user'),
 ('pa_exam','medical','Visite médicale',70,'user'),
 ('pa_exam','inscription-resultats','Inscriptions et résultats',80,'user'),
 ('pa_exam','retours','Retours d’expérience',90,'user'),
 ('gpx_exam','ecrits','Épreuves écrites',0,'user'),
 ('gpx_exam','cas-pratique','Cas pratique',10,'user'),
 ('gpx_exam','psychotechniques','Tests psychotechniques',20,'user'),
 ('gpx_exam','sport','Sport',30,'user'),
 ('gpx_exam','oral','Oral et jury',40,'user'),
 ('gpx_exam','administratif','Enquête, médical et inscriptions',50,'user'),
 ('gpx_exam','affectations','Affectations et résultats',60,'user'),
 ('pa_school','formation','Organisation de la formation',0,'user'),
 ('pa_school','cours-revisions','Cours et révisions',10,'user'),
 ('pa_school','evaluations','Évaluations',20,'user'),
 ('pa_school','sport','Sport',30,'user'),
 ('pa_school','vie-ecole','Vie en école',40,'user'),
 ('pa_school','stages-affectation','Stages et affectation',50,'user'),
 ('gpx_school','incorporation','Incorporation',0,'user'),
 ('gpx_school','cours-revisions','Cours et révisions',10,'user'),
 ('gpx_school','techniques','Techniques professionnelles',20,'user'),
 ('gpx_school','sport-tir','Sport et tir',30,'user'),
 ('gpx_school','vie-ecole','Vie en école',40,'user'),
 ('gpx_school','classement-affectation','Classement et affectation',50,'user')
on conflict(space_id,slug) do update set label=excluded.label,sort_order=excluded.sort_order,posting_role=excluded.posting_role;

create table if not exists public.community_memberships (
  user_id uuid not null references auth.users(id) on delete cascade,
  space_id text not null references public.community_spaces(id),
  is_primary boolean not null default false,
  status text not null default 'active' check(status in ('active','left','suspended')),
  notification_level text not null default 'important' check(notification_level in ('all','important','none')),
  joined_at timestamptz not null default now(),
  last_visited_at timestamptz,
  primary key(user_id,space_id)
);
create unique index if not exists community_one_primary_space on public.community_memberships(user_id) where is_primary and status='active';

create table if not exists public.community_posts (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null default gen_random_uuid(),
  author_id uuid not null references auth.users(id) on delete restrict,
  space_id text not null references public.community_spaces(id),
  category_id uuid not null references public.community_categories(id),
  type text not null default 'discussion' check(type in ('discussion','question','experience','poll','announcement')),
  title text not null check(char_length(title) between 10 and 120),
  content text not null check(char_length(content) between 20 and 10000),
  status text not null default 'published' check(status in ('draft','published','pending_review','hidden','locked','removed_by_moderator','deleted_by_author','archived')),
  is_pinned boolean not null default false,
  is_resolved boolean not null default false,
  solution_comment_id uuid,
  reaction_count integer not null default 0 check(reaction_count>=0),
  comment_count integer not null default 0 check(comment_count>=0),
  share_count integer not null default 0 check(share_count>=0),
  view_count integer not null default 0 check(view_count>=0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  edited_at timestamptz,
  deleted_at timestamptz,
  unique(author_id,client_id)
);

create table if not exists public.community_comments (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null default gen_random_uuid(),
  post_id uuid not null references public.community_posts(id) on delete cascade,
  author_id uuid not null references auth.users(id) on delete restrict,
  parent_id uuid references public.community_comments(id) on delete set null,
  content text not null check(char_length(content) between 1 and 5000),
  status text not null default 'published' check(status in ('published','pending_review','hidden','removed_by_moderator','deleted_by_author')),
  is_solution boolean not null default false,
  reaction_count integer not null default 0 check(reaction_count>=0),
  created_at timestamptz not null default now(),
  edited_at timestamptz,
  deleted_at timestamptz,
  unique(author_id,client_id)
);
alter table public.community_posts drop constraint if exists community_posts_solution_comment_id_fkey;
alter table public.community_posts add constraint community_posts_solution_comment_id_fkey foreign key(solution_comment_id) references public.community_comments(id) on delete set null;

create table if not exists public.community_reactions (
  user_id uuid not null references auth.users(id) on delete cascade,
  post_id uuid references public.community_posts(id) on delete cascade,
  comment_id uuid references public.community_comments(id) on delete cascade,
  kind text not null check(kind in ('like','useful')),
  created_at timestamptz not null default now(),
  check ((post_id is not null)::int + (comment_id is not null)::int = 1)
);
create unique index if not exists community_reaction_post_unique on public.community_reactions(user_id,post_id,kind) where post_id is not null;
create unique index if not exists community_reaction_comment_unique on public.community_reactions(user_id,comment_id,kind) where comment_id is not null;

create table if not exists public.community_bookmarks (
 user_id uuid not null references auth.users(id) on delete cascade,
 post_id uuid not null references public.community_posts(id) on delete cascade,
 created_at timestamptz not null default now(), primary key(user_id,post_id)
);
create table if not exists public.community_subscriptions (
 user_id uuid not null references auth.users(id) on delete cascade,
 post_id uuid not null references public.community_posts(id) on delete cascade,
 level text not null default 'all' check(level in ('all','important','none')),
 created_at timestamptz not null default now(), primary key(user_id,post_id)
);
create table if not exists public.community_blocks (
 blocker_id uuid not null references auth.users(id) on delete cascade,
 blocked_id uuid not null references auth.users(id) on delete cascade,
 created_at timestamptz not null default now(), primary key(blocker_id,blocked_id),
 check(blocker_id<>blocked_id)
);

create table if not exists public.community_rooms (
 id uuid primary key default gen_random_uuid(), client_id uuid not null default gen_random_uuid(),
 space_id text references public.community_spaces(id), created_by uuid not null references auth.users(id) on delete restrict,
 kind text not null default 'direct' check(kind in ('direct','group','official')),
 title text, description text, avatar_path text, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 unique(created_by,client_id)
);
create table if not exists public.community_room_members (
 room_id uuid not null references public.community_rooms(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 role text not null default 'member' check(role in ('owner','admin','member')),
 muted_until timestamptz, last_read_message_id uuid, last_read_at timestamptz,
 joined_at timestamptz not null default now(), left_at timestamptz, primary key(room_id,user_id)
);
create table if not exists public.community_messages (
 id uuid primary key default gen_random_uuid(), client_id uuid not null,
 room_id uuid not null references public.community_rooms(id) on delete cascade,
 sender_id uuid not null references auth.users(id) on delete restrict,
 reply_to_id uuid references public.community_messages(id) on delete set null,
 type text not null default 'text' check(type in ('text','image','post_share','system')),
 content text not null default '' check(char_length(content)<=5000), attachment_path text,
 status text not null default 'published' check(status in ('published','hidden','removed_by_moderator','deleted_by_author')),
 created_at timestamptz not null default now(), edited_at timestamptz, deleted_at timestamptz,
 unique(sender_id,client_id)
);
alter table public.community_room_members drop constraint if exists community_room_members_last_read_message_id_fkey;
alter table public.community_room_members add constraint community_room_members_last_read_message_id_fkey foreign key(last_read_message_id) references public.community_messages(id) on delete set null;

create table if not exists public.community_reports (
 id uuid primary key default gen_random_uuid(), reporter_id uuid not null references auth.users(id) on delete restrict,
 space_id text references public.community_spaces(id), target_type text not null check(target_type in ('post','comment','message','profile','attachment','room')),
 target_id uuid not null, reason text not null check(reason in ('spam','harassment','hate','threat','sexual','personal_data','fraud','impersonation','advertising','dangerous_misinformation','off_topic','other')),
 details text check(char_length(details)<=2000), status text not null default 'new' check(status in ('new','triaged','in_progress','resolved','rejected','appealed')),
 assigned_to uuid references auth.users(id), resolution text, created_at timestamptz not null default now(), resolved_at timestamptz
);
create unique index if not exists community_open_report_unique on public.community_reports(reporter_id,target_type,target_id) where status in ('new','triaged','in_progress');

create table if not exists public.community_sanctions (
 id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete restrict,
 space_id text references public.community_spaces(id), imposed_by uuid not null references auth.users(id) on delete restrict,
 kind text not null check(kind in ('warning','post_restriction','comment_restriction','message_restriction','suspension','ban')),
 reason text not null, starts_at timestamptz not null default now(), ends_at timestamptz,
 status text not null default 'active' check(status in ('active','expired','revoked','appealed')),
 created_at timestamptz not null default now(), revoked_at timestamptz, revoked_by uuid references auth.users(id)
);
create table if not exists public.community_moderator_scopes (
 user_id uuid not null references auth.users(id) on delete cascade, space_id text not null references public.community_spaces(id),
 role text not null check(role in ('helper','moderator','admin','owner')), granted_by uuid not null references auth.users(id),
 granted_at timestamptz not null default now(), expires_at timestamptz, primary key(user_id,space_id)
);
create table if not exists public.community_moderation_log (
 id bigint generated always as identity primary key, actor_id uuid not null references auth.users(id) on delete restrict,
 space_id text references public.community_spaces(id), action text not null, target_type text not null, target_id text not null,
 reason text not null, old_state jsonb, new_state jsonb, report_id uuid references public.community_reports(id),
 created_at timestamptz not null default now()
);
create table if not exists public.community_notifications (
 id uuid primary key default gen_random_uuid(), recipient_id uuid not null references auth.users(id) on delete cascade,
 actor_id uuid references auth.users(id) on delete set null, space_id text references public.community_spaces(id),
 type text not null, target_type text, target_id uuid, payload jsonb not null default '{}',
 created_at timestamptz not null default now(), read_at timestamptz
);

create index if not exists community_posts_feed_idx on public.community_posts(space_id,status,is_pinned desc,created_at desc,id desc);
create index if not exists community_posts_category_idx on public.community_posts(category_id,created_at desc);
create index if not exists community_posts_author_idx on public.community_posts(author_id,created_at desc);
create index if not exists community_posts_search_idx on public.community_posts using gin(to_tsvector('french',title||' '||content));
create index if not exists community_comments_post_idx on public.community_comments(post_id,created_at,id);
create index if not exists community_messages_room_idx on public.community_messages(room_id,created_at desc,id desc);
create index if not exists community_notifications_recipient_idx on public.community_notifications(recipient_id,read_at,created_at desc);
create index if not exists community_reports_queue_idx on public.community_reports(status,created_at);
create index if not exists community_sanctions_active_idx on public.community_sanctions(user_id,space_id,kind,ends_at) where status='active';

create or replace function public.community_is_staff(p_space_id text default 'global', p_roles text[] default array['moderator','admin','owner'])
returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.community_moderator_scopes s where s.user_id=(select auth.uid()) and s.role=any(p_roles)
 and s.space_id in ('global',p_space_id) and (s.expires_at is null or s.expires_at>now()));
$$;
revoke all on function public.community_is_staff(text,text[]) from public,anon;
grant execute on function public.community_is_staff(text,text[]) to authenticated;

create or replace function public.community_can_publish(p_space_id text, p_kind text default 'post')
returns boolean language sql stable security invoker set search_path='' as $$
 select (select auth.uid()) is not null and not exists(
  select 1 from public.community_sanctions s where s.user_id=(select auth.uid()) and s.status='active'
  and (s.space_id is null or s.space_id in ('global',p_space_id))
  and (s.ends_at is null or s.ends_at>now())
  and (s.kind in ('suspension','ban') or (p_kind='post' and s.kind='post_restriction') or (p_kind='comment' and s.kind='comment_restriction') or (p_kind='message' and s.kind='message_restriction'))
 );
$$;

create or replace function public.community_recount_post(p_post_id uuid) returns void
language plpgsql security definer set search_path='' as $$ begin
 update public.community_posts p set
  reaction_count=(select count(*) from public.community_reactions r where r.post_id=p_post_id),
  comment_count=(select count(*) from public.community_comments c where c.post_id=p_post_id and c.status='published'),
  updated_at=greatest(p.updated_at,now()) where p.id=p_post_id;
end $$;
revoke all on function public.community_recount_post(uuid) from public,anon,authenticated;

create or replace function public.community_is_room_member(p_room_id uuid,p_roles text[] default array['owner','admin','member'])
returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.community_room_members m where m.room_id=p_room_id
 and m.user_id=(select auth.uid()) and m.role=any(p_roles) and m.left_at is null);
$$;
revoke all on function public.community_is_room_member(uuid,text[]) from public,anon;
grant execute on function public.community_is_room_member(uuid,text[]) to authenticated;

create or replace function public.community_counts_trigger() returns trigger language plpgsql security definer set search_path='' as $$
begin perform public.community_recount_post(coalesce(new.post_id,old.post_id)); return coalesce(new,old); end $$;
create trigger community_comment_counts after insert or update of status or delete on public.community_comments for each row execute function public.community_counts_trigger();
create trigger community_reaction_counts after insert or delete on public.community_reactions for each row execute function public.community_counts_trigger();

create or replace function public.community_touch_updated_at() returns trigger language plpgsql set search_path='' as $$
begin new.updated_at=now(); if row(new.*) is distinct from row(old.*) then new.edited_at=now(); end if; return new; end $$;
create trigger community_posts_touch before update on public.community_posts for each row execute function public.community_touch_updated_at();

alter table public.community_spaces enable row level security;
alter table public.community_categories enable row level security;
alter table public.community_memberships enable row level security;
alter table public.community_posts enable row level security;
alter table public.community_comments enable row level security;
alter table public.community_reactions enable row level security;
alter table public.community_bookmarks enable row level security;
alter table public.community_subscriptions enable row level security;
alter table public.community_blocks enable row level security;
alter table public.community_rooms enable row level security;
alter table public.community_room_members enable row level security;
alter table public.community_messages enable row level security;
alter table public.community_reports enable row level security;
alter table public.community_sanctions enable row level security;
alter table public.community_moderator_scopes enable row level security;
alter table public.community_moderation_log enable row level security;
alter table public.community_notifications enable row level security;

create policy community_spaces_read on public.community_spaces for select to authenticated using(is_active or public.community_is_staff(id));
create policy community_categories_read on public.community_categories for select to authenticated using(is_active or public.community_is_staff(space_id));
create policy community_memberships_own_read on public.community_memberships for select to authenticated using(user_id=(select auth.uid()) or public.community_is_staff(space_id));
create policy community_memberships_own_insert on public.community_memberships for insert to authenticated with check(user_id=(select auth.uid()));
create policy community_memberships_own_update on public.community_memberships for update to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));

create policy community_posts_read on public.community_posts for select to authenticated using(
 (status in ('published','locked','archived') and not exists(
   select 1 from public.community_blocks b where b.blocker_id=(select auth.uid()) and b.blocked_id=author_id
 )) or author_id=(select auth.uid()) or public.community_is_staff(space_id));
create policy community_posts_insert on public.community_posts for insert to authenticated with check(
 author_id=(select auth.uid()) and public.community_can_publish(space_id,'post') and
 exists(select 1 from public.community_categories c where c.id=category_id and c.space_id=community_posts.space_id and c.is_active
   and (c.posting_role='user' or public.community_is_staff(space_id,array[c.posting_role,'admin','owner']))));
create policy community_posts_owner_update on public.community_posts for update to authenticated using(author_id=(select auth.uid()) or public.community_is_staff(space_id))
 with check(author_id=(select auth.uid()) or public.community_is_staff(space_id));

create policy community_comments_read on public.community_comments for select to authenticated using(status='published' or author_id=(select auth.uid()) or public.community_is_staff((select p.space_id from public.community_posts p where p.id=post_id)));
create policy community_comments_insert on public.community_comments for insert to authenticated with check(author_id=(select auth.uid()) and public.community_can_publish((select p.space_id from public.community_posts p where p.id=post_id),'comment'));
create policy community_comments_update on public.community_comments for update to authenticated using(author_id=(select auth.uid()) or public.community_is_staff((select p.space_id from public.community_posts p where p.id=post_id))) with check(author_id=(select auth.uid()) or public.community_is_staff((select p.space_id from public.community_posts p where p.id=post_id)));

create policy community_reactions_read on public.community_reactions for select to authenticated using(true);
create policy community_reactions_own_insert on public.community_reactions for insert to authenticated with check(user_id=(select auth.uid()));
create policy community_reactions_own_delete on public.community_reactions for delete to authenticated using(user_id=(select auth.uid()));
create policy community_bookmarks_own_all on public.community_bookmarks for all to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
create policy community_subscriptions_own_all on public.community_subscriptions for all to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
create policy community_blocks_own_all on public.community_blocks for all to authenticated using(blocker_id=(select auth.uid())) with check(blocker_id=(select auth.uid()));

create policy community_rooms_member_read on public.community_rooms for select to authenticated using(created_by=(select auth.uid()) or public.community_is_room_member(id));
create policy community_rooms_create on public.community_rooms for insert to authenticated with check(created_by=(select auth.uid()));
create policy community_room_members_read on public.community_room_members for select to authenticated using(user_id=(select auth.uid()) or public.community_is_room_member(room_id));
create policy community_room_members_manage on public.community_room_members for insert to authenticated with check(user_id=(select auth.uid()) or public.community_is_room_member(room_id,array['owner','admin']));
create policy community_room_members_update on public.community_room_members for update to authenticated using(user_id=(select auth.uid()) or public.community_is_room_member(room_id,array['owner','admin'])) with check(user_id=(select auth.uid()) or public.community_is_room_member(room_id,array['owner','admin']));
create policy community_messages_member_read on public.community_messages for select to authenticated using(public.community_is_room_member(room_id));
create policy community_messages_member_insert on public.community_messages for insert to authenticated with check(sender_id=(select auth.uid()) and public.community_can_publish(coalesce((select r.space_id from public.community_rooms r where r.id=room_id),'global'),'message') and public.community_is_room_member(room_id)
 and not exists(select 1 from public.community_room_members other join public.community_blocks b on b.blocker_id=other.user_id and b.blocked_id=(select auth.uid()) where other.room_id=community_messages.room_id and other.left_at is null));
create policy community_messages_owner_update on public.community_messages for update to authenticated using(sender_id=(select auth.uid())) with check(sender_id=(select auth.uid()));

create policy community_reports_own_read on public.community_reports for select to authenticated using(reporter_id=(select auth.uid()) or public.community_is_staff(coalesce(space_id,'global')));
create policy community_reports_own_insert on public.community_reports for insert to authenticated with check(reporter_id=(select auth.uid()));
create policy community_reports_staff_update on public.community_reports for update to authenticated using(public.community_is_staff(coalesce(space_id,'global'))) with check(public.community_is_staff(coalesce(space_id,'global')));
create policy community_sanctions_subject_read on public.community_sanctions for select to authenticated using(user_id=(select auth.uid()) or public.community_is_staff(coalesce(space_id,'global')));
create policy community_sanctions_staff_manage on public.community_sanctions for all to authenticated using(public.community_is_staff(coalesce(space_id,'global'),array['admin','owner'])) with check(public.community_is_staff(coalesce(space_id,'global'),array['admin','owner']));
create policy community_scopes_staff_read on public.community_moderator_scopes for select to authenticated using(user_id=(select auth.uid()) or public.community_is_staff(space_id,array['admin','owner']));
create policy community_log_staff_read on public.community_moderation_log for select to authenticated using(public.community_is_staff(coalesce(space_id,'global')));
create policy community_notifications_own_read on public.community_notifications for select to authenticated using(recipient_id=(select auth.uid()));
create policy community_notifications_own_update on public.community_notifications for update to authenticated using(recipient_id=(select auth.uid())) with check(recipient_id=(select auth.uid()));

grant select on public.community_spaces,public.community_categories to authenticated;
grant select,insert,update on public.community_memberships,public.community_posts,public.community_comments,public.community_room_members,public.community_messages,public.community_reports,public.community_notifications to authenticated;
grant select,insert,delete on public.community_reactions,public.community_bookmarks,public.community_subscriptions,public.community_blocks to authenticated;
grant select,insert on public.community_rooms to authenticated;
grant select on public.community_sanctions,public.community_moderator_scopes,public.community_moderation_log to authenticated;
grant insert,update on public.community_sanctions to authenticated;
grant usage,select on sequence public.community_moderation_log_id_seq to authenticated;

comment on table public.community_moderation_log is 'Immutable moderation audit log; clients receive no UPDATE or DELETE grants.';

-- Stable RPC surface prepared for the future static admin panel. Every action
-- re-checks the moderator scope in PostgreSQL and writes an immutable audit row.
create or replace function public.community_admin_dashboard(p_space_id text default null)
returns jsonb language plpgsql stable security definer set search_path='' as $$
begin
 if not public.community_is_staff(coalesce(p_space_id,'global')) then raise exception 'Accès refusé' using errcode='42501'; end if;
 return jsonb_build_object(
  'posts_today',(select count(*) from public.community_posts p where p.created_at>=date_trunc('day',now()) and (p_space_id is null or p.space_id=p_space_id)),
  'comments_today',(select count(*) from public.community_comments c join public.community_posts p on p.id=c.post_id where c.created_at>=date_trunc('day',now()) and (p_space_id is null or p.space_id=p_space_id)),
  'open_reports',(select count(*) from public.community_reports r where r.status in ('new','triaged','in_progress') and (p_space_id is null or r.space_id=p_space_id)),
  'active_sanctions',(select count(*) from public.community_sanctions s where s.status='active' and (s.ends_at is null or s.ends_at>now()) and (p_space_id is null or s.space_id=p_space_id))
 );
end $$;

create or replace function public.community_moderate_post(p_post_id uuid,p_action text,p_reason text)
returns void language plpgsql security definer set search_path='' as $$
declare v_old public.community_posts; v_new public.community_posts;
begin
 select * into v_old from public.community_posts where id=p_post_id for update;
 if v_old.id is null then raise exception 'Publication introuvable'; end if;
 if not public.community_is_staff(v_old.space_id) then raise exception 'Accès refusé' using errcode='42501'; end if;
 if char_length(trim(coalesce(p_reason,'')))<3 then raise exception 'Motif obligatoire'; end if;
 update public.community_posts set
  status=case p_action when 'hide' then 'hidden' when 'restore' then 'published' when 'lock' then 'locked' when 'remove' then 'removed_by_moderator' else status end,
  is_pinned=case p_action when 'pin' then true when 'unpin' then false else is_pinned end
 where id=p_post_id returning * into v_new;
 if p_action not in ('hide','restore','lock','remove','pin','unpin') then raise exception 'Action invalide'; end if;
 insert into public.community_moderation_log(actor_id,space_id,action,target_type,target_id,reason,old_state,new_state)
 values((select auth.uid()),v_old.space_id,p_action,'post',p_post_id::text,p_reason,to_jsonb(v_old),to_jsonb(v_new));
end $$;

create or replace function public.community_resolve_report(p_report_id uuid,p_status text,p_resolution text)
returns void language plpgsql security definer set search_path='' as $$
declare v_report public.community_reports;
begin
 select * into v_report from public.community_reports where id=p_report_id for update;
 if v_report.id is null then raise exception 'Signalement introuvable'; end if;
 if not public.community_is_staff(coalesce(v_report.space_id,'global')) then raise exception 'Accès refusé' using errcode='42501'; end if;
 if p_status not in ('resolved','rejected') or char_length(trim(coalesce(p_resolution,'')))<3 then raise exception 'Décision invalide'; end if;
 update public.community_reports set status=p_status,resolution=p_resolution,resolved_at=now(),assigned_to=(select auth.uid()) where id=p_report_id;
 insert into public.community_moderation_log(actor_id,space_id,action,target_type,target_id,reason,report_id,new_state)
 values((select auth.uid()),v_report.space_id,'resolve_report','report',p_report_id::text,p_resolution,p_report_id,jsonb_build_object('status',p_status));
end $$;

revoke all on function public.community_admin_dashboard(text) from public,anon;
revoke all on function public.community_moderate_post(uuid,text,text) from public,anon;
revoke all on function public.community_resolve_report(uuid,text,text) from public,anon;
grant execute on function public.community_admin_dashboard(text),public.community_moderate_post(uuid,text,text),public.community_resolve_report(uuid,text,text) to authenticated;
