-- COP'IQ — Durcissement du système de badges (30/07/2026, suite immédiate
-- de 20260730000000_user_badges_system.sql), suite à l'auditeur de sécurité
-- Supabase relancé après la migration initiale :
--
--   1. count_quiz_attempts / get_public_profile_badge(s) restaient
--      exécutables par le rôle `anon` (non authentifié) : un GRANT à
--      `authenticated` n'annule pas le GRANT par défaut à `PUBLIC` que
--      Postgres pose à la création d'une fonction — il faut le révoquer
--      explicitement.
--   2. quiz_history_rate_limit() est une fonction de trigger interne ;
--      elle n'a aucune raison d'être appelable en RPC directe.
--   3. compute_badge_type() et prevent_direct_role_change() n'avaient pas
--      de `search_path` fixé (avis `function_search_path_mutable`).

REVOKE EXECUTE ON FUNCTION public.count_quiz_attempts(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.count_quiz_attempts(uuid) TO authenticated;

REVOKE EXECUTE ON FUNCTION public.get_public_profile_badges(uuid[]) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_public_profile_badges(uuid[]) TO authenticated;

REVOKE EXECUTE ON FUNCTION public.get_public_profile_badge(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_public_profile_badge(uuid) TO authenticated;

REVOKE EXECUTE ON FUNCTION public.quiz_history_rate_limit() FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.compute_badge_type(p_role public.user_role, p_quiz_count integer)
RETURNS text
LANGUAGE sql
IMMUTABLE
SET search_path TO 'public'
AS $$
  SELECT CASE
    WHEN p_role IN ('owner', 'admin') THEN 'admin'
    WHEN p_role = 'moderator' THEN 'moderator'
    WHEN COALESCE(p_quiz_count, 0) >= 2000 THEN 'legend'
    WHEN COALESCE(p_quiz_count, 0) >= 100 THEN 'active'
    ELSE 'none'
  END;
$$;

CREATE OR REPLACE FUNCTION public.prevent_direct_role_change()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $$
BEGIN
  IF NEW.role IS DISTINCT FROM OLD.role THEN
    IF current_setting('copiq.role_change_authorized', true) IS DISTINCT FROM 'true' THEN
      RAISE EXCEPTION 'role_change_forbidden: use public.set_user_role()' USING ERRCODE = '42501';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;
