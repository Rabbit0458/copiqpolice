-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 015 : parrainage (referral codes)   ║
-- ║  Tâche      : CODE-060                                                  ║
-- ║                                                                         ║
-- ║  - Table `cas_pratique_referral_codes` : 1 code unique par user        ║
-- ║    (6 caractères alphanum upper, généré côté DB).                       ║
-- ║                                                                         ║
-- ║  - Table `cas_pratique_referrals` : enregistre chaque parrainage       ║
-- ║    abouti (referrer + referee + code_used + converted_at).              ║
-- ║                                                                         ║
-- ║  - Fonction `fn_cp_get_or_create_my_referral_code()` : retourne le    ║
-- ║    code de l'user courant, en créant une ligne si absente.             ║
-- ║                                                                         ║
-- ║  - Fonction `fn_cp_redeem_referral_code(p_code)` :                     ║
-- ║      Vérifie validité + pas auto-parrainage + pas déjà parrainé.       ║
-- ║      Crée la ligne `cas_pratique_referrals` avec status='converted'.   ║
-- ║      Crédite +500 XP au parrain ET au filleul via xp_ledger             ║
-- ║      (reason = 'referral_bonus').                                       ║
-- ║                                                                         ║
-- ║  - Étend le CHECK de cas_pratique_xp_ledger.reason pour accepter       ║
-- ║    'referral_bonus'.                                                    ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

-- ─── Étendre la CHECK constraint du ledger pour 'referral_bonus' ──────────

ALTER TABLE public.cas_pratique_xp_ledger
    DROP CONSTRAINT IF EXISTS cas_pratique_xp_ledger_reason_check;

ALTER TABLE public.cas_pratique_xp_ledger
    ADD CONSTRAINT cas_pratique_xp_ledger_reason_check
    CHECK (reason IN (
        'correction_score',
        'streak_bonus',
        'first_try_bonus',
        'daily_challenge',
        'badge_unlock',
        'admin_grant',
        'admin_revoke',
        'referral_bonus'
    ));

