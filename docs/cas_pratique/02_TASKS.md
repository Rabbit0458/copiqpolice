# ✅ COP'IQ — Cas Pratique GPX — Checklist 110 Tâches

> Chaque tâche est **atomique** (≤ 30 min de travail), **vérifiable** (un test concret), et **traçable** (ID stable T001-T110). Quand une tâche est faite, cocher `[x]` et noter la date.

**Légende statuts** :
- `[ ]` pending
- `[~]` in_progress
- `[x]` completed
- `[!]` blocked (voir notes en fin de fichier)

---

## 🟦 PHASE 1 — Database Schema (T001 → T020)

> Fichier de référence : `03_SCHEMA.sql`

- [ ] **T001** — Créer la table `cas_pratique_themes`
  - Colonnes : `id uuid PK`, `slug text unique`, `label text`, `color_hex text`, `icon text`, `sort_order int`
  - Vérification : `SELECT * FROM cas_pratique_themes;` retourne au moins les 5 thèmes seed
  - Dépendances : aucune

- [ ] **T002** — Créer la table `cas_pratique_cases`
  - Colonnes : `id uuid PK`, `slug text unique`, `title text`, `year int`, `month text`, `theme_id uuid FK`, `situation_text text`, `situation_md text`, `difficulty text` (`facile|moyen|difficile`), `total_points int default 15`, `estimated_minutes int default 15`, `status text` (`draft|review|published|archived`), `created_at timestamptz`, `updated_at timestamptz`, `published_at timestamptz`, `created_by uuid`, `notes_admin text`
  - Vérification : insert + select + RLS
  - Dépendances : T001

- [ ] **T003** — Créer la table `cas_pratique_questions`
  - Colonnes : `id uuid PK`, `case_id uuid FK CASCADE`, `position int`, `label text`, `hint text NULL`, `max_points int default 5`, `char_min int default 50`, `char_recommended int default 400`, `created_at timestamptz`
  - Contrainte : `unique(case_id, position)`
  - Dépendances : T002

- [ ] **T004** — Créer la table `cas_pratique_perfect_answers`
  - Colonnes : `id uuid PK`, `question_id uuid FK CASCADE unique`, `body_md text`, `references_legal jsonb` (ex: `[{article:"322-1", code:"penal"}]`), `created_at`, `updated_at`
  - Dépendances : T003

- [ ] **T005** — Créer la table `cas_pratique_rubric_points`
  - Colonnes : `id uuid PK`, `question_id uuid FK CASCADE`, `position int`, `label text`, `weight numeric(3,2) default 1.00`, `is_required bool default true`, `kind text` (`core|bonus`), `explanation_md text NULL`, `created_at`
  - Contrainte : `unique(question_id, position)`
  - Dépendances : T003

- [ ] **T006** — Créer la table `cas_pratique_keyword_groups`
  - Colonnes : `id uuid PK`, `point_id uuid FK CASCADE`, `position int`, `description text NULL`, `is_optional bool default false`
  - Contrainte : `unique(point_id, position)`
  - Logique : entre groupes = ET ; à l'intérieur d'un groupe = OR
  - Dépendances : T005

- [ ] **T007** — Créer la table `cas_pratique_keywords`
  - Colonnes : `id uuid PK`, `group_id uuid FK CASCADE NULL`, `syn_dict_id uuid FK NULL`, `value text NULL`, `is_phrase bool default false`, `is_negation bool default false`, `fuzzy_max_dist int default 1`, `position int`, `created_at`, `created_by uuid`, `auto_added bool default false`
  - Contrainte : `(group_id IS NOT NULL OR syn_dict_id IS NOT NULL)`
  - Note : un keyword peut soit avoir une valeur littérale (`value`), soit pointer vers le dictionnaire (`syn_dict_id`)
  - Dépendances : T006, T008

- [ ] **T008** — Créer la table `cas_pratique_synonyms_dictionary`
  - Colonnes : `id uuid PK`, `slug text unique` (ex: `calmer`, `degrader`), `label text`, `terms jsonb` (array de strings), `tags jsonb` (ex: `["deontologie","accueil"]`), `created_at`, `updated_at`, `owner_admin_id uuid`
  - Vérification : `SELECT slug, jsonb_array_length(terms) FROM cas_pratique_synonyms_dictionary;`
  - Dépendances : aucune (peut être créée avant T007)

- [ ] **T009** — Créer la table `cas_pratique_attempts`
  - Colonnes : `id uuid PK`, `user_id uuid FK auth.users`, `case_id uuid FK`, `started_at timestamptz`, `finished_at timestamptz NULL`, `status text` (`in_progress|completed|abandoned`), `total_score numeric(5,2) NULL`, `total_max numeric(5,2) NULL`, `percent numeric(5,2) NULL`, `time_spent_ms bigint NULL`, `device_info jsonb NULL`
  - Index : `(user_id, case_id, started_at DESC)`
  - Dépendances : T002

