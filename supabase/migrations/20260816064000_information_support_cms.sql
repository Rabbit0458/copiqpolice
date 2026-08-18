-- COP'IQ — Centre d'information administrable (web + panneau admin)
-- FAQ, support, mentions légales, confidentialité, informations et état des services.

create table if not exists public.information_contents (
  id uuid primary key default gen_random_uuid(),
  content_type text not null check (content_type in ('information','faq','legal_notice','privacy','support','service_status')),
  slug text not null,
  title text not null,
  summary text not null default '',
  body_md text not null default '',
  category text not null default 'Général',
  sort_order integer not null default 0,
  status text not null default 'draft' check (status in ('draft','scheduled','published','archived')),
  scheduled_at timestamptz,
  published_at timestamptz,
  archived_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (content_type, slug),
  check (status <> 'scheduled' or scheduled_at is not null)
);

create index if not exists information_contents_public_idx
  on public.information_contents (content_type, status, sort_order, published_at desc);
create index if not exists information_contents_schedule_idx
  on public.information_contents (scheduled_at)
  where status = 'scheduled';

alter table public.information_contents enable row level security;
revoke all on table public.information_contents from anon, authenticated;
grant select on table public.information_contents to anon, authenticated;

drop policy if exists information_contents_public_read on public.information_contents;
create policy information_contents_public_read
on public.information_contents for select
to anon, authenticated
using (
  status = 'published'
  or (status = 'scheduled' and scheduled_at <= now())
);

create table if not exists public.support_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  name text not null,
  email text not null,
  category text not null default 'other',
  subject text not null,
  message text not null,
  status text not null default 'new' check (status in ('new','in_progress','waiting_user','resolved','closed')),
  priority text not null default 'normal' check (priority in ('low','normal','high','urgent')),
  admin_note text not null default '',
  resolved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists support_requests_admin_idx
  on public.support_requests (status, priority, created_at desc);
create index if not exists support_requests_user_idx
  on public.support_requests (user_id, created_at desc);

alter table public.support_requests enable row level security;
revoke all on table public.support_requests from anon, authenticated;

create or replace function public.information_admin_guard()
returns uuid
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_admin_id uuid;
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED';
  end if;
  if coalesce(auth.jwt()->>'aal', 'aal1') <> 'aal2' then
    raise exception 'AAL2_REQUIRED';
  end if;
  v_admin_id := public.current_admin_id();
  if v_admin_id is null then
    raise exception 'ADMIN_REQUIRED';
  end if;
  return v_admin_id;
end;
$$;

revoke all on function public.information_admin_guard() from public, anon, authenticated;

create or replace function public.information_admin_list(
  p_type text default null,
  p_status text default null,
  p_search text default null
)
returns setof public.information_contents
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  perform public.information_admin_guard();
  return query
  select c.* from public.information_contents c
  where (p_type is null or c.content_type = p_type)
    and (p_status is null or c.status = p_status)
    and (p_search is null or c.title ilike '%' || p_search || '%' or c.body_md ilike '%' || p_search || '%')
  order by c.content_type, c.sort_order, c.updated_at desc;
end;
$$;

create or replace function public.information_admin_save(p_data jsonb)
returns public.information_contents
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_admin uuid := public.information_admin_guard();
  v_status text := coalesce(nullif(p_data->>'status',''), 'draft');
  v_row public.information_contents;
begin
  if v_status not in ('draft','scheduled','published','archived') then raise exception 'INVALID_STATUS'; end if;
  if v_status = 'scheduled' and nullif(p_data->>'scheduled_at','') is null then raise exception 'SCHEDULE_REQUIRED'; end if;

  insert into public.information_contents (
    id, content_type, slug, title, summary, body_md, category, sort_order,
    status, scheduled_at, published_at, archived_at, metadata,
    created_by, updated_by, updated_at
  ) values (
    coalesce(nullif(p_data->>'id','')::uuid, gen_random_uuid()),
    p_data->>'content_type', lower(regexp_replace(p_data->>'slug','[^a-zA-Z0-9_-]+','-','g')),
    trim(p_data->>'title'), coalesce(p_data->>'summary',''), coalesce(p_data->>'body_md',''),
    coalesce(nullif(p_data->>'category',''),'Général'), coalesce((p_data->>'sort_order')::integer,0),
    v_status, nullif(p_data->>'scheduled_at','')::timestamptz,
    case when v_status='published' then coalesce(nullif(p_data->>'published_at','')::timestamptz,now()) else null end,
    case when v_status='archived' then now() else null end,
    coalesce(p_data->'metadata','{}'::jsonb), v_admin, v_admin, now()
  )
  on conflict (content_type, slug) do update set
    title=excluded.title, summary=excluded.summary, body_md=excluded.body_md,
    category=excluded.category, sort_order=excluded.sort_order, status=excluded.status,
    scheduled_at=excluded.scheduled_at,
    published_at=case when excluded.status='published' then coalesce(information_contents.published_at,now()) else null end,
    archived_at=excluded.archived_at, metadata=excluded.metadata, updated_by=v_admin, updated_at=now()
  returning * into v_row;
  return v_row;
end;
$$;

create or replace function public.information_admin_delete(p_id uuid)
returns boolean
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  perform public.information_admin_guard();
  delete from public.information_contents where id=p_id and status <> 'published';
  return found;
