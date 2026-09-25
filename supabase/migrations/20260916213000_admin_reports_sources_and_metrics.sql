-- Scheduled report definitions, source-run visibility and a complete metric catalog.

create or replace function public.admin_report_schedules_list()
returns setof public.admin_report_schedules
language plpgsql stable security definer set search_path=public,auth as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  return query select * from public.admin_report_schedules order by active desc,next_run_at nulls last,updated_at desc;
end; $$;

create or replace function public.admin_report_schedule_save(p_data jsonb)
returns public.admin_report_schedules
language plpgsql security definer set search_path=public,auth as $$
declare v_id uuid:=nullif(p_data->>'id','')::uuid; v_row public.admin_report_schedules;
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  if coalesce(length(btrim(p_data->>'name')),0)<2 then raise exception 'Nom requis.' using errcode='22023'; end if;
  insert into public.admin_report_schedules(id,name,report_key,format,cadence,filters,recipients,active,next_run_at)
  values(coalesce(v_id,gen_random_uuid()),btrim(p_data->>'name'),coalesce(nullif(p_data->>'report_key',''),'premium-control'),coalesce(nullif(p_data->>'format',''),'pdf'),coalesce(nullif(p_data->>'cadence',''),'weekly'),coalesce(p_data->'filters','{}'::jsonb),coalesce(array(select jsonb_array_elements_text(coalesce(p_data->'recipients','[]'::jsonb))),'{}'::text[]),coalesce((p_data->>'active')::boolean,true),nullif(p_data->>'next_run_at','')::timestamptz)
  on conflict(id) do update set name=excluded.name,report_key=excluded.report_key,format=excluded.format,cadence=excluded.cadence,filters=excluded.filters,recipients=excluded.recipients,active=excluded.active,next_run_at=excluded.next_run_at,updated_at=now()
  returning * into v_row;
  return v_row;
end; $$;

create or replace function public.admin_data_source_runs_list(p_source_key text default null,p_limit integer default 100)
returns setof public.admin_data_source_runs
language plpgsql stable security definer set search_path=public,auth as $$
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  return query select * from public.admin_data_source_runs r where p_source_key is null or r.source_key=p_source_key order by r.started_at desc limit least(greatest(coalesce(p_limit,100),1),500);
end; $$;

create or replace function public.admin_data_sources_refresh_internal()
returns jsonb language plpgsql security definer set search_path=public,auth as $$
declare v_now timestamptz:=now();
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then raise exception 'Accès refusé.' using errcode='42501'; end if;
  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,record_count=(select count(*) from public.app_logs),last_error=null,updated_by=auth.uid(),updated_at=v_now where source_key='supabase.app_logs';
  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,record_count=(select count(*) from public.quiz_answer_history),last_error=null,updated_by=auth.uid(),updated_at=v_now where source_key='supabase.learning';
  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,record_count=(select count(*) from public.cas_pratique_subscriptions),last_error=null,updated_by=auth.uid(),updated_at=v_now where source_key='supabase.billing';
  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,record_count=((select count(*) from public.cours_scolarite)+(select count(*) from public.active_content_nodes)),last_error=null,updated_by=auth.uid(),updated_at=v_now where source_key='supabase.content';
  update public.admin_data_sources set connection_status=case when exists(select 1 from public.admin_email_campaigns) then 'healthy' else 'not_connected' end,last_success_at=(select max(completed_at) from public.admin_email_campaigns where status in ('sent','partial')),record_count=(select count(*) from public.admin_email_deliveries),updated_by=auth.uid(),updated_at=v_now where source_key='brevo.email';
  update public.admin_data_sources set connection_status='healthy',last_success_at=coalesce((select max(processed_at) from public.cp_stripe_webhook_events),v_now),record_count=(select count(*) from public.cp_stripe_webhook_events),last_error=null,updated_by=auth.uid(),updated_at=v_now where source_key='stripe.billing';
  update public.admin_data_sources set connection_status='healthy',last_success_at=coalesce((select max(processed_at) from public.cp_revenuecat_webhook_events),v_now),record_count=(select count(*) from public.cp_revenuecat_webhook_events),last_error=null,updated_by=auth.uid(),updated_at=v_now where source_key='revenuecat.subscriptions';
  return jsonb_build_object('refreshed_at',v_now,'sources',7);
end; $$;

insert into public.admin_metric_definitions(metric_key,label,definition,formula,source,unit,cadence,minimum_sample,interpretation_limit)
values
 ('billing.gross_revenue','Chiffre d’affaires brut','Somme des factures internes payées sur la période.','SUM(billing_invoices.amount_cents) WHERE status payé','billing_invoices','centimes EUR','temps réel',1,'N’inclut pas une source boutique tant que son import n’est pas raccordé.'),
 ('billing.at_risk','Abonnements à risque','Abonnements en retard, impayés ou en période de grâce.','COUNT(status IN past_due, unpaid, grace_period)','cas_pratique_subscriptions','abonnements','temps réel',1,'Un statut à risque n’est pas une perte définitive.'),
 ('content.quality_issues','Anomalies éditoriales','Somme des cours vides, médias sans alternative, orphelins et catégories sans image.','empty + missing_alt + orphan + active_missing_image','cours_scolarite + active_content_nodes','anomalies','temps réel',0,'Le score signale des contrôles à faire, pas nécessairement un défaut visible.'),
 ('sources.freshness','Fraîcheur des sources','Écart entre la dernière réussite et l’objectif de fraîcheur.','NOW - last_success_at comparé à freshness_target_minutes','admin_data_sources','état','60 s',0,'Une source non raccordée ne doit jamais être assimilée à zéro activité.'),
 ('forecast.activity_7d','Prévision d’activité à 7 jours','Projection indicative calculée uniquement avec au moins 14 jours observés.','régression linéaire + intervalle 1,96 écart-type','app_logs','utilisateurs','à la demande',14,'Prévision non contractuelle ; masquée si l’historique est insuffisant.'),
 ('forecast.answers_7d','Prévision de réponses à 7 jours','Projection des réponses réellement sauvegardées.','régression linéaire + intervalle 1,96 écart-type','quiz_answer_history','réponses','à la demande',14,'La longueur choisie pour un quiz n’est jamais comptée comme réponse.'),
 ('stores.rating','Note moyenne boutiques','Moyenne des avis importés depuis les boutiques.','AVG(rating)','admin_store_reviews','note / 5','après import',1,'Indisponible tant que les API boutiques ne sont pas raccordées.')
on conflict(metric_key) do update set label=excluded.label,definition=excluded.definition,formula=excluded.formula,source=excluded.source,unit=excluded.unit,cadence=excluded.cadence,minimum_sample=excluded.minimum_sample,interpretation_limit=excluded.interpretation_limit,version=public.admin_metric_definitions.version+1,updated_at=now();

do $$ declare r record; begin
  for r in select p.oid::regprocedure proc from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname in ('admin_report_schedules_list','admin_report_schedule_save','admin_data_source_runs_list','admin_data_sources_refresh_internal') loop
    execute format('revoke all on function %s from public,anon',r.proc);
    execute format('grant execute on function %s to authenticated',r.proc);
  end loop;
end $$;