- [ ] **T010** — Migrer la table `cas_pratique_answers` (existante)
  - Ajouter : `attempt_id uuid FK`, `question_id uuid FK`, `normalized_text text`, `char_count int`, `updated_at timestamptz`
  - Garder rétrocompat : `case_id text` reste, `question_index int` reste
  - Backfill : pour les lignes existantes, créer un attempt synthétique
  - Dépendances : T003, T009

- [ ] **T011** — Créer la table `cas_pratique_corrections`
  - Colonnes : `id uuid PK`, `attempt_id uuid FK unique`, `total_score numeric(5,2)`, `total_max numeric(5,2)`, `percent numeric(5,2)`, `evaluated_at timestamptz`, `engine_version text`, `engine_settings jsonb` (paramètres utilisés)
  - Dépendances : T009

- [ ] **T012** — Créer la table `cas_pratique_correction_details`
  - Colonnes : `id uuid PK`, `correction_id uuid FK CASCADE`, `question_id uuid FK`, `point_id uuid FK`, `status text` (`covered|partial|missing`), `score numeric(3,2)`, `weight numeric(3,2)`, `group_matches jsonb` (debug : quels groupes ont matché)
  - Index : `(correction_id, question_id)`
  - Dépendances : T011, T005

- [ ] **T013** — Créer la table `cas_pratique_appeals`
  - Colonnes : `id uuid PK`, `correction_detail_id uuid FK`, `user_id uuid FK`, `message text NULL`, `status text` (`pending|approved|rejected`), `admin_id uuid NULL`, `admin_response text NULL`, `processed_at timestamptz NULL`, `created_keyword_id uuid NULL`, `created_at timestamptz`
  - Dépendances : T012

- [ ] **T014** — Créer la table `cas_pratique_user_progress`
  - Colonnes : `user_id uuid PK FK`, `cases_started int default 0`, `cases_finished int default 0`, `total_attempts int default 0`, `avg_score_percent numeric(5,2) NULL`, `best_score_percent numeric(5,2) NULL`, `last_attempt_at timestamptz NULL`, `streak_days int default 0`, `updated_at timestamptz`
  - Dépendances : T009

- [ ] **T015** — Créer la table `cas_pratique_admin_audit`
  - Colonnes : `id uuid PK`, `admin_id uuid FK`, `action text` (`create|update|delete|publish|approve_appeal|reject_appeal`), `entity text` (`case|question|rubric_point|keyword|appeal|...`), `entity_id uuid`, `payload_diff jsonb`, `ip text`, `user_agent text`, `created_at timestamptz`
  - Dépendances : aucune

- [ ] **T016** — Créer les indexes essentiels
  - `CREATE INDEX ON cas_pratique_cases (theme_id);`
  - `CREATE INDEX ON cas_pratique_cases (status, published_at DESC);`
  - `CREATE INDEX ON cas_pratique_attempts (user_id, case_id);`
  - `CREATE INDEX ON cas_pratique_answers (attempt_id, question_id);`
  - `CREATE INDEX ON cas_pratique_correction_details (correction_id);`
  - `CREATE INDEX ON cas_pratique_appeals (status) WHERE status = 'pending';`
  - Dépendances : T002, T009, T010, T012, T013

- [ ] **T017** — Index full-text trigram (recherche admin)
  - `CREATE EXTENSION IF NOT EXISTS pg_trgm;`
  - `CREATE INDEX idx_cases_title_trgm ON cas_pratique_cases USING gin (title gin_trgm_ops);`
  - `CREATE INDEX idx_cases_situation_trgm ON cas_pratique_cases USING gin (situation_text gin_trgm_ops);`
  - Dépendances : T002

- [ ] **T018** — Trigger `update_user_progress_after_correction`
  - Recalcule `avg_score_percent`, `best_score_percent`, `cases_finished`, `last_attempt_at` à chaque insert dans `cas_pratique_corrections`
  - Idempotent
  - Dépendances : T011, T014

- [ ] **T019** — RLS policies user
  - User ne lit que SES tentatives, réponses, corrections, appeals
  - User n'écrit que SES propres données
  - Toutes les tables `attempts`, `answers`, `corrections`, `correction_details`, `appeals`, `user_progress`
  - Dépendances : T009 → T014

- [ ] **T020** — RLS policies admin
  - Custom claim JWT `is_admin = true` (set via fonction `auth.set_admin_claim(user_id)`)
  - Policy : `USING ((auth.jwt() ->> 'is_admin')::bool = true)`
  - Full access sur toutes les tables `cases`, `questions`, `perfect_answers`, `rubric_points`, `keyword_groups`, `keywords`, `synonyms_dictionary`, `appeals`, `admin_audit`
  - Dépendances : T001 → T015

