-- ════════════════════════════════════════════════════════════════════════════
--  COP'IQ — Intégration des signalements « cas pratique » au panneau admin
--
--  Contexte : la table public.cas_pratique_question_reports et la RPC
--  public.cp_report_question (déjà utilisée par l'app Flutter, cf.
--  lib/data/cas_pratique/cas_pratique_repository_impl.dart) existaient déjà,
--  mais n'étaient reliées à aucune vue d'administration : les signalements
--  s'accumulaient en base sans être visibles dans /admin/signalements.
--
--  Ce script :
--    1. ajoute une colonne `archived` à cas_pratique_question_reports, pour
--       la cohérence avec les autres tables de signalement (report_culture_
--       generale, tests_psycotechnique_report) ;
--    2. ajoute le type 'cas_pratique' à la RPC admin_reports_unified (lecture
--       agrégée, utilisée par /admin/signalements) ;
--    3. ajoute le type 'cas_pratique' à la RPC admin_resolve_report
--       (traitement/archivage d'un signalement).
--
--  Chaque ligne de cas_pratique_question_reports correspond à un signalement
--  sur UNE question précise d'UN cas pratique (faute d'orthographe, erreur
--  juridique, grille de correction incorrecte, énoncé ambigu, réponse modèle
--  incorrecte, ou autre). Le libellé affiché combine le titre du cas et le
--  numéro de la question pour permettre l'identification immédiate.
-- ════════════════════════════════════════════════════════════════════════════

BEGIN;

-- 1. Cohérence de schéma avec les autres tables de signalement.
ALTER TABLE public.cas_pratique_question_reports
  ADD COLUMN IF NOT EXISTS archived boolean NOT NULL DEFAULT false;

-- 2. Lecture agrégée : ajout de la branche 'cas_pratique'.
CREATE OR REPLACE FUNCTION public.admin_reports_unified(
  p_kind text DEFAULT NULL::text,
  p_status text DEFAULT NULL::text,
  p_search text DEFAULT NULL::text,
  p_limit integer DEFAULT 100,
  p_offset integer DEFAULT 0
)
 RETURNS TABLE(kind text, id text, created_at timestamp with time zone, status text, module text, category text, question_id text, question text, message text, report_type text, email text, archived boolean)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
BEGIN
  IF NOT public.has_admin_permission('reports.read') THEN
    RAISE EXCEPTION 'Accès refusé.' USING ERRCODE='42501';
  END IF;
  RETURN QUERY
  SELECT * FROM (
    SELECT 'cg'::text AS kind, r.id::text AS id, r.created_at, r.status,
           r.module, r.category, r.question_id::text, r.question,
           r.message, r.report_type, r.email, r.archived
    FROM public.report_culture_generale r
    WHERE (p_kind IS NULL OR p_kind='' OR p_kind='cg')
    UNION ALL
    SELECT 'psy'::text, r.id::text, r.created_at, r.status,
           r.module, r.category, r.question_id, r.question,
           r.message, r.report_type, r.email, r.archived
    FROM public.tests_psycotechnique_report r
    WHERE (p_kind IS NULL OR p_kind='' OR p_kind='psy')
    UNION ALL
    SELECT 'cas_pratique'::text, r.id::text, r.created_at, r.status,
           'cas_pratique'::text AS module,
           th.slug AS category,
           r.question_id::text,
           (c.title || ' — Q' || q.position::text || ' : ' || q.label) AS question,
           r.message, r.report_type, au.email, r.archived
    FROM public.cas_pratique_question_reports r
    JOIN public.cas_pratique_questions q ON q.id = r.question_id
    JOIN public.cas_pratique_cases c ON c.id = r.case_id
    LEFT JOIN public.cas_pratique_themes th ON th.id = c.theme_id
    LEFT JOIN auth.users au ON au.id = r.user_id
    WHERE (p_kind IS NULL OR p_kind='' OR p_kind='cas_pratique')
  ) u
  WHERE (p_status IS NULL OR p_status='' OR u.status=p_status)
    AND (p_search IS NULL OR p_search='' OR
         u.question ILIKE '%'||p_search||'%' OR
         u.message ILIKE '%'||p_search||'%' OR
         COALESCE(u.email,'') ILIKE '%'||p_search||'%')
  ORDER BY u.created_at DESC
  LIMIT GREATEST(p_limit,1) OFFSET GREATEST(p_offset,0);
END;
$function$;

-- 3. Traitement / archivage : ajout de la branche 'cas_pratique'.
CREATE OR REPLACE FUNCTION public.admin_resolve_report(
  p_kind text,
  p_id text,
  p_status text,
  p_archive boolean DEFAULT false,
  p_comment text DEFAULT NULL::text
)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth'
AS $function$
DECLARE v_table text; v_old jsonb;
BEGIN
  IF NOT public.has_admin_permission('reports.manage') THEN
    RAISE EXCEPTION 'Accès refusé.' USING ERRCODE='42501';
  END IF;
  IF p_kind = 'cg' THEN
    v_table := 'report_culture_generale';
    SELECT to_jsonb(t) INTO v_old FROM public.report_culture_generale t WHERE t.id::text=p_id;
    UPDATE public.report_culture_generale SET status=p_status, archived=COALESCE(p_archive,false), status_updated_at=now(), updated_at=now() WHERE id::text=p_id;
  ELSIF p_kind = 'psy' THEN
    v_table := 'tests_psycotechnique_report';
    SELECT to_jsonb(t) INTO v_old FROM public.tests_psycotechnique_report t WHERE t.id::text=p_id;
    UPDATE public.tests_psycotechnique_report SET status=p_status, archived=COALESCE(p_archive,false), status_updated_at=now(), updated_at=now() WHERE id::text=p_id;
  ELSIF p_kind = 'cas_pratique' THEN
    v_table := 'cas_pratique_question_reports';
    SELECT to_jsonb(t) INTO v_old FROM public.cas_pratique_question_reports t WHERE t.id::text=p_id;
    UPDATE public.cas_pratique_question_reports
       SET status=p_status,
           archived=COALESCE(p_archive,false),
           admin_response=COALESCE(p_comment, admin_response),
           resolved_by=auth.uid(),
           resolved_at=now(),
           updated_at=now()
     WHERE id::text=p_id;
  ELSE
    RAISE EXCEPTION 'Type de signalement inconnu.' USING ERRCODE='22023';
  END IF;
  PERFORM public.audit_log_write('report.resolve','info',true,v_table,p_id,NULL,v_old,
    jsonb_build_object('status',p_status,'archived',p_archive), p_comment);
  RETURN jsonb_build_object('ok',true);
END;
$function$;

COMMIT;
