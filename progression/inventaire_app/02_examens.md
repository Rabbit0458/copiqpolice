# 02 — Parcours EXAMEN : Policier adjoint (PA) et Gardien de la paix (GPX)

Périmètre : app Flutter `/home/claude/app/lib` (lecture seule). But : porter ces parcours vers le site Next.js qui partage la même base Supabase.
Aucune définition SQL n'est présente dans le dépôt : les schémas et contrats ci-dessous viennent des appels faits par le client. Les chemins sont relatifs à `lib/`.

Légende : **[DB]** contenu servi par Supabase · **[DART]** contenu codé en dur dans le fichier Dart · **[MORT]** code présent mais jamais appelé ou page orpheline.

---

## 0. Vue d'ensemble

| Parcours | Accueil | Épreuves ou modules exposés |
|---|---|---|
| PA (`track='pa'`, `mode='exam'`) | `features/home/home_page_pa_exam.dart` (route `/home-pa-exam`), config `categoriesConfigPA` l.1600+ | 1. Les épreuves du concours PA · 2. Épreuve de photolangage · 3. Tests psychotechniques · 4. Connaissances générales. Les blocs « 5. Français » et « 6. Étude de texte » sont commentés et absents de l'interface. |
| GPX (`track='gpx'`, `mode='exam'`) | `features/home/home_page_gpx_exam.dart` (route `/home-gpx-exam`), config l.2510+ | 1. Structure du concours GPX · 2. Cas pratique · 3. Culture générale · 4. Langue étrangère · 5. Tests psychotechniques (+ Mode concours) |
| Transverses | — | Test de positionnement (`features/placement/**`), suivi de progression PA/GPX, Concours blanc **[MORT/squelette]**, Annales **[MORT/placeholder]** |

Toutes les écritures utilisent la session Supabase de l'utilisateur, avec RLS côté serveur.

---

## 1. PARCOURS PA — Concours Policier adjoint

### 1.1 « Les épreuves du concours PA » (badge « Bien démarrer »)
- Sous-pages « Tableau des épreuves » (`/pa_exam/concours/epreuves/tableau`) et « Visite médicale & enquête administrative » (`/pa_exam/concours/epreuves/visite_medicale_enquete`).
- **[DB]** Page générique `content/gpx_scolarite/shared/cours_scolarite_page.dart` : `.from('cours_scolarite').select().eq('route', key).eq('is_published', true)`. Lecture seule.

### 1.2 « Épreuve de photolangage » (badge « Expression écrite »)
Fichiers : `content/pa_exam/photolangage/*`. Routes (`PaPhotolangageRoutes`, `pa_photolangage_core.dart`) :
- `/pa_exam/concours/photolangage` : hub. Il propose « Reprendre mon exercice » à partir du dernier brouillon et un lien « Mon historique ».
- `/pa_exam/concours/photolangage/analyse` : « Analyse de l'épreuve » **[DART]** (texte statique).
- `/pa_exam/concours/photolangage/etapes_reussite` : « Les étapes de la réussite », méthode en 7 étapes **[DART]**.
- `/pa_exam/concours/photolangage/entrainements` : « Entraînements — sujets & corrigés ». Filtres : Tous / À commencer / En cours / Terminés.
- `/pa_exam/concours/photolangage/historique` : historique des copies.
- Pages poussées sans nom de route (`MaterialPageRoute`) : intro du cas → image (`PaPhotolangageImagePage`) → éditeur (`pa_photolangage_editor_page.dart`) → résultat (`pa_photolangage_result_page.dart`).

**Contenu [DB]** : `photolangage_cases`
```dart
_sb.from('photolangage_cases').select().eq('is_published', true).order('case_order', ascending: true);
```
Colonnes lues : `id, case_order, title, short_description, image_url, image_alt, difficulty ('decouverte'|'intermediaire'|'avancee' → Découverte/Intermédiaire/Avancée), duration_seconds (défaut 1200), minimum_characters (900), minimum_words (140), recommended_characters (1300), is_premium, pedagogical_tips (text[]), version`.

**Format** : rédaction libre décrivant une photo. Le chrono par cas (`duration_seconds`, 20 min par défaut) démarre à l'ouverture de l'éditeur. Alertes à 5 min et à 1 min. On peut revoir l'image pendant l'épreuve, le temps continue. Une détection anti-triche non punitive (`antiGamingIssue`) vérifie le ratio de mots uniques (< 0,28), un mot dépassant 12 % du texte et les caractères non linguistiques (> 15 %). Le bouton de validation n'apparaît qu'une fois `minimumWords` et `minimumCharacters` atteints. À l'expiration, l'envoi est automatique si le minimum est atteint. Sinon une boîte de dialogue propose « Analyser quand même » (statut `expired_incomplete`).

**Contrat d'écriture**
- Brouillon : sauvegarde locale à chaque frappe (debounce 900 ms, `SharedPreferences` clé `pa_photolangage_draft_<caseId>`). Sauvegarde distante au plus toutes les 8 s, ou forcée :
```dart
_sb.from('photolangage_drafts').upsert({'user_id': uid,'case_id': draft.caseId,'text': draft.text,
  'started_at': ..., 'deadline': ..., 'last_saved_at': ..., 'case_version': draft.caseVersion});
// suppression après envoi : .delete().eq('user_id', uid).eq('case_id', caseId)
```
- Envoi (`insertAttempt`). Pas de `user_id`, `track` ni `mode` dans la charge utile : ces valeurs sont donc des défauts ou des triggers côté base. Pourtant le suivi filtre sur `track='pa'` et `mode='exam'` (voir §5) :
```dart
_sb.from('photolangage_attempts').insert({'case_id': c.id,'case_version': c.version,'raw_text': rawText,
  'started_at': ..., 'submitted_at': nowUtc, 'elapsed_seconds': c.durationSeconds - remainingSeconds,
  'remaining_seconds_at_submit': remainingSeconds, 'character_count': ..., 'word_count': ...,
  'status': expiredIncomplete ? 'expired_incomplete' : 'submitted'}).select('id').single();
```
- Correction par l'Edge Function, qui persiste elle-même `correction_status`, `pedagogical_score` et `correction_payload` sur la tentative :
```dart
_sb.functions.invoke('photolangage-correct', body: {'attemptId': attemptId, 'language': 'fr-FR'}); // → data.payload
```
- Lecture de l'historique : `photolangage_attempts.select('id, case_id, status, correction_status, pedagogical_score, word_count, character_count, submitted_at, correction_payload, raw_text').eq('user_id', uid)`.