---

## 🟩 PHASE 2 — Migration des cas existants (T021 → T030)

- [ ] **T021** — Script Dart `tools/extract_legacy_cases.dart`
  - Lit les 6 fichiers `case_X_page.dart`
  - Parse les `_PerfectAnswer` et `_ExpectedPoint`
  - Émet un fichier JSON par cas dans `tools/legacy_dump/case_X.json`
  - Dépendances : T002 → T007

- [ ] **T022** — Script SQL `tools/legacy_to_db.sql`
  - Lit les JSON et génère les `INSERT` SQL correspondants
  - Dépendances : T021

- [ ] **T023** — Insert des thèmes initiaux
  - Seeds : Accueil, Déontologie, Cadre légal, Sécurité publique, Intervention, Famille/Mineur, Routier
  - Avec couleurs et icônes
  - Dépendances : T001

- [ ] **T024** — Insert des 6 cas legacy en `published`
  - Avec `slug = "case_X"` pour rétrocompat
  - Avec `year` et `theme_id` corrects (à inférer du contenu)
  - Dépendances : T002, T023

- [ ] **T025** — Insert des 18 questions
  - 3 questions × 6 cas
  - `position 1, 2, 3`, `max_points = 5` chacune
  - Dépendances : T003, T024

- [ ] **T026** — Insert des 6 perfect_answers (3 par cas = 18 lignes)
  - Le `body_md` contient la réponse parfaite formatée
  - Identifier les références légales (articles du code pénal cités)
  - Dépendances : T004, T025

- [ ] **T027** — Insert des rubric_points + keyword_groups + keywords
  - ~50 points × ~3 groupes × ~10 keywords = ~1500 lignes
  - Script généré depuis le JSON
  - Dépendances : T005, T006, T007, T025

- [ ] **T028** — Identifier les sets de synonymes récurrents
  - Analyser quels keywords reviennent dans plusieurs rubrics
  - Top candidats : `calmer`, `respect`, `dégrader`, `cambriolage`, `vehicule`, `victime`, `auteur`, `infraction`, `constat`, `flagrance`, …
  - Injecter dans `cas_pratique_synonyms_dictionary` (~50 entrées initiales)
  - Refactor des keywords existants pour pointer vers le dictionnaire
  - Dépendances : T008, T027

- [ ] **T029** — Test de régression
  - Pour chaque cas legacy, comparer score `engine_v2` (DB) vs `engine_v1` (code Dart actuel)
  - Tolérance : ±1 point sur 15
  - Si écart, identifier la cause et corriger les keywords avant de continuer
  - Dépendances : T027

- [ ] **T030** — Backup des fichiers legacy
  - `mkdir lib/legacy/cas_pratique/`
  - Déplacer `case_1_page.dart` → `case_6_page.dart` dans ce dossier
  - Marquer `@deprecated` dans les classes
  - Ne supprime PAS encore (suppression à T060)
  - Dépendances : T029

---

## 🟧 PHASE 3 — Moteur de correction nouvelle génération (T031 → T045)

> Fichier de référence : `04_CORRECTION_ENGINE_SPEC.md`

- [ ] **T031** — Créer `lib/core/cas_pratique/engine/normalizer.dart`
  - Classe `Normalizer` avec méthode `String normalize(String input)`
  - Pipeline : Unicode NFD → strip diacritics → lowercase → strip punctuation → collapse whitespace
  - Tests : 20 cas de figure
  - Dépendances : aucune

- [ ] **T032** — Compléter Unicode NFD + diacritics
  - Utiliser `unorm` ou implémentation manuelle pour Dart
  - Tests : `àéèêëçœæ` → `aeeeeeoeae`
  - Dépendances : T031

- [ ] **T033** — Retrait ponctuation + collapse whitespace
  - Regex `[^a-z0-9\s]` → ` `
  - `\s+` → ` ` puis `trim()`
  - Garder les apostrophes en option (paramétrable)
  - Dépendances : T031

- [ ] **T034** — Stop-words FR
  - Liste : `le, la, les, un, une, des, de, du, à, au, aux, et, ou, ni, mais, donc, or, car, je, tu, il, elle, on, nous, vous, ils, elles, mon, ma, mes, ton, ta, tes, son, sa, ses, notre, votre, leur, ce, cet, cette, ces, qui, que, quoi, dont, où, est, sont, suis, es, ai, as, a, ont, avons, avez`
  - Méthode `removeStopWords(List<String> tokens) → List<String>`
  - Optionnel (paramétrable) : certaines rubrics veulent garder les négations (`ne pas`)
  - Dépendances : T031

