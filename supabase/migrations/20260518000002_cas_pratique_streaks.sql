-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 011 : système de streaks            ║
-- ║  Tâche      : CODE-056                                                  ║
-- ║                                                                         ║
-- ║  - Ajoute la table `cas_pratique_streak_freezes` (jokers pour éviter   ║
-- ║    le reset à zéro sur 1 jour manqué).                                 ║
-- ║  - Fonction `fn_cp_compute_streak(p_user_id)` :                         ║
-- ║      Retourne `{ count, last_activity_at, is_at_risk, broken_at }`     ║
-- ║      en lisant attempts.finished_at distincts par jour (UTC).          ║
-- ║      Tient compte des freezes consommés.                                ║
-- ║  - Fonction `fn_cp_apply_streak_to_progress(p_user_id)` qui :          ║
-- ║      1. recalcule le streak                                              ║
-- ║      2. UPDATE cas_pratique_user_progress.streak_days en conséquence    ║
-- ║      Appelée par le trigger correction → user_progress (CODE-007).      ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

-- ─── Table des "freezes" (jokers anti-perte de streak) ─────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_streak_freezes (
    id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    granted_at timestamptz NOT NULL DEFAULT now(),
    consumed_for_day date,
    consumed_at timestamptz,
    source     text        NOT NULL DEFAULT 'manual'
                              CHECK (source IN ('manual','reward','premium','admin')),
    CHECK ((consumed_for_day IS NULL) = (consumed_at IS NULL))
);

COMMENT ON TABLE public.cas_pratique_streak_freezes IS
    'CODE-056 : jokers consommables qui empêchent le reset du streak sur 1 jour manqué.';

CREATE INDEX IF NOT EXISTS idx_cp_streak_freezes_user
    ON public.cas_pratique_streak_freezes(user_id)
    WHERE consumed_for_day IS NULL;

ALTER TABLE public.cas_pratique_streak_freezes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_streak_freezes_user_select ON public.cas_pratique_streak_freezes;
CREATE POLICY p_streak_freezes_user_select
    ON public.cas_pratique_streak_freezes
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

