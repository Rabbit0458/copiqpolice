-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 012 : système XP + niveaux          ║
-- ║  Tâche      : CODE-057                                                  ║
-- ║                                                                         ║
-- ║  - Table `cas_pratique_xp_ledger` : journal append-only des deltas XP. ║
-- ║  - Fonction `fn_cp_award_xp_for_correction(correction_id)` appelée    ║
-- ║    par trigger AFTER INSERT ON cas_pratique_corrections. Calcule :     ║
-- ║      base         = round((percent / 100) × 10 × nb_questions)         ║
-- ║      streak_bonus = min(50, streak_days × 2)                            ║
-- ║      first_try    = 25 si 1re tentative validée pour ce cas            ║
-- ║                                                                         ║
-- ║  - Fonction `fn_cp_xp_total(p_user_id)` retourne :                      ║
-- ║      { total_xp, level, level_name, xp_into_level, xp_to_next_level,   ║
-- ║        level_progress_percent }                                         ║
-- ║                                                                         ║
-- ║  Niveaux par seuils (XP min) :                                          ║
-- ║      1 : 0    → "Recrue"                                                 ║
-- ║      2 : 100  → "Apprenti"                                                ║
-- ║      3 : 250  → "Cadet"                                                  ║
-- ║      4 : 500  → "Gardien"                                                ║
-- ║      5 : 1000 → "Brigadier"                                              ║
-- ║      6 : 2000 → "Lieutenant"                                             ║
-- ║      7 : 4000 → "Capitaine"                                              ║
-- ║      8 : 8000 → "Commandant"                                             ║
-- ║      9 : 16000 → "Commissaire"                                           ║
-- ║     10 : 32000 → "Légende COP'IQ"                                        ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

-- ─── Ledger append-only ────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_xp_ledger (
    id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    delta         integer     NOT NULL,
    reason        text        NOT NULL
                                CHECK (reason IN (
                                    'correction_score',
                                    'streak_bonus',
                                    'first_try_bonus',
                                    'daily_challenge',
                                    'badge_unlock',
                                    'admin_grant',
                                    'admin_revoke'
                                )),
    correction_id uuid        REFERENCES public.cas_pratique_corrections(id) ON DELETE SET NULL,
    attempt_id    uuid        REFERENCES public.cas_pratique_attempts(id)    ON DELETE SET NULL,
    metadata      jsonb       NOT NULL DEFAULT '{}'::jsonb,
    created_at    timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_xp_ledger IS
    'CODE-057 : journal append-only des deltas XP. Pas d''UPDATE/DELETE possible côté user.';

CREATE INDEX IF NOT EXISTS idx_cp_xp_ledger_user_created
    ON public.cas_pratique_xp_ledger(user_id, created_at DESC);

ALTER TABLE public.cas_pratique_xp_ledger ENABLE ROW LEVEL SECURITY;

-- L'utilisateur peut LIRE son propre ledger (pour l'historique XP).
DROP POLICY IF EXISTS p_xp_ledger_select ON public.cas_pratique_xp_ledger;
CREATE POLICY p_xp_ledger_select
    ON public.cas_pratique_xp_ledger
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

-- Aucun INSERT/UPDATE/DELETE direct. Seules les fonctions SECURITY DEFINER y touchent.
DROP POLICY IF EXISTS p_xp_ledger_admin_write ON public.cas_pratique_xp_ledger;
CREATE POLICY p_xp_ledger_admin_write
    ON public.cas_pratique_xp_ledger
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Fonction : award XP après une correction ─────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_award_xp_for_correction(p_correction_id uuid)
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_corr        record;
    v_attempt     record;
    v_user_id     uuid;
    v_case_id     uuid;
    v_n_questions int;
    v_streak      int := 0;
    v_base        int := 0;
    v_streak_bn   int := 0;
    v_first_try   int := 0;
    v_is_first    boolean := false;
    v_total_award int := 0;
