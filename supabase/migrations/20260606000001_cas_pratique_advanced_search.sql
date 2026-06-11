-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Recherche full-text avancée                   ║
-- ║  Migration : 20260606000001_cas_pratique_advanced_search.sql           ║
-- ║  Tâche     : CODE-092                                                  ║
-- ║                                                                         ║
-- ║  Ajoute :                                                               ║
-- ║    1. Colonnes tsvector pré-calculées sur cases + questions             ║
-- ║    2. Indexes GIN pour FTS FR (unaccent + simple)                       ║
-- ║    3. Index trigram supplémentaire sur keywords                         ║
-- ║    4. Vue cp_cases_search_index (dénormalisée, FTS sur 4 champs)        ║
-- ║    5. RPC cp_search_cases_fts   — recherche avancée avec filtres        ║
-- ║    6. RPC cp_search_autocomplete — suggestions titre                    ║
-- ╚════════════════════════════════════════════════════════════════════════╝

-- ─── 0. Extensions (idempotentes) ────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Dictionnaire "french_unaccent" : unaccent + stopwords FR
-- (crée si absent ; ignore si existe déjà)
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_ts_config WHERE cfgname = 'french_unaccent'
  ) THEN
    CREATE TEXT SEARCH CONFIGURATION french_unaccent ( COPY = french );
    ALTER TEXT SEARCH CONFIGURATION french_unaccent
      ALTER MAPPING FOR hword, hword_part, word
      WITH unaccent, french_stem;
  END IF;
END $$;

-- ─── 1. Colonnes tsvector pré-calculées ──────────────────────────────────────

-- 1a. Table cas_pratique_cases — colonne search_vector
ALTER TABLE cas_pratique_cases
  ADD COLUMN IF NOT EXISTS search_vector tsvector;

-- Peupler le vecteur (pondération : titre A, situation B, keywords C)
UPDATE cas_pratique_cases
SET search_vector =
  setweight(to_tsvector('french_unaccent', coalesce(title, '')), 'A') ||
  setweight(to_tsvector('french_unaccent', coalesce(situation_text, '')), 'B')
WHERE search_vector IS NULL;

-- 1b. Trigger de mise à jour automatique sur cas_pratique_cases
CREATE OR REPLACE FUNCTION fn_cp_update_case_search_vector()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.search_vector :=
    setweight(to_tsvector('french_unaccent', coalesce(NEW.title, '')), 'A') ||
    setweight(to_tsvector('french_unaccent', coalesce(NEW.situation_text, '')), 'B');
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_cp_case_search_vector ON cas_pratique_cases;
CREATE TRIGGER trg_cp_case_search_vector
  BEFORE INSERT OR UPDATE OF title, situation_text
  ON cas_pratique_cases
  FOR EACH ROW EXECUTE FUNCTION fn_cp_update_case_search_vector();

-- ─── 2. Indexes GIN (FTS) + trigram ──────────────────────────────────────────

-- GIN sur search_vector des cas
CREATE INDEX IF NOT EXISTS idx_cp_cases_search_vector
  ON cas_pratique_cases USING GIN (search_vector);

-- GIN trigram sur le titre (pour auto-complete rapide)
CREATE INDEX IF NOT EXISTS idx_cp_cases_title_trgm
  ON cas_pratique_cases USING GIN (title gin_trgm_ops);

-- GIN trigram sur situation_text
CREATE INDEX IF NOT EXISTS idx_cp_cases_situation_trgm
  ON cas_pratique_cases USING GIN (situation_text gin_trgm_ops);

-- GIN trigram sur la valeur des keywords (recherche mots-clés)
CREATE INDEX IF NOT EXISTS idx_cp_keywords_value_trgm
  ON cas_pratique_keywords USING GIN (value gin_trgm_ops);

-- GIN trigram sur le texte des questions
CREATE INDEX IF NOT EXISTS idx_cp_questions_text_trgm
  ON cas_pratique_questions USING GIN (question_text gin_trgm_ops);

-- ─── 3. Vue dénormalisée pour FTS multi-champs ───────────────────────────────

