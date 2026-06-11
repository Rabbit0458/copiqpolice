-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 004 : Attempts, Answers, Corrections
--  Tables : attempts, answers (upgrade), corrections, correction_details (T009-T012)
--  Référence : docs/cas_pratique/03_SCHEMA.sql (section 2, T009-T012)
--  Tâche      : CODE-004
-- ════════════════════════════════════════════════════════════════════════════

-- ─── T009 — ATTEMPTS ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_attempts (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    case_id         uuid NOT NULL REFERENCES public.cas_pratique_cases(id) ON DELETE CASCADE,
    started_at      timestamptz NOT NULL DEFAULT now(),
    finished_at     timestamptz,
    status          text NOT NULL DEFAULT 'in_progress'
                      CHECK (status IN ('in_progress','completed','abandoned')),
    total_score     numeric(5,2),
    total_max       numeric(5,2),
    percent         numeric(5,2),
    time_spent_ms   bigint,
    device_info     jsonb
);

COMMENT ON TABLE public.cas_pratique_attempts IS
    'Une tentative complète d''un cas par un user. Nouvelle attempt à chaque démarrage de cas.';

-- ─── T010 — ANSWERS (migration idempotente) ─────────────────────────────────
-- Si la table existe déjà (legacy avec case_id text + question_index int),
-- on ajoute les colonnes manquantes sans casser l'existant.
CREATE TABLE IF NOT EXISTS public.cas_pratique_answers (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    case_id         text NOT NULL,                  -- legacy
    attempt_id      uuid REFERENCES public.cas_pratique_attempts(id) ON DELETE CASCADE,
    question_id     uuid REFERENCES public.cas_pratique_questions(id) ON DELETE SET NULL,
    question_index  int  NOT NULL,                  -- legacy 0..N
    answer          text NOT NULL,
    normalized_text text,
    char_count      int,
    status          text NOT NULL DEFAULT 'validated'
                      CHECK (status IN ('draft','validated')),
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now()
);

-- Ajout idempotent des colonnes pour les bases qui contenaient déjà la table
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='attempt_id') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN attempt_id uuid
            REFERENCES public.cas_pratique_attempts(id) ON DELETE CASCADE;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='question_id') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN question_id uuid
            REFERENCES public.cas_pratique_questions(id) ON DELETE SET NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='normalized_text') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN normalized_text text;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='char_count') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN char_count int;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='status') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN status text NOT NULL DEFAULT 'validated';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='updated_at') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
    END IF;
END$$;

COMMENT ON TABLE public.cas_pratique_answers IS
    'Réponses utilisateurs. Une ligne par question répondue par tentative.';

-- ─── T011 — CORRECTIONS ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_corrections (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id          uuid NOT NULL UNIQUE REFERENCES public.cas_pratique_attempts(id) ON DELETE CASCADE,
    total_score         numeric(5,2) NOT NULL,
    total_max           numeric(5,2) NOT NULL,
    percent             numeric(5,2) NOT NULL,
    evaluated_at        timestamptz  NOT NULL DEFAULT now(),
    engine_version      text NOT NULL DEFAULT '2.0.0',
    engine_settings     jsonb NOT NULL DEFAULT '{}'::jsonb
);

COMMENT ON TABLE public.cas_pratique_corrections IS
    'Une correction = un score global pour une tentative. engine_version permet la traçabilité.';

-- ─── T012 — CORRECTION DETAILS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_correction_details (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    correction_id   uuid NOT NULL REFERENCES public.cas_pratique_corrections(id) ON DELETE CASCADE,
    question_id     uuid NOT NULL REFERENCES public.cas_pratique_questions(id) ON DELETE CASCADE,
    point_id        uuid NOT NULL REFERENCES public.cas_pratique_rubric_points(id) ON DELETE CASCADE,
    status          text NOT NULL CHECK (status IN ('covered','partial','missing')),
    score           numeric(3,2) NOT NULL,
    weight          numeric(3,2) NOT NULL,
    group_matches   jsonb NOT NULL DEFAULT '[]'::jsonb
);

COMMENT ON TABLE public.cas_pratique_correction_details IS
    'Détail point par point d''une correction. Permet d''afficher quels points sont couverts/manqués.';
