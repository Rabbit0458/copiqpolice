# 03 — Scolarité PA & GPX : cartographie pour le portage Next.js

> Périmètre : parcours **école** uniquement (PA scolarité, GPX scolarité). Sources lues : `lib/features/home/home_page_pa_school.dart`, `home_page_gpx_school.dart`, `lib/features/onboarding/pa_school.dart`, `gpx_school.dart`, `lib/routes/pa_school_routes.dart`, `lib/routes/app_router.dart`, `lib/content/{pa,gpx}_scolarite/**`, `lib/core/content/course_markdown_parser.dart`, `lib/core/services/{learning_answer_history_service,subscription_service,premium_guard}.dart`, `lib/features/home/{pa,gpx}_school_progress_service.dart`, `quiz_progress_enrichment.dart`, `journal_*school*.dart`, docs `progression/*`. Base Supabase interrogée en lecture seule (projet `nuoonagnkhbeeymtvrcn`) le 2026-10-09.
>
> NB : la cartographie `progression/CARTOGRAPHIE_COMPLETE_SCOLARITE_GPX_PA.md` et sa pyramide PNG sont organisées **par arborescence de fichiers** (1 409 fichiers), pas par menu affiché. La pyramide ci-dessous est celle **réellement affichée** (configs `paSchoolCategoriesConfig` / `gpxSchoolCategoriesConfig`).

## 0. Synthèse chiffrée

| | PA | GPX |
|---|---:|---:|
| Programmes (niveau 1, choisis dans `PaSchoolArt`/`GpxSchoolArt`) | 3 | 7 |
| Domaines (cartes du deck = `CategoryConfig`) | 31 | 55 |
| Feuilles (cours + quiz = `SubCategoryConfig`) | 187 (167 cours, 20 quiz) | 326 (297 cours, 29 quiz) |
| Lignes `cours_scolarite` (toutes publiées) | 583 (543 course + 40 introduction) | 663 (613 + 50) |
| Modules `quiz_scolarite_modules` | 73 (20 132 questions actives) | 122 (29 165 questions actives) |
| Fragments `scolarite_content_fragments` (PA+GPX) | 85 125 (84 287 `is_runtime_connected`, 1 199 fichiers, 20 édités) | |

Résolution des 513 feuilles de menu (script de mapping route → registre → fichier → DB) :
- **452** cours = page Dart historique dont le texte est lu via `ScolariteText.value(sourcePath, fragmentKey, fallback)` → table `scolarite_content_fragments` (450 ont aussi une ligne `cours_scolarite`).
- **12** cours = `CoursScolaritePage` 100 % Supabase (`cours_scolarite.body_md`) — GPX « Dimension humaine ».
- **19** quiz = `QuizScolariteDynamiquePage(module: …)` 100 % Supabase.
- **30** quiz = page Dart avec questions **codées en dur** (listes `const QuizQuestion`), mais dont les questions sont **déjà importées** dans `quiz_scolarite_questions` sous une clé dérivée du chemin (voir §3). Seul Flagrant délit (PA + GPX) lit déjà la DB (avec secours Dart).

## 1. Hiérarchie d’affichage (pyramide)

```
Niveau 0  Mode School  →  piste PA (/home-pa-school)  |  piste GPX (/home-gpx-school)
Niveau 1  Programme (enum PaSchoolProgram / GpxSchoolProgram, persisté via SchoolProgramPreferences.savePa/…)
Niveau 2  Domaine = CategoryConfig {label, badge, image, route, subcategories}  → carte du HeroDeck
Niveau 3  Feuille = SubCategoryConfig {label, route, image?} → _CategoryDetailPage (liste de _ModuleCard)
Niveau 4  Page Dart : intro (splash) → contenu (cartes chapitres) → sous-pages/chapitres (PageView) ; ou quiz
```

Programmes :

| Piste | key (`.key`) | Titre affiché | Icône | Image héro |
|---|---|---|---|---|
| PA/GPX | `institution_valeurs` | Institution & Valeurs | account_balance_rounded | assets/images/school.jpeg |
| PA/GPX | `dps_dpg` | DPS / DPG | gavel_rounded | assets/images/exam.jpeg |
| PA/GPX | `memento_circulation_routiere` | Mémento • Circulation routière (compact : Circulation routière) | directions_car_rounded | assets/images/contravention.jpeg |
| GPX | `policier_en_intervention` | Policier en intervention — Socle initial | local_police_rounded | assets/images/cat_hierarchie.jpg |
| GPX | `policier_en_intervention_avance` | Policier en intervention — Socle avancé | local_police_rounded | assets/images/cat_hierarchie.jpg |
| GPX | `recueil_pv_apj20` | Recueil de procès-verbaux (APJ 20) | description_rounded | assets/images/pp_instruction_mandats_detention.jpeg |
| GPX | `dimension_humaine` | Dimension humaine | volunteer_activism_rounded | assets/images/dignite_discriminations.jpeg |

Sous-titres/badges GPX : `lib/features/onboarding/gpx_school.dart:47-129` ; PA : `lib/features/onboarding/pa_school.dart:35-80`.
Remarque : `lib/content/pa_scolarite/policier_intervention_pages/**`, `procedure_penale_pages/**`, `cadres_juridiques_pages/**` existent mais la PA n’expose que 3 programmes ; ces pages sont atteintes via les routes des feuilles DPS/DPG ou ne sont pas dans le menu PA.

La table complète domaine → feuilles (libellés exacts, routes, images, type, source de données, clé module, fichier Dart) est en §7.

## 2. Sources de données

### 2.1 Tables Supabase utilisées par la scolarité (grep `.from('` sur le périmètre)

| Table / RPC | Usage | Fichier |
|---|---|---|
| `scolarite_content_fragments` (source_path, fragment_key, panel, position, component, text_value, original_text, style_payload, is_editable, revision, is_runtime_connected) | Texte de **toutes** les pages Dart historiques (1 198 fichiers importent `scolarite_text.dart`). Clé = chemin du fichier Dart + `f00001…`. Cache SharedPreferences `scolarite_text_fragments_v1::<path>`, fallback = texte Dart. | `lib/content/gpx_scolarite/shared/scolarite_text.dart:72` |
| `cours_scolarite` (route, track, module, section, code, title, subtitle, body_md, key_points, legal_refs, quiz_module, color_hex, sort_order, is_published, publication_status…, content_blocks, source_path, source_kind, parent_route, metadata) | Fiches dynamiques (`CoursScolaritePage`, clé = `route`) + catalogue. Les 1 246 lignes importées sont des **extractions à plat** (contiennent « Retour », parfois des commentaires Dart dans les intros) : utilisables pour recherche/SEO, **pas** comme rendu fidèle. | `lib/content/gpx_scolarite/shared/cours_scolarite_page.dart:31,138` |
| `quiz_scolarite_modules` (module, track, title, subtitle, icon, color_hex, route, sort_order, is_active) | Habillage quiz dynamique. `title` des 176 modules importés = nom de fichier (« Pa Quiz Stad.dart ») → le web doit prendre le **libellé du menu**. `route` = `/scolarite/quiz/<module>` sauf modules natifs. | `gpx_quiz_dynamique_page.dart:215` |
| `quiz_scolarite_questions` (id, module, track, category, difficulty Facile/Moyenne/Difficile, question, options jsonb, answer, explanation, legal_ref, position, is_active, publication_status, metadata{image_asset,question_type,stable_key}, revision, source_path, source_question_key) | Questions | RPC + `pa_quiz_flagrant_delit_page.dart:2476`, `gpx …/quiz_flagrant_delit_page.dart:2453` |
| RPC `quiz_scolarite_counts(p_module)` → `{total,facile,moyenne,difficile}` | écran intro du quiz | `gpx_quiz_dynamique_page.dart:233` |
| RPC `quiz_scolarite_session(p_module,p_difficulty,p_limit=15)` (random, max 50, **ne filtre pas** `publication_status`) ; `organisation_quiz_session` (idem + `publication_status='published'`, utilisée si module contient « organisation ») | tirage | `gpx_quiz_dynamique_page.dart:262` |
| `quiz_history` (361 appels) | tentative | tous les quiz |
| RPC `record_learning_answer` → `quiz_answer_history` | réponse détaillée | `lib/core/services/learning_answer_history_service.dart` |
| `report_question` (104) / `QuizReportQueueService` | signalement | quiz |
| ~70 tables legacy `quiz_<sujet>` (`quiz_stad`, `quiz_probite`…) | log par réponse des quiz Dart (doublon historique de `quiz_answer_history`) | quiz Dart |

### 2.2 Migré vs restant en Dart
- Texte des cours : **migré** (fragments), mais **mise en page/structure restée en Dart** (widgets, couleurs, images, enchaînements de navigation). Pour le web il faut ré-implémenter quelques **gabarits** (intro splash, page de cartes-chapitres, lecteur PageView, leçon « premium sanction », tableaux) et les alimenter par `scolarite_content_fragments` filtré par `source_path` + `order by position` (le champ `component` : TextSpan, string, _Paragraph, _SubTitle, title, Text, subtitle, tooltip, label, _NotaBox).
- Quiz : **questions migrées** (48 755 uniques / 195 modules) ; les écrans Flutter routés restent Dart sauf 19 dynamiques + Flagrant délit. Le web peut tout servir via `quiz_scolarite_session` sur la clé module (§3).
- Hiérarchie (programmes/domaines/feuilles/images) : **uniquement en Dart** (const maps). Aucune table de navigation ; à porter en JSON/TS dans le web (ou créer une table).

## 3. Clés `quiz_scolarite_modules.module` ↔ hiérarchie

Deux familles :
1. **Modules natifs** (créés pour le moteur dynamique, routes déclarées en dur dans `lib/routes/app_router.dart:365-505`) : `gpx_institution_laicite`, `gpx_intervention_{etrangers,mineurs,accident_circulation,stupefiants,debit_boissons,malades_mentaux,animal,autres}`, `gpx_circulation_{procedures,controle_routier,equipements}`, `gpx_dh_{communication,stress,ethique}`, `pa_institution_laicite`, `pa_circulation_{procedures,controle_routier,equipements}`. Route menu = `/<track>/…/quiz`, identique à `quiz_scolarite_modules.route`.
2. **Modules importés depuis les fichiers Dart** : `module = track + '_' + slug(chemin relatif sous lib/content/<track>_scolarite/ sans .dart)` où slug = minuscules, tout caractère hors `[a-z0-9]` → `_`, `_` multiples fusionnés (é, è → `_`).
   - `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_stad.dart` → `pa_quiz_scolarite_pa_pa_quiz_stad`
   - `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/quiz_circulation_routiere.dart` → `gpx_dps_dpg_infraction_circulation_routi_re_pages_quiz_circulation_routiere`
   - Route stable côté app : `/scolarite/quiz/<module>` (résolue dynamiquement, `app_router.dart:190-202`).
   Chaîne de résolution menu → module : route menu → `RouteRegistry`/`PaSchoolRouteRegistry` → classe `Quiz…PA` → fichier → clé. Tableau §7 colonne « Clé DB ».
- Plusieurs fichiers ont le même contenu (ex. 3 modules circulation à 336 q. : `pa_quiz_scolarite_pa_pa_quiz_circulation_routiere`, `gpx_quiz_scolarite_gpx_gpx_quiz_circulation_routiere`, `gpx_dps_dpg_infraction_…`). Les pistes restent séparées (décision propriétaire, `app_router.dart:411-418`).
- `cours_scolarite.quiz_module` existe pour lier fiche → quiz (rempli pour les fiches Dimension humaine).
- Recommandation web : table/JSON `menuRoute → moduleKey + label` (49 entrées ci-dessous), titre = libellé menu.

## 4. Contrat d’écriture de progression (quiz école)

Début de quiz (moteur dynamique, `lib/content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_dynamique_page.dart:362`) :
```dart
await _sb.from('quiz_history').insert({
  'uid': user.id, 'email': user.email,
  'grade': UserContextService.I.trackOrDefault,   // 'pa' | 'gpx'
  'track': UserContextService.I.trackOrDefault,
  'mode':  UserContextService.I.modeOrDefault,    // 'school'
  'module_name': _config?.title ?? _module,
  'quiz_name':   _config?.title ?? _module,
  'score': 0, 'total_questions': _questions.length, 'correct_count': 0,
  'started_at': DateTime.now().toUtc().toIso8601String(),
}).select('id').single();
```
Fin (même fichier `:386`) : si 0 réponse → `delete` de la ligne ; sinon
```dart
.update({
  'score': (_score * 100 ~/ answered).clamp(0, 100),   // pourcentage
  'correct_count': _score, 'total_questions': answered,  // nb de questions RÉPONDUES
  'finished_at': DateTime.now().toUtc().toIso8601String(),
  'completed_at': DateTime.now().toIso8601String(),     // timestamp sans TZ
}).eq('id', _historyRowId!).eq('uid', user.id);
```
Les quiz Dart (ex. `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_stad.dart:3767-3820`) font pareil mais avec `module_name` = **libellé du domaine** (« Crimes & délits contre les biens ») et `quiz_name` = **titre du quiz** (« Atteintes aux STAD »). Le web doit suivre cette convention (module_name = domaine, quiz_name = feuille) car le suivi classe par mots-clés sur ces champs.

Chaque réponse (`:416`) :
```dart
await LearningAnswerHistoryService().record(
  historyId: _historyRowId, track: track, mode: 'school',
  moduleKey: _module,                      // Dart legacy : q.category
  quizKey: 'quiz_scolarite_dynamique',     // Dart legacy : 'pa_quiz_stad', …
  questionId: q.stableKey,                 // legacy : '${q.category}:${index+1}'
  question: q.question, options: q.options, userAnswer: _selected ?? '',
  correctAnswer: q.answer, isCorrect: correct, explanation: q.explanation,
  difficulty: q.difficulty, responseTimeMs: …, questionPosition: _index + 1,
  questionVersion: q.revision.toString());
```
→ `rpc('record_learning_answer', {p_history_id, p_track, p_mode, p_module_key, p_quiz_key, p_question_id, p_question_text, p_options, p_user_answer, p_correct_answer, p_is_correct, p_explanation, p_difficulty, p_response_time_ms, p_question_position, p_client_event_id: uuid v4, p_question_version})`. Côté SQL : `auth.uid()` obligatoire, `p_track ∈ {pa,gpx}`, `p_mode ∈ {exam,school}`, `p_history_id` doit appartenir à l’appelant (sinon 42501), upsert idempotent sur `(user_id, client_event_id)` → `quiz_answer_history`. Hors ligne : file `copiq_learning_answer_offline_queue_v1` (500 max) rejouée par `flushPending()`.
Legacy Dart écrit en plus dans `quiz_<sujet>` (user_uid, email, grade, question, user_answer, correct_answer, is_correct, score, difficulty) — à ne pas reproduire sur le web sauf besoin de compatibilité.

Lecture du suivi : `PaSchoolProgressService` / `GpxSchoolProgressService` → `quiz_history` `eq(uid) eq(track,'pa'|'gpx') eq(mode,'school')` limit 750 + `enrichQuizProgress` (`quiz_answer_history` par `history_id`). Regroupement par mots-clés sur `quiz_name`/`module_name` : PA → institutions_valeurs / circulation_routiere / dps_dpg / intervention / fondamentaux ; GPX → institution_organisation / police_judiciaire / securite_routiere / intervention / public_victimes / fondamentaux (`pa_school_progress_service.dart:143-209`, `gpx_school_progress_service.dart:143-219`). Objectif quotidien : SharedPreferences `pa_school_daily_goal` (local). Reprise : `pa_school_last_route` / `pa_school_last_label`, deck : `pa_school_hero_deck_index` (local).
Journaux : `journal_pa_school.dart` (2 raccourcis en dur), `journal_gpx_school.dart` (Cours / Quiz), `journal_gpx_school_courses_page.dart` (reprend `gpxSchoolCategoriesConfig`) — secondaires.

## 5. Règles premium

- Source : `SubscriptionService` (`lib/core/services/subscription_service.dart`) : `isPremium` = RPC `is_user_premium` OU droit store ; quota gratuit hebdo table `free_weekly_usage`, consommé par RPC `consume_free_request` ; `isLocked = !isPremium && quota.remaining <= 0` (`:129`).
- `canAccessPremiumContent(state) => state.isPremium` (`lib/core/services/premium_guard.dart`).
- **PA** (`home_page_pa_school.dart:410-438`) : ouvrir un domaine **avec** sous-catégories = libre (liste visible) ; domaine **sans** sous-catégories = premium strict (`PremiumRequiredPage` `/premium-required`). Dans la liste, chaque `_ModuleCard` appelle `guardAppAccess` (`:2453`) = autorisé si premium **ou** quota restant > 0 (sinon dialogue) ; badge « Premium » affiché si `isLocked`. Deck : même règle (`:1368`).
- **GPX** (`home_page_gpx_school.dart:2030`) : **chaque feuille** exige `isPremium` strict → `PremiumRequiredPage` ; domaine sans sous-cat. idem (`:382`, `:1361`).
- Consommation du quota : `onRoutePushed` (NavigatorObserver) décompte 1 crédit pour toute route contenant `/quiz`, `quiz_`, `/gpx_exam`, `/pa_exam` si non premium et non verrouillé (anti-doublon 3 s) (`subscription_service.dart:297-330`). Les cours ne consomment pas.
- Côté données : RLS `cours_scolarite` lecture `authenticated` + `is_published`; `quiz_scolarite_questions` lecture `authenticated` + `is_active`. Aucun contrôle premium en base → le web doit garder le gating côté serveur (route handlers/RSC) avec `is_user_premium`.

## 6. Pattern visuel

- **Accueil école** (`home_page_pa_school.dart:464-725`) : en-tête « Bonjour {username} » (Poppins 22/w900) + « Bienvenue sur COP’IQ » ; bouton « Revenir à l’espace PA » + cercle école (`ModePickerScreen`) ; barre de recherche 44 px « Rechercher (ex: san, nat, arm...) » (auto-ouvre si 1 seul domaine correspond, ≥3 caractères, préfixe de mot normalisé sans accents) ; titre « Scolarité — Policier Adjoint » / « Sélection de contenu » ; **`_HeroDeck`** ; carte « prochaine étape » (`_PaSchoolNextStepCard`, CTA « Commencer … ») ; `ProgressCardV4` (« Ton suivi pendant la scolarité de Policier Adjoint ») ; barre de nav pilule glissante 5 onglets (home, insights, forum, favoris, profil).
- **`_HeroDeck`** = cartes empilées glissantes (pas une grille) : hauteur 330, `viewportFraction 0.78`, échelle 0.90→1.0, décalage x 52 / y 18, opacité .75→1, rayon 24, drag horizontal ; index initial = domaine « Cadres juridiques ». Chaque `_HeroCard` : image plein cadre (`CategoryConfig.image`), dégradé noir bas→haut (.65/.30/0, stops .05/.35/.75), cœur favori en haut à droite, badge (Poppins 12), titre Instrument Sans 20, note fictive « 4.9 (120) », CTA gris `#474B53` « Découvrir »/« Reprendre ».
- **Page domaine** `_CategoryDetailPage` : AppBar centrée (Fustat w900 18), fond `#FFFFFF` / sombre `#0E0F12`, **liste verticale** de `_ModuleCard` (hauteur min 190, image de couverture = `SubCategoryConfig.image` sinon heuristique `_imageFor(label)` par mots-clés, titre blanc 24, sous-titre blanc .85 14 via `_subtitleFor`, pastille « Premium », bouton rond CTA).
- **Pages de cours Dart** : intro « splash » (image plein écran + voile `#99000000→#D0000000`, titre machine-à-écrire dégradé `#FFFFFF→#D3E3FF`, bouton néon « COMMENCER » → route contenu) ; page de **cartes-chapitres** (fond `#FFFFFF`/`#373737`, cartes image + titre/sous-titre, hauteur adaptative `ScolariteText.adaptiveCardHeight` quand ≤4 cartes) ; lecteurs à pages glissantes (`PageView`, ~180 fichiers) ; leçons « premium sanction » (`sanction_pages/widgets/premium_sanction_lesson_page.dart`).
- **Fiche dynamique** `CoursScolaritePage` : accent unique `#2563EB`, fond `#F5F6F8`/`#101114`, Markdown via `parseCourseMarkdown` (paragraph, heading, listes, quote, divider, table ; simple retour ligne = coupure douce) + points clés + références légales.
- **Quiz dynamique** : fond `#F4F6FD`/`#071028`, couleur = `quiz_scolarite_modules.color_hex` (109 × `#1147D9`, 69 × `#C0392B`, natifs `#5B4BE8`, `#E8574B`, `#3FA34D`…), icône `quiz` (176) ou natives (balance, local_police, description, build…). Intro avec choix difficulté (Facile/Moyenne/Difficile/tous niveaux + compteurs), 15 questions, options mélangées, signalement.
- **Couleurs par domaine** : il n’y a **pas** de couleur par domaine dans les menus (identité portée par les images). Seules couleurs de domaine = méta du suivi : PA Institution `#2563EB`, Circulation `#0F766E`, DPS/DPG `#7C3AED`, Intervention `#EA580C`, Fondamentaux `#64748B` ; GPX idem + Accueil public/victimes `#DB2777`.
- Images : toutes en `assets/images/*` (liste par domaine/feuille §7) → à copier dans `public/images/` du site.

## 7. Pyramide complète par piste (libellés exacts, routes, sources)

Légende source : `Dart-page + ScolariteText fragments` = page Dart, texte dans `scolarite_content_fragments` (source_path = fichier) ; `DB-cours_scolarite(body_md)` = `CoursScolaritePage` ; `DB-quiz-module` = `QuizScolariteDynamiquePage` ; `Dart-quiz (hardcoded) → DB module OK` = écran Dart, questions déjà présentes sous la clé indiquée.

### 7.A Menus bruts (libellé — badge — image — route)

#### PA

##### institutionValeurs

- **Formation initiale** — badge «Bases & méthodo» — img `assets/images/copic_institutions.jpg` — `/pa/institution/formation_initiale`
  - [COURS] La formation initiale — `/pa/institution/formation_initiale/formation` img `assets/images/copic_institutions.jpg`
  - [COURS] Mémento prise de notes & méthodologie — `/pa/institution/formation_initiale/memento_notes` img `assets/images/concours_connaissances_generales.jpeg`
- **Organisation de la Police Nationale** — badge «Structures & rôles» — img `assets/images/background.jpeg` — `/pa/institution/organisation_pn`
  - [COURS] Organigramme du Ministère de l’Intérieur — `/pa/institution/organisation_pn/organigramme_mi` img `assets/images/organigramme_mi.jpeg`
  - [COURS] Organisation & Direction de la Police Nationale — `/pa/institution/organisation_pn/organisation`
  - [COURS] Direction générale de la sécurité intérieure — `/pa/institution/organisation_pn/dgsi` img `assets/images/dgsi.jpeg`
  - [COURS] Préfecture de police — `/pa/institution/organisation_pn/prefecture_police` img `assets/images/prefecture_police.jpeg`
  - [COURS] Organigrammes — `/pa/institution/organisation_pn/organigrammes`
  - [COURS] Hiérarchie des personnels de la Police Nationale — `/pa/institution/organisation_pn/hierarchie` img `assets/images/hierarchie_police.jpeg`
  - [COURS] Règles d’emploi des policiers adjoints — `/pa/institution/organisation_pn/regles_emploi_pa` img `assets/images/regles_emploi_pa.jpeg`
  - [COURS] Horaires de service en sécurité publique — `/pa/institution/organisation_pn/horaires_service_sp` img `assets/images/horaires_service_sp.jpeg`
  - [QUIZ] Quiz — Organisation de la Police Nationale — `/pa/institution/organisation_pn/quiz` img `assets/images/quiz.jpeg`
- **Déontologie** — badge «Éthique & cadre» — img `assets/images/cat_organisation.jpg` — `/pa/institution/deontologie`
  - [COURS] Code de déontologie commenté (PN & GN) — `/pa/institution/deontologie/code_commente` img `assets/images/code_commente.webp`
  - [COURS] Marques extérieures de respect (salut, présentation) — `/pa/institution/deontologie/marques_respect` img `assets/images/marques_respect.jpeg`
  - [COURS] Droits & obligations des policiers — `/pa/institution/deontologie/droits_obligations`
  - [COURS] Policier hors service : dois-je intervenir ? (AMARIS) — `/pa/institution/deontologie/hors_service_amaris` img `assets/images/hors_service_amaris.jpeg`
  - [COURS] Sanctions & récompenses — `/pa/institution/deontologie/sanctions_recompenses` img `assets/images/sanction.jpeg`
  - [COURS] Enquête administrative — `/pa/institution/deontologie/enquete_administrative`
  - [COURS] Usage des réseaux sociaux — `/pa/institution/deontologie/reseaux_sociaux` img `assets/images/reseaux_sociaux.jpg`
  - [QUIZ] Quiz — Déontologie — `/pa/institution/deontologie/quiz` img `assets/images/quiz.jpeg`
- **Information de la hiérarchie** — badge «Écrits pro» — img `assets/images/cat_hierarchie.jpg` — `/pa/institution/hierarchie_info`
  - [COURS] Le compte-rendu — `/pa/institution/hierarchie_info/compte_rendu` img `assets/images/compte_rendu.jpeg`
  - [COURS] Le formalisme du rapport — `/pa/institution/hierarchie_info/formalisme_rapport` img `assets/images/formalisme_rapport.jpeg`
  - [COURS] Modèles de rapports — `/pa/institution/hierarchie_info/modeles` img `assets/images/modeles.jpeg`