-- Vue qui agrège : titre cas + situation + texte des questions + valeurs keywords
-- Scoped RLS : uniquement les cas publiés.
CREATE OR REPLACE VIEW cp_cases_search_index AS
SELECT
  c.id                                          AS case_id,
  c.slug,
  c.title,
  c.year,
  c.difficulty,
  c.theme_id,
  c.is_free,
  c.status,
  -- Vecteur composite : title A | situation B | questions C | keywords D
  (
    setweight(to_tsvector('french_unaccent', coalesce(c.title, '')), 'A') ||
    setweight(to_tsvector('french_unaccent', coalesce(c.situation_text, '')), 'B') ||
    setweight(
      to_tsvector('french_unaccent',
        coalesce(string_agg(DISTINCT q.question_text, ' '), '')),
      'C'
    ) ||
    setweight(
      to_tsvector('french_unaccent',
        coalesce(string_agg(DISTINCT k.value, ' '), '')),
      'D'
    )
  ) AS full_vector,
  -- Texte brut concaténé pour ILIKE / trigram fallback
  (
    coalesce(c.title, '') || ' ' ||
    coalesce(c.situation_text, '') || ' ' ||
    coalesce(string_agg(DISTINCT q.question_text, ' '), '') || ' ' ||
    coalesce(string_agg(DISTINCT k.value, ' '), '')
  ) AS full_text
FROM cas_pratique_cases c
LEFT JOIN cas_pratique_questions  q  ON q.case_id = c.id
LEFT JOIN cas_pratique_rubric_points rp ON rp.case_id = c.id
LEFT JOIN cas_pratique_keyword_groups kg ON kg.rubric_point_id = rp.id
LEFT JOIN cas_pratique_keywords k ON k.group_id = kg.id
WHERE c.status = 'published'
GROUP BY c.id, c.slug, c.title, c.year, c.difficulty, c.theme_id,
         c.is_free, c.status, c.situation_text;

-- Accès lecture à tous les utilisateurs (RLS sur la table de base protège déjà)
GRANT SELECT ON cp_cases_search_index TO anon, authenticated;

