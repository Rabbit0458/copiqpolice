-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — RGPD : Export & Suppression données            ║
-- ║  Tâche : CODE-079                                                        ║
-- ║  RGPD articles 17 (droit à l'effacement) & 20 (portabilité)             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ---------------------------------------------------------------------------
-- 1. TABLE : tokens de suppression (2-step confirmation via code 6 chiffres)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cas_pratique_deletion_tokens (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  token_hash     TEXT        NOT NULL,           -- SHA-256 du code 6 chiffres
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at     TIMESTAMPTZ NOT NULL DEFAULT now() + INTERVAL '15 minutes',
  used_at        TIMESTAMPTZ,
  CONSTRAINT uq_deletion_token_user UNIQUE (user_id)  -- 1 token actif par user
);

-- Index TTL pour le cleanup automatique
CREATE INDEX IF NOT EXISTS idx_deletion_tokens_expires
  ON cas_pratique_deletion_tokens (expires_at)
  WHERE used_at IS NULL;

-- RLS : le user ne peut pas lire ses propres tokens (évite brute-force via API)
ALTER TABLE cas_pratique_deletion_tokens ENABLE ROW LEVEL SECURITY;

-- Seule la fonction SECURITY DEFINER peut écrire/lire ces tokens
REVOKE ALL ON cas_pratique_deletion_tokens FROM authenticated, anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON cas_pratique_deletion_tokens
  TO service_role;

-- ---------------------------------------------------------------------------
-- 2. FONCTION : fn_cp_export_user_data(p_user_id) → jsonb
-- ---------------------------------------------------------------------------
-- Retourne TOUTES les données personnelles du user dans un JSON structuré.
-- RGPD Art. 20 : portabilité des données.
-- Appelée UNIQUEMENT depuis la edge function (service_role).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cp_export_user_data(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_result JSONB;
BEGIN
  SELECT jsonb_build_object(
    'export_date',    now(),
    'user_id',        p_user_id::text,
    'rgpd_article',   'Art. 20 — Droit à la portabilité des données',

    -- Tentatives
    'attempts', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'id',            a.id,
        'case_id',       a.case_id,
        'status',        a.status,
        'total_score',   a.total_score,
        'total_max',     a.total_max,
        'started_at',    a.started_at,
        'finished_at',   a.finished_at,
        'time_spent_ms', a.time_spent_ms
      ) ORDER BY a.started_at DESC), '[]'::jsonb)
      FROM cas_pratique_attempts a
      WHERE a.user_id = p_user_id
    ),

    -- Réponses (textes saisis par le user)
    'answers', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'attempt_id',   ans.attempt_id,
        'question_id',  ans.question_id,
        'answer_text',  ans.answer_text,
        'status',       ans.status,
        'char_count',   ans.char_count,
        'saved_at',     ans.saved_at
      ) ORDER BY ans.saved_at DESC), '[]'::jsonb)
      FROM cas_pratique_answers ans
      JOIN cas_pratique_attempts a2 ON a2.id = ans.attempt_id
      WHERE a2.user_id = p_user_id
    ),

    -- Corrections reçues
    'corrections', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'id',             c.id,
        'attempt_id',     c.attempt_id,
        'total_score',    c.total_score,
        'total_max',      c.total_max,
        'percent',        c.percent,
        'engine_version', c.engine_version,
        'corrected_at',   c.corrected_at
      ) ORDER BY c.corrected_at DESC), '[]'::jsonb)
      FROM cas_pratique_corrections c
      JOIN cas_pratique_attempts a3 ON a3.id = c.attempt_id
      WHERE a3.user_id = p_user_id
    ),

    -- Appels soumis
    'appeals', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'id',             ap.id,
        'message',        ap.message,
        'status',         ap.status,
        'admin_response', ap.admin_response,
        'created_at',     ap.created_at,
        'resolved_at',    ap.resolved_at
      ) ORDER BY ap.created_at DESC), '[]'::jsonb)
      FROM cas_pratique_appeals ap
      WHERE ap.user_id = p_user_id
    ),

    -- Progression globale
    'user_progress', (
      SELECT row_to_json(p)::jsonb
      FROM cas_pratique_user_progress p
      WHERE p.user_id = p_user_id
      LIMIT 1
    ),

    -- XP Ledger
    'xp_ledger', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'delta',        x.delta,
        'reason',       x.reason,
        'created_at',   x.created_at
      ) ORDER BY x.created_at DESC), '[]'::jsonb)
      FROM cas_pratique_xp_ledger x
      WHERE x.user_id = p_user_id
    ),

    -- Badges débloqués
    'badges', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'badge_slug',   ub.badge_slug,
        'unlocked_at',  ub.unlocked_at
      ) ORDER BY ub.unlocked_at DESC), '[]'::jsonb)
      FROM cas_pratique_user_badges ub
      WHERE ub.user_id = p_user_id
    ),

    -- Code de parrainage
    'referral_code', (
      SELECT rc.code
      FROM cas_pratique_referral_codes rc
      WHERE rc.user_id = p_user_id
      LIMIT 1
    ),

    -- Parrainages
    'referrals', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'code_used',  r.code_used,
        'status',     r.status,
        'xp_awarded', r.xp_awarded,
        'created_at', r.created_at
      ) ORDER BY r.created_at DESC), '[]'::jsonb)
      FROM cas_pratique_referrals r
      WHERE r.referrer_user_id = p_user_id OR r.referee_user_id = p_user_id
    )
  ) INTO v_result;

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION fn_cp_export_user_data(UUID) TO service_role;
REVOKE EXECUTE ON FUNCTION fn_cp_export_user_data(UUID) FROM authenticated, anon;

