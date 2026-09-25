-- Keep internal source freshness truthful without relying on a third-party job.

create or replace function public.admin_data_sources_refresh_internal()
returns jsonb
language plpgsql
security definer
set search_path=public,auth
as $$
declare v_now timestamptz:=now();
begin
  if not public.has_admin_role('owner') or not public.admin_require_aal2() then
    raise exception 'Accès refusé.' using errcode='42501';
  end if;

  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,
    record_count=(select count(*) from public.app_logs),last_error=null,updated_by=auth.uid(),updated_at=v_now
  where source_key='supabase.app_logs';
  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,
    record_count=(select count(*) from public.quiz_answer_history),last_error=null,updated_by=auth.uid(),updated_at=v_now
  where source_key='supabase.learning';
  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,
    record_count=(select count(*) from public.cas_pratique_subscriptions),last_error=null,updated_by=auth.uid(),updated_at=v_now
  where source_key='supabase.billing';
  update public.admin_data_sources set connection_status='healthy',last_success_at=v_now,
    record_count=((select count(*) from public.cours_scolarite)+(select count(*) from public.active_content_nodes)),last_error=null,updated_by=auth.uid(),updated_at=v_now
  where source_key='supabase.content';
  update public.admin_data_sources set
    connection_status=case when exists(select 1 from public.admin_email_campaigns) then 'healthy' else 'not_connected' end,
    last_success_at=(select max(completed_at) from public.admin_email_campaigns where status in ('sent','partial')),
    record_count=(select count(*) from public.admin_email_deliveries),updated_by=auth.uid(),updated_at=v_now
  where source_key='brevo.email';

  return jsonb_build_object('refreshed_at',v_now,'sources',5);
end;
$$;

revoke all on function public.admin_data_sources_refresh_internal() from public,anon;
grant execute on function public.admin_data_sources_refresh_internal() to authenticated;

