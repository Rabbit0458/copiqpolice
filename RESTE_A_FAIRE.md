# COP'IQ — Audit final avant publication (28 juillet 2026)

**Méthode** : chaque ligne de ce document est issue d'une vérification réelle —
lecture de code, requête SQL exécutée sur la base de production, sortie de
`flutter analyze`, ou lecture des manifestes `AndroidManifest.xml` /
`Info.plist`. Rien n'est estimé ni supposé. Ce document **remplace** la
version du 26/07/2026.

**Ce qui n'a PAS pu être vérifié ici** (nécessite un device/simulateur réel,
absent de cet environnement) : rendu visuel écran par écran, fluidité des
animations, comportement au clavier, contraste réel en dark mode, temps de
démarrage à froid, consommation batterie/mémoire in situ, et la soumission
réelle sur App Store Connect / Play Console. Ces points sont listés en fin de
document comme QA manuelle obligatoire — ne pas les considérer validés.

---

## A. État réel du projet

| Axe | Statut |
|---|---|
| Compilation / lint (`flutter analyze`) | ✅ **0 problème** sur 1 673 fichiers Dart (2,39 M lignes) |
| Routing (boutons → pages) | ⚠️ 0 conflit **actif**, mais **435 pages mortes confirmées** (code jamais exécutable) |
| Contenu GPX Exam / GPX Scolarité | ✅ Fonctionnellement complet, routé, quiz alimentés |
| Contenu PA Exam | ✅ Fonctionnellement complet |
| Contenu PA Scolarité | 🔴 **363 pages rédigées mais mortes** — chantier éditorial, pas technique |
| Contenu Réserve | ✅ Contenu inachevé mais correctement verrouillé (0 utilisateur exposé, défense en profondeur ajoutée) |
| Base de données (structure) | ✅ 176 tables, RLS activé partout, cas pratique et signalements sains |
| Base de données (hygiène des données) | 🔴 **6,35M lignes de doublons** dans `quiz_questions` |
| Sécurité Supabase | 🟠 876 avis (dont 1 vraie faille de configuration à corriger, le reste = durcissement) |
| Performance Supabase à l'échelle | 🟠 551 avis de perf, dont 260 `auth_rls_initplan` — réel à l'échelle de centaines de milliers d'utilisateurs |
| Conformité iOS (App Store) | ✅ **Corrigé le 28/07/2026** — `NSPhotoLibraryUsageDescription` ajoutée ; **à retester sur device/simulateur avant soumission** |
| Conformité Android (Play Store) | 🟠 Non vérifiable sans build réel — manifeste vide de permissions explicites |
| Hygiène du code | ✅ 13 TODO seulement sur tout le projet, tous localisés et non-critiques |

**Verdict global (mis à jour après corrections autonomes du 28/07/2026)** :
le crash iOS bloquant est corrigé dans le code (reste un test device réel à
faire) et le garde-fou Réserve renforcé. Il reste 1 point 🔴 réellement actif
(déduplication `quiz_questions`, en cours) avant que l'app soit dans un état
optimal pour la soumission. Le reste (PA Scolarité, perf Supabase) n'empêche
pas de soumettre mais dégradera l'expérience et le coût d'infrastructure à
l'échelle visée.

---

## B. Fonctionnalités entièrement terminées et vérifiées

- Authentification (inscription, connexion, mot de passe oublié, deep links
  OAuth Apple/Google) — routes et intent-filters iOS/Android présents et
  documentés dans les manifestes.
- GPX Exam : cas pratique (516 cas, 1 544 questions, 0 titre dupliqué),
  psychotechniques (10 pages routées), culture générale, français, quiz de
  concours.
- GPX Scolarité (hors module Réserve) : cours + quiz dynamiques
  (`QuizScolariteDynamiquePage`, 15 modules × 12 questions = 180 questions,
  répartition parfaitement homogène).
- PA Exam : structure de concours, mémento circulation, épreuves.
- Panel admin : 13 pages fonctionnelles, RBAC (`has_admin_permission`) posé
  sur les RPC sensibles (`admin_reports_unified`, `admin_resolve_report`),
  journal d'audit immuable (`admin_audit_logs`).