BEGIN
    -- Récupère correction + attempt
    SELECT c.attempt_id, c.percent, c.engine_version
      INTO v_corr
      FROM public.cas_pratique_corrections c
     WHERE c.id = p_correction_id
     LIMIT 1;
    IF v_corr IS NULL THEN RETURN 0; END IF;

    SELECT a.user_id, a.case_id
      INTO v_attempt
      FROM public.cas_pratique_attempts a
     WHERE a.id = v_corr.attempt_id
     LIMIT 1;
    IF v_attempt IS NULL THEN RETURN 0; END IF;
    v_user_id := v_attempt.user_id;
    v_case_id := v_attempt.case_id;

    -- 1) Base XP = round(percent/100 × 10 × nb_questions)
    SELECT count(*) INTO v_n_questions
      FROM public.cas_pratique_questions
     WHERE case_id = v_case_id;
    v_base := round((COALESCE(v_corr.percent, 0) / 100.0) * 10.0 * GREATEST(v_n_questions, 1))::int;

    -- 2) Bonus streak = min(50, streak_days × 2)
    SELECT COALESCE(streak_days, 0) INTO v_streak
      FROM public.cas_pratique_user_progress
     WHERE user_id = v_user_id;
    v_streak_bn := LEAST(50, GREATEST(0, v_streak) * 2);

    -- 3) First-try bonus : aucune autre correction n'existait pour ce case
    --    (on regarde les attempts completed antérieures avec une correction).
    SELECT NOT EXISTS (
        SELECT 1
          FROM public.cas_pratique_corrections cc
          JOIN public.cas_pratique_attempts aa ON aa.id = cc.attempt_id
         WHERE aa.user_id = v_user_id
           AND aa.case_id = v_case_id
           AND cc.id <> p_correction_id
    ) INTO v_is_first;
    IF v_is_first THEN v_first_try := 25; END IF;

    -- INSERTs au ledger (1 ligne par catégorie pour traçabilité)
    IF v_base > 0 THEN
        INSERT INTO public.cas_pratique_xp_ledger
            (user_id, delta, reason, correction_id, attempt_id, metadata)
        VALUES (v_user_id, v_base, 'correction_score',
                p_correction_id, v_corr.attempt_id,
                jsonb_build_object('percent', v_corr.percent,
                                   'n_questions', v_n_questions));
        v_total_award := v_total_award + v_base;
    END IF;
    IF v_streak_bn > 0 THEN
        INSERT INTO public.cas_pratique_xp_ledger
            (user_id, delta, reason, correction_id, attempt_id, metadata)
        VALUES (v_user_id, v_streak_bn, 'streak_bonus',
                p_correction_id, v_corr.attempt_id,
                jsonb_build_object('streak_days', v_streak));
        v_total_award := v_total_award + v_streak_bn;
    END IF;
    IF v_first_try > 0 THEN
        INSERT INTO public.cas_pratique_xp_ledger
            (user_id, delta, reason, correction_id, attempt_id, metadata)
        VALUES (v_user_id, v_first_try, 'first_try_bonus',
                p_correction_id, v_corr.attempt_id,
                jsonb_build_object('case_id', v_case_id));
        v_total_award := v_total_award + v_first_try;
    END IF;

    RETURN v_total_award;
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_award_xp_for_correction(uuid) IS
    'CODE-057 : crédite l''utilisateur en XP suite à une correction. Idempotente par insertion (pas par check) — l''appelant DOIT éviter le double-appel.';

GRANT EXECUTE ON FUNCTION public.fn_cp_award_xp_for_correction(uuid) TO authenticated;

-- ─── Trigger : auto-award sur INSERT correction ────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_trg_award_xp()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
BEGIN
    PERFORM public.fn_cp_award_xp_for_correction(NEW.id);
    RETURN NEW;
END;
$func$;

DROP TRIGGER IF EXISTS trg_cp_award_xp ON public.cas_pratique_corrections;
CREATE TRIGGER trg_cp_award_xp
    AFTER INSERT ON public.cas_pratique_corrections
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_cp_trg_award_xp();

-- ─── Fonction : total + niveau ─────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_xp_total(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $func$
DECLARE
    v_total           int := 0;
    v_level           int := 1;
    v_level_name      text := 'Recrue';
    v_current_thresh  int := 0;
    v_next_thresh     int := 100;
    v_into_level      int := 0;
    v_to_next         int := 0;
    v_progress        numeric := 0.0;
BEGIN
    IF p_user_id IS NULL THEN
        RETURN jsonb_build_object(
            'total_xp', 0, 'level', 1, 'level_name', 'Recrue',
            'xp_into_level', 0, 'xp_to_next_level', 100,
            'level_progress_percent', 0
        );
    END IF;

    SELECT COALESCE(SUM(delta), 0)::int
      INTO v_total
      FROM public.cas_pratique_xp_ledger
     WHERE user_id = p_user_id;

    -- Échelle de niveaux (paliers XP min, label)
    SELECT lvl, name, threshold, next_threshold
      INTO v_level, v_level_name, v_current_thresh, v_next_thresh
      FROM (
        VALUES
            (1,  'Recrue',          0,     100),
            (2,  'Apprenti',        100,   250),
            (3,  'Cadet',           250,   500),
            (4,  'Gardien',         500,   1000),
            (5,  'Brigadier',       1000,  2000),
            (6,  'Lieutenant',      2000,  4000),
            (7,  'Capitaine',       4000,  8000),
            (8,  'Commandant',      8000,  16000),
            (9,  'Commissaire',     16000, 32000),
            (10, 'Légende COP''IQ', 32000, 2147483647)
      ) AS levels(lvl, name, threshold, next_threshold)
     WHERE v_total >= threshold
     ORDER BY threshold DESC
     LIMIT 1;

    v_into_level := v_total - v_current_thresh;
    v_to_next    := GREATEST(0, v_next_thresh - v_total);
    IF v_next_thresh > v_current_thresh AND v_level < 10 THEN
        v_progress := ROUND(
            ((v_total - v_current_thresh)::numeric /
             (v_next_thresh - v_current_thresh)::numeric) * 100,
            2
        );
    ELSE
        v_progress := 100.0;
    END IF;

    RETURN jsonb_build_object(
        'total_xp', v_total,
        'level', v_level,
        'level_name', v_level_name,
        'xp_into_level', v_into_level,
        'xp_to_next_level', v_to_next,
        'level_progress_percent', v_progress
    );
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_xp_total(uuid) IS
    'CODE-057 : retourne le total XP + niveau dérivé pour un utilisateur.';

GRANT EXECUTE ON FUNCTION public.fn_cp_xp_total(uuid) TO authenticated;

COMMIT;