- [ ] **T035** — Lemmatiseur FR léger
  - Pas un vrai lemmatiseur (trop lourd) — juste retrait des suffixes courants
  - Suffixes : `-ais, -ait, -ions, -iez, -aient, -er, -ir, -re, -é, -ée, -és, -ées, -s, -x, -aux, -ant, -ent, -ons, -ez`
  - Retrait conditionnel (si mot ≥ 5 lettres après retrait)
  - Tests : `dégradait` → `degrad`, `dégrader` → `degrad`, `dégradations` → `degrad`
  - Dépendances : T031

- [ ] **T036** — Tokenizer + n-grams
  - Méthode `List<String> tokenize(String s)` : split sur whitespace
  - Méthode `List<String> ngrams(List<String> tokens, int n)` : génère bigrams/trigrams
  - Tests : `"degradation volontaire"` → bigram `"degradation_volontaire"`
  - Dépendances : T031

- [ ] **T037** — Levenshtein distance
  - Implémentation classique (matrice 2D)
  - Méthode `int distance(String a, String b)` et `double ratio(String a, String b)`
  - Optimisation : early-exit si distance > seuil
  - Tests : `("degradation", "degredation") = 1`, `("vitre", "vitres") = 1`
  - Dépendances : aucune

- [ ] **T038** — Keyword matcher
  - Méthode `bool matches(String normalizedAnswer, Keyword kw)`
  - Logique :
    1. Si `is_phrase = true` → match exact dans la string
    2. Sinon → match dans les tokens, exact d'abord, puis fuzzy si activé et longueur ≥ 6
  - Méthode bonus : retourne le `MatchInfo` (position, distance, fuzzy ?)
  - Dépendances : T036, T037

- [ ] **T039** — Synonym resolver
  - Méthode `List<String> resolve(Keyword kw, SynDict dict)`
  - Si `syn_dict_id` non nul → renvoie `dict.terms`
  - Sinon → renvoie `[kw.value]`
  - Cache local pour éviter les lookups répétés
  - Dépendances : T038

- [ ] **T040** — Negation detector
  - Détecte `ne pas X`, `pas X`, `aucun X`, `jamais X`, `non` à proximité
  - Fenêtre de 5 tokens AVANT le keyword
  - Si négation détectée → le match du keyword est inversé OU annulé selon `kw.is_negation`
  - Tests : `"je ne dégrade pas"` ne match pas `dégrader` (sauf si `is_negation = true`)
  - Dépendances : T038

- [ ] **T041** — Point evaluator
  - Méthode `PointEvalResult evaluate(String userAnswer, RubricPoint point, List<KeywordGroup> groups)`
  - Logique : pour CHAQUE groupe, AU MOINS UN keyword doit matcher (OR)
  - Le point est `covered` si TOUS les groupes ont matché (ET)
  - Le point est `partial` si AU MOINS 50 % des groupes ont matché
  - Le point est `missing` sinon
  - Score : `covered = weight`, `partial = weight × 0.5`, `missing = 0`
  - Dépendances : T038, T039, T040

- [ ] **T042** — Question scorer
  - Méthode `QuestionScore score(String userAnswer, Question q, List<RubricPoint> points)`
  - Somme des scores des points
  - Normalisation à `q.max_points` (par défaut 5)
  - Retourne `{score, max, percent, point_results: [...]}`
  - Dépendances : T041

- [ ] **T043** — Attempt scorer
  - Méthode `AttemptCorrection correctAttempt(Attempt a, List<Answer> answers, Case fullCase)`
  - Boucle sur les questions
  - Calcule total /15 (ou /20 selon cas)
  - Persiste dans `corrections` + `correction_details`
  - Dépendances : T042

- [ ] **T044** — Tests unitaires
  - Au moins 50 cas dans `test/cas_pratique/`
  - Couvrir : normalisation, fuzzy, ngrams, négation, points required vs bonus, synonymes
  - Snapshot fixtures : `test/cas_pratique/fixtures/case_1_perfect.json`, `case_1_partial.json`, etc.
  - Dépendances : T031 → T043

- [ ] **T045** — Benchmark performance
  - Cas : 1 cas avec 3 questions, 9 points, 25 groupes, 250 keywords
  - Réponse user : 2000 caractères
  - Cible : `< 80 ms` sur Pixel 4a / iPhone SE
  - Si dépassé : profiler et optimiser (cache, early exit, indexation tokens)
  - Dépendances : T043

---

## 🟪 PHASE 4 — Page cas pratique dynamique (T046 → T060)

- [ ] **T046** — Repository `lib/data/cas_pratique/cas_pratique_repository.dart`
  - Méthodes : `Future<List<CaseSummary>> listCases({filters})`, `Future<CaseDetail> getCase(String slug)`, `Future<Attempt> startAttempt(String caseId)`, `Future<void> saveAnswer(...)`, `Future<Correction> finishAndCorrect(...)`
  - Dépendances : T002 → T012

