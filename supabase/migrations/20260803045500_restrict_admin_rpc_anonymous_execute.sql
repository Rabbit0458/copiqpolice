-- Réduit la surface publique des RPC utilisées par copiq.fr/admin.
-- Les contrôles internes de rôle restent obligatoires : ce REVOKE constitue
-- une défense supplémentaire et non un remplacement des gardes applicatives.

revoke execute on function public.admin_dashboard_stats_fast() from anon;
revoke execute on function public.admin_dashboard_stats_v2() from anon;
revoke execute on function public.admin_refresh_dashboard_stats() from anon;
revoke execute on function public.admin_recent_audit_logs(text, text, integer, integer) from anon;
revoke execute on function public.admin_reports_unified(text, text, text, integer, integer) from anon;
revoke execute on function public.admin_resolve_report(text, text, text, boolean, text) from anon;
revoke execute on function public.admin_users_overview(text, text, text, integer, integer) from anon;

revoke execute on function public.cp_admin_guard() from anon;
revoke execute on function public.cp_admin_list_question_reports(text) from anon;
revoke execute on function public.cp_admin_resolve_question_report(uuid, text, text) from anon;
revoke execute on function public.forum_admin_guard() from anon;

-- Les appels du panel sont effectués avec une session Supabase authentifiée.
grant execute on function public.admin_dashboard_stats_fast() to authenticated;
grant execute on function public.admin_dashboard_stats_v2() to authenticated;
grant execute on function public.admin_refresh_dashboard_stats() to authenticated;
grant execute on function public.admin_recent_audit_logs(text, text, integer, integer) to authenticated;
grant execute on function public.admin_reports_unified(text, text, text, integer, integer) to authenticated;
grant execute on function public.admin_resolve_report(text, text, text, boolean, text) to authenticated;
grant execute on function public.admin_users_overview(text, text, text, integer, integer) to authenticated;
grant execute on function public.cp_admin_list_question_reports(text) to authenticated;
grant execute on function public.cp_admin_resolve_question_report(uuid, text, text) to authenticated;
