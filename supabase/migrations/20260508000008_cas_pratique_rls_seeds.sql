-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 008 : RLS policies + Seeds thèmes
--  Référence : docs/cas_pratique/03_SCHEMA.sql (sections 5 et 6, T019-T020 + seeds)
--  Tâche      : CODE-008
-- ════════════════════════════════════════════════════════════════════════════

-- ─── Helper : check is_admin via JWT custom claim ───────────────────────────
CREATE OR REPLACE FUNCTION public.fn_cp_is_admin() RETURNS boolean AS $$
    SELECT COALESCE((auth.jwt() ->> 'is_admin')::boolean, false);
$$ LANGUAGE sql STABLE;

-- ─── Activation RLS sur toutes les tables ───────────────────────────────────
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

-- ─── THÈMES ─────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_themes_read ON public.cas_pratique_themes;
CREATE POLICY p_cp_themes_read ON public.cas_pratique_themes
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS p_cp_themes_admin_write ON public.cas_pratique_themes;
CREATE POLICY p_cp_themes_admin_write ON public.cas_pratique_themes
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── CASES ─────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_cases_read_published ON public.cas_pratique_cases;
CREATE POLICY p_cp_cases_read_published ON public.cas_pratique_cases
    FOR SELECT USING (status = 'published' OR public.fn_cp_is_admin());

DROP POLICY IF EXISTS p_cp_cases_admin_write ON public.cas_pratique_cases;
CREATE POLICY p_cp_cases_admin_write ON public.cas_pratique_cases
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── QUESTIONS ──────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_questions_read ON public.cas_pratique_questions;
CREATE POLICY p_cp_questions_read ON public.cas_pratique_questions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_cases c
            WHERE c.id = case_id
              AND (c.status = 'published' OR public.fn_cp_is_admin())
        )
    );
DROP POLICY IF EXISTS p_cp_questions_admin_write ON public.cas_pratique_questions;
CREATE POLICY p_cp_questions_admin_write ON public.cas_pratique_questions
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── PERFECT ANSWERS ────────────────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_perfect_read ON public.cas_pratique_perfect_answers;
CREATE POLICY p_cp_perfect_read ON public.cas_pratique_perfect_answers
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_questions q
            JOIN public.cas_pratique_cases c ON c.id = q.case_id
            WHERE q.id = question_id
              AND (c.status = 'published' OR public.fn_cp_is_admin())
        )
    );
DROP POLICY IF EXISTS p_cp_perfect_admin_write ON public.cas_pratique_perfect_answers;
CREATE POLICY p_cp_perfect_admin_write ON public.cas_pratique_perfect_answers
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── RUBRIC POINTS — admin only (jamais leak côté user direct) ──────────────
DROP POLICY IF EXISTS p_cp_rubric_admin ON public.cas_pratique_rubric_points;
CREATE POLICY p_cp_rubric_admin ON public.cas_pratique_rubric_points
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── KEYWORD GROUPS — admin only ────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_groups_admin ON public.cas_pratique_keyword_groups;
CREATE POLICY p_cp_groups_admin ON public.cas_pratique_keyword_groups
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── KEYWORDS — admin only ──────────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_keywords_admin ON public.cas_pratique_keywords;
CREATE POLICY p_cp_keywords_admin ON public.cas_pratique_keywords
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── SYNONYMES DICT — admin only ────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_synonyms_admin ON public.cas_pratique_synonyms_dictionary;
CREATE POLICY p_cp_synonyms_admin ON public.cas_pratique_synonyms_dictionary
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── T019 — ATTEMPTS / ANSWERS — user voit/écrit ses propres données ────────
DROP POLICY IF EXISTS p_cp_attempts_user ON public.cas_pratique_attempts;
CREATE POLICY p_cp_attempts_user ON public.cas_pratique_attempts
    FOR ALL
    USING (auth.uid() = user_id OR public.fn_cp_is_admin())
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS p_cp_answers_user ON public.cas_pratique_answers;
CREATE POLICY p_cp_answers_user ON public.cas_pratique_answers
    FOR ALL
    USING (auth.uid() = user_id OR public.fn_cp_is_admin())
    WITH CHECK (auth.uid() = user_id);

-- ─── CORRECTIONS — user lit les siennes via FK attempt ──────────────────────
DROP POLICY IF EXISTS p_cp_corrections_user ON public.cas_pratique_corrections;
CREATE POLICY p_cp_corrections_user ON public.cas_pratique_corrections
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_attempts a
            WHERE a.id = attempt_id
              AND (a.user_id = auth.uid() OR public.fn_cp_is_admin())
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_attempts a
            WHERE a.id = attempt_id AND a.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS p_cp_corr_details_user ON public.cas_pratique_correction_details;
CREATE POLICY p_cp_corr_details_user ON public.cas_pratique_correction_details
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_corrections c
            JOIN public.cas_pratique_attempts a ON a.id = c.attempt_id
            WHERE c.id = correction_id
              AND (a.user_id = auth.uid() OR public.fn_cp_is_admin())
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.cas_pratique_corrections c
            JOIN public.cas_pratique_attempts a ON a.id = c.attempt_id
            WHERE c.id = correction_id AND a.user_id = auth.uid()
        )
    );

-- ─── APPEALS ────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_appeals_user_read ON public.cas_pratique_appeals;
CREATE POLICY p_cp_appeals_user_read ON public.cas_pratique_appeals
    FOR SELECT USING (auth.uid() = user_id OR public.fn_cp_is_admin());

DROP POLICY IF EXISTS p_cp_appeals_user_insert ON public.cas_pratique_appeals;
CREATE POLICY p_cp_appeals_user_insert ON public.cas_pratique_appeals
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS p_cp_appeals_admin_update ON public.cas_pratique_appeals;
CREATE POLICY p_cp_appeals_admin_update ON public.cas_pratique_appeals
    FOR UPDATE USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ─── USER PROGRESS ──────────────────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_progress_user_read ON public.cas_pratique_user_progress;
CREATE POLICY p_cp_progress_user_read ON public.cas_pratique_user_progress
    FOR SELECT USING (auth.uid() = user_id OR public.fn_cp_is_admin());

-- ─── T020 — AUDIT — admin only ──────────────────────────────────────────────
DROP POLICY IF EXISTS p_cp_audit_admin ON public.cas_pratique_admin_audit;
CREATE POLICY p_cp_audit_admin ON public.cas_pratique_admin_audit
    FOR ALL USING (public.fn_cp_is_admin()) WITH CHECK (public.fn_cp_is_admin());

-- ════════════════════════════════════════════════════════════════════════════
--  SEEDS — Thèmes initiaux
-- ════════════════════════════════════════════════════════════════════════════
INSERT INTO public.cas_pratique_themes (slug, label, color_hex, icon, sort_order) VALUES
    ('accueil',          'Accueil du public',          '#1147D9', 'support_agent_rounded',       10),
    ('deontologie',      'Déontologie',                '#0EA5E9', 'shield_rounded',              20),
    ('cadre_legal',      'Cadre légal',                '#22C55E', 'gavel_rounded',               30),
    ('securite_publique','Sécurité publique',          '#F59E0B', 'security_rounded',            40),
    ('intervention',     'Intervention',               '#EF4444', 'flash_on_rounded',            50),
    ('famille_mineur',   'Famille / Mineur',           '#A855F7', 'family_restroom_rounded',     60),
    ('routier',          'Sécurité routière',          '#06B6D4', 'directions_car_rounded',      70)
ON CONFLICT (slug) DO NOTHING;