**Écran de résultat** (`pa_photolangage_result_page.dart`). Un loader affiche les étapes « Vérification du texte / Analyse du français / Analyse de la structure / Comparaison avec l'image / Préparation des conseils ». En cas d'échec, l'écran indique « Correction momentanément indisponible » et propose « Relancer l'analyse » ou « Revenir plus tard ». Champs du `payload` affichés :
- `overallPedagogicalScore` (sur 100), `pedagogicalLevel`, `confidence`, `correctionMode` (`linguistic_only` → bandeau « résultat partiel ») ;
- `juryAppreciation` (« Simulation du jury »), `strengths` (« Points forts »), `priorities` (« Priorités de progression ») ;
- `metrics{language, factualAccuracy, structure, observationCoverage, vocabulary, readability}` (« Score par compétence », 0 à 100) ;
- `issues[{category, original, explanation, suggestions, start, end}]` et `aiIssues`. La copie est annotée par surlignage start/end, avec un filtre par catégorie. Catégories : spelling, grammar, conjugation, syntax, punctuation, typography, capitalization, homophone, repetition, style, vocabulary, structure, incoherence, unsupportedInference, uncertaintyExpression ;
- `semanticAnalysis{unsupportedClaims[], importantMissingElements[], organizationFeedback}`, `counts`, `improvedVersion` (« Proposition améliorée »), `referenceDescription` (« Corrigé type »).
- Mention à reprendre : « Score pédagogique COP'IQ — indicateur d'entraînement non officiel ».

**Images** : `image_url` contient une URL complète stockée en base, affichée avec `Image.network(c.imageUrl)`. Aucun appel `storage.from(...)` côté client, donc le bucket n'est pas visible dans le code : il faut lire la valeur de `photolangage_cases.image_url` en base.

**Premium** : `is_premium` est lu mais **jamais appliqué** dans le module. Seul le quota global s'applique (§4).

### 1.3 « Tests psychotechniques » (badge « Logique & profil »)
Hub `content/pa_exam/psycotechniques/pa_tests_psy_hub_pages.dart`, route `/pa_exam/concours/tests_psychotechniques`. Le module est indépendant du module GPX.
- Pages de cours **[DART]** : « Analyse de l'épreuve » (`/pa_exam/concours/tests_psy/analyse`) et « Personnalité & comportements » (`/pa_exam/concours/tests_psy/personnalite`, `pa_tests_psy_personnalite_page.dart`).
- Hubs d'agrégation : Raisonnement logique, Observation & attention, « QCM chronométrés » (`/entrainements_qcm`), « Exercices par compétence » (`/entrainements_exercices`).
- « Mes corrigés & historique » (`/pa_exam/concours/tests_psy/entrainements_corriges`, `pa_tests_psy_corriges_page.dart`). Cette page lit `quiz_history` (`track='pa'`, `quiz_name` dans la liste PA psycho, limite 60) et `tests_psychotechnique_history` (`module='pa_psychotechnique'`, limite 60). Libellés : ≥ 90 « Très bonne maîtrise », ≥ 75 « Bonne maîtrise », ≥ 60 « Satisfaisant », ≥ 40 « En progression », sinon « Bases à renforcer ».

Les 6 exercices (catalogue `PaTestsPsyRoutes`) :

| Libellé | Route | Fichier | Source | Volume ou difficulté |
|---|---|---|---|---|
| Attention visuelle | `/pa_exam/concours/tests_psychotechniques/attention_visuelle` | `pa_attention_visuelle_page.dart` | **[DB]** `tests_psyco_attention_visuelle` `.eq('is_active', true)` (toute la table), filtre client par difficulté normalisée (easy/medium/hard ↔ Facile/Moyenne/Difficile), mélange local | Vrai/Faux (`text_a`, `text_b`, `is_true`), **5 s par question** |
| Suites logiques | `/pa_exam/concours/tests_psychotechniques/suites_logiques` | `pa_quiz_tests_psycotechniques_suite_logiques.dart` | **[DB]** `tests_psyco_suite_logique` `.eq('is_active', true)` (toute la table), filtre client | QCM (`sequence_text`, `prompt`, `options`, `answer`, `explanation`, `hint`), **30 s par question** |
| Calcul mental | `/pa_exam/concours/tests_psychotechniques/calcul_rapide` | `pa_quiz_tests_psycotechniques_calcul.dart` | **[DART]** `paQuestionPsycotechniquesCalcul`, 2 610 questions (Facile 299 / Moyenne 830 / Difficile 1 481), catégorie « Tests psychotechniques — Calcul rapide » | QCM, pas de chrono |
| Concentration | `/pa_exam/concours/tests_psychotechniques/attention_concentration` | `pa_quiz_tests_psycotechniques_concentration.dart` | **[DART]** 4 050 questions (1 572 / 1 360 / 1 118), catégorie « … — Attention & concentration » | QCM, pas de chrono |
| Logique verbale (aussi servie par `/pa_exam/concours/tests_psy/aptitude_verbale`) | `/pa_exam/concours/tests_psychotechniques/logique_verbale` | `pa_quiz_tests_psycotechniques_suite_verbal.dart` | **[DART]** 2 717 questions (510 / 985 / 1 222) | QCM, pas de chrono |
| Raisonnement logique | `/pa_exam/concours/tests_psychotechniques/raisonnement_logique` | `pa_quiz_tests_psycotechniques_raisonnement.dart` | **[DART]** 4 100 questions (1 332 / 1 541 / 1 227) | QCM, pas de chrono |

