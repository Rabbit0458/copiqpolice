-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 013 : badges & succès               ║
-- ║  Tâche      : CODE-057                                                  ║
-- ║                                                                         ║
-- ║  - Table `cas_pratique_badges` : catalog des badges (slug, label,      ║
-- ║    description, icon, color_hex, kind, sort_order). Seedé en bas du    ║
-- ║    fichier avec 20 badges initiaux.                                     ║
-- ║                                                                         ║
-- ║  - Table `cas_pratique_user_badges` : unlocks (user_id + badge_slug    ║
-- ║    PK + unlocked_at). Append-only via la fonction d'unlock.            ║
-- ║                                                                         ║
-- ║  - Fonction `fn_cp_check_and_unlock_badges(p_user_id)` qui scanne     ║
-- ║    chaque condition et fait un INSERT...ON CONFLICT DO NOTHING. Retour ║
-- ║    : liste des slugs **nouvellement** débloqués (utile pour l'UI       ║
-- ║    toast).                                                              ║
-- ║                                                                         ║
-- ║  - Trigger AFTER INSERT ON cas_pratique_corrections qui appelle la     ║
-- ║    fonction (les conditions liées au score se vérifient à ce moment).  ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

-- ─── Catalog ────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_badges (
    slug         text        PRIMARY KEY,
    label        text        NOT NULL,
    description  text        NOT NULL,
    icon         text        NOT NULL DEFAULT 'emoji_events_rounded',
    color_hex    text        NOT NULL DEFAULT '#1147D9',
    kind         text        NOT NULL
                                CHECK (kind IN (
                                    'progress', 'score', 'streak',
                                    'breadth',  'quality', 'xp', 'meta'
                                )),
    sort_order   int         NOT NULL DEFAULT 100,
    created_at   timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_badges IS
    'CODE-057 : catalog des badges (lecture publique, écriture admin only).';

-- Public read (la liste des badges est publique).
ALTER TABLE public.cas_pratique_badges ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_badges_public_read ON public.cas_pratique_badges;
CREATE POLICY p_badges_public_read
    ON public.cas_pratique_badges
    FOR SELECT TO authenticated, anon
    USING (true);

DROP POLICY IF EXISTS p_badges_admin_write ON public.cas_pratique_badges;
CREATE POLICY p_badges_admin_write
    ON public.cas_pratique_badges
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Unlocks par user ──────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_user_badges (
    user_id     uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    badge_slug  text        NOT NULL REFERENCES public.cas_pratique_badges(slug) ON DELETE CASCADE,
    unlocked_at timestamptz NOT NULL DEFAULT now(),
    metadata    jsonb       NOT NULL DEFAULT '{}'::jsonb,
    PRIMARY KEY (user_id, badge_slug)
);

COMMENT ON TABLE public.cas_pratique_user_badges IS
    'CODE-057 : badges débloqués par user. Append-only via fn_cp_check_and_unlock_badges.';

CREATE INDEX IF NOT EXISTS idx_cp_user_badges_unlocked
    ON public.cas_pratique_user_badges(user_id, unlocked_at DESC);

ALTER TABLE public.cas_pratique_user_badges ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_user_badges_select ON public.cas_pratique_user_badges;
CREATE POLICY p_user_badges_select
    ON public.cas_pratique_user_badges
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

DROP POLICY IF EXISTS p_user_badges_admin_write ON public.cas_pratique_user_badges;
CREATE POLICY p_user_badges_admin_write
    ON public.cas_pratique_user_badges
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Seed des 20 badges ────────────────────────────────────────────────────

INSERT INTO public.cas_pratique_badges (slug, label, description, icon, color_hex, kind, sort_order) VALUES
    -- progress
    ('first_attempt',    'Premier pas',          'Tu as démarré ton premier cas pratique.',                  'flag_rounded',           '#1147D9', 'progress',   10),
    ('first_completed',  'Premier validé',       'Tu as terminé et validé ton premier cas pratique.',         'check_circle_rounded',   '#22C55E', 'progress',   20),
    ('cases_5',          'Cinq sur cinq',        'Tu as validé 5 cas pratiques.',                              'looks_5_rounded',        '#22C55E', 'progress',   30),
    ('cases_10',         'Dixième de fond',      'Tu as validé 10 cas pratiques.',                             'looks_one_rounded',      '#22C55E', 'progress',   40),
    ('cases_25',         'Vingt-cinq battements','Tu as validé 25 cas pratiques.',                             'workspace_premium_rounded','#F59E0B','progress',   50),
    ('cases_50',         'Demi-centenaire',      'Tu as validé 50 cas pratiques.',                             'military_tech_rounded',  '#F59E0B', 'progress',   60),
    ('cases_100',        'Centurion',            'Tu as validé 100 cas pratiques.',                            'emoji_events_rounded',   '#EF4444', 'progress',   70),
    -- score
    ('perfect_first',    'Coup d''éclat',        'Tu as obtenu 100% sur un cas pratique.',                     'star_rounded',           '#F59E0B', 'score',     110),
    ('perfect_3',        'Triple perfection',    'Tu as obtenu 100% sur 3 cas pratiques.',                     'star_purple500_rounded', '#A855F7', 'score',     120),
    ('perfect_10',       'Maestro',              'Tu as obtenu 100% sur 10 cas pratiques.',                    'auto_awesome_rounded',   '#A855F7', 'score',     130),
    -- streak
    ('streak_3',         'Trois en ligne',       '3 jours consécutifs d''entraînement.',                       'whatshot_rounded',       '#F59E0B', 'streak',    210),
    ('streak_7',         'Une semaine',          '7 jours consécutifs sans rater une journée.',                'local_fire_department_rounded', '#EF4444', 'streak', 220),
    ('streak_30',        'Marathonien',          '30 jours d''affilée. Régularité légendaire.',                'local_fire_department_rounded', '#EF4444', 'streak', 230),
    ('streak_100',       'Centurion régulier',   '100 jours consécutifs. Pour les machines.',                   'bolt_rounded',           '#EF4444', 'streak',    240),
    -- breadth
    ('themes_3',         'Polyvalent',           'Tu as travaillé au moins 3 thèmes différents.',              'category_rounded',       '#0EA5E9', 'breadth',   310),
    ('themes_all',       'Touche-à-tout',        'Tu as travaillé tous les thèmes disponibles.',               'palette_rounded',        '#0EA5E9', 'breadth',   320),
    -- quality
    ('score_avg_70',     'Réussite confirmée',   'Moyenne globale ≥ 70%.',                                     'trending_up_rounded',    '#22C55E', 'quality',   410),
    ('score_avg_85',     'Excellence',           'Moyenne globale ≥ 85%. Tu vises le sommet.',                  'verified_rounded',       '#22C55E', 'quality',   420),
    -- xp
    ('xp_1000',          'Mille points',         'Tu as franchi le cap des 1 000 XP.',
    'leaderboard_rounded','#1147D9', 'xp',        510),
    ('xp_5000',          'Cinq mille points',    'Tu as franchi le cap des 5 000 XP.',                          'workspace_premium_rounded','#A855F7','xp',        520)
ON CONFLICT (slug) DO UPDATE
    SET label       = EXCLUDED.label,
        description = EXCLUDED.description,
        icon        = EXCLUDED.icon,
        color_hex   = EXCLUDED.color_hex,
        kind        = EXCLUDED.kind,
        sort_order  = EXCLUDED.sort_order;

-- ─── Fonction d'unlock ─────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_check_and_unlock_badges(p_user_id uuid)
RETURNS text[]
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_newly         text[] := ARRAY[]::text[];
    v_completed     int := 0;
    v_perfect       int := 0;
    v_streak        int := 0;
    v_themes        int := 0;
    v_themes_total  int := 0;
    v_avg           numeric := 0;
    v_total_xp      int := 0;
    v_has_attempts  boolean := false;
BEGIN
    IF p_user_id IS NULL THEN RETURN v_newly; END IF;

    -- Récupère les stats nécessaires
    SELECT EXISTS (
        SELECT 1 FROM public.cas_pratique_attempts WHERE user_id = p_user_id
    ) INTO v_has_attempts;

    SELECT count(*)
      INTO v_completed
      FROM public.cas_pratique_attempts
     WHERE user_id = p_user_id AND status = 'completed';

    SELECT count(*)
      INTO v_perfect
      FROM public.cas_pratique_attempts
     WHERE user_id = p_user_id
       AND status = 'completed'
       AND percent IS NOT NULL
       AND percent >= 100.0;

    SELECT COALESCE(streak_days, 0) INTO v_streak
      FROM public.cas_pratique_user_progress WHERE user_id = p_user_id;

    SELECT count(DISTINCT cc.theme_id)
      INTO v_themes
      FROM public.cas_pratique_attempts a
      JOIN public.cas_pratique_cases cc ON cc.id = a.case_id
     WHERE a.user_id = p_user_id AND a.status = 'completed';

    SELECT count(*) INTO v_themes_total FROM public.cas_pratique_themes;

    SELECT COALESCE(avg(percent), 0)
      INTO v_avg
      FROM public.cas_pratique_attempts
     WHERE user_id = p_user_id AND status = 'completed' AND percent IS NOT NULL;

    SELECT COALESCE(SUM(delta), 0)::int
      INTO v_total_xp
      FROM public.cas_pratique_xp_ledger WHERE user_id = p_user_id;

    -- Helper inline : tente l'unlock et accumule le slug si nouveau
    --   (la clé primaire (user_id, badge_slug) garantit l'idempotence)
    PERFORM 1;
    -- progress
    IF v_has_attempts THEN
        INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug)
        VALUES (p_user_id, 'first_attempt')
        ON CONFLICT DO NOTHING;
    END IF;
    IF v_completed >= 1   THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'first_completed') ON CONFLICT DO NOTHING; END IF;
    IF v_completed >= 5   THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'cases_5')          ON CONFLICT DO NOTHING; END IF;
    IF v_completed >= 10  THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'cases_10')         ON CONFLICT DO NOTHING; END IF;
    IF v_completed >= 25  THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'cases_25')         ON CONFLICT DO NOTHING; END IF;
    IF v_completed >= 50  THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'cases_50')         ON CONFLICT DO NOTHING; END IF;
    IF v_completed >= 100 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'cases_100')        ON CONFLICT DO NOTHING; END IF;
    -- score
    IF v_perfect >= 1  THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'perfect_first') ON CONFLICT DO NOTHING; END IF;
    IF v_perfect >= 3  THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'perfect_3')     ON CONFLICT DO NOTHING; END IF;
    IF v_perfect >= 10 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'perfect_10')    ON CONFLICT DO NOTHING; END IF;
    -- streak
    IF v_streak >= 3   THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'streak_3')      ON CONFLICT DO NOTHING; END IF;
    IF v_streak >= 7   THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'streak_7')      ON CONFLICT DO NOTHING; END IF;
    IF v_streak >= 30  THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'streak_30')     ON CONFLICT DO NOTHING; END IF;
    IF v_streak >= 100 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'streak_100')    ON CONFLICT DO NOTHING; END IF;
    -- breadth
    IF v_themes >= 3 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'themes_3')  ON CONFLICT DO NOTHING; END IF;
    IF v_themes_total > 0 AND v_themes >= v_themes_total
        THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'themes_all') ON CONFLICT DO NOTHING; END IF;
    -- quality (au moins 3 cas pour éviter le badge sur 1 cas chanceux)
    IF v_completed >= 3 AND v_avg >= 70 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'score_avg_70') ON CONFLICT DO NOTHING; END IF;
    IF v_completed >= 5 AND v_avg >= 85 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'score_avg_85') ON CONFLICT DO NOTHING; END IF;
    -- xp
    IF v_total_xp >= 1000 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'xp_1000') ON CONFLICT DO NOTHING; END IF;
    IF v_total_xp >= 5000 THEN INSERT INTO public.cas_pratique_user_badges (user_id, badge_slug) VALUES (p_user_id, 'xp_5000') ON CONFLICT DO NOTHING; END IF;

    -- Retourne les slugs débloqués DANS LES 5 dernières secondes pour cet user.
    -- Ce filtre temporel = "nouveaux depuis l'appel" (au lieu de tracker un set diff)
    SELECT COALESCE(array_agg(badge_slug ORDER BY unlocked_at DESC), ARRAY[]::text[])
      INTO v_newly
      FROM public.cas_pratique_user_badges
     WHERE user_id = p_user_id
       AND unlocked_at >= now() - INTERVAL '5 seconds';

    RETURN v_newly;
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_check_and_unlock_badges(uuid) IS
    'CODE-057 : scanne toutes les conditions et débloque les badges éligibles. Retourne les slugs débloqués dans les 5 dernières secondes.';

GRANT EXECUTE ON FUNCTION public.fn_cp_check_and_unlock_badges(uuid) TO authenticated;

-- ─── Trigger : check après chaque correction ───────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_trg_check_badges()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_user_id uuid;
BEGIN
    SELECT user_id INTO v_user_id
      FROM public.cas_pratique_attempts
     WHERE id = NEW.attempt_id LIMIT 1;
    IF v_user_id IS NOT NULL THEN
        PERFORM public.fn_cp_check_and_unlock_badges(v_user_id);
    END IF;
    RETURN NEW;
END;
$func$;

DROP TRIGGER IF EXISTS trg_cp_check_badges ON public.cas_pratique_corrections;
CREATE TRIGGER trg_cp_check_badges
    AFTER INSERT ON public.cas_pratique_corrections
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_cp_trg_check_badges();

COMMIT;