- [ ] **T047** — Models `lib/data/cas_pratique/cas_pratique_models.dart`
  - Classes : `Theme`, `CaseSummary`, `CaseDetail`, `Question`, `PerfectAnswer`, `RubricPoint`, `KeywordGroup`, `Keyword`, `Attempt`, `Answer`, `Correction`, `CorrectionDetail`, `Appeal`
  - Sérialisation depuis Supabase (Map → object)
  - Dépendances : T046

- [ ] **T048** — Cache local Hive
  - Box `cas_pratique_cache` avec TTL 24h
  - Cache : liste des cases, détail des cases ouverts récemment
  - Invalidation manuelle : pull-to-refresh
  - Dépendances : T046, T047

- [ ] **T049** — Page dynamique `lib/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_dynamic_page.dart`
  - Reçoit un argument `caseSlug` ou `caseId`
  - Remplace les 6 fichiers hardcodés
  - Architecture : `PageController` + Pages (intro, texte, Q1..QN, correction)
  - Dépendances : T046, T047

- [ ] **T050** — Skeleton loader pendant le fetch
  - Shimmer effect via `shimmer` package OU custom Container avec animation
  - Affichage 3 sections : header, body, action
  - Dépendances : T049

- [ ] **T051** — Page Intro dynamique
  - Hero : titre cas + thème en pill + ETA + difficulté
  - 3 puces : "Lecture scénario / Structure / Correction expliquée"
  - CTA "Lire le scénario"
  - Animations : fade + slide à l'entrée
  - Dépendances : T049

- [ ] **T052** — Page Texte du cas
  - Lecture immersive : texte sur fond surface, line-height 1.6, font 16, max-width
  - Scroll smooth
  - Sticky bottom : bouton "Je commence"
  - Mention "Tu pourras relire le scénario à tout moment"
  - Dépendances : T049

- [ ] **T053** — Bouton "Re-lire le cas" sur page Question
  - Modal sheet pleine hauteur (78 % screen)
  - Texte du cas affiché
  - Bouton fermer
  - Réutilise le composant existant (déjà bien fait)
  - Dépendances : T049, T052

- [ ] **T054** — Page Question (1 par 1)
  - Énoncé en haut (dans une card subtile)
  - Textarea premium : padding 16, font 15, line-height 1.5, border focus animé
  - Compteur caractères : `{count} / {recommended} caractères`
  - Couleur compteur : neutre < 50 %, normal 50-100 %, vert > 100 %
  - Bouton "Valider" en sticky bottom (désactivé si vide)
  - Dépendances : T049

- [ ] **T055** — Auto-save debounced
  - Après 1.5 s sans changement → save brouillon dans `cas_pratique_answers` (status `draft`)
  - Indicator subtil : icône cloud avec animation pulse pendant le save
  - "Sauvegardé il y a Xs"
  - Dépendances : T046, T054

- [ ] **T056** — Bouton Valider
  - Verrouille la réponse (status `validated` dans la DB)
  - Lock back navigation après validation
  - Animation de validation (checkmark fade-in)
  - Haptic feedback `selectionClick`
  - Passe à la question suivante
  - Dépendances : T055

- [ ] **T057** — Lock back navigation
  - Préserve la logique existante `_minBackIndex`
  - Snackbar warning si tentative de revenir en arrière
  - Dépendances : T056

- [ ] **T058** — Page Correction — score révélé
  - À l'ouverture : appel `engine.correctAttempt()`
  - Animation : `CircularProgressIndicator` qui se remplit en 1.2 s
  - Compteur de score qui scrolle de 0 à `total_score`
  - Couleur du circle selon palier : 0-30 % rouge, 30-70 % orange, 70-100 % vert
  - Confettis (`confetti` package) si ≥ 80 %
  - Sound feedback (optionnel, si user a son activé)
  - Dépendances : T043

- [ ] **T059** — Accordion par question
  - Pour chaque question : header avec score `4/5`, expand/collapse
  - Body :
    - Section "Ta réponse" (collapsable)
    - Section "Points couverts" (vert avec checkmark)
    - Section "Points manqués" (rouge avec X + bouton "Faire appel")
    - Section "Points partiels" (orange avec ~ + explication)
    - Section "Réponse parfaite" (collapsable)
  - Dépendances : T058

- [ ] **T060** — Update `cas_pratique_list_confiug.dart`
  - Remplacer les routes `/case_1` … `/case_6` par `/cas_pratique/case_dynamic` avec argument
  - Suppression définitive des fichiers `case_1_page.dart` → `case_6_page.dart` (sortis du build)
  - Tests manuels : ouvrir chaque cas et vérifier qu'il fonctionne
  - Dépendances : T029, T049, T059

---

