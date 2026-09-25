begin;

-- Le schéma historique n'acceptait que exam/school. Le mode actif reste lié
-- au parcours GPX et ne devient visible que via la configuration ci-dessous.
do $$
declare v_constraint record;
begin
  for v_constraint in
    select conname from pg_constraint
    where conrelid='public.user_profiles'::regclass and contype='c'
      and pg_get_constraintdef(oid) ilike '%user_mode%'
  loop
    execute format('alter table public.user_profiles drop constraint %I',v_constraint.conname);
  end loop;
end $$;
alter table public.user_profiles add constraint user_profiles_user_mode_check
  check (user_mode in ('exam','school','active'));

create table if not exists public.active_mode_config (
  id boolean primary key default true check (id),
  enabled boolean not null default false,
  revision bigint not null default 1 check (revision > 0),
  disable_message text not null default 'Une mise à jour doit être appliquée sur ce module.',
  countdown_seconds smallint not null default 30 check (countdown_seconds between 10 and 120),
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id)
);

insert into public.active_mode_config(id) values(true) on conflict(id) do nothing;

create table if not exists public.active_content_nodes (
  id uuid primary key default gen_random_uuid(),
  parent_id uuid references public.active_content_nodes(id) on delete restrict,
  node_type text not null check (node_type in ('category','subcategory','course')),
  title text not null check (length(trim(title)) between 1 and 140),
  subtitle text,
  image_url text,
  icon text,
  sort_order integer not null default 0,
  draft_content jsonb not null default '[]'::jsonb,
  published_content jsonb,
  status text not null default 'draft' check (status in ('draft','published','archived')),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users(id),
  updated_by uuid references auth.users(id),
  archived_at timestamptz,
  archived_by uuid references auth.users(id),
  constraint active_course_content_array check (
    jsonb_typeof(draft_content) = 'array' and
    (published_content is null or jsonb_typeof(published_content) = 'array')
  )
);

create index if not exists active_content_parent_sort_idx
  on public.active_content_nodes(parent_id, sort_order, title);
create index if not exists active_content_published_idx
  on public.active_content_nodes(status, node_type, sort_order) where status='published';

create table if not exists public.active_learning_events (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  node_id uuid not null references public.active_content_nodes(id) on delete cascade,
  event_type text not null check (event_type in ('opened','completed','favorite_added','favorite_removed')),
  created_at timestamptz not null default now()
);

create index if not exists active_learning_user_created_idx
  on public.active_learning_events(user_id, created_at desc);

create table if not exists public.active_content_notifications (
  id bigint generated always as identity primary key,
  recipient_id uuid not null references auth.users(id) on delete cascade,
  node_id uuid references public.active_content_nodes(id) on delete cascade,
  title text not null,
  body text not null,
  read_at timestamptz,
  created_at timestamptz not null default now(),
  unique(recipient_id, node_id)
);