-- ─── 4. RPC cp_search_cases_fts — recherche avancée avec filtres ─────────────
--
-- Paramètres :
--   p_query         text      — termes de recherche (vide = pas de filtre texte)
--   p_limit         int       — résultats max (défaut 50)
--   p_offset        int       — pagination (défaut 0)
--   p_theme_ids     uuid[]    — filtrer sur des theme_id (null = tous)
--   p_years         int[]     — filtrer par année (null = toutes)
--   p_difficulties  text[]    — filtrer par difficulté (null = toutes)
--   p_not_done_uid  uuid      — exclure les cas où user a un attempt final (null = ne pas filtrer)
--
-- Retourne colonnes compatibles avec CaseSummary Flutter
CREATE OR REPLACE FUNCTION cp_search_cases_fts(
  p_query        text    DEFAULT '',
  p_limit        int     DEFAULT 50,
  p_offset       int     DEFAULT 0,
  p_theme_ids    uuid[]  DEFAULT NULL,
  p_years        int[]   DEFAULT NULL,
  p_difficulties text[]  DEFAULT NULL,
  p_not_done_uid uuid    DEFAULT NULL
)
RETURNS TABLE (
  id                  uuid,
  slug                text,
  title               text,
  year                int,
  month               int,
  difficulty          text,
  total_points        int,
  estimated_minutes   int,
  published_at        timestamptz,
  status              text,
  is_free             boolean,
  theme_id            uuid,
  rank                real
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
  v_tsquery  tsquery;
  v_norm     text;
BEGIN
  -- Normaliser la requête (trim, lower, unaccent)
  v_norm := lower(trim(unaccent(p_query)));

  -- Construire tsquery si non vide (supporte multi-mots avec AND implicite)
  IF v_norm <> '' THEN
    BEGIN
      v_tsquery := plainto_tsquery('french_unaccent', v_norm);
    EXCEPTION WHEN OTHERS THEN
      v_tsquery := NULL;
    END;
  END IF;

  RETURN QUERY
  WITH base AS (
    SELECT
      c.id,
      c.slug,
      c.title,
      c.year,
      c.month,
      c.difficulty,
      c.total_points,
      c.estimated_minutes,
      c.published_at,
      c.status,
      c.is_free,
      c.theme_id,
      -- Score de pertinence FTS (0 si pas de requête)
      CASE
        WHEN v_tsquery IS NOT NULL THEN
          ts_rank_cd(
            (
              setweight(to_tsvector('french_unaccent', coalesce(c.title, '')), 'A') ||
              setweight(to_tsvector('french_unaccent', coalesce(c.situation_text, '')), 'B')
            ),
            v_tsquery,
            32  -- normalise par longueur doc
          )
        ELSE
          -- Fallback trigram similarity sur le titre
          CASE WHEN v_norm <> '' THEN similarity(lower(c.title), v_norm) ELSE 1.0 END
      END AS _rank
    FROM cas_pratique_cases c
    WHERE
      c.status = 'published'
      -- Filtre texte : FTS ou trigram ou aucun filtre
      AND (
        v_norm = ''
        OR (
          v_tsquery IS NOT NULL
          AND (
            (to_tsvector('french_unaccent', coalesce(c.title, '')) @@ v_tsquery)
            OR (to_tsvector('french_unaccent', coalesce(c.situation_text, '')) @@ v_tsquery)
            -- Recherche dans questions via sous-requête
            OR EXISTS (
              SELECT 1 FROM cas_pratique_questions q2
              WHERE q2.case_id = c.id
                AND to_tsvector('french_unaccent', coalesce(q2.question_text, '')) @@ v_tsquery
            )
            -- Recherche dans keywords via sous-requête
            OR EXISTS (
              SELECT 1
              FROM cas_pratique_rubric_points rp2
              JOIN cas_pratique_keyword_groups kg2 ON kg2.rubric_point_id = rp2.id
              JOIN cas_pratique_keywords k2        ON k2.group_id = kg2.id
              WHERE rp2.case_id = c.id
                AND to_tsvector('french_unaccent', coalesce(k2.value, '')) @@ v_tsquery
            )
          )
        )
        -- Fallback trigram si tsquery a échoué
        OR (v_tsquery IS NULL AND v_norm <> '' AND (
          c.title ILIKE '%' || v_norm || '%'
          OR c.situation_text ILIKE '%' || v_norm || '%'
        ))
      )
      -- Filtre thèmes
      AND (p_theme_ids IS NULL OR c.theme_id = ANY(p_theme_ids))
      -- Filtre années
      AND (p_years IS NULL OR c.year = ANY(p_years))
      -- Filtre difficultés
      AND (p_difficulties IS NULL OR c.difficulty = ANY(p_difficulties))
      -- Filtre "non fait" : exclure cas avec attempt de statut 'completed'
      AND (
        p_not_done_uid IS NULL
        OR NOT EXISTS (
          SELECT 1 FROM cas_pratique_attempts a
          WHERE a.case_id = c.id
            AND a.user_id = p_not_done_uid
            AND a.status = 'completed'
        )
      )
  )
  SELECT
    b.id, b.slug, b.title, b.year, b.month, b.difficulty,
    b.total_points, b.estimated_minutes, b.published_at,
    b.status, b.is_free, b.theme_id,
    b._rank::real AS rank
  FROM base b
  ORDER BY
    CASE WHEN v_norm <> '' THEN b._rank ELSE 0 END DESC,
    b.published_at DESC NULLS LAST
  LIMIT p_limit
  OFFSET p_offset;
END;
$$;

-- Accès à tous les utilisateurs (auth + anon)
GRANT EXECUTE ON FUNCTION cp_search_cases_fts(text, int, int, uuid[], int[], text[], uuid)
  TO anon, authenticated;

-- ─── 5. RPC cp_search_autocomplete — suggestions de titre ────────────────────
--
-- Retourne les titres (+ slug) dont le titre est similaire à p_query.
-- Utilisé pour le dropdown d'auto-complete côté Flutter.
CREATE OR REPLACE FUNCTION cp_search_autocomplete(
  p_query text,
  p_limit int DEFAULT 8
)
RETURNS TABLE (slug text, title text, year int, similarity_score real)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
  v_norm text;
BEGIN
  v_norm := lower(trim(unaccent(p_query)));
  IF length(v_norm) < 2 THEN
    RETURN;
  END IF;

  RETURN QUERY
  SELECT
    c.slug,
    c.title,
    c.year,
    similarity(lower(unaccent(c.title)), v_norm)::real AS similarity_score
  FROM cas_pratique_cases c
  WHERE
    c.status = 'published'
    AND (
      lower(unaccent(c.title)) ILIKE '%' || v_norm || '%'
      OR similarity(lower(unaccent(c.title)), v_norm) > 0.15
    )
  ORDER BY similarity_score DESC, c.published_at DESC
  LIMIT p_limit;
END;
$$;

GRANT EXECUTE ON FUNCTION cp_search_autocomplete(text, int)
  TO anon, authenticated;

-- ─── 6. Commentaires sur les nouvelles colonnes ──────────────────────────────
COMMENT ON COLUMN cas_pratique_cases.search_vector
  IS 'Vecteur tsvector pré-calculé : title (A) + situation_text (B). Mis à jour par trigger trg_cp_case_search_vector.';

COMMENT ON FUNCTION cp_search_cases_fts IS
  'Recherche full-text avancée sur les cas pratiques. Supporte FTS (tsquery) + fallback trigram ILIKE. Filtres : thèmes, années, difficultés, non-fait.';

COMMENT ON FUNCTION cp_search_autocomplete IS
  'Auto-complétion sur les titres de cas (trigram similarity). Requête min 2 chars.';
