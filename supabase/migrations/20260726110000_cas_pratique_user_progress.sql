-- ─────────────────────────────────────────────────────────────────────────
-- Table manquante référencée par les migrations 20260508000007 (triggers),
-- 20260518000002 (streaks), 20260518000003 (xp) et 20260518000004 (badges),
-- mais jamais créée en base. Sans elle, ces 3 fonctionnalités ne peuvent pas
-- être activées : leurs triggers échoueraient à la première correction
-- soumise par un élève.
--
-- Le corps du trigger est protégé par un bloc EXCEPTION : une anomalie dans
-- le calcul des stats agrégées ne doit jamais faire échouer l'INSERT sur
-- cas_pratique_corrections (le chemin le plus critique de l'app).
-- ─────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_user_progress (
    user_id              uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    cases_started        int NOT NULL DEFAULT 0,
    cases_finished       int NOT NULL DEFAULT 0,
    total_attempts       int NOT NULL DEFAULT 0,
    avg_score_percent    numeric(5,2),
    best_score_percent   numeric(5,2),
    last_attempt_at      timestamptz,
    streak_days          int NOT NULL DEFAULT 0,
    updated_at           timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_user_progress IS
    'Stats agrégées par user (cases, score, streak). Écriture exclusivement via fonctions SECURITY DEFINER.';

ALTER TABLE public.cas_pratique_user_progress ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_user_progress_select_own ON public.cas_pratique_user_progress;
CREATE POLICY p_user_progress_select_own
    ON public.cas_pratique_user_progress
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

-- ─── updated_at automatique sur cette table uniquement ─────────────────────
CREATE OR REPLACE FUNCTION public.fn_cp_set_updated_at() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_cp_progress_updated_at ON public.cas_pratique_user_progress;
CREATE TRIGGER trg_cp_progress_updated_at
    BEFORE UPDATE ON public.cas_pratique_user_progress
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_set_updated_at();

-- ─── Recalcul après chaque correction (exception-safe) ──────────────────────
CREATE OR REPLACE FUNCTION public.fn_cp_update_user_progress() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
    v_user_id  uuid;
    v_avg      numeric(5,2);
    v_best     numeric(5,2);
    v_started  int;
    v_finished int;
    v_total    int;
    v_last     timestamptz;
BEGIN
    BEGIN
        SELECT a.user_id INTO v_user_id
        FROM public.cas_pratique_attempts a
        WHERE a.id = NEW.attempt_id;

        IF v_user_id IS NULL THEN
            RETURN NEW;
        END IF;

        SELECT
            COUNT(DISTINCT case_id) FILTER (WHERE status IN ('in_progress','completed')),
            COUNT(DISTINCT case_id) FILTER (WHERE status = 'completed'),
            COUNT(*),
            MAX(finished_at)
        INTO v_started, v_finished, v_total, v_last
        FROM public.cas_pratique_attempts
        WHERE user_id = v_user_id;

        SELECT AVG(c.percent), MAX(c.percent)
        INTO v_avg, v_best
        FROM public.cas_pratique_corrections c
        JOIN public.cas_pratique_attempts a ON a.id = c.attempt_id
        WHERE a.user_id = v_user_id;

        INSERT INTO public.cas_pratique_user_progress
            (user_id, cases_started, cases_finished, total_attempts,
             avg_score_percent, best_score_percent, last_attempt_at, updated_at)
        VALUES
            (v_user_id, v_started, v_finished, v_total, v_avg, v_best, v_last, now())
        ON CONFLICT (user_id) DO UPDATE SET
            cases_started      = EXCLUDED.cases_started,
            cases_finished     = EXCLUDED.cases_finished,
            total_attempts     = EXCLUDED.total_attempts,
            avg_score_percent  = EXCLUDED.avg_score_percent,
            best_score_percent = EXCLUDED.best_score_percent,
            last_attempt_at    = EXCLUDED.last_attempt_at,
            updated_at         = now();
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'fn_cp_update_user_progress failed for correction %: %', NEW.id, SQLERRM;
    END;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_cp_update_progress_after_correction ON public.cas_pratique_corrections;
CREATE TRIGGER trg_cp_update_progress_after_correction
    AFTER INSERT OR UPDATE ON public.cas_pratique_corrections
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_update_user_progress();