- **Accueil du public** — badge «Victimes & assistance» — img `assets/images/image1.jpeg` — `/pa/institution/accueil_public`
  - [COURS] Charte de l’accueil du public & assistance aux victimes — `/pa/institution/accueil_public/charte` img `assets/images/charte.jpeg`
  - [COURS] Référentiel Marianne — `/pa/institution/accueil_public/marianne` img `assets/images/marianne.jpg`
  - [COURS] Dépliants & doctrine accueil / prise en charge — `/pa/institution/accueil_public/doctrine` img `assets/images/doctrine.jpeg`
  - [COURS] Quelques démarches administratives — `/pa/institution/accueil_public/demarches`
  - [COURS] Protection des locaux de police — `/pa/institution/accueil_public/protection_locaux` img `assets/images/protection_locaux.jpeg`
  - [QUIZ] Quiz — Accueil du public — `/pa/institution/accueil_public/quiz` img `assets/images/quiz.jpeg`
- **Laïcité, police et religions** — badge «Neutralité» — img `assets/images/image6.jpg` — `/pa/institution/laicite`
  - [COURS] La laïcité (DLPAJ / bureau des cultes) — `/pa/institution/laicite/laicite_dlpaj` img `assets/images/laicite_dlpaj.jpeg`
  - [COURS] Charte de la laïcité dans les services publics — `/pa/institution/laicite/charte` img `assets/images/charte_laicite.jpeg`
  - [COURS] Principaux rites & pratiques des cultes en France — `/pa/institution/laicite/rites_cultes` img `assets/images/rites_cultes.jpeg`
  - [QUIZ] Quiz — Laïcité — `/pa/institution/laicite/quiz` img `assets/images/image6.jpg`
- **Histoire de la police** — badge «Repères» — img `assets/images/image4.jpeg` — `/pa/institution/histoire`
  - [COURS] Points de repères chronologiques — `/pa/institution/histoire/reperes`

##### dpsDpg

- **Généralités** — badge «Socle initial» — img `assets/images/generalite.jpeg` — `/pa/dps_dpg/socle_initial/generalites`
  - [COURS] Classification des infractions — `/pa/dps_dpg/socle_initial/generalites/classification_infractions`
  - [COURS] L’infraction — `/pa/dps_dpg/socle_initial/generalites/infraction_intro`
  - [COURS] La tentative punissable — `/pa/dps_dpg/socle_initial/generalites/tentative_intro`
  - [COURS] La complicité — `/pa/dps_dpg/socle_initial/generalites/complicite_intro`
  - [COURS] La légitime défense — `/pa/dps_dpg/socle_initial/generalites/legitimedefense_intro`
  - [COURS] Cadre légal d’usage des armes — `/pa/dps_dpg/socle_initial/generalites/usagedesarmes_intro`
  - [COURS] Les libertés publiques — `/pa/dps_dpg/libertes_publiques_intro`
  - [COURS] Rétention dans les locaux de police — `/pa/dps_dpg/socle_initial/generalites/retention_locaux_police_intro`
- **Hiérarchie — fonctions judiciaires** — badge «Socle initial» — img `assets/images/cat_hierarchie.jpg` — `/pa/dps_dpg/socle_initial/hierarchie`
  - [COURS] Hiérarchie des personnels de la Police Nationale — `/pa/dps_dpg/socle_initial/hierarchie/hierarchie_intro`
- **Cadres juridiques** — badge «Socle initial» — img `assets/images/cadres_juridiques.jpeg` — `/pa/dps_dpg/socle_initial/cadres_juridiques`
  - [COURS] Les cadres d'enquête — `/pa/dps_dpg/cadres_juridiques/cadres_enquete_intro`
  - [COURS] L'enquête de flagrant délit — `/pa/dps_dpg/cadres_juridiques/flagrant_delit_intro`
  - [COURS] L'enquête préliminaire — `/pa/dps_dpg/cadres_juridiques/enquete_preliminaire_intro`
  - [COURS] La commission rogatoire — `/pa/dps_dpg/cadres_juridiques/commission_rogatoire_intro`
  - [COURS] Découverte d'une personne grièvement blessée — `/pa/dps_dpg/cadres_juridiques/personne_blessee_intro`
  - [COURS] Mort de cause inconnue ou suspecte — `/pa/dps_dpg/cadres_juridiques/mort_inconnue/intro`
  - [COURS] Délinquance & criminalité organisées — `/pa/dps_dpg/cadres_juridiques/criminalite_organisee_contenu`
  - [COURS] Recherche des personnes en fuite — `/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/intro`
  - [COURS] Disparitions inquiétantes — `/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes_intro`
- **Armes & munitions** — badge «Régimes spéciaux» — img `assets/images/armes_munitions.jpeg` — `/pa/dps_dpg/socle_initial/armes_munitions`
  - [COURS] Classification des armes et des munitions — `/pa/dps_dpg/armes_munitions_pages/armes_classification`
  - [COURS] Définitions — `/pa/dps_dpg/armes_munitions_pages/armes_definitions`
  - [COURS] Introduction — `/pa/dps_dpg/armes_munitions_pages/armes_introduction`
  - [COURS] Acquisition/détention cat. A ou B sans autorisation — `/pa/dps_dpg/armes_munitions_pages/armes_acquisition_detention_ab`
  - [COURS] Port/transport sans motif légitime (cat. C ou D) — `/pa/dps_dpg/armes_munitions_pages/armes_port_transport_cd`
  - [COURS] Régimes matériels de guerre / éléments d’arme — `/pa/dps_dpg/armes_munitions_pages/armes_materiels_guerre_elements`
  - [COURS] Règles d’acquisition & détention — `/pa/dps_dpg/armes_munitions_pages/armes_regles_acquisition_detention`
  - [COURS] Règles de port & transport — `/pa/dps_dpg/armes_munitions_pages/armes_regles_port_transport`
  - [QUIZ] Quiz — Classification des armes et des munitions — `/pa/armes_munitions_pages/quiz/pa_quiz_armes_munitions_pages` img `assets/images/quiz.jpeg`
- **La sanction** — badge «Peines & sûreté» — img `assets/images/sanction.jpeg` — `/pa/dps_dpg/sanctions`
  - [COURS] Classification des peines et mesures de sûreté — `/pa/dps_dpg/sanctions/classification_peines`
  - [COURS] Causes d’aggravation de la sanction — `/pa/dps_dpg/sanctions/causes_aggravation_sanction`
  - [COURS] Règles en cas de pluralité d’infractions — `/pa/dps_dpg/sanctions/pluralite_infractions`
  - [QUIZ] Quiz — Sanction (récidive, réitération, concours réel) — `/pa/sanction/quiz/sanction_page`
- **Crimes & délits contre la nation** — badge «Institutions & justice» — img `assets/images/contre_nation.jpeg` — `/pa/dps_dpg/crimes_nation`
  - [COURS] Association de malfaiteurs — `/pa/dps_dpg/atteintes_nation_pages/association_malfaiteurs`
  - [COURS] Abus d’autorité contre les particuliers — `/pa/dps_dpg/atteintes_nation_pages/abus_autorite`
  - [COURS] Atteintes à l’action de la justice — `/pa/dps_dpg/atteintes_nation_pages/atteintes_action_justice`
  - [COURS] Atteintes à l’administration par des particuliers — `/pa/dps_dpg/socle_initial/autorite_etat/outrage`
  - [COURS] Faux et usage de faux — `/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux`
  - [COURS] Manquements au devoir de probité — `/pa/dps_dpg/atteintes_nation_pages/probite`
  - [QUIZ] Quiz — Abus d’autorité contre les particuliers — `/pa/nation/quiz/abus_autorite_particuliers`
  - [QUIZ] Quiz — Atteintes à l’action de la justice — `/pa/nation/quiz/atteintes_action_justice`
  - [QUIZ] Quiz — Atteintes à l’administration — `/pa/nation/quiz/atteintes_administration`
  - [QUIZ] Quiz — Faux et usage de faux — `/pa/nation/quiz/faux_usage_faux`
  - [QUIZ] Quiz — Manquements au devoir de probité — `/pa/nation/quiz/probite`
- **Atteintes aux mineurs & à la famille** — badge «Protection des mineurs» — img `assets/images/mineurs_famille.jpeg` — `/pa/dps_dpg/mineurs_famille`
  - [COURS] La mise en péril des mineurs — `/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril`
  - [COURS] Violation d’ordonnances JAF (violences) — `/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf`
  - [COURS] Atteintes à l’exercice de l’autorité parentale — `/pa/dps_dpg/mineurs_famille_pages/autorite_parentale`
  - [COURS] L’abandon de famille — `/pa/dps_dpg/mineurs_famille_pages/abandon_famille`
  - [QUIZ] Quiz — L’abandon de famille — `/pa/mineurs_famille_pages/quiz/pa_quiz_mineurs_famille`
- **Procédure Pénale** — badge «Cours & cas pratiques» — img `assets/images/procedure_penale.jpg` — `/pa/dps_dpg/procedure_penale`
  - [COURS] Action publique, action civile, autorités & contrôle de la PJ — `/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile_intro`
  - [COURS] Nullité des actes de procédure — `/pa/dps_dpg/procedure_penale/nullite_intro_page`
  - [COURS] Juridictions de jugement & exécution des décisions — `/pa/dps_dpg/procedure_penale/juridictions_contenu`
  - [COURS] Instruction préparatoire, mandats, contrôle jud., détention provisoire — `/pa/dps_dpg/procedure_penale/pp_instruction_mandats_controle_detention`
  - [QUIZ] Quiz — Action publique — `/pa/procedure_penale/quiz/action_publique`
  - [QUIZ] Quiz — Nullité des actes de procédure — `/pa/procedure_penale/quiz/nullite`
  - [QUIZ] Quiz — Juridictions pénales — `/pa/procedure_penale/quiz/juridictions_penales`
  - [QUIZ] Quiz — Instruction préparatoire, mandats & détention provisoire — `/pa/procedure_penale/quiz/instruction_preparatoire`
- **Contrôle d'identité** — badge «Socle initial» — img `assets/images/controle_identite.jpeg` — `/pa/dps_dpg/socle_initial/controle_identite`
  - [COURS] Contrôles et vérifications d'identité — `/pa/dps_dpg/cadres_juridiques/controle_identite`
- **Circulation routière** — badge «Socle initial» — img `assets/images/circulation_routiere.jpeg` — `/pa/dps_dpg/socle_initial/circulation`
  - [COURS] Compétences des agents verbalisateurs — `/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs` img `assets/images/agents_verbalisateurs.png`
  - [COURS] Conduite après usage de stupéfiants — `/pa/dps_dpg/socle_initial/circulation/conduite_stupefiants`
  - [COURS] Conduite en état d'ivresse — `/pa/dps_dpg/socle_initial/circulation/ivresse`
  - [COURS] Conduite sous l'empire d'un état alcoolique — `/pa/dps_dpg/socle_initial/circulation/etat_alcoolique`
  - [COURS] Défaut d'assurance — `/pa/dps_dpg/socle_initial/circulation/defaut_assurance`
  - [COURS] Défaut de permis de conduire — `/pa/dps_dpg/socle_initial/circulation/defaut_permis`
  - [COURS] Délit de fuite — `/pa/dps_dpg/socle_initial/circulation/delit_fuite`
  - [COURS] Grand excès de vitesse — `/pa/dps_dpg/socle_initial/circulation/grand_exces_vitesse`
  - [COURS] Refus de vérifications — `/pa/dps_dpg/socle_initial/circulation/refus_verifications`
  - [COURS] Refus d'obtempérer — `/pa/dps_dpg/socle_initial/circulation/refus_obtemperer`
  - [COURS] Rodéo motorisé — `/pa/dps_dpg/socle_initial/circulation/rodeo_motorise`
  - [COURS] Plaques & inscriptions (délits liés) — `/pa/dps_dpg/socle_initial/circulation/plaques_inscriptions`
  - [COURS] Incitation / organisation / promotion — `/pa/dps_dpg/socle_initial/circulation/incitation_organisation_promotion` img `assets/images/incitation.png`
  - [QUIZ] Quiz — Infractions à la circulation routière — `/pa/dps_dpg/quiz/quiz_circulation_routiere`
- **Organisation judiciaire** — badge «Socle initial» — img `assets/images/cat_organisation.jpg` — `/pa/dps_dpg/socle_initial/organisation_judiciaire`
  - [COURS] L’organisation judiciaire — `/pa/dps_dpg/socle_initial/organisation_judiciaire/organisation`
  - [COURS] La magistrature — `/pa/dps_dpg/socle_initial/organisation_judiciaire/magistrature` img `assets/images/magistrature.png`
- **Atteintes aux biens** — badge «Socle initial» — img `assets/images/atteintes_biens.jpeg` — `/pa/dps_dpg/socle_initial/atteintes_biens`
  - [COURS] Le vol — `/pa/dps_dpg/socle_initial/atteintes_biens/vol`
  - [COURS] Destructions, dégradations, détériorations — `/pa/dps_dpg/socle_initial/atteintes_biens/destructions`
  - [COURS] Infractions sans danger pour les personnes — `/pa/dps_dpg/socle_initial/atteintes_biens/sans_danger_personnes`
  - [COURS] Infractions dangereuses pour les personnes — `/pa/dps_dpg/socle_initial/atteintes_biens/dangereuses_personnes`
  - [COURS] Tags et graffitis — `/pa/dps_dpg/socle_initial/atteintes_biens/tags_graffitis` img `assets/images/tags_graffitis.png`
- **Atteintes aux personnes** — badge «Socle initial» — img `assets/images/atteintes_personnes.jpeg` — `/pa/dps_dpg/socle_initial/atteintes_personnes`
  - [COURS] Les discriminations — `/pa/dps_dpg/socle_initial/atteintes_personnes/discriminations` img `assets/images/discriminations.png`
  - [COURS] Les violences volontaires — `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_volontaires`
  - [COURS] Les violences habituelles — `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_habituelles`
  - [COURS] Violences contre les forces de sécurité intérieure — `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_fsi` img `assets/images/violence_pdap.png`
  - [COURS] Atteintes volontaires à la vie — `/pa/dps_dpg/socle_initial/atteintes_personnes/atteintes_vie`
  - [COURS] Le viol — `/pa/dps_dpg/socle_initial/atteintes_personnes/viol`
  - [COURS] Agressions sexuelles — `/pa/dps_dpg/socle_initial/atteintes_personnes/agressions_sexuelles`
  - [COURS] Harcèlement sexuel — `/pa/dps_dpg/socle_initial/atteintes_personnes/harcelement_sexuel`
  - [COURS] Exhibition sexuelle — `/pa/dps_dpg/socle_initial/atteintes_personnes/exhibition`
  - [COURS] Mise en péril des mineurs — `/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril`
  - [COURS] Atteinte à l’intimité d’une personne — `/pa/dps_dpg/socle_initial/atteintes_personnes/atteinte_intimite`
  - [COURS] Outrage sexiste et sexuel — `/pa/dps_dpg/socle_initial/atteintes_personnes/outrage_sexiste` img `assets/images/outrage_sexiste.png`
- **Autorité de l’État** — badge «Socle initial» — img `assets/images/autorite_etat.png` — `/pa/dps_dpg/socle_initial/autorite_etat`
  - [COURS] Refus d’obtempérer — `/pa/dps_dpg/socle_initial/autorite_etat/refus_obtemperer` img `assets/images/refus_obtemperer_pn.png`
  - [COURS] L’outrage — `/pa/dps_dpg/socle_initial/autorite_etat/outrage` img `assets/images/outrage_pn.png`
  - [COURS] La rébellion — `/pa/dps_dpg/socle_initial/autorite_etat/rebellion` img `assets/images/rebellion_pn.png`
  - [COURS] Provocation directe à la rébellion — `/pa/dps_dpg/socle_initial/autorite_etat/provocation_rebellion` img `assets/images/provocation_rebellion_pn.png`
- **Généralités** — badge «Socle avancé» — img `assets/images/droit_penal_general.jpeg` — `/pa/dps_dpg/socle_avance/generalites`
  - [COURS] Le droit pénal — `/pa/dps_dpg/socle_avance/generalites/droit_penal` img `assets/images/droit_penal_generalite.png`
  - [COURS] Immunités et inviolabilités — `/pa/dps_dpg/socle_avance/generalites/immunites_inviolabilites` img `assets/images/immunite.png`
  - [COURS] La responsabilité pénale — `/pa/dps_dpg/socle_avance/generalites/responsabilite_penale` img `assets/images/responsabilite_penale.png`
- **Acteurs de la Police Judiciaire** — badge «Socle avancé» — img `assets/images/police_judiciaire.png` — `/pa/dps_dpg/socle_avance/acteurs_pj`
  - [COURS] Compétences des OPJ — `/pa/dps_dpg/socle_avance/acteurs_pj/opj` img `assets/images/opj.png`
  - [COURS] Compétences des APJ — `/pa/dps_dpg/socle_avance/acteurs_pj/apj` img `assets/images/gardien_de_la_paix.png`
  - [COURS] Assistants d’enquête — `/pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete` img `assets/images/assistant_enquete.png`
  - [COURS] Prérogatives judiciaires (OPJ / APJ / APJA) — `/pa/dps_dpg/socle_avance/acteurs_pj/prerogatives` img `assets/images/prerogative.png`
  - [COURS] Le procureur de la République — `/pa/dps_dpg/socle_avance/acteurs_pj/procureur` img `assets/images/procureur.png`
  - [COURS] Le juge d’instruction — `/pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction` img `assets/images/juge_instruction.png`
- **Atteintes aux biens** — badge «Socle avancé» — img `assets/images/atteintes_biens.jpeg` — `/pa/dps_dpg/socle_avance/atteintes_biens`
  - [COURS] L’extorsion — `/pa/dps_dpg/socle_avance/atteintes_biens/extorsion` img `assets/images/extorsion.png`
  - [COURS] L’escroquerie — `/pa/dps_dpg/socle_avance/atteintes_biens/escroquerie` img `assets/images/escroquerie.png`
  - [COURS] L’abus de confiance — `/pa/dps_dpg/socle_avance/atteintes_biens/abus_confiance` img `assets/images/abus_confiance.png`
  - [COURS] La filouterie — `/pa/dps_dpg/socle_avance/atteintes_biens/filouterie` img `assets/images/filouterie.png`
  - [COURS] Le recel — `/pa/dps_dpg/socle_avance/atteintes_biens/recel` img `assets/images/recel_vol.png`
  - [COURS] Abstention volontaire de combattre un sinistre — `/pa/dps_dpg/socle_avance/atteintes_biens/abstention_sinistre` img `assets/images/abstention_volontaire.png`
- **Atteintes aux personnes** — badge «Socle avancé» — img `assets/images/contre_personne.jpeg` — `/pa/dps_dpg/socle_avance/atteintes_personnes`
  - [COURS] Atteintes involontaires à la vie et à l’intégrité — `/pa/dps_dpg/socle_avance/atteintes_personnes/involontaires` img `assets/images/atteintes_involontaires.png`
  - [COURS] Menaces contre les personnes — `/pa/dps_dpg/socle_avance/atteintes_personnes/menaces` img `assets/images/menaces.png`
  - [COURS] Entrave volontaire à l’arrivée des secours — `/pa/dps_dpg/socle_avance/atteintes_personnes/entrave_secours` img `assets/images/entrave_secours.png`
  - [COURS] Non-obstacle à la commission d’un crime ou délit — `/pa/dps_dpg/socle_avance/atteintes_personnes/non_obstacle` img `assets/images/non_obstacle.png`
  - [COURS] Non-assistance à personne en péril — `/pa/dps_dpg/socle_avance/atteintes_personnes/non_assistance` img `assets/images/non_assistance.png`
  - [COURS] Appels téléphoniques malveillants — `/pa/dps_dpg/socle_avance/atteintes_personnes/appels_malveillants` img `assets/images/appels_malveillants.png`
  - [COURS] Risque causé à autrui — `/pa/dps_dpg/socle_avance/atteintes_personnes/risque_autrui` img `assets/images/risque_autrui.png`
- **Délits routiers** — badge «Socle avancé» — img `assets/images/circulation_routiere.jpeg` — `/pa/dps_dpg/socle_avance/delits_routiers`
  - [COURS] Rodéo motorisé — `/pa/dps_dpg/socle_avance/delits_routiers/rodeo`
  - [COURS] Incitation / organisation / promotion — `/pa/dps_dpg/socle_avance/delits_routiers/incitation` img `assets/images/incitation.png`
  - [COURS] Délit de fuite — `/pa/dps_dpg/socle_avance/delits_routiers/delit_fuite`
  - [COURS] Refus d’obtempérer — `/pa/dps_dpg/socle_avance/delits_routiers/refus_obtemperer` img `assets/images/refus_obtemperer.png`
  - [COURS] Autres délits routiers (alcool, stup, permis, vérifications…) — `/pa/dps_dpg/socle_avance/delits_routiers/autres` img `assets/images/autres_delits_routiers.png`
- **Autorité de l’État** — badge «Socle avancé» — img `assets/images/autorite_etat.png` — `/pa/dps_dpg/socle_avance/autorite_etat`
  - [COURS] Menaces envers les dépositaires de l’autorité publique — `/pa/dps_dpg/socle_avance/autorite_etat/menaces` img `assets/images/menaces_pdap.png`
  - [COURS] Corruption passive — `/pa/dps_dpg/socle_avance/autorite_etat/corruption_passive` img `assets/images/corruption_passive.png`
  - [COURS] Corruption active — `/pa/dps_dpg/socle_avance/autorite_etat/corruption_active` img `assets/images/corruption_active.png`
- **Stupéfiants** — badge «Socle avancé» — img `assets/images/stupefiants.jpeg` — `/pa/dps_dpg/socle_avance/stupefiants`
  - [COURS] Usage illicite de stupéfiants — `/pa/dps_dpg/socle_avance/stupefiants/usage_illicite`
  - [COURS] Cession / offre illicites (consommation personnelle) — `/pa/dps_dpg/socle_avance/stupefiants/cession_offre`

##### mememtoCirculationRoutiere

- **Procédures circulation routière** — badge «Procédures» — img `assets/images/memento_procedures.jpeg` — `/pa/memento_circulation/procedures`
  - [COURS] L’amende forfaitaire — `/pa/memento_circulation/procedures/amende_forfaitaire` img `assets/images/amende_forfaitaire.jpeg`
  - [COURS] L’amende forfaitaire délictuelle — `/pa/memento_circulation/procedures/amende_forfaitaire_delictuelle` img `assets/images/amende_forfaitaire_delictuelle.jpeg`
  - [COURS] La consignation — `/pa/memento_circulation/procedures/consignation` img `assets/images/consignation.jpeg`
  - [COURS] L’immobilisation du véhicule — `/pa/memento_circulation/procedures/immobilisation` img `assets/images/immobilisation.jpeg`
  - [COURS] La mise en fourrière — `/pa/memento_circulation/procedures/mise_en_fourriere` img `assets/images/mise_en_fourriere.jpeg`
  - [COURS] La conduite sous l’influence de l’alcool — `/pa/memento_circulation/procedures/conduite_alcool` img `assets/images/ivresse.jpeg`
  - [COURS] La conduite après usage de stupéfiants — `/pa/memento_circulation/procedures/conduite_stupefiants` img `assets/images/stupefiants.jpeg`
  - [COURS] La rétention du permis de conduire — `/pa/memento_circulation/procedures/retention_permis` img `assets/images/retention_permis.jpeg`
  - [COURS] Le permis à points — `/pa/memento_circulation/procedures/permis_a_points` img `assets/images/permis_points.jpeg`
  - [QUIZ] Quiz — Procédures circulation — `/pa/memento_circulation/procedures/quiz` img `assets/images/quiz.jpeg`
- **Contrôle routier & pièces** — badge «Contrôle» — img `assets/images/memento_controle_routier.jpeg` — `/pa/memento_circulation/controle_routier`
  - [COURS] Le cadre légal du contrôle routier — `/pa/memento_circulation/controle_routier/cadre_legal` img `assets/images/cadres_juridiques.jpeg`
  - [COURS] Le permis de conduire — `/pa/memento_circulation/controle_routier/permis_conduire` img `assets/images/permis_conduire.jpeg`
  - [COURS] Le brevet de sécurité routière — `/pa/memento_circulation/controle_routier/bsr` img `assets/images/bsr.jpeg`
  - [COURS] Les certificats d’immatriculation — `/pa/memento_circulation/controle_routier/certificat_immatriculation` img `assets/images/certificat_immatriculation.jpeg`
  - [COURS] Le contrôle technique des véhicules — `/pa/memento_circulation/controle_routier/controle_technique` img `assets/images/controle_technique.jpeg`
  - [COURS] L’assurance — `/pa/memento_circulation/controle_routier/assurance_obligatoire` img `assets/images/assurance_obligatoire.jpeg`
  - [QUIZ] Quiz — Contrôle routier — `/pa/memento_circulation/controle_routier/quiz` img `assets/images/quiz.jpeg`
