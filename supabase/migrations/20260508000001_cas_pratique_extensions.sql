-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Cas Pratique — Migration 001 : Extensions
--  Référence : docs/cas_pratique/03_SCHEMA.sql (section 1)
--  Tâche      : CODE-001
-- ════════════════════════════════════════════════════════════════════════════

CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- recherche full-text trigram
CREATE EXTENSION IF NOT EXISTS "unaccent";   -- normalisation accents côté DB
