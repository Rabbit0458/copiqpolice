-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 014 : leaderboard hebdomadaire      ║
-- ║  Tâche      : CODE-059                                                  ║
-- ║                                                                         ║
-- ║  Vue matérialisée `cas_pratique_weekly_leaderboard` qui agrège les    ║
-- ║  XP gagnés sur les **7 derniers jours glissants** par user (top 100).  ║
-- ║                                                                         ║
-- ║  Anonymisation : un pseudo stable est dérivé d'un hash MD5(user_id)    ║
-- ║  → "Apprenti #1234" (4 chiffres du hash). L'utilisateur courant se    ║
-- ║  reconnaît via la fonction `fn_cp_my_leaderboard_position()` qui      ║
-- ║  retourne SA propre ligne (rang + score + total user du leaderboard).  ║
-- ║                                                                         ║
-- ║  Refresh : à appeler toutes les heures via `pg_cron` (extension à     ║
-- ║  activer côté Supabase dashboard). La fonction de refresh est livrée   ║
-- ║  ici. Le cron est commenté en bas du fichier.                          ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

-- ─── Vue matérialisée ──────────────────────────────────────────────────────

DROP MATERIALIZED VIEW IF EXISTS public.cas_pratique_weekly_leaderboard CASCADE;

CREATE MATERIALIZED VIEW public.cas_pratique_weekly_leaderboard AS
WITH last_7_days_xp AS (
    SELECT
        user_id,
        COALESCE(SUM(delta), 0)::int AS weekly_xp,
        count(*)::int                AS actions_count,
        MAX(created_at)              AS last_action_at
    FROM public.cas_pratique_xp_ledger
    WHERE created_at >= now() - INTERVAL '7 days'
      AND delta > 0
    GROUP BY user_id
)
SELECT
    user_id,
    weekly_xp,
    actions_count,
    last_action_at,
    -- Rang stable (RANK pour gérer les égalités). Tie-break = last_action_at desc.
    DENSE_RANK() OVER (ORDER BY weekly_xp DESC, last_action_at DESC) AS rank,
    -- Pseudo anonymisé : "Apprenti #" + 4 derniers chars du MD5(user_id)
    'Apprenti #' || upper(substr(md5(user_id::text), -4)) AS anon_handle,
    now() AS refreshed_at
  FROM last_7_days_xp
 ORDER BY weekly_xp DESC, last_action_at DESC
 LIMIT 1000; -- on garde 1000 places pour le percentile global

CREATE UNIQUE INDEX IF NOT EXISTS idx_cp_weekly_lb_user
    ON public.cas_pratique_weekly_leaderboard(user_id);

CREATE INDEX IF NOT EXISTS idx_cp_weekly_lb_rank
    ON public.cas_pratique_weekly_leaderboard(rank);

COMMENT ON MATERIALIZED VIEW public.cas_pratique_weekly_leaderboard IS
    'CODE-059 : top users (XP gagnés sur 7j glissants) + pseudo anonymisé. À rafraîchir toutes les heures via fn_cp_refresh_weekly_leaderboard().';

-- Les materialized views n'ont pas de RLS native — on protège via la fonction
-- `fn_cp_get_leaderboard()` (SECURITY DEFINER, retourne uniquement les
-- colonnes safe : pas de user_id).

REVOKE ALL ON public.cas_pratique_weekly_leaderboard FROM PUBLIC, anon, authenticated;

-- ─── Fonction : récupère le top N ──────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_get_leaderboard(p_limit int DEFAULT 100)
RETURNS TABLE (
    rank          int,
    anon_handle   text,
    weekly_xp     int,
    actions_count int,
    last_action_at timestamptz,
    is_self       boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $func$
DECLARE
    v_uid uuid := auth.uid();
    v_lim int := GREATEST(1, LEAST(COALESCE(p_limit, 100), 200));
BEGIN
    RETURN QUERY
    SELECT
        lb.rank::int,
        lb.anon_handle,
        lb.weekly_xp,
        lb.actions_count,
        lb.last_action_at,
        (v_uid IS NOT NULL AND lb.user_id = v_uid) AS is_self
      FROM public.cas_pratique_weekly_leaderboard lb
     ORDER BY lb.rank ASC
     LIMIT v_lim;
END;
$func$;

GRANT EXECUTE ON FUNCTION public.fn_cp_get_leaderboard(int) TO authenticated;

-- ─── Fonction : position de l'utilisateur courant ─────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_my_leaderboard_position()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $func$
DECLARE
    v_uid       uuid := auth.uid();
    v_rank      int;
    v_xp        int;
    v_handle    text;
    v_actions   int;
    v_total     int;
    v_percentile numeric;
BEGIN
    IF v_uid IS NULL THEN
        RETURN jsonb_build_object('error', 'not_authenticated');
    END IF;

    SELECT count(*) INTO v_total
      FROM public.cas_pratique_weekly_leaderboard;

    SELECT rank, weekly_xp, anon_handle, actions_count
      INTO v_rank, v_xp, v_handle, v_actions
      FROM public.cas_pratique_weekly_leaderboard
     WHERE user_id = v_uid
     LIMIT 1;

    IF v_rank IS NULL THEN
        RETURN jsonb_build_object(
            'in_leaderboard', false,
            'total', v_total
        );
    END IF;

    -- Percentile : 100 = top 1%, 0 = dernier
    v_percentile := CASE WHEN v_total <= 1
        THEN 100
        ELSE round((1.0 - ((v_rank - 1)::numeric / (v_total - 1)::numeric)) * 100, 1)
    END;

    RETURN jsonb_build_object(
        'in_leaderboard', true,
        'rank', v_rank,
        'weekly_xp', v_xp,
        'actions_count', v_actions,
        'anon_handle', v_handle,
        'total', v_total,
        'percentile', v_percentile
    );
END;
$func$;

GRANT EXECUTE ON FUNCTION public.fn_cp_my_leaderboard_position() TO authenticated;

-- ─── Fonction : refresh (à appeler par pg_cron) ───────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_refresh_weekly_leaderboard()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY public.cas_pratique_weekly_leaderboard;
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_refresh_weekly_leaderboard() IS
    'CODE-059 : à appeler toutes les heures via pg_cron. CONCURRENTLY pour ne pas bloquer les lectures.';

-- Le grant est admin-only ; le cron tournera via le role postgres.
REVOKE ALL ON FUNCTION public.fn_cp_refresh_weekly_leaderboard() FROM PUBLIC, anon, authenticated;

-- ─── pg_cron setup (à exécuter manuellement après activation extension) ────
-- Décommenter une fois pg_cron activé côté dashboard Supabase :
--
-- SELECT cron.schedule(
--     'cp_refresh_weekly_leaderboard_hourly',
--     '0 * * * *',  -- toutes les heures pile
--     $$SELECT public.fn_cp_refresh_weekly_leaderboard();$$
-- );
--
-- ─── Pour un premier refresh manuel après cette migration ──────────────────
SELECT public.fn_cp_refresh_weekly_leaderboard();

COMMIT;
