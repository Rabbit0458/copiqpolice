-- Audit COP'IQ : controles de catalogue uniquement, sans appel de purge.
-- A executer avec un compte d'audit autorise dans le projet correspondant.
-- EXECUTE client doit etre false pour les fonctions internes serveur.
-- purge_user : anon=false, authenticated=false, service_role=true.
-- set_admin_panel_code : authenticated=true est volontaire ; le corps
-- exige community_admin_owner_guard(), sauf pour le role serveur.
select
  p.proname,
  pg_get_function_identity_arguments(p.oid) as arguments,
  p.prosecdef as security_definer,
  pg_get_userbyid(p.proowner) as owner,
  has_schema_privilege('anon', n.oid, 'USAGE') as anon_schema_usage,
  has_function_privilege('anon', p.oid, 'EXECUTE') as anon_execute,
  has_function_privilege('authenticated', p.oid, 'EXECUTE') as authenticated_execute,
  has_function_privilege('service_role', p.oid, 'EXECUTE') as service_execute
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname in (
    'purge_user', 'set_admin_panel_code', 'apply_store_snapshot',
    'set_subscription_tier', 'set_user_subscription', 'grant_rewarded_request',
    'auth_email_exists', 'fn_cp_apply_streak_to_progress',
    'fn_cp_check_and_unlock_badges', 'fn_cp_award_xp_for_correction'
  )
order by p.proname;

-- Verifier la logique : une permission EXECUTE ne suffit pas a juger une RPC.
select p.proname, pg_get_functiondef(p.oid) as definition
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname in (
    'purge_user', 'set_admin_panel_code', 'grant_rewarded_request',
    'auth_email_exists'
  );

select tablename, policyname, roles, cmd, permissive, qual, with_check
from pg_policies
where schemaname = 'public'
  and tablename in (
    'cours_scolarite', 'quiz_scolarite_questions', 'scolarite_content_fragments',
    'cas_pratique_subscriptions', 'store_entitlements', 'user_profiles'
  )
order by tablename, policyname;