- **Équipements véhicules & usagers** — badge «Équipements» — img `assets/images/memento_equipements.jpeg` — `/pa/memento_circulation/equipements`
  - [COURS] Les pneumatiques — `/pa/memento_circulation/equipements/pneumatiques` img `assets/images/pneumatiques.jpeg`
  - [COURS] Éclairage et signalisation — `/pa/memento_circulation/equipements/eclairage_signalisation` img `assets/images/eclairage_signalisation.jpeg`
  - [COURS] Chargement — `/pa/memento_circulation/equipements/chargement` img `assets/images/chargement.jpeg`
  - [COURS] Les plaques — `/pa/memento_circulation/equipements/plaques` img `assets/images/plaques.jpeg`
  - [COURS] Miroirs / rétroviseurs / vision indirecte — `/pa/memento_circulation/equipements/retroviseurs_vision` img `assets/images/retroviseurs.jpeg`
  - [COURS] Les essuie-glace — `/pa/memento_circulation/equipements/essuie_glace` img `assets/images/essuie_glace.jpeg`
  - [COURS] Nuisances des véhicules (fumées, bruit, avertisseur sonore) — `/pa/memento_circulation/equipements/nuisances` img `assets/images/nuisances.jpeg`
  - [COURS] Ceinture de sécurité / retenue enfant — `/pa/memento_circulation/equipements/ceinture_retenue_enfant` img `assets/images/ceinture_retenue_enfant.jpeg`
  - [COURS] Casque et gants de protection — `/pa/memento_circulation/equipements/casque_gants` img `assets/images/casque_gants.jpeg`
  - [COURS] Casque "cycliste" — `/pa/memento_circulation/equipements/casque_cycliste` img `assets/images/casque_cycliste.jpeg`
  - [COURS] Gilet de haute visibilité — `/pa/memento_circulation/equipements/gilet_haute_visibilite` img `assets/images/gilet_haute_visibilite.jpeg`
  - [QUIZ] Quiz — Équipements — `/pa/memento_circulation/equipements/quiz` img `assets/images/quiz.jpeg`

#### GPX

##### institutionValeurs

- **Formation initiale** — badge «Bases & méthodo» — img `assets/images/copic_institutions.jpg` — `/gpx/institution/formation_initiale`
  - [COURS] La formation initiale — `/gpx/institution/formation_initiale/formation` img `assets/images/copic_institutions.jpg`
  - [COURS] Mémento prise de notes & méthodologie — `/gpx/institution/formation_initiale/memento_notes` img `assets/images/concours_connaissances_generales.jpeg`
- **Organisation de la Police Nationale** — badge «Structures & rôles» — img `assets/images/background.jpeg` — `/gpx/institution/organisation_pn`
  - [COURS] Organigramme du Ministère de l’Intérieur — `/gpx/institution/organisation_pn/organigramme_mi` img `assets/images/organigramme_mi.jpeg`
  - [COURS] Organisation & Direction de la Police Nationale — `/gpx/institution/organisation_pn/organisation`
  - [COURS] Direction générale de la sécurité intérieure — `/gpx/institution/organisation_pn/dgsi` img `assets/images/dgsi.jpeg`
  - [COURS] Préfecture de police — `/gpx/institution/organisation_pn/prefecture_police` img `assets/images/prefecture_police.jpeg`
  - [COURS] Organigrammes — `/gpx/institution/organisation_pn/organigrammes`
  - [COURS] Hiérarchie des personnels de la Police Nationale — `/gpx/institution/organisation_pn/hierarchie` img `assets/images/hierarchie_police.jpeg`
  - [COURS] Règles d’emploi des policiers adjoints — `/gpx/institution/organisation_pn/regles_emploi_pa` img `assets/images/regles_emploi_pa.jpeg`
  - [COURS] Horaires de service en sécurité publique — `/gpx/institution/organisation_pn/horaires_service_sp` img `assets/images/horaires_service_sp.jpeg`
  - [QUIZ] Quiz — Organisation (global) — `/gpx/institution/organisation_pn/quiz` img `assets/images/quiz.jpeg`
- **Déontologie** — badge «Éthique & cadre» — img `assets/images/cat_organisation.jpg` — `/gpx/institution/deontologie`
  - [COURS] Code de déontologie commenté (PN & GN) — `/gpx/institution/deontologie/code_commente` img `assets/images/code_commente.webp`
  - [COURS] Marques extérieures de respect (salut, présentation) — `/gpx/institution/deontologie/marques_respect` img `assets/images/marques_respect.jpeg`
  - [COURS] Droits & obligations des policiers — `/gpx/institution/deontologie/droits_obligations`
  - [COURS] Policier hors service : dois-je intervenir ? (AMARIS) — `/gpx/institution/deontologie/hors_service_amaris` img `assets/images/hors_service_amaris.jpeg`
  - [COURS] Sanctions & récompenses — `/gpx/institution/deontologie/sanctions_recompenses` img `assets/images/sanction.jpeg`
  - [COURS] Enquête administrative — `/gpx/institution/deontologie/enquete_administrative`
  - [COURS] Usage des réseaux sociaux — `/gpx/institution/deontologie/reseaux_sociaux` img `assets/images/reseaux_sociaux.jpg`
  - [QUIZ] Quiz — Déontologie — `/gpx/institution/deontologie/quiz` img `assets/images/quiz.jpeg`
- **Information de la hiérarchie** — badge «Écrits pro» — img `assets/images/cat_hierarchie.jpg` — `/gpx/institution/hierarchie_info`
  - [COURS] Le compte-rendu — `/gpx/institution/hierarchie_info/compte_rendu` img `assets/images/compte_rendu.jpeg`
  - [COURS] Le formalisme du rapport — `/gpx/institution/hierarchie_info/formalisme_rapport` img `assets/images/formalisme_rapport.jpeg`
  - [COURS] Modèles de rapports — `/gpx/institution/hierarchie_info/modeles` img `assets/images/modeles.jpeg`
- **Accueil du public** — badge «Victimes & assistance» — img `assets/images/image1.jpeg` — `/gpx/institution/accueil_public`
  - [COURS] Charte de l’accueil du public & assistance aux victimes — `/gpx/institution/accueil_public/charte` img `assets/images/charte.jpeg`
  - [COURS] Référentiel Marianne — `/gpx/institution/accueil_public/marianne` img `assets/images/marianne.jpg`
  - [COURS] Dépliants & doctrine accueil / prise en charge — `/gpx/institution/accueil_public/doctrine` img `assets/images/doctrine.jpeg`
  - [COURS] Quelques démarches administratives — `/gpx/institution/accueil_public/demarches`
  - [COURS] Protection des locaux de police — `/gpx/institution/accueil_public/protection_locaux` img `assets/images/protection_locaux.jpeg`
  - [QUIZ] Quiz — Accueil du public — `/gpx/institution/accueil_public/quiz` img `assets/images/quiz.jpeg`
- **Laïcité, police et religions** — badge «Neutralité» — img `assets/images/image6.jpg` — `/gpx/institution/laicite`
  - [COURS] La laïcité (DLPAJ / bureau des cultes) — `/gpx/institution/laicite/laicite_dlpaj` img `assets/images/laicite_dlpaj.jpeg`
  - [COURS] Charte de la laïcité dans les services publics — `/gpx/institution/laicite/charte` img `assets/images/charte_laicite.jpeg`
  - [COURS] Principaux rites & pratiques des cultes en France — `/gpx/institution/laicite/rites_cultes` img `assets/images/rites_cultes.jpeg`
  - [QUIZ] Quiz — Laïcité — `/gpx/institution/laicite/quiz` img `assets/images/quiz.jpeg`
- **Histoire de la police** — badge «Repères» — img `assets/images/image4.jpeg` — `/gpx/institution/histoire`
  - [COURS] Points de repères chronologiques — `/gpx/institution/histoire/reperes`

##### dpsDpg

- **Généralités** — badge «Concepts de base» — img `assets/images/generalite.jpeg` — `/gpx_scolarite_pages/generalite_pages`
  - [COURS] Classification des infractions — `/gpx/generalites/classification_infractions`
  - [COURS] L'infraction — `/gpx/generalites/infraction_intro`
  - [COURS] La tentative punissable — `/gpx/generalites/tentative_intro`
  - [COURS] La complicité — `/gpx/generalites/complicite_intro`
  - [COURS] La légitime défense — `/gpx/generalites/legitimedefense_intro`
  - [COURS] Cadre légal d'usage des armes — `/gpx/generalites/usagedesarmes_intro`
  - [COURS] Les libertés publiques — `/gpx/generalites/libertespubliques_intro`
  - [COURS] Cas de rétention dans les locaux de police — `/gpx/generalites/retention_locaux_police_intro`
  - [COURS] La hiérarchie des personnels de la Police Nationale : Fonctions judiciaires — `/gpx/generalites/hierarchie_intro`
  - [QUIZ] Quiz généralités, classification des infractions, infraction, tentative punissable etc.. — `/gpx/procedure_penale/quiz/generalité_principales`
- **Cadres juridiques** — badge «Cadres d'enquête» — img `assets/images/cadres_juridiques.jpeg` — `/gpx_scolarite_pages/cadres_juridiques_pages`
  - [COURS] Les cadres d'enquête — `/gpx/generalites/cadres_enquete_intro`
  - [COURS] L’enquête de flagrant délit — `/gpx/generalites/flagrant_delit_intro`
  - [COURS] L’enquête préliminaire — `/gpx/generalites/enquete_preliminaire_intro`
  - [COURS] La commission rogatoire — `/gpx/generalites/commission_rogatoire_intro`
  - [COURS] Découverte d’une personne grièvement blessée — `/gpx/generalites/personne_blessee_intro`
  - [COURS] Mort de cause inconnue ou suspecte — `/gpx/generalites/mort_inconnue_intro`
  - [COURS] Délinquance & criminalité organisées — `/gpx/generalites/criminalite_deliquance_intro`
  - [COURS] Recherche des personnes en fuite — `/gpx/generalites/personnes_fuite_intro`
  - [COURS] Disparitions inquiétantes — `/gpx/cadres_juridiques/disparitions_inquietantes_intro`
  - [COURS] Contrôles et vérifications d’identité — `/gpx/generalites/flagrant_delit_intro`
  - [COURS] Entraide judiciaire internationale — `/gpx/generalites/entraide_judiciaire_intro`
  - [QUIZ] Quiz cadres juridiques, les cadres d'enquête, l'enquête de flagrant délit etc.. — `/gpx/procedure_penale/quiz/cadres_juridiques_principales`
- **Procédure Pénale** — badge «Cours & cas pratiques» — img `assets/images/procedure_penale.jpg` — `/gpx_scolarite_pages/procédure_pénale_pages`
  - [COURS] Action publique, action civile, autorités & contrôle de la PJ — `/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_autorites_pj`
  - [COURS] Nullité des actes de procédure — `/gpx_scolarite_pages/procédure_pénale_pages/nullite_intro_page`
  - [COURS] Juridictions de jugement & exécution des décisions — `/gpx_scolarite_pages/procédure_pénale_pages/juridictions_intro`
  - [COURS] Instruction préparatoire, mandats, contrôle jud., détention provisoire — `/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_mandats_controle_detention`
  - [QUIZ] Quiz instruction préparatoire, mandats & détention provisoire — `/gpx/procedure_penale/quiz/instruction_preparatoire`
- **Droit pénal général** — badge «Loi & responsabilité» — img `assets/images/droit_penal_general.jpeg` — `/gpx_scolarite_pages/droit_pénale_général_pages`
  - [COURS] De la loi pénale — `/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale`
  - [COURS] De la responsabilité pénale — `/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale`
- **La sanction** — badge «Peines & sûreté» — img `assets/images/sanction.jpeg` — `/gpx_scolarite_pages/sanction_pages`
  - [COURS] Classification des peines et mesures de sûreté — `/gpx_scolarite_pages/sanction_pages/classification_peines`
  - [COURS] Causes d’aggravation de la sanction — `/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction`
  - [COURS] Règles en cas de pluralité d’infractions — `/gpx_scolarite_pages/sanction_pages/pluralite_infractions`
  - [QUIZ] Quiz — Sanction  (récidive, réitération, concours réel) — `/gpx/sanction/quiz/sanction_page`
- **Crimes & délits contre la personne** — badge «Atteintes aux personnes» — img `assets/images/contre_personne.jpeg` — `/gpx_scolarite_pages/crime_delit_contre_personne_pages`
  - [COURS] La mise en danger de la personne — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/mise_en_danger`
  - [COURS] Le viol, l’inceste et autres agressions sexuelles — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/avertissement`
  - [COURS] L’enlèvement et la séquestration — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/enlevement_sequestration`
  - [COURS] Enregistrement & diffusion d’images — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images`
  - [COURS] Atteintes à la dignité de la personne — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne`
  - [COURS] Atteintes à la personnalité — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/personnalite`
  - [COURS] Atteintes involontaires à la vie et à l’intégrité — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires`
  - [COURS] Atteintes volontaires à la vie — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie`
  - [COURS] Atteintes volontaires à l’intégrité physique — `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite`
  - [QUIZ] Quiz — Crimes & délits contre la personne — `/gpx/crimes_personne/quiz/crimes_delits_personne`
- **Atteintes aux mineurs & à la famille** — badge «Protection des mineurs» — img `assets/images/mineurs_famille.jpeg` — `/gpx_scolarite_pages/mineurs_famille_pages`
  - [COURS] La mise en péril des mineurs — `/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril`
  - [COURS] Violation d’ordonnances JAF (violences) — `/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf`
  - [COURS] Atteintes à l’exercice de l’autorité parentale — `/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale`
  - [COURS] L’abandon de famille — `/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille`
  - [QUIZ] Quiz — L’abandon de famille — `/gpx/mineurs_famille_pages/quiz/quiz_mineurs_famille`
- **Crimes & délits contre la nation** — badge «Institutions & justice» — img `assets/images/contre_nation.jpeg` — `/gpx_scolarite_pages/crime_delit_nation_pages`
  - [COURS] Association de malfaiteurs — `/gpx_scolarite_pages/crime_delit_nation_pages/association_malfaiteurs`
  - [COURS] Abus d’autorité contre les particuliers — `/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite`
  - [COURS] Atteintes à l’action de la justice — `/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_action_justice`
  - [COURS] Atteintes à l’administration par des particuliers — `/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration`
  - [COURS] Faux et usage de faux — `/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux`
  - [COURS] Manquements au devoir de probité — `/gpx_scolarite_pages/crime_delit_nation_pages/probite`
  - [QUIZ] Quiz — Crimes & délits contre la nation — `/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_nation`
- **Crimes & délits contre les biens** — badge «Atteintes aux biens» — img `assets/images/contre_biens.jpeg` — `/gpx_scolarite_pages/crime_delit_bien_pages`
  - [COURS] Recel & non-justification de ressources — `/gpx_scolarite_pages/crime_delit_bien_pages/recel_non_justification`
  - [COURS] Le vol — `/gpx_scolarite_pages/crime_delit_bien_pages/vol`
  - [COURS] Atteintes aux STAD (informatique) — `/gpx_scolarite_pages/crime_delit_bien_pages/stad`
  - [COURS] Contrefaçons & falsifications de chèques — `/gpx_scolarite_pages/crime_delit_bien_pages/contrefacons_falsifications`
  - [COURS] Destructions, dégradations, détériorations — `/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations`
  - [COURS] Infractions voisines du vol — `/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol`
  - [QUIZ] Quiz — Crimes & délits contre les biens — `/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_bien`
- **Infractions à la circulation routière** — badge «Code de la route» — img `assets/images/circulation_routiere.jpeg` — `/gpx_scolarite_pages/infraction_circulation_routière_pages`
  - [COURS] Conduite après usage de stupéfiants — `/gpx_scolarite_pages/infraction_circulation_routière_pages/conduite_stupefiants`
  - [COURS] Conduite en état d’ivresse — `/gpx_scolarite_pages/infraction_circulation_routière_pages/ivresse`
  - [COURS] Conduite sous l’empire d’un état alcoolique — `/gpx_scolarite_pages/infraction_circulation_routière_pages/etat_alcoolique`
  - [COURS] Défaut d’assurance — `/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_assurance`
  - [COURS] Défaut de permis de conduire — `/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_permis`
  - [COURS] Délit de fuite — `/gpx_scolarite_pages/infraction_circulation_routière_pages/delit_fuite`
  - [COURS] Grand excès de vitesse — `/gpx_scolarite_pages/infraction_circulation_routière_pages/grand_exces_vitesse`
  - [COURS] Refus de vérifications — `/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_verifications`
  - [COURS] Refus d’obtempérer — `/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_obtemperer`
  - [COURS] Rodéo motorisé — `/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise`
  - [COURS] Plaques & inscriptions (délits liés) — `/gpx_scolarite_pages/infraction_circulation_routière_pages/plaques_inscriptions`
  - [COURS] Incitation / organisation / promotion — `/gpx_scolarite_pages/infraction_circulation_routière_pages/incitation_organisation_promotion`
  - [QUIZ] Quiz — Infractions à la circulation routière — `/gpx/infraction_circulation_routière_pages/quiz/quiz_circulation_routiere`
- **Armes & munitions** — badge «Régimes spéciaux» — img `assets/images/armes_munitions.jpeg` — `/gpx_scolarite_pages/armes_munitions_pages`
  - [COURS] Classification des armes et des munitions — `/gpx_scolarite_pages/armes_munitions_pages/armes_classification`
  - [COURS] Définitions — `/gpx_scolarite_pages/armes_munitions_pages/armes_definitions`
  - [COURS] Introduction — `/gpx_scolarite_pages/armes_munitions_pages/armes_introduction`
  - [COURS] Acquisition/détention cat. A ou B sans autorisation — `/gpx_scolarite_pages/armes_munitions_pages/armes_acquisition_detention_ab`
  - [COURS] Port/transport sans motif légitime (cat. C ou D) — `/gpx_scolarite_pages/armes_munitions_pages/armes_port_transport_cd`
  - [COURS] Régimes matériels de guerre / éléments d’arme — `/gpx_scolarite_pages/armes_munitions_pages/armes_materiels_guerre_elements`
  - [COURS] Règles d’acquisition & détention — `/gpx_scolarite_pages/armes_munitions_pages/armes_regles_acquisition_detention`
  - [COURS] Règles de port & transport — `/gpx_scolarite_pages/armes_munitions_pages/armes_regles_port_transport`
  - [QUIZ] Quiz — Classification des armes et des munitions — `/gpx/armes_munitions_pages/quiz/quiz_armes_munitions_pages`
- **Libertés publiques** — badge «Droits & garanties» — img `assets/images/libertes_publiques.jpeg` — `/gpx/generalites/libertespubliques_intro`
- **Stupéfiants — usage & trafic** — badge «Stups» — img `assets/images/stupefiants.jpeg` — `/gpx_scolarite_pages/stupéfiants_pages`
  - [COURS] Introduction — `/gpx_scolarite_pages/stupéfiants_pages/introduction`
  - [COURS] Cession/offre illicites pour consommation personnelle — `/gpx_scolarite_pages/stupéfiants_pages/cession_offre`
  - [COURS] Direction/organisation d’un trafic — `/gpx_scolarite_pages/stupéfiants_pages/direction_organisation`
  - [COURS] Facilitation à l’usage illicite — `/gpx_scolarite_pages/stupéfiants_pages/facilitation_usage`
  - [COURS] Production/fabrication illicites — `/gpx_scolarite_pages/stupéfiants_pages/production_fabrication`
  - [COURS] Provocation d’un majeur à l’usage ou au trafic — `/gpx_scolarite_pages/stupéfiants_pages/provocation_majeur`
  - [COURS] Blanchiment du produit du trafic — `/gpx_scolarite_pages/stupéfiants_pages/blanchiment_produit`
  - [COURS] Transport/détention/offre/cession/acquisition/emploi — `/gpx_scolarite_pages/stupéfiants_pages/transport_detention_offre`
  - [COURS] Importation/exportation illicites — `/gpx_scolarite_pages/stupéfiants_pages/import_export`
  - [COURS] Usage illicite de stupéfiants — `/gpx_scolarite_pages/stupéfiants_pages/usage_illicite`
  - [QUIZ] Quiz — Stupéfiants — usage & trafic — `/gpx/stupéfiants_pages/quiz/quiz_stupéfiants`

##### mememtoCirculationRoutiere

- **Procédures circulation routière** — badge «Procédures» — img `assets/images/memento_procedures.jpeg` — `/gpx/memento_circulation/procedures`
  - [COURS] L’amende forfaitaire — `/gpx/memento_circulation/procedures/amende_forfaitaire` img `assets/images/amende_forfaitaire.jpeg`
  - [COURS] L’amende forfaitaire délictuelle — `/gpx/memento_circulation/procedures/amende_forfaitaire_delictuelle` img `assets/images/amende_forfaitaire_delictuelle.jpeg`
  - [COURS] La consignation — `/gpx/memento_circulation/procedures/consignation` img `assets/images/consignation.jpeg`
  - [COURS] L’immobilisation du véhicule — `/gpx/memento_circulation/procedures/immobilisation` img `assets/images/immobilisation.jpeg`
  - [COURS] La mise en fourrière — `/gpx/memento_circulation/procedures/mise_en_fourriere` img `assets/images/mise_en_fourriere.jpeg`
  - [COURS] La conduite sous l’influence de l’alcool — `/gpx/memento_circulation/procedures/conduite_alcool` img `assets/images/ivresse.jpeg`
  - [COURS] La conduite après usage de stupéfiants — `/gpx/memento_circulation/procedures/conduite_stupefiants` img `assets/images/stupefiants.jpeg`
  - [COURS] La rétention du permis de conduire — `/gpx/memento_circulation/procedures/retention_permis` img `assets/images/retention_permis.jpeg`
  - [COURS] Le permis à points — `/gpx/memento_circulation/procedures/permis_a_points` img `assets/images/permis_points.jpeg`
  - [QUIZ] Quiz — Procédures circulation — `/gpx/memento_circulation/procedures/quiz` img `assets/images/quiz.jpeg`
- **Contrôle routier & pièces** — badge «Contrôle» — img `assets/images/memento_controle_routier.jpeg` — `/gpx/memento_circulation/controle_routier`
  - [COURS] Le cadre légal du contrôle routier — `/gpx/memento_circulation/controle_routier/cadre_legal` img `assets/images/cadres_juridiques.jpeg`
  - [COURS] Le permis de conduire — `/gpx/memento_circulation/controle_routier/permis_conduire` img `assets/images/permis_conduire.jpeg`
  - [COURS] Le brevet de sécurité routière — `/gpx/memento_circulation/controle_routier/bsr` img `assets/images/bsr.jpeg`
  - [COURS] Les certificats d’immatriculation — `/gpx/memento_circulation/controle_routier/certificat_immatriculation` img `assets/images/certificat_immatriculation.jpeg`
  - [COURS] Le contrôle technique des véhicules — `/gpx/memento_circulation/controle_routier/controle_technique` img `assets/images/controle_technique.jpeg`
  - [COURS] L’assurance — `/gpx/memento_circulation/controle_routier/assurance_obligatoire` img `assets/images/assurance_obligatoire.jpeg`
  - [QUIZ] Quiz — Contrôle routier — `/gpx/memento_circulation/controle_routier/quiz` img `assets/images/quiz.jpeg`
- **Équipements véhicules & usagers** — badge «Équipements» — img `assets/images/memento_equipements.jpeg` — `/gpx/memento_circulation/equipements`
  - [COURS] Les pneumatiques — `/gpx/memento_circulation/equipements/pneumatiques` img `assets/images/pneumatiques.jpeg`
  - [COURS] Éclairage et signalisation — `/gpx/memento_circulation/equipements/eclairage_signalisation` img `assets/images/eclairage_signalisation.jpeg`
  - [COURS] Chargement — `/gpx/memento_circulation/equipements/chargement` img `assets/images/chargement.jpeg`
  - [COURS] Les plaques — `/gpx/memento_circulation/equipements/plaques` img `assets/images/plaques.jpeg`
  - [COURS] Miroirs / rétroviseurs / vision indirecte — `/gpx/memento_circulation/equipements/retroviseurs_vision` img `assets/images/retroviseurs.jpeg`
  - [COURS] Les essuie-glace — `/gpx/memento_circulation/equipements/essuie_glace` img `assets/images/essuie_glace.jpeg`
  - [COURS] Nuisances des véhicules (fumées, bruit, avertisseur sonore) — `/gpx/memento_circulation/equipements/nuisances` img `assets/images/nuisances.jpeg`
  - [COURS] Ceinture de sécurité / retenue enfant — `/gpx/memento_circulation/equipements/ceinture_retenue_enfant` img `assets/images/ceinture_retenue_enfant.jpeg`
  - [COURS] Casque et gants de protection — `/gpx/memento_circulation/equipements/casque_gants` img `assets/images/casque_gants.jpeg`
  - [COURS] Casque “cycliste” — `/gpx/memento_circulation/equipements/casque_cycliste` img `assets/images/casque_cycliste.jpeg`
  - [COURS] Gilet de haute visibilité — `/gpx/memento_circulation/equipements/gilet_haute_visibilite` img `assets/images/gilet_haute_visibilite.jpeg`
  - [QUIZ] Quiz — Équipements — `/gpx/memento_circulation/equipements/quiz` img `assets/images/quiz.jpeg`
- **Natinf** — badge «Natinf» — img `assets/images/natinf.png` — `/gpx/memento_circulation/natinf`
  - [COURS] Natinf — `/gpx/memento_circulation/controle_routier/natinf` img `assets/images/natinf.png`

##### policierEnInterventionsa

- **Circulation & séjour des étrangers** — badge «Étrangers» — img `assets/images/mandat_arret.jpeg` — `/gpx/intervention/etrangers`
  - [COURS] L’accord de Schengen — `/gpx/intervention/etrangers/schengen` img `assets/images/schengen.jpeg`
  - [COURS] Coopération policière et judiciaire (UE) — `/gpx/intervention/etrangers/cooperation-ue` img `assets/images/cooperation_ue.jpeg`
  - [COURS] Les différents titres de séjour — `/gpx/intervention/etrangers/titres-sejour` img `assets/images/titres_sejour.jpeg`
  - [QUIZ] Quiz — Étrangers — `/gpx/intervention/etrangers/quiz`