create table if not exists public.active_community_posts (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (length(trim(body)) between 1 and 5000),
  status text not null default 'published' check (status in ('published','hidden','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.active_community_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.active_community_posts(id) on delete cascade,
  author_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (length(trim(body)) between 1 and 3000),
  status text not null default 'published' check (status in ('published','hidden','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.active_mode_config enable row level security;
alter table public.active_content_nodes enable row level security;
alter table public.active_learning_events enable row level security;
alter table public.active_content_notifications enable row level security;
alter table public.active_community_posts enable row level security;
alter table public.active_community_comments enable row level security;

alter table public.active_mode_config force row level security;
alter table public.active_content_nodes force row level security;
alter table public.active_learning_events force row level security;
alter table public.active_content_notifications force row level security;
alter table public.active_community_posts force row level security;
alter table public.active_community_comments force row level security;

create or replace function public.active_user_guard(p_require_enabled boolean default true)
returns void language plpgsql security definer set search_path=public,auth as $$
declare v_enabled boolean;
begin
  if auth.uid() is null then raise exception 'AUTH_REQUIRED' using errcode='42501'; end if;
  select enabled into v_enabled from public.active_mode_config where id=true;
  if p_require_enabled and not coalesce(v_enabled,false) then raise exception 'ACTIVE_MODE_DISABLED' using errcode='42501'; end if;
  if not exists(select 1 from public.active_access_verifications where user_id=auth.uid() and status='granted') then
    raise exception 'ACTIVE_ACCESS_REQUIRED' using errcode='42501';
  end if;
  if not exists(select 1 from public.user_profiles where user_id=auth.uid() and user_mode='active' and user_track='gpx') then
    raise exception 'ACTIVE_GPX_PROFILE_REQUIRED' using errcode='42501';
  end if;
end;
$$;

create or replace function public.active_mode_public_config()
returns jsonb language sql stable security definer set search_path=public as $$
  select jsonb_build_object('enabled',enabled,'revision',revision,
    'disable_message',disable_message,'countdown_seconds',countdown_seconds,'updated_at',updated_at)
  from public.active_mode_config where id=true;
$$;

create or replace function public.active_content_tree()
returns setof public.active_content_nodes language plpgsql stable security definer set search_path=public,auth as $$
begin
  perform public.active_user_guard(true);
  return query select * from public.active_content_nodes
   where status='published' order by parent_id nulls first,sort_order,title;
end;
$$;

create or replace function public.active_learning_record(p_node_id uuid,p_event_type text)
returns void language plpgsql security definer set search_path=public,auth as $$
begin
  perform public.active_user_guard(true);
  if p_event_type not in ('opened','completed','favorite_added','favorite_removed') then raise exception 'INVALID_EVENT'; end if;
  if not exists(select 1 from public.active_content_nodes where id=p_node_id and status='published') then raise exception 'CONTENT_NOT_FOUND'; end if;
  insert into public.active_learning_events(user_id,node_id,event_type) values(auth.uid(),p_node_id,p_event_type);
end;
$$;

create or replace function public.admin_active_content_state()
returns jsonb language plpgsql security definer set search_path=public,auth as $$
declare v_admin public.admin_users;
begin
  v_admin:=public.active_admin_guard();
  if v_admin.role<>'owner' then raise exception 'OWNER_REQUIRED' using errcode='42501'; end if;
  return jsonb_build_object(
    'config',(select to_jsonb(c) from public.active_mode_config c where id=true),
    'nodes',coalesce((select jsonb_agg(to_jsonb(n) order by n.parent_id nulls first,n.sort_order,n.title)
      from public.active_content_nodes n where n.status<>'archived'),'[]'::jsonb)
  );
end;
$$;

create or replace function public.admin_active_config_set(p_enabled boolean,p_message text default null)
returns jsonb language plpgsql security definer set search_path=public,auth as $$
declare v_admin public.admin_users; v_old jsonb; v_new jsonb;
begin
  v_admin:=public.active_admin_guard();
  if v_admin.role<>'owner' then raise exception 'OWNER_REQUIRED' using errcode='42501'; end if;
  select to_jsonb(c) into v_old from public.active_mode_config c where id=true;
  update public.active_mode_config set enabled=p_enabled,revision=revision+1,
    disable_message=coalesce(nullif(trim(p_message),''),disable_message),updated_at=now(),updated_by=auth.uid() where id=true;
  select to_jsonb(c) into v_new from public.active_mode_config c where id=true;
  insert into public.admin_audit_logs(actor_admin_id,actor_auth_uid,actor_email,actor_role,target_table,target_id,action,severity,success,old_value,new_value,meta)
  values(v_admin.id,auth.uid(),v_admin.email,v_admin.role,'active_mode_config','true','active_mode_toggle','warning',true,v_old,v_new,jsonb_build_object('source','admin_panel'));
  return v_new;
end;
$$;

create or replace function public.admin_active_content_save(
  p_id uuid,p_parent_id uuid,p_node_type text,p_title text,p_subtitle text,p_image_url text,p_icon text,p_sort_order integer,p_content jsonb)
returns public.active_content_nodes language plpgsql security definer set search_path=public,auth as $$
declare v_admin public.admin_users; v_id uuid:=coalesce(p_id,gen_random_uuid()); v_row public.active_content_nodes;
begin
  v_admin:=public.active_admin_guard();
  if v_admin.role<>'owner' then raise exception 'OWNER_REQUIRED' using errcode='42501'; end if;
  if p_node_type not in ('category','subcategory','course') then raise exception 'INVALID_NODE_TYPE'; end if;
  if jsonb_typeof(coalesce(p_content,'[]'::jsonb))<>'array' then raise exception 'CONTENT_MUST_BE_ARRAY'; end if;
  if p_parent_id is not null and not exists(select 1 from public.active_content_nodes where id=p_parent_id and status<>'archived') then raise exception 'PARENT_NOT_FOUND'; end if;
  insert into public.active_content_nodes(id,parent_id,node_type,title,subtitle,image_url,icon,sort_order,draft_content,created_by,updated_by)
  values(v_id,p_parent_id,p_node_type,trim(p_title),nullif(trim(p_subtitle),''),nullif(trim(p_image_url),''),nullif(trim(p_icon),''),coalesce(p_sort_order,0),coalesce(p_content,'[]'::jsonb),auth.uid(),auth.uid())
  on conflict(id) do update set parent_id=excluded.parent_id,node_type=excluded.node_type,title=excluded.title,
    subtitle=excluded.subtitle,image_url=excluded.image_url,icon=excluded.icon,sort_order=excluded.sort_order,
    draft_content=excluded.draft_content,status=case when active_content_nodes.status='archived' then 'draft' else active_content_nodes.status end,
    updated_at=now(),updated_by=auth.uid(),archived_at=null,archived_by=null
  returning * into v_row;
  insert into public.admin_audit_logs(actor_admin_id,actor_auth_uid,actor_email,actor_role,target_table,target_id,action,severity,success,new_value,meta)
  values(v_admin.id,auth.uid(),v_admin.email,v_admin.role,'active_content_nodes',v_id::text,'active_content_save','info',true,to_jsonb(v_row),jsonb_build_object('source','admin_panel'));
  return v_row;
end;
$$;

create or replace function public.admin_active_content_publish(p_id uuid)
returns public.active_content_nodes language plpgsql security definer set search_path=public,auth as $$
declare v_admin public.admin_users; v_row public.active_content_nodes;
begin
  v_admin:=public.active_admin_guard();
  if v_admin.role<>'owner' then raise exception 'OWNER_REQUIRED' using errcode='42501'; end if;
  update public.active_content_nodes set published_content=draft_content,status='published',published_at=now(),updated_at=now(),updated_by=auth.uid()
    where id=p_id and status<>'archived' returning * into v_row;
  if v_row.id is null then raise exception 'CONTENT_NOT_FOUND'; end if;
  if v_row.node_type='course' then
    insert into public.active_content_notifications(recipient_id,node_id,title,body)
    select p.user_id,v_row.id,'Nouveau cours disponible',v_row.title
    from public.user_profiles p join public.active_access_verifications a on a.user_id=p.user_id and a.status='granted'
    where p.user_mode='active' and p.user_track='gpx' on conflict do nothing;
  end if;
  insert into public.admin_audit_logs(actor_admin_id,actor_auth_uid,actor_email,actor_role,target_table,target_id,action,severity,success,new_value,meta)
  values(v_admin.id,auth.uid(),v_admin.email,v_admin.role,'active_content_nodes',p_id::text,'active_content_publish','warning',true,to_jsonb(v_row),jsonb_build_object('source','admin_panel'));
  return v_row;
end;
$$;

create or replace function public.admin_active_content_archive(p_id uuid,p_confirmation text)
returns void language plpgsql security definer set search_path=public,auth as $$
declare v_admin public.admin_users; v_title text;
begin
  v_admin:=public.active_admin_guard();
  if v_admin.role<>'owner' then raise exception 'OWNER_REQUIRED' using errcode='42501'; end if;
  select title into v_title from public.active_content_nodes where id=p_id and status<>'archived';
  if v_title is null then raise exception 'CONTENT_NOT_FOUND'; end if;
  if p_confirmation <> 'ARCHIVER '||v_title then raise exception 'CONFIRMATION_MISMATCH'; end if;
  if exists(select 1 from public.active_content_nodes where parent_id=p_id and status<>'archived') then raise exception 'ARCHIVE_CHILDREN_FIRST'; end if;
  update public.active_content_nodes set status='archived',archived_at=now(),archived_by=auth.uid(),updated_at=now(),updated_by=auth.uid() where id=p_id;
  insert into public.admin_audit_logs(actor_admin_id,actor_auth_uid,actor_email,actor_role,target_table,target_id,action,severity,success,comment,meta)
  values(v_admin.id,auth.uid(),v_admin.email,v_admin.role,'active_content_nodes',p_id::text,'active_content_archive','warning',true,p_confirmation,jsonb_build_object('source','admin_panel'));
end;
$$;

create policy active_learning_own_read on public.active_learning_events for select to authenticated using(user_id=(select auth.uid()));
create policy active_notification_own_read on public.active_content_notifications for select to authenticated using(recipient_id=(select auth.uid()));
create policy active_notification_own_update on public.active_content_notifications for update to authenticated using(recipient_id=(select auth.uid())) with check(recipient_id=(select auth.uid()));

revoke all on public.active_mode_config,public.active_content_nodes,public.active_learning_events,public.active_content_notifications,public.active_community_posts,public.active_community_comments from public,anon,authenticated;
grant select,update on public.active_content_notifications to authenticated;
grant select on public.active_learning_events to authenticated;

revoke all on function public.active_user_guard(boolean),public.active_mode_public_config(),public.active_content_tree(),public.active_learning_record(uuid,text),
 public.admin_active_content_state(),public.admin_active_config_set(boolean,text),public.admin_active_content_save(uuid,uuid,text,text,text,text,text,integer,jsonb),
 public.admin_active_content_publish(uuid),public.admin_active_content_archive(uuid,text) from public,anon;
grant execute on function public.active_mode_public_config(),public.active_content_tree(),public.active_learning_record(uuid,text),
 public.admin_active_content_state(),public.admin_active_config_set(boolean,text),public.admin_active_content_save(uuid,uuid,text,text,text,text,text,integer,jsonb),
 public.admin_active_content_publish(uuid),public.admin_active_content_archive(uuid,text) to authenticated;

commit;