-- ---------------------------------------------------------------------------
-- 3. FONCTION : fn_cp_request_deletion_token(p_user_id) → text
-- ---------------------------------------------------------------------------
-- Génère un token de suppression à 6 chiffres, le stocke hashé (SHA-256),
-- retourne le code en clair pour que l'edge function l'envoie par email.
-- Valide 15 minutes, 1 seul token actif par user (upsert).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cp_request_deletion_token(p_user_id UUID)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_code   TEXT;
  v_hash   TEXT;
BEGIN
  -- Code 6 chiffres (pad à gauche avec des zéros)
  v_code := LPAD(FLOOR(random() * 1000000)::TEXT, 6, '0');
  v_hash := encode(sha256(v_code::bytea), 'hex');

  INSERT INTO cas_pratique_deletion_tokens (user_id, token_hash, expires_at)
  VALUES (p_user_id, v_hash, now() + INTERVAL '15 minutes')
  ON CONFLICT (user_id)
  DO UPDATE SET
    token_hash  = EXCLUDED.token_hash,
    created_at  = now(),
    expires_at  = EXCLUDED.expires_at,
    used_at     = NULL;

  RETURN v_code;
END;
$$;

GRANT EXECUTE ON FUNCTION fn_cp_request_deletion_token(UUID) TO service_role;
REVOKE EXECUTE ON FUNCTION fn_cp_request_deletion_token(UUID) FROM authenticated, anon;

-- ---------------------------------------------------------------------------
-- 4. FONCTION : fn_cp_delete_user_data(p_user_id, p_code) → jsonb
-- ---------------------------------------------------------------------------
-- Vérifie le token, cascade-supprime toutes les données CP du user,
-- supprime le compte Auth, marque le token utilisé.
-- RGPD Art. 17 : droit à l'effacement.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cp_delete_user_data(p_user_id UUID, p_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_hash       TEXT;
  v_token_row  cas_pratique_deletion_tokens;
  v_counts     JSONB;
  v_attempts   INT;
  v_answers    INT;
  v_corrections INT;
  v_appeals    INT;
