-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 005 : Appeals, Progress, Audit
--  Tables : appeals, user_progress, admin_audit (T013-T015) + cycle FK keyword↔appeal
--  Référence : docs/cas_pratique/03_SCHEMA.sql (section 2, T013-T015)
--  Tâche      : CODE-005
-- ════════════════════════════════════════════════════════════════════════════

-- ─── T013 — APPEALS ─────────────────────────────────────────────────────────
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

COMMENT ON TABLE public.cas_pratique_appeals IS
    'Signalements user "ma réponse est correcte". Filet de sécurité du moteur. Approve = ajout auto d''un keyword.';

-- ─── Cycle FK : cas_pratique_keywords.appeal_id → cas_pratique_appeals ──────
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_keyword_appeal'
          AND table_name = 'cas_pratique_keywords'
    ) THEN
        ALTER TABLE public.cas_pratique_keywords
            ADD CONSTRAINT fk_keyword_appeal
            FOREIGN KEY (appeal_id) REFERENCES public.cas_pratique_appeals(id) ON DELETE SET NULL;
    END IF;
END$$;

-- ─── T014 — USER PROGRESS ───────────────────────────────────────────────────
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
    'Stats agrégées par user. Mise à jour automatique via trigger (migration 007).';

-- ─── T015 — ADMIN AUDIT ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cas_pratique_admin_audit (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id        uuid NOT NULL REFERENCES auth.users(id) ON DELETE SET NULL,
    action          text NOT NULL CHECK (action IN
                      ('create','update','delete','publish','archive',
                       'approve_appeal','reject_appeal','add_keyword','add_synonym')),
    entity          text NOT NULL,
    entity_id       uuid,
    payload_diff    jsonb,
    ip              text,
    user_agent      text,
    created_at      timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_admin_audit IS
    'Journal d''audit des actions admin. Traçabilité complète.';
