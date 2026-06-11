-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 016 : concours blanc (mock exams)   ║
-- ║  Tâche      : CODE-061                                                  ║
-- ║                                                                         ║
-- ║  Mode "épreuve réelle" : durée imposée, verrouillage strict, scoring   ║
-- ║  stocké à part des attempts normaux pour ne pas polluer les stats     ║
-- ║  d'entraînement.                                                        ║
-- ║                                                                         ║
-- ║  Tables :                                                                ║
-- ║   - cas_pratique_mock_exams         : catalog (45 min par défaut)       ║
-- ║   - cas_pratique_mock_exam_cases    : N cas par mock (position)         ║
-- ║   - cas_pratique_mock_exam_attempts : 1 tentative user                  ║
-- ║   - cas_pratique_mock_exam_answers  : réponses (1 par question)         ║
-- ║                                                                         ║
-- ║  Fonctions :                                                             ║
-- ║   - fn_cp_start_mock_exam(p_mock_exam_id)       → crée l'attempt        ║
-- ║   - fn_cp_finish_mock_exam(p_mock_attempt_id)   → finalise + score      ║
-- ║   - fn_cp_mock_exam_leaderboard(p_mock_exam_id) → classement anonymisé ║
-- ║   - fn_cp_my_mock_exam_position(p_mock_exam_id)                         ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