## 🟨 PHASE 5 — Liste dynamique des cas (T061 → T070)

- [ ] **T061** — Pull cases depuis Supabase
  - Au lieu de la liste hardcodée de 30 entries
  - Filter `status = 'published'`
  - Order `published_at DESC` par défaut
  - Dépendances : T046

- [ ] **T062** — Filtres en pill (Année / Thème / Difficulté)
  - 3 chips horizontalement scrollables en haut
  - Tap → bottom sheet avec choix multiples (checkboxes)
  - Apply filter → re-fetch
  - Persistence du filtre dans `shared_preferences`
  - Dépendances : T061

- [ ] **T063** — Recherche full-text
  - Icône loupe en haut → expand search bar
  - Search dans `title` et `situation_text` (côté Supabase, full-text trigram)
  - Debounce 300 ms
  - Dépendances : T017, T061

- [ ] **T064** — Tri (Récent / Score / Durée)
  - Bouton tri à côté des filtres
  - Bottom sheet avec radio buttons
  - Dépendances : T061

- [ ] **T065** — Badge "Nouveau"
  - Sur les cas publiés < 7 jours
  - Pill orange en haut-droite de la card
  - Dépendances : T061

- [ ] **T066** — Badge "Recommandé"
  - Algorithme simple : cas du même thème que les derniers cas réussis par l'user
  - Pill bleue
  - Dépendances : T061, T014

- [ ] **T067** — Affichage taux de réussite
  - Sur la card : "67 % réussissent ce cas" (calculé depuis `cas_pratique_corrections`)
  - Vue matérialisée Supabase recalculée chaque nuit
  - Dépendances : T011

- [ ] **T068** — État dernière tentative
  - Sur la card : si l'user a déjà fait le cas, afficher "Ton score : 11/15"
  - Couleur selon palier
  - Dépendances : T009, T011

- [ ] **T069** — Pull-to-refresh
  - Standard Material `RefreshIndicator`
  - Reset cache + re-fetch
  - Dépendances : T048

- [ ] **T070** — Empty state
  - Si aucun cas (offline ou no results) : illustration + message + bouton "Réessayer"
  - Dépendances : T061

---

## 🟥 PHASE 6 — Système d'appel/signalement (T071 → T078)

- [ ] **T071** — UI bouton "Faire appel"
  - Sur chaque point manqué dans la correction
  - Pill discrète "🤔 Je pense que ma réponse est correcte"
  - Dépendances : T059

- [ ] **T072** — Modal d'argumentation
  - Bottom sheet avec :
    - Rappel : ta réponse, le point attendu
    - Textarea : "Explique pourquoi tu penses que c'est correct"
    - Bouton "Envoyer"
  - Dépendances : T071

- [ ] **T073** — Insert dans `cas_pratique_appeals`
  - Avec `correction_detail_id`, `user_id`, `message`
  - Status `pending`
  - Dépendances : T013

- [ ] **T074** — Notification push admin
  - Via Supabase Realtime sur la table `cas_pratique_appeals`
  - OU via OneSignal si déjà intégré
  - Notification immédiate sur l'appli admin
  - Dépendances : T073

- [ ] **T075** — UI admin liste des appels
  - Page `admin/appeals` triée par date desc
  - Pour chaque appeal : message user, sa réponse, le point attendu, la rubric
  - Bouton "Approuver" / "Rejeter"
  - Dépendances : T013

- [ ] **T076** — Action "Approuver"
  - Modal : "Quel mot-clé manquait ?"
  - Champ pré-rempli avec extrait de la réponse user
  - Insert dans `cas_pratique_keywords` avec `auto_added = true`, lien vers le bon `group_id`
  - Update `appeal.status = 'approved'`, `created_keyword_id`
  - Dépendances : T007, T075

- [ ] **T077** — Action "Rejeter"
  - Modal avec textarea pour motif
  - Update `appeal.status = 'rejected'`, `admin_response`
  - Notification au user
  - Dépendances : T075

- [ ] **T078** — Recalcul score user après approve
  - Lance `engine.correctAttempt()` à nouveau pour la tentative concernée
  - Update `corrections` et `correction_details`
  - Notification user : "Bonne nouvelle, ton score est passé à X/15"
  - Dépendances : T043, T076

---

## 🟫 PHASE 7 — Panel admin (T079 → T093)

> Fichier de référence : `06_ADMIN_PANEL_SPEC.md`

- [ ] **T079** — Authentification admin
  - JWT custom claim `is_admin = true`
  - Route admin gated par `AuthGuard.requireAdmin()`
  - Splash si non admin
  - Dépendances : T020

- [ ] **T080** — Dashboard admin
  - KPIs : nb cas publiés, nb users actifs 7j, nb tentatives 7j, score moyen, nb appels pending
  - Graphique évolution sur 30 jours
  - Top 5 cas les plus échoués
  - Dépendances : T079