-- ─── Table : referral codes (1 par user) ──────────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_referral_codes (
    user_id    uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    code       text        NOT NULL UNIQUE,
    created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.cas_pratique_referral_codes IS
    'CODE-060 : 1 code de parrainage unique par utilisateur (6 chars upper).';

ALTER TABLE public.cas_pratique_referral_codes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_ref_codes_select_self ON public.cas_pratique_referral_codes;
CREATE POLICY p_ref_codes_select_self
    ON public.cas_pratique_referral_codes
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

-- Pas d'INSERT/UPDATE/DELETE direct — uniquement via fn_cp_get_or_create_my_referral_code
DROP POLICY IF EXISTS p_ref_codes_admin_write ON public.cas_pratique_referral_codes;
CREATE POLICY p_ref_codes_admin_write
    ON public.cas_pratique_referral_codes
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Table : referrals (parrainages aboutis) ──────────────────────────────

CREATE TABLE IF NOT EXISTS public.cas_pratique_referrals (
    id                uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
    referrer_user_id  uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    referee_user_id   uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    code_used         text        NOT NULL,
    status            text        NOT NULL DEFAULT 'converted'
                                    CHECK (status IN ('pending', 'converted', 'rejected')),
    xp_awarded        int         NOT NULL DEFAULT 500,
    converted_at      timestamptz NOT NULL DEFAULT now(),
    -- Un filleul ne peut être parrainé qu'une seule fois
    UNIQUE (referee_user_id),
    -- Pas d'auto-parrainage
    CHECK (referrer_user_id <> referee_user_id)
);

COMMENT ON TABLE public.cas_pratique_referrals IS
    'CODE-060 : 1 ligne par parrainage abouti. referee_user_id est UNIQUE (chaque user n''est parrainé qu''une fois).';

CREATE INDEX IF NOT EXISTS idx_cp_referrals_referrer
    ON public.cas_pratique_referrals(referrer_user_id, converted_at DESC);

ALTER TABLE public.cas_pratique_referrals ENABLE ROW LEVEL SECURITY;

-- L'user voit ses propres parrainages (en tant que parrain ou filleul).
DROP POLICY IF EXISTS p_referrals_select_self ON public.cas_pratique_referrals;
CREATE POLICY p_referrals_select_self
    ON public.cas_pratique_referrals
    FOR SELECT TO authenticated
    USING (referrer_user_id = auth.uid() OR referee_user_id = auth.uid());

DROP POLICY IF EXISTS p_referrals_admin_write ON public.cas_pratique_referrals;
CREATE POLICY p_referrals_admin_write
    ON public.cas_pratique_referrals
    FOR ALL TO authenticated
    USING (public.fn_cp_is_admin())
    WITH CHECK (public.fn_cp_is_admin());

-- ─── Helper : génère un code 6 chars alphanum upper unique ────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_generate_referral_code()
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_alphabet text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';  -- 32 chars (sans confusion 0/O/1/I)
    v_code     text;
    v_attempts int := 0;
    v_idx      int;
BEGIN
    LOOP
        v_code := '';
        FOR i IN 1..6 LOOP
            v_idx := 1 + floor(random() * length(v_alphabet))::int;
            v_code := v_code || substr(v_alphabet, v_idx, 1);
        END LOOP;
        -- check unicité
        IF NOT EXISTS (
            SELECT 1 FROM public.cas_pratique_referral_codes WHERE code = v_code
        ) THEN
            RETURN v_code;
        END IF;
        v_attempts := v_attempts + 1;
        IF v_attempts > 20 THEN
            -- improbable mais fail-safe : on rallonge à 8 chars
            v_code := '';
            FOR i IN 1..8 LOOP
                v_idx := 1 + floor(random() * length(v_alphabet))::int;
                v_code := v_code || substr(v_alphabet, v_idx, 1);
            END LOOP;
            RETURN v_code;
        END IF;
    END LOOP;
END;
$func$;

-- ─── Fonction : get or create my referral code ────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_get_or_create_my_referral_code()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_uid       uuid := auth.uid();
    v_code      text;
    v_created   timestamptz;
    v_count     int;
    v_total_xp  int := 0;
BEGIN
    IF v_uid IS NULL THEN
        RETURN jsonb_build_object('error', 'not_authenticated');
    END IF;

    -- Récupère le code existant
    SELECT code, created_at INTO v_code, v_created
      FROM public.cas_pratique_referral_codes
     WHERE user_id = v_uid;

    -- Sinon en génère un
    IF v_code IS NULL THEN
        v_code := public.fn_cp_generate_referral_code();
        INSERT INTO public.cas_pratique_referral_codes (user_id, code)
        VALUES (v_uid, v_code)
        ON CONFLICT (user_id) DO UPDATE SET code = EXCLUDED.code
        RETURNING created_at INTO v_created;
    END IF;

    -- Stats
    SELECT count(*) INTO v_count
      FROM public.cas_pratique_referrals
     WHERE referrer_user_id = v_uid AND status = 'converted';

    SELECT COALESCE(SUM(delta), 0)::int INTO v_total_xp
      FROM public.cas_pratique_xp_ledger
     WHERE user_id = v_uid AND reason = 'referral_bonus';

    RETURN jsonb_build_object(
        'code', v_code,
        'created_at', v_created,
        'referrals_count', v_count,
        'xp_earned_from_referrals', v_total_xp,
        'xp_per_referral', 500
    );
END;
$func$;

GRANT EXECUTE ON FUNCTION public.fn_cp_get_or_create_my_referral_code() TO authenticated;

-- ─── Fonction : redeem (appelée par le filleul après son inscription) ─────

CREATE OR REPLACE FUNCTION public.fn_cp_redeem_referral_code(p_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_referee uuid := auth.uid();
    v_referrer uuid;
    v_normalized_code text;
    v_xp_bonus int := 500;
BEGIN
    IF v_referee IS NULL THEN
        RETURN jsonb_build_object('ok', false, 'error', 'not_authenticated');
    END IF;
    IF p_code IS NULL OR length(trim(p_code)) = 0 THEN
        RETURN jsonb_build_object('ok', false, 'error', 'invalid_code');
    END IF;

    v_normalized_code := upper(trim(p_code));

    -- Cherche le parrain
    SELECT user_id INTO v_referrer
      FROM public.cas_pratique_referral_codes
     WHERE code = v_normalized_code
     LIMIT 1;

    IF v_referrer IS NULL THEN
        RETURN jsonb_build_object('ok', false, 'error', 'code_not_found');
    END IF;

    -- Pas d'auto-parrainage
    IF v_referrer = v_referee THEN
        RETURN jsonb_build_object('ok', false, 'error', 'self_referral');
    END IF;

    -- Pas déjà parrainé
    IF EXISTS (
        SELECT 1 FROM public.cas_pratique_referrals
         WHERE referee_user_id = v_referee
    ) THEN
        RETURN jsonb_build_object('ok', false, 'error', 'already_referred');
    END IF;

    -- Crée le parrainage
    INSERT INTO public.cas_pratique_referrals
        (referrer_user_id, referee_user_id, code_used, status, xp_awarded)
    VALUES
        (v_referrer, v_referee, v_normalized_code, 'converted', v_xp_bonus);

    -- Crédite XP au parrain ET au filleul
    INSERT INTO public.cas_pratique_xp_ledger (user_id, delta, reason, metadata)
    VALUES
        (v_referrer, v_xp_bonus, 'referral_bonus',
         jsonb_build_object('role', 'referrer', 'referee_id', v_referee)),
        (v_referee,  v_xp_bonus, 'referral_bonus',
         jsonb_build_object('role', 'referee', 'referrer_id', v_referrer, 'code', v_normalized_code));

    -- Recompute les badges du parrain (au cas où xp_5000 / xp_1000 se débloque)
    PERFORM public.fn_cp_check_and_unlock_badges(v_referrer);
    PERFORM public.fn_cp_check_and_unlock_badges(v_referee);

    RETURN jsonb_build_object(
        'ok', true,
        'xp_awarded', v_xp_bonus,
        'referrer_id', v_referrer
    );
END;
$func$;

GRANT EXECUTE ON FUNCTION public.fn_cp_redeem_referral_code(text) TO authenticated;

COMMENT ON FUNCTION public.fn_cp_redeem_referral_code(text) IS
    'CODE-060 : à appeler par le filleul après inscription. Crédite +500 XP au parrain et au filleul. Idempotente sur (referee_user_id) UNIQUE.';

COMMIT;
