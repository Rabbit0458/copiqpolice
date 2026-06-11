-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 017 : algo recommandation           ║
-- ║  Tâche      : CODE-062                                                  ║
-- ║                                                                         ║
-- ║  Fonction `fn_cp_recommend_next_cases(p_user_id, p_n)` :               ║
-- ║                                                                         ║
-- ║   Stratégie en 3 niveaux :                                              ║
-- ║   ─────────────────────────                                              ║
-- ║   1. PRIORITÉ HAUTE — cas du thème le moins bien scoré par l'user :    ║
-- ║      on calcule l'avg(percent) par theme_id sur les attempts completed ║
-- ║      → on prend le thème avec le score le plus bas → on propose les   ║
-- ║      cas de ce thème JAMAIS faits par l'user en priorité.             ║
-- ║                                                                         ║
-- ║   2. PRIORITÉ MOYENNE — si le thème faible n'a plus de cas neufs :    ║
-- ║      on propose ses cas où l'user a < 50% (à rejouer).                 ║
-- ║                                                                         ║
-- ║   3. FALLBACK — si l'user n'a jamais fini de cas (newcomer) :         ║
-- ║      on propose les cas les plus récents jamais faits.                ║
-- ║                                                                         ║
-- ║  Retour : table (case_id, slug, title, theme_id, theme_slug,           ║
-- ║                  year, difficulty, reason, priority_score)              ║
-- ║                                                                         ║
-- ║  `reason` ∈ {'weakest_theme_new', 'weakest_theme_replay', 'fresh'}     ║
-- ║  pour expliciter la motivation côté UI.                                ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