end;
$$;

create or replace function public.submit_support_request(
  p_name text, p_email text, p_category text, p_subject text, p_message text, p_website text default ''
)
returns uuid
language plpgsql
security definer
set search_path = public, auth
as $$
declare v_id uuid;
begin
  if coalesce(trim(p_website),'') <> '' then raise exception 'INVALID_REQUEST'; end if;
  if length(trim(p_name)) not between 2 and 120 then raise exception 'INVALID_NAME'; end if;
  if p_email !~* '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$' then raise exception 'INVALID_EMAIL'; end if;
  if length(trim(p_subject)) not between 3 and 180 then raise exception 'INVALID_SUBJECT'; end if;
  if length(trim(p_message)) not between 10 and 6000 then raise exception 'INVALID_MESSAGE'; end if;
  insert into public.support_requests(user_id,name,email,category,subject,message)
  values(auth.uid(),trim(p_name),lower(trim(p_email)),coalesce(nullif(trim(p_category),''),'other'),trim(p_subject),trim(p_message))
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function public.support_admin_list(p_status text default null, p_search text default null)
returns setof public.support_requests
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  perform public.information_admin_guard();
  return query select s.* from public.support_requests s
  where (p_status is null or s.status=p_status)
    and (p_search is null or s.email ilike '%'||p_search||'%' or s.subject ilike '%'||p_search||'%' or s.message ilike '%'||p_search||'%')
  order by case s.priority when 'urgent' then 0 when 'high' then 1 when 'normal' then 2 else 3 end, s.created_at desc;
end;
$$;

create or replace function public.support_admin_update(
  p_id uuid, p_status text, p_priority text, p_admin_note text default ''
)
returns public.support_requests
language plpgsql
security definer
set search_path = public, auth
as $$
declare v_row public.support_requests;
begin
  perform public.information_admin_guard();
  update public.support_requests set status=p_status, priority=p_priority,
    admin_note=coalesce(p_admin_note,''), resolved_at=case when p_status in ('resolved','closed') then now() else null end,
    updated_at=now()
  where id=p_id returning * into v_row;
  return v_row;
end;
$$;

revoke all on function public.information_admin_list(text,text,text) from public, anon;
revoke all on function public.information_admin_save(jsonb) from public, anon;
revoke all on function public.information_admin_delete(uuid) from public, anon;
revoke all on function public.support_admin_list(text,text) from public, anon;
revoke all on function public.support_admin_update(uuid,text,text,text) from public, anon;
grant execute on function public.information_admin_list(text,text,text) to authenticated;
grant execute on function public.information_admin_save(jsonb) to authenticated;
grant execute on function public.information_admin_delete(uuid) to authenticated;
grant execute on function public.support_admin_list(text,text) to authenticated;
grant execute on function public.support_admin_update(uuid,text,text,text) to authenticated;
revoke all on function public.submit_support_request(text,text,text,text,text,text) from public;
grant execute on function public.submit_support_request(text,text,text,text,text,text) to anon, authenticated;

insert into public.information_contents(content_type,slug,title,summary,body_md,category,sort_order,status,published_at,metadata)
values
('information','presentation','Bienvenue dans COP''IQ','La plateforme complète pour préparer les concours et la scolarité de la Police nationale.','COP''IQ réunit les cours GPX et PA, les quiz, les examens, les entraînements psychotechniques, les cas pratiques et les outils de suivi dans une seule expérience.','Découvrir COP''IQ',10,'published',now(),'{}'),
('support','contact','Une équipe à votre écoute','Une question sur ton abonnement, un contenu ou le fonctionnement de COP''IQ ?','Notre équipe répond aux demandes transmises depuis le formulaire de support. Pour nous aider à répondre rapidement, précise le parcours concerné et décris les étapes du problème.','Support',10,'published',now(),'{"email":"contact@copiq.fr","response_time":"Réponse habituelle sous 24 à 48 h ouvrées"}'),
('service_status','platform','Tous les services','État général de COP''IQ','Les services COP''IQ sont surveillés. En cas d''incident, cette page permet d''informer rapidement les utilisateurs.','Services',10,'published',now(),'{"state":"operational","label":"Tous les services sont opérationnels"}'),
('faq','subscription-access','Que débloque l''abonnement Premium ?','', 'Premium donne accès à l''ensemble de l''application : cours GPX et PA, quiz, examens, entraînements et futures mises à jour, avec une utilisation illimitée soumise à une protection contre les abus automatisés.','Abonnement',10,'published',now(),'{}'),
('faq','cancel-subscription','Que se passe-t-il après une résiliation ?','', 'L''accès Premium reste actif jusqu''à la fin de la période déjà payée. Aucun nouveau prélèvement n''est effectué après cette date.','Abonnement',20,'published',now(),'{}'),
('faq','annual-trial','Comment fonctionne l''essai annuel de 7 jours ?','', 'L''offre annuelle comprend 7 jours d''essai. Une carte bancaire est demandée au démarrage. Tu peux annuler avant la fin de l''essai pour éviter le premier prélèvement.','Abonnement',30,'published',now(),'{}')
on conflict (content_type,slug) do nothing;

notify pgrst, 'reload schema';
