-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 007 : Triggers
--  Référence : docs/cas_pratique/03_SCHEMA.sql (section 4, T018)
--  Tâche      : CODE-007
-- ════════════════════════════════════════════════════════════════════════════

-- ─── Fonction générique : updated_at = now() ─────────────────────────────────
CREATE OR REPLACE FUNCTION public.fn_cp_set_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ─── Triggers updated_at ─────────────────────────────────────────────────────
DROP TRIGGER IF EXISTS trg_cp_cases_updated_at ON public.cas_pratique_cases;
CREATE TRIGGER trg_cp_cases_updated_at
    BEFORE UPDATE ON public.cas_pratique_cases
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_set_updated_at();

DROP TRIGGER IF EXISTS trg_cp_perfect_answers_updated_at ON public.cas_pratique_perfect_answers;
CREATE TRIGGER trg_cp_perfect_answers_updated_at
    BEFORE UPDATE ON public.cas_pratique_perfect_answers
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_set_updated_at();

DROP TRIGGER IF EXISTS trg_cp_synonyms_updated_at ON public.cas_pratique_synonyms_dictionary;
CREATE TRIGGER trg_cp_synonyms_updated_at
    BEFORE UPDATE ON public.cas_pratique_synonyms_dictionary
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_set_updated_at();

DROP TRIGGER IF EXISTS trg_cp_progress_updated_at ON public.cas_pratique_user_progress;
CREATE TRIGGER trg_cp_progress_updated_at
    BEFORE UPDATE ON public.cas_pratique_user_progress
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_set_updated_at();

DROP TRIGGER IF EXISTS trg_cp_answers_updated_at ON public.cas_pratique_answers;
CREATE TRIGGER trg_cp_answers_updated_at
    BEFORE UPDATE ON public.cas_pratique_answers
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_set_updated_at();

-- ─── T018 — Trigger : recalc user_progress après correction ─────────────────
CREATE OR REPLACE FUNCTION public.fn_cp_update_user_progress() RETURNS trigger AS $$
DECLARE
    v_user_id  uuid;
    v_avg      numeric(5,2);
    v_best     numeric(5,2);
    v_started  int;
    v_finished int;
    v_total    int;
    v_last     timestamptz;
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

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_cp_update_progress_after_correction
    ON public.cas_pratique_corrections;
CREATE TRIGGER trg_cp_update_progress_after_correction
    AFTER INSERT OR UPDATE ON public.cas_pratique_corrections
    FOR EACH ROW EXECUTE FUNCTION public.fn_cp_update_user_progress();
