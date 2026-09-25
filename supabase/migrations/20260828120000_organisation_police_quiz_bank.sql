-- COP'IQ — banque de questions versionnée « Organisation de la Police nationale ».
-- Additive et relançable : les identifiants historiques restent inchangés.

update public.quiz_scolarite_modules
set title = 'Organisation de la Police nationale',
    subtitle = 'Institutions, directions, hiérarchie, missions et grades',
    color_hex = '#1456D9',
    is_active = true
where module in (
  'gpx_institutions_valeurs_quiz_institutions_valeurs_quiz_organisation_page',
  'pa_institutions_valeurs_quiz_pa_quiz_organisation_page'
);

-- Normalise les questions importées sans casser leurs ids ni la progression.
with organisation as (
  select q.id,
         coalesce(nullif(q.source_question_key, ''), 'legacy-' || q.id::text) stable_key,
         case
           when q.category ilike '%grade%' or q.category ilike '%hiérarchie%' then 'hierarchie_pn'
           when q.category ilike '%dgsi%' then 'dgsi'
           when q.category ilike '%préfecture%' or q.category ilike '%PP %' then 'prefecture_police'
           when q.category ilike '%emploi%' then 'regles_emploi_pa'
           when q.category ilike '%horaire%' or q.category ilike '%temps de travail%' then 'horaires_service_sp'
           when q.category ilike '%organigramme%' then 'organigrammes_pn'
           else 'organisation_pn'
         end chapter_key
  from public.quiz_scolarite_questions q
  where q.source_path in (
    'lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart',
    'lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_organisation_page.dart'
  )
)
update public.quiz_scolarite_questions q
set metadata = q.metadata || jsonb_build_object(
      'schema_version', 2,
      'content_version', greatest(q.revision, 1),
      'stable_key', o.stable_key,
      'course_key', 'organisation_police_nationale',
      'chapter_key', o.chapter_key,
      'question_type', coalesce(nullif(q.metadata->>'question_type', ''), 'multiple_choice'),
      'tags', coalesce(q.metadata->'tags', jsonb_build_array(o.chapter_key)),
      'source_reference', coalesce(nullif(q.legal_ref, ''), 'Cours COP’IQ — Organisation de la Police nationale')
    )
from organisation o
where q.id = o.id;

-- Quatrième distracteur cohérent : une autre réponse du même thème, stable et distincte.
with candidates as (
  select q.id,
         (
           select q2.answer
           from public.quiz_scolarite_questions q2
           where q2.source_path = q.source_path
             and q2.category = q.category
             and q2.id <> q.id
             and q2.answer <> q.answer
             and not (q.options ? q2.answer)
           order by md5(q.id::text || ':' || q2.id::text)
           limit 1
         ) distractor
  from public.quiz_scolarite_questions q
  where q.source_path in (
    'lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart',
    'lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_organisation_page.dart'
  )
  and jsonb_array_length(q.options) = 3
)
update public.quiz_scolarite_questions q
set options = q.options || jsonb_build_array(coalesce(c.distractor, 'Aucune de ces propositions')),
    updated_at = now()
from candidates c
where q.id = c.id;

-- Les explications courtes deviennent des fiches de correction exploitables.
update public.quiz_scolarite_questions q
set explanation = concat_ws(E'\n\n',
      'Réponse exacte : « ' || q.answer || ' ».',
      nullif(trim(q.explanation), ''),
      'À retenir : cette réponse doit être reliée au thème « ' || coalesce(q.category, 'Organisation de la Police nationale') || ' ». Repère d’abord le niveau hiérarchique, la direction ou la mission citée dans l’énoncé ; cela permet d’écarter les propositions qui appartiennent à un autre service ou à un autre corps.',
      case when nullif(trim(q.legal_ref), '') is not null then 'Référence : ' || q.legal_ref else null end
    ),
    revision = greatest(q.revision, 1) + 1,
    updated_at = now(),
    metadata = q.metadata || jsonb_build_object('content_version', greatest(q.revision, 1) + 1)
where q.source_path in (
  'lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart',
  'lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_organisation_page.dart'
)
and (q.explanation is null or length(trim(q.explanation)) < 120);

