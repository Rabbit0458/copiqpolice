-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 010 : rate limiting (token bucket)  ║
-- ║  Tâche      : CODE-054                                                  ║
-- ║                                                                         ║
-- ║  Table `cas_pratique_rate_buckets` + fonction atomique                  ║
-- ║  `fn_cp_consume_token(scope, capacity, refill_per_window, window_s)`   ║
-- ║  qui implémente l'algorithme token bucket :                             ║
-- ║                                                                         ║
-- ║    elapsed   = now() - last_refill_at                                   ║
-- ║    refilled  = min(capacity, tokens + elapsed * refill_rate)            ║
-- ║    if refilled ≥ 1 → consume 1, return allowed=true                     ║
-- ║    else              → return allowed=false + retry_after_seconds       ║
-- ║                                                                         ║
-- ║  Rates par défaut (à respecter côté caller) :                           ║
-- ║    cp.list_cases       — 60   / min                                     ║
-- ║    cp.save_draft       — 600  / min                                     ║
-- ║    cp.validate_answer  — 30   / min                                     ║
-- ║    cp.finish_correct   — 10   / min                                     ║
-- ║    cp.create_appeal    — 20   / jour                                    ║
-- ║                                                                         ║
-- ║  La fonction est SECURITY DEFINER et lit `auth.uid()` pour identifier  ║
-- ║  l'appelant. RLS de la table : aucun accès direct user → seule la      ║
-- ║  fonction y touche.                                                     ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

CREATE TABLE IF NOT EXISTS public.cas_pratique_rate_buckets (
    user_id        uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    scope          text        NOT NULL,
    tokens         numeric     NOT NULL DEFAULT 0,
    capacity       integer     NOT NULL DEFAULT 60,
    last_refill_at timestamptz NOT NULL DEFAULT now(),
    created_at     timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, scope)
);

COMMENT ON TABLE public.cas_pratique_rate_buckets IS
    'CODE-054 : token bucket par (user_id, scope) pour le rate limiting des endpoints critiques.';

CREATE INDEX IF NOT EXISTS idx_cp_rate_buckets_user
    ON public.cas_pratique_rate_buckets(user_id);

-- RLS : aucun user ne lit / écrit directement. Seule la fonction
-- `fn_cp_consume_token` (SECURITY DEFINER) y accède.
ALTER TABLE public.cas_pratique_rate_buckets ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_rate_buckets_no_direct ON public.cas_pratique_rate_buckets;
CREATE POLICY p_rate_buckets_no_direct
    ON public.cas_pratique_rate_buckets
    FOR ALL
    TO authenticated
    USING (false)
    WITH CHECK (false);

-- ─── Fonction atomique de consommation ─────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_consume_token(
    p_scope             text,
    p_capacity          integer,
    p_refill_per_window integer,
    p_window_seconds    integer
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_user_id       uuid := auth.uid();
    v_refill_rate   numeric;
    v_now           timestamptz := now();
    v_elapsed       numeric;
    v_refilled      numeric;
    v_wait_seconds  numeric;
    v_bucket        record;
BEGIN
    IF v_user_id IS NULL THEN
        RETURN jsonb_build_object('allowed', false, 'error', 'not_authenticated');
    END IF;

    IF p_window_seconds IS NULL OR p_window_seconds <= 0
       OR p_capacity IS NULL OR p_capacity <= 0
       OR p_refill_per_window IS NULL OR p_refill_per_window <= 0 THEN
        RETURN jsonb_build_object('allowed', false, 'error', 'invalid_input');
    END IF;

    v_refill_rate := p_refill_per_window::numeric / p_window_seconds::numeric;

    -- Upsert défensif : crée le bucket plein la 1re fois.
    INSERT INTO public.cas_pratique_rate_buckets
        (user_id, scope, tokens, capacity, last_refill_at)
    VALUES
        (v_user_id, p_scope, p_capacity::numeric, p_capacity, v_now)
    ON CONFLICT (user_id, scope) DO NOTHING;

    -- Verrouille la ligne pour éviter les races.
    SELECT *
      INTO v_bucket
      FROM public.cas_pratique_rate_buckets
     WHERE user_id = v_user_id AND scope = p_scope
       FOR UPDATE;

    v_elapsed := EXTRACT(EPOCH FROM (v_now - v_bucket.last_refill_at));
    v_refilled := least(
        p_capacity::numeric,
        v_bucket.tokens + v_elapsed * v_refill_rate
    );

    IF v_refilled >= 1.0 THEN
        UPDATE public.cas_pratique_rate_buckets
           SET tokens = v_refilled - 1.0,
               capacity = p_capacity,
               last_refill_at = v_now
         WHERE user_id = v_user_id AND scope = p_scope;
        RETURN jsonb_build_object(
            'allowed', true,
            'tokens_remaining', round(v_refilled - 1.0, 2),
            'capacity', p_capacity
        );
    ELSE
        -- Pas assez de tokens : on calcule combien de secondes attendre pour
        -- atteindre 1 token. On NE consomme PAS, mais on met à jour
        -- last_refill_at pour le prochain calcul correct.
        v_wait_seconds := ceil((1.0 - v_refilled) / v_refill_rate);
        UPDATE public.cas_pratique_rate_buckets
           SET tokens = v_refilled,
               capacity = p_capacity,
               last_refill_at = v_now
         WHERE user_id = v_user_id AND scope = p_scope;
        RETURN jsonb_build_object(
            'allowed', false,
            'retry_after_seconds', v_wait_seconds,
            'capacity', p_capacity
        );
    END IF;
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_consume_token(text, int, int, int) IS
    'CODE-054 : tente de consommer 1 token du bucket (auth.uid(), p_scope). Renvoie un JSON {allowed, tokens_remaining|retry_after_seconds, capacity}. Idempotente sur la création du bucket.';

-- Grant : tout user authentifié peut appeler.
GRANT EXECUTE ON FUNCTION public.fn_cp_consume_token(text, int, int, int)
    TO authenticated;

COMMIT;