- **Protection des mineurs** — badge «Mineurs» — img `assets/images/mineurs_famille.jpeg` — `/gpx/intervention/mineurs`
  - [COURS] Le statut juridique du mineur — `/gpx/intervention/mineurs/statut-juridique`
  - [COURS] Protection des mineurs sur la voie publique — `/gpx/intervention/mineurs/voie-publique`
  - [QUIZ] Quiz — Mineurs — `/gpx/intervention/mineurs/quiz`
- **Accident de la circulation** — badge «Accident» — img `assets/images/mise_en_danger.jpeg` — `/gpx/intervention/accident-circulation`
  - [COURS] Technique du plan des lieux — `/gpx/intervention/accident-circulation/plan-lieux-technique` img `assets/images/plan_lieux.jpeg`
  - [COURS] Différents modèles de plan — `/gpx/intervention/accident-circulation/modeles-plan` img `assets/images/modele-sans-cotes.jpeg`
  - [COURS] Renseignements à recueillir sur les lieux — `/gpx/intervention/accident-circulation/renseignements-a-recueillir` img `assets/images/renseignements.jpeg`
  - [COURS] Tableau synthèse des renseignements à recueillir — `/gpx/intervention/accident-circulation/tableau-synthese` img `assets/images/tableau_synthese.jpeg`
  - [COURS] L’avis à la famille — `/gpx/intervention/accident-circulation/avis-famille` img `assets/images/avis_famille.jpeg`
  - [COURS] “J’annonce une mauvaise nouvelle” (AMARIS) — `/gpx/intervention/accident-circulation/annoncer-mauvaise-nouvelle` img `assets/images/mauvaise_nouvelle.jpeg`
  - [QUIZ] Quiz — Accident — `/gpx/intervention/accident-circulation/quiz`
- **Intervention : usage de stupéfiants** — badge «Stupéfiants» — img `assets/images/stupefiants.jpeg` — `/gpx/intervention/stupefiants`
  - [COURS] Amende forfaitaire délictuelle (usage illicite) — `/gpx/intervention/stupefiants/amende-forfaitaire-delictuelle`
  - [QUIZ] Quiz — Stupéfiants — `/gpx/intervention/stupefiants/quiz`
- **Intervention : débit de boissons** — badge «Débit» — img `assets/images/ivresse.jpeg` — `/gpx/intervention/debit-boissons`
  - [COURS] Intervention dans un débit de boissons — `/gpx/intervention/debit-boissons/intervention` img `assets/images/boissons_intervention.jpeg`
  - [COURS] Contrôle des débits de boissons — `/gpx/intervention/debit-boissons/controle` img `assets/images/boissons_controle.jpeg`
  - [QUIZ] Quiz — Débit de boissons — `/gpx/intervention/debit-boissons/quiz`
- **Les malades mentaux** — badge «Psychiatrie» — img `assets/images/malades_mentaux.jpeg` — `/gpx/intervention/malades-mentaux`
  - [COURS] Intervenir auprès de personnes ne jouissant pas de toutes leurs capacités mentales — `/gpx/intervention/malades-mentaux/intervenir` img `assets/images/malades_mentaux_intervenir.jpeg`
  - [COURS] Admission en soins psychiatriques sans consentement — `/gpx/intervention/malades-mentaux/soins-sans-consentement` img `assets/images/soins_sans_consentement.jpeg`
  - [QUIZ] Quiz — Malades mentaux — `/gpx/intervention/malades-mentaux/quiz`
- **Intervention : présence d’un animal** — badge «Animal» — img `assets/images/animal.jpeg` — `/gpx/intervention/animal`
  - [COURS] Lutte contre la maltraitance animale — `/gpx/intervention/animal/maltraitance` img `assets/images/maltraitance.jpeg`
  - [COURS] “Intervenir face à un chien dangereux” (AMARIS) — `/gpx/intervention/animal/chien-dangereux` img `assets/images/chien_dangereux.jpeg`
  - [COURS] Protocole sanitaire en cas de morsure — `/gpx/intervention/animal/protocole-morsure` img `assets/images/protocole_morsure.jpeg`
  - [COURS] Chiens d’attaque, de garde ou de défense — `/gpx/intervention/animal/chiens-categories` img `assets/images/chiens_categories.jpeg`
  - [QUIZ] Quiz — Animal — `/gpx/intervention/animal/quiz`
- **Les autres interventions** — badge «Divers» — img `assets/images/autres_interventions.jpeg` — `/gpx/intervention/autres`
  - [COURS] Intervention sur les lieux d’un sinistre — `/gpx/intervention/autres/sinistre` img `assets/images/sinistre.jpeg`
  - [COURS] “Primo-intervenant sur un incendie” (AMARIS) — `/gpx/intervention/autres/incendie-primo` img `assets/images/incendie_primo.jpeg`
  - [COURS] Intervention sur une alarme (établissement à caractère financier ou commercial) — `/gpx/intervention/autres/alarme-etablissement` img `assets/images/alarme_etablissement.jpeg`
  - [COURS] Principes de levée de doute lors d’agressions armées — `/gpx/intervention/autres/levee-doute-agression-armee` img `assets/images/levee_doute_agression_armee.jpeg`
  - [COURS] Intervention suite à une agression armée à caractère crapuleux — `/gpx/intervention/autres/agression-armee-crapuleux` img `assets/images/agression_armee_crapuleux.jpeg`
  - [COURS] Intervention suite à la violation d’un bracelet anti-rapprochement (interdiction de se rapprocher) — `/gpx/intervention/autres/violation-bar`
  - [COURS] Plan Vigipirate — `/gpx/intervention/autres/plan-vigipirate` img `assets/images/vigipirate.jpeg`
  - [QUIZ] Quiz — Autres interventions — `/gpx/intervention/autres/quiz`

##### policierEnIntervention

- **La prise de service** — badge «Service» — img `assets/images/cat_hierarchie.jpg` — `/gpx/intervention/prise-service`
  - [COURS] La prise de service : l’appel — `/gpx/intervention/prise-service/appel` img `assets/images/prise_de_service.png`
  - [COURS] Les principaux registres du poste — `/gpx/intervention/prise-service/registres` img `assets/images/registe_poste.png`
  - [COURS] Les applications “main courante” et “déclaration d’usagers” — `/gpx/intervention/prise-service/applications` img `assets/images/main_courante.jpeg`
  - [COURS] Mesures de sécurité, la fouille intégrale — `/gpx/intervention/prise-service/fouille-integrale` img `assets/images/fouille.jpeg`
  - [COURS] La gestion humaine et matérielle de la garde à vue — `/gpx/intervention/prise-service/garde-a-vue` img `assets/images/gav.jpeg`
  - [COURS] Maîtriser le risque d’évasion et de fuite (AMARIS) — `/gpx/intervention/prise-service/risque-evasion-fuite` img `assets/images/amaris.jpg`
- **La patrouille** — badge «Patrouille» — img `assets/images/memento_controle_routier.jpeg` — `/gpx/intervention/patrouille`
  - [COURS] La patrouille — `/gpx/intervention/patrouille/patrouille` img `assets/images/cat_infractions.jpg`
  - [COURS] La communication radioélectrique — `/gpx/intervention/patrouille/communication-radio` img `assets/images/prise_de_service.png`
  - [COURS] Plaquette : respect de la procédure radio — `/gpx/intervention/patrouille/procedure-radio` img `assets/images/prise_de_service.png`
  - [COURS] MEMO TPH 900 — `/gpx/intervention/patrouille/memo-tph-900` img `assets/images/prise_de_service.png`
  - [COURS] Les principaux fichiers — `/gpx/intervention/patrouille/principaux-fichiers` img `assets/images/copic_institutions.jpg`
  - [COURS] L’interrogation du F.P.R. — `/gpx/intervention/patrouille/interrogation-fpr` img `assets/images/criminalite_organisee.jpeg`
  - [COURS] La caméra piéton — `/gpx/intervention/patrouille/camera-pieton` img `assets/images/camera_pieton.jpg`
  - [COURS] L’utilité de la caméra piéton (AMARIS) — `/gpx/intervention/patrouille/utilite-camera` img `assets/images/amaris.jpg`
  - [COURS] Les équipements de sécurité — `/gpx/intervention/patrouille/equipements-securite` img `assets/images/equipement_securite.jpg`
  - [COURS] La conduite des véhicules de police — `/gpx/intervention/patrouille/conduite-vehicules` img `assets/images/voiture_police.jpg`
  - [COURS] L’usage des signaux sonores et lumineux — `/gpx/intervention/patrouille/signaux-sonores-lumineux` img `assets/images/gyro.jpg`
  - [COURS] Le signalement descriptif — `/gpx/intervention/patrouille/signalement-descriptif` img `assets/images/signalement_descriptif.jpg`
  - [COURS] La palpation de sécurité — `/gpx/intervention/patrouille/palpation-securite` img `assets/images/fouille.jpeg`
  - [COURS] Le menottage — `/gpx/intervention/patrouille/menottage` img `assets/images/menottage.jpeg`
  - [COURS] Enregistrement et diffusion éventuelle d'images et de paroles de fonctionnaires de police dans l'exercice de leurs fonctions. — `/gpx/intervention/patrouille/enregistrement-diffusion-images-paroles` img `assets/images/enregistement_police.jpg`
  - [COURS] Synthèse des indicateurs de basculement — `/gpx/intervention/patrouille/synthese-indicateurs-basculement` img `assets/images/emotion.webp`
- **L’accident de la circulation** — badge «Accident» — img `assets/images/mise_en_danger.jpeg` — `/gpx/intervention/accident-circulation`
  - [COURS] La sécurité pendant le trajet et sur les lieux du constat d’un accident de la circulation — `/gpx/intervention/accident-circulation/securite-trajet-lieux` img `assets/images/acccident_voiture.jpeg`
  - [COURS] Les différents types d’accidents de la circulation routière — `/gpx/intervention/accident-circulation/types-accidents` img `assets/images/different_accident.jpg`
  - [COURS] La régulation de la circulation — `/gpx/intervention/accident-circulation/regulation-circulation` img `assets/images/regulastion_accident.webp`
- **L’intervention au domicile** — badge «Domicile» — img `assets/images/mineurs_famille.jpeg` — `/gpx/intervention/domicile`
  - [COURS] Le domicile et la violation de domicile — `/gpx/intervention/domicile/violation-domicile` img `assets/images/violation_domicile.webp`
  - [COURS] Les bruits et tapages — `/gpx/intervention/domicile/bruits-tapages` img `assets/images/tapage.jpg`
  - [COURS] Le différend familial — `/gpx/intervention/domicile/differend-familial` img `assets/images/different_familiale.jpg`
  - [COURS] Violences conjugales : conduite à tenir lors des interventions à domicile — `/gpx/intervention/domicile/violences-conjugales` img `assets/images/violence_conjugale.jpg`
- **Les autres interventions** — badge «Divers» — img `assets/images/hierarchie_police.jpeg` — `/gpx/intervention/autres`
  - [COURS] “Primo-intervenant sur une scène d’infraction” (AMARIS) — `/gpx/intervention/autres/primo-scene-infraction-amaris` img `assets/images/flagrant_delit.webp`
  - [COURS] Bagages abandonnés, oubliés ; objets, engins ou véhicules suspects — `/gpx/intervention/autres/alertes-a-la-bombe` img `assets/images/deminage_camion.png`
  - [COURS] Identification et détection des produits suspects — `/gpx/intervention/autres/identification-detection-produits-suspects` img `assets/images/identifiacation_colis.png`
  - [COURS] L’ivresse publique et manifeste (I.P.M.) — `/gpx/intervention/autres/ipm` img `assets/images/ipm.jpg`
  - [COURS] Les plans ORSEC — `/gpx/intervention/autres/plans-orsec` img `assets/images/ORSEC_large.jpg`
- **Formulaires utiles** — badge «Docs» — img `assets/images/copic_institutions.jpg` — `/gpx/intervention/formulaires-utiles`
  - [COURS] Avis de rétention d’un permis de conduire — `/gpx/intervention/formulaires-utiles/avis-retention-permis` img `assets/images/retention_permis_conduire.jpg`
  - [COURS] Fiche d’immobilisation — `/gpx/intervention/formulaires-utiles/fiche-immobilisation` img `assets/images/fiche_immobilisation.jpg`
  - [COURS] Fiche descriptive de l’état du véhicule à enlever en fourrière — `/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere` img `assets/images/fourrière.webp`

##### recueilPvApj20

- **Recueil PV — Introduction** — badge «Bases» — img `assets/images/pv_intro.jpg` — `/gpx/pv_apj20/introduction`
  - [COURS]  — `/gpx/pv_apj20/introduction/preambule` img `assets/images/pv_preambule.png`
  - [COURS]  — `/gpx/pv_apj20/introduction/procedure` img `assets/images/pv_procedure.png`
  - [COURS]  — `/gpx/pv_apj20/introduction/proces_verbaux` img `assets/images/proces_verbaux.png`
  - [COURS] L’état-civil — `/gpx/pv_apj20/introduction/etat_civil` img `assets/images/etat_civil.png`
- **Recueil PV — La plainte** — badge «Plainte» — img `assets/images/pv_plainte.jpeg` — `/gpx/pv_apj20/plainte`
  - [COURS]  — `/gpx/pv_apj20/plainte/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas de procès-verbal de plainte contre auteur inconnu — `/gpx/pv_apj20/plainte/pv_saisine_personne_inconnue` img `assets/images/canevas.png`
  - [COURS] Canevas de procès-verbal de plainte contre personne dénommée — `/gpx/pv_apj20/plainte/pv_saisine_personne_denommee` img `assets/images/canevas.png`
  - [COURS] Canevas de procès-verbal de plainte contre personne dénommée — Suite — `/gpx/pv_apj20/plainte/pv_saisine_personne_denommee_suite` img `assets/images/canevas.png`
  - [COURS] Violences conjugales — Grille d’évaluation du danger — `/gpx/pv_apj20/plainte/violences_conjugales/presentation_grille_danger` img `assets/images/pv_vc_grille_danger.jpg`
  - [COURS] Violences conjugales — Document d’information synthétique (démarches & dispositifs) — `/gpx/pv_apj20/plainte/violences_conjugales/document_info_synthetique` img `assets/images/pv_vc_document_info.webp`
  - [COURS] Canevas & PV de plainte d’une victime de violences conjugales — `/gpx/pv_apj20/plainte/violences_conjugales/pv_victime` img `assets/images/canevas.png`
- **Recueil PV — Constatations** — badge «Constats» — img `assets/images/perquisition.jpeg` — `/gpx/pv_apj20/constatations`
  - [COURS]  — `/gpx/pv_apj20/constatations/generalites` img `assets/images/généralités.png`
  - [COURS]  — `/gpx/pv_apj20/constatations/canevas_pv` img `assets/images/canevas.png`
- **Recueil PV — Témoignage** — badge «Audition» — img `assets/images/renseignements.jpeg` — `/gpx/pv_apj20/temoignage`
  - [COURS]  — `/gpx/pv_apj20/temoignage/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV d’enquête de voisinage — `/gpx/pv_apj20/temoignage/enquete_voisinage` img `assets/images/canevas.png`
  - [COURS] Canevas & PV d’audition de témoin — `/gpx/pv_apj20/temoignage/audition_temoins` img `assets/images/canevas.png`
- **Recueil PV — Contrôle d’identité** — badge «Identité» — img `assets/images/pv_controle_identite.jpeg` — `/gpx/pv_apj20/controle_identite`
  - [COURS]  — `/gpx/pv_apj20/controle_identite/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV de contrôle d’identité — `/gpx/pv_apj20/controle_identite/pv_controle_identite` img `assets/images/canevas.png`
  - [COURS] Canevas & PV de contrôle d’identité + fiche de recherche — `/gpx/pv_apj20/controle_identite/pv_ci_fiche_recherche` img `assets/images/canevas.png`
- **Recueil PV — Interpellation & conduite au poste** — badge «Interpellation» — img `assets/images/pv_interpellation.jpeg` — `/gpx/pv_apj20/interpellation`
  - [COURS]  — `/gpx/pv_apj20/interpellation/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV de contrôle d’identité + découverte d’une arme — `/gpx/pv_apj20/interpellation/ci_decouverte_arme` img `assets/images/canevas.png`
  - [COURS] Canevas & PV d’interpellation — `/gpx/pv_apj20/interpellation/pv_interpellation` img `assets/images/canevas.png`
  - [COURS] Canevas & PV de conduite au poste — `/gpx/pv_apj20/interpellation/conduite_au_poste` img `assets/images/canevas.png`
  - [COURS] Les mandats (recherche, comparution, amener, arrêt) — `/gpx/pv_apj20/interpellation/mandats` img `assets/images/pv_mandats.png`
  - [COURS] Canevas & PV de notification de mandat — `/gpx/pv_apj20/interpellation/notification_mandat` img `assets/images/canevas.png`
  - [COURS] Canevas & PV de recherches infructueuses (exécution mandat) — `/gpx/pv_apj20/interpellation/recherches_infructueuses_mandat` img `assets/images/canevas.png`
  - [COURS] Canevas de compte-rendu à l’O.P.J. — `/gpx/pv_apj20/interpellation/compte_rendu_opj` img `assets/images/canevas.png`
- **Recueil PV — GAV & suspect libre** — badge «Droits» — img `assets/images/pv_gav_suspect_libre.jpeg` — `/gpx/pv_apj20/gav_suspect_libre`
  - [COURS] La garde à vue : généralités — `/gpx/pv_apj20/gav_suspect_libre/gav_generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : notification placement GAV + droits (A.P.J.) — `/gpx/pv_apj20/gav_suspect_libre/notification_gav_droits_apj` img `assets/images/canevas.png`
  - [COURS] Le suspect libre : généralités — `/gpx/pv_apj20/gav_suspect_libre/suspect_libre_generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : notification des droits au suspect majeur — `/gpx/pv_apj20/gav_suspect_libre/notification_droits_suspect_majeur_emprisonnement` img `assets/images/canevas.png`
  - [COURS] Canevas & PV : notification en audition libre (contravention/délit non puni emprisonnement) — `/gpx/pv_apj20/gav_suspect_libre/notification_audition_libre_sans_emprisonnement` img `assets/images/canevas.png`
  - [COURS] Canevas & PV : notification des droits — Art. 65 du C.P.P. — `/gpx/pv_apj20/gav_suspect_libre/notification_droits_art_65_cpp` img `assets/images/canevas.png`
  - [COURS] Intervention de l’avocat : généralités — `/gpx/pv_apj20/gav_suspect_libre/avocat_generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : entretien du gardé à vue avec l’avocat — `/gpx/pv_apj20/gav_suspect_libre/entretien_gav_avocat` img `assets/images/canevas.png`
- **Recueil PV — Audition du suspect** — badge «Audition» — img `assets/images/pv_audition_suspect.jpeg` — `/gpx/pv_apj20/audition_suspect`
  - [COURS]  — `/gpx/pv_apj20/audition_suspect/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : audition du gardé à vue — `/gpx/pv_apj20/audition_suspect/audition_gav` img `assets/images/canevas.png`
  - [COURS] Canevas & PV : audition du suspect libre — `/gpx/pv_apj20/audition_suspect/audition_suspect_libre` img `assets/images/canevas.png`
  - [COURS] Canevas & PV : audition du suspect libre + notification des droits (contravention/délit non puni emprisonnement) — `/gpx/pv_apj20/audition_suspect/audition_libre_notification_droits_sans_emprisonnement` img `assets/images/canevas.png`
  - [COURS] Le civilement responsable : généralités — `/gpx/pv_apj20/audition_suspect/civilement_responsable_generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : audition du civilement responsable — `/gpx/pv_apj20/audition_suspect/audition_civilement_responsable` img `assets/images/canevas.png`
- **Recueil PV — Perquisition (enquête préliminaire)** — badge «Enquête» — img `assets/images/pv_perquisition.jpeg` — `/gpx/pv_apj20/perquisition_preliminaire`
  - [COURS]  — `/gpx/pv_apj20/perquisition_preliminaire/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : perquisition en enquête préliminaire — `/gpx/pv_apj20/perquisition_preliminaire/perquisition` img `assets/images/canevas.png`
  - [COURS] Canevas & PV : fouille de véhicule en enquête préliminaire — `/gpx/pv_apj20/perquisition_preliminaire/fouille_vehicule` img `assets/images/canevas.png`
- **Recueil PV — Réquisitions** — badge «Réquisitions» — img `assets/images/pv_requisitions.jpeg` — `/gpx/pv_apj20/requisitions`
  - [COURS]  — `/gpx/pv_apj20/requisitions/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : réquisition à personne — `/gpx/pv_apj20/requisitions/requisition_personne` img `assets/images/canevas.png`
  - [COURS] Canevas & rapport : réquisition à personne — `/gpx/pv_apj20/requisitions/rapport_requisition_personne` img `assets/images/canevas.png`
- **Recueil PV — Confrontation** — badge «Procédure» — img `assets/images/pv_confrontation.jpeg` — `/gpx/pv_apj20/confrontation`
  - [COURS]  — `/gpx/pv_apj20/confrontation/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : confrontation victime / gardé à vue — `/gpx/pv_apj20/confrontation/victime_gav` img `assets/images/canevas.png`
  - [COURS] Canevas & PV : confrontation victime / suspect libre (crime/délit puni emprisonnement) — `/gpx/pv_apj20/confrontation/victime_suspect_libre_emprisonnement` img `assets/images/canevas.png`