BEGIN
  v_hash := encode(sha256(p_code::bytea), 'hex');

  -- Vérifier le token
  SELECT * INTO v_token_row
  FROM cas_pratique_deletion_tokens
  WHERE user_id = p_user_id
    AND token_hash = v_hash
    AND used_at IS NULL
    AND expires_at > now();

  IF NOT FOUND THEN
    RAISE EXCEPTION 'invalid_or_expired_token'
      USING HINT = 'Le code de confirmation est invalide ou expiré.';
  END IF;

  -- Marquer le token utilisé immédiatement (idempotent)
  UPDATE cas_pratique_deletion_tokens
  SET used_at = now()
  WHERE id = v_token_row.id;

  -- Compter avant suppression (pour le rapport)
  SELECT COUNT(*) INTO v_attempts   FROM cas_pratique_attempts  WHERE user_id = p_user_id;
  SELECT COUNT(*) INTO v_corrections
    FROM cas_pratique_corrections c
    JOIN cas_pratique_attempts a ON a.id = c.attempt_id
    WHERE a.user_id = p_user_id;
  SELECT COUNT(*) INTO v_answers
    FROM cas_pratique_answers ans
    JOIN cas_pratique_attempts a2 ON a2.id = ans.attempt_id
    WHERE a2.user_id = p_user_id;
  SELECT COUNT(*) INTO v_appeals FROM cas_pratique_appeals WHERE user_id = p_user_id;

  -- ── Cascade suppression des données CP ───────────────────────────────────
  -- L'ordre respecte les FK (les tables filles d'abord)

  -- Détails corrections (FK → corrections)
  DELETE FROM cas_pratique_correction_details cd
  USING cas_pratique_corrections c
  JOIN  cas_pratique_attempts a ON a.id = c.attempt_id
  WHERE cd.correction_id = c.id AND a.user_id = p_user_id;

  -- Appels (FK → correction_details ou user direct)
  DELETE FROM cas_pratique_appeals WHERE user_id = p_user_id;

  -- Corrections
  DELETE FROM cas_pratique_corrections c
  USING cas_pratique_attempts a
  WHERE c.attempt_id = a.id AND a.user_id = p_user_id;

  -- Réponses
  DELETE FROM cas_pratique_answers ans
  USING cas_pratique_attempts a2
  WHERE ans.attempt_id = a2.id AND a2.user_id = p_user_id;

  -- Tentatives
  DELETE FROM cas_pratique_attempts WHERE user_id = p_user_id;

  -- Progression
  DELETE FROM cas_pratique_user_progress WHERE user_id = p_user_id;
  DELETE FROM cas_pratique_user_case_progress WHERE user_id = p_user_id;

  -- Gamification
  DELETE FROM cas_pratique_user_badges   WHERE user_id = p_user_id;
  DELETE FROM cas_pratique_xp_ledger     WHERE user_id = p_user_id;
  DELETE FROM cas_pratique_streak_freezes WHERE user_id = p_user_id;
  DELETE FROM cas_pratique_referrals
    WHERE referrer_user_id = p_user_id OR referee_user_id = p_user_id;
  DELETE FROM cas_pratique_referral_codes WHERE user_id = p_user_id;
  DELETE FROM cas_pratique_rate_buckets   WHERE user_id = p_user_id;

  -- Token de suppression lui-même
  DELETE FROM cas_pratique_deletion_tokens WHERE user_id = p_user_id;

  -- ── Suppression du compte Auth via admin API ──────────────────────────────
  -- La edge function doit appeler auth.admin.deleteUser(userId) APRÈS.
  -- On n'a pas accès à auth.admin depuis SQL ; l'edge function le fait.

  v_counts := jsonb_build_object(
    'attempts_deleted',     v_attempts,
    'answers_deleted',      v_answers,
    'corrections_deleted',  v_corrections,
    'appeals_deleted',      v_appeals,
    'deleted_at',           now()
  );

  RETURN v_counts;
END;
$$;

GRANT EXECUTE ON FUNCTION fn_cp_delete_user_data(UUID, TEXT) TO service_role;
REVOKE EXECUTE ON FUNCTION fn_cp_delete_user_data(UUID, TEXT) FROM authenticated, anon;

-- ---------------------------------------------------------------------------
-- 5. Cleanup automatique des tokens expirés (pg_cron snippet — à activer)
-- ---------------------------------------------------------------------------
-- SELECT cron.schedule(
--   'cp_cleanup_deletion_tokens',
--   '*/30 * * * *',
--   $$DELETE FROM cas_pratique_deletion_tokens
--     WHERE expires_at < now() AND used_at IS NULL$$
-- );

COMMENT ON TABLE  cas_pratique_deletion_tokens               IS 'RGPD CODE-079 — tokens de suppression de compte (SHA-256, TTL 15 min)';
COMMENT ON FUNCTION fn_cp_export_user_data(UUID)             IS 'RGPD Art.20 — export toutes données CP du user en JSONB';
COMMENT ON FUNCTION fn_cp_request_deletion_token(UUID)       IS 'RGPD Art.17 step-1 — génère code 6 chiffres stocké hashé';
COMMENT ON FUNCTION fn_cp_delete_user_data(UUID, TEXT)       IS 'RGPD Art.17 step-2 — vérifie code, cascade-delete données CP';