- [ ] **T081** — Liste des cas
  - Table avec colonnes : Titre, Année, Thème, Statut, Actions
  - Actions : Éditer, Dupliquer, Archiver, Publier
  - Filtre par statut (`draft / review / published / archived`)
  - Dépendances : T079

- [ ] **T082** — Form Création de cas
  - Étape 1 : titre, année, mois, thème, difficulté, durée estimée
  - Étape 2 : situation (markdown éditeur)
  - Étape 3 : prévisualisation
  - Sauvegarde en `draft` par défaut
  - Dépendances : T002, T081

- [ ] **T083** — Form Ajout de questions
  - Liste de questions avec drag-and-drop pour réordonner
  - Pour chaque question : énoncé, hint, max_points, char_recommended
  - Dépendances : T003, T082

- [ ] **T084** — Form Réponse parfaite
  - Markdown éditeur (avec preview)
  - Section "Références légales" : ajout d'articles cités (autocomplete sur le code pénal/CPP)
  - Dépendances : T004, T083

- [ ] **T085** — Form Rubric points
  - Drag-and-drop pour réordonner
  - Pour chaque point : label, weight, is_required, kind, explanation
  - Bouton "+ Ajouter un point"
  - Dépendances : T005, T083

- [ ] **T086** — Form Keyword groups
  - Visualisation arborescente : Point → Groupes → Keywords
  - Bouton "+ Ajouter un groupe" (sera ET avec les autres)
  - Description optionnelle pour clarifier la sémantique du groupe
  - Dépendances : T006, T085

- [ ] **T087** — Form Keywords + preview match
  - Pour chaque keyword : valeur, fuzzy_max_dist, is_phrase, is_negation
  - OU : sélection d'un dictionnaire de synonymes
  - **Preview live** : champ "Tester" → on tape une réponse et on voit en temps réel quels keywords matchent (highlighted)
  - Dépendances : T007, T038, T086

- [ ] **T088** — Éditeur Dictionnaire de synonymes
  - Page dédiée `admin/synonyms`
  - CRUD slug, label, terms, tags
  - Recherche dans le dictionnaire
  - Référence count : combien de keywords pointent vers ce dict
  - Dépendances : T008

- [ ] **T089** — Mode Preview cas
  - Bouton "Tester en mode user" sur chaque cas (même draft)
  - Ouvre le cas comme un user, sans persister la tentative
  - Permet de valider l'expérience avant publication
  - Dépendances : T049, T081

- [ ] **T090** — Workflow publication
  - Statuts : `draft → review → published → archived`
  - Bouton "Publier" : passe en `published` + set `published_at = now()`
  - Bouton "Archiver" : enlève de la liste user mais garde les données
  - Logs dans `admin_audit`
  - Dépendances : T015, T081

- [ ] **T091** — Stats par cas
  - Vue détaillée : taux complétion, score moyen, temps moyen, drop-off par question, points les plus ratés
  - Permet d'identifier les rubrics à améliorer
  - Dépendances : T011, T012, T081

- [ ] **T092** — Liste des appels à traiter
  - Page `admin/appeals` (déjà créée en T075)
  - Tri par date, filtre par statut
  - Stats : nb pending, nb approved/rejected ce mois
  - Dépendances : T075

- [ ] **T093** — Audit log
  - Page `admin/audit` avec timeline des actions
  - Filtre par admin, par entity, par action
  - Lien vers l'entité concernée
  - Dépendances : T015

---

## 🟫 PHASE 8 — Design ultra-premium (T094 → T105)

> Fichier de référence : `05_DESIGN_SYSTEM.md`

- [ ] **T094** — Charte couleurs cas pratique
  - Palette principale : `#1147D9`, `#000B36`
  - Sémantiques : vert `#22C55E`, rouge `#EF4444`, orange `#F59E0B`
  - Surfaces dark : `#0B102A`, `#0F1438`, `#13193F`
  - Surfaces light : `#FFFFFF`, `#F4F6FB`, `#EAEEF7`
  - Documenté dans `05_DESIGN_SYSTEM.md`
  - Dépendances : aucune

- [ ] **T095** — Page Intro premium
  - Hero animation : titre fade-in lettre par lettre
  - Badge thème avec icône et couleur du thème
  - 3 puces avec icône + label, fade-in stagger
  - CTA bouton blanc avec shadow + scale on press
  - Dépendances : T051

- [ ] **T096** — Page Texte premium
  - Reading mode : font 16, line-height 1.6, paragraphes espacés
  - Couleur texte : `Colors.white.withOpacity(0.92)` en dark, `Colors.black87` en light
  - Possibilité d'agrandir le texte (bouton A+ / A-)
  - Dépendances : T052