- **Recueil PV — Procédures spéciales (étrangers)** — badge «Spécial» — img `assets/images/pv_etrangers.jpeg` — `/gpx/pv_apj20/procedures_speciales/etrangers`
  - [COURS]  — `/gpx/pv_apj20/procedures_speciales/etrangers/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV : contrôle d’identité + contrôle du séjour et de la circulation des étrangers — `/gpx/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation` img `assets/images/canevas.png`
  - [COURS] Canevas & PV : contrôle du séjour et de la circulation des étrangers — `/gpx/pv_apj20/procedures_speciales/etrangers/controle_sejour_circulation` img `assets/images/canevas.png`
- **Recueil PV — Circulation routière** — badge «Circulation» — img `assets/images/pv_circulation_routiere.jpeg` — `/gpx/pv_apj20/circulation_routiere`
  - [COURS] Alcool — Généralités — `/gpx/pv_apj20/circulation_routiere/alcool/generalites` img `assets/images/généralités.png`
  - [COURS] Alcool — Canevas & PV conduite au poste (dépistage CEEA positif / refus / sans dépistage) — `/gpx/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus` img `assets/images/canevas.png`
  - [COURS] Alcool — Canevas & PV d’interpellation suite conduite en état d’ivresse — `/gpx/pv_apj20/circulation_routiere/alcool/interpellation_etat_ivresse` img `assets/images/canevas.png`
  - [COURS] Alcool — Tableau des taux d’alcool (affichés & retenus) — `/gpx/pv_apj20/circulation_routiere/alcool/tableau_taux` img `assets/images/pv_tableau_taux_alcool.png`
  - [COURS] Alcool — Canevas & PV vérification + notification des taux (CEEA) — `/gpx/pv_apj20/circulation_routiere/alcool/verification_notification_taux_ceea` img `assets/images/canevas.png`
  - [COURS] Alcool — Canevas & PV vérification des taux (CEI) — `/gpx/pv_apj20/circulation_routiere/alcool/verification_taux_cei` img `assets/images/canevas.png`
  - [COURS] Alcool — Canevas & PV prélèvement sanguin (vérification état alcoolique) — `/gpx/pv_apj20/circulation_routiere/alcool/prelevement_sanguin` img `assets/images/canevas.png`
  - [COURS] Alcool — Canevas & rapport réquisition (examen clinique médical + prélèvement sanguin) — `/gpx/pv_apj20/circulation_routiere/alcool/requisition_examen_clinique_prelevement` img `assets/images/canevas.png`
  - [COURS] Alcool — Fiches A, B, C — `/gpx/pv_apj20/circulation_routiere/alcool/fiches_abc` img `assets/images/pv_fiches_abc.png`
  - [COURS] Stupéfiants — Généralités — `/gpx/pv_apj20/circulation_routiere/stupefiants/generalites` img `assets/images/stupefiants.jpeg`
  - [COURS] Stupéfiants — Canevas & PV conduite au poste (dépistage positif / refus) — `/gpx/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus` img `assets/images/canevas.png`
  - [COURS] Stupéfiants — Formulaire d’information — `/gpx/pv_apj20/circulation_routiere/stupefiants/formulaire_information` img `assets/images/pv_formulaire_information.png`
  - [COURS] Stupéfiants — Canevas & PV vérifications destinées à établir l’usage — `/gpx/pv_apj20/circulation_routiere/stupefiants/verifications_etablir_usage` img `assets/images/canevas.png`
  - [COURS] Stupéfiants — Fiche suivi prélèvements (analyse salivaire) — `/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_salivaire` img `assets/images/pv_suivi_prelevements.png`
  - [COURS] Stupéfiants — Canevas & PV suite à prélèvement sanguin — `/gpx/pv_apj20/circulation_routiere/stupefiants/suite_prelevement_sanguin` img `assets/images/canevas.png`
  - [COURS] Stupéfiants — Canevas & PV prélèvement sanguin (établir usage stupéfiants) — `/gpx/pv_apj20/circulation_routiere/stupefiants/prelevement_sanguin_etablir_usage` img `assets/images/canevas.png`
  - [COURS] Stupéfiants — Fiche suivi prélèvements (analyse sanguine) — `/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_sanguine` img `assets/images/pv_suivi_prelevements.png`
  - [COURS] Stupéfiants — Canevas & rapport réquisition (examen clinique + prélèvement sanguin) + expertise — `/gpx/pv_apj20/circulation_routiere/stupefiants/requisition_examen_clinique_prelevement_expertise` img `assets/images/canevas.png`
  - [COURS] Alcool + Stups — Conduite au poste (dépistages positifs / refus) — `/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/conduite_poste_depistages_positifs_ou_refus` img `assets/images/pv_conduite_poste.png`
  - [COURS] Alcool + Stups — Conduite au poste (refus de se soumettre aux vérifications) — `/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/refus_verifications` img `assets/images/pv_refus_verifications.png`
  - [COURS] Contravention 5e classe — Grand excès de vitesse (+50 km/h) — `/gpx/pv_apj20/circulation_routiere/contravention_5e/grand_exces_vitesse` img `assets/images/grand_exces_vitesse.jpeg`
  - [COURS] Contravention 5e classe — Tableau des vitesses retenues — `/gpx/pv_apj20/circulation_routiere/contravention_5e/tableau_vitesses` img `assets/images/pv_tableau_vitesses.png`
  - [COURS] Formulaires utiles — Avis de rétention du permis — `/gpx/intervention/formulaires-utiles/avis-retention-permis` img `assets/images/retention_permis.jpeg`
  - [COURS] Formulaires utiles — Fiche d’immobilisation — `/gpx/intervention/formulaires-utiles/fiche-immobilisation` img `assets/images/immobilisation.jpeg`
  - [COURS] Formulaires utiles — Fiche descriptive état véhicule (fourrière) — `/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere` img `assets/images/mise_en_fourriere.jpeg`
- **Recueil PV — I.V.P.M** — badge «IPM» — img `assets/images/ipm.jpeg` — `/gpx/pv_apj20/ipm`
  - [COURS]  — `/gpx/pv_apj20/ipm/generalites` img `assets/images/généralités.png`
  - [COURS] Canevas & PV contravention d’ivresse publique et manifeste (examen médical) — `/gpx/pv_apj20/ipm/pv_ipm_examen_medical` img `assets/images/canevas.png`
  - [COURS] Canevas & PV contravention d’ivresse publique et manifeste (remise à un tiers) — `/gpx/pv_apj20/ipm/pv_ipm_remise_tiers` img `assets/images/canevas.png`

##### dimensionHumaine

- **Communication & posture** — badge «Relationnel» — img `assets/images/dh_communication.jpeg` — `/gpx/dimension_humaine/communication`
  - [COURS] DH1 — Le fonctionnement intellectuel et émotionnel dans l’intervention — `/gpx/dimension_humaine/communication/dh1_fonctionnement` img `assets/images/dh1_fonctionnement.jpeg`
  - [COURS] DH3 — Les stratégies de communication adaptées avec le public — `/gpx/dimension_humaine/communication/dh3_strategies_public` img `assets/images/dh3_strategies_public.jpeg`
  - [COURS] DH4 — La coordination au sein des équipes de police — `/gpx/dimension_humaine/communication/dh4_coordination_equipes` img `assets/images/dh4_coordination.jpeg`
  - [COURS] ADH2 — La posture professionnelle adaptée face à une victime — `/gpx/dimension_humaine/communication/adh2_posture_victime` img `assets/images/adh2_posture_victime.jpeg`
  - [COURS] S3-2 — L’intervention auprès de victimes de violences intrafamiliales — `/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales` img `assets/images/s3_2_violences_intrafamiliales.jpeg`
  - [QUIZ] Quiz — Communication & posture — `/gpx/dimension_humaine/communication/quiz` img `assets/images/quiz.jpeg`
- **Stress & gestion émotionnelle** — badge «Bien-être» — img `assets/images/dh_stress.jpeg` — `/gpx/dimension_humaine/stress`
  - [COURS] DH2 — Le stress — `/gpx/dimension_humaine/stress/dh2_stress` img `assets/images/dh2_stress.jpeg`
  - [COURS] DH2 — Le carnet des ressources — `/gpx/dimension_humaine/stress/dh2_carnet_ressources` img `assets/images/dh2_carnet_ressources.jpeg`
  - [COURS] ADH9 — Faire face à une situation d’agressivité — `/gpx/dimension_humaine/stress/adh9_agressivite` img `assets/images/adh9_agressivite.jpeg`
  - [COURS] AC6 — Les conduites suicidaires — `/gpx/dimension_humaine/stress/ac6_conduites_suicidaires` img `assets/images/ac6_suicide.jpeg`
  - [QUIZ] Quiz — Stress & gestion émotionnelle — `/gpx/dimension_humaine/stress/quiz` img `assets/images/quiz.jpeg`
- **Éthique au quotidien** — badge «Valeurs» — img `assets/images/dignite_discriminations.jpeg` — `/gpx/dimension_humaine/ethique`
  - [COURS] ADH1 — L’intervention auprès de personnes ne jouissant pas de toutes ses facultés mentales — `/gpx/dimension_humaine/ethique/adh1_facultes_mentales` img `assets/images/adh1_facultes_mentales.jpeg`
  - [COURS] ADH4 — Les violences sexuelles et sexistes — `/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes` img `assets/images/adh4_violences_sexuelles.jpeg`
  - [COURS] ADH6 — La confrontation à la mort en situation professionnelle — `/gpx/dimension_humaine/ethique/adh6_confrontation_mort` img `assets/images/adh6_confrontation_mort.jpeg`
  - [QUIZ] Quiz — Éthique au quotidien — `/gpx/dimension_humaine/ethique/quiz` img `assets/images/quiz.jpeg`

### 7.B Résolution feuille → source de données

### PA — table de résolution
#### institutionValeurs
- **Formation initiale** — badge «Bases & méthodo» — img `assets/images/copic_institutions.jpg` — `/pa/institution/formation_initiale`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La formation initiale | `/pa/institution/formation_initiale/formation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/formation_initiale/formation_initiale_policier_adjoint_page.dart` |
| COURS | Mémento prise de notes & méthodologie | `/pa/institution/formation_initiale/memento_notes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart` |
- **Organisation de la Police Nationale** — badge «Structures & rôles» — img `assets/images/background.jpeg` — `/pa/institution/organisation_pn`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Organigramme du Ministère de l’Intérieur | `/pa/institution/organisation_pn/organigramme_mi` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/organigramme_mi_page.dart` |
| COURS | Organisation & Direction de la Police Nationale | `/pa/institution/organisation_pn/organisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/pa_organisation_page.dart` |
| COURS | Direction générale de la sécurité intérieure | `/pa/institution/organisation_pn/dgsi` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/dgsi_page.dart` |
| COURS | Préfecture de police | `/pa/institution/organisation_pn/prefecture_police` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/prefecture_police_page.dart` |
| COURS | Organigrammes | `/pa/institution/organisation_pn/organigrammes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/organigrammes_pn_page.dart` |
| COURS | Hiérarchie des personnels de la Police Nationale | `/pa/institution/organisation_pn/hierarchie` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/pa_hierarchie_pn_page.dart` |
| COURS | Règles d’emploi des policiers adjoints | `/pa/institution/organisation_pn/regles_emploi_pa` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/regles_emploi_pa_page.dart` |
| COURS | Horaires de service en sécurité publique | `/pa/institution/organisation_pn/horaires_service_sp` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/pa_horaires_service_sp_page.dart` |
| QUIZ | Quiz — Organisation de la Police Nationale | `/pa/institution/organisation_pn/quiz` | Dart-quiz (hardcoded) → DB module OK | `pa_institutions_valeurs_quiz_pa_quiz_organisation_page` | `lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_organisation_page.dart` |
- **Déontologie** — badge «Éthique & cadre» — img `assets/images/cat_organisation.jpg` — `/pa/institution/deontologie`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Code de déontologie commenté (PN & GN) | `/pa/institution/deontologie/code_commente` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/deontologie/gpx_code_deontologie_commente_page.dart` |
| COURS | Marques extérieures de respect (salut, présentation) | `/pa/institution/deontologie/marques_respect` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/deontologie/marques_exterieures_respect_page.dart` |
| COURS | Droits & obligations des policiers | `/pa/institution/deontologie/droits_obligations` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart` |
| COURS | Policier hors service : dois-je intervenir ? (AMARIS) | `/pa/institution/deontologie/hors_service_amaris` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/deontologie/hors_service_amaris_page.dart` |
| COURS | Sanctions & récompenses | `/pa/institution/deontologie/sanctions_recompenses` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/deontologie/sanctions_recompenses_page.dart` |
| COURS | Enquête administrative | `/pa/institution/deontologie/enquete_administrative` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/deontologie/enquete_administrative_page.dart` |
| COURS | Usage des réseaux sociaux | `/pa/institution/deontologie/reseaux_sociaux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/deontologie/reseaux_sociaux_page.dart` |
| QUIZ | Quiz — Déontologie | `/pa/institution/deontologie/quiz` | Dart-quiz (hardcoded) → DB module OK | `pa_institutions_valeurs_quiz_pa_quiz_deontologie` | `lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_deontologie.dart` |
- **Information de la hiérarchie** — badge «Écrits pro» — img `assets/images/cat_hierarchie.jpg` — `/pa/institution/hierarchie_info`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le compte-rendu | `/pa/institution/hierarchie_info/compte_rendu` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/hierarchie_info/compte_rendu_page.dart` |
| COURS | Le formalisme du rapport | `/pa/institution/hierarchie_info/formalisme_rapport` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/hierarchie_info/formalisme_rapport_page.dart` |
| COURS | Modèles de rapports | `/pa/institution/hierarchie_info/modeles` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/hierarchie_info/modeles_rapports_page.dart` |
- **Accueil du public** — badge «Victimes & assistance» — img `assets/images/image1.jpeg` — `/pa/institution/accueil_public`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Charte de l’accueil du public & assistance aux victimes | `/pa/institution/accueil_public/charte` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/accueil_public/charte_accueil_public_victimes_page.dart` |
| COURS | Référentiel Marianne | `/pa/institution/accueil_public/marianne` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart` |
| COURS | Dépliants & doctrine accueil / prise en charge | `/pa/institution/accueil_public/doctrine` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart` |
| COURS | Quelques démarches administratives | `/pa/institution/accueil_public/demarches` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart` |
| COURS | Protection des locaux de police | `/pa/institution/accueil_public/protection_locaux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/accueil_public/protection_locaux_police_page.dart` |
| QUIZ | Quiz — Accueil du public | `/pa/institution/accueil_public/quiz` | Dart-quiz (hardcoded) → DB module OK | `pa_institutions_valeurs_quiz_pa_quiz_accueil_public` | `lib/content/pa_scolarite/institutions_valeurs_quiz/pa_quiz_accueil_public.dart` |
- **Laïcité, police et religions** — badge «Neutralité» — img `assets/images/image6.jpg` — `/pa/institution/laicite`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La laïcité (DLPAJ / bureau des cultes) | `/pa/institution/laicite/laicite_dlpaj` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/laicite/gpx_laicite_dlpaj_page.dart` |
| COURS | Charte de la laïcité dans les services publics | `/pa/institution/laicite/charte` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/laicite/charte_laicite_services_publics_page.dart` |
| COURS | Principaux rites & pratiques des cultes en France | `/pa/institution/laicite/rites_cultes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/laicite/rites_cultes_france_page.dart` |
| QUIZ | Quiz — Laïcité | `/pa/institution/laicite/quiz` | DB-quiz-module | `pa_institution_laicite` |  |
- **Histoire de la police** — badge «Repères» — img `assets/images/image4.jpeg` — `/pa/institution/histoire`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Points de repères chronologiques | `/pa/institution/histoire/reperes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/institution_valeurs/histoire/histoire_reperes_page.dart` |
#### dpsDpg
- **Généralités** — badge «Socle initial» — img `assets/images/generalite.jpeg` — `/pa/dps_dpg/socle_initial/generalites`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Classification des infractions | `/pa/dps_dpg/socle_initial/generalites/classification_infractions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_classification_infractions_page.dart` |
| COURS | L’infraction | `/pa/dps_dpg/socle_initial/generalites/infraction_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_infraction_intro_page.dart` |
| COURS | La tentative punissable | `/pa/dps_dpg/socle_initial/generalites/tentative_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_tentative_intro_page.dart` |
| COURS | La complicité | `/pa/dps_dpg/socle_initial/generalites/complicite_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_complicite_intro_page.dart` |
| COURS | La légitime défense | `/pa/dps_dpg/socle_initial/generalites/legitimedefense_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_ld_intro_page.dart` |
| COURS | Cadre légal d’usage des armes | `/pa/dps_dpg/socle_initial/generalites/usagedesarmes_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_usage_des_armes_intro_page.dart` |
| COURS | Les libertés publiques | `/pa/dps_dpg/libertes_publiques_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/libertes_publiques_pages/liberte_publiques_intro_page.dart` |
| COURS | Rétention dans les locaux de police | `/pa/dps_dpg/socle_initial/generalites/retention_locaux_police_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_retention_locaux_intro.dart` |
- **Hiérarchie — fonctions judiciaires** — badge «Socle initial» — img `assets/images/cat_hierarchie.jpg` — `/pa/dps_dpg/socle_initial/hierarchie`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Hiérarchie des personnels de la Police Nationale | `/pa/dps_dpg/socle_initial/hierarchie/hierarchie_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dps_dpg/generalite_pages/pa_hierarchie_intro_page.dart` |
- **Cadres juridiques** — badge «Socle initial» — img `assets/images/cadres_juridiques.jpeg` — `/pa/dps_dpg/socle_initial/cadres_juridiques`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Les cadres d'enquête | `/pa/dps_dpg/cadres_juridiques/cadres_enquete_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/cadres_enquete/cadres_enquete_intro_page.dart` |
| COURS | L'enquête de flagrant délit | `/pa/dps_dpg/cadres_juridiques/flagrant_delit_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_intro_page.dart` |
| COURS | L'enquête préliminaire | `/pa/dps_dpg/cadres_juridiques/enquete_preliminaire_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_intro_page.dart` |
| COURS | La commission rogatoire | `/pa/dps_dpg/cadres_juridiques/commission_rogatoire_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_intro.dart` |
| COURS | Découverte d'une personne grièvement blessée | `/pa/dps_dpg/cadres_juridiques/personne_blessee_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/personne_grievement_blessee/personne_intro.dart` |
| COURS | Mort de cause inconnue ou suspecte | `/pa/dps_dpg/cadres_juridiques/mort_inconnue/intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_intro_page.dart` |
| COURS | Délinquance & criminalité organisées | `/pa/dps_dpg/cadres_juridiques/criminalite_organisee_contenu` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/criminalite_organisee_contenu_page.dart` |
| COURS | Recherche des personnes en fuite | `/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart` |
| COURS | Disparitions inquiétantes | `/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_intro.dart` |
- **Armes & munitions** — badge «Régimes spéciaux» — img `assets/images/armes_munitions.jpeg` — `/pa/dps_dpg/socle_initial/armes_munitions`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Classification des armes et des munitions | `/pa/dps_dpg/armes_munitions_pages/armes_classification` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_classification_contenu_page.dart` |
| COURS | Définitions | `/pa/dps_dpg/armes_munitions_pages/armes_definitions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_definitions_contenu_page.dart` |
| COURS | Introduction | `/pa/dps_dpg/armes_munitions_pages/armes_introduction` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_introduction_contenu_page.dart` |
| COURS | Acquisition/détention cat. A ou B sans autorisation | `/pa/dps_dpg/armes_munitions_pages/armes_acquisition_detention_ab` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_acquisition_detention_ab_contenu_page.dart` |
| COURS | Port/transport sans motif légitime (cat. C ou D) | `/pa/dps_dpg/armes_munitions_pages/armes_port_transport_cd` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart` |
| COURS | Régimes matériels de guerre / éléments d’arme | `/pa/dps_dpg/armes_munitions_pages/armes_materiels_guerre_elements` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart` |
| COURS | Règles d’acquisition & détention | `/pa/dps_dpg/armes_munitions_pages/armes_regles_acquisition_detention` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_regles_acquisition_detention_contenu_page.dart` |
| COURS | Règles de port & transport | `/pa/dps_dpg/armes_munitions_pages/armes_regles_port_transport` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/armes_munitions_pages/armes_regles_port_transport_contenu_page.dart` |
| QUIZ | Quiz — Classification des armes et des munitions | `/pa/armes_munitions_pages/quiz/pa_quiz_armes_munitions_pages` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_armes_munitions_pages` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_armes_munitions_pages.dart` |
- **La sanction** — badge «Peines & sûreté» — img `assets/images/sanction.jpeg` — `/pa/dps_dpg/sanctions`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Classification des peines et mesures de sûreté | `/pa/dps_dpg/sanctions/classification_peines` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/sanction_pages/classification_peines_page.dart` |
| COURS | Causes d’aggravation de la sanction | `/pa/dps_dpg/sanctions/causes_aggravation_sanction` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction_contenu_page.dart` |
| COURS | Règles en cas de pluralité d’infractions | `/pa/dps_dpg/sanctions/pluralite_infractions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart` |
| QUIZ | Quiz — Sanction (récidive, réitération, concours réel) | `/pa/sanction/quiz/sanction_page` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_sanction` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_sanction.dart` |
- **Crimes & délits contre la nation** — badge «Institutions & justice» — img `assets/images/contre_nation.jpeg` — `/pa/dps_dpg/crimes_nation`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Association de malfaiteurs | `/pa/dps_dpg/atteintes_nation_pages/association_malfaiteurs` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart` |
| COURS | Abus d’autorité contre les particuliers | `/pa/dps_dpg/atteintes_nation_pages/abus_autorite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/abus_autorite/abus_autorite_particuliers_contenu_page.dart` |
| COURS | Atteintes à l’action de la justice | `/pa/dps_dpg/atteintes_nation_pages/atteintes_action_justice` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/atteintes_action_justice/atteintes_action_justice_contenu_page.dart` |
| COURS | Atteintes à l’administration par des particuliers | `/pa/dps_dpg/socle_initial/autorite_etat/outrage` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/atteintes_administration_contenu_page.dart` |
| COURS | Faux et usage de faux | `/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_usage_faux_contenu_page.dart` |
| COURS | Manquements au devoir de probité | `/pa/dps_dpg/atteintes_nation_pages/probite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/probite/probite_contenu_page.dart` |
| QUIZ | Quiz — Abus d’autorité contre les particuliers | `/pa/nation/quiz/abus_autorite_particuliers` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_abus_autorite` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_abus_autorite.dart` |
| QUIZ | Quiz — Atteintes à l’action de la justice | `/pa/nation/quiz/atteintes_action_justice` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_atteintes_action_justice` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteintes_action_justice.dart` |
| QUIZ | Quiz — Atteintes à l’administration | `/pa/nation/quiz/atteintes_administration` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_atteintes_administration` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteintes_administration.dart` |
| QUIZ | Quiz — Faux et usage de faux | `/pa/nation/quiz/faux_usage_faux` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_faux_usage_faux` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_faux_usage_faux.dart` |
| QUIZ | Quiz — Manquements au devoir de probité | `/pa/nation/quiz/probite` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_probite` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_probite.dart` |
- **Atteintes aux mineurs & à la famille** — badge «Protection des mineurs» — img `assets/images/mineurs_famille.jpeg` — `/pa/dps_dpg/mineurs_famille`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La mise en péril des mineurs | `/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart` |
| COURS | Violation d’ordonnances JAF (violences) | `/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/violation_ordonnances_jaf_page.dart` |
| COURS | Atteintes à l’exercice de l’autorité parentale | `/pa/dps_dpg/mineurs_famille_pages/autorite_parentale` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/mineurs_famille_pages/autorite_parentale/autorite_parentale_page.dart` |
| COURS | L’abandon de famille | `/pa/dps_dpg/mineurs_famille_pages/abandon_famille` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/mineurs_famille_pages/abandon_famille/abandon_famille_page.dart` |
| QUIZ | Quiz — L’abandon de famille | `/pa/mineurs_famille_pages/quiz/pa_quiz_mineurs_famille` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_mineurs_famille` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_mineurs_famille.dart` |
- **Procédure Pénale** — badge «Cours & cas pratiques» — img `assets/images/procedure_penale.jpg` — `/pa/dps_dpg/procedure_penale`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Action publique, action civile, autorités & contrôle de la PJ | `/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_autorites_pj_intro_page.dart` |
| COURS | Nullité des actes de procédure | `/pa/dps_dpg/procedure_penale/nullite_intro_page` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/procedure_penale_pages/nullite_intro_page.dart` |
| COURS | Juridictions de jugement & exécution des décisions | `/pa/dps_dpg/procedure_penale/juridictions_contenu` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/procedure_penale_pages/juridiction_contenu_page.dart` |
| COURS | Instruction préparatoire, mandats, contrôle jud., détention provisoire | `/pa/dps_dpg/procedure_penale/pp_instruction_mandats_controle_detention` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/procedure_penale_pages/instruction_preparatoire_intro.dart` |
| QUIZ | Quiz — Action publique | `/pa/procedure_penale/quiz/action_publique` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_action_publique_page` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_action_publique_page.dart` |
| QUIZ | Quiz — Nullité des actes de procédure | `/pa/procedure_penale/quiz/nullite` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_nullite_page` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_nullite_page.dart` |
| QUIZ | Quiz — Juridictions pénales | `/pa/procedure_penale/quiz/juridictions_penales` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_juridiction_page` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_juridiction_page.dart` |
| QUIZ | Quiz — Instruction préparatoire, mandats & détention provisoire | `/pa/procedure_penale/quiz/instruction_preparatoire` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_instruction_page` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_instruction_page.dart` |
- **Contrôle d'identité** — badge «Socle initial» — img `assets/images/controle_identite.jpeg` — `/pa/dps_dpg/socle_initial/controle_identite`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Contrôles et vérifications d'identité | `/pa/dps_dpg/cadres_juridiques/controle_identite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_contenu_page.dart` |
- **Circulation routière** — badge «Socle initial» — img `assets/images/circulation_routiere.jpeg` — `/pa/dps_dpg/socle_initial/circulation`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Compétences des agents verbalisateurs | `/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart` |
| COURS | Conduite après usage de stupéfiants | `/pa/dps_dpg/socle_initial/circulation/conduite_stupefiants` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/conduite_stupefiants_contenu_page.dart` |
| COURS | Conduite en état d'ivresse | `/pa/dps_dpg/socle_initial/circulation/ivresse` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/ivresse_contenu_page.dart` |
| COURS | Conduite sous l'empire d'un état alcoolique | `/pa/dps_dpg/socle_initial/circulation/etat_alcoolique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart` |
| COURS | Défaut d'assurance | `/pa/dps_dpg/socle_initial/circulation/defaut_assurance` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/defaut_assurance_page.dart` |
| COURS | Défaut de permis de conduire | `/pa/dps_dpg/socle_initial/circulation/defaut_permis` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/defaut_permis_contenu_page.dart` |
| COURS | Délit de fuite | `/pa/dps_dpg/socle_initial/circulation/delit_fuite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart` |
| COURS | Grand excès de vitesse | `/pa/dps_dpg/socle_initial/circulation/grand_exces_vitesse` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/grand_exces_vitesse_page.dart` |
| COURS | Refus de vérifications | `/pa/dps_dpg/socle_initial/circulation/refus_verifications` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/refus_verifications_contenu_page.dart` |
| COURS | Refus d'obtempérer | `/pa/dps_dpg/socle_initial/circulation/refus_obtemperer` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/refus_obtemperer_page.dart` |
| COURS | Rodéo motorisé | `/pa/dps_dpg/socle_initial/circulation/rodeo_motorise` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/rodeo_motorise_contenu_page.dart` |
| COURS | Plaques & inscriptions (délits liés) | `/pa/dps_dpg/socle_initial/circulation/plaques_inscriptions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/plaques_inscriptions_page.dart` |
| COURS | Incitation / organisation / promotion | `/pa/dps_dpg/socle_initial/circulation/incitation_organisation_promotion` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/incitation_organisation_promotion_page.dart` |
| QUIZ | Quiz — Infractions à la circulation routière | `/pa/dps_dpg/quiz/quiz_circulation_routiere` | Dart-quiz (hardcoded) → DB module OK | `pa_quiz_scolarite_pa_pa_quiz_circulation_routiere` | `lib/content/pa_scolarite/quiz_scolarite_pa/pa_quiz_circulation_routiere.dart` (route déclarée dans app_router.dart:532) |
- **Organisation judiciaire** — badge «Socle initial» — img `assets/images/cat_organisation.jpg` — `/pa/dps_dpg/socle_initial/organisation_judiciaire`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | L’organisation judiciaire | `/pa/dps_dpg/socle_initial/organisation_judiciaire/organisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart` |
| COURS | La magistrature | `/pa/dps_dpg/socle_initial/organisation_judiciaire/magistrature` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart` |
- **Atteintes aux biens** — badge «Socle initial» — img `assets/images/atteintes_biens.jpeg` — `/pa/dps_dpg/socle_initial/atteintes_biens`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le vol | `/pa/dps_dpg/socle_initial/atteintes_biens/vol` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/vol_page.dart` |
| COURS | Destructions, dégradations, détériorations | `/pa/dps_dpg/socle_initial/atteintes_biens/destructions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/destructions_degradations_contenu_page.dart` |
| COURS | Infractions sans danger pour les personnes | `/pa/dps_dpg/socle_initial/atteintes_biens/sans_danger_personnes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/sans_danger_dommage_leger_contenu_page.dart` |
| COURS | Infractions dangereuses pour les personnes | `/pa/dps_dpg/socle_initial/atteintes_biens/dangereuses_personnes` | Dart-page + ScolariteText fragments |  | `lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart` |
| COURS | Tags et graffitis | `/pa/dps_dpg/socle_initial/atteintes_biens/tags_graffitis` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart` |
- **Atteintes aux personnes** — badge «Socle initial» — img `assets/images/atteintes_personnes.jpeg` — `/pa/dps_dpg/socle_initial/atteintes_personnes`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Les discriminations | `/pa/dps_dpg/socle_initial/atteintes_personnes/discriminations` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/discriminations_contenu_page.dart` |
| COURS | Les violences volontaires | `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_volontaires` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/atteintes_volontaires_integrite_contenu_page.dart` |
| COURS | Les violences habituelles | `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_habituelles` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart` |
| COURS | Violences contre les forces de sécurité intérieure | `/pa/dps_dpg/socle_initial/atteintes_personnes/violences_fsi` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/violences_sur_fsi_page.dart` |
| COURS | Atteintes volontaires à la vie | `/pa/dps_dpg/socle_initial/atteintes_personnes/atteintes_vie` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_volontaire/atteintes_volontaires_vie_contenu_page.dart` |
| COURS | Le viol | `/pa/dps_dpg/socle_initial/atteintes_personnes/viol` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_inceste_agressions_contenu_page.dart` |
| COURS | Agressions sexuelles | `/pa/dps_dpg/socle_initial/atteintes_personnes/agressions_sexuelles` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agressions_sexuelles_autres_que_viol_page.dart` |
| COURS | Harcèlement sexuel | `/pa/dps_dpg/socle_initial/atteintes_personnes/harcelement_sexuel` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/harcelement_sexuel_page.dart` |
| COURS | Exhibition sexuelle | `/pa/dps_dpg/socle_initial/atteintes_personnes/exhibition` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/exhibition_sexuelle_page.dart` |
| COURS | Mise en péril des mineurs | `/pa/dps_dpg/socle_initial/atteintes_personnes/mineurs_mise_en_peril` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart` |
| COURS | Atteinte à l’intimité d’une personne | `/pa/dps_dpg/socle_initial/atteintes_personnes/atteinte_intimite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_personnalite_contenu_page.dart` |
| COURS | Outrage sexiste et sexuel | `/pa/dps_dpg/socle_initial/atteintes_personnes/outrage_sexiste` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart` |
- **Autorité de l’État** — badge «Socle initial» — img `assets/images/autorite_etat.png` — `/pa/dps_dpg/socle_initial/autorite_etat`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Refus d’obtempérer | `/pa/dps_dpg/socle_initial/autorite_etat/refus_obtemperer` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/refus_obtemperer_page.dart` |
| COURS | L’outrage | `/pa/dps_dpg/socle_initial/autorite_etat/outrage` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/atteintes_administration_contenu_page.dart` |
| COURS | La rébellion | `/pa/dps_dpg/socle_initial/autorite_etat/rebellion` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/rebellion_contenu_page.dart` |
| COURS | Provocation directe à la rébellion | `/pa/dps_dpg/socle_initial/autorite_etat/provocation_rebellion` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/provocation_directe_rebellion_contenu_page.dart` |
- **Généralités** — badge «Socle avancé» — img `assets/images/droit_penal_general.jpeg` — `/pa/dps_dpg/socle_avance/generalites`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le droit pénal | `/pa/dps_dpg/socle_avance/generalites/droit_penal` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dpg_pages/loi_penale_contenu_page.dart` |
| COURS | Immunités et inviolabilités | `/pa/dps_dpg/socle_avance/generalites/immunites_inviolabilites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dpg_pages/gpx_school_etendue_application_lois_page.dart` |
| COURS | La responsabilité pénale | `/pa/dps_dpg/socle_avance/generalites/responsabilite_penale` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/dpg_pages/responsabilite_penale_page.dart` |
- **Acteurs de la Police Judiciaire** — badge «Socle avancé» — img `assets/images/police_judiciaire.png` — `/pa/dps_dpg/socle_avance/acteurs_pj`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Compétences des OPJ | `/pa/dps_dpg/socle_avance/acteurs_pj/opj` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_opj_page.dart` |
| COURS | Compétences des APJ | `/pa/dps_dpg/socle_avance/acteurs_pj/apj` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_apj_page.dart` |
| COURS | Assistants d’enquête | `/pa/dps_dpg/socle_avance/acteurs_pj/assistants_enquete` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart` |
| COURS | Prérogatives judiciaires (OPJ / APJ / APJA) | `/pa/dps_dpg/socle_avance/acteurs_pj/prerogatives` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart` |
| COURS | Le procureur de la République | `/pa/dps_dpg/socle_avance/acteurs_pj/procureur` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/procedure_penale_pages/pp_organisation_ministere_public_contenu_page.dart` |
| COURS | Le juge d’instruction | `/pa/dps_dpg/socle_avance/acteurs_pj/juge_instruction` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_judiciaire_pages/juge_instruction_page.dart` |
- **Atteintes aux biens** — badge «Socle avancé» — img `assets/images/atteintes_biens.jpeg` — `/pa/dps_dpg/socle_avance/atteintes_biens`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | L’extorsion | `/pa/dps_dpg/socle_avance/atteintes_biens/extorsion` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/extorsion_contenu_page.dart` |
| COURS | L’escroquerie | `/pa/dps_dpg/socle_avance/atteintes_biens/escroquerie` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/escroquerie_contenu_page.dart` |
| COURS | L’abus de confiance | `/pa/dps_dpg/socle_avance/atteintes_biens/abus_confiance` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart` |
| COURS | La filouterie | `/pa/dps_dpg/socle_avance/atteintes_biens/filouterie` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/filouteries_contenu_page.dart` |
| COURS | Le recel | `/pa/dps_dpg/socle_avance/atteintes_biens/recel` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_biens_pages/recel_non_justification/recel_page.dart` |
| COURS | Abstention volontaire de combattre un sinistre | `/pa/dps_dpg/socle_avance/atteintes_biens/abstention_sinistre` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/atteintes_volontaires_integrite_contenu_page.dart` |
- **Atteintes aux personnes** — badge «Socle avancé» — img `assets/images/contre_personne.jpeg` — `/pa/dps_dpg/socle_avance/atteintes_personnes`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Atteintes involontaires à la vie et à l’intégrité | `/pa/dps_dpg/socle_avance/atteintes_personnes/involontaires` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_contenu_page.dart` |
| COURS | Menaces contre les personnes | `/pa/dps_dpg/socle_avance/atteintes_personnes/menaces` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/menace_sans_condition_page.dart` |
| COURS | Entrave volontaire à l’arrivée des secours | `/pa/dps_dpg/socle_avance/atteintes_personnes/entrave_secours` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_contenu_page.dart` |
| COURS | Non-obstacle à la commission d’un crime ou délit | `/pa/dps_dpg/socle_avance/atteintes_personnes/non_obstacle` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_obstacle_commission_crime_delit_page.dart` |
| COURS | Non-assistance à personne en péril | `/pa/dps_dpg/socle_avance/atteintes_personnes/non_assistance` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart` |
| COURS | Appels téléphoniques malveillants | `/pa/dps_dpg/socle_avance/atteintes_personnes/appels_malveillants` | Dart-page + ScolariteText fragments |  | `lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores_page.dart` |
| COURS | Risque causé à autrui | `/pa/dps_dpg/socle_avance/atteintes_personnes/risque_autrui` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart` |
- **Délits routiers** — badge «Socle avancé» — img `assets/images/circulation_routiere.jpeg` — `/pa/dps_dpg/socle_avance/delits_routiers`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Rodéo motorisé | `/pa/dps_dpg/socle_avance/delits_routiers/rodeo` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/rodeo_motorise_contenu_page.dart` |
| COURS | Incitation / organisation / promotion | `/pa/dps_dpg/socle_avance/delits_routiers/incitation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/incitation_organisation_promotion_page.dart` |
| COURS | Délit de fuite | `/pa/dps_dpg/socle_avance/delits_routiers/delit_fuite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart` |
| COURS | Refus d’obtempérer | `/pa/dps_dpg/socle_avance/delits_routiers/refus_obtemperer` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/refus_obtemperer_page.dart` |
| COURS | Autres délits routiers (alcool, stup, permis, vérifications…) | `/pa/dps_dpg/socle_avance/delits_routiers/autres` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart` |
- **Autorité de l’État** — badge «Socle avancé» — img `assets/images/autorite_etat.png` — `/pa/dps_dpg/socle_avance/autorite_etat`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Menaces envers les dépositaires de l’autorité publique | `/pa/dps_dpg/socle_avance/autorite_etat/menaces` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart` |
| COURS | Corruption passive | `/pa/dps_dpg/socle_avance/autorite_etat/corruption_passive` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/probite/corruption_page.dart` |
| COURS | Corruption active | `/pa/dps_dpg/socle_avance/autorite_etat/corruption_active` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/atteintes_nation_pages/probite/corruption_page.dart` |
- **Stupéfiants** — badge «Socle avancé» — img `assets/images/stupefiants.jpeg` — `/pa/dps_dpg/socle_avance/stupefiants`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Usage illicite de stupéfiants | `/pa/dps_dpg/socle_avance/stupefiants/usage_illicite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/stupefiants_pages/usage_illicite_contenu_page.dart` |
| COURS | Cession / offre illicites (consommation personnelle) | `/pa/dps_dpg/socle_avance/stupefiants/cession_offre` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/stupefiants_pages/cession_offre_contenu_page.dart` |
#### mememtoCirculationRoutiere
- **Procédures circulation routière** — badge «Procédures» — img `assets/images/memento_procedures.jpeg` — `/pa/memento_circulation/procedures`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | L’amende forfaitaire | `/pa/memento_circulation/procedures/amende_forfaitaire` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_page.dart` |
| COURS | L’amende forfaitaire délictuelle | `/pa/memento_circulation/procedures/amende_forfaitaire_delictuelle` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart` |
| COURS | La consignation | `/pa/memento_circulation/procedures/consignation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart` |
| COURS | L’immobilisation du véhicule | `/pa/memento_circulation/procedures/immobilisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/immobilisation_page.dart` |
| COURS | La mise en fourrière | `/pa/memento_circulation/procedures/mise_en_fourriere` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart` |
| COURS | La conduite sous l’influence de l’alcool | `/pa/memento_circulation/procedures/conduite_alcool` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart` |
| COURS | La conduite après usage de stupéfiants | `/pa/memento_circulation/procedures/conduite_stupefiants` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/conduite_apres_usage_stupefiants_page.dart` |
| COURS | La rétention du permis de conduire | `/pa/memento_circulation/procedures/retention_permis` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/retention_permis_conduire_page.dart` |
| COURS | Le permis à points | `/pa/memento_circulation/procedures/permis_a_points` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/permis_a_points_page.dart` |
| QUIZ | Quiz — Procédures circulation | `/pa/memento_circulation/procedures/quiz` | DB-quiz-module | `pa_circulation_procedures` |  |
- **Contrôle routier & pièces** — badge «Contrôle» — img `assets/images/memento_controle_routier.jpeg` — `/pa/memento_circulation/controle_routier`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le cadre légal du contrôle routier | `/pa/memento_circulation/controle_routier/cadre_legal` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart` |
| COURS | Le permis de conduire | `/pa/memento_circulation/controle_routier/permis_conduire` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart` |
| COURS | Le brevet de sécurité routière | `/pa/memento_circulation/controle_routier/bsr` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/bsr_page.dart` |
| COURS | Les certificats d’immatriculation | `/pa/memento_circulation/controle_routier/certificat_immatriculation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart` |
| COURS | Le contrôle technique des véhicules | `/pa/memento_circulation/controle_routier/controle_technique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/controle_technique_page.dart` |
| COURS | L’assurance | `/pa/memento_circulation/controle_routier/assurance_obligatoire` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/assurance_obligatoire_page.dart` |
| QUIZ | Quiz — Contrôle routier | `/pa/memento_circulation/controle_routier/quiz` | DB-quiz-module | `pa_circulation_controle_routier` |  |
- **Équipements véhicules & usagers** — badge «Équipements» — img `assets/images/memento_equipements.jpeg` — `/pa/memento_circulation/equipements`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Les pneumatiques | `/pa/memento_circulation/equipements/pneumatiques` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart` |
| COURS | Éclairage et signalisation | `/pa/memento_circulation/equipements/eclairage_signalisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart` |
| COURS | Chargement | `/pa/memento_circulation/equipements/chargement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/chargement_page.dart` |
| COURS | Les plaques | `/pa/memento_circulation/equipements/plaques` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/plaques_page.dart` |
| COURS | Miroirs / rétroviseurs / vision indirecte | `/pa/memento_circulation/equipements/retroviseurs_vision` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/retroviseurs_vision_page.dart` |
| COURS | Les essuie-glace | `/pa/memento_circulation/equipements/essuie_glace` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/essuie_glace_page.dart` |
| COURS | Nuisances des véhicules (fumées, bruit, avertisseur sonore) | `/pa/memento_circulation/equipements/nuisances` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart` |
| COURS | Ceinture de sécurité / retenue enfant | `/pa/memento_circulation/equipements/ceinture_retenue_enfant` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart` |
| COURS | Casque et gants de protection | `/pa/memento_circulation/equipements/casque_gants` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/casque_gants_page.dart` |
| COURS | Casque "cycliste" | `/pa/memento_circulation/equipements/casque_cycliste` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart` |
| COURS | Gilet de haute visibilité | `/pa/memento_circulation/equipements/gilet_haute_visibilite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/gilet_haute_visibilite_page.dart` |
| QUIZ | Quiz — Équipements | `/pa/memento_circulation/equipements/quiz` | DB-quiz-module | `pa_circulation_equipements` |  |

