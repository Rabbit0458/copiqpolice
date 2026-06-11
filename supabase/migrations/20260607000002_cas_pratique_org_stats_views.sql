-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Stats agrégées multi-user (rôle formateur)
--  Migration : 20260607000002
--  Tâche     : CODE-096
-- ════════════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. VUE — Progression de chaque élève par cas (accessible aux formateurs)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW public.cp_org_learner_progress AS
SELECT
    m.org_id,
    m.user_id,
    m.promo_label,
    u.email                         AS user_email,
    ucp.case_id,
    c.slug                          AS case_slug,
    c.title                         AS case_title,
    t.slug                          AS theme_slug,
    t.label                         AS theme_label,
    c.difficulty,
    c.total_points                  AS max_score,
    ucp.attempt_count,
    ucp.best_score,
    ucp.last_score,
    ROUND((ucp.best_score::numeric / NULLIF(c.total_points, 0)) * 100, 1)
                                    AS best_pct,
    ucp.last_attempt_at
FROM public.cas_pratique_org_members m
JOIN auth.users u ON u.id = m.user_id
LEFT JOIN public.cas_pratique_user_case_progress ucp ON ucp.user_id = m.user_id
LEFT JOIN public.cas_pratique_cases c ON c.id = ucp.case_id
LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
WHERE m.role = 'learner';

COMMENT ON VIEW public.cp_org_learner_progress IS
    'Progression par élève × cas. Accessible au formateur de l''organisation (voir RLS via fonction).';

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. VUE — KPIs agrégés par organisation
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE VIEW public.cp_org_kpis AS
SELECT
    m.org_id,
    COUNT(DISTINCT m.user_id)                                AS total_members,
    COUNT(DISTINCT CASE WHEN m.role = 'learner' THEN m.user_id END)  AS total_learners,
    COUNT(DISTINCT CASE WHEN m.role = 'trainer' THEN m.user_id END)  AS total_trainers,
    COUNT(DISTINCT ucp.case_id)                              AS cases_attempted,
    COUNT(DISTINCT ucp.user_id || ucp.case_id)              AS total_attempts,
    ROUND(AVG(ucp.best_score)::numeric, 2)                  AS avg_best_score,
    ROUND(AVG(
        (ucp.best_score::numeric / NULLIF(
            (SELECT total_points FROM public.cas_pratique_cases cc WHERE cc.id = ucp.case_id), 0
        )) * 100
    )::numeric, 1)                                           AS avg_best_pct,
    MAX(ucp.last_attempt_at)                                 AS last_activity_at
FROM public.cas_pratique_org_members m
LEFT JOIN public.cas_pratique_user_case_progress ucp ON ucp.user_id = m.user_id
GROUP BY m.org_id;

COMMENT ON VIEW public.cp_org_kpis IS
    'KPIs agrégés (membres, tentatives, score moyen) par organisation.';

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. RPC — Stats promo pour le formateur (accessible par n'importe quel trainer de l'org)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION cp_trainer_promo_stats(_org_id uuid, _promo_label text DEFAULT NULL)
RETURNS TABLE (
    user_id         uuid,
    user_email      text,
    promo_label     text,
    cases_done      bigint,
    avg_score_pct   numeric,
    best_score_pct  numeric,
    last_active_at  timestamptz,
    rank            bigint
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        lp.user_id,
        lp.user_email,
        lp.promo_label,
        COUNT(DISTINCT lp.case_id)                                                              AS cases_done,
        ROUND(AVG(lp.best_pct), 1)                                                             AS avg_score_pct,
        ROUND(MAX(lp.best_pct), 1)                                                             AS best_score_pct,
        MAX(lp.last_attempt_at)                                                                AS last_active_at,
        RANK() OVER (ORDER BY AVG(lp.best_pct) DESC NULLS LAST)                               AS rank
    FROM public.cp_org_learner_progress lp
    WHERE lp.org_id = _org_id
      AND (_promo_label IS NULL OR lp.promo_label = _promo_label)
      AND fn_cp_is_trainer(_org_id)  -- vérification RLS : seul un trainer de l'org peut accéder
    GROUP BY lp.user_id, lp.user_email, lp.promo_label
    ORDER BY rank;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. RPC — Thèmes faibles communs de la promo
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION cp_trainer_weak_themes(_org_id uuid, _promo_label text DEFAULT NULL)
RETURNS TABLE (
    theme_slug      text,
    theme_label     text,
    avg_pct         numeric,
    cases_count     bigint,
    learner_count   bigint
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        lp.theme_slug,
        lp.theme_label,
        ROUND(AVG(lp.best_pct), 1)     AS avg_pct,
        COUNT(DISTINCT lp.case_id)     AS cases_count,
        COUNT(DISTINCT lp.user_id)     AS learner_count
    FROM public.cp_org_learner_progress lp
    WHERE lp.org_id = _org_id
      AND (_promo_label IS NULL OR lp.promo_label = _promo_label)
      AND lp.theme_slug IS NOT NULL
      AND fn_cp_is_trainer(_org_id)
    GROUP BY lp.theme_slug, lp.theme_label
    ORDER BY avg_pct ASC NULLS LAST;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. RPC — Export CSV des notes (retourne JSON que le client transformera)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION cp_trainer_export_csv(_org_id uuid, _promo_label text DEFAULT NULL)
RETURNS TABLE (
    user_email      text,
    promo_label     text,
    case_slug       text,
    case_title      text,
    theme_label     text,
    difficulty      text,
    best_score      numeric,
    max_score       int,
    best_pct        numeric,
    attempt_count   int,
    last_attempt_at timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        lp.user_email,
        lp.promo_label,
        lp.case_slug,
        lp.case_title,
        lp.theme_label,
        lp.difficulty,
        lp.best_score,
        lp.max_score,
        lp.best_pct,
        lp.attempt_count,
        lp.last_attempt_at
    FROM public.cp_org_learner_progress lp
    WHERE lp.org_id = _org_id
      AND (_promo_label IS NULL OR lp.promo_label = _promo_label)
      AND fn_cp_is_trainer(_org_id)
    ORDER BY lp.user_email, lp.last_attempt_at DESC;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. RPC admin — liste membres d'une org avec stats
-- ─────────────────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION cp_admin_org_member_stats(_org_id uuid)
RETURNS TABLE (
    user_id         uuid,
    user_email      text,
    role            text,
    promo_label     text,
    joined_at       timestamptz,
    cases_done      bigint,
    avg_pct         numeric
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT
        m.user_id,
        u.email,
        m.role,
        m.promo_label,
        m.joined_at,
        COUNT(DISTINCT ucp.case_id)            AS cases_done,
        ROUND(AVG(
            (ucp.best_score::numeric / NULLIF(c.total_points, 0)) * 100
        ), 1)                                  AS avg_pct
    FROM public.cas_pratique_org_members m
    JOIN auth.users u ON u.id = m.user_id
    LEFT JOIN public.cas_pratique_user_case_progress ucp ON ucp.user_id = m.user_id
    LEFT JOIN public.cas_pratique_cases c ON c.id = ucp.case_id
    WHERE m.org_id = _org_id
      AND fn_cp_is_admin()
    GROUP BY m.user_id, u.email, m.role, m.promo_label, m.joined_at
    ORDER BY m.joined_at DESC;
$$;
