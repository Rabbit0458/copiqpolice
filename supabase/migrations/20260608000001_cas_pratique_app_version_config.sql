-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Migration CODE-098 : app_minimum_version config               ║
-- ║  Tâche : CODE-098                                                        ║
-- ║                                                                          ║
-- ║  Crée la table `cp_app_version_config` qui pilote le "force update"     ║
-- ║  des clients mobiles Android / iOS.                                      ║
-- ║                                                                          ║
-- ║  L'edge function `app_minimum_version` lit cette table au boot de l'app ║
-- ║  pour déterminer si le client doit mettre à jour.                        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ── Table config ─────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS cp_app_version_config (
  platform        TEXT        NOT NULL
                  CHECK (platform IN ('android', 'ios')),
  min_version     TEXT        NOT NULL DEFAULT '1.0.0',
  latest_version  TEXT        NOT NULL DEFAULT '1.0.0',
  store_url       TEXT        NOT NULL,
  -- Si true, l'écran bloquant est affiché MÊME si force_update est désactivé
  -- (réservé aux breaking changes critiques — ex : faille sécurité).
  force_update    BOOLEAN     NOT NULL DEFAULT FALSE,
  -- Message affiché dans l'écran bloquant (FR).
  message_fr      TEXT        NOT NULL DEFAULT
    'Une nouvelle version de COP''IQ est disponible. Mets à jour l''application pour continuer.',
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT cp_app_version_config_pkey PRIMARY KEY (platform)
);

-- Trigger pour updated_at automatique
CREATE OR REPLACE FUNCTION fn_cp_update_version_config_ts()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_cp_version_config_updated_at ON cp_app_version_config;
CREATE TRIGGER trg_cp_version_config_updated_at
  BEFORE UPDATE ON cp_app_version_config
  FOR EACH ROW EXECUTE FUNCTION fn_cp_update_version_config_ts();

-- ── RLS ───────────────────────────────────────────────────────────────────────
-- Lecture publique (l'app appelle cet endpoint sans auth)
ALTER TABLE cp_app_version_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "cp_version_config_public_read" ON cp_app_version_config;
CREATE POLICY "cp_version_config_public_read"
  ON cp_app_version_config FOR SELECT
  TO anon, authenticated
  USING (TRUE);

-- Écriture uniquement service_role (admin panel ou Supabase Dashboard)
-- Pas de policy INSERT/UPDATE/DELETE pour anon/authenticated.

-- ── Seeds ─────────────────────────────────────────────────────────────────────

INSERT INTO cp_app_version_config (platform, min_version, latest_version, store_url, force_update)
VALUES
  (
    'android',
    '1.0.0',
    '1.0.0',
    'https://play.google.com/store/apps/details?id=fr.copiq.app',
    FALSE
  ),
  (
    'ios',
    '1.0.0',
    '1.0.0',
    'https://apps.apple.com/app/copiq/id000000000',
    FALSE
  )
ON CONFLICT (platform) DO NOTHING;

-- ── Commentaires ──────────────────────────────────────────────────────────────
COMMENT ON TABLE cp_app_version_config IS
  'Pilote le "force update" des clients mobiles. '
  'Modifier min_version > version actuelle pour forcer la mise à jour. '
  'Passer force_update = TRUE pour un écran bloquant immédiat (breaking change). '
  'Modifiable directement dans le Dashboard Supabase → Table Editor sans redéploiement.';

COMMENT ON COLUMN cp_app_version_config.min_version IS
  'Version minimale acceptée (format semver X.Y.Z). '
  'Si la version de l''app < min_version → écran bloquant affiché.';

COMMENT ON COLUMN cp_app_version_config.force_update IS
  'Override immédiat : si TRUE, l''écran bloquant est TOUJOURS affiché '
  'indépendamment de la comparaison de version. '
  'Réserver aux situations critiques (faille sécurité, breaking API).';