**Écran de niveau** : « Sélectionne le niveau de difficulté » avec Facile / Moyen(ne) / Difficile, plus « Mélanger les 3 niveaux » (ou « Aléatoire » pour Attention et Suites). Ensuite vient le **sélecteur de session** commun (§3.1).

**Écritures — QCM codés en dur (calcul, concentration, verbal, raisonnement)** : même schéma que la culture générale (§3.2), avec les valeurs suivantes.

| Fichier | `module_name` | `quiz_name` | `quizKey` (RPC) |
|---|---|---|---|
| calcul | `PA - Tests psychotechniques - Calcul` | `PA - Quiz tests psychotechniques calcul` | `pa_quiz_tests_psycotechniques_calcul` |
| concentration | `PA - Tests psychotechniques - Concentration` | `PA - Quiz tests psychotechniques concentration` | `pa_quiz_tests_psycotechniques_concentration` |
| verbal | `PA - Tests psychotechniques - Verbal` | `PA - Quiz tests psychotechniques verbal` | `pa_quiz_tests_psycotechniques_suite_verbal` |
| raisonnement | `PA - Tests psychotechniques - Raisonnement` | `PA - Quiz tests psychotechniques raisonnement` | `pa_quiz_tests_psycotechniques_raisonnement` |

Insertion au démarrage, dans `_createHistoryOnStart` :
```dart
_sb.from('quiz_history').insert({'grade':'pa','track':'pa','mode':'exam','uid': widget.uid,'email': widget.email,
  'module_name': 'PA - Tests psychotechniques - Calcul','quiz_name': 'PA - Quiz tests psychotechniques calcul',
  'score': 0,'total_questions': _qs.length,'correct_count': 0,'started_at': nowUtc}).select('id').single();
```
Mise à jour à la fin : `{'score': percent, 'correct_count': _score, 'total_questions': answered, 'finished_at': nowUtc, 'completed_at': DateTime.now().toIso8601String() /* heure locale, sans Z */}` avec `.eq('id', _historyRowId).eq('uid', uid)`.
Par réponse : `record_learning_answer` avec `track:'pa'`, `mode:'exam'`, `moduleKey: q.category` et `questionId: '${q.category}:${index+1}'`.
**[MORT]** `_saveAnswer` → `quiz_psycotechniques_{calcul|concentration|raisonnement|verbal}_pages` existe mais n'est jamais appelé.

**Écritures — Attention visuelle et Suites logiques [DB]** : une seule insertion en fin de série, sans `quiz_history` ni RPC par réponse :
```dart
supabase.from('tests_psychotechnique_history').insert({'user_id': uid,'exercise_type': 'suite_logique' /* ou 'attention_visuelle' */,
  'module': 'pa_psychotechnique','score': correctAnswers /* nombre brut, pas un % ! */,'correct_answers': correctAnswers,
  'wrong_answers': totalAnswers - correctAnswers,'total_questions': totalAnswers,'duration_seconds': sum(responseTimes),
  'avg_response_time': avg,'mode': 'concours' /* + 'created_at' pour suites */});
```
La série s'arrête quand `totalAnswers >= selectedSessionLength`, ou automatiquement après **10 délais dépassés consécutifs** (`afkStopLimit`).
Signalement : `tests_psycotechnique_report` (`module:'pa_psychotechnique'`, `category:'suites_logiques'` ou attention, `status:'pending'`, `report_type:'question'`, `page: routeName`).

