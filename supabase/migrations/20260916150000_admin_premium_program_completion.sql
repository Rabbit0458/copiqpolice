-- COP'IQ premium administration programme — operational completion layer.
-- This migration adds only control-plane data. Existing mobile visibility,
-- learning and publication rules remain untouched.

create table if not exists public.admin_data_sources (
  source_key text primary key check (source_key ~ '^[a-z0-9_.-]+$'),
  label text not null,
  category text not null check (category in ('product','learning','billing','store','email','infrastructure','analytics')),
  source_mode text not null check (source_mode in ('realtime','calculated','imported','manual')),
  connection_status text not null default 'not_connected' check (connection_status in ('healthy','delayed','failed','not_connected','paused')),
  freshness_target_minutes integer not null default 1440 check (freshness_target_minutes > 0),
  last_success_at timestamptz,
  last_failure_at timestamptz,
  next_check_at timestamptz,
  record_count bigint not null default 0 check (record_count >= 0),
  last_error text,
  public_config jsonb not null default '{}'::jsonb,
  updated_by uuid default auth.uid(),
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_data_source_runs (
  id bigint generated always as identity primary key,
  source_key text not null references public.admin_data_sources(source_key) on delete cascade,
  run_key text not null,
  status text not null check (status in ('running','succeeded','partial','failed','cancelled')),
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  input_count bigint not null default 0 check (input_count >= 0),
  output_count bigint not null default 0 check (output_count >= 0),
  duplicate_count bigint not null default 0 check (duplicate_count >= 0),
  duration_ms bigint check (duration_ms is null or duration_ms >= 0),
  error_code text,
  error_message text,
  metadata jsonb not null default '{}'::jsonb,
  triggered_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  unique(source_key, run_key)
);

create index if not exists admin_data_source_runs_source_idx
  on public.admin_data_source_runs(source_key, started_at desc);

create table if not exists public.admin_saved_views (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid(),
  name text not null check (char_length(btrim(name)) between 2 and 80),
  page_key text not null check (page_key ~ '^[a-z0-9_.-]+$'),
  filters jsonb not null default '{}'::jsonb,
  is_default boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(owner_id, page_key, name)
);

create table if not exists public.admin_report_schedules (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 2 and 120),
  report_key text not null,
  format text not null default 'pdf' check (format in ('pdf','csv','json')),
  cadence text not null default 'weekly' check (cadence in ('daily','weekly','monthly','manual')),
  filters jsonb not null default '{}'::jsonb,
  recipients text[] not null default '{}',
  active boolean not null default true,
  next_run_at timestamptz,
  last_run_at timestamptz,
  last_status text,
  last_error text,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_restore_exercises (
  id uuid primary key default gen_random_uuid(),
  environment text not null check (environment in ('isolated','staging','disaster-recovery')),
  backup_reference text not null,
  status text not null default 'planned' check (status in ('planned','running','passed','failed','cancelled')),
  started_at timestamptz,
  finished_at timestamptz,
  recovery_time_minutes integer check (recovery_time_minutes is null or recovery_time_minutes >= 0),
  data_loss_minutes integer check (data_loss_minutes is null or data_loss_minutes >= 0),
  integrity_checks jsonb not null default '[]'::jsonb,
  result_notes text not null default '',
  evidence_url text,
  executed_by uuid,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_translation_items (
  id uuid primary key default gen_random_uuid(),
  entity_type text not null check (entity_type in ('course','category','email','system_message','information')),
  entity_id text not null,
  source_locale text not null default 'fr',
  target_locale text not null,
  source_text text not null,
  translated_text text not null default '',
  source_hash text not null,
  status text not null default 'missing' check (status in ('missing','draft','review','approved','outdated')),
  version integer not null default 1 check (version > 0),
  reviewed_by uuid,
  reviewed_at timestamptz,
  updated_by uuid default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(entity_type, entity_id, target_locale)
);

create index if not exists admin_translation_items_status_idx
  on public.admin_translation_items(target_locale, status, entity_type);

create table if not exists public.admin_external_metrics (
  id bigint generated always as identity primary key,
  source_key text not null references public.admin_data_sources(source_key) on delete restrict,
  provider_id text not null,
  metric_date date not null,
  metric_key text not null,
  numeric_value numeric not null,
  unit text not null,
  dimensions jsonb not null default '{}'::jsonb,
  imported_at timestamptz not null default now(),
  unique(source_key, provider_id, metric_key)
);

create index if not exists admin_external_metrics_query_idx
  on public.admin_external_metrics(metric_key, metric_date desc, source_key);

create table if not exists public.admin_store_reviews (
  id uuid primary key default gen_random_uuid(),
  source_key text not null references public.admin_data_sources(source_key) on delete restrict,
  provider_review_id text not null,
  platform text not null check (platform in ('ios','android')),
  rating smallint not null check (rating between 1 and 5),
  title text,
  review_text text not null default '',
  app_version text,
  country_code text,
  theme text,
  internal_status text not null default 'new' check (internal_status in ('new','analysed','planned','resolved','ignored')),
  public_created_at timestamptz,
  imported_at timestamptz not null default now(),
  unique(source_key, provider_review_id)
);

create index if not exists admin_store_reviews_query_idx
  on public.admin_store_reviews(platform, internal_status, public_created_at desc);

create table if not exists public.admin_bulk_jobs (
  id uuid primary key default gen_random_uuid(),
  action text not null check (action in ('operations_start','operations_complete','operations_archive')),
  target_ids uuid[] not null,
  target_count integer not null check (target_count > 0),
  status text not null default 'previewed' check (status in ('previewed','executed','failed','cancelled')),
  preview jsonb not null,
  result jsonb,
  created_by uuid default auth.uid(),
  executed_by uuid,
  created_at timestamptz not null default now(),
  executed_at timestamptz
);

do $$
declare v_table text;
begin
  foreach v_table in array array[
    'admin_data_sources','admin_data_source_runs','admin_saved_views',
    'admin_report_schedules','admin_restore_exercises','admin_translation_items',
    'admin_external_metrics','admin_store_reviews','admin_bulk_jobs'
  ] loop
    execute format('alter table public.%I enable row level security', v_table);
    execute format('revoke all on table public.%I from public, anon, authenticated', v_table);
  end loop;
end $$;

revoke all on sequence public.admin_data_source_runs_id_seq from public, anon, authenticated;
revoke all on sequence public.admin_external_metrics_id_seq from public, anon, authenticated;

insert into public.admin_data_sources
  (source_key,label,category,source_mode,connection_status,freshness_target_minutes,public_config)
values
  ('supabase.app_logs','Activité et qualité applicative','analytics','realtime','healthy',15,'{"contains_personal_data":false}'::jsonb),
  ('supabase.learning','Réponses et progression pédagogique','learning','realtime','healthy',15,'{"four_journeys":true}'::jsonb),
  ('supabase.billing','Abonnements et factures internes','billing','realtime','healthy',60,'{"authoritative_for":"internal_status"}'::jsonb),
  ('supabase.content','Cours, quiz et contenus actifs','product','realtime','healthy',15,'{"four_journeys":true,"active_separate":true}'::jsonb),
  ('brevo.email','Remise des e-mails de service','email','imported','healthy',1440,'{"secret_location":"server_only"}'::jsonb),
  ('apple.appstore','App Store Connect','store','imported','not_connected',1440,'{"secret_location":"server_only"}'::jsonb),
  ('google.play','Google Play Console','store','imported','not_connected',1440,'{"secret_location":"server_only"}'::jsonb),
  ('revenuecat.subscriptions','RevenueCat','billing','imported','not_connected',60,'{"secret_location":"server_only"}'::jsonb),
  ('stripe.billing','Stripe','billing','imported','not_connected',60,'{"secret_location":"server_only"}'::jsonb),
  ('supabase.platform','Supabase Platform','infrastructure','imported','not_connected',1440,'{"secret_location":"server_only"}'::jsonb)
on conflict (source_key) do update set
  label=excluded.label, category=excluded.category, source_mode=excluded.source_mode,
  freshness_target_minutes=excluded.freshness_target_minutes,
  public_config=public.admin_data_sources.public_config || excluded.public_config,
  updated_at=now();

comment on table public.admin_data_sources is 'Secret-free registry of analytics, billing, store and infrastructure sources.';
comment on table public.admin_external_metrics is 'Normalized imported metrics. Provider credentials never belong in this table.';
comment on table public.admin_bulk_jobs is 'Owner-only, preview-first bulk operations with exact confirmation.';

create or replace function public.admin_premium_control_overview(p_days integer default 30)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, auth
as $$
declare
  v_days integer := least(greatest(coalesce(p_days,30),7),90);
  v_result jsonb;
  v_activity_days integer;
  v_answer_days integer;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode='42501';
  end if;

  select count(distinct created_at::date) into v_activity_days
  from public.app_logs where created_at >= current_date - (v_days - 1);
  select count(distinct answered_at::date) into v_answer_days
  from public.quiz_answer_history where answered_at >= current_date - (v_days - 1);

  with activity_daily as (
    select d::date as day_value, count(distinct l.user_id)::numeric as metric_value
    from generate_series(current_date-(v_days-1),current_date,'1 day') d
    left join public.app_logs l on l.created_at >= d and l.created_at < d + interval '1 day'
    group by d
  ), activity_model as (
    select regr_slope(metric_value, day_number::numeric) as slope,
      regr_intercept(metric_value, day_number::numeric) as intercept,
      stddev_pop(metric_value) as deviation
    from (select metric_value, row_number() over(order by day_value) as day_number from activity_daily) x
  ), answers_daily as (
    select d::date as day_value, count(a.id)::numeric as metric_value
    from generate_series(current_date-(v_days-1),current_date,'1 day') d
    left join public.quiz_answer_history a on a.answered_at >= d and a.answered_at < d + interval '1 day'
    group by d
  ), answers_model as (
    select regr_slope(metric_value, day_number::numeric) as slope,
      regr_intercept(metric_value, day_number::numeric) as intercept,
      stddev_pop(metric_value) as deviation
    from (select metric_value, row_number() over(order by day_value) as day_number from answers_daily) x
  )
  select jsonb_build_object(
    'refreshed_at',now(),
    'days',v_days,
    'sources',coalesce((select jsonb_agg(jsonb_build_object(
      'key',s.source_key,'label',s.label,'category',s.category,'mode',s.source_mode,
      'status',case when s.connection_status='healthy' and s.last_success_at is not null
        and s.last_success_at < now() - make_interval(mins=>s.freshness_target_minutes) then 'delayed'
        else s.connection_status end,
      'freshness_target_minutes',s.freshness_target_minutes,'last_success_at',s.last_success_at,
      'last_failure_at',s.last_failure_at,'next_check_at',s.next_check_at,
      'record_count',s.record_count,'last_error',s.last_error,'public_config',s.public_config,
      'latest_run',(select to_jsonb(r) - 'triggered_by' from public.admin_data_source_runs r where r.source_key=s.source_key order by r.started_at desc limit 1)
    ) order by s.category,s.label) from public.admin_data_sources s),'[]'::jsonb),
    'economy',jsonb_build_object(
      'gross_revenue_cents',coalesce((select sum(amount_cents) from public.billing_invoices where status in ('paid','succeeded') and coalesce(paid_at,created_at)>=now()-make_interval(days=>v_days)),0),
      'paid_invoices',coalesce((select count(*) from public.billing_invoices where status in ('paid','succeeded') and coalesce(paid_at,created_at)>=now()-make_interval(days=>v_days)),0),
      'active_subscriptions',coalesce((select count(*) from public.cas_pratique_subscriptions where status in ('active','trialing')),0),
      'trials',coalesce((select count(*) from public.cas_pratique_subscriptions where status='trialing'),0),
      'cancel_at_period_end',coalesce((select count(*) from public.cas_pratique_subscriptions where cancel_at_period_end),0),
      'past_due',coalesce((select count(*) from public.cas_pratique_subscriptions where status in ('past_due','unpaid','grace_period')),0),
      'expired',coalesce((select count(*) from public.cas_pratique_subscriptions where status in ('expired','canceled')),0),
      'by_store',coalesce((select jsonb_agg(jsonb_build_object('store',store,'total',total)) from (select coalesce(store,payment_source,'unknown') store,count(*) total from public.cas_pratique_subscriptions group by 1 order by 2 desc) q),'[]'::jsonb),
      'external_metrics_available',(select count(*) from public.admin_external_metrics where metric_date>=current_date-(v_days-1))
    ),
    'content_quality',jsonb_build_object(
      'courses_total',(select count(*) from public.cours_scolarite),
      'courses_published',(select count(*) from public.cours_scolarite where is_published or publication_status='published'),
      'courses_without_body',(select count(*) from public.cours_scolarite where coalesce(length(btrim(body_md)),0)<20 and jsonb_array_length(coalesce(content_blocks,'[]'::jsonb))=0),
      'courses_without_media_alt',(select count(*) from public.cours_scolarite_media where coalesce(length(btrim(alt_text)),0)=0),
      'orphan_courses',(select count(*) from public.cours_scolarite c where c.parent_route is not null and not exists(select 1 from public.cours_scolarite p where p.route=c.parent_route)),
      'active_nodes_total',(select count(*) from public.active_content_nodes where status<>'archived'),
      'active_nodes_without_image',(select count(*) from public.active_content_nodes where status<>'archived' and node_type<>'course' and coalesce(image_url,'')=''),
      'translations',jsonb_build_object(
        'total',(select count(*) from public.admin_translation_items),
        'approved',(select count(*) from public.admin_translation_items where status='approved'),
        'missing',(select count(*) from public.admin_translation_items where status in ('missing','outdated'))
      )
    ),
    'store_reviews',jsonb_build_object(
      'total',(select count(*) from public.admin_store_reviews),
      'unprocessed',(select count(*) from public.admin_store_reviews where internal_status='new'),
      'average_rating',(select round(avg(rating)::numeric,2) from public.admin_store_reviews),
      'by_platform',coalesce((select jsonb_agg(jsonb_build_object('platform',platform,'reviews',reviews,'rating',rating)) from (select platform,count(*) reviews,round(avg(rating)::numeric,2) rating from public.admin_store_reviews group by platform) q),'[]'::jsonb)
    ),
    'forecast',jsonb_build_object(
      'method','Régression linéaire sur les valeurs quotidiennes ; intervalle indicatif fondé sur 1,96 écart-type.',
      'minimum_observed_days',14,
      'activity_available',v_activity_days>=14,
      'answers_available',v_answer_days>=14,
      'activity_observed_days',v_activity_days,
      'answers_observed_days',v_answer_days,
      'activity',case when v_activity_days>=14 then (select jsonb_agg(jsonb_build_object('date',current_date+n,'estimate',greatest(0,round(intercept+slope*(v_days+n))),'low',greatest(0,round(intercept+slope*(v_days+n)-1.96*coalesce(deviation,0))),'high',greatest(0,round(intercept+slope*(v_days+n)+1.96*coalesce(deviation,0)))) order by n) from activity_model cross join generate_series(1,7) n) else '[]'::jsonb end,
      'answers',case when v_answer_days>=14 then (select jsonb_agg(jsonb_build_object('date',current_date+n,'estimate',greatest(0,round(intercept+slope*(v_days+n))),'low',greatest(0,round(intercept+slope*(v_days+n)-1.96*coalesce(deviation,0))),'high',greatest(0,round(intercept+slope*(v_days+n)+1.96*coalesce(deviation,0)))) order by n) from answers_model cross join generate_series(1,7) n) else '[]'::jsonb end
    ),
    'saved_views',(select count(*) from public.admin_saved_views where owner_id=auth.uid()),
    'report_schedules',(select count(*) from public.admin_report_schedules where active),
    'restore_exercises',jsonb_build_object(
      'total',(select count(*) from public.admin_restore_exercises),
      'passed',(select count(*) from public.admin_restore_exercises where status='passed'),
      'failed',(select count(*) from public.admin_restore_exercises where status='failed'),
      'last',(select to_jsonb(e)-'created_by'-'executed_by' from public.admin_restore_exercises e order by coalesce(finished_at,created_at) desc limit 1)
    )
  ) into v_result
  from activity_model, answers_model;
  return v_result;
end;
$$;

create or replace function public.admin_content_dependency_graph(p_search text default null)
returns jsonb
language plpgsql stable security definer set search_path=public,auth as $$
declare v_result jsonb;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  select jsonb_build_object(
    'nodes',coalesce(jsonb_agg(node order by node->>'label') filter(where node is not null),'[]'::jsonb),
    'edges',coalesce(jsonb_agg(edges) filter(where edges is not null),'[]'::jsonb)
  ) into v_result
  from (
    select jsonb_build_object('id','course:'||c.id,'entity_type','course','entity_id',c.id::text,'label',c.title,'route',c.route,'scope',coalesce(c.track,'unknown'),'status',coalesce(c.publication_status,case when c.is_published then 'published' else 'draft' end),'warnings',jsonb_build_array(case when coalesce(length(btrim(c.body_md)),0)<20 and jsonb_array_length(coalesce(c.content_blocks,'[]'::jsonb))=0 then 'Contenu vide' end)) node,
      case when c.parent_route is not null then jsonb_build_object('from','course:'||(select p.id from public.cours_scolarite p where p.route=c.parent_route limit 1),'to','course:'||c.id,'relation','parent') end edges
    from public.cours_scolarite c
    where p_search is null or btrim(p_search)='' or c.title ilike '%'||btrim(p_search)||'%' or c.route ilike '%'||btrim(p_search)||'%'
    union all
    select jsonb_build_object('id','active:'||n.id,'entity_type','active_node','entity_id',n.id::text,'label',n.title,'route',null,'scope','active','status',n.status,'warnings',jsonb_build_array(case when n.node_type<>'course' and coalesce(n.image_url,'')='' then 'Image manquante' end)),
      case when n.parent_id is not null then jsonb_build_object('from','active:'||n.parent_id,'to','active:'||n.id,'relation','parent') end
    from public.active_content_nodes n
    where n.status<>'archived' and (p_search is null or btrim(p_search)='' or n.title ilike '%'||btrim(p_search)||'%')
  ) x;
  return v_result;
end; $$;

create or replace function public.admin_content_impact_preview(p_entity_type text,p_entity_id text)
returns jsonb language plpgsql stable security definer set search_path=public,auth as $$
declare v_result jsonb;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  if p_entity_type='course' then
    select jsonb_build_object(
      'entity',jsonb_build_object('type','course','id',c.id,'title',c.title,'route',c.route,'track',c.track,'status',coalesce(c.publication_status,case when c.is_published then 'published' else 'draft' end)),
      'impact_level',case when (select count(*) from public.app_logs where route=c.route and created_at>=now()-interval '30 days')>=100 then 'high' when (select count(*) from public.app_logs where route=c.route and created_at>=now()-interval '30 days')>=20 then 'medium' else 'low' end,
      'users_30d',(select count(distinct user_id) from public.app_logs where route=c.route and created_at>=now()-interval '30 days'),
      'views_30d',(select count(*) from public.app_logs where route=c.route and created_at>=now()-interval '30 days'),
      'children',(select count(*) from public.cours_scolarite ch where ch.parent_route=c.route),
      'media',(select count(*) from public.cours_scolarite_media m where m.course_id=c.id),
      'versions',(select count(*) from public.cours_scolarite_versions v where v.course_id=c.id),
      'quiz_answers_30d',(select count(*) from public.quiz_answer_history q where q.module_key=c.quiz_module and q.answered_at>=now()-interval '30 days'),
      'checks',jsonb_build_array(
        jsonb_build_object('label','Titre renseigné','ok',length(btrim(c.title))>=3),
        jsonb_build_object('label','Contenu renseigné','ok',coalesce(length(btrim(c.body_md)),0)>=20 or jsonb_array_length(coalesce(c.content_blocks,'[]'::jsonb))>0),
        jsonb_build_object('label','Parent valide','ok',c.parent_route is null or exists(select 1 from public.cours_scolarite p where p.route=c.parent_route)),
        jsonb_build_object('label','Médias accessibles','ok',not exists(select 1 from public.cours_scolarite_media m where m.course_id=c.id and coalesce(m.storage_path,'')=''))
      )
    ) into v_result from public.cours_scolarite c where c.id=p_entity_id::bigint;
  elsif p_entity_type='active_node' then
    select jsonb_build_object(
      'entity',jsonb_build_object('type','active_node','id',n.id,'title',n.title,'status',n.status,'node_type',n.node_type),
      'impact_level',case when (select count(*) from public.active_content_nodes ch where ch.parent_id=n.id)>0 then 'medium' else 'low' end,
      'children',(select count(*) from public.active_content_nodes ch where ch.parent_id=n.id and ch.status<>'archived'),
      'checks',jsonb_build_array(
        jsonb_build_object('label','Titre renseigné','ok',length(btrim(n.title))>=3),
        jsonb_build_object('label','Parent valide','ok',n.parent_id is null or exists(select 1 from public.active_content_nodes p where p.id=n.parent_id)),
        jsonb_build_object('label','Image de catégorie','ok',n.node_type='course' or coalesce(n.image_url,'')<>''),
        jsonb_build_object('label','Contenu de cours','ok',n.node_type<>'course' or jsonb_array_length(coalesce(n.draft_content,'[]'::jsonb))>0)
      )
    ) into v_result from public.active_content_nodes n where n.id=p_entity_id::uuid;
  else raise exception 'Type de contenu inconnu.' using errcode='22023'; end if;
  if v_result is null then raise exception 'Contenu introuvable.' using errcode='P0002'; end if;
  return v_result;
end; $$;

create or replace function public.admin_bulk_operations_preview(p_action text,p_target_ids uuid[])
returns jsonb language plpgsql security definer set search_path=public,auth as $$
declare v_count integer; v_preview jsonb;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  if p_action not in ('operations_start','operations_complete','operations_archive') then raise exception 'Action groupée non autorisée.' using errcode='22023'; end if;
  if coalesce(array_length(p_target_ids,1),0)=0 or array_length(p_target_ids,1)>100 then raise exception 'Sélection requise (100 éléments maximum).' using errcode='22023'; end if;
  select count(*),coalesce(jsonb_agg(jsonb_build_object('id',id,'title',title,'from_status',status,'priority',priority)),'[]'::jsonb)
    into v_count,v_preview from public.admin_operations_items where id=any(p_target_ids);
  if v_count<>array_length(p_target_ids,1) then raise exception 'La sélection contient un élément introuvable.' using errcode='P0002'; end if;
  return jsonb_build_object('action',p_action,'target_count',v_count,'targets',v_preview,'confirmation','APPLIQUER '||v_count,'effects',case p_action when 'operations_start' then 'Passage au statut En cours' when 'operations_complete' then 'Clôture à 100 %' else 'Archivage des éléments' end);
end; $$;

create or replace function public.admin_bulk_operations_execute(p_action text,p_target_ids uuid[],p_confirmation text)
returns jsonb language plpgsql security definer set search_path=public,auth as $$
declare v_preview jsonb; v_count integer; v_job uuid; v_status text;
begin
  v_preview:=public.admin_bulk_operations_preview(p_action,p_target_ids);
  v_count:=(v_preview->>'target_count')::integer;
  if p_confirmation<>v_preview->>'confirmation' then raise exception 'Confirmation exacte requise : %',v_preview->>'confirmation' using errcode='22023'; end if;
  v_status:=case p_action when 'operations_start' then 'in_progress' when 'operations_complete' then 'done' else 'archived' end;
  insert into public.admin_bulk_jobs(action,target_ids,target_count,preview,status) values(p_action,p_target_ids,v_count,v_preview,'previewed') returning id into v_job;
  update public.admin_operations_items set status=v_status,progress=case when v_status='done' then 100 else progress end where id=any(p_target_ids);
  insert into public.admin_operations_history(item_id,action,to_status,note,snapshot)
    select id,'bulk_'||p_action,v_status,'Opération groupée '||v_job,jsonb_build_object('job_id',v_job,'action',p_action) from public.admin_operations_items where id=any(p_target_ids);
  update public.admin_bulk_jobs set status='executed',result=jsonb_build_object('updated',v_count,'status',v_status),executed_by=auth.uid(),executed_at=now() where id=v_job;
  return jsonb_build_object('job_id',v_job,'updated',v_count,'status',v_status);
exception when others then
  if v_job is not null then update public.admin_bulk_jobs set status='failed',result=jsonb_build_object('error',sqlerrm),executed_by=auth.uid(),executed_at=now() where id=v_job; end if;
  raise;
end; $$;

create or replace function public.admin_saved_views_list(p_page_key text default null)
returns setof public.admin_saved_views language plpgsql stable security definer set search_path=public,auth as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  return query select * from public.admin_saved_views v where v.owner_id=auth.uid() and (p_page_key is null or v.page_key=p_page_key) order by v.is_default desc,v.updated_at desc;
end; $$;

create or replace function public.admin_saved_view_save(p_id uuid,p_name text,p_page_key text,p_filters jsonb,p_is_default boolean default false)
returns public.admin_saved_views language plpgsql security definer set search_path=public,auth as $$
declare v_row public.admin_saved_views;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  if p_is_default then update public.admin_saved_views set is_default=false where owner_id=auth.uid() and page_key=p_page_key; end if;
  insert into public.admin_saved_views(id,owner_id,name,page_key,filters,is_default)
  values(coalesce(p_id,gen_random_uuid()),auth.uid(),btrim(p_name),p_page_key,coalesce(p_filters,'{}'::jsonb),coalesce(p_is_default,false))
  on conflict(id) do update set name=excluded.name,filters=excluded.filters,is_default=excluded.is_default,updated_at=now()
  where public.admin_saved_views.owner_id=auth.uid()
  returning * into v_row;
  return v_row;
end; $$;

create or replace function public.admin_restore_exercises_list()
returns setof public.admin_restore_exercises language plpgsql stable security definer set search_path=public,auth as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  return query select * from public.admin_restore_exercises order by coalesce(finished_at,started_at,created_at) desc limit 100;
end; $$;

create or replace function public.admin_restore_exercise_save(p_data jsonb)
returns public.admin_restore_exercises language plpgsql security definer set search_path=public,auth as $$
declare v_row public.admin_restore_exercises; v_id uuid:=nullif(p_data->>'id','')::uuid;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  insert into public.admin_restore_exercises(id,environment,backup_reference,status,started_at,finished_at,recovery_time_minutes,data_loss_minutes,integrity_checks,result_notes,evidence_url,executed_by)
  values(coalesce(v_id,gen_random_uuid()),coalesce(nullif(p_data->>'environment',''),'isolated'),btrim(p_data->>'backup_reference'),coalesce(nullif(p_data->>'status',''),'planned'),nullif(p_data->>'started_at','')::timestamptz,nullif(p_data->>'finished_at','')::timestamptz,nullif(p_data->>'recovery_time_minutes','')::integer,nullif(p_data->>'data_loss_minutes','')::integer,coalesce(p_data->'integrity_checks','[]'::jsonb),coalesce(p_data->>'result_notes',''),nullif(p_data->>'evidence_url',''),case when p_data->>'status' in ('passed','failed') then auth.uid() else null end)
  on conflict(id) do update set environment=excluded.environment,backup_reference=excluded.backup_reference,status=excluded.status,started_at=excluded.started_at,finished_at=excluded.finished_at,recovery_time_minutes=excluded.recovery_time_minutes,data_loss_minutes=excluded.data_loss_minutes,integrity_checks=excluded.integrity_checks,result_notes=excluded.result_notes,evidence_url=excluded.evidence_url,executed_by=excluded.executed_by,updated_at=now()
  returning * into v_row;
  return v_row;
end; $$;

create or replace function public.admin_translation_overview()
returns jsonb language plpgsql stable security definer set search_path=public,auth as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  return jsonb_build_object('items',coalesce((select jsonb_agg(to_jsonb(t)-'source_text' order by target_locale,entity_type,entity_id) from public.admin_translation_items t),'[]'::jsonb),'by_locale',coalesce((select jsonb_agg(jsonb_build_object('locale',target_locale,'total',total,'approved',approved,'missing',missing)) from (select target_locale,count(*) total,count(*) filter(where status='approved') approved,count(*) filter(where status in ('missing','outdated')) missing from public.admin_translation_items group by target_locale) x),'[]'::jsonb));
end; $$;

create or replace function public.admin_store_reviews_list(p_status text default null,p_platform text default null)
returns setof public.admin_store_reviews language plpgsql stable security definer set search_path=public,auth as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  return query select * from public.admin_store_reviews r where (p_status is null or r.internal_status=p_status) and (p_platform is null or r.platform=p_platform) order by r.public_created_at desc nulls last,r.imported_at desc limit 500;
end; $$;

do $$
declare r record;
begin
  for r in select p.oid::regprocedure proc from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname in (
    'admin_premium_control_overview','admin_content_dependency_graph','admin_content_impact_preview',
    'admin_bulk_operations_preview','admin_bulk_operations_execute','admin_saved_views_list',
    'admin_saved_view_save','admin_restore_exercises_list','admin_restore_exercise_save',
    'admin_translation_overview','admin_store_reviews_list'
  ) loop
    execute format('revoke all on function %s from public, anon',r.proc);
    execute format('grant execute on function %s to authenticated',r.proc);
  end loop;
end $$;
