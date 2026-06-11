-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 003 : Rubrics & Keywords
--  Tables : rubric_points, keyword_groups, synonyms_dictionary, keywords (T005-T008)
--  Référence : docs/cas_pratique/03_SCHEMA.sql (section 2, T005-T008)
--  Tâche      : CODE-003
-- ════════════════════════════════════════════════════════════════════════════

-- ─── T005 — RUBRIC POINTS ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_rubric_points (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id     uuid NOT NULL REFERENCES public.cas_pratique_questions(id) ON DELETE CASCADE,
    position        int  NOT NULL,
    label           text NOT NULL,
    weight          numeric(3,2) NOT NULL DEFAULT 1.00,
    is_required     boolean NOT NULL DEFAULT true,
    kind            text NOT NULL DEFAULT 'core'
                      CHECK (kind IN ('core','bonus')),
    explanation_md  text,
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE(question_id, position)
);

COMMENT ON TABLE public.cas_pratique_rubric_points IS
    'Grille de correction par question. Chaque point a un poids et peut être core (essentiel) ou bonus (secondaire).';

-- ─── T006 — KEYWORD GROUPS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_keyword_groups (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    point_id        uuid NOT NULL REFERENCES public.cas_pratique_rubric_points(id) ON DELETE CASCADE,
    position        int  NOT NULL,
    description     text,
    is_optional     boolean NOT NULL DEFAULT false,
    created_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE(point_id, position)
);

COMMENT ON TABLE public.cas_pratique_keyword_groups IS
    'Groupes de keywords pour un point. ENTRE groupes = ET, INTRA groupe = OR. Si is_optional, ne bloque pas le matching.';

-- ─── T008 — DICTIONNAIRE DE SYNONYMES MUTUALISÉ ─────────────────────────────
-- (Créée avant T007 car T007 référence T008)
CREATE TABLE IF NOT EXISTS public.cas_pratique_synonyms_dictionary (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            text NOT NULL UNIQUE,
    label           text NOT NULL,
    terms           jsonb NOT NULL,
    tags            jsonb NOT NULL DEFAULT '[]'::jsonb,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    owner_admin_id  uuid REFERENCES auth.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE public.cas_pratique_synonyms_dictionary IS
    'Dictionnaire global de synonymes réutilisable entre rubrics. DRY des keywords.';

-- ─── T007 — KEYWORDS ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_keywords (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id        uuid REFERENCES public.cas_pratique_keyword_groups(id) ON DELETE CASCADE,
    syn_dict_id     uuid REFERENCES public.cas_pratique_synonyms_dictionary(id) ON DELETE SET NULL,
    value           text,
    is_phrase       boolean NOT NULL DEFAULT false,
    is_negation     boolean NOT NULL DEFAULT false,
    fuzzy_max_dist  int     NOT NULL DEFAULT 1,
    position        int     NOT NULL DEFAULT 0,
    created_at      timestamptz NOT NULL DEFAULT now(),
    created_by      uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    auto_added      boolean NOT NULL DEFAULT false,
    appeal_id       uuid,  -- FK vers cas_pratique_appeals ajoutée à la migration 005 (cycle)
    CONSTRAINT keyword_value_or_dict_required
      CHECK ((value IS NOT NULL) OR (syn_dict_id IS NOT NULL))
);

COMMENT ON TABLE public.cas_pratique_keywords IS
    'Mots-clés ou expressions à matcher. Soit value littérale, soit pointeur vers le dictionnaire de synonymes.';
