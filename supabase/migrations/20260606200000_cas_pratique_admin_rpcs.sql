-- ============================================================
-- COP'IQ — Admin RPCs (CODE-094)
-- Fonctions appelées par le panel admin Flutter Web.
-- RLS : toutes les fonctions vérifient fn_cp_is_admin().
-- ============================================================

-- ── 1. KPIs dashboard ────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION cp_admin_kpis()
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result json;
BEGIN
  IF NOT fn_cp_is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT json_build_object(
    'published_cases',  (SELECT count(*) FROM cas_pratique_cases WHERE status = 'published'),
    'draft_cases',      (SELECT count(*) FROM cas_pratique_cases WHERE status IN ('draft','review')),
    'attempts_7d',      (
      SELECT count(*) FROM cas_pratique_attempts
      WHERE created_at >= now() - interval '7 days'
    ),
    'avg_score',        (
      SELECT coalesce(avg(c.total_score), 0)::numeric(5,2)
      FROM cas_pratique_corrections c
      JOIN cas_pratique_attempts a ON a.id = c.attempt_id
      WHERE a.created_at >= now() - interval '7 days'
        AND c.total_score IS NOT NULL
    ),
    'max_score',        15,
    'pending_appeals',  (
      SELECT count(*) FROM cas_pratique_appeals WHERE status = 'pending'
    ),
    'active_users_7d',  (
      SELECT count(DISTINCT user_id) FROM cas_pratique_attempts
      WHERE created_at >= now() - interval '7 days'
    ),
    'completion_rate',  (
      SELECT CASE
        WHEN count(*) = 0 THEN 0
        ELSE count(*) FILTER (WHERE status = 'completed')::numeric / count(*)
      END
      FROM cas_pratique_attempts
      WHERE created_at >= now() - interval '30 days'
    )
  ) INTO result;

  RETURN result;
END;
$$;

-- ── 2. Tentatives par jour ─────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION cp_admin_daily_attempts(days int DEFAULT 30)
RETURNS TABLE(day date, count bigint)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT fn_cp_is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    a.created_at::date AS day,
    count(*) AS count
  FROM cas_pratique_attempts a
  WHERE a.created_at >= now() - (days || ' days')::interval
  GROUP BY a.created_at::date
  ORDER BY a.created_at::date;
END;
$$;

-- ── 3. Top cas échoués ────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION cp_admin_top_failed(p_limit int DEFAULT 5)
RETURNS TABLE(
  case_slug  text,
  case_title text,
  avg_score  numeric,
  max_score  int,
  attempts   bigint
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT fn_cp_is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    ca.slug,
    ca.title,
    avg(c.total_score)::numeric(5,2),
    ca.total_points,
    count(*)
  FROM cas_pratique_corrections c
  JOIN cas_pratique_attempts att ON att.id = c.attempt_id
  JOIN cas_pratique_cases ca ON ca.id = att.case_id
  WHERE c.total_score IS NOT NULL
  GROUP BY ca.id, ca.slug, ca.title, ca.total_points
  ORDER BY (avg(c.total_score) / NULLIF(ca.total_points, 0)) ASC NULLS LAST
  LIMIT p_limit;
END;
$$;

-- ── 4. Synonymes avec compteur usage ─────────────────────────────────────────

CREATE OR REPLACE FUNCTION cp_admin_synonyms(p_search text DEFAULT NULL)
RETURNS TABLE(
  id               uuid,
  slug             text,
  label            text,
  terms            text[],
  tags             text[],
  used_in_keywords bigint
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT fn_cp_is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    d.id,
    d.slug,
    d.label,
    d.terms,
    d.tags,
    count(k.id)
  FROM cas_pratique_synonyms_dictionary d
  LEFT JOIN cas_pratique_keywords k ON k.dict_slug = d.slug
  WHERE (p_search IS NULL
    OR d.slug ILIKE '%' || p_search || '%'
    OR d.label ILIKE '%' || p_search || '%'
    OR d.terms::text ILIKE '%' || p_search || '%'
  )
  GROUP BY d.id, d.slug, d.label, d.terms, d.tags
  ORDER BY d.slug;
END;
$$;

-- ── 5. Appels enrichis ────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION cp_admin_appeals(p_status text DEFAULT NULL)
RETURNS TABLE(
  id                 uuid,
  user_id            uuid,
  user_email         text,
  case_title         text,
  case_slug          text,
  question_label     text,
  rubric_point_label text,
  user_answer        text,
  user_message       text,
  status             text,
  admin_response     text,
  created_at         timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT fn_cp_is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT
    ap.id,
    ap.user_id,
    u.email::text AS user_email,
    ca.title AS case_title,
    ca.slug AS case_slug,
    q.label AS question_label,
    rp.label AS rubric_point_label,
    an.content AS user_answer,
    ap.user_message,
    ap.status::text,
    ap.admin_response,
    ap.created_at
  FROM cas_pratique_appeals ap
  JOIN auth.users u ON u.id = ap.user_id
  JOIN cas_pratique_correction_details cd ON cd.id = ap.correction_detail_id
  JOIN cas_pratique_corrections cor ON cor.id = cd.correction_id
  JOIN cas_pratique_attempts att ON att.id = cor.attempt_id
  JOIN cas_pratique_cases ca ON ca.id = att.case_id
  JOIN cas_pratique_rubric_points rp ON rp.id = cd.rubric_point_id
  JOIN cas_pratique_questions q ON q.id = rp.question_id
  LEFT JOIN cas_pratique_answers an ON an.attempt_id = att.id AND an.question_id = q.id
  WHERE (p_status IS NULL OR ap.status::text = p_status)
  ORDER BY ap.created_at DESC;
END;
$$;

-- ── Grants ────────────────────────────────────────────────────────────────────

GRANT EXECUTE ON FUNCTION cp_admin_kpis()                     TO authenticated;
GRANT EXECUTE ON FUNCTION cp_admin_daily_attempts(int)         TO authenticated;
GRANT EXECUTE ON FUNCTION cp_admin_top_failed(int)             TO authenticated;
GRANT EXECUTE ON FUNCTION cp_admin_synonyms(text)              TO authenticated;
GRANT EXECUTE ON FUNCTION cp_admin_appeals(text)               TO authenticated;