**Résultat** : boîte de dialogue. Si précision ≥ 80 : « Excellent rythme ». Si ≥ 50 : « Tu progresses ». Sinon « Relance une série ». Variantes « Série arrêtée » et « Série arrêtée automatiquement » (« 10 questions sans réponse d'affilée… »). Pour les QCM codés en dur, voir la carte de résultat du §3.3.

### 1.4 « Connaissances générales » (badge « Institution & culture »)
Hub `content/pa_exam/culture_generale/pa_cg_hub_pages.dart` (`PaCgRoutes`) : `/pa_exam/concours/connaissances_generales` avec les pages « Fiches de cours » (`/fiches_de_cours`, « Réviser par thème » **[DART]**), « QCM par thème » (`/entrainements_qcm`), « S'exercer par thème » (`/entrainements_exercices`), « Mes corrigés & historique » (`/entrainements_corriges` → `pa_cg_corriges_page.dart`, qui lit `quiz_history` `.eq('track','pa').inFilter('quiz_name', …).limit(80)`).

14 thèmes (titre PA → route → classe, `_categoryNameDb`) :

| Titre PA | Route `/pa_exam/concours/…` | `category` (quiz_questions) | `quiz_name` |
|---|---|---|---|
| Histoire de France | `culture_generale_histoire_france` | `Histoire` | `PA - Quiz culture générale histoire` |
| Institutions européennes | `culture_generale_institutions_europeennes` | `Institutions` | `PA - Quiz culture générale institutions européennes` |
| Actualité | `culture_generale_actualite` | `Actualite` | `PA - Quiz culture générale actualité` |
| Géographie | `culture_generale_geographie` | `Geographie` | `PA - Quiz culture générale géographie` |
| Langue française | `culture_generale_francais` | `France` | `PA - Quiz culture générale France` |
| Sport & culture générale | `culture_generale_sport` | `Sport` | `PA - Quiz culture générale sport` |
| Sciences | `culture_generale_sciences` | `Sciences` | `PA - Quiz culture générale sciences` |
| Santé | `culture_generale_sante` | `Sante` | `PA - Quiz culture générale santé` |
| Police & sécurité | `culture_generale_police_securite` | `Police` | `PA - Quiz culture générale police` |
| Mythologie & culture générale | `culture_generale_mythologie` | `Mythologie` | `PA - Quiz culture générale mythologie` |
| Musique & culture générale | `culture_generale_musique` | `Musique` | `PA - Quiz culture générale musique` |
| Cinéma & culture générale | `culture_generale_cinema` | `Cinema` | `PA - Quiz culture générale cinéma` |
| Droit & culture générale | `culture_generale_droit` | `Droit` | `PA - Quiz culture générale droit` |
| Sécurité routière | `culture_generale_securite_routiere` | `Securite` | `PA - Quiz culture générale sécurité routière` |

Pour tous ces thèmes, `module_name = 'PA - Culture générale'`, `track='pa'` et `quizKey = 'pa_quiz_culture_generale_<fichier>'` (par exemple `pa_quiz_culture_generale_histoire_france`, `..._institutions_europeens`, `..._securite_routiere`). Moteur identique au GPX (§3.2) **et même banque de questions** (`quiz_questions` filtrée sur la même `category`, sans filtre sur le parcours).

---

## 2. PARCOURS GPX — Concours Gardien de la paix

### 2.1 « Structure du concours GPX » (badge « Organisation & déroulement ») **[DART]**
`content/gpx_exam/structure_gpx_concours/` :
- « Tableau récapitulatif des épreuves » (`/gpx_exam/concours/epreuves_gpx/tableau`) :
  - Cas pratique : 2 h, coefficient 4, éliminatoire < 5/20.
  - QCM culture générale : 1 h avec la langue, coefficient 2.
  - QCM langue étrangère : coefficient 1.
  - Tests psychotechniques : 2 h, non notés.
  - Sport (PHM + TECR) : éliminatoire < 7/20.
  - Entretien : 25 min, éliminatoire < 5/20.
  - Conditions d'accès.
- « Épreuves d'admissibilité — écrit » (`/epreuves_gpx/admissibilite`) et « Épreuves d'admission — oral & sport » (`/epreuves_gpx/admission`).
- Accueil secondaire `features/home/gpx_exam_concours_home_page.dart` (`/gpx_exam/concours`) : cartes « Structure du concours » et « S'entraîner ».

### 2.2 « Culture générale » (badge « Institutions & société ») **[DB]**
Hub `features/home/gpx_exam_culture_generale_page.dart` (`/gpx_exam/concours/culture_generale`), 15 cartes avec titre et sous-titre. Fichiers `content/gpx_exam/culture_generale/quiz_culture_generale_*.dart` :

| Libellé hub | Route `/gpx_exam/concours/…` | `category` | `quiz_name` | `quizKey` |
|---|---|---|---|---|
| Histoire de France & institutions | `culture_generale_histoire_france` | `Histoire` | `Quiz culture générale histoire` | `quiz_culture_generale_histoire_france` |
| Institutions européennes | `culture_generale_institutions_europeennes` | `Institutions` | `Quiz culture générale institutions européennes` | `quiz_culture_generale_institutions_europeens` |
| Actualité & société | `culture_generale_actualite` | `Actualite` | `Quiz culture générale actualité` | `quiz_culture_generale_actualite` |
| Géographie française & mondiale | `culture_generale_geographie` | `Geographie` | `Quiz culture générale géographie` | `quiz_culture_generale_geographie` |
| Français & Humanités | `culture_generale_francais` | `France` | `Quiz culture générale France` | `quiz_culture_generale_france` |
| Sport & culture générale | `culture_generale_sport` | `Sport` | `Quiz culture générale sport` | `quiz_culture_generale_sport` |
| Sciences & environnement | `culture_generale_sciences` | `Sciences` | `Quiz culture générale sciences` | `quiz_culture_generale_sciences` |
| Santé & bien-être | `culture_generale_sante` | `Sante` | `Quiz culture générale santé` | `quiz_culture_generale_sante` |
| Police & sécurité publique | `culture_generale_police_securite` | `Police` | `Quiz culture générale police` | `quiz_culture_generale_police` |
| Mythologie & culture générale | `culture_generale_mythologie` | `Mythologie` | `Quiz culture générale mythologie` | `quiz_culture_generale_mythologie` |
| Musique & culture générale | `culture_generale_musique` | `Musique` | `Quiz culture générale musique` | `quiz_culture_generale_musique` |
| Cinéma & culture générale | `culture_generale_cinema` | `Cinema` | `Quiz culture générale cinéma` | `quiz_culture_generale_cinema` |
| Droit & culture générale | `culture_generale_droit` | `Droit` | `Quiz culture générale droit` | `quiz_culture_generale_droit` |
| Langue & culture générale | `culture_generale_langue` → **alias** vers `QuizCultureGeneralFrance` (`routes/app_router.dart` l.525) | `France` | (idem France) | (idem) |
| Sécurité routière & culture générale | `culture_generale_securite_routiere` | `Securite` | `Quiz culture générale sécurité routière` | `quiz_culture_generale_securite_routiere` |

`module_name = 'Culture générale'`, `track='gpx'`, `mode='exam'`. **[MORT]** Les tables `quiz_culture_generale_*_pages` (PA et GPX) sont référencées dans `_saveAnswer`, qui n'est jamais appelé.

### 2.3 « Langue étrangère » (badge « Anglais • Espagnol • Allemand ») **[DART]**
`content/gpx_exam/langue_etrangere/quiz_langue_etrangere_{anglais,espagnol,allemand}.dart` :

| Libellé | Route | Banque | `module_name` / `quiz_name` / `quizKey` |
|---|---|---|---|
| QCM — Anglais | `/gpx_exam/concours/langue_etrangere/exemples_anglais` | 435 questions (Facile 182 / Moyenne 164 / Difficile 89), « Texte à trous » | `Langue étrangère - Anglais` / `Quiz langue étrangère anglais` / `quiz_langue_etrangere_anglais` |
| QCM — Espagnol | `…/exemples_espagnol` | 441 (257 / 114 / 70) | `Langue étrangère - Espagnol` / `Quiz langue étrangère espagnol` / `quiz_langue_etrangere_espagnol` |
| QCM — Allemand | `…/exemples_allemand` | 348 (178 / 109 / 61) | `Langue étrangère - Allemand` / `Quiz langue étrangère allemand` / `quiz_langue_etrangere_allemand` |

Format : QCM à 3 options, `{category, question, options, answer, explanation, difficulty}`. Insertion au démarrage dans `quiz_history`, avec `'grade':'gpx'` en plus et sans `finished_at`. Fin et RPC : comme les QCM PA codés en dur. **[MORT]** `_saveAnswer` → `quiz_langue_etrangere_{langue}`.

### 2.4 « Tests psychotechniques » (badge « Logique • Numérique • Verbal • Spatial ») **[DB]**
Module `features/gpx_exam/psychotechniques/`. Le service `services/psycho_question_service.dart` (table `PsychoTable`) commente « 283 000 questions ».

| Libellé | Route `/gpx_exam/concours/tests_psychotechniques/…` | Table | `exercise_type` écrit | Chrono par question | Session par défaut |
|---|---|---|---|---|---|
| Comprendre l'épreuve **[DART]** | `comprendre_epreuve` | — | — | — | — |
| Attention visuelle | `attention_visuelle` (`AttentionVisuellePageNew`) | `tests_psyco_attention_visuelle` (difficulté `easy/medium/hard`, pas de `rand_key`) | `attention_visuelle` | 15 s | 12 |
| Suites logiques | `suites_logiques` (`SuitesLogiquesPageNew`) | `tests_psyco_suite_logique` | `suite_logique` | 40 s | 10 |
| Raisonnement logique | `raisonnement_logique` | `tests_psyco_raisonnement_logique` | `raisonnement_logique` | 40 s | 10 |
| Calcul mental | `calcul_mental` (alias `calcul_rapide`) | `tests_psyco_calcul_mental` | `calcul_mental` | 30 s | 10 |
| Logique verbale | `logique_verbale` | `tests_psyco_logique_verbale` | `logique_verbale` | 30 s | 10 |
| Raisonnement spatial | `spatial` | `tests_psyco_raisonnement_spatial` (+ `image_url`, `figure_data` → `widgets/psycho_cube_renderer.dart`) | `raisonnement_spatial` | 45 s | 8 |
| Rotations & symétries | `rotations` | `tests_psyco_rotations_symetries` (+ `image_url`, `figure_data`) | `rotations_symetries` | 40 s | 8 |
| Concentration | `concentration` (alias `attention_concentration`) | `tests_psyco_concentration` (`prompt` ou `stimulus`) | `concentration` | 35 s | 10 |
| Mode concours (chronométré) | `mode_concours` | toutes | catégorie ou `mode_concours_global` | chrono global 2, 5 (défaut) ou 10 min | sans limite (pool en boucle) |

**Échantillonnage** (`_loadGeneric`) :
```dart
seed = random(); .from(table).select().eq('is_active', true).eq('difficulty', difficulty)
  .gte('rand_key', seed).order('rand_key').limit(limit)   // puis complément .lt('rand_key', seed)
// dédoublonnage par id + mélange local. Attention visuelle : select tout le niveau + shuffle + take(limit).
```
Comptage par niveau pour l'écran « Choix du niveau » : `.select('id').eq('is_active', true).eq('difficulty', d)` puis `length`. C'est coûteux, et le résultat est plafonné par le nombre maximal de lignes de PostgREST.
Difficulté en base : `Facile` / `Moyenne` / `Difficile`, sauf pour Attention visuelle (`easy`/`medium`/`hard`). Normalisation : `PsychoQuestion.normalizeDifficulty`.
Options : liste JSON de chaînes ou d'objets `{key|id|value, label|text|title}`. Une réponse est correcte si `picked.key == answer || picked.label == answer` (`models/psycho_question.dart`).
Mode concours : 30 questions par catégorie pour « Toutes les catégories », 60 pour une seule catégorie ; difficulté par défaut « Moyenne ».

**Déroulé** (`pages/psycho_quiz_page.dart`) : choix du niveau → intro (masquable, préférence `psycho_intro_hide_<cat>_v1`) → sélecteur de session → quiz. Un délai dépassé compte comme faux. Sortie ou fin gérées par `core/quiz/quiz_end_controller.dart`, avec réessai en cas d'échec de sauvegarde.

**Écriture** (`services/psycho_history_service.dart`). Une seule insertion en fin de session, **sans `quiz_history` et sans `record_learning_answer`** :
```dart
_supabase.from('tests_psychotechnique_history').insert({'user_id': user.id,'exercise_type': exerciseType,
  'module': 'psychotechnique','score': percent,'correct_answers': c,'wrong_answers': w,'total_questions': total,
  'duration_seconds': d,'avg_response_time': avg,
  'mode': 'concours' | 'concours_ended_early' | 'concours_global'});   // accuracy = colonne générée en base
```
Signalement (`services/psycho_report_service.dart`) : `tests_psycotechnique_report` `{user_uid, email, question_id, module, category, difficulty, question, options[{key,label}], answer, explanation, sub, report_type, message, page, status:'new'}`.

**Résultat** (`widgets/psycho_result_screen.dart`) : « Bilan • {niveau} », anneau en %, « de réussite », état « Enregistrement de ta session… » puis « Session enregistrée ». Tuiles Bonnes / Mauvaises / Total / Précision / Temps total / Temps moyen. Boutons « Recommencer », « Changer de niveau », « Retour aux exercices ».

### 2.5 « Cas pratique » (badge « Méthodologie & raisonnement ») **[DB]**
Parcours : `/gpx_exam/concours/cas_pratique/welcome` (`cas_pratique_welcome_page.dart`) → `/cas_pratique_etapes_reussite` (onboarding `cas_pratique_onboarding.dart`) → `/cas_pratique/list` (`cas_pratique_list_confiug.dart`, pagination par 40) → `/cas_pratique/case_dynamic` avec le slug en argument (`cas_pratique_excercice/case_dynamic_page.dart`).

**Lecture** (`data/cas_pratique/cas_pratique_repository_impl.dart`) :
- `cas_pratique_themes` triés par `sort_order`.
- `cas_pratique_cases` `.eq('status','published')`. Colonnes : `id, slug, title, year, month, difficulty ('facile'|'moyen'|'difficile'|'expert'), total_points, estimated_minutes, published_at, status, is_free, situation_text, situation_md, theme:cas_pratique_themes(id, slug, label, color_hex, icon, sort_order)`. Filtres possibles : thème, année, difficulté, recherche. Tri : récent, alphabétique ou durée.
- `cas_pratique_questions` `.eq('case_id').order('position')` : `id, position, label, hint, max_points, char_min, char_recommended, perfect_answer:cas_pratique_perfect_answers(body_md, references_legal)`.
- Progression : `cas_pratique_attempts.select('case_id, percent, finished_at').eq('user_id').inFilter('case_id', ids)`.

**Chrono** : `estimated_minutes`, 20 min par défaut. Il démarre sur « Je commence », pas de retour arrière. À expiration, la copie part en correction en l'état.

**Écritures** :
```dart
// début (ou reprise via getActiveAttempt : status='in_progress')
_sb.from('cas_pratique_attempts').insert({'user_id': userId,'case_id': caseId,'status': 'in_progress'}).select().single();
// brouillon (debounce 1,5 s) et validation
_sb.from('cas_pratique_answers').upsert({'user_id','case_id': caseSlugLegacy /* slug ! */,'attempt_id','question_id',
  'question_index','answer','char_count','status': 'draft'|'validated'}, onConflict: 'attempt_id,question_id');
// correction locale (core/cas_pratique/engine/correction_engine.dart, kEngineVersion '2.0.0')
_sb.rpc('cp_get_rubric_for_attempt', params: {'p_attempt_id': attemptId});   // grille (SECURITY DEFINER)
_sb.from('cas_pratique_corrections').insert({'attempt_id','total_score','total_max','percent','engine_version',
  'engine_settings': {'normalizer':'v1','fuzzy':true,'ngrams':true,'lemma':true,'partial_threshold':0.5}}).select('id').single();
_sb.from('cas_pratique_correction_details').insert([{correction_id, question_id, point_id,
  status:'covered'|'partial'|'missing', score, weight, group_matches}]).select(...);
_sb.from('cas_pratique_attempts').update({'status':'completed','total_score','total_max','percent','finished_at','time_spent_ms'});
// appel sur un point manqué
_sb.from('cas_pratique_appeals').insert({'correction_detail_id','user_id','message'});
_sb.rpc('cp_report_question', params: {'p_question_id','p_report_type','p_message'});
```
Le moteur de correction est **côté client** : normalisation, tokenisation, lemmatisation, Levenshtein, synonymes, négation, mots-clés, points, score (`core/cas_pratique/engine/*.dart`). Il faut le porter en TypeScript, ou le passer côté serveur.

**Résultat** : `ScoreReveal` (score et %), pastilles par point avec `explanation_md`, réponse parfaite (`body_md`, `references_legal`), bouton d'appel sur les points manqués, « Moteur de correction v2.0.0 », « Retour à la liste ».

Autres éléments :
- Pages annexes routées : « Mes appels » (`my_appeals_page.dart`, abonnement realtime à `cas_pratique_appeals`), classement (`fn_cp_get_leaderboard`, `fn_cp_my_leaderboard_position`), parrainage (`fn_cp_get_or_create_my_referral_code`, `fn_cp_redeem_referral_code`), recommandations (`fn_cp_recommend_next_cases`), confidentialité (Edge Functions), PDF, partage.
- **[MORT]** XP, badges, streaks (`fn_cp_xp_total`, `fn_cp_check_and_unlock_badges`, `fn_cp_compute_streak`) et recherche FTS (`cp_search_cases_fts`, `cp_search_autocomplete`) ne sont pas branchés.
- Héritage : `case_1..6_page.dart` (`/gpx_exam/concours/cas_pratique/case_N`) sont **[DART]**, notés sur 15 en local, et écrivent `cas_pratique_answers.insert({user_id, case_id:'case_1', attempt_id: uuid, question_index, answer})`. Ils sont routés mais absents de la liste.

### 2.6 Concours blanc et Annales
- `features/home/concours_blanc_page.dart` (`/home-gpx-exam/concours-blanc`) : **squelette orphelin**, qui n'est même pas routé. Il affiche « 3h chrono · 5 épreuves au choix », avec Cas pratique 45 min / 20 pts, Culture générale 30 min / 15, Français — synthèse 60 / 20, QCM connaissances 20 / 30, Épreuve complète 180 / 100. Tous les boutons mènent à « Bientôt disponible ».
- `content/gpx_exam/cas_pratique/concours_blanc_page.dart` (`CasPratiqueConcoursBlancPage`, routée mais **jamais poussée**). Fonctionnement :
  - `cas_pratique_mock_exams` (`status='published'`) et `cas_pratique_mock_exam_cases` (`case_id`, `position`) ;
  - RPC `fn_cp_start_mock_exam{p_mock_exam_id}` → `{ok, attempt_id, deadline_at, resumed}` ;
  - réponses : `cas_pratique_mock_exam_answers.upsert({mock_attempt_id, question_id, text, char_count, updated_at}, onConflict:'mock_attempt_id,question_id')` ;
  - `fn_cp_finish_mock_exam{p_mock_attempt_id}` et `fn_cp_mock_exam_leaderboard{p_mock_exam_id, p_limit}` ;
  - chrono 45 min par défaut (`total_minutes`), verrouillage strict, soumission automatique.
- `features/home/annales_page.dart` (`/home-gpx-exam/annales`) : placeholder orphelin « Cette page doit être codée plus tard ».

---

## 3. Mécanique commune des QCM (culture générale PA et GPX, langue, QCM psycho PA codés en dur)

### 3.1 Niveau et taille de session
- Écran `_DifficultySplash` : « Sélectionne le niveau de difficulté », cartes Facile / Moyen (valeur `Moyenne`) / Difficile, bouton « Commencer », « Mélanger les 3 niveaux » (`difficulty = null`), « Nouvelles questions à chaque partie. »
- `core/quiz/quiz_session_picker.dart`, « Combien de questions ? » :
  - « Session rapide » 10 (~5 min), « Session standard » 20 (~10 min), « Session intensive » 50 ;
  - « Personnalisée » de 5 à min(dispo, 100) ;
  - « Toutes les questions ».
  - Le dernier choix est mémorisé (préférence `quiz_session_length_v1`, défaut 20).
- **Aucun chrono** dans ces QCM. L'animation `_msTotal` est purement visuelle.

### 3.2 Contenu de la culture générale (PA et GPX) **[DB]**
```dart
// compte
sb.from('quiz_questions').count(CountOption.exact).eq('category', cat)[.eq('difficulty', d)];
// tirage pseudo-aléatoire
sb.from('quiz_questions').select('id,module,category,question,options,answer,explanation,difficulty,sub,rand_key')
  .eq('category', cat)[.eq('difficulty', d)].gte('rand_key', seed).order('rand_key').limit(n); // + wrap .lt('rand_key', seed)
```
`options` est en JSONB, parfois sous forme de chaîne JSON doublement encodée. Elles sont nettoyées (trim, valeurs vides et « null » retirées, dédoublonnage), la bonne réponse est ajoutée si elle manque, puis le tout est mélangé.

### 3.3 Contrat d'écriture (exemple : `quiz_culture_generale_police.dart` l.1000-1070)
- **Début** (après le chargement des questions) :
```dart
_sb.from('quiz_history').insert({'uid': uid,'email': email,'module_name': 'Culture générale','quiz_name': 'Quiz culture générale police',
  'score': 0,'correct_count': 0,'total_questions': _total,'mode': 'exam','track': 'gpx',
  'started_at': nowUtc,'finished_at': nowUtc /* colonne NOT NULL supposée */,'completed_at': null}).select('id').single();
```
  Variantes : langue étrangère et QCM psycho PA ajoutent `'grade': 'gpx'|'pa'` et omettent `finished_at` et `completed_at`.
- **Par réponse** (`core/services/learning_answer_history_service.dart`). Appel non bloquant. En cas d'échec, l'appel est mis en file hors ligne (`copiq_learning_answer_offline_queue_v1`, 500 max) puis rejoué :
```dart
_client.rpc('record_learning_answer', params: {'p_history_id': historyId,'p_track': 'gpx'|'pa','p_mode': 'exam',
  'p_module_key': q.category,'p_quiz_key': '<quizKey>','p_question_id': '${q.category}:${index+1}','p_question_text': q.question,
  'p_options': q.options,'p_user_answer': choice,'p_correct_answer': q.answer,'p_is_correct': ok,'p_explanation': q.explanation,
  'p_difficulty': q.difficulty,'p_response_time_ms': null,'p_question_position': index+1,
  'p_client_event_id': uuid.v4(),'p_question_version': null});   // → renvoie answer_id ; alimente quiz_answer_history
```
  Note : `p_question_id` n'est **pas** l'id en base ; c'est `category:position`.
- **Fin** (dernière question, bouton « Mettre fin » ou croix, avec confirmation « Mettre fin au quiz ? ») :
```dart
_sb.from('quiz_history').update({'total_questions': answered,'score': percent,'correct_count': _score,
  'finished_at': nowUtc,'completed_at': nowUtc,'mode': 'exam','track': 'gpx'}).eq('id', _historyRowId).eq('uid', uid);
```
- Signalement (culture générale seulement) : `report_culture_generale` `{created_at, user_uid, email, question_id, module, category, difficulty, question, options, answer, explanation, sub, report_type:'bug'|'probleme'|'autre', message, page: routeName, status:'new'}`.

### 3.4 Carte de résultat (CG, langue, QCM psycho PA)
- % ≥ 80 : « Excellent ! » / « Tu maîtrises parfaitement le sujet ✨ ».
- % ≥ 50 : « Bon travail » / « Encore un petit effort 💪 ».
- Sinon : « À retravailler » / « Revois la leçon et retente ».
- Ligne « {score}/{répondues} bonnes réponses • {pct}% », boutons « Quitter » et « Recommencer ».
- Le score porte sur les questions **répondues**, pas sur la taille de la session.

---

## 4. Accès gratuit ou premium (`core/services/subscription_service.dart`)
- **Premium** = `rpc('is_user_premium', {p_user_id})` **OU** RevenueCat (`RevenueCatService.instance.isPremium`). Realtime sur `cas_pratique_subscriptions` et `free_weekly_usage`.
- **Gratuit** : 10 « requêtes quiz » par fenêtre glissante de 7 jours. Lecture via `free_weekly_usage.select('user_id, window_start, used, updated_at')`, réinitialisation à `updated_at + 7 j`. Consommation : `rpc('consume_free_request')` → `{allowed, premium, remaining, resets_at, reason}`. Verrouillage si `!isPremium && remaining <= 0`.
- **Déclencheurs de consommation** :
  - `NavigatorObserver.didPush/didReplace` (`main.dart` l.1583) → `onRoutePushed(name)` sur toute route **nommée** contenant `/quiz`, `/gpx_exam`, `/pa_exam` ou `quiz_`. Les **hubs** sont donc comptés eux aussi, par exemple `/pa_exam/concours/tests_psychotechniques`. Les pages poussées sans nom (éditeur photolangage) ne le sont pas. Anti-doublon : même route en moins de 3 s.
  - Accueil GPX `_openRouteWithQuota` : consommation **supplémentaire** explicite pour les routes feuilles (`culture_generale_*`, `tests_psychotechniques/*`, `langue_etrangere/exemples_*`, `cas_pratique/*`). Risque de double décompte. Si refusé : « Limite atteinte — Tu as utilisé tes 10 quiz gratuits… » avec un lien vers `/abonnement`.
  - Cartes d'accueil PA et GPX : `guardAppAccess(context)` ouvre le dialogue de verrouillage (déblocage par pub récompensée possible) et affiche le badge « Premium » sur les cartes si verrouillé.
- **Aucun verrou par contenu n'est appliqué** :
  - `photolangage_cases.is_premium` et `cas_pratique_cases.is_free` sont lus mais ignorés ;
  - `CasPratiqueSubscriptionService.canAccessCase` (`user_metadata.cas_pratique_premium`) n'est pas utilisé ;
  - `CpPaywallPage` (`/cas-pratique/paywall`, déclencheurs `second_case` et `concours_blanc`) n'est jamais poussée ;
  - `PaywallGate` et `EntitlementService` (`get_my_entitlement`) ne sont pas utilisés dans les examens.

---

## 5. Suivi de progression (lecture seule, à reproduire sur le web)
- PA : `features/home/pa_exam_progress_{repository,service,calculator,models,page}.dart` + `pa_exam_progress_source_registry.dart`.
- GPX : `gpx_exam_progress_*`.
- Commun : `quiz_progress_enrichment.dart`.
- Sources :
  - `quiz_history` `.eq('uid').eq('track', t).eq('mode','exam')`, limite 500 ;
  - PA : `tests_psychotechnique_history` `.eq('module','pa_psychotechnique').eq('mode','concours')` ;
  - GPX : `.eq('module','psychotechnique').inFilter('mode', ['concours','concours_global'])`. `concours_ended_early` est **exclu** ;
  - PA : `photolangage_attempts` `.eq('user_id').eq('track','pa').eq('mode','exam').eq('status','submitted')`. Le score retenu est `pedagogical_score` sur 100 ;
  - GPX : `cas_pratique_attempts` `.eq('status','completed')` avec `cas_pratique_cases(title)`. Le score retenu est `percent` ;
  - PA : `placement_results` (dernier `score_pct`) ;
  - `quiz_answer_history` (`history_id, question_id, question_text, options_snapshot, user_answer, correct_answer, is_correct, explanation_snapshot, difficulty, response_time_ms, answered_at`) : recalcule le score par tentative et regroupe les erreurs par `module_key`.
- Classement des modules par mots-clés trouvés dans `module_name + quiz_name` :
  - PA : photo → photolangage ; psycho/logique/calcul/concentration/attention → psychotechnique ; fran/verbal → francais ; police/institution → institution ; culture/connaissance → culture_generale ; sinon autres.
  - GPX : cas pratique ; psycho… ; langue/anglais/espagnol/allemand → langue_etrangere ; police/institution → institution ; culture/histoire/geograph/science/droit/actualite/sport → culture_generale.
- Réflexion « Avant la correction, tu étais… » (Sûr / Hésitant / Au hasard) → `coach_answer_reflections.upsert({user_id, answer_id, confidence:'known'|'hesitant'|'guess', perceived_cause, updated_at}, onConflict:'user_id,answer_id')`.

## 6. Test de positionnement (`features/placement/**`)
- Routes `/placement-intro` et `/placement`, poussées depuis `welcome_after_signup.dart`.
- **[DART]** 32 questions (`_buildQuestionBank` dans `placement_test.dart`) sur 5 domaines : francais, logique, deontologie, histoire, sport. 6 questions par domaine, soit 30. Poids 1, 2 ou 3 selon la difficulté. Démarrage en difficulté moyenne. **15 min** de chrono global, avec envoi automatique.
- `placement_engine.dart` et `placement_questions.dart` sont une ancienne version **[MORT]**.
- Écritures :
```dart
supabase.from('placement_results').insert({'user_id','email','total_score','max_score','score_pct'}).select('id').single();
supabase.from('placement_answers').insert([{'result_id','user_id','question_id','domain','selected_index','correct_index','is_correct'}]);
```
- Résultat (`widgets/placement_result_view.dart`) :
  - « Ton niveau est… » : Débutant < 40, Intermédiaire < 60, puis paliers supérieurs ;
  - tuiles « Bonnes réponses / Précision / Adaptation », « Analyse IA » (texte généré en local), « Compétences à renforcer », « Objectif recommandé » (nombre de jours) ;
  - bouton « Commencer mon parcours ».

## 7. Ressources
- Pas de `storage.from()` dans le périmètre. Les images distantes sont des URL stockées en base : `photolangage_cases.image_url` et `tests_psyco_*.image_url` (spatial et rotations).
- Ressources locales :
  - `assets/images/concours_pa_epreuves.jpeg`, `concours_photolangage.jpeg`, `concours_tests_psy.jpeg`, `comprendre_psyco.png` et les images des cartes GPX ;
  - `assets/sfx/correct_answer.mp3` et `wrong_answer.mp3`.

## 8. Points d'attention pour le portage
1. Le PA et le GPX partagent `quiz_questions` (même `category`). Seuls `track` et `quiz_name` (préfixe `PA - `) les distinguent.
2. Le `score` de `quiz_history` est un **%**. Celui de `tests_psychotechnique_history` est un % pour le GPX mais un **nombre brut** pour Attention et Suites du PA.
3. `completed_at` est écrit en heure locale sans fuseau pour la langue et les QCM psycho PA.
4. `photolangage_attempts` est inséré sans `user_id`, `track` ni `mode`, alors que le suivi PA filtre sur `track` et `mode`. Il faut vérifier les défauts en base.
5. `cas_pratique_answers.case_id` reçoit le **slug**, pas l'uuid.
6. Le titre des sessions de rotations psycho GPX n'est pas reconnu (`rotations_symetries` est absent de `_psyTitle`).
7. Le psycho GPX n'écrit rien dans `quiz_history` ni dans `quiz_answer_history`. Seul le résumé de session est enregistré.
8. Risque de double consommation du quota sur l'accueil GPX, et consommation sur les hubs (§4).