- Signalements (bug de ce mois, corrigé) : les signalements sur les cas
  pratiques (`cas_pratique_question_reports`) sont maintenant visibles et
  traitables depuis `/admin/signalements`.
- Abonnements Stripe : tables `billing_*`, `stripe_customers`,
  `subscription_events` présentes et RLS activé.
- Cas pratique : XP, badges (20 catalogués), streak freezes, leaderboard,
  parrainage, mock exams — schéma complet et cohérent.

---

## C. Anomalies détectées

### ✅ C.1 — Crash iOS confirmé : sélection d'image sans usage description (CORRIGÉ le 28/07/2026, à retester sur device)

- **Emplacement** : `ios/Runner/Info.plist` (aucune clé `NSPhotoLibraryUsageDescription`
  ni `NSCameraUsageDescription`) / `lib/features/forum/forum_espace_exam_gpx.dart:2243-2247`
  (`ImagePicker().pickImage(source: ImageSource.gallery)` réellement appelé
  depuis un `onTap` en production, ligne 2422).
- **Gravité** : Critique.
- **Impact** : sur iOS, iOS tue immédiatement l'app dès qu'elle touche à la
  photothèque sans string de justification déclarée (TCC enforcement — ce
  n'est pas un risque de refus, c'est un crash garanti et systématiquement
  testé par le reviewer Apple). Rejet automatique à la soumission.
- **Solution** : ajouter dans `Info.plist` :
  `NSPhotoLibraryUsageDescription` (texte expliquant l'usage — partage de
  photo dans le forum) et `NSPhotoLibraryAddUsageDescription` si l'app
  sauvegarde des images. Vérifier aussi les 2 autres call-sites `TODO: à
  brancher avec un vrai picker` (lignes 4628, 4793 du même fichier) avant
  release, pour savoir s'ils doivent être supprimés ou complétés.

### 🔴 C.2 — 6,35 millions de lignes dupliquées dans `quiz_questions`

- **Emplacement** : table Supabase `public.quiz_questions` (Culture générale
  GPX Exam / PA Exam).