-- ─── Catalog ────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_mock_exams (
    id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            text        NOT NULL UNIQUE,
    title           text        NOT NULL,
    description     text,
    total_minutes   int         NOT NULL DEFAULT 45 CHECK (total_minutes > 0 AND total_minutes <= 240),
    total_points    int         NOT NULL DEFAULT 20,
    status          text        NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
    published_at    timestamptz,
    created_at      timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.cas_pratique_mock_exams ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_mocks_public_read ON public.cas_pratique_mock_exams;
CREATE POLICY p_mocks_public_read
    ON public.cas_pratique_mock_exams
    FOR SELECT TO authenticated
    USING (status = 'published');

DROP POLICY IF EXISTS p_mocks_admin_write ON public.cas_pratique_mock_exams;
CREATE POLICY p_mocks_admin_write
    ON public.cas_pratique_mock_exams
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Cas associés au mock (M:N avec position) ──────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_mock_exam_cases (
    mock_exam_id uuid    NOT NULL REFERENCES public.cas_pratique_mock_exams(id) ON DELETE CASCADE,
    case_id      uuid    NOT NULL REFERENCES public.cas_pratique_cases(id)      ON DELETE CASCADE,
    position     int     NOT NULL DEFAULT 0,
    PRIMARY KEY (mock_exam_id, case_id)
);

CREATE INDEX IF NOT EXISTS idx_cp_mock_exam_cases_position
    ON public.cas_pratique_mock_exam_cases(mock_exam_id, position);

ALTER TABLE public.cas_pratique_mock_exam_cases ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_mock_cases_read ON public.cas_pratique_mock_exam_cases;
CREATE POLICY p_mock_cases_read
    ON public.cas_pratique_mock_exam_cases
    FOR SELECT TO authenticated
    USING (EXISTS (
        SELECT 1 FROM public.cas_pratique_mock_exams m
         WHERE m.id = mock_exam_id AND m.status = 'published'
    ));

DROP POLICY IF EXISTS p_mock_cases_admin_write ON public.cas_pratique_mock_exam_cases;
CREATE POLICY p_mock_cases_admin_write
    ON public.cas_pratique_mock_exam_cases
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Tentatives user ───────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_mock_exam_attempts (
    id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    mock_exam_id   uuid        NOT NULL REFERENCES public.cas_pratique_mock_exams(id) ON DELETE CASCADE,
    started_at     timestamptz NOT NULL DEFAULT now(),
    finished_at    timestamptz,
    deadline_at    timestamptz NOT NULL,
    status         text        NOT NULL DEFAULT 'in_progress'
                                  CHECK (status IN ('in_progress','submitted','expired','cancelled')),
    total_score    numeric,
    total_max      numeric,
    percent        numeric,
    time_spent_ms  bigint
);

CREATE INDEX IF NOT EXISTS idx_cp_mock_attempts_user
    ON public.cas_pratique_mock_exam_attempts(user_id, started_at DESC);

CREATE INDEX IF NOT EXISTS idx_cp_mock_attempts_exam_score
    ON public.cas_pratique_mock_exam_attempts(mock_exam_id, percent DESC)
    WHERE status = 'submitted';

ALTER TABLE public.cas_pratique_mock_exam_attempts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_mock_attempts_select_self ON public.cas_pratique_mock_exam_attempts;
CREATE POLICY p_mock_attempts_select_self
    ON public.cas_pratique_mock_exam_attempts
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

DROP POLICY IF EXISTS p_mock_attempts_admin_write ON public.cas_pratique_mock_exam_attempts;
CREATE POLICY p_mock_attempts_admin_write
    ON public.cas_pratique_mock_exam_attempts
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Réponses user ─────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_mock_exam_answers (
    id                  uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    mock_attempt_id     uuid        NOT NULL REFERENCES public.cas_pratique_mock_exam_attempts(id) ON DELETE CASCADE,
    question_id         uuid        NOT NULL REFERENCES public.cas_pratique_questions(id) ON DELETE CASCADE,
    text                text        NOT NULL DEFAULT '',
    char_count          int         NOT NULL DEFAULT 0,
    updated_at          timestamptz NOT NULL DEFAULT now(),
    UNIQUE (mock_attempt_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_cp_mock_answers_attempt
    ON public.cas_pratique_mock_exam_answers(mock_attempt_id);

ALTER TABLE public.cas_pratique_mock_exam_answers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_mock_answers_select_self ON public.cas_pratique_mock_exam_answers;
CREATE POLICY p_mock_answers_select_self
    ON public.cas_pratique_mock_exam_answers
    FOR SELECT TO authenticated
    USING (EXISTS (
        SELECT 1 FROM public.cas_pratique_mock_exam_attempts a
         WHERE a.id = mock_attempt_id AND a.user_id = auth.uid()
    ));

-- L'user peut INSERT/UPDATE ses propres réponses, mais SEULEMENT tant que
-- l'attempt est in_progress et que la deadline n'est pas dépassée.
DROP POLICY IF EXISTS p_mock_answers_write_self ON public.cas_pratique_mock_exam_answers;
CREATE POLICY p_mock_answers_write_self
    ON public.cas_pratique_mock_exam_answers
    FOR ALL TO authenticated
    USING (EXISTS (
        SELECT 1 FROM public.cas_pratique_mock_exam_attempts a
         WHERE a.id = mock_attempt_id
           AND a.user_id = auth.uid()
           AND a.status = 'in_progress'
           AND a.deadline_at > now()
    ))
    WITH CHECK (EXISTS (
        SELECT 1 FROM public.cas_pratique_mock_exam_attempts a
         WHERE a.id = mock_attempt_id
           AND a.user_id = auth.uid()
           AND a.status = 'in_progress'
           AND a.deadline_at > now()
    ));

-- ─── Fonction : démarrer un mock ───────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_start_mock_exam(p_mock_exam_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_uid       uuid := auth.uid();
    v_minutes   int;
    v_now       timestamptz := now();
    v_existing  uuid;
    v_id        uuid;
    v_deadline  timestamptz;
BEGIN
    IF v_uid IS NULL THEN
        RETURN jsonb_build_object('ok', false, 'error', 'not_authenticated');
    END IF;

    SELECT total_minutes INTO v_minutes
      FROM public.cas_pratique_mock_exams
     WHERE id = p_mock_exam_id AND status = 'published';
    IF v_minutes IS NULL THEN
        RETURN jsonb_build_object('ok', false, 'error', 'mock_not_found');
    END IF;

    -- Une seule tentative in_progress active à la fois
    SELECT id INTO v_existing
      FROM public.cas_pratique_mock_exam_attempts
     WHERE user_id = v_uid AND mock_exam_id = p_mock_exam_id
       AND status = 'in_progress' AND deadline_at > v_now
     LIMIT 1;
    IF v_existing IS NOT NULL THEN
        SELECT deadline_at INTO v_deadline
          FROM public.cas_pratique_mock_exam_attempts WHERE id = v_existing;
        RETURN jsonb_build_object(
            'ok', true, 'attempt_id', v_existing,
            'deadline_at', v_deadline, 'resumed', true
        );
    END IF;

    v_deadline := v_now + (v_minutes || ' minutes')::interval;
    INSERT INTO public.cas_pratique_mock_exam_attempts
        (user_id, mock_exam_id, started_at, deadline_at, status)
    VALUES (v_uid, p_mock_exam_id, v_now, v_deadline, 'in_progress')
    RETURNING id INTO v_id;

    RETURN jsonb_build_object(
        'ok', true, 'attempt_id', v_id,
        'deadline_at', v_deadline, 'resumed', false
    );
END;
$func$;

GRANT EXECUTE ON FUNCTION public.fn_cp_start_mock_exam(uuid) TO authenticated;

-- ─── Fonction : soumettre un mock ──────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_finish_mock_exam(p_mock_attempt_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_uid       uuid := auth.uid();
    v_attempt   record;
    v_now       timestamptz := now();
    v_status    text;
BEGIN
    IF v_uid IS NULL THEN
        RETURN jsonb_build_object('ok', false, 'error', 'not_authenticated');
    END IF;

    SELECT * INTO v_attempt
      FROM public.cas_pratique_mock_exam_attempts
     WHERE id = p_mock_attempt_id;
    IF v_attempt IS NULL THEN
        RETURN jsonb_build_object('ok', false, 'error', 'attempt_not_found');
    END IF;
    IF v_attempt.user_id <> v_uid THEN
        RETURN jsonb_build_object('ok', false, 'error', 'not_owner');
    END IF;
    IF v_attempt.status <> 'in_progress' THEN
        RETURN jsonb_build_object('ok', false, 'error', 'already_finalized');
    END IF;

    -- Si la deadline est passée → expired ; sinon → submitted
    v_status := CASE WHEN v_now > v_attempt.deadline_at THEN 'expired' ELSE 'submitted' END;

    -- ⚠ Le scoring réel sera fait par l'edge function `cas_pratique_correct_mock_attempt`
    -- (futur CODE — port du moteur sur les mocks). Ici on se contente de fermer
    -- l'attempt et de calculer un time_spent indicatif.
    UPDATE public.cas_pratique_mock_exam_attempts
       SET status = v_status,
           finished_at = v_now,
           time_spent_ms = EXTRACT(EPOCH FROM (v_now - started_at))::bigint * 1000
     WHERE id = p_mock_attempt_id;

    RETURN jsonb_build_object(
        'ok', true,
        'status', v_status,
        'finished_at', v_now
    );
END;
$func$;

GRANT EXECUTE ON FUNCTION public.fn_cp_finish_mock_exam(uuid) TO authenticated;

-- ─── Fonctions : classement par mock ───────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_mock_exam_leaderboard(p_mock_exam_id uuid, p_limit int DEFAULT 100)
RETURNS TABLE (
    rank          int,
    anon_handle   text,
    percent       numeric,
    total_score   numeric,
    time_spent_ms bigint,
    submitted_at  timestamptz,
    is_self       boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $func$
DECLARE
    v_uid uuid := auth.uid();
BEGIN
    RETURN QUERY
    SELECT
        DENSE_RANK() OVER (ORDER BY a.percent DESC NULLS LAST, a.time_spent_ms ASC NULLS LAST)::int AS rank,
        'Apprenti #' || upper(substr(md5(a.user_id::text), -4)) AS anon_handle,
        a.percent,
        a.total_score,
        a.time_spent_ms,
        a.finished_at AS submitted_at,
        (v_uid IS NOT NULL AND a.user_id = v_uid) AS is_self
      FROM public.cas_pratique_mock_exam_attempts a
     WHERE a.mock_exam_id = p_mock_exam_id
       AND a.status = 'submitted'
       AND a.percent IS NOT NULL
     ORDER BY a.percent DESC NULLS LAST, a.time_spent_ms ASC NULLS LAST
     LIMIT GREATEST(1, LEAST(COALESCE(p_limit, 100), 200));
END;
$func$;

GRANT EXECUTE ON FUNCTION public.fn_cp_mock_exam_leaderboard(uuid, int) TO authenticated;

COMMIT;
