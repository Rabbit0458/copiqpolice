-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 002 : Taxonomie & Cas
--  Tables : themes, cases, questions, perfect_answers (T001-T004)
--  Référence : docs/cas_pratique/03_SCHEMA.sql (section 2, T001-T004)
--  Tâche      : CODE-002
-- ════════════════════════════════════════════════════════════════════════════

-- ─── T001 — THÈMES ──────────────────────────────────────────────────────────
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
    'Taxonomie des thèmes de cas pratique (Accueil, Déontologie, Cadre légal, Sécurité publique, …).';

-- ─── T002 — CAS PRATIQUES ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_cases (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug                text NOT NULL UNIQUE,
    title               text NOT NULL,
    year                int  NOT NULL,
    month               text,
    theme_id            uuid REFERENCES public.cas_pratique_themes(id) ON DELETE SET NULL,
    situation_text      text NOT NULL,
    situation_md        text,
    difficulty          text NOT NULL DEFAULT 'moyen'
                          CHECK (difficulty IN ('facile','moyen','difficile')),
    total_points        int  NOT NULL DEFAULT 15,
    estimated_minutes   int  NOT NULL DEFAULT 15,
    status              text NOT NULL DEFAULT 'draft'
                          CHECK (status IN ('draft','review','published','archived')),
    notes_admin         text,
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now(),
    published_at        timestamptz,
    created_by          uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE public.cas_pratique_cases IS
    'Cas pratiques GPX. Un cas = une mise en situation + N questions. Workflow : draft → review → published → archived.';

-- ─── T003 — QUESTIONS ───────────────────────────────────────────────────────
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

-- ─── T004 — RÉPONSE PARFAITE ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_perfect_answers (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id         uuid NOT NULL UNIQUE REFERENCES public.cas_pratique_questions(id) ON DELETE CASCADE,
    body_md             text NOT NULL,
    references_legal    jsonb NOT NULL DEFAULT '[]'::jsonb,
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_perfect_answers IS
    'Réponse modèle pour chaque question. Sert d''affichage post-correction et de base à la rubric.';
