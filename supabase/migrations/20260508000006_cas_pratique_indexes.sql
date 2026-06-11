-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 006 : Indexes
--  Référence : docs/cas_pratique/03_SCHEMA.sql (section 3, T016-T017)
--  Tâche      : CODE-006
-- ════════════════════════════════════════════════════════════════════════════

-- ─── T016 — Indexes opérationnels ───────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_cases_theme_id
    ON public.cas_pratique_cases(theme_id);
CREATE INDEX IF NOT EXISTS idx_cases_status_published
    ON public.cas_pratique_cases(status, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_questions_case_id
    ON public.cas_pratique_questions(case_id, position);
CREATE INDEX IF NOT EXISTS idx_rubric_question
    ON public.cas_pratique_rubric_points(question_id, position);
CREATE INDEX IF NOT EXISTS idx_groups_point
    ON public.cas_pratique_keyword_groups(point_id, position);
CREATE INDEX IF NOT EXISTS idx_keywords_group
    ON public.cas_pratique_keywords(group_id);
CREATE INDEX IF NOT EXISTS idx_keywords_syn_dict
    ON public.cas_pratique_keywords(syn_dict_id) WHERE syn_dict_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_attempts_user_case
    ON public.cas_pratique_attempts(user_id, case_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_attempts_user_status
    ON public.cas_pratique_attempts(user_id, status);
CREATE INDEX IF NOT EXISTS idx_answers_attempt_question
    ON public.cas_pratique_answers(attempt_id, question_id);
CREATE INDEX IF NOT EXISTS idx_answers_user
    ON public.cas_pratique_answers(user_id, case_id);
CREATE INDEX IF NOT EXISTS idx_corr_details_correction
    ON public.cas_pratique_correction_details(correction_id, question_id);
CREATE INDEX IF NOT EXISTS idx_corrections_attempt
    ON public.cas_pratique_corrections(attempt_id);
CREATE INDEX IF NOT EXISTS idx_appeals_pending
    ON public.cas_pratique_appeals(status) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_appeals_user
    ON public.cas_pratique_appeals(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_admin
    ON public.cas_pratique_admin_audit(admin_id, created_at DESC);

-- ─── T017 — Indexes full-text trigram (recherche admin) ─────────────────────
CREATE INDEX IF NOT EXISTS idx_cases_title_trgm
    ON public.cas_pratique_cases USING gin (title gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_cases_situation_trgm
    ON public.cas_pratique_cases USING gin (situation_text gin_trgm_ops);