- [ ] **T097** — Page Question premium
  - Textarea avec borders animés (focus = couleur primaire)
  - Compteur caractères : couleur change selon palier
  - Auto-save indicator : cloud icon pulse + texte "Sauvegardé il y a 2s"
  - Bouton Valider : disabled avec opacity 0.5 si textarea vide
  - Dépendances : T054, T055

- [ ] **T098** — Page Correction reveal animation
  - Fond : gradient animé qui pulse
  - Score : `CircularProgressIndicator` 200×200 px, custom paint pour le gradient de couleur
  - Compteur : `TweenAnimationBuilder<int>` qui scrolle de 0 à `total_score` en 1.2 s
  - Confettis : `confetti` package, déclenchement si ≥ 80 %
  - Haptic burst à la fin
  - Dépendances : T058

- [ ] **T099** — Couleurs sémantiques cohérentes
  - Vert `#22C55E` (covered)
  - Rouge `#EF4444` (missing)
  - Orange `#F59E0B` (partial)
  - Avec versions light/dark adaptées (alpha modulé)
  - Dépendances : T094

- [ ] **T100** — Mode dark parfait
  - Background : gradient `#000B36 → #000A33 → #00082D`
  - Cards : `#0B102A` avec border `#1A2050`
  - Texte : `Colors.white.withOpacity(0.92 / 0.78 / 0.62)` (3 niveaux)
  - Audit visuel sur 5 devices : iPhone SE, iPhone 14 Pro, Pixel 4a, Pixel 8, Galaxy A52
  - Dépendances : T094

- [ ] **T101** — Mode light parfait
  - Background : gradient `#1147D9 → #1A55E6 → #0E2F9E` (immersif) OU surface neutre `#F4F6FB` selon page
  - Cards : `#FFFFFF` avec shadow douce
  - Texte : `Colors.black.withOpacity(0.87 / 0.70 / 0.50)`
  - Mêmes 5 devices à auditer
  - Dépendances : T094

- [ ] **T102** — Animations spring physics
  - Standard 280-320 ms `Curves.easeOutCubic` pour les transitions de page
  - Spring `Curves.elasticOut` réservé aux célébrations (score reveal)
  - Toujours respecter `MediaQuery.disableAnimations`
  - Dépendances : aucune

- [ ] **T103** — Haptic feedback
  - `HapticFeedback.selectionClick()` à chaque tap interactif
  - `HapticFeedback.mediumImpact()` à la validation d'une question
  - `HapticFeedback.heavyImpact()` au reveal du score final
  - Dépendances : aucune

- [ ] **T104** — Mode Focus (anti-distraction)
  - Toggle dans les settings de la page question
  - Active : `SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive)` + désactive les notifications (iOS focus mode si possible)
  - Subtle : juste un pill "Focus" en haut
  - Dépendances : T054

- [ ] **T105** — Partage du score
  - Bouton "Partager" sur la page correction
  - Génère une image (1080×1920) via `screenshot` package : score, titre du cas, logo COP'IQ, badge thème, gradient COP'IQ
  - Share via `share_plus`
  - Dépendances : T058

---

## 🟦 PHASE 9 — Performance & UX (T106 → T110)

- [ ] **T106** — Précharge la liste des cas
  - Au lancement de l'app, fetch en background la liste des cases publiées
  - Cache mis à jour
  - Dépendances : T046, T048

- [ ] **T107** — Skeleton loaders partout
  - Liste cas, détail cas, page question, page correction
  - Pas de spinner brut nulle part
  - Dépendances : T050

- [ ] **T108** — Mode offline
  - Cache local des cases déjà ouverts (Hive)
  - Si offline et cas en cache : on peut faire le cas
  - Correction faite localement (engine fonctionne offline)
  - Sync à la reconnexion : push answers, attempts, corrections
  - Dépendances : T046, T048

- [ ] **T109** — Sauvegarde locale brouillon
  - Avant que `auto-save` Supabase ne se déclenche, écriture instantanée dans `shared_preferences`
  - Si l'app crash ou est tuée, on retrouve sa réponse au redémarrage
  - Dépendances : T055

- [ ] **T110** — Sync background
  - Worker (`workmanager` Flutter) qui flush les actions en attente quand la connexion revient
  - Batch upsert des `answers` non synchronisées
  - Dépendances : T108, T109

---

## 🚧 BLOCAGES (à compléter à chaud)

| ID    | Tâche bloquée | Raison              | Action requise (Kaïs)       |
|-------|---------------|---------------------|-----------------------------|
| —     | —             | —                   | —                           |

---

## 📜 NOTES & DÉCISIONS

- **2026-05-08** : Plan initial créé. Choix d'architecture validé : pas de LLM en ligne, moteur déterministe avec filet de sécurité par appel utilisateur.