-- 25 visuels propres : un enregistrement canonique par parcours.
with grade_questions(stable_key, asset, answer, options, explanation, position) as (
  values
  ('grade-001','assets/grades/grade_001_directeur_general.png','Directeur général de la Police nationale',jsonb_build_array('Directeur général de la Police nationale','Directeur des services actifs','Inspecteur général','Contrôleur général'),'Le visuel correspond à l’emploi de directeur général de la Police nationale. Il se situe au sommet de la chaîne de direction active : il ne doit pas être confondu avec les emplois d’inspecteur général ou de contrôleur général.',1001),
  ('grade-002','assets/grades/grade_002_directeur_services_actifs.png','Directeur des services actifs',jsonb_build_array('Directeur des services actifs','Directeur général de la Police nationale','Inspecteur général','Commissaire général'),'Ce galon identifie un directeur des services actifs. La distinction porte sur l’emploi fonctionnel exercé ; le commissaire général appartient, lui, au corps de conception et de direction.',1002),
  ('grade-003','assets/grades/grade_003_inspecteur_general.png','Inspecteur général',jsonb_build_array('Inspecteur général','Contrôleur général','Directeur des services actifs','Commissaire divisionnaire'),'Il s’agit de l’emploi d’inspecteur général. Pour le reconnaître, compare les marqueurs du visuel avec ceux du contrôleur général et ne le confonds pas avec un grade du corps des commissaires.',1003),
  ('grade-004','assets/grades/grade_004_controleur_general.png','Contrôleur général',jsonb_build_array('Contrôleur général','Inspecteur général','Commissaire général','Commandant divisionnaire fonctionnel'),'Le visuel est celui d’un contrôleur général. C’est un emploi supérieur distinct de l’inspecteur général et des grades de commissaire ; la lecture précise des insignes évite cette confusion.',1004),
  ('grade-005','assets/grades/grade_005_commissaire_general.png','Commissaire général de police',jsonb_build_array('Commissaire général de police','Commissaire divisionnaire de police','Commissaire de police','Contrôleur général'),'Le commissaire général est le grade le plus élevé présenté ici dans le corps de conception et de direction. Il ne faut pas l’assimiler à l’emploi fonctionnel de contrôleur général.',1005),
  ('grade-006','assets/grades/grade_006_commissaire_divisionnaire.png','Commissaire divisionnaire de police',jsonb_build_array('Commissaire divisionnaire de police','Commissaire général de police','Commissaire de police','Commandant divisionnaire'),'Ce galon correspond au commissaire divisionnaire. Il appartient au corps de conception et de direction, entre commissaire et commissaire général dans la série présentée.',1006),
  ('grade-007','assets/grades/grade_007_commissaire.png','Commissaire de police',jsonb_build_array('Commissaire de police','Commissaire divisionnaire de police','Commissaire stagiaire','Commandant de police'),'Le visuel correspond au grade de commissaire de police. La bonne identification suppose de distinguer le corps des commissaires de celui des officiers, auquel appartient le commandant.',1007),
  ('grade-008','assets/grades/grade_008_commissaire_eleve_stagiaire.png','Commissaire élève ou stagiaire',jsonb_build_array('Commissaire élève ou stagiaire','Commissaire de police','Capitaine élève','Policier stagiaire'),'Ce visuel désigne la phase de formation du corps de conception et de direction : commissaire élève ou stagiaire. Les autres réponses renvoient à d’autres corps ou statuts de formation.',1008),
  ('grade-009','assets/grades/grade_009_commandant_divisionnaire_fonctionnel.png','Commandant divisionnaire fonctionnel',jsonb_build_array('Commandant divisionnaire fonctionnel','Commandant divisionnaire','Commandant de police','Commissaire divisionnaire'),'Le galon est celui de commandant divisionnaire fonctionnel. Le terme fonctionnel est essentiel : il le distingue du commandant divisionnaire et du commissaire divisionnaire, qui relève d’un autre corps.',1009),
  ('grade-010','assets/grades/grade_010_commandant_divisionnaire.png','Commandant divisionnaire de police',jsonb_build_array('Commandant divisionnaire de police','Commandant divisionnaire fonctionnel','Commandant de police','Capitaine de police'),'Ce visuel correspond au commandant divisionnaire de police. Il appartient au corps de commandement et se distingue de la variante fonctionnelle par ses attributs propres.',1010),
  ('grade-011','assets/grades/grade_011_commandant.png','Commandant de police',jsonb_build_array('Commandant de police','Commandant divisionnaire','Capitaine de police','Commissaire de police'),'Le galon représente un commandant de police, membre du corps de commandement. Commissaire appartient au corps de conception et de direction ; capitaine est un autre grade du corps de commandement.',1011),
  ('grade-012','assets/grades/grade_012_capitaine.png','Capitaine de police',jsonb_build_array('Capitaine de police','Commandant de police','Lieutenant de police','Capitaine stagiaire'),'Il s’agit du grade de capitaine de police. La mention stagiaire désigne un statut de formation différent, tandis que commandant est un grade supérieur dans le même corps.',1012),
  ('grade-013','assets/grades/grade_013_lieutenant_appellation.png','Lieutenant de police (appellation)',jsonb_build_array('Lieutenant de police (appellation)','Capitaine de police','Capitaine stagiaire','Sous-brigadier'),'Le visuel correspond à l’appellation de lieutenant de police. Il doit être rattaché au corps de commandement et distingué des grades du corps d’encadrement et d’application.',1013),
  ('grade-014','assets/grades/grade_014_capitaine_stagiaire.png','Capitaine stagiaire',jsonb_build_array('Capitaine stagiaire','Capitaine de police','Capitaine élève','Commissaire stagiaire'),'Ce galon indique le statut de capitaine stagiaire. Le mot stagiaire marque une étape différente de celle d’élève et du grade pleinement exercé de capitaine de police.',1014),
  ('grade-015','assets/grades/grade_015_capitaine_eleve.png','Capitaine élève',jsonb_build_array('Capitaine élève','Capitaine stagiaire','Capitaine de police','Commissaire élève'),'Le visuel est celui d’un capitaine élève. Il correspond à l’étape de formation initiale précédant le statut de stagiaire puis l’exercice du grade.',1015),
  ('grade-016','assets/grades/grade_016_rulp.png','Responsable d’unité locale de police (RULP)',jsonb_build_array('Responsable d’unité locale de police (RULP)','Major de police','Major exceptionnel','Brigadier-major'),'Le galon correspond à l’appellation RULP, responsable d’unité locale de police. L’appellation fonctionnelle doit être distinguée des grades ou appellations de major et de brigadier-major.',1016),
  ('grade-017','assets/grades/grade_017_major_exceptionnel.png','Major de police à l’échelon exceptionnel',jsonb_build_array('Major de police à l’échelon exceptionnel','Major de police','Brigadier-major','RULP'),'Ce visuel désigne un major de police à l’échelon exceptionnel. L’échelon exceptionnel est le détail déterminant qui permet de l’écarter du major sans cette précision.',1017),
  ('grade-018','assets/grades/grade_018_brigadier_major.png','Brigadier-major de police',jsonb_build_array('Brigadier-major de police','Brigadier-chef de police','Sous-brigadier de police','Gardien de la paix'),'Le galon est celui de brigadier-major, dans le corps d’encadrement et d’application. Il se place au-dessus des appellations de brigadier-chef et de sous-brigadier présentées ici.',1018),
  ('grade-019','assets/grades/grade_019_brigadier_chef.png','Brigadier-chef de police',jsonb_build_array('Brigadier-chef de police','Brigadier-major de police','Sous-brigadier de police','Gardien de la paix'),'Ce visuel correspond à l’appellation de brigadier-chef. Le nombre et l’organisation des galons permettent de le distinguer du brigadier-major et du sous-brigadier.',1019),
  ('grade-020','assets/grades/grade_020_brigadier_ancien.png','Brigadier de police (ancienne appellation)',jsonb_build_array('Brigadier de police (ancienne appellation)','Brigadier-chef de police','Brigadier-major de police','Sous-brigadier de police'),'Le visuel renvoie à l’ancienne appellation de brigadier de police. La précision « ancienne appellation » est indispensable pour ne pas la confondre avec les appellations actuelles voisines.',1020),
  ('grade-021','assets/grades/grade_021_sous_brigadier.png','Sous-brigadier de police',jsonb_build_array('Sous-brigadier de police','Brigadier-chef de police','Gardien de la paix','Policier adjoint'),'Il s’agit de l’appellation de sous-brigadier. Elle appartient au corps d’encadrement et d’application et ne doit pas être confondue avec le statut contractuel de policier adjoint.',1021),
  ('grade-022','assets/grades/grade_022_policier_stagiaire.png','Policier stagiaire',jsonb_build_array('Policier stagiaire','Gardien de la paix','Policier adjoint','Réserviste opérationnel'),'Ce visuel identifie un policier stagiaire. Le statut de stagiaire correspond à une phase de formation et d’évaluation avant titularisation ; ce n’est ni un policier adjoint ni un réserviste.',1022),
  ('grade-023','assets/grades/grade_023_policier_adjoint.png','Policier adjoint',jsonb_build_array('Policier adjoint','Gardien de la paix','Policier stagiaire','Réserviste opérationnel'),'Le galon est celui d’un policier adjoint. Le policier adjoint est recruté sous un statut distinct de celui du gardien de la paix et ne relève pas de la réserve opérationnelle.',1023),
  ('grade-024','assets/grades/grade_024_reserve.png','Réserviste opérationnel de la Police nationale',jsonb_build_array('Réserviste opérationnel de la Police nationale','Policier adjoint','Gardien de la paix','Policier stagiaire'),'Ce visuel correspond à la réserve opérationnelle de la Police nationale. Le réserviste intervient sous un statut spécifique, différent du policier adjoint, du stagiaire et du gardien de la paix.',1024),
  ('grade-025','assets/grades/grade_025_gardien_de_la_paix.png','Gardien de la paix',jsonb_build_array('Gardien de la paix','Sous-brigadier de police','Policier adjoint','Policier stagiaire'),'Le galon représente un gardien de la paix titulaire du corps d’encadrement et d’application. Il doit être distingué de l’appellation de sous-brigadier et des statuts de policier adjoint ou stagiaire.',1025)
), tracks(track,module,source_path) as (
  values
  ('gpx','gpx_institutions_valeurs_quiz_institutions_valeurs_quiz_organisation_page','lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart'),
  ('pa','pa_institutions_valeurs_quiz_pa_quiz_organisation_page','lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_organisation_page.dart')
)
insert into public.quiz_scolarite_questions (
  module, track, category, difficulty, question, options, answer, explanation,
  legal_ref, position, is_active, publication_status, published_at,
  source_path, source_hash, source_question_key, metadata, revision
)
select t.module, t.track, 'Grades PN — Reconnaissance visuelle',
       case when g.position % 3 = 0 then 'Difficile' when g.position % 2 = 0 then 'Moyenne' else 'Facile' end,
       'Quel grade, emploi ou statut est représenté par cet insigne (planche ' || lpad((g.position - 1000)::text, 2, '0') || ') ?',
       g.options, g.answer, g.explanation,
       'Référentiel visuel COP’IQ — galons de la Police nationale', g.position,
       true, 'published', now(), t.source_path,
       md5(g.stable_key || ':' || g.answer), 'organisation-' || g.stable_key,
       jsonb_build_object(
         'schema_version', 2, 'content_version', 1,
         'stable_key', 'organisation-' || g.stable_key,
         'course_key', 'organisation_police_nationale',
         'chapter_key', 'hierarchie_pn',
         'question_type', 'image_to_grade',
         'image_asset', g.asset,
         'tags', jsonb_build_array('grades', 'galons', 'reconnaissance_visuelle'),
         'source_reference', 'Référentiel visuel COP’IQ — galons de la Police nationale'
       ), 1
