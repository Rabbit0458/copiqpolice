-- ╔════════════════════════════════════════════════════════════════════════╗
-- ║  COP'IQ — Cas Pratique — Migration 009 : seed cas legacy (case_1 → 6)  ║
-- ║  Tâche      : CODE-047                                                  ║
-- ║                                                                         ║
-- ║  Cette migration est un BOOTSTRAP des 6 cas pratiques legacy migrés    ║
-- ║  depuis `lib/content/.../case_X_page.dart` via l'extracteur CODE-046.  ║
-- ║                                                                         ║
-- ║  Stratégie :                                                            ║
-- ║   1. Fonction utilitaire `fn_cp_seed_legacy_case(slug, ...)` qui crée  ║
-- ║      le cas, ses questions, perfect answers, rubric_points,            ║
-- ║      keyword_groups et keywords en une seule passe idempotente         ║
-- ║      (UPSERT sur slug + ON CONFLICT DO NOTHING sur les enfants).        ║
-- ║   2. 6 appels à la fonction, un par cas, avec un JSON d'entrée.        ║
-- ║                                                                         ║
-- ║  Le JSON d'entrée a la structure :                                      ║
-- ║   {                                                                     ║
-- ║     "title": "...",                                                     ║
-- ║     "year": 2024, "month": "Septembre", "difficulty": "moyen",          ║
-- ║     "situation_text": "...", "situation_md": "...",                     ║
-- ║     "theme_slug": "deontologie" | null,                                 ║
-- ║     "questions": [                                                      ║
-- ║       { "position":1, "label":"...", "perfect":"...",                   ║
-- ║         "points": [                                                     ║
-- ║           { "position":1, "label":"...", "weight":1.5,                  ║
-- ║             "is_required":true, "kind":"core",                          ║
-- ║             "groups": [                                                 ║
-- ║               { "position":1, "is_optional":false,                      ║
-- ║                 "keywords": ["mot1","mot2","..."] } ] } ] } ] }         ║
-- ║                                                                         ║
-- ║  ⚠️  Cette migration insère les cas avec `status='draft'`. Un admin    ║
-- ║   doit les revoir (theme, difficulty, weights, kind, explanation) et   ║
-- ║   passer à `status='published'` avant qu'ils n'apparaissent dans la    ║
-- ║   liste user.                                                           ║
-- ╚════════════════════════════════════════════════════════════════════════╝

BEGIN;

-- ─── Fonction utilitaire ───────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_cp_seed_legacy_case(p_slug text, p_data jsonb)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $func$
DECLARE
    v_case_id   uuid;
    v_q_id      uuid;
    v_pt_id     uuid;
    v_g_id      uuid;
    v_theme_id  uuid;
    v_q         jsonb;
    v_pt        jsonb;
    v_grp       jsonb;
    v_kw_text   text;
BEGIN
    -- 1) Theme (optionnel)
    IF p_data ? 'theme_slug' AND (p_data->>'theme_slug') IS NOT NULL THEN
        SELECT id INTO v_theme_id
        FROM public.cas_pratique_themes
        WHERE slug = p_data->>'theme_slug'
        LIMIT 1;
    END IF;

    -- 2) Case : upsert sur slug
    INSERT INTO public.cas_pratique_cases (
        slug, theme_id, title, year, month, difficulty,
        total_points, estimated_minutes, status,
        situation_text, situation_md
    )
    VALUES (
        p_slug,
        v_theme_id,
        COALESCE(p_data->>'title', 'Cas pratique ' || p_slug),
        COALESCE((p_data->>'year')::int, 0),
        p_data->>'month',
        COALESCE(p_data->>'difficulty', 'moyen'),
        COALESCE((p_data->>'total_points')::int, 15),
        COALESCE((p_data->>'estimated_minutes')::int, 15),
        COALESCE(p_data->>'status', 'draft'),
        COALESCE(p_data->>'situation_text', ''),
        COALESCE(p_data->>'situation_md', p_data->>'situation_text', '')
    )
    ON CONFLICT (slug) DO UPDATE
      SET title             = EXCLUDED.title,
          theme_id          = COALESCE(EXCLUDED.theme_id, public.cas_pratique_cases.theme_id),
          year              = EXCLUDED.year,
          month             = EXCLUDED.month,
          difficulty        = EXCLUDED.difficulty,
          total_points      = EXCLUDED.total_points,
          estimated_minutes = EXCLUDED.estimated_minutes,
          status            = EXCLUDED.status,
          situation_text    = EXCLUDED.situation_text,
          situation_md      = EXCLUDED.situation_md
    RETURNING id INTO v_case_id;

    -- 3) Wipe les questions/perfect/rubric existantes pour ce cas
    --    (ON DELETE CASCADE supprime aussi keyword_groups et keywords)
    DELETE FROM public.cas_pratique_questions WHERE case_id = v_case_id;

    -- 4) Questions
    FOR v_q IN SELECT * FROM jsonb_array_elements(p_data->'questions')
    LOOP
        INSERT INTO public.cas_pratique_questions (
            case_id, position, label, hint,
            max_points, char_min, char_recommended
        )
        VALUES (
            v_case_id,
            COALESCE((v_q->>'position')::int, 0),
            COALESCE(v_q->>'label', ''),
            v_q->>'hint',
            COALESCE((v_q->>'max_points')::int, 5),
            COALESCE((v_q->>'char_min')::int, 80),
            COALESCE((v_q->>'char_recommended')::int, 400)
        )
        RETURNING id INTO v_q_id;

        -- 4.a) Perfect answer
        IF (v_q->>'perfect') IS NOT NULL AND length(v_q->>'perfect') > 0 THEN
            INSERT INTO public.cas_pratique_perfect_answers (
                question_id, body_md, references_legal
            )
            VALUES (
                v_q_id,
                v_q->>'perfect',
                COALESCE(v_q->'references_legal', '[]'::jsonb)
            );
        END IF;

        -- 4.b) Rubric points
        FOR v_pt IN SELECT * FROM jsonb_array_elements(COALESCE(v_q->'points', '[]'::jsonb))
        LOOP
            INSERT INTO public.cas_pratique_rubric_points (
                question_id, position, label, weight,
                is_required, kind, explanation_md
            )
            VALUES (
                v_q_id,
                COALESCE((v_pt->>'position')::int, 0),
                COALESCE(v_pt->>'label', ''),
                COALESCE((v_pt->>'weight')::numeric, 1.0),
                COALESCE((v_pt->>'is_required')::boolean, true),
                COALESCE(v_pt->>'kind', 'core'),
                v_pt->>'explanation_md'
            )
            RETURNING id INTO v_pt_id;

            -- 4.c) Keyword groups
            FOR v_grp IN SELECT * FROM jsonb_array_elements(COALESCE(v_pt->'groups', '[]'::jsonb))
            LOOP
                INSERT INTO public.cas_pratique_keyword_groups (
                    point_id, position, description, is_optional
                )
                VALUES (
                    v_pt_id,
                    COALESCE((v_grp->>'position')::int, 0),
                    v_grp->>'description',
                    COALESCE((v_grp->>'is_optional')::boolean, false)
                )
                RETURNING id INTO v_g_id;

                -- 4.d) Keywords (array de strings simple)
                FOR v_kw_text IN
                    SELECT jsonb_array_elements_text(COALESCE(v_grp->'keywords', '[]'::jsonb))
                LOOP
                    IF v_kw_text IS NULL OR length(trim(v_kw_text)) = 0 THEN
                        CONTINUE;
                    END IF;
                    INSERT INTO public.cas_pratique_keywords (
                        group_id, value, is_phrase, is_negation, fuzzy_max_dist, position
                    )
                    VALUES (
                        v_g_id,
                        v_kw_text,
                        position(' ' in v_kw_text) > 0,  -- multi-mots = phrase
                        false,
                        1,
                        0
                    );
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;

    RETURN v_case_id;