-- Insert / Update : seules les fonctions SECURITY DEFINER y touchent.
DROP POLICY IF EXISTS p_streak_freezes_admin_write ON public.cas_pratique_streak_freezes;
CREATE POLICY p_streak_freezes_admin_write
    ON public.cas_pratique_streak_freezes
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── fn_cp_compute_streak : pure, ne mute rien ─────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_compute_streak(p_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $func$
DECLARE
    v_days       date[];          -- jours d'activité distincts, desc
    v_today      date := (now() at time zone 'utc')::date;
    v_count      int := 0;
    v_cursor     date;
    v_expected   date := v_today;
    v_last       date;
    v_at_risk    boolean := false;
    v_broken_at  date;
    v_available_freezes int;
BEGIN
    IF p_user_id IS NULL THEN
        RETURN jsonb_build_object('count', 0);
    END IF;

    -- Liste des jours UTC où l'user a fini un attempt, desc.
    SELECT array_agg(DISTINCT (finished_at at time zone 'utc')::date ORDER BY (finished_at at time zone 'utc')::date DESC)
      INTO v_days
      FROM public.cas_pratique_attempts
     WHERE user_id = p_user_id
       AND status = 'completed'
       AND finished_at IS NOT NULL;

    IF v_days IS NULL OR array_length(v_days, 1) IS NULL THEN
        RETURN jsonb_build_object(
            'count', 0,
            'last_activity_at', NULL,
            'is_at_risk', false,
            'broken_at', NULL
        );
    END IF;

    v_last := v_days[1];

    -- Compte les freezes disponibles (non consommés)
    SELECT count(*) INTO v_available_freezes
      FROM public.cas_pratique_streak_freezes
     WHERE user_id = p_user_id
       AND consumed_for_day IS NULL;

    -- Walk : on attend chaque jour consécutif en partant de today (ou yesterday).
    -- Si v_last == today → on commence à today.
    -- Sinon si v_last == today-1 → at_risk, on commence à yesterday.
    -- Sinon → streak broken définitivement.
    IF v_last = v_today THEN
        v_expected := v_today;
    ELSIF v_last = v_today - 1 THEN
        v_expected := v_today - 1;
        v_at_risk := true;
    ELSE
        -- Trop de jours manqués : on tente d'appliquer les freezes.
        IF (v_today - v_last) - 1 <= v_available_freezes THEN
            -- Suffisamment de freezes : on continue.
            v_expected := v_last;
            v_at_risk := true;
        ELSE
            v_broken_at := v_last;
            RETURN jsonb_build_object(
                'count', 0,
                'last_activity_at', v_last,
                'is_at_risk', false,
                'broken_at', v_broken_at,
                'available_freezes', v_available_freezes
            );
        END IF;
    END IF;

    -- Compte les jours consécutifs.
    FOREACH v_cursor IN ARRAY v_days
    LOOP
        IF v_cursor = v_expected THEN
            v_count := v_count + 1;
            v_expected := v_expected - 1;
        ELSIF v_cursor < v_expected THEN
            -- Gap : on regarde les freezes
            WHILE v_expected > v_cursor AND v_available_freezes > 0 LOOP
                v_available_freezes := v_available_freezes - 1;
                v_expected := v_expected - 1;
                v_count := v_count + 1;
            END LOOP;
            IF v_cursor = v_expected THEN
                v_count := v_count + 1;
                v_expected := v_expected - 1;
            ELSE
                EXIT; -- streak cassé malgré les freezes
            END IF;
        END IF;
    END LOOP;

    RETURN jsonb_build_object(
        'count', v_count,
        'last_activity_at', v_last,
        'is_at_risk', v_at_risk,
        'broken_at', NULL,
        'available_freezes', v_available_freezes
    );
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_compute_streak(uuid) IS
    'CODE-056 : recalcule le streak d''un user à partir de cas_pratique_attempts (sans le persister). Tient compte des freezes disponibles.';

GRANT EXECUTE ON FUNCTION public.fn_cp_compute_streak(uuid) TO authenticated;

-- ─── fn_cp_apply_streak_to_progress : appelée par le trigger ───────────────

CREATE OR REPLACE FUNCTION public.fn_cp_apply_streak_to_progress(p_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_result jsonb;
    v_count  int;
BEGIN
    IF p_user_id IS NULL THEN RETURN; END IF;
    v_result := public.fn_cp_compute_streak(p_user_id);
    v_count := COALESCE((v_result->>'count')::int, 0);

    UPDATE public.cas_pratique_user_progress
       SET streak_days = v_count
     WHERE user_id = p_user_id;

    -- Si la ligne n'existait pas, le trigger user_progress de CODE-007 la
    -- créera ; on tente un INSERT défensif au cas où.
    INSERT INTO public.cas_pratique_user_progress (user_id, streak_days)
    VALUES (p_user_id, v_count)
    ON CONFLICT (user_id) DO NOTHING;
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_apply_streak_to_progress(uuid) IS
    'CODE-056 : appelle fn_cp_compute_streak et persiste le résultat dans cas_pratique_user_progress.streak_days.';

GRANT EXECUTE ON FUNCTION public.fn_cp_apply_streak_to_progress(uuid) TO authenticated;

-- ─── Trigger : à chaque INSERT correction, on met à jour le streak ─────────

CREATE OR REPLACE FUNCTION public.fn_cp_trg_apply_streak()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_user_id uuid;
BEGIN
    -- Récupère le user_id depuis l'attempt liée
    SELECT user_id INTO v_user_id
      FROM public.cas_pratique_attempts
     WHERE id = NEW.attempt_id
     LIMIT 1;
    IF v_user_id IS NOT NULL THEN
        PERFORM public.fn_cp_apply_streak_to_progress(v_user_id);
    END IF;
    RETURN NEW;
END;
$func$;

DROP TRIGGER IF EXISTS trg_cp_apply_streak ON public.cas_pratique_corrections;
CREATE TRIGGER trg_cp_apply_streak
    AFTER INSERT ON public.cas_pratique_corrections
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_cp_trg_apply_streak();

COMMIT;
