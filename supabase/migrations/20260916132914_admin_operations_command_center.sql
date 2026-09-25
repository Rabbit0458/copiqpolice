-- COP'IQ owner operations command center.
-- This is a control-plane only: no mobile learning data or visibility rule is changed.

create table if not exists public.admin_operations_items (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in (
    'task','incident','objective','notification','synchronization','cost',
    'store_review','experiment','recommendation','production_check',
    'restore_test','documentation','health_event','feedback'
  )),
  title text not null check (char_length(btrim(title)) between 3 and 180),
  description text not null default '' check (char_length(description) <= 10000),
  status text not null default 'new' check (status in (
    'new','planned','in_progress','monitoring','blocked','done','ignored','archived'
  )),
  priority text not null default 'normal' check (priority in ('low','normal','high','critical')),
  scope text not null default 'global' check (scope in (
    'global','gpx_school','pa_school','gpx_exam','pa_exam','active','web','ios','android'
  )),
  source_type text,
  source_id text,
  assigned_admin_id uuid,
  due_at timestamptz,
  started_at timestamptz,
  completed_at timestamptz,
  progress smallint not null default 0 check (progress between 0 and 100),
  score numeric(10,2),
  metadata jsonb not null default '{}'::jsonb,
  created_by uuid default auth.uid(),
  updated_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists admin_operations_items_kind_status_idx
  on public.admin_operations_items (kind, status, priority, updated_at desc);
create index if not exists admin_operations_items_due_idx
  on public.admin_operations_items (due_at)
  where status not in ('done','ignored','archived') and due_at is not null;
create index if not exists admin_operations_items_source_idx
  on public.admin_operations_items (source_type, source_id)
  where source_type is not null and source_id is not null;

create table if not exists public.admin_operations_history (
  id bigint generated always as identity primary key,
  item_id uuid not null references public.admin_operations_items(id) on delete cascade,
  action text not null,
  from_status text,
  to_status text,
  note text check (note is null or char_length(note) <= 5000),
  snapshot jsonb not null default '{}'::jsonb,
  actor_id uuid default auth.uid(),
  created_at timestamptz not null default now()
);

create index if not exists admin_operations_history_item_idx
  on public.admin_operations_history (item_id, created_at desc);

create table if not exists public.admin_metric_definitions (
  metric_key text primary key check (metric_key ~ '^[a-z0-9_.-]+$'),
  label text not null,
  definition text not null,
  formula text not null,
  source text not null,
  unit text not null,
  cadence text not null,
  timezone text not null default 'Europe/Paris',
  minimum_sample integer not null default 0 check (minimum_sample >= 0),
  interpretation_limit text not null default '',
  version integer not null default 1 check (version > 0),
  updated_by uuid default auth.uid(),
  updated_at timestamptz not null default now()
);