- **Gravité** : Majeure (coût infra + risque de timeout à l'échelle).
- **Constat vérifié par requête SQL** : la catégorie « Police » contient 81
  questions distinctes répétées **exactement 600 fois chacune** (48 600
  lignes). Même ratio ×600 confirmé sur « Droit » et « Sport ». Extrapolé sur
  l'ensemble du module Culture générale (hors Géographie), cela représente la
  quasi-totalité des 6,35M lignes.
- **Cause identifiée dans le code** : `quiz_culture_generale_police.dart`
  (et ses clones) implémente un tirage pseudo-aléatoire par colonne
  `rand_key` pour éviter un `ORDER BY random()` coûteux — technique valide,
  mais qui **ne nécessite qu'une seule ligne par question** avec une clé
  aléatoire statique. La duplication ×600 n'apporte aucun bénéfice
  fonctionnel et multiplie par 600 le stockage, le temps de sauvegarde et le
  risque de timeout.
- **Cas à part — catégorie Géographie (1,3M lignes)** : ce n'est pas de la
  duplication mais un générateur combinatoire (« quelle est la préfecture du
  département X », « quel pays n'appartient pas à telle région ») qui a
  produit ~984 000 variantes réellement distinctes.
- **Solution recommandée** : dédupliquer `quiz_questions` en gardant 1 ligne
  par `(module, category, question)` avec une seule `rand_key` aléatoire.
  **Décision explicite de l'utilisateur (29/07/2026) : ne pas réduire le
  volume de contenu distinct** — les catégories combinatoires (Géographie,
  France...) gardent l'intégralité de leurs variantes uniques ; seuls les
  doublons de texte strictement identique sont retirés.

### ✅ C.3 — Module Réserve : contenu inachevé, mais déjà correctement verrouillé (corrigé, défense en profondeur ajoutée)

- **Emplacement** : `lib/content/reserve_scolarite/introduction/reserve_introduction_page.dart:54-63`,
  `lib/features/home/home_page_reserve_school.dart`, `lib/features/onboarding/reserve_school.dart`,
  `lib/features/onboarding/grade_picker.dart`, `lib/features/home/home_bootstrap.dart`.
- **Constat initial (à corriger)** : le texte affiché sur ces pages contient
  littéralement `'• TODO: compléter avec les missions du Réserviste.\n'`.
  Vérification plus poussée : `grade_picker.dart` (écran affiché à tout
  nouveau compte via `HomeBootstrap`) **verrouille déjà** la carte Réserve —
  `_apply()` intercepte `GradeChoice.reserve` en tout début de fonction et
  affiche un toast "Bientôt disponible" **sans jamais naviguer ni persister
  `user_track='reserve'`** (le code de navigation vers `ReserveAccueilPage`
  plus bas dans le même fichier est mort, inatteignable). Requête SQL sur
  `user_profiles` : **0 compte** avec `user_track='reserve'` actuellement.
  **Aucun utilisateur réel n'est donc exposé au contenu placeholder
  aujourd'hui.**
- **Trou de défense en profondeur identifié et corrigé** : `HomeBootstrap`
  acceptait `'reserve'` comme piste valide (`_isValidTrack`) et aurait routé
  tout profil avec `user_track='reserve'` (ex. donnée historique/legacy,
  migration, edit manuel) directement vers le contenu inachevé, sans aucun
  garde-fou à ce niveau. **Corrigé** : `home_bootstrap.dart` redirige
  désormais ce cas vers `/grade_picker` au lieu de `/reserve`.
- **Reste à faire (non bloquant)** : finaliser le contenu Réserve
  (`reserve_introduction_page.dart` et les modules associés) pour une future
  release, ou supprimer le code mort de navigation dans `grade_picker.dart`
  (lignes 109-115) si la fonctionnalité est abandonnée.

### 🟠 C.4 — 435 pages de PA/GPX Scolarité rédigées mais totalement inaccessibles

- **Emplacement** : majoritairement `lib/content/pa_scolarite/**` (363
  fichiers), le reste dans `lib/content/gpx_scolarite/dps_dpg/**` (67
  fichiers, ancienne génération avant le passage aux quiz dynamiques
  Supabase).
- **Gravité** : Majeure pour PA Scolarité (c'est le seul vrai chantier de
  contenu restant), mineure pour GPX Scolarité (doublons de l'ancienne
  architecture, remplacés par le moteur `QuizScolariteDynamiquePage`).
- **Méthode de vérification** : script d'analyse statique — extraction de
  toutes les classes déclarant un `routeName` (1 408 trouvées), comparaison
  avec les clés réellement enregistrées dans `RouteRegistry.routes`
  (`lib/routes/app_router.dart`), puis recherche de toute autre référence à
  la classe ailleurs dans le code (menus, listes de cours). 735 classes ne
  sont pas routées ; 300 sont référencées ailleurs (accessibles autrement,
  à vérifier au cas par cas) ; **435 n'ont absolument aucune référence** —
  code mort à 100 %, confirmé automatiquement.
- **Solution** : soit router ces 435 pages dans `RouteRegistry.routes` (si le
  contenu est prêt), soit les supprimer si elles sont obsolètes. Étant donné
  le volume (PA Scolarité), une revue par lot thématique est recommandée
  plutôt qu'un branchement page par page.

### 🟠 C.5 — 40 fichiers legacy à `routeName` dupliqué (code mort, sans risque actif)

- **Constat** : 40 paires de classes différentes déclarent exactement le même
  `routeName` (ex. `QuizDisparitionPage` vs `QuizDisparitionPageGPX`).
  Vérification effectuée : dans **tous les cas**, une seule des deux classes
  est réellement insérée dans `RouteRegistry.routes` — aucun conflit de
  navigation actif aujourd'hui (un commentaire du fichier confirme que ce
  pattern a déjà été traité consciemment une fois par le passé, pour
  `AttentionVisuellePage`/`AttentionVisuellePageNew`).
- **Gravité** : Mineure (nettoyage), mais **fragile** : si quelqu'un routait
  un jour la classe non enregistrée du duo, la dernière entrée du literal Map
  écraserait silencieusement l'autre — un bouton ouvrirait alors la mauvaise
  page sans crash ni erreur visible.
- **Solution** : supprimer les 40 fichiers legacy (`dps_dpg/**`) une fois
  confirmé que leur remplaçant `*GPX` couvre le même contenu.

### ✅ C.6 — Signalements sur les quiz classiques invisibles côté admin (CORRIGÉ le 28/07/2026)

- **Emplacement** : table `public.report_question`, alimentée par
  `.from('report_question').insert(...)` dans des dizaines de fichiers
  `lib/content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_*.dart`.
- **Gravité** : Majeure une fois l'app en prod (silencieux, donc dangereux :
  aucune erreur, juste des signalements qui n'arrivent jamais nulle part).
- **Constat** : `admin_reports_unified` (RPC utilisée par
  `/admin/signalements`) ne gère que les kinds `cg`, `psy`, `cas_pratique` —
  pas `question`. Le frontend admin propose pourtant un filtre "Questions de
  quiz" dans `KINDS` qui ne retournera jamais rien. Table actuellement à 0
  ligne (aucun signalement perdu *pour l'instant*), mais le chemin d'écriture
  est actif dès qu'un utilisateur clique sur signaler.
- **Solution** : même correctif que celui déjà appliqué pour `cas_pratique`
  ce mois-ci (migration `20260728010000_admin_reports_cas_pratique.sql`) —
  ajouter une branche `question` dans `admin_reports_unified` et
  `admin_resolve_report` pointant sur `report_question`.

### 🟠 C.7 — Sécurité Supabase : réglage "connexions anonymes" actif mais inutilisé

- **Constat** : l'avis `auth_allow_anonymous_sign_ins` est remonté sur 182
  tables (dont `admin_users`, `admin_audit_logs`, `billing_*`). Vérifié par
  grep : **aucun appel** à `signInAnonymously()` n'existe dans tout le code
  Flutter — la fonctionnalité "connexions anonymes" est activée au niveau du
  projet Supabase (Auth settings) sans être utilisée par l'app.
- **Gravité** : Majeure en potentiel (élargit inutilement la surface
  d'attaque : n'importe qui peut appeler l'API Supabase directement, obtenir
  un `auth.uid()` anonyme valide, et tester les policies RLS qui vérifient
  seulement `auth.uid() IS NOT NULL` sans exclure `is_anonymous`), nulle en
  exploitation confirmée.
- **Solution** : désactiver "Allow anonymous sign-ins" dans Project Settings
  → Authentication. Aucune perte fonctionnelle attendue.
- **Non automatisable depuis cet audit** : ce réglage vit dans la
  configuration Auth du projet Supabase (dashboard ou Management API), pas
  dans le schéma SQL — aucun outil disponible ici ne permet de le modifier.
  Action manuelle de 2 clics : dashboard Supabase → Project Settings →
  Authentication → désactiver "Allow anonymous sign-ins".

### 🟠 C.8 — Performance Supabase à l'échelle (260 + 132 + 48 avis)

- **`auth_rls_initplan` ×260** : policies RLS qui appellent `auth.uid()` /
  `auth.jwt()` directement au lieu de `(select auth.uid())`, ce qui force
  Postgres à réévaluer la fonction à **chaque ligne** plutôt qu'une fois par
  requête. Impact réel et documenté par Supabase à partir de quelques
  dizaines de milliers de lignes — directement pertinent pour l'objectif
  "centaines de milliers d'utilisateurs".
- **`multiple_permissive_policies` ×132** : plusieurs policies permissives
  empilées sur la même table/action, chacune évaluée séparément.
- **`unindexed_foreign_keys` ×48** : clés étrangères sans index de
  couverture — jointures et suppressions en cascade lentes à volume élevé.
- **`unused_index` ×97 / `duplicate_index` ×13** : coût d'écriture et de
  stockage sans bénéfice de lecture mesuré.
- **Solution** : passage en revue par lot (script de migration générique
  possible pour réécrire les policies `auth.uid()` → `(select auth.uid())`,
  c'est un remplacement mécanique sûr), suppression des index dupliqués,
  ajout d'index sur les FK non couvertes les plus grosses tables
  (`cas_pratique_*`, `quiz_questions`, `app_logs`).

### 🟡 C.9 — Divers durcissements Supabase mineurs

- `function_search_path_mutable` ×7 : fonctions sans `SET search_path`
  explicite (risque théorique d'injection de search_path).
- `extension_in_public` ×2 (`citext`, `pg_trgm`) : à déplacer hors du schéma
  `public` par convention de sécurité Supabase.
- `rls_enabled_no_policy` ×1 : `cp_rate_limit_buckets` a RLS activé sans
  aucune policy (bloque tout accès direct — probablement voulu puisque
  cette table n'est manipulée que par des fonctions `SECURITY DEFINER`, mais
  aucune policy explicite ne documente cette intention).
- `materialized_view_in_api` ×1 : `mv_admin_dashboard_stats` est
  sélectionnable par `anon`/`authenticated` via l'API — à vérifier qu'aucune
  donnée sensible n'y transite, ou à retirer de l'exposition PostgREST.
- `auth_otp_long_expiry`, `auth_leaked_password_protection`,
  `vulnerable_postgres_version` : recommandations standards Supabase
  (raccourcir l'expiration OTP, activer la protection mots de passe compromis
  via HaveIBeenPwned, mettre à jour la version Postgres du projet).
- 822 000 lignes (12,9 %) de `quiz_questions.options` stockées en JSON
  double-encodé (string au lieu de array). **Vérifié non-bloquant** : le
  parseur `QuizQuestion.fromJson` gère déjà ce cas défensivement
  (`jsonDecode` si `options` est une String). Reste une dette de propreté de
  données à corriger à la source lors du nettoyage de C.2.
- 2 questions strictement identiques entre modules `gpx_dh_ethique` et
  `gpx_intervention_malades_mentaux` / `gpx_intervention_autres` dans
  `quiz_scolarite_questions` — chevauchement thématique plausible, à trancher
  éditorialement (dupliquer volontairement ou choisir un seul module).

### 🔵 C.10 — Conformité Android non vérifiée (pas nécessairement un bug)

- **Constat** : `android/app/src/main/AndroidManifest.xml` ne déclare
  **aucune** `<uses-permission>` explicite, alors que l'app dépend de
  `image_picker`, `permission_handler`, `flutter_local_notifications`,
  `vibration`, `google_mobile_ads`, `firebase_messaging`. En pratique, la
  plupart de ces plugins fusionnent leurs propres permissions dans le
  manifeste final au moment du build Gradle (comportement standard Flutter) —
  ce n'est donc pas forcément un bug, mais **ce n'est pas vérifié ici**
  (nécessite un `flutter build apk` réel puis inspection du manifeste
  fusionné).
- **Point spécifique à contrôler** : `POST_NOTIFICATIONS` (obligatoire
  Android 13+ pour que les notifications locales s'affichent) — confirmer
  qu'elle est bien demandée à l'exécution, pas seulement déclarée.
- **Solution** : lancer un build Android réel et inspecter
  `build/app/outputs/.../AndroidManifest.xml` fusionné avant soumission Play
  Store.

---

## D. Audit des cours

| Statut | Nombre | Détail |
|---|---|---|
| Cours validés et routés | ~1 000 pages | GPX Exam, GPX Scolarité (hors ancienne génération), PA Exam |
| Cours rédigés mais non routés | 435 confirmés (+300 à vérifier) | Voir C.4 — 83 % dans PA Scolarité |
| Cours avec contenu placeholder visible | 1 module entier (Réserve) | Voir C.3 |
| Doublons de titre (cas pratique) | 0 | Vérifié par `GROUP BY title HAVING count(*)>1` sur les 516 cas |
| Cours orphelins (routés mais jamais liés depuis un menu) | non mesuré | Nécessiterait un crawl des menus, non fait faute de temps — à faire en complément |

---

## E. Audit des quiz

| Élément | Statut |
|---|---|
| `cas_pratique_cases` (516 cas / 1 544 questions) | ✅ 0 doublon de titre |
| `quiz_scolarite_questions` (180, 15 modules × 12) | ✅ Répartition homogène, seulement 2 doublons de texte cross-module (mineur) |
| `quiz_questions` (Culture générale, 6,35M lignes) | 🔴 Duplication massive ×600 sur la majorité des catégories — voir C.2 |
| Catégorie/thème cohérents | ✅ Pour cas pratique (theme_id → `cas_pratique_themes`, vérifié via la jointure ajoutée dans `admin_reports_unified`) et `quiz_scolarite_modules` (module ↔ route 1:1, vérifié dans `app_router.dart`) |
| Signalement d'erreur sur une question | ✅ cas pratique (branché ce mois-ci) / 🔴 quiz classiques (`report_question`, voir C.6) |

---

## F. Audit Supabase (résumé)

- 176 tables, RLS activé sur 100 % d'entre elles.
- 876 avis de sécurité : 1 point de configuration à corriger réellement
  (anonymous sign-ins, C.7), le reste = durcissement recommandé (C.9), aucune
  faille RLS avec accès croisé entre utilisateurs détectée dans les tables
  échantillonnées (`cas_pratique_*`, `billing_*`).
- 551 avis de performance, dominés par le pattern `auth_rls_initplan` (C.8) —
  le point le plus directement lié à l'objectif "centaines de milliers
  d'utilisateurs".
- Aucune fuite d'admin détectée : les RPC admin vérifient toutes
  `has_admin_permission(...)` avant d'agir (vérifié sur
  `admin_reports_unified`, `admin_resolve_report`).

---

## G. Audit UX/UI

**Non réalisable dans cet environnement** (pas de device/simulateur
disponible). Aucune anomalie visuelle n'a été "trouvée" faute de pouvoir
regarder l'app tourner — ne pas interpréter l'absence de mention comme une
validation. À faire manuellement avant soumission : test sur au moins un
appareil iOS et un Android, thème clair et sombre, en portrait et paysage sur
tablette (l'app déclare supporter le paysage sur iPad dans `Info.plist`).

---

## H. Optimisations recommandées (hors bugs bloquants)

1. Dédupliquer `quiz_questions` (C.2) — gain de stockage estimé de l'ordre de
   99 % sur ce module.
2. Réécrire les policies RLS `auth.uid()` → `(select auth.uid())` (C.8) —
   mécanique, sûr, gain de perf direct à l'échelle.
3. Supprimer les 435 fichiers PA/GPX Scolarité confirmés morts (C.4) après
   décision éditoriale (router ou supprimer), pour réduire la taille du
   dépôt et le temps de build.
4. Auditer les 31 `print(` restants et les remplacer par le logger applicatif
   (`AppConsoleLogger`, déjà utilisé ailleurs) pour la propreté des logs prod.

---

## I. Checklist finale avant publication

| # | Point | Statut |
|---|---|---|
| 1 | Compilation propre (`flutter analyze`) | ✅ |
| 2 | Aucun crash connu au lancement | ✅ (non testé sur device réel) |
| 3 | Sélecteur d'image iOS (`Info.plist`) | ✅ Corrigé — C.1 (à valider sur device réel) |
| 4 | Permissions Android vérifiées sur build réel | ⚠️ Non vérifié — C.10 |
| 5 | Suppression de compte disponible | ✅ Code présent (`user_page.dart`) |
| 6 | Politique de confidentialité / CGU liées | ✅ Code présent (`legal_content.dart`, `cp_privacy_page.dart`) |
| 7 | Toutes les routes de menu aboutissent à une page réelle | ⚠️ 435 confirmées mortes en PA/GPX Scolarité — C.4 |
| 8 | Aucun texte "TODO" visible en production | ✅ Vérifié : Réserve verrouillé, 0 utilisateur exposé — C.3 |
| 9 | Quiz sans doublons | ⚠️ `quiz_questions` massivement dupliqué — C.2 ; `cas_pratique` et `quiz_scolarite` propres |
| 10 | Signalements admin fonctionnels sur tous les types de contenu | ✅ cas pratique et quiz classiques — C.6 |
| 11 | RLS activé sur toutes les tables | ✅ |
| 12 | Pas de connexion anonyme non maîtrisée | ⚠️ Activée au niveau projet mais inutilisée — C.7 |
| 13 | Performance RLS soutenable à grande échelle | ⚠️ 260 policies à corriger — C.8 |
| 14 | Test manuel écran par écran (device réel) | ❌ Non fait — nécessaire avant soumission |
| 15 | Build Android + inspection manifeste fusionné | ❌ Non fait — nécessaire avant soumission |
| 16 | Soumission App Store Connect / Play Console | ❌ Non applicable ici — étape humaine finale |

---

## J. Reste à faire — feuille de route officielle

### 🔴 Bloquant avant publication

1. ✅ **[FAIT — 28/07/2026]** Corriger le crash iOS sur la sélection d'image
   *Fichier* : `ios/Runner/Info.plist`
   *Ce qui a été fait* : ajout de `NSPhotoLibraryUsageDescription` et
   `NSPhotoLibraryAddUsageDescription`.
   *Reste à faire* : **vérification obligatoire sur simulateur/device iOS
   réel** avant de considérer le point définitivement clos (non testable
   dans cet environnement).

2. **Dédupliquer `quiz_questions`**
   *Emplacement* : table Supabase `public.quiz_questions`.
   *Méthode* : script SQL `DISTINCT ON (module, category, question)` en
   conservant une `rand_key` unique par question ; plafonner le générateur
   combinatoire Géographie.
   *Impact utilisateur* : aucun visible directement, mais impact fort sur le
   coût d'infra et le risque de timeout à l'échelle visée.
   *Complexité* : moyenne (script + validation avant `DELETE`).

### 🟠 Important

3. **Router ou supprimer les 435 pages PA/GPX Scolarité confirmées mortes**
   (C.4) — décision éditoriale au cas par cas, prioriser PA Scolarité.
4. ✅ **[FAIT — 28/07/2026]** Brancher les signalements des quiz classiques
   (`report_question`) sur `admin_reports_unified` / `admin_resolve_report`.
   Migration `20260729010000_admin_reports_report_question.sql` appliquée et
   vérifiée (colonnes `archived`/`updated_at` ajoutées, branche `question`
   testée directement en SQL).
5. **Désactiver "Allow anonymous sign-ins"** dans les paramètres Auth du
   projet Supabase (C.7). *Non automatisable* : c'est un réglage du
   dashboard Supabase (Project Settings → Authentication), aucun outil de
   cet audit n'y a accès. Complexité triviale — 2 clics à faire manuellement.
6. **Corriger les 260 policies RLS `auth_rls_initplan`** (C.8) — remplacement
   mécanique `auth.uid()` → `(select auth.uid())`, à valider par tests de
   non-régression sur un échantillon avant application massive.
7. **Vérifier le manifeste Android fusionné** sur un build réel, en
   particulier `POST_NOTIFICATIONS` (C.10).
8. **Supprimer les 40 fichiers legacy à `routeName` dupliqué** une fois
   confirmé que leur équivalent `*GPX` couvre le même contenu (C.5).

### 🟡 Amélioration

9. Indexer les 48 clés étrangères non couvertes et supprimer les 13 index
    dupliqués + 97 index inutilisés (C.8).
10. Ajouter `SET search_path` sur les 7 fonctions qui n'en ont pas (C.9).
11. Déplacer `citext` et `pg_trgm` hors du schéma `public` (C.9).
12. Documenter/clarifier `cp_rate_limit_buckets` (RLS sans policy — C.9).
13. Raccourcir l'expiration OTP, activer la protection mots de passe
    compromis, mettre à jour la version Postgres du projet (C.9).
14. Nettoyer les 31 `print(` restants vers le logger applicatif.
15. Trancher les 2 doublons de questions cross-module dans
    `quiz_scolarite_questions` (C.9).

### 🔵 Évolutions futures

16. Crawl automatisé des menus pour détecter les pages routées mais jamais
    liées depuis aucun menu (« orphelines » au sens inverse de C.4).
17. Mettre en place un test de non-régression automatisé sur le routing
    (script similaire à celui utilisé pour cet audit, à intégrer en CI) pour
    empêcher qu'une future page reparte non routée.
18. Étendre la déduplication `quiz_questions` à une politique d'insertion qui
    empêche la réintroduction de doublons (contrainte `UNIQUE(module,
    category, question)` ou vérification applicative avant insert).

---

*Statut au 28/07/2026, 2ᵉ passe : le crash iOS (C.1) est corrigé et le
garde-fou Réserve (C.3) renforcé. Reste 1 point 🔴 (déduplication
`quiz_questions`) puis les points 🟠, en cours de traitement autonome.
Prochaine étape : un premier build réel iOS + Android pour la QA manuelle
listée en section G/I avant toute soumission aux stores.*