from grade_questions g cross join tracks t
on conflict (source_path, source_question_key) where source_path is not null and source_question_key is not null
do update set
  options = excluded.options, answer = excluded.answer,
  explanation = excluded.explanation, metadata = excluded.metadata,
  is_active = true, publication_status = 'published', updated_at = now();

create index if not exists quiz_scolarite_organisation_session_idx
  on public.quiz_scolarite_questions(module, publication_status, is_active, difficulty, position);
create index if not exists quiz_scolarite_organisation_metadata_idx
  on public.quiz_scolarite_questions using gin(metadata jsonb_path_ops);

create or replace function public.organisation_quiz_session(
  p_module text,
  p_difficulty text default null,
  p_limit integer default 15
)
returns table(
  id bigint, category text, difficulty text, question text, options jsonb,
  answer text, explanation text, legal_ref text, metadata jsonb,
  revision integer, updated_at timestamptz
)
language sql stable security definer set search_path = public
as $$
  select q.id, q.category, q.difficulty, q.question, q.options, q.answer,
         q.explanation, q.legal_ref, q.metadata, q.revision, q.updated_at
  from public.quiz_scolarite_questions q
  where q.module = p_module
    and q.is_active
    and q.publication_status = 'published'
    and (p_difficulty is null or q.difficulty = p_difficulty)
  order by random()
  limit greatest(1, least(p_limit, 50));
$$;

revoke all on function public.organisation_quiz_session(text,text,integer) from public, anon;
grant execute on function public.organisation_quiz_session(text,text,integer) to authenticated;
grant select on public.quiz_scolarite_questions to authenticated;

comment on function public.organisation_quiz_session(text,text,integer) is
  'Session versionnée Organisation PN, réservée aux utilisateurs authentifiés.';
