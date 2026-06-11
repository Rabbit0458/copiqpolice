-- =============================================================================
-- Migration : 20260606100000_cp_user_notification_prefs.sql
-- Préférences de notifications push Cas Pratique (granulaires + quiet hours).
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Table : cp_user_notification_prefs
-- Stocke les préférences par utilisateur.
-- Une seule ligne par user_id (upsert).
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS cp_user_notification_prefs (
  id                     UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Opt-in par topic (true = abonné)
  topic_new_case         BOOLEAN     NOT NULL DEFAULT true,
  topic_streak_risk      BOOLEAN     NOT NULL DEFAULT true,
  topic_appeal_result    BOOLEAN     NOT NULL DEFAULT true,
  topic_leaderboard      BOOLEAN     NOT NULL DEFAULT false,

  -- Heures silencieuses : de quiet_start_hour à quiet_end_hour (UTC)
  quiet_start_hour       SMALLINT    NOT NULL DEFAULT 22   CHECK (quiet_start_hour BETWEEN 0 AND 23),
  quiet_end_hour         SMALLINT    NOT NULL DEFAULT 8    CHECK (quiet_end_hour BETWEEN 0 AND 23),
  -- Timezone IANA du user (ex. 'Europe/Paris') pour convertir quiet hours
  user_timezone          TEXT        NOT NULL DEFAULT 'Europe/Paris',

  -- FCM token actif du device (mis à jour par le client)
  fcm_token              TEXT,

  created_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at             TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index unique pour upsert efficace
CREATE UNIQUE INDEX IF NOT EXISTS cp_user_notification_prefs_user_id_idx
  ON cp_user_notification_prefs (user_id);

-- Trigger updated_at
CREATE OR REPLACE FUNCTION fn_cp_notif_prefs_set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_cp_notif_prefs_updated_at ON cp_user_notification_prefs;
CREATE TRIGGER trg_cp_notif_prefs_updated_at
  BEFORE UPDATE ON cp_user_notification_prefs
  FOR EACH ROW EXECUTE FUNCTION fn_cp_notif_prefs_set_updated_at();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

ALTER TABLE cp_user_notification_prefs ENABLE ROW LEVEL SECURITY;

-- Lecture : propriétaire uniquement
CREATE POLICY cp_notif_prefs_select
  ON cp_user_notification_prefs FOR SELECT
  USING (auth.uid() = user_id);

-- Insertion : propriétaire uniquement
CREATE POLICY cp_notif_prefs_insert
  ON cp_user_notification_prefs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Mise à jour : propriétaire uniquement
CREATE POLICY cp_notif_prefs_update
  ON cp_user_notification_prefs FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Suppression : propriétaire uniquement
CREATE POLICY cp_notif_prefs_delete
  ON cp_user_notification_prefs FOR DELETE
  USING (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- Vue utilitaire pour l'admin (service_role uniquement — pas de RLS)
-- Permet au backend de récupérer les tokens FCM et prefs pour l'envoi push.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE VIEW cp_admin_notification_targets AS
SELECT
  p.user_id,
  p.fcm_token,
  p.topic_new_case,
  p.topic_streak_risk,
  p.topic_appeal_result,
  p.topic_leaderboard,
  p.quiet_start_hour,
  p.quiet_end_hour,
  p.user_timezone,
  p.updated_at
FROM cp_user_notification_prefs p
WHERE p.fcm_token IS NOT NULL;

-- Accès service_role uniquement (pas de grant public)
REVOKE ALL ON cp_admin_notification_targets FROM PUBLIC;

-- ---------------------------------------------------------------------------
-- Commentaires
-- ---------------------------------------------------------------------------

COMMENT ON TABLE cp_user_notification_prefs IS
  'Préférences push granulaires + quiet hours par utilisateur (Cas Pratique).';
COMMENT ON COLUMN cp_user_notification_prefs.topic_new_case IS
  'Recevoir une notif quand un nouveau cas pratique est publié.';
COMMENT ON COLUMN cp_user_notification_prefs.topic_streak_risk IS
  'Recevoir une alerte quand la streak est en danger (< 2h restantes).';
COMMENT ON COLUMN cp_user_notification_prefs.topic_appeal_result IS
  'Recevoir une notif quand un appel est traité (approuvé ou rejeté).';
COMMENT ON COLUMN cp_user_notification_prefs.topic_leaderboard IS
  'Recevoir le classement hebdomadaire chaque lundi.';
COMMENT ON COLUMN cp_user_notification_prefs.quiet_start_hour IS
  'Début de la plage silencieuse (heure locale user, 0-23). Default 22h.';
COMMENT ON COLUMN cp_user_notification_prefs.quiet_end_hour IS
  'Fin de la plage silencieuse (heure locale user, 0-23). Default 8h.';
