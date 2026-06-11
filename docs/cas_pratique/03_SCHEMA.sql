-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique GPX — Schéma Supabase complet
--  Version : 1.0.0
--  Date    : 2026-05-08
--
--  Ordre d'exécution :
--    1. Extensions
--    2. Tables (T001-T015)
--    3. Indexes (T016-T017)
--    4. Triggers (T018)
--    5. RLS (T019-T020)
--    6. Seeds (T023)
--
--  Conventions :
--    - Tous les noms de table sont préfixés `cas_pratique_`
--    - Toutes les PK sont des `uuid` générés par `gen_random_uuid()`
--    - Les FK ont un ON DELETE explicite (CASCADE pour les hiérarchies, RESTRICT sinon)
--    - Les timestamps sont en `timestamptz`, valeur par défaut `now()`
-- ════════════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. EXTENSIONS
-- ─────────────────────────────────────────────────────────────────────────────

CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- recherche full-text trigram
CREATE EXTENSION IF NOT EXISTS "unaccent";   -- normalisation accents côté DB (option)

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. TABLES
-- ─────────────────────────────────────────────────────────────────────────────

-- T001 ─── THÈMES ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_themes (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug        text NOT NULL UNIQUE,
    label       text NOT NULL,
    color_hex   text NOT NULL DEFAULT '#1147D9',
    icon        text NOT NULL DEFAULT 'shield_rounded',
    sort_order  int  NOT NULL DEFAULT 100,
    created_at  timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_themes IS
    'Taxonomie des thèmes de cas pratique (Accueil, Déontologie, Cadre légal, Sécurité publique, …)';

-- T002 ─── CAS PRATIQUES ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_cases (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug                text NOT NULL UNIQUE,
    title               text NOT NULL,
    year                int  NOT NULL,
    month               text,           -- "Mars", "Septembre", "Février", …
    theme_id            uuid REFERENCES public.cas_pratique_themes(id) ON DELETE SET NULL,
    situation_text      text NOT NULL,  -- texte brut (fallback)
    situation_md        text,           -- version markdown enrichie
    difficulty          text NOT NULL DEFAULT 'moyen'
                          CHECK (difficulty IN ('facile','moyen','difficile')),
    total_points        int  NOT NULL DEFAULT 15,
    estimated_minutes   int  NOT NULL DEFAULT 15,
    status              text NOT NULL DEFAULT 'draft'
                          CHECK (status IN ('draft','review','published','archived')),
    notes_admin         text,           -- notes internes non visibles users
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now(),
    published_at        timestamptz,
    created_by          uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE public.cas_pratique_cases IS
    'Cas pratiques GPX. Un cas = une mise en situation + N questions. Statut workflow : draft → review → published → archived.';

-- T003 ─── QUESTIONS ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_questions (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id             uuid NOT NULL REFERENCES public.cas_pratique_cases(id) ON DELETE CASCADE,
    position            int  NOT NULL,
    label               text NOT NULL,
    hint                text,
    max_points          int  NOT NULL DEFAULT 5,
    char_min            int  NOT NULL DEFAULT 50,
    char_recommended    int  NOT NULL DEFAULT 400,
    created_at          timestamptz NOT NULL DEFAULT now(),
    UNIQUE(case_id, position)
);

COMMENT ON TABLE public.cas_pratique_questions IS
    'Questions liées à un cas. Typiquement 3 questions × 5 points = 15 points par cas.';

-- T004 ─── RÉPONSE PARFAITE ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_perfect_answers (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id         uuid NOT NULL UNIQUE REFERENCES public.cas_pratique_questions(id) ON DELETE CASCADE,
    body_md             text NOT NULL,
    references_legal    jsonb NOT NULL DEFAULT '[]'::jsonb, -- [{article:"322-1", code:"penal"}]
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_perfect_answers IS
    'Réponse modèle pour chaque question. Sert d''affichage post-correction et de base à la rubric.';

-- T005 ─── RUBRIC POINTS ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_rubric_points (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id     uuid NOT NULL REFERENCES public.cas_pratique_questions(id) ON DELETE CASCADE,
    position        int  NOT NULL,
    label           text NOT NULL,                 -- ex: "Qualifier l'infraction"
    weight          numeric(3,2) NOT NULL DEFAULT 1.00,
    is_required     boolean NOT NULL DEFAULT true,
    kind            text NOT NULL DEFAULT 'core'
                      CHECK (kind IN ('core','bonus')),
    explanation_md  text,                          -- explication pédagogique (affichée en correction)
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE(question_id, position)
);

COMMENT ON TABLE public.cas_pratique_rubric_points IS
    'Grille de correction par question. Chaque point a un poids et peut être core (essentiel) ou bonus (secondaire).';

-- T006 ─── KEYWORD GROUPS ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_keyword_groups (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    point_id        uuid NOT NULL REFERENCES public.cas_pratique_rubric_points(id) ON DELETE CASCADE,
    position        int  NOT NULL,
    description     text,                          -- ex: "Variantes de 'dégradation'"
    is_optional     boolean NOT NULL DEFAULT false,
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE(point_id, position)
);

COMMENT ON TABLE public.cas_pratique_keyword_groups IS
    'Groupes de keywords pour un point. Logique : ENTRE groupes = ET, INTRA groupe = OR. Si is_optional = true, le groupe ne bloque pas le matching.';

-- T008 ─── DICTIONNAIRE DE SYNONYMES MUTUALISÉ ──────────────────────────────
-- (Créée avant T007 car T007 référence T008)
CREATE TABLE IF NOT EXISTS public.cas_pratique_synonyms_dictionary (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            text NOT NULL UNIQUE,          -- ex: "calmer", "degrader"
    label           text NOT NULL,                 -- ex: "Synonymes de 'calmer'"
    terms           jsonb NOT NULL,                -- ["calmer","apaiser","calmement","desamorcer",...]
    tags            jsonb NOT NULL DEFAULT '[]'::jsonb, -- ["deontologie","accueil"]
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    owner_admin_id  uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE public.cas_pratique_synonyms_dictionary IS
    'Dictionnaire global de synonymes réutilisable. Permet de DRY les keywords entre rubrics.';

-- T007 ─── KEYWORDS ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_keywords (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id        uuid REFERENCES public.cas_pratique_keyword_groups(id) ON DELETE CASCADE,
    syn_dict_id     uuid REFERENCES public.cas_pratique_synonyms_dictionary(id) ON DELETE SET NULL,
    value           text,                          -- soit valeur littérale...
    is_phrase       boolean NOT NULL DEFAULT false,-- ...ou expression multi-mots
    is_negation     boolean NOT NULL DEFAULT false,-- inverse la logique de match
    fuzzy_max_dist  int     NOT NULL DEFAULT 1,    -- 0 = match exact only, 1-2 = fuzzy
    position        int     NOT NULL DEFAULT 0,
    created_at      timestamptz NOT NULL DEFAULT now(),
    created_by      uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    auto_added      boolean NOT NULL DEFAULT false,-- true si ajouté via approve d'un appeal
    appeal_id       uuid,                          -- FK ajoutée plus tard (cycle)
    CONSTRAINT keyword_value_or_dict_required
      CHECK ((value IS NOT NULL) OR (syn_dict_id IS NOT NULL))
);

COMMENT ON TABLE public.cas_pratique_keywords IS
    'Mots-clés ou expressions à matcher. Soit value littérale, soit pointeur vers le dictionnaire de synonymes.';

-- T009 ─── ATTEMPTS ──────────────────────────────────────────────────────────
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

-- T010 ─── ANSWERS (migration de l'existant) ─────────────────────────────────
-- Si la table existe déjà, on ajoute les colonnes manquantes
CREATE TABLE IF NOT EXISTS public.cas_pratique_answers (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    case_id         text NOT NULL,                  -- legacy : "case_1" etc.
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

-- Si la table préexistait sans certaines colonnes, on les ajoute (idempotent)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='attempt_id') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN attempt_id uuid;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name='cas_pratique_answers' AND column_name='question_id') THEN
        ALTER TABLE public.cas_pratique_answers ADD COLUMN question_id uuid;
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
END$$;

COMMENT ON TABLE public.cas_pratique_answers IS
    'Réponses utilisateurs. Une ligne par question répondue par tentative.';

-- T011 ─── CORRECTIONS ───────────────────────────────────────────────────────
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
    'Une correction = un score global pour une tentative. engine_version permet de retracer quelle version du moteur a évalué.';

-- T012 ─── CORRECTION DETAILS (point par point) ──────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_correction_details (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    correction_id   uuid NOT NULL REFERENCES public.cas_pratique_corrections(id) ON DELETE CASCADE,
    question_id     uuid NOT NULL REFERENCES public.cas_pratique_questions(id) ON DELETE CASCADE,
    point_id        uuid NOT NULL REFERENCES public.cas_pratique_rubric_points(id) ON DELETE CASCADE,
    status          text NOT NULL CHECK (status IN ('covered','partial','missing')),
    score           numeric(3,2) NOT NULL,
    weight          numeric(3,2) NOT NULL,
    group_matches   jsonb NOT NULL DEFAULT '[]'::jsonb -- debug : [{group_id, matched_keywords:[...]}]
);

COMMENT ON TABLE public.cas_pratique_correction_details IS
    'Détail point par point d''une correction. Permet d''afficher quels points sont couverts/manqués.';

-- T013 ─── APPEALS ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_appeals (
    id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    correction_detail_id    uuid NOT NULL REFERENCES public.cas_pratique_correction_details(id) ON DELETE CASCADE,
    user_id                 uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    message                 text,
    status                  text NOT NULL DEFAULT 'pending'
                              CHECK (status IN ('pending','approved','rejected')),
    admin_id                uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    admin_response          text,
    processed_at            timestamptz,
    created_keyword_id      uuid REFERENCES public.cas_pratique_keywords(id) ON DELETE SET NULL,
    created_at              timestamptz NOT NULL DEFAULT now()
);

-- Cycle FK : keywords ↔ appeals
ALTER TABLE public.cas_pratique_keywords
    ADD CONSTRAINT fk_keyword_appeal
    FOREIGN KEY (appeal_id) REFERENCES public.cas_pratique_appeals(id) ON DELETE SET NULL;

COMMENT ON TABLE public.cas_pratique_appeals IS
    'Signalements user "ma réponse est correcte". Filet de sécurité du moteur. Approve = ajout auto d''un keyword.';

-- T014 ─── USER PROGRESS ─────────────────────────────────────────────────────
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
    'Stats agrégées par user. Mise à jour automatique via trigger T018.';

-- T015 ─── ADMIN AUDIT ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_admin_audit (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id        uuid NOT NULL REFERENCES auth.users(id) ON DELETE SET NULL,
    action          text NOT NULL CHECK (action IN
                      ('create','update','delete','publish','archive',
                       'approve_appeal','reject_appeal','add_keyword','add_synonym')),
    entity          text NOT NULL,                 -- 'case', 'question', 'rubric_point', 'keyword', ...
    entity_id       uuid,
    payload_diff    jsonb,
    ip              text,
    user_agent      text,
    created_at      timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_admin_audit IS
    'Journal d''audit des actions admin. Traçabilité complète.';

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. INDEXES (T016, T017)
-- ─────────────────────────────────────────────────────────────────────────────

-- T016
CREATE INDEX IF NOT EXISTS idx_cases_theme_id           ON public.cas_pratique_cases(theme_id);
CREATE INDEX IF NOT EXISTS idx_cases_status_published   ON public.cas_pratique_cases(status, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_questions_case_id        ON public.cas_pratique_questions(case_id, position);
CREATE INDEX IF NOT EXISTS idx_rubric_question          ON public.cas_pratique_rubric_points(question_id, position);
CREATE INDEX IF NOT EXISTS idx_groups_point             ON public.cas_pratique_keyword_groups(point_id, position);
CREATE INDEX IF NOT EXISTS idx_keywords_group           ON public.cas_pratique_keywords(group_id);
CREATE INDEX IF NOT EXISTS idx_attempts_user_case       ON public.cas_pratique_attempts(user_id, case_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_attempts_user_status     ON public.cas_pratique_attempts(user_id, status);
CREATE INDEX IF NOT EXISTS idx_answers_attempt_question ON public.cas_pratique_answers(attempt_id, question_id);
CREATE INDEX IF NOT EXISTS idx_corr_details_correction  ON public.cas_pratique_correction_details(correction_id, question_id);
CREATE INDEX IF NOT EXISTS idx_appeals_pending          ON public.cas_pratique_appeals(status) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_audit_admin              ON public.cas_pratique_admin_audit(admin_id, created_at DESC);

-- T017 — Full-text trigram pour recherche admin
CREATE INDEX IF NOT EXISTS idx_cases_title_trgm
    ON public.cas_pratique_cases USING gin (title gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_cases_situation_trgm
    ON public.cas_pratique_cases USING gin (situation_text gin_trgm_ops);

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. TRIGGERS (T018)
-- ─────────────────────────────────────────────────────────────────────────────

-- Trigger générique : updated_at
CREATE OR REPLACE FUNCTION public.fn_set_updated_at() RETURNS trigger AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_cases_updated_at ON public.cas_pratique_cases;
CREATE TRIGGER trg_cases_updated_at
    BEFORE UPDATE ON public.cas_pratique_cases
    FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();

DROP TRIGGER IF EXISTS trg_perfect_answers_updated_at ON public.cas_pratique_perfect_answers;
CREATE TRIGGER trg_perfect_answers_updated_at
    BEFORE UPDATE ON public.cas_pratique_perfect_answers
    FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();

DROP TRIGGER IF EXISTS trg_synonyms_updated_at ON public.cas_pratique_synonyms_dictionary;
CREATE TRIGGER trg_synonyms_updated_at
    BEFORE UPDATE ON public.cas_pratique_synonyms_dictionary
    FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();

DROP TRIGGER IF EXISTS trg_progress_updated_at ON public.cas_pratique_user_progress;
CREATE TRIGGER trg_progress_updated_at
    BEFORE UPDATE ON public.cas_pratique_user_progress
    FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();

DROP TRIGGER IF EXISTS trg_answers_updated_at ON public.cas_pratique_answers;
CREATE TRIGGER trg_answers_updated_at
    BEFORE UPDATE ON public.cas_pratique_answers
    FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();

-- T018 — Trigger update_user_progress_after_correction
CREATE OR REPLACE FUNCTION public.fn_update_user_progress() RETURNS trigger AS $$
DECLARE
    v_user_id uuid;
    v_avg     numeric(5,2);
    v_best    numeric(5,2);
    v_started int;
    v_finished int;
    v_total   int;
    v_last    timestamptz;
BEGIN
    -- Récup user_id via attempt
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

DROP TRIGGER IF EXISTS trg_update_progress_after_correction
    ON public.cas_pratique_corrections;
CREATE TRIGGER trg_update_progress_after_correction
    AFTER INSERT OR UPDATE ON public.cas_pratique_corrections
    FOR EACH ROW EXECUTE FUNCTION public.fn_update_user_progress();

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. ROW LEVEL SECURITY (T019, T020)
-- ─────────────────────────────────────────────────────────────────────────────

-- Helper : check is_admin
CREATE OR REPLACE FUNCTION public.fn_is_admin() RETURNS boolean AS $$
    SELECT COALESCE((auth.jwt() ->> 'is_admin')::boolean, false);
$$ LANGUAGE sql STABLE;

-- ── Tables LECTURE PUBLIQUE (cas publiés) ───────────────────────────────────
ALTER TABLE public.cas_pratique_themes              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_cases               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_questions           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_perfect_answers     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_rubric_points       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_keyword_groups      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_keywords            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_synonyms_dictionary ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_attempts            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_answers             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_corrections         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_correction_details  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_appeals             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_user_progress       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cas_pratique_admin_audit         ENABLE ROW LEVEL SECURITY;

-- THÈMES — lecture publique (authentifié), écriture admin
DROP POLICY IF EXISTS p_themes_read ON public.cas_pratique_themes;
CREATE POLICY p_themes_read ON public.cas_pratique_themes
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS p_themes_admin_write ON public.cas_pratique_themes;
CREATE POLICY p_themes_admin_write ON public.cas_pratique_themes
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

-- CASES — user voit les published, admin voit tout
DROP POLICY IF EXISTS p_cases_read_published ON public.cas_pratique_cases;
CREATE POLICY p_cases_read_published ON public.cas_pratique_cases
    FOR SELECT USING (status = 'published' OR public.fn_is_admin());

DROP POLICY IF EXISTS p_cases_admin_write ON public.cas_pratique_cases;
CREATE POLICY p_cases_admin_write ON public.cas_pratique_cases
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

-- QUESTIONS / PERFECT_ANSWERS / RUBRICS / GROUPS / KEYWORDS / SYNONYMS
-- → lecture sur les cas published, écriture admin
DROP POLICY IF EXISTS p_questions_read ON public.cas_pratique_questions;
CREATE POLICY p_questions_read ON public.cas_pratique_questions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_cases c
            WHERE c.id = case_id
              AND (c.status = 'published' OR public.fn_is_admin())
        )
    );
DROP POLICY IF EXISTS p_questions_admin_write ON public.cas_pratique_questions;
CREATE POLICY p_questions_admin_write ON public.cas_pratique_questions
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

-- (mêmes patterns pour perfect_answers, rubric_points, keyword_groups, keywords, synonyms_dictionary)
DROP POLICY IF EXISTS p_perfect_read ON public.cas_pratique_perfect_answers;
CREATE POLICY p_perfect_read ON public.cas_pratique_perfect_answers
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_questions q
            JOIN public.cas_pratique_cases c ON c.id = q.case_id
            WHERE q.id = question_id
              AND (c.status = 'published' OR public.fn_is_admin())
        )
    );
DROP POLICY IF EXISTS p_perfect_admin_write ON public.cas_pratique_perfect_answers;
CREATE POLICY p_perfect_admin_write ON public.cas_pratique_perfect_answers
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

DROP POLICY IF EXISTS p_rubric_read ON public.cas_pratique_rubric_points;
CREATE POLICY p_rubric_read ON public.cas_pratique_rubric_points
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_questions q
            JOIN public.cas_pratique_cases c ON c.id = q.case_id
            WHERE q.id = question_id
              AND (c.status = 'published' OR public.fn_is_admin())
        )
    );
DROP POLICY IF EXISTS p_rubric_admin_write ON public.cas_pratique_rubric_points;
CREATE POLICY p_rubric_admin_write ON public.cas_pratique_rubric_points
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

DROP POLICY IF EXISTS p_groups_read ON public.cas_pratique_keyword_groups;
CREATE POLICY p_groups_read ON public.cas_pratique_keyword_groups
    FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS p_groups_admin_write ON public.cas_pratique_keyword_groups;
CREATE POLICY p_groups_admin_write ON public.cas_pratique_keyword_groups
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

DROP POLICY IF EXISTS p_keywords_read ON public.cas_pratique_keywords;
CREATE POLICY p_keywords_read ON public.cas_pratique_keywords
    FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS p_keywords_admin_write ON public.cas_pratique_keywords;
CREATE POLICY p_keywords_admin_write ON public.cas_pratique_keywords
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

DROP POLICY IF EXISTS p_synonyms_read ON public.cas_pratique_synonyms_dictionary;
CREATE POLICY p_synonyms_read ON public.cas_pratique_synonyms_dictionary
    FOR SELECT USING (auth.role() = 'authenticated');
DROP POLICY IF EXISTS p_synonyms_admin_write ON public.cas_pratique_synonyms_dictionary;
CREATE POLICY p_synonyms_admin_write ON public.cas_pratique_synonyms_dictionary
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

-- T019 — User RLS sur SES données
DROP POLICY IF EXISTS p_attempts_user ON public.cas_pratique_attempts;
CREATE POLICY p_attempts_user ON public.cas_pratique_attempts
    FOR ALL
    USING (auth.uid() = user_id OR public.fn_is_admin())
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS p_answers_user ON public.cas_pratique_answers;
CREATE POLICY p_answers_user ON public.cas_pratique_answers
    FOR ALL
    USING (auth.uid() = user_id OR public.fn_is_admin())
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS p_corrections_user ON public.cas_pratique_corrections;
CREATE POLICY p_corrections_user ON public.cas_pratique_corrections
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_attempts a
            WHERE a.id = attempt_id
              AND (a.user_id = auth.uid() OR public.fn_is_admin())
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_attempts a
            WHERE a.id = attempt_id AND a.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS p_corr_details_user ON public.cas_pratique_correction_details;
CREATE POLICY p_corr_details_user ON public.cas_pratique_correction_details
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_corrections c
            JOIN public.cas_pratique_attempts a ON a.id = c.attempt_id
            WHERE c.id = correction_id
              AND (a.user_id = auth.uid() OR public.fn_is_admin())
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_corrections c
            JOIN public.cas_pratique_attempts a ON a.id = c.attempt_id
            WHERE c.id = correction_id AND a.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS p_appeals_user ON public.cas_pratique_appeals;
CREATE POLICY p_appeals_user ON public.cas_pratique_appeals
    FOR SELECT USING (auth.uid() = user_id OR public.fn_is_admin());
DROP POLICY IF EXISTS p_appeals_user_insert ON public.cas_pratique_appeals;
CREATE POLICY p_appeals_user_insert ON public.cas_pratique_appeals
    FOR INSERT WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS p_appeals_admin_write ON public.cas_pratique_appeals;
CREATE POLICY p_appeals_admin_write ON public.cas_pratique_appeals
    FOR UPDATE USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

DROP POLICY IF EXISTS p_progress_user ON public.cas_pratique_user_progress;
CREATE POLICY p_progress_user ON public.cas_pratique_user_progress
    FOR SELECT USING (auth.uid() = user_id OR public.fn_is_admin());

-- T020 — Admin audit
DROP POLICY IF EXISTS p_audit_admin ON public.cas_pratique_admin_audit;
CREATE POLICY p_audit_admin ON public.cas_pratique_admin_audit
    FOR ALL USING (public.fn_is_admin()) WITH CHECK (public.fn_is_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. SEEDS — Thèmes de base (T023)
-- ─────────────────────────────────────────────────────────────────────────────

INSERT INTO public.cas_pratique_themes (slug, label, color_hex, icon, sort_order) VALUES
    ('accueil',          'Accueil du public',          '#1147D9', 'support_agent_rounded',       10),
    ('deontologie',      'Déontologie',                '#0EA5E9', 'shield_rounded',              20),
    ('cadre_legal',      'Cadre légal',                '#22C55E', 'gavel_rounded',               30),
    ('securite_publique','Sécurité publique',          '#F59E0B', 'security_rounded',            40),
    ('intervention',     'Intervention',               '#EF4444', 'flash_on_rounded',            50),
    ('famille_mineur',   'Famille / Mineur',           '#A855F7', 'family_restroom_rounded',     60),
    ('routier',          'Sécurité routière',          '#06B6D4', 'directions_car_rounded',      70)
ON CONFLICT (slug) DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
--  FIN DU SCHEMA
-- ════════════════════════════════════════════════════════════════════════════