-- Some older production databases were created before the remote feature-flag
-- migration. Keep the control centre self-contained while preserving the
-- public, read-only contract already used by the mobile client.
create table if not exists public.cp_feature_flags (
  key text primary key,
  description text,
  value_type text not null check (value_type in ('bool','string','int','double','variant')),
  value_default jsonb not null,
  rollout_percent integer check (rollout_percent is null or rollout_percent between 0 and 100),
  is_active boolean not null default true,
  segment text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_cp_feature_flags_active
  on public.cp_feature_flags (is_active) where is_active = true;

create or replace function public.cp_feature_flags_set_updated_at()
returns trigger language plpgsql set search_path = public as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_cp_feature_flags_updated_at on public.cp_feature_flags;
create trigger trg_cp_feature_flags_updated_at before update on public.cp_feature_flags
for each row execute function public.cp_feature_flags_set_updated_at();

alter table public.cp_feature_flags enable row level security;
drop policy if exists "cp_feature_flags_select_all" on public.cp_feature_flags;
create policy "cp_feature_flags_select_all" on public.cp_feature_flags
for select to anon, authenticated using (is_active = true);

create or replace view public.cp_feature_flags_public as
select key,value_type,value_default,rollout_percent,segment
from public.cp_feature_flags where is_active = true;

grant select on public.cp_feature_flags_public to anon, authenticated;

alter table public.admin_operations_items enable row level security;
alter table public.admin_operations_history enable row level security;
alter table public.admin_metric_definitions enable row level security;
revoke all on table public.admin_operations_items from public, anon, authenticated;
revoke all on table public.admin_operations_history from public, anon, authenticated;
revoke all on table public.admin_metric_definitions from public, anon, authenticated;
revoke all on sequence public.admin_operations_history_id_seq from public, anon, authenticated;

create or replace function public.admin_operations_touch()
returns trigger
language plpgsql
set search_path = public, auth
as $$
begin
  new.updated_at := now();
  new.updated_by := auth.uid();
  if new.status = 'in_progress' and new.started_at is null then new.started_at := now(); end if;
  if new.status = 'done' and new.completed_at is null then
    new.completed_at := now();
    new.progress := 100;
  end if;
  return new;
end;
$$;

drop trigger if exists admin_operations_items_touch on public.admin_operations_items;
create trigger admin_operations_items_touch
before update on public.admin_operations_items
for each row execute function public.admin_operations_touch();

revoke all on function public.admin_operations_touch() from public, anon, authenticated;

create or replace function public.admin_operations_overview()
returns jsonb
language plpgsql
stable
security definer
set search_path = public, auth
as $$
declare
  v_result jsonb;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;

  select jsonb_build_object(
    'refreshed_at', now(),
    'open_total', count(*) filter (where status not in ('done','ignored','archived')),
    'overdue', count(*) filter (where status not in ('done','ignored','archived') and due_at < now()),
    'critical', count(*) filter (where status not in ('done','ignored','archived') and priority = 'critical'),
    'owner_actions', count(*) filter (where status not in ('done','ignored','archived') and assigned_admin_id is null),
    'incidents_open', count(*) filter (where kind = 'incident' and status not in ('done','ignored','archived')),
    'sync_failures', count(*) filter (where kind = 'synchronization' and status in ('blocked','new')),
    'objectives_active', count(*) filter (where kind = 'objective' and status in ('planned','in_progress','monitoring')),
    'restore_tests_due', count(*) filter (where kind = 'restore_test' and status not in ('done','ignored','archived') and due_at < now()),
    'by_kind', coalesce((
      select jsonb_agg(jsonb_build_object('kind', kind, 'open', open_count) order by open_count desc, kind)
      from (
        select kind, count(*)::integer open_count
        from public.admin_operations_items
        where status not in ('done','ignored','archived')
        group by kind
      ) grouped
    ), '[]'::jsonb)
  ) into v_result
  from public.admin_operations_items;
  return v_result;
end;
$$;

create or replace function public.admin_operations_list(
  p_kind text default null,
  p_status text default null,
  p_search text default null,
  p_limit integer default 200
)
returns setof public.admin_operations_items
language plpgsql
stable
security definer
set search_path = public, auth
as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  return query
  select i.*
  from public.admin_operations_items i
  where (p_kind is null or i.kind = p_kind)
    and (p_status is null or i.status = p_status)
    and (p_search is null or btrim(p_search) = '' or
      i.title ilike '%' || btrim(p_search) || '%' or
      i.description ilike '%' || btrim(p_search) || '%')
  order by
    case i.priority when 'critical' then 1 when 'high' then 2 when 'normal' then 3 else 4 end,
    (i.status in ('done','ignored','archived')),
    i.due_at nulls last,
    i.updated_at desc
  limit least(greatest(coalesce(p_limit, 200), 1), 500);
end;
$$;

create or replace function public.admin_operations_save(p_data jsonb)
returns public.admin_operations_items
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_id uuid := nullif(p_data->>'id','')::uuid;
  v_item public.admin_operations_items;
  v_before public.admin_operations_items;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  if p_data is null or char_length(btrim(coalesce(p_data->>'title',''))) < 3 then
    raise exception 'Le titre doit contenir au moins 3 caractères.' using errcode = '22023';
  end if;

  if v_id is null then
    insert into public.admin_operations_items (
      kind,title,description,status,priority,scope,source_type,source_id,
      assigned_admin_id,due_at,progress,score,metadata
    ) values (
      coalesce(nullif(p_data->>'kind',''),'task'),
      btrim(p_data->>'title'),
      coalesce(p_data->>'description',''),
      coalesce(nullif(p_data->>'status',''),'new'),
      coalesce(nullif(p_data->>'priority',''),'normal'),
      coalesce(nullif(p_data->>'scope',''),'global'),
      nullif(p_data->>'source_type',''), nullif(p_data->>'source_id',''),
      nullif(p_data->>'assigned_admin_id','')::uuid,
      nullif(p_data->>'due_at','')::timestamptz,
      coalesce(nullif(p_data->>'progress','')::smallint,0),
      nullif(p_data->>'score','')::numeric,
      coalesce(p_data->'metadata','{}'::jsonb)
    ) returning * into v_item;
    insert into public.admin_operations_history(item_id,action,to_status,note,snapshot)
      values(v_item.id,'created',v_item.status,'Création depuis le centre d’exploitation',to_jsonb(v_item));
  else
    select * into v_before from public.admin_operations_items where id = v_id for update;
    if not found then raise exception 'Élément introuvable.' using errcode = 'P0002'; end if;
    update public.admin_operations_items set
      kind = coalesce(nullif(p_data->>'kind',''),kind),
      title = btrim(coalesce(nullif(p_data->>'title',''),title)),
      description = coalesce(p_data->>'description',description),
      status = coalesce(nullif(p_data->>'status',''),status),
      priority = coalesce(nullif(p_data->>'priority',''),priority),
      scope = coalesce(nullif(p_data->>'scope',''),scope),
      source_type = case when p_data ? 'source_type' then nullif(p_data->>'source_type','') else source_type end,
      source_id = case when p_data ? 'source_id' then nullif(p_data->>'source_id','') else source_id end,
      assigned_admin_id = case when p_data ? 'assigned_admin_id' then nullif(p_data->>'assigned_admin_id','')::uuid else assigned_admin_id end,
      due_at = case when p_data ? 'due_at' then nullif(p_data->>'due_at','')::timestamptz else due_at end,
      progress = coalesce(nullif(p_data->>'progress','')::smallint,progress),
      score = case when p_data ? 'score' then nullif(p_data->>'score','')::numeric else score end,
      metadata = case when p_data ? 'metadata' then coalesce(p_data->'metadata','{}'::jsonb) else metadata end
    where id = v_id returning * into v_item;
    insert into public.admin_operations_history(item_id,action,from_status,to_status,note,snapshot)
      values(v_item.id,'updated',v_before.status,v_item.status,'Mise à jour depuis le centre d’exploitation',jsonb_build_object('before',to_jsonb(v_before),'after',to_jsonb(v_item)));
  end if;
  return v_item;
end;
$$;

create or replace function public.admin_operations_transition(
  p_id uuid,
  p_status text,
  p_note text default null
)
returns public.admin_operations_items
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_before public.admin_operations_items;
  v_item public.admin_operations_items;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  if p_status not in ('new','planned','in_progress','monitoring','blocked','done','ignored','archived') then
    raise exception 'Statut invalide.' using errcode = '22023';
  end if;
  select * into v_before from public.admin_operations_items where id = p_id for update;
  if not found then raise exception 'Élément introuvable.' using errcode = 'P0002'; end if;
  update public.admin_operations_items set status = p_status where id = p_id returning * into v_item;
  insert into public.admin_operations_history(item_id,action,from_status,to_status,note,snapshot)
    values(p_id,'status_changed',v_before.status,v_item.status,nullif(btrim(coalesce(p_note,'')),''),to_jsonb(v_item));
  return v_item;
end;
$$;

create or replace function public.admin_operations_history_list(p_item_id uuid)
returns setof public.admin_operations_history
language plpgsql
stable
security definer
set search_path = public, auth
as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  return query select h.* from public.admin_operations_history h
    where h.item_id = p_item_id order by h.created_at desc limit 250;
end;
$$;

create or replace function public.admin_metric_dictionary()
returns setof public.admin_metric_definitions
language plpgsql
stable
security definer
set search_path = public, auth
as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  return query select d.* from public.admin_metric_definitions d order by d.label;
end;
$$;

create or replace function public.admin_feature_flags_list()
returns table(
  key text, description text, value_type text, value_default jsonb,
  rollout_percent integer, is_active boolean, segment text, updated_at timestamptz
)
language plpgsql
stable
security definer
set search_path = public, auth
as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  return query select f.key,f.description,f.value_type,f.value_default,
    f.rollout_percent,f.is_active,f.segment,f.updated_at
    from public.cp_feature_flags f order by f.key;
end;
$$;

create or replace function public.admin_feature_flag_update(
  p_key text,
  p_active boolean,
  p_rollout integer default null,
  p_segment text default null,
  p_confirmation text default null
)
returns public.cp_feature_flags
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_before public.cp_feature_flags;
  v_flag public.cp_feature_flags;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode = '42501';
  end if;
  if p_confirmation <> p_key then
    raise exception 'Confirmation invalide : saisissez la clé exacte du flag.' using errcode = '22023';
  end if;
  if p_rollout is not null and (p_rollout < 0 or p_rollout > 100) then
    raise exception 'Pourcentage de déploiement invalide.' using errcode = '22023';
  end if;
  select * into v_before from public.cp_feature_flags where cp_feature_flags.key = p_key for update;
  if not found then raise exception 'Feature flag introuvable.' using errcode = 'P0002'; end if;
  update public.cp_feature_flags set
    is_active = p_active,
    rollout_percent = p_rollout,
    segment = nullif(btrim(coalesce(p_segment,'')),'')
  where cp_feature_flags.key = p_key returning * into v_flag;
  insert into public.admin_operations_items(kind,title,description,status,priority,scope,source_type,source_id,progress,metadata)
    values('health_event','Modification du feature flag ' || p_key,
      'Changement validé par le propriétaire.','done','normal','global','feature_flag',p_key,100,
      jsonb_build_object('before',to_jsonb(v_before),'after',to_jsonb(v_flag)));
  return v_flag;
end;
$$;

insert into public.admin_metric_definitions
  (metric_key,label,definition,formula,source,unit,cadence,minimum_sample,interpretation_limit)
values
  ('active_users','Utilisateurs actifs','Personnes distinctes ayant ouvert l’application ou navigué.','count(distinct user_id)','app_logs','utilisateurs','moins d’une minute',5,'Les renouvellements de connexion et erreurs seuls sont exclus.'),
  ('answers_saved','Réponses sauvegardées','Questions auxquelles une réponse a réellement été fournie.','count(*)','quiz_answer_history','réponses','moins d’une minute',20,'La longueur prévue du quiz n’est jamais comptée comme réponse.'),
  ('accuracy','Taux de réussite','Part des bonnes réponses parmi les réponses sauvegardées.','100 × bonnes réponses / réponses sauvegardées','quiz_answer_history','pourcentage','moins d’une minute',20,'Masqué sous 20 réponses ou 5 apprenants.'),
  ('retention_d7','Rétention J+7','Part des inscrits revenus exactement sept jours après leur inscription.','retours J+7 / cohortes éligibles','user_profiles + app_logs','pourcentage','quotidien',5,'Seules les cohortes assez anciennes sont éligibles.'),
  ('incident_events','Incidents consignés','Événements d’erreur enregistrés en production iOS ou Android.','count(error events)','app_logs','événements','moins d’une minute',5,'Un incident consigné ne signifie pas nécessairement un crash.'),
  ('premium_active','Premium actifs','Abonnements actuellement actifs dans la table normalisée.','count(active premium subscriptions)','cas_pratique_subscriptions','abonnements','temps réel',0,'Un statut actif n’est pas un chiffre d’affaires.'),
  ('community_contributions','Contributions communauté','Publications, commentaires et messages publiés et non supprimés.','posts + comments + messages','community_*','contributions','moins d’une minute',5,'Les contenus supprimés ou modérés sont exclus.')
on conflict (metric_key) do update set
  label=excluded.label,definition=excluded.definition,formula=excluded.formula,
  source=excluded.source,unit=excluded.unit,cadence=excluded.cadence,
  minimum_sample=excluded.minimum_sample,interpretation_limit=excluded.interpretation_limit,
  version=public.admin_metric_definitions.version + 1,updated_at=now();

insert into public.admin_operations_items(kind,title,description,status,priority,scope,progress,metadata)
select seed.kind,seed.title,seed.description,'planned',seed.priority,seed.scope,0,seed.metadata
from (values
  ('documentation','Procédure de publication','Vérifier les parcours, les liens, les médias, les migrations, les sauvegardes et le retour arrière avant toute mise en production.','high','global',jsonb_build_object('template','publication-runbook','version',1)),
  ('documentation','Procédure de restauration','Restaurer uniquement sur un environnement isolé, vérifier l’intégrité, documenter le RPO/RTO et journaliser le résultat.','critical','global',jsonb_build_object('template','restore-runbook','version',1)),
  ('production_check','Contrôle des quatre parcours','Valider Scolarité GPX, Scolarité PA, Concours GPX et Concours PA sans mélanger le module Je suis actif.','critical','global',jsonb_build_object('blocking',true)),
  ('production_check','Contrôle sécurité et secrets','Vérifier 2FA, permissions, migrations, RLS et absence de secret privé dans les bundles.','critical','web',jsonb_build_object('blocking',true)),
  ('restore_test','Test de restauration trimestriel','Exécuter une restauration sur un environnement séparé et consigner durée, intégrité, RPO et RTO.','critical','global',jsonb_build_object('environment','isolated','rpo_hours',24,'rto_hours',4))
) as seed(kind,title,description,priority,scope,metadata)
where not exists (
  select 1 from public.admin_operations_items existing
  where existing.kind = seed.kind and existing.title = seed.title
);

do $$
declare f regprocedure;
begin
  foreach f in array array[
    'public.admin_operations_overview()'::regprocedure,
    'public.admin_operations_list(text,text,text,integer)'::regprocedure,
    'public.admin_operations_save(jsonb)'::regprocedure,
    'public.admin_operations_transition(uuid,text,text)'::regprocedure,
    'public.admin_operations_history_list(uuid)'::regprocedure,
    'public.admin_metric_dictionary()'::regprocedure,
    'public.admin_feature_flags_list()'::regprocedure,
    'public.admin_feature_flag_update(text,boolean,integer,text,text)'::regprocedure
  ] loop
    execute format('revoke all on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end $$;

comment on table public.admin_operations_items is 'Owner control-plane: tasks, incidents, objectives, runbooks, checks and operational follow-up.';
comment on table public.admin_operations_history is 'Immutable history of owner operations changes.';
comment on table public.admin_metric_definitions is 'Versioned definitions and lineage for aggregate dashboard metrics.';