CREATE OR REPLACE FUNCTION public.fn_cp_recommend_next_cases(
    p_user_id uuid DEFAULT NULL,
    p_n int DEFAULT 3
)
RETURNS TABLE (
    case_id        uuid,
    slug           text,
    title          text,
    theme_id       uuid,
    theme_slug     text,
    year           int,
    month          text,
    difficulty     text,
    estimated_minutes int,
    total_points   int,
    reason         text,
    priority_score numeric
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $func$
DECLARE
    v_uid         uuid := COALESCE(p_user_id, auth.uid());
    v_n           int := GREATEST(1, LEAST(COALESCE(p_n, 3), 10));
    v_weak_theme  uuid;
    v_weak_avg    numeric;
    v_done_count  int := 0;
BEGIN
    IF v_uid IS NULL THEN
        -- Pas d'auth : on renvoie les cas les plus récents (fresh).
        RETURN QUERY
        SELECT
            c.id,
            c.slug,
            c.title,
            c.theme_id,
            t.slug,
            c.year,
            c.month,
            c.difficulty,
            c.estimated_minutes,
            c.total_points,
            'fresh'::text     AS reason,
            (100 - row_number() OVER (ORDER BY c.published_at DESC NULLS LAST))::numeric AS priority_score
          FROM public.cas_pratique_cases c
          LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
         WHERE c.status = 'published'
         ORDER BY c.published_at DESC NULLS LAST
         LIMIT v_n;
        RETURN;
    END IF;

    -- Combien de cas l'user a-t-il finis ?
    SELECT count(*) INTO v_done_count
      FROM public.cas_pratique_attempts
     WHERE user_id = v_uid AND status = 'completed';

    -- ── FALLBACK newcomer ───────────────────────────────────────────────
    IF v_done_count = 0 THEN
        RETURN QUERY
        SELECT
            c.id,
            c.slug,
            c.title,
            c.theme_id,
            t.slug,
            c.year,
            c.month,
            c.difficulty,
            c.estimated_minutes,
            c.total_points,
            'fresh'::text AS reason,
            (100 - row_number() OVER (ORDER BY c.published_at DESC NULLS LAST))::numeric
          FROM public.cas_pratique_cases c
          LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
         WHERE c.status = 'published'
         ORDER BY c.published_at DESC NULLS LAST
         LIMIT v_n;
        RETURN;
    END IF;

    -- Identifier le thème le plus faible
    SELECT cc.theme_id, avg(a.percent)
      INTO v_weak_theme, v_weak_avg
      FROM public.cas_pratique_attempts a
      JOIN public.cas_pratique_cases cc ON cc.id = a.case_id
     WHERE a.user_id = v_uid
       AND a.status = 'completed'
       AND a.percent IS NOT NULL
     GROUP BY cc.theme_id
     ORDER BY avg(a.percent) ASC NULLS LAST
     LIMIT 1;

    IF v_weak_theme IS NULL THEN
        -- aucun score numérique : fallback fresh
        RETURN QUERY
        SELECT
            c.id, c.slug, c.title, c.theme_id, t.slug,
            c.year, c.month, c.difficulty, c.estimated_minutes, c.total_points,
            'fresh'::text,
            (100 - row_number() OVER (ORDER BY c.published_at DESC NULLS LAST))::numeric
          FROM public.cas_pratique_cases c
          LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
         WHERE c.status = 'published'
           AND NOT EXISTS (
                SELECT 1 FROM public.cas_pratique_attempts a
                 WHERE a.user_id = v_uid AND a.case_id = c.id
           )
         ORDER BY c.published_at DESC NULLS LAST
         LIMIT v_n;
        RETURN;
    END IF;

    -- ── 1. PRIORITÉ HAUTE — cas neufs du thème faible ──────────────────
    --    On les note 100 (priorité max).
    -- ── 2. PRIORITÉ MOYENNE — cas déjà faits du thème faible avec <50% ─
    --    Notation 50 + (50 - percent) → plus le score était mauvais,
    --    plus la priorité est haute (jusqu'à 100).
    -- ── 3. FALLBACK — cas neufs d'autres thèmes ────────────────────────
    --    Notation 30 - rank récent.

    RETURN QUERY
    WITH user_attempts AS (
        SELECT case_id, max(percent) AS best_percent
          FROM public.cas_pratique_attempts
         WHERE user_id = v_uid AND status = 'completed'
         GROUP BY case_id
    ),
    candidates AS (
        -- Niveau 1 : weakest theme, jamais fait
        SELECT
            c.id            AS case_id,
            c.slug,
            c.title,
            c.theme_id,
            t.slug          AS theme_slug,
            c.year,
            c.month,
            c.difficulty,
            c.estimated_minutes,
            c.total_points,
            'weakest_theme_new'::text AS reason,
            100.0::numeric  AS priority_score,
            c.published_at
          FROM public.cas_pratique_cases c
          LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
         WHERE c.status = 'published'
           AND c.theme_id = v_weak_theme
           AND NOT EXISTS (
                SELECT 1 FROM user_attempts ua WHERE ua.case_id = c.id
           )

        UNION ALL

        -- Niveau 2 : weakest theme, déjà fait avec <50%
        SELECT
            c.id, c.slug, c.title, c.theme_id, t.slug,
            c.year, c.month, c.difficulty, c.estimated_minutes, c.total_points,
            'weakest_theme_replay'::text,
            (50.0 + (50.0 - COALESCE(ua.best_percent, 0)))::numeric AS priority_score,
            c.published_at
          FROM public.cas_pratique_cases c
          LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
          JOIN user_attempts ua ON ua.case_id = c.id
         WHERE c.status = 'published'
           AND c.theme_id = v_weak_theme
           AND COALESCE(ua.best_percent, 0) < 50

        UNION ALL

        -- Niveau 3 : autres thèmes, jamais fait
        SELECT
            c.id, c.slug, c.title, c.theme_id, t.slug,
            c.year, c.month, c.difficulty, c.estimated_minutes, c.total_points,
            'fresh'::text,
            30.0::numeric AS priority_score,
            c.published_at
          FROM public.cas_pratique_cases c
          LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
         WHERE c.status = 'published'
           AND (c.theme_id IS NULL OR c.theme_id <> v_weak_theme)
           AND NOT EXISTS (
                SELECT 1 FROM user_attempts ua WHERE ua.case_id = c.id
           )
    )
    SELECT
        candidates.case_id,
        candidates.slug,
        candidates.title,
        candidates.theme_id,
        candidates.theme_slug,
        candidates.year,
        candidates.month,
        candidates.difficulty,
        candidates.estimated_minutes,
        candidates.total_points,
        candidates.reason,
        candidates.priority_score
      FROM candidates
     ORDER BY candidates.priority_score DESC, candidates.published_at DESC NULLS LAST
     LIMIT v_n;
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_recommend_next_cases(uuid, int) IS
    'CODE-062 : recommande N cas à l''user. Stratégie 3 niveaux (weakest_theme_new > weakest_theme_replay > fresh). Stable, lit auth.uid() si p_user_id NULL.';

GRANT EXECUTE ON FUNCTION public.fn_cp_recommend_next_cases(uuid, int) TO authenticated;

COMMIT;
