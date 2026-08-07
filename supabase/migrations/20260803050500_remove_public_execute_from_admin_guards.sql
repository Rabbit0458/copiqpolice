-- Certaines anciennes fonctions avaient conservé le privilège EXECUTE accordé
-- implicitement à PUBLIC lors de leur création. Retirer seulement `anon` ne
-- suffisait donc pas, car ce rôle hérite des privilèges de PUBLIC.

revoke execute on function public.cp_admin_guard() from public;
revoke execute on function public.cp_admin_list_question_reports(text) from public;
revoke execute on function public.cp_admin_resolve_question_report(uuid, text, text) from public;
revoke execute on function public.forum_admin_guard() from public;

grant execute on function public.cp_admin_list_question_reports(text) to authenticated;
grant execute on function public.cp_admin_resolve_question_report(uuid, text, text) to authenticated;