### GPX — table de résolution
#### institutionValeurs
- **Formation initiale** — badge «Bases & méthodo» — img `assets/images/copic_institutions.jpg` — `/gpx/institution/formation_initiale`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La formation initiale | `/gpx/institution/formation_initiale/formation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart` |
| COURS | Mémento prise de notes & méthodologie | `/gpx/institution/formation_initiale/memento_notes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart` |
- **Organisation de la Police Nationale** — badge «Structures & rôles» — img `assets/images/background.jpeg` — `/gpx/institution/organisation_pn`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Organigramme du Ministère de l’Intérieur | `/gpx/institution/organisation_pn/organigramme_mi` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/organigramme_mi_page.dart` |
| COURS | Organisation & Direction de la Police Nationale | `/gpx/institution/organisation_pn/organisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/organisation_page.dart` |
| COURS | Direction générale de la sécurité intérieure | `/gpx/institution/organisation_pn/dgsi` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/dgsi_page.dart` |
| COURS | Préfecture de police | `/gpx/institution/organisation_pn/prefecture_police` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/prefecture_police_page.dart` |
| COURS | Organigrammes | `/gpx/institution/organisation_pn/organigrammes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/organigrammes_pn_page.dart` |
| COURS | Hiérarchie des personnels de la Police Nationale | `/gpx/institution/organisation_pn/hierarchie` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/hierarchie_pn_page.dart` |
| COURS | Règles d’emploi des policiers adjoints | `/gpx/institution/organisation_pn/regles_emploi_pa` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/regles_emploi_pa_page.dart` |
| COURS | Horaires de service en sécurité publique | `/gpx/institution/organisation_pn/horaires_service_sp` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/pa_scolarite/organisation_pn/horaires_service_sp_page.dart` |
| QUIZ | Quiz — Organisation (global) | `/gpx/institution/organisation_pn/quiz` | Dart-quiz (hardcoded) → DB module OK | `gpx_institutions_valeurs_quiz_institutions_valeurs_quiz_organisation_page` | `lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart` |
- **Déontologie** — badge «Éthique & cadre» — img `assets/images/cat_organisation.jpg` — `/gpx/institution/deontologie`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Code de déontologie commenté (PN & GN) | `/gpx/institution/deontologie/code_commente` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/deontologie/gpx_code_deontologie_commente_page.dart` |
| COURS | Marques extérieures de respect (salut, présentation) | `/gpx/institution/deontologie/marques_respect` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/deontologie/marques_exterieures_respect_page.dart` |
| COURS | Droits & obligations des policiers | `/gpx/institution/deontologie/droits_obligations` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/deontologie/droits_obligations_policiers_page.dart` |
| COURS | Policier hors service : dois-je intervenir ? (AMARIS) | `/gpx/institution/deontologie/hors_service_amaris` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/deontologie/hors_service_amaris_page.dart` |
| COURS | Sanctions & récompenses | `/gpx/institution/deontologie/sanctions_recompenses` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart` |
| COURS | Enquête administrative | `/gpx/institution/deontologie/enquete_administrative` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/deontologie/enquete_administrative_page.dart` |
| COURS | Usage des réseaux sociaux | `/gpx/institution/deontologie/reseaux_sociaux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/deontologie/reseaux_sociaux_page.dart` |
| QUIZ | Quiz — Déontologie | `/gpx/institution/deontologie/quiz` | Dart-quiz (hardcoded) → DB module OK | `gpx_institutions_valeurs_quiz_institutions_valeurs_quiz_deontologie` | `lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_deontologie.dart` |
- **Information de la hiérarchie** — badge «Écrits pro» — img `assets/images/cat_hierarchie.jpg` — `/gpx/institution/hierarchie_info`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le compte-rendu | `/gpx/institution/hierarchie_info/compte_rendu` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/hierarchie_info/compte_rendu_page.dart` |
| COURS | Le formalisme du rapport | `/gpx/institution/hierarchie_info/formalisme_rapport` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/hierarchie_info/formalisme_rapport_page.dart` |
| COURS | Modèles de rapports | `/gpx/institution/hierarchie_info/modeles` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/hierarchie_info/modeles_rapports_page.dart` |
- **Accueil du public** — badge «Victimes & assistance» — img `assets/images/image1.jpeg` — `/gpx/institution/accueil_public`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Charte de l’accueil du public & assistance aux victimes | `/gpx/institution/accueil_public/charte` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart` |
| COURS | Référentiel Marianne | `/gpx/institution/accueil_public/marianne` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/accueil_public/referentiel_marianne_page.dart` |
| COURS | Dépliants & doctrine accueil / prise en charge | `/gpx/institution/accueil_public/doctrine` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart` |
| COURS | Quelques démarches administratives | `/gpx/institution/accueil_public/demarches` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/accueil_public/demarches_administratives_page.dart` |
| COURS | Protection des locaux de police | `/gpx/institution/accueil_public/protection_locaux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/accueil_public/protection_locaux_police_page.dart` |
| QUIZ | Quiz — Accueil du public | `/gpx/institution/accueil_public/quiz` | Dart-quiz (hardcoded) → DB module OK | `gpx_institutions_valeurs_quiz_institutions_valeurs_quiz_accueil_public` | `lib/content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_accueil_public.dart` |
- **Laïcité, police et religions** — badge «Neutralité» — img `assets/images/image6.jpg` — `/gpx/institution/laicite`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La laïcité (DLPAJ / bureau des cultes) | `/gpx/institution/laicite/laicite_dlpaj` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/laicite/gpx_laicite_dlpaj_page.dart` |
| COURS | Charte de la laïcité dans les services publics | `/gpx/institution/laicite/charte` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/laicite/charte_laicite_services_publics_page.dart` |
| COURS | Principaux rites & pratiques des cultes en France | `/gpx/institution/laicite/rites_cultes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/laicite/rites_cultes_france_page.dart` |
| QUIZ | Quiz — Laïcité | `/gpx/institution/laicite/quiz` | DB-quiz-module | `gpx_institution_laicite` |  |
- **Histoire de la police** — badge «Repères» — img `assets/images/image4.jpeg` — `/gpx/institution/histoire`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Points de repères chronologiques | `/gpx/institution/histoire/reperes` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/institutions_valeurs/histoire/histoire_reperes_page.dart` |
#### dpsDpg
- **Généralités** — badge «Concepts de base» — img `assets/images/generalite.jpeg` — `/gpx_scolarite_pages/generalite_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Classification des infractions | `/gpx/generalites/classification_infractions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/classification_infractions_page.dart` |
| COURS | L'infraction | `/gpx/generalites/infraction_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/infraction/infraction_intro_page.dart` |
| COURS | La tentative punissable | `/gpx/generalites/tentative_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/tentative/tentative_intro_page.dart` |
| COURS | La complicité | `/gpx/generalites/complicite_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_intro_page.dart` |
| COURS | La légitime défense | `/gpx/generalites/legitimedefense_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_intro_page.dart` |
| COURS | Cadre légal d'usage des armes | `/gpx/generalites/usagedesarmes_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_intro_page.dart` |
| COURS | Les libertés publiques | `/gpx/generalites/libertespubliques_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/libert#U00e9s_publiques/liberte_publiques_intro_page.dart` |
| COURS | Cas de rétention dans les locaux de police | `/gpx/generalites/retention_locaux_police_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_locaux_intro.dart` |
| COURS | La hiérarchie des personnels de la Police Nationale : Fonctions judiciaires | `/gpx/generalites/hierarchie_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_intro_page.dart` |
| QUIZ | Quiz généralités, classification des infractions, infraction, tentative punissable etc.. | `/gpx/procedure_penale/quiz/generalité_principales` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_generalite_pages_quizz_generalit_quiz_generalite_page` | `lib/content/gpx_scolarite/dps_dpg/generalite_pages/quizz_generalit#U00e9/quiz_generalite_page.dart` |
- **Cadres juridiques** — badge «Cadres d'enquête» — img `assets/images/cadres_juridiques.jpeg` — `/gpx_scolarite_pages/cadres_juridiques_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Les cadres d'enquête | `/gpx/generalites/cadres_enquete_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/cadres_enquete/cadres_enquete_intro_page.dart` |
| COURS | L’enquête de flagrant délit | `/gpx/generalites/flagrant_delit_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_intro_page.dart` |
| COURS | L’enquête préliminaire | `/gpx/generalites/enquete_preliminaire_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_intro_page.dart` |
| COURS | La commission rogatoire | `/gpx/generalites/commission_rogatoire_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_intro.dart` |
| COURS | Découverte d’une personne grièvement blessée | `/gpx/generalites/personne_blessee_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personne_grievement_blessee/personne_intro.dart` |
| COURS | Mort de cause inconnue ou suspecte | `/gpx/generalites/mort_inconnue_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_page_intro.dart` |
| COURS | Délinquance & criminalité organisées | `/gpx/generalites/criminalite_deliquance_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/criminalite_deliquance_intro_page.dart` |
| COURS | Recherche des personnes en fuite | `/gpx/generalites/personnes_fuite_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_intro.dart` |
| COURS | Disparitions inquiétantes | `/gpx/cadres_juridiques/disparitions_inquietantes_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparitions_inquietantes_intro.dart` |
| COURS | Contrôles et vérifications d’identité | `/gpx/generalites/flagrant_delit_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_intro_page.dart` |
| COURS | Entraide judiciaire internationale | `/gpx/generalites/entraide_judiciaire_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_intro_page.dart` |
| QUIZ | Quiz cadres juridiques, les cadres d'enquête, l'enquête de flagrant délit etc.. | `/gpx/procedure_penale/quiz/cadres_juridiques_principales` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_cadres_juridiques_pages_quiz_cadres_juridiques_quiz_page_cadres_juridique` | `lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/quiz_cadres_juridiques/quiz_page_cadres_juridique.dart` |
- **Procédure Pénale** — badge «Cours & cas pratiques» — img `assets/images/procedure_penale.jpg` — `/gpx_scolarite_pages/procédure_pénale_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Action publique, action civile, autorités & contrôle de la PJ | `/gpx_scolarite_pages/procédure_pénale_pages/pp_action_publique_autorites_pj` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/proc#U00e9dure_p#U00e9nale_pages/pp_action_publique_autorites_pj_page.dart` |
| COURS | Nullité des actes de procédure | `/gpx_scolarite_pages/procédure_pénale_pages/nullite_intro_page` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/proc#U00e9dure_p#U00e9nale_pages/nullite_intro_page.dart` |
| COURS | Juridictions de jugement & exécution des décisions | `/gpx_scolarite_pages/procédure_pénale_pages/juridictions_intro` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/proc#U00e9dure_p#U00e9nale_pages/juridiction_intro_page.dart` |
| COURS | Instruction préparatoire, mandats, contrôle jud., détention provisoire | `/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_mandats_controle_detention` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/proc#U00e9dure_p#U00e9nale_pages/instruction_preparatoire_intro.dart` |
| QUIZ | Quiz instruction préparatoire, mandats & détention provisoire | `/gpx/procedure_penale/quiz/instruction_preparatoire` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_proc_dure_p_nale_pages_quiz_procedure_penale_quiz_instruction_page` | `lib/content/gpx_scolarite/dps_dpg/proc#U00e9dure_p#U00e9nale_pages/quiz_procedure_penale/quiz_instruction_page.dart` |
- **Droit pénal général** — badge «Loi & responsabilité» — img `assets/images/droit_penal_general.jpeg` — `/gpx_scolarite_pages/droit_pénale_général_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | De la loi pénale | `/gpx_scolarite_pages/droit_pénale_général_pages/loi_penale` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/droit_p#U00e9nale_g#U00e9n#U00e9ral_pages/loi_penale_contenu_page.dart` |
| COURS | De la responsabilité pénale | `/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/droit_p#U00e9nale_g#U00e9n#U00e9ral_pages/responsabilite_penale_contenu.dart` |
- **La sanction** — badge «Peines & sûreté» — img `assets/images/sanction.jpeg` — `/gpx_scolarite_pages/sanction_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Classification des peines et mesures de sûreté | `/gpx_scolarite_pages/sanction_pages/classification_peines` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/sanction_pages/classification_peines_contenu_page.dart` |
| COURS | Causes d’aggravation de la sanction | `/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction_contenu_page.dart` |
| COURS | Règles en cas de pluralité d’infractions | `/gpx_scolarite_pages/sanction_pages/pluralite_infractions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/sanction_pages/pluralite_infractions_contenu_page.dart` |
| QUIZ | Quiz — Sanction  (récidive, réitération, concours réel) | `/gpx/sanction/quiz/sanction_page` | Dart-quiz (hardcoded) → DB module OK | `gpx_quiz_scolarite_gpx_gpx_quiz_sanction` | `lib/content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_sanction.dart` |
- **Crimes & délits contre la personne** — badge «Atteintes aux personnes» — img `assets/images/contre_personne.jpeg` — `/gpx_scolarite_pages/crime_delit_contre_personne_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La mise en danger de la personne | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/mise_en_danger` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/mise_en_danger/mise_en_danger_contenu_page.dart` |
| COURS | Le viol, l’inceste et autres agressions sexuelles | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/avertissement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_inceste_agressions_avertissement_page.dart` |
| COURS | L’enlèvement et la séquestration | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/enlevement_sequestration` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enlevement_sequestration_page.dart` |
| COURS | Enregistrement & diffusion d’images | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/enregistrement_diffusion_images` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/enregistrement_diffusion_images/enregistrement_diffusion_images_contenu_page.dart` |
| COURS | Atteintes à la dignité de la personne | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/dignite_personne_contenu_page.dart` |
| COURS | Atteintes à la personnalité | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/personnalite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_personnalite_contenu_page.dart` |
| COURS | Atteintes involontaires à la vie et à l’intégrité | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_involontaires/atteintes_involontaires_contenu_page.dart` |
| COURS | Atteintes volontaires à la vie | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_vie` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_volontaire/atteintes_volontaires_vie_contenu_page.dart` |
| COURS | Atteintes volontaires à l’intégrité physique | `/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_volontaires_integrite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteintes_volontaires_integrite/atteintes_volontaires_integrite_contenu_page.dart` |
| QUIZ | Quiz — Crimes & délits contre la personne | `/gpx/crimes_personne/quiz/crimes_delits_personne` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_crime_delit_contre_personne_pages_quiz_crime_delit_personne_quiz_crimes_delits_personne` | `lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/quiz_crime_delit_personne/quiz_crimes_delits_personne.dart` |
- **Atteintes aux mineurs & à la famille** — badge «Protection des mineurs» — img `assets/images/mineurs_famille.jpeg` — `/gpx_scolarite_pages/mineurs_famille_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La mise en péril des mineurs | `/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart` |
| COURS | Violation d’ordonnances JAF (violences) | `/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/violation_ordonnances_jaf_page.dart` |
| COURS | Atteintes à l’exercice de l’autorité parentale | `/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/autorite_parentale/autorite_parentale_page.dart` |
| COURS | L’abandon de famille | `/gpx_scolarite_pages/mineurs_famille_pages/abandon_famille` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/abandon_famille/abandon_famille_page.dart` |
| QUIZ | Quiz — L’abandon de famille | `/gpx/mineurs_famille_pages/quiz/quiz_mineurs_famille` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_mineurs_famille_pages_quiz_mineurs_pages_quiz_mineurs_famille` | `lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/quiz_mineurs_pages/quiz_mineurs_famille.dart` |
- **Crimes & délits contre la nation** — badge «Institutions & justice» — img `assets/images/contre_nation.jpeg` — `/gpx_scolarite_pages/crime_delit_nation_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Association de malfaiteurs | `/gpx_scolarite_pages/crime_delit_nation_pages/association_malfaiteurs` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/association_malfaiteurs_contenu_page.dart` |
| COURS | Abus d’autorité contre les particuliers | `/gpx_scolarite_pages/crime_delit_nation_pages/abus_autorite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/abus_autorite/abus_autorite_particuliers_contenu_page.dart` |
| COURS | Atteintes à l’action de la justice | `/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_action_justice` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/atteintes_action_justice_contenu_page.dart` |
| COURS | Atteintes à l’administration par des particuliers | `/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_administration/atteintes_administration_contenu_page.dart` |
| COURS | Faux et usage de faux | `/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_usage_faux_contenu_page.dart` |
| COURS | Manquements au devoir de probité | `/gpx_scolarite_pages/crime_delit_nation_pages/probite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart` |
| QUIZ | Quiz — Crimes & délits contre la nation | `/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_nation` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_crime_delit_nation_pages_quiz_delit_nation_quiz_crimes_delits_nation` | `lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/quiz_delit_nation/quiz_crimes_delits_nation.dart` |
- **Crimes & délits contre les biens** — badge «Atteintes aux biens» — img `assets/images/contre_biens.jpeg` — `/gpx_scolarite_pages/crime_delit_bien_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Recel & non-justification de ressources | `/gpx_scolarite_pages/crime_delit_bien_pages/recel_non_justification` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/recel_non_justification/recel_non_justification_contenu_page.dart` |
| COURS | Le vol | `/gpx_scolarite_pages/crime_delit_bien_pages/vol` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/vol_page.dart` |
| COURS | Atteintes aux STAD (informatique) | `/gpx_scolarite_pages/crime_delit_bien_pages/stad` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/stad/stad_contenu_page.dart` |
| COURS | Contrefaçons & falsifications de chèques | `/gpx_scolarite_pages/crime_delit_bien_pages/contrefacons_falsifications` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/contrefacons_falsifications/contrefacons_falsifications_cheques_page.dart` |
| COURS | Destructions, dégradations, détériorations | `/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/destructions_degradations_contenu_page.dart` |
| COURS | Infractions voisines du vol | `/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/voisines_du_vol_contenu_page.dart` |
| QUIZ | Quiz — Crimes & délits contre les biens | `/gpx/crime_delit_nation_pages/quiz/quiz_crimes_delits_bien` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_crime_delit_bien_pages_quiz_crime_delit_bien_pages_quiz_crimes_delits_bien` | `lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/quiz_crime_delit_bien_pages/quiz_crimes_delits_bien.dart` |
- **Infractions à la circulation routière** — badge «Code de la route» — img `assets/images/circulation_routiere.jpeg` — `/gpx_scolarite_pages/infraction_circulation_routière_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Conduite après usage de stupéfiants | `/gpx_scolarite_pages/infraction_circulation_routière_pages/conduite_stupefiants` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/conduite_stupefiants_contenu_page.dart` |
| COURS | Conduite en état d’ivresse | `/gpx_scolarite_pages/infraction_circulation_routière_pages/ivresse` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/ivresse_contenu_page.dart` |
| COURS | Conduite sous l’empire d’un état alcoolique | `/gpx_scolarite_pages/infraction_circulation_routière_pages/etat_alcoolique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/etat_alcoolique_contenu_page.dart` |
| COURS | Défaut d’assurance | `/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_assurance` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/defaut_assurance_page.dart` |
| COURS | Défaut de permis de conduire | `/gpx_scolarite_pages/infraction_circulation_routière_pages/defaut_permis` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/defaut_permis_contenu_page.dart` |
| COURS | Délit de fuite | `/gpx_scolarite_pages/infraction_circulation_routière_pages/delit_fuite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/delit_fuite_page.dart` |
| COURS | Grand excès de vitesse | `/gpx_scolarite_pages/infraction_circulation_routière_pages/grand_exces_vitesse` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/grand_exces_vitesse_page.dart` |
| COURS | Refus de vérifications | `/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_verifications` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/refus_verifications_contenu_page.dart` |
| COURS | Refus d’obtempérer | `/gpx_scolarite_pages/infraction_circulation_routière_pages/refus_obtemperer` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/refus_obtemperer_page.dart` |
| COURS | Rodéo motorisé | `/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/rodeo_motorise_contenu_page.dart` |
| COURS | Plaques & inscriptions (délits liés) | `/gpx_scolarite_pages/infraction_circulation_routière_pages/plaques_inscriptions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/plaques_inscriptions_page.dart` |
| COURS | Incitation / organisation / promotion | `/gpx_scolarite_pages/infraction_circulation_routière_pages/incitation_organisation_promotion` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/incitation_organisation_promotion_page.dart` |
| QUIZ | Quiz — Infractions à la circulation routière | `/gpx/infraction_circulation_routière_pages/quiz/quiz_circulation_routiere` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_infraction_circulation_routi_re_pages_quiz_circulation_routiere` | `lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routi#U00e8re_pages/quiz_circulation_routiere.dart` |
- **Armes & munitions** — badge «Régimes spéciaux» — img `assets/images/armes_munitions.jpeg` — `/gpx_scolarite_pages/armes_munitions_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Classification des armes et des munitions | `/gpx_scolarite_pages/armes_munitions_pages/armes_classification` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_classification_contenu_page.dart` |
| COURS | Définitions | `/gpx_scolarite_pages/armes_munitions_pages/armes_definitions` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_definitions_contenu_page.dart` |
| COURS | Introduction | `/gpx_scolarite_pages/armes_munitions_pages/armes_introduction` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_introduction_contenu_page.dart` |
| COURS | Acquisition/détention cat. A ou B sans autorisation | `/gpx_scolarite_pages/armes_munitions_pages/armes_acquisition_detention_ab` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_acquisition_detention_ab_contenu_page.dart` |
| COURS | Port/transport sans motif légitime (cat. C ou D) | `/gpx_scolarite_pages/armes_munitions_pages/armes_port_transport_cd` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart` |
| COURS | Régimes matériels de guerre / éléments d’arme | `/gpx_scolarite_pages/armes_munitions_pages/armes_materiels_guerre_elements` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart` |
| COURS | Règles d’acquisition & détention | `/gpx_scolarite_pages/armes_munitions_pages/armes_regles_acquisition_detention` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_regles_acquisition_detention_contenu_page.dart` |
| COURS | Règles de port & transport | `/gpx_scolarite_pages/armes_munitions_pages/armes_regles_port_transport` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/armes_regles_port_transport_contenu_page.dart` |
| QUIZ | Quiz — Classification des armes et des munitions | `/gpx/armes_munitions_pages/quiz/quiz_armes_munitions_pages` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_armes_munitions_pages_quiz_armes_munitions_pages` | `lib/content/gpx_scolarite/dps_dpg/armes_munitions_pages/quiz_armes_munitions_pages.dart` |
- **Libertés publiques** — badge «Droits & garanties» — img `assets/images/libertes_publiques.jpeg` — `/gpx/generalites/libertespubliques_intro`
- **Stupéfiants — usage & trafic** — badge «Stups» — img `assets/images/stupefiants.jpeg` — `/gpx_scolarite_pages/stupéfiants_pages`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Introduction | `/gpx_scolarite_pages/stupéfiants_pages/introduction` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/introduction_contenu_page.dart` |
| COURS | Cession/offre illicites pour consommation personnelle | `/gpx_scolarite_pages/stupéfiants_pages/cession_offre` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/cession_offre_contenu_page.dart` |
| COURS | Direction/organisation d’un trafic | `/gpx_scolarite_pages/stupéfiants_pages/direction_organisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/direction_organisation_contenu_page.dart` |
| COURS | Facilitation à l’usage illicite | `/gpx_scolarite_pages/stupéfiants_pages/facilitation_usage` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/facilitation_usage_contenu_page.dart` |
| COURS | Production/fabrication illicites | `/gpx_scolarite_pages/stupéfiants_pages/production_fabrication` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/production_fabrication_contenu_page.dart` |
| COURS | Provocation d’un majeur à l’usage ou au trafic | `/gpx_scolarite_pages/stupéfiants_pages/provocation_majeur` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/provocation_majeur_contenu_page.dart` |
| COURS | Blanchiment du produit du trafic | `/gpx_scolarite_pages/stupéfiants_pages/blanchiment_produit` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/blanchiment_produit_contenu_page.dart` |
| COURS | Transport/détention/offre/cession/acquisition/emploi | `/gpx_scolarite_pages/stupéfiants_pages/transport_detention_offre` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/transport_detention_offre_contenu_page.dart` |
| COURS | Importation/exportation illicites | `/gpx_scolarite_pages/stupéfiants_pages/import_export` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/import_export_contenu_page.dart` |
| COURS | Usage illicite de stupéfiants | `/gpx_scolarite_pages/stupéfiants_pages/usage_illicite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/usage_illicite_contenu_page.dart` |
| QUIZ | Quiz — Stupéfiants — usage & trafic | `/gpx/stupéfiants_pages/quiz/quiz_stupéfiants` | Dart-quiz (hardcoded) → DB module OK | `gpx_dps_dpg_stup_fiants_pages_quiz_stup_fiants` | `lib/content/gpx_scolarite/dps_dpg/stup#U00e9fiants_pages/quiz_stup#U00e9fiants.dart` |
#### mememtoCirculationRoutiere
- **Procédures circulation routière** — badge «Procédures» — img `assets/images/memento_procedures.jpeg` — `/gpx/memento_circulation/procedures`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | L’amende forfaitaire | `/gpx/memento_circulation/procedures/amende_forfaitaire` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_page.dart` |
| COURS | L’amende forfaitaire délictuelle | `/gpx/memento_circulation/procedures/amende_forfaitaire_delictuelle` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart` |
| COURS | La consignation | `/gpx/memento_circulation/procedures/consignation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart` |
| COURS | L’immobilisation du véhicule | `/gpx/memento_circulation/procedures/immobilisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/immobilisation_page.dart` |
| COURS | La mise en fourrière | `/gpx/memento_circulation/procedures/mise_en_fourriere` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart` |
| COURS | La conduite sous l’influence de l’alcool | `/gpx/memento_circulation/procedures/conduite_alcool` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart` |
| COURS | La conduite après usage de stupéfiants | `/gpx/memento_circulation/procedures/conduite_stupefiants` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/conduite_apres_usage_stupefiants_page.dart` |
| COURS | La rétention du permis de conduire | `/gpx/memento_circulation/procedures/retention_permis` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/retention_permis_conduire_page.dart` |
| COURS | Le permis à points | `/gpx/memento_circulation/procedures/permis_a_points` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/procedures/permis_a_points_page.dart` |
| QUIZ | Quiz — Procédures circulation | `/gpx/memento_circulation/procedures/quiz` | DB-quiz-module | `gpx_circulation_procedures` |  |
- **Contrôle routier & pièces** — badge «Contrôle» — img `assets/images/memento_controle_routier.jpeg` — `/gpx/memento_circulation/controle_routier`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le cadre légal du contrôle routier | `/gpx/memento_circulation/controle_routier/cadre_legal` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart` |
| COURS | Le permis de conduire | `/gpx/memento_circulation/controle_routier/permis_conduire` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart` |
| COURS | Le brevet de sécurité routière | `/gpx/memento_circulation/controle_routier/bsr` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/bsr_page.dart` |
| COURS | Les certificats d’immatriculation | `/gpx/memento_circulation/controle_routier/certificat_immatriculation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart` |
| COURS | Le contrôle technique des véhicules | `/gpx/memento_circulation/controle_routier/controle_technique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/controle_technique_page.dart` |
| COURS | L’assurance | `/gpx/memento_circulation/controle_routier/assurance_obligatoire` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/controle_routier/assurance_obligatoire_page.dart` |
| QUIZ | Quiz — Contrôle routier | `/gpx/memento_circulation/controle_routier/quiz` | DB-quiz-module | `gpx_circulation_controle_routier` |  |
- **Équipements véhicules & usagers** — badge «Équipements» — img `assets/images/memento_equipements.jpeg` — `/gpx/memento_circulation/equipements`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Les pneumatiques | `/gpx/memento_circulation/equipements/pneumatiques` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart` |
| COURS | Éclairage et signalisation | `/gpx/memento_circulation/equipements/eclairage_signalisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart` |
| COURS | Chargement | `/gpx/memento_circulation/equipements/chargement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/chargement_page.dart` |
| COURS | Les plaques | `/gpx/memento_circulation/equipements/plaques` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/plaques_page.dart` |
| COURS | Miroirs / rétroviseurs / vision indirecte | `/gpx/memento_circulation/equipements/retroviseurs_vision` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/retroviseurs_vision_page.dart` |
| COURS | Les essuie-glace | `/gpx/memento_circulation/equipements/essuie_glace` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/essuie_glace_page.dart` |
| COURS | Nuisances des véhicules (fumées, bruit, avertisseur sonore) | `/gpx/memento_circulation/equipements/nuisances` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart` |
| COURS | Ceinture de sécurité / retenue enfant | `/gpx/memento_circulation/equipements/ceinture_retenue_enfant` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart` |
| COURS | Casque et gants de protection | `/gpx/memento_circulation/equipements/casque_gants` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/casque_gants_page.dart` |
| COURS | Casque “cycliste” | `/gpx/memento_circulation/equipements/casque_cycliste` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart` |
| COURS | Gilet de haute visibilité | `/gpx/memento_circulation/equipements/gilet_haute_visibilite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/equipements/gilet_haute_visibilite_page.dart` |
| QUIZ | Quiz — Équipements | `/gpx/memento_circulation/equipements/quiz` | DB-quiz-module | `gpx_circulation_equipements` |  |
- **Natinf** — badge «Natinf» — img `assets/images/natinf.png` — `/gpx/memento_circulation/natinf`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Natinf | `/gpx/memento_circulation/controle_routier/natinf` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart` |
#### policierEnInterventionsa
- **Circulation & séjour des étrangers** — badge «Étrangers» — img `assets/images/mandat_arret.jpeg` — `/gpx/intervention/etrangers`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | L’accord de Schengen | `/gpx/intervention/etrangers/schengen` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart` |
| COURS | Coopération policière et judiciaire (UE) | `/gpx/intervention/etrangers/cooperation-ue` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart` |
| COURS | Les différents titres de séjour | `/gpx/intervention/etrangers/titres-sejour` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart` |
| QUIZ | Quiz — Étrangers | `/gpx/intervention/etrangers/quiz` | DB-quiz-module | `gpx_intervention_etrangers` |  |
- **Protection des mineurs** — badge «Mineurs» — img `assets/images/mineurs_famille.jpeg` — `/gpx/intervention/mineurs`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le statut juridique du mineur | `/gpx/intervention/mineurs/statut-juridique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart` |
| COURS | Protection des mineurs sur la voie publique | `/gpx/intervention/mineurs/voie-publique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/mineurs/protection_mineurs_voie_publique_page.dart` |
| QUIZ | Quiz — Mineurs | `/gpx/intervention/mineurs/quiz` | DB-quiz-module | `gpx_intervention_mineurs` |  |
- **Accident de la circulation** — badge «Accident» — img `assets/images/mise_en_danger.jpeg` — `/gpx/intervention/accident-circulation`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Technique du plan des lieux | `/gpx/intervention/accident-circulation/plan-lieux-technique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/plan_lieux_technique_page.dart` |
| COURS | Différents modèles de plan | `/gpx/intervention/accident-circulation/modeles-plan` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/modeles_plan_page.dart` |
| COURS | Renseignements à recueillir sur les lieux | `/gpx/intervention/accident-circulation/renseignements-a-recueillir` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart` |
| COURS | Tableau synthèse des renseignements à recueillir | `/gpx/intervention/accident-circulation/tableau-synthese` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/tableau_synthese_page.dart` |
| COURS | L’avis à la famille | `/gpx/intervention/accident-circulation/avis-famille` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/avis_famille_page.dart` |
| COURS | “J’annonce une mauvaise nouvelle” (AMARIS) | `/gpx/intervention/accident-circulation/annoncer-mauvaise-nouvelle` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart` |
| QUIZ | Quiz — Accident | `/gpx/intervention/accident-circulation/quiz` | DB-quiz-module | `gpx_intervention_accident_circulation` |  |
- **Intervention : usage de stupéfiants** — badge «Stupéfiants» — img `assets/images/stupefiants.jpeg` — `/gpx/intervention/stupefiants`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Amende forfaitaire délictuelle (usage illicite) | `/gpx/intervention/stupefiants/amende-forfaitaire-delictuelle` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/stupefiants/amende_forfaitaire_delictuelle_page.dart` |
| QUIZ | Quiz — Stupéfiants | `/gpx/intervention/stupefiants/quiz` | DB-quiz-module | `gpx_intervention_stupefiants` |  |
- **Intervention : débit de boissons** — badge «Débit» — img `assets/images/ivresse.jpeg` — `/gpx/intervention/debit-boissons`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Intervention dans un débit de boissons | `/gpx/intervention/debit-boissons/intervention` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/debit_boissons/intervention_debit_boissons_page.dart` |
| COURS | Contrôle des débits de boissons | `/gpx/intervention/debit-boissons/controle` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/debit_boissons/controle_debits_boissons_page.dart` |
| QUIZ | Quiz — Débit de boissons | `/gpx/intervention/debit-boissons/quiz` | DB-quiz-module | `gpx_intervention_debit_boissons` |  |
- **Les malades mentaux** — badge «Psychiatrie» — img `assets/images/malades_mentaux.jpeg` — `/gpx/intervention/malades-mentaux`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Intervenir auprès de personnes ne jouissant pas de toutes leurs capacités mentales | `/gpx/intervention/malades-mentaux/intervenir` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart` |
| COURS | Admission en soins psychiatriques sans consentement | `/gpx/intervention/malades-mentaux/soins-sans-consentement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/malades_mentaux/soins_sans_consentement_page.dart` |
| QUIZ | Quiz — Malades mentaux | `/gpx/intervention/malades-mentaux/quiz` | DB-quiz-module | `gpx_intervention_malades_mentaux` |  |
- **Intervention : présence d’un animal** — badge «Animal» — img `assets/images/animal.jpeg` — `/gpx/intervention/animal`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Lutte contre la maltraitance animale | `/gpx/intervention/animal/maltraitance` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart` |
| COURS | “Intervenir face à un chien dangereux” (AMARIS) | `/gpx/intervention/animal/chien-dangereux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart` |
| COURS | Protocole sanitaire en cas de morsure | `/gpx/intervention/animal/protocole-morsure` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/animal/protocole_morsure_page.dart` |
| COURS | Chiens d’attaque, de garde ou de défense | `/gpx/intervention/animal/chiens-categories` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart` |
| QUIZ | Quiz — Animal | `/gpx/intervention/animal/quiz` | DB-quiz-module | `gpx_intervention_animal` |  |
- **Les autres interventions** — badge «Divers» — img `assets/images/autres_interventions.jpeg` — `/gpx/intervention/autres`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Intervention sur les lieux d’un sinistre | `/gpx/intervention/autres/sinistre` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/autres/sinistre_page.dart` |
| COURS | “Primo-intervenant sur un incendie” (AMARIS) | `/gpx/intervention/autres/incendie-primo` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/autres/incendie_primo_page.dart` |
| COURS | Intervention sur une alarme (établissement à caractère financier ou commercial) | `/gpx/intervention/autres/alarme-etablissement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/autres/alarme_etablissement_page.dart` |
| COURS | Principes de levée de doute lors d’agressions armées | `/gpx/intervention/autres/levee-doute-agression-armee` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/autres/levee_doute_agression_armee_page.dart` |
| COURS | Intervention suite à une agression armée à caractère crapuleux | `/gpx/intervention/autres/agression-armee-crapuleux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart` |
| COURS | Intervention suite à la violation d’un bracelet anti-rapprochement (interdiction de se rapprocher) | `/gpx/intervention/autres/violation-bar` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart` |
| COURS | Plan Vigipirate | `/gpx/intervention/autres/plan-vigipirate` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_avance/autres/plan_vigipirate_page.dart` |
| QUIZ | Quiz — Autres interventions | `/gpx/intervention/autres/quiz` | DB-quiz-module | `gpx_intervention_autres` |  |
#### policierEnIntervention
- **La prise de service** — badge «Service» — img `assets/images/cat_hierarchie.jpg` — `/gpx/intervention/prise-service`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La prise de service : l’appel | `/gpx/intervention/prise-service/appel` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_appel_page.dart` |
| COURS | Les principaux registres du poste | `/gpx/intervention/prise-service/registres` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_registres_page.dart` |
| COURS | Les applications “main courante” et “déclaration d’usagers” | `/gpx/intervention/prise-service/applications` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_applications_page.dart` |
| COURS | Mesures de sécurité, la fouille intégrale | `/gpx/intervention/prise-service/fouille-integrale` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_fouille_integrale_page.dart` |
| COURS | La gestion humaine et matérielle de la garde à vue | `/gpx/intervention/prise-service/garde-a-vue` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart` |
| COURS | Maîtriser le risque d’évasion et de fuite (AMARIS) | `/gpx/intervention/prise-service/risque-evasion-fuite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_risque_evasion_fuite_page.dart` |
- **La patrouille** — badge «Patrouille» — img `assets/images/memento_controle_routier.jpeg` — `/gpx/intervention/patrouille`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La patrouille | `/gpx/intervention/patrouille/patrouille` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart` |
| COURS | La communication radioélectrique | `/gpx/intervention/patrouille/communication-radio` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart` |
| COURS | Plaquette : respect de la procédure radio | `/gpx/intervention/patrouille/procedure-radio` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/procedure_radio_page.dart` |
| COURS | MEMO TPH 900 | `/gpx/intervention/patrouille/memo-tph-900` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/memo_tph_900_page.dart` |
| COURS | Les principaux fichiers | `/gpx/intervention/patrouille/principaux-fichiers` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart` |
| COURS | L’interrogation du F.P.R. | `/gpx/intervention/patrouille/interrogation-fpr` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/interrogation_fpr_page.dart` |
| COURS | La caméra piéton | `/gpx/intervention/patrouille/camera-pieton` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart` |
| COURS | L’utilité de la caméra piéton (AMARIS) | `/gpx/intervention/patrouille/utilite-camera` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/utilite_camera_pieton_page.dart` |
| COURS | Les équipements de sécurité | `/gpx/intervention/patrouille/equipements-securite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/equipements_securite_page.dart` |
| COURS | La conduite des véhicules de police | `/gpx/intervention/patrouille/conduite-vehicules` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/conduite_vehicules_police_page.dart` |
| COURS | L’usage des signaux sonores et lumineux | `/gpx/intervention/patrouille/signaux-sonores-lumineux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart` |
| COURS | Le signalement descriptif | `/gpx/intervention/patrouille/signalement-descriptif` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/signalement_descriptif_page.dart` |
| COURS | La palpation de sécurité | `/gpx/intervention/patrouille/palpation-securite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart` |
| COURS | Le menottage | `/gpx/intervention/patrouille/menottage` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/menottage_page.dart` |
| COURS | Enregistrement et diffusion éventuelle d'images et de paroles de fonctionnaires de police dans l'exercice de leurs fonctions. | `/gpx/intervention/patrouille/enregistrement-diffusion-images-paroles` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart` |
| COURS | Synthèse des indicateurs de basculement | `/gpx/intervention/patrouille/synthese-indicateurs-basculement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart` |
- **L’accident de la circulation** — badge «Accident» — img `assets/images/mise_en_danger.jpeg` — `/gpx/intervention/accident-circulation`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La sécurité pendant le trajet et sur les lieux du constat d’un accident de la circulation | `/gpx/intervention/accident-circulation/securite-trajet-lieux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/accident_circulation/securite_trajet_lieux_page.dart` |
| COURS | Les différents types d’accidents de la circulation routière | `/gpx/intervention/accident-circulation/types-accidents` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/accident_circulation/types_accidents_circulation_page.dart` |
| COURS | La régulation de la circulation | `/gpx/intervention/accident-circulation/regulation-circulation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/accident_circulation/regulation_circulation_page.dart` |
- **L’intervention au domicile** — badge «Domicile» — img `assets/images/mineurs_famille.jpeg` — `/gpx/intervention/domicile`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Le domicile et la violation de domicile | `/gpx/intervention/domicile/violation-domicile` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/domicile/violation_domicile_page.dart` |
| COURS | Les bruits et tapages | `/gpx/intervention/domicile/bruits-tapages` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/domicile/bruits_tapages_page.dart` |
| COURS | Le différend familial | `/gpx/intervention/domicile/differend-familial` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/domicile/differend_familial_page.dart` |
| COURS | Violences conjugales : conduite à tenir lors des interventions à domicile | `/gpx/intervention/domicile/violences-conjugales` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart` |
- **Les autres interventions** — badge «Divers» — img `assets/images/hierarchie_police.jpeg` — `/gpx/intervention/autres`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | “Primo-intervenant sur une scène d’infraction” (AMARIS) | `/gpx/intervention/autres/primo-scene-infraction-amaris` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/autres/primo_scene_infraction_amaris_page.dart` |
| COURS | Bagages abandonnés, oubliés ; objets, engins ou véhicules suspects | `/gpx/intervention/autres/alertes-a-la-bombe` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart` |
| COURS | Identification et détection des produits suspects | `/gpx/intervention/autres/identification-detection-produits-suspects` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart` |
| COURS | L’ivresse publique et manifeste (I.P.M.) | `/gpx/intervention/autres/ipm` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/autres/ivresse_publique_manifeste_page.dart` |
| COURS | Les plans ORSEC | `/gpx/intervention/autres/plans-orsec` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/autres/plans_orsec_page.dart` |
- **Formulaires utiles** — badge «Docs» — img `assets/images/copic_institutions.jpg` — `/gpx/intervention/formulaires-utiles`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Avis de rétention d’un permis de conduire | `/gpx/intervention/formulaires-utiles/avis-retention-permis` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/avis_retention_permis_page.dart` |
| COURS | Fiche d’immobilisation | `/gpx/intervention/formulaires-utiles/fiche-immobilisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_immobilisation_page.dart` |
| COURS | Fiche descriptive de l’état du véhicule à enlever en fourrière | `/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_descriptive_fourriere_page.dart` |
#### recueilPvApj20
- **Recueil PV — Introduction** — badge «Bases» — img `assets/images/pv_intro.jpg` — `/gpx/pv_apj20/introduction`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/introduction/preambule` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/introduction/preambule_page.dart` |
| COURS |  | `/gpx/pv_apj20/introduction/procedure` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/introduction/procedure_page.dart` |
| COURS |  | `/gpx/pv_apj20/introduction/proces_verbaux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart` |
| COURS | L’état-civil | `/gpx/pv_apj20/introduction/etat_civil` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/introduction/etat_civil_page.dart` |
- **Recueil PV — La plainte** — badge «Plainte» — img `assets/images/pv_plainte.jpeg` — `/gpx/pv_apj20/plainte`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/plainte/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/plainte/plainte_generalites_page.dart` |
| COURS | Canevas de procès-verbal de plainte contre auteur inconnu | `/gpx/pv_apj20/plainte/pv_saisine_personne_inconnue` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart` |
| COURS | Canevas de procès-verbal de plainte contre personne dénommée | `/gpx/pv_apj20/plainte/pv_saisine_personne_denommee` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_denommee_page.dart` |
| COURS | Canevas de procès-verbal de plainte contre personne dénommée — Suite | `/gpx/pv_apj20/plainte/pv_saisine_personne_denommee_suite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_denommee_suite_page.dart` |
| COURS | Violences conjugales — Grille d’évaluation du danger | `/gpx/pv_apj20/plainte/violences_conjugales/presentation_grille_danger` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart` |
| COURS | Violences conjugales — Document d’information synthétique (démarches & dispositifs) | `/gpx/pv_apj20/plainte/violences_conjugales/document_info_synthetique` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/plainte/document_info_synthetique_page.dart` |
| COURS | Canevas & PV de plainte d’une victime de violences conjugales | `/gpx/pv_apj20/plainte/violences_conjugales/pv_victime` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart` |
- **Recueil PV — Constatations** — badge «Constats» — img `assets/images/perquisition.jpeg` — `/gpx/pv_apj20/constatations`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/constatations/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/constatations/constatations_generalites_page.dart` |
| COURS |  | `/gpx/pv_apj20/constatations/canevas_pv` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/constatations/canevas_pv_page.dart` |
- **Recueil PV — Témoignage** — badge «Audition» — img `assets/images/renseignements.jpeg` — `/gpx/pv_apj20/temoignage`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/temoignage/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/temoignage/temoignage_generalites_page.dart` |
| COURS | Canevas & PV d’enquête de voisinage | `/gpx/pv_apj20/temoignage/enquete_voisinage` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/temoignage/enquete_voisinage_page.dart` |
| COURS | Canevas & PV d’audition de témoin | `/gpx/pv_apj20/temoignage/audition_temoins` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/temoignage/audition_temoins_page.dart` |
- **Recueil PV — Contrôle d’identité** — badge «Identité» — img `assets/images/pv_controle_identite.jpeg` — `/gpx/pv_apj20/controle_identite`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/controle_identite/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart` |
| COURS | Canevas & PV de contrôle d’identité | `/gpx/pv_apj20/controle_identite/pv_controle_identite` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart` |
| COURS | Canevas & PV de contrôle d’identité + fiche de recherche | `/gpx/pv_apj20/controle_identite/pv_ci_fiche_recherche` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/controle_identite/pv_ci_fiche_recherche_page.dart` |
- **Recueil PV — Interpellation & conduite au poste** — badge «Interpellation» — img `assets/images/pv_interpellation.jpeg` — `/gpx/pv_apj20/interpellation`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/interpellation/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/interpellation_generalites_page.dart` |
| COURS | Canevas & PV de contrôle d’identité + découverte d’une arme | `/gpx/pv_apj20/interpellation/ci_decouverte_arme` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/pv_ci_decouverte_arme_page.dart` |
| COURS | Canevas & PV d’interpellation | `/gpx/pv_apj20/interpellation/pv_interpellation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/pv_interpellation_page.dart` |
| COURS | Canevas & PV de conduite au poste | `/gpx/pv_apj20/interpellation/conduite_au_poste` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/conduite_au_poste_page.dart` |
| COURS | Les mandats (recherche, comparution, amener, arrêt) | `/gpx/pv_apj20/interpellation/mandats` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/mandats_page.dart` |
| COURS | Canevas & PV de notification de mandat | `/gpx/pv_apj20/interpellation/notification_mandat` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/notification_mandat_page.dart` |
| COURS | Canevas & PV de recherches infructueuses (exécution mandat) | `/gpx/pv_apj20/interpellation/recherches_infructueuses_mandat` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart` |
| COURS | Canevas de compte-rendu à l’O.P.J. | `/gpx/pv_apj20/interpellation/compte_rendu_opj` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/interpellation/compte_rendu_opj_page.dart` |
- **Recueil PV — GAV & suspect libre** — badge «Droits» — img `assets/images/pv_gav_suspect_libre.jpeg` — `/gpx/pv_apj20/gav_suspect_libre`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | La garde à vue : généralités | `/gpx/pv_apj20/gav_suspect_libre/gav_generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/gav_generalites_page.dart` |
| COURS | Canevas & PV : notification placement GAV + droits (A.P.J.) | `/gpx/pv_apj20/gav_suspect_libre/notification_gav_droits_apj` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart` |
| COURS | Le suspect libre : généralités | `/gpx/pv_apj20/gav_suspect_libre/suspect_libre_generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart` |
| COURS | Canevas & PV : notification des droits au suspect majeur | `/gpx/pv_apj20/gav_suspect_libre/notification_droits_suspect_majeur_emprisonnement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_droits_suspect_majeur_emprisonnement_page.dart` |
| COURS | Canevas & PV : notification en audition libre (contravention/délit non puni emprisonnement) | `/gpx/pv_apj20/gav_suspect_libre/notification_audition_libre_sans_emprisonnement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_audition_libre_sans_emprisonnement_page.dart` |
| COURS | Canevas & PV : notification des droits — Art. 65 du C.P.P. | `/gpx/pv_apj20/gav_suspect_libre/notification_droits_art_65_cpp` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_droits_article_65_cpp_page.dart` |
| COURS | Intervention de l’avocat : généralités | `/gpx/pv_apj20/gav_suspect_libre/avocat_generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart` |
| COURS | Canevas & PV : entretien du gardé à vue avec l’avocat | `/gpx/pv_apj20/gav_suspect_libre/entretien_gav_avocat` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/entretien_gav_avocat_page.dart` |
- **Recueil PV — Audition du suspect** — badge «Audition» — img `assets/images/pv_audition_suspect.jpeg` — `/gpx/pv_apj20/audition_suspect`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/audition_suspect/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/audition_suspect/audition_suspect_generalites_page.dart` |
| COURS | Canevas & PV : audition du gardé à vue | `/gpx/pv_apj20/audition_suspect/audition_gav` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/audition_suspect/audition_gav_page.dart` |
| COURS | Canevas & PV : audition du suspect libre | `/gpx/pv_apj20/audition_suspect/audition_suspect_libre` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/audition_suspect/audition_suspect_libre_page.dart` |
| COURS | Canevas & PV : audition du suspect libre + notification des droits (contravention/délit non puni emprisonnement) | `/gpx/pv_apj20/audition_suspect/audition_libre_notification_droits_sans_emprisonnement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/audition_suspect/audition_libre_notification_droits_sans_emprisonnement_page.dart` |
| COURS | Le civilement responsable : généralités | `/gpx/pv_apj20/audition_suspect/civilement_responsable_generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/audition_suspect/civilement_responsable_generalites_page.dart` |
| COURS | Canevas & PV : audition du civilement responsable | `/gpx/pv_apj20/audition_suspect/audition_civilement_responsable` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/audition_suspect/civilement_responsable_generalites__canevas_page.dart` |
- **Recueil PV — Perquisition (enquête préliminaire)** — badge «Enquête» — img `assets/images/pv_perquisition.jpeg` — `/gpx/pv_apj20/perquisition_preliminaire`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/perquisition_preliminaire/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/perquisition_preliminaire/perquisition_preliminaire_generalites_page.dart` |
| COURS | Canevas & PV : perquisition en enquête préliminaire | `/gpx/pv_apj20/perquisition_preliminaire/perquisition` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/perquisition_preliminaire/perquisition_preliminaire_perquisition_page.dart` |
| COURS | Canevas & PV : fouille de véhicule en enquête préliminaire | `/gpx/pv_apj20/perquisition_preliminaire/fouille_vehicule` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/perquisition_preliminaire/fouille_vehicule_preliminaire_page.dart` |
- **Recueil PV — Réquisitions** — badge «Réquisitions» — img `assets/images/pv_requisitions.jpeg` — `/gpx/pv_apj20/requisitions`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/requisitions/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart` |
| COURS | Canevas & PV : réquisition à personne | `/gpx/pv_apj20/requisitions/requisition_personne` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart` |
| COURS | Canevas & rapport : réquisition à personne | `/gpx/pv_apj20/requisitions/rapport_requisition_personne` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/requisitions/rapport_requisition_personne_page.dart` |
- **Recueil PV — Confrontation** — badge «Procédure» — img `assets/images/pv_confrontation.jpeg` — `/gpx/pv_apj20/confrontation`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/confrontation/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_generalites_page.dart` |
| COURS | Canevas & PV : confrontation victime / gardé à vue | `/gpx/pv_apj20/confrontation/victime_gav` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_gav_page.dart` |
| COURS | Canevas & PV : confrontation victime / suspect libre (crime/délit puni emprisonnement) | `/gpx/pv_apj20/confrontation/victime_suspect_libre_emprisonnement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart` |
- **Recueil PV — Procédures spéciales (étrangers)** — badge «Spécial» — img `assets/images/pv_etrangers.jpeg` — `/gpx/pv_apj20/procedures_speciales/etrangers`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/procedures_speciales/etrangers/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart` |
| COURS | Canevas & PV : contrôle d’identité + contrôle du séjour et de la circulation des étrangers | `/gpx/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart` |
| COURS | Canevas & PV : contrôle du séjour et de la circulation des étrangers | `/gpx/pv_apj20/procedures_speciales/etrangers/controle_sejour_circulation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/controle_sejour_circulation_page.dart` |
- **Recueil PV — Circulation routière** — badge «Circulation» — img `assets/images/pv_circulation_routiere.jpeg` — `/gpx/pv_apj20/circulation_routiere`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | Alcool — Généralités | `/gpx/pv_apj20/circulation_routiere/alcool/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart` |
| COURS | Alcool — Canevas & PV conduite au poste (dépistage CEEA positif / refus / sans dépistage) | `/gpx/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart` |
| COURS | Alcool — Canevas & PV d’interpellation suite conduite en état d’ivresse | `/gpx/pv_apj20/circulation_routiere/alcool/interpellation_etat_ivresse` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/interpellation_etat_ivresse_page.dart` |
| COURS | Alcool — Tableau des taux d’alcool (affichés & retenus) | `/gpx/pv_apj20/circulation_routiere/alcool/tableau_taux` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/tableau_taux_page.dart` |
| COURS | Alcool — Canevas & PV vérification + notification des taux (CEEA) | `/gpx/pv_apj20/circulation_routiere/alcool/verification_notification_taux_ceea` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/verification_notification_taux_ceea_page.dart` |
| COURS | Alcool — Canevas & PV vérification des taux (CEI) | `/gpx/pv_apj20/circulation_routiere/alcool/verification_taux_cei` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/verification_taux_cei_page.dart` |
| COURS | Alcool — Canevas & PV prélèvement sanguin (vérification état alcoolique) | `/gpx/pv_apj20/circulation_routiere/alcool/prelevement_sanguin` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart` |
| COURS | Alcool — Canevas & rapport réquisition (examen clinique médical + prélèvement sanguin) | `/gpx/pv_apj20/circulation_routiere/alcool/requisition_examen_clinique_prelevement` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/requisition_examen_clinique_prelevement_page.dart` |
| COURS | Alcool — Fiches A, B, C | `/gpx/pv_apj20/circulation_routiere/alcool/fiches_abc` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/fiches_abc_page.dart` |
| COURS | Stupéfiants — Généralités | `/gpx/pv_apj20/circulation_routiere/stupefiants/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/stupefiants_generalites_page.dart` |
| COURS | Stupéfiants — Canevas & PV conduite au poste (dépistage positif / refus) | `/gpx/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus_page.dart` |
| COURS | Stupéfiants — Formulaire d’information | `/gpx/pv_apj20/circulation_routiere/stupefiants/formulaire_information` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/formulaire_information_page.dart` |
| COURS | Stupéfiants — Canevas & PV vérifications destinées à établir l’usage | `/gpx/pv_apj20/circulation_routiere/stupefiants/verifications_etablir_usage` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/verifications_etablir_usage_stupefiants_page.dart` |
| COURS | Stupéfiants — Fiche suivi prélèvements (analyse salivaire) | `/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_salivaire` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_salivaire_page.dart` |
| COURS | Stupéfiants — Canevas & PV suite à prélèvement sanguin | `/gpx/pv_apj20/circulation_routiere/stupefiants/suite_prelevement_sanguin` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/suite_prelevement_sanguin_page.dart` |
| COURS | Stupéfiants — Canevas & PV prélèvement sanguin (établir usage stupéfiants) | `/gpx/pv_apj20/circulation_routiere/stupefiants/prelevement_sanguin_etablir_usage` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/prelevement_sanguin_etablir_usage_page.dart` |
| COURS | Stupéfiants — Fiche suivi prélèvements (analyse sanguine) | `/gpx/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_sanguine` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_sanguine_page.dart` |
| COURS | Stupéfiants — Canevas & rapport réquisition (examen clinique + prélèvement sanguin) + expertise | `/gpx/pv_apj20/circulation_routiere/stupefiants/requisition_examen_clinique_prelevement_expertise` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/requisition_examen_clinique_prelevement_expertise_page.dart` |
| COURS | Alcool + Stups — Conduite au poste (dépistages positifs / refus) | `/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/conduite_poste_depistages_positifs_ou_refus` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistages_positifs_ou_refus_page.dart` |
| COURS | Alcool + Stups — Conduite au poste (refus de se soumettre aux vérifications) | `/gpx/pv_apj20/circulation_routiere/alcool_stupefiants/refus_verifications` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart` |
| COURS | Contravention 5e classe — Grand excès de vitesse (+50 km/h) | `/gpx/pv_apj20/circulation_routiere/contravention_5e/grand_exces_vitesse` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/contravention_5e/grand_exces_vitesse_page.dart` |
| COURS | Contravention 5e classe — Tableau des vitesses retenues | `/gpx/pv_apj20/circulation_routiere/contravention_5e/tableau_vitesses` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/circulation_routiere/contravention_5e/tableau_vitesses_page.dart` |
| COURS | Formulaires utiles — Avis de rétention du permis | `/gpx/intervention/formulaires-utiles/avis-retention-permis` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/avis_retention_permis_page.dart` |
| COURS | Formulaires utiles — Fiche d’immobilisation | `/gpx/intervention/formulaires-utiles/fiche-immobilisation` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_immobilisation_page.dart` |
| COURS | Formulaires utiles — Fiche descriptive état véhicule (fourrière) | `/gpx/intervention/formulaires-utiles/fiche-descriptive-fourriere` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_descriptive_fourriere_page.dart` |
- **Recueil PV — I.V.P.M** — badge «IPM» — img `assets/images/ipm.jpeg` — `/gpx/pv_apj20/ipm`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS |  | `/gpx/pv_apj20/ipm/generalites` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/ipm/ipm_generalites_page.dart` |
| COURS | Canevas & PV contravention d’ivresse publique et manifeste (examen médical) | `/gpx/pv_apj20/ipm/pv_ipm_examen_medical` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/ipm/pv_ipm_examen_medical_page.dart` |
| COURS | Canevas & PV contravention d’ivresse publique et manifeste (remise à un tiers) | `/gpx/pv_apj20/ipm/pv_ipm_remise_tiers` | Dart-page + ScolariteText fragments ; cours_scolarite row |  | `lib/content/gpx_scolarite/pv_apj20/ipm/pv_ipm_remise_tiers_page.dart` |
#### dimensionHumaine
- **Communication & posture** — badge «Relationnel» — img `assets/images/dh_communication.jpeg` — `/gpx/dimension_humaine/communication`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | DH1 — Le fonctionnement intellectuel et émotionnel dans l’intervention | `/gpx/dimension_humaine/communication/dh1_fonctionnement` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/communication/dh1_fonctionnement` |  |
| COURS | DH3 — Les stratégies de communication adaptées avec le public | `/gpx/dimension_humaine/communication/dh3_strategies_public` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/communication/dh3_strategies_public` |  |
| COURS | DH4 — La coordination au sein des équipes de police | `/gpx/dimension_humaine/communication/dh4_coordination_equipes` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/communication/dh4_coordination_equipes` |  |
| COURS | ADH2 — La posture professionnelle adaptée face à une victime | `/gpx/dimension_humaine/communication/adh2_posture_victime` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/communication/adh2_posture_victime` |  |
| COURS | S3-2 — L’intervention auprès de victimes de violences intrafamiliales | `/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/communication/s3_2_violences_intrafamiliales` |  |
| QUIZ | Quiz — Communication & posture | `/gpx/dimension_humaine/communication/quiz` | DB-quiz-module | `gpx_dh_communication` |  |
- **Stress & gestion émotionnelle** — badge «Bien-être» — img `assets/images/dh_stress.jpeg` — `/gpx/dimension_humaine/stress`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | DH2 — Le stress | `/gpx/dimension_humaine/stress/dh2_stress` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/stress/dh2_stress` |  |
| COURS | DH2 — Le carnet des ressources | `/gpx/dimension_humaine/stress/dh2_carnet_ressources` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/stress/dh2_carnet_ressources` |  |
| COURS | ADH9 — Faire face à une situation d’agressivité | `/gpx/dimension_humaine/stress/adh9_agressivite` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/stress/adh9_agressivite` |  |
| COURS | AC6 — Les conduites suicidaires | `/gpx/dimension_humaine/stress/ac6_conduites_suicidaires` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/stress/ac6_conduites_suicidaires` |  |
| QUIZ | Quiz — Stress & gestion émotionnelle | `/gpx/dimension_humaine/stress/quiz` | DB-quiz-module | `gpx_dh_stress` |  |
- **Éthique au quotidien** — badge «Valeurs» — img `assets/images/dignite_discriminations.jpeg` — `/gpx/dimension_humaine/ethique`
| Type | Libellé affiché | Route menu | Source de données | Clé DB (module quiz) | Fichier Dart |
|---|---|---|---|---|---|
| COURS | ADH1 — L’intervention auprès de personnes ne jouissant pas de toutes ses facultés mentales | `/gpx/dimension_humaine/ethique/adh1_facultes_mentales` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/ethique/adh1_facultes_mentales` |  |
| COURS | ADH4 — Les violences sexuelles et sexistes | `/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/ethique/adh4_violences_sexuelles_sexistes` |  |
| COURS | ADH6 — La confrontation à la mort en situation professionnelle | `/gpx/dimension_humaine/ethique/adh6_confrontation_mort` | DB-cours_scolarite(body_md) | `/gpx/dimension_humaine/ethique/adh6_confrontation_mort` |  |
| QUIZ | Quiz — Éthique au quotidien | `/gpx/dimension_humaine/ethique/quiz` | DB-quiz-module | `gpx_dh_ethique` |  |

## 8. Points d’attention pour le portage

1. Porter les deux const maps (`paSchoolCategoriesConfig` `home_page_pa_school.dart:3654`, `gpxSchoolCategoriesConfig` `home_page_gpx_school.dart:3690`) + `redirectConfigPaSchool` (`home_page_pa_school.dart:4828`) en données TS/JSON (ou nouvelle table).
2. Routes menu ≠ routes stockées : certaines feuilles PA pointent vers des routes partagées/legacy (`/pa/dps_dpg/socle_initial/autorite_etat/outrage` pour « Atteintes à l’administration… »). Résolution via `RouteRegistry` (`app_router.dart:229`) puis `PaSchoolRouteRegistry` (généré, `pa_school_routes.dart`).
3. Quiz « Infractions à la circulation routière » PA : route `/pa/dps_dpg/quiz/quiz_circulation_routiere` déclarée dans `app_router.dart:532` (alias), pas dans le registre généré.
4. Titres `quiz_scolarite_modules.title` des modules importés = noms de fichiers → utiliser les libellés menu.
5. `quiz_scolarite_session` ne filtre pas `publication_status` (l’autre RPC si) → à harmoniser avant d’exposer le web.
6. `cours_scolarite.body_md` des pages importées = texte aplati (bruit « Retour », commentaires Dart dans certaines des 90 introductions) → rendu fidèle = gabarits + `scolarite_content_fragments`.
7. 30 quiz Dart restent la source effective dans l’app : toute correction de question faite dans l’admin n’apparaît dans l’app que pour les 19 dynamiques + Flagrant délit ; le web, s’il lit la DB, sera « en avance » sur l’app.
