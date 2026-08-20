-- ============================================================================
--  COP'IQ — Correctif : restaure public.community_admin_guard()
--  ---------------------------------------------------------------------------
--  Découvert en auditant la base avant d'appliquer 20260820100000 : la
--  fonction partagée `community_admin_guard()`, décrite et censée exister
--  depuis 20260818120000_community_admin_user_dossier.sql, n'existait plus
--  en production (seules les gardes propres à chaque module existaient :
--  quiz_admin_guard, cp_admin_guard, forum_admin_guard, information_admin_guard).
--
--  Conséquence avant ce correctif : `community_admin_user_detail`,
--  `community_admin_user_timeline` et toutes les nouvelles RPC de
--  20260820100000 échouaient avec `function public.community_admin_guard()
--  does not exist` — cassant la Vue d'ensemble du dossier utilisateur.
--
--  Ce fichier documente le correctif appliqué manuellement en production
--  (via execute_sql) le 2026-08-21, pour que le dépôt reste synchronisé avec
--  l'état réel de la base. Rejouable sans risque (CREATE OR REPLACE).
-- ============================================================================

create or replace function public.community_admin_guard()
returns void language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.has_admin_role('owner','admin','moderator') then
    raise exception 'Accès refusé' using errcode = '42501';
  end if;
end;
$$;

comment on function public.community_admin_guard() is
  'Garde partagée des RPC de dossier utilisateur : rôle owner/admin/moderator obligatoire.';

revoke all on function public.community_admin_guard() from public, anon;
grant execute on function public.community_admin_guard() to authenticated;