END;
$func$;

COMMENT ON FUNCTION public.fn_cp_seed_legacy_case(text, jsonb) IS
    'Idempotente : seed un cas legacy + ses questions / perfect / rubric / groups / keywords. Slug = clé d''upsert.';

-- ═══════════════════════════════════════════════════════════════════════════
-- SEED des 6 cas legacy
-- ═══════════════════════════════════════════════════════════════════════════
--
-- Le payload détaillé (label/perfect/points/groups/keywords) est généré par
-- l'extracteur Dart CODE-046 (`tools/cas_pratique/extract_legacy_cases.dart`)
-- et doit être collé ici, par cas, sous forme de jsonb.
--
-- Pour rester safe en CI / preview, on stocke ici un PLACEHOLDER minimal :
--   - le cas est créé avec slug = case_N, title générique, status='draft'
--   - les questions / rubrics ne sont PAS hardcodées (à pousser par admin
--     via un script séparé ou via une seconde migration une fois les JSON
--     dumps validés).
--
-- Quand les JSON dumps sont prêts (`tools/cas_pratique/legacy_dump/case_<n>.json`),
-- remplacez `'{}'::jsonb` par le contenu du JSON via un script `psql -v` ou
-- via `\set content `cat case_<n>.json`` puis appelez fn_cp_seed_legacy_case.

DO $$
DECLARE
    v_i int;
    v_slug text;
    v_payload jsonb;
BEGIN
    FOR v_i IN 1..6 LOOP
        v_slug := 'case_' || v_i;
        v_payload := jsonb_build_object(
            'title', 'Cas pratique n°' || v_i || ' (legacy)',
            'year', 0,
            'month', NULL,
            'difficulty', 'moyen',
            'total_points', 15,
            'estimated_minutes', 15,
            'status', 'draft',
            'situation_text', 'Migration legacy en attente. Voir tools/cas_pratique/legacy_dump/case_' || v_i || '.json.',
            'situation_md', 'Migration legacy en attente. Voir tools/cas_pratique/legacy_dump/case_' || v_i || '.json.',
            'theme_slug', NULL,
            'questions', '[]'::jsonb
        );
        PERFORM public.fn_cp_seed_legacy_case(v_slug, v_payload);
    END LOOP;
END $$;

COMMIT;

-- ─── Notes d'opération ─────────────────────────────────────────────────────
--
-- Pour pousser les vrais payloads après extraction :
--
--   1. dart run tools/cas_pratique/extract_legacy_cases.dart
--   2. Pour chaque case_N.json généré, convertir au format attendu par
--      fn_cp_seed_legacy_case (questions[].perfect = perfect_answer.body_md,
--      questions[].points = rubric, points[].groups[].keywords = liste de
--      strings tirée de keywords[].value) — un petit script Node/Python
--      fait l'affaire.
--   3. psql -f run_seed_legacy.sql où run_seed_legacy.sql contient :
--        SELECT public.fn_cp_seed_legacy_case('case_1', '<JSON>'::jsonb);
--        SELECT public.fn_cp_seed_legacy_case('case_2', '<JSON>'::jsonb);
--        ...
--
-- Cette migration garantit que la fonction est dispo + les 6 slugs existent
-- en draft, prêts à être enrichis.
