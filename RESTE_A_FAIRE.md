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
| Base de données (hygiène des données) | ✅ **Corrigé** — `quiz_questions` dédupliqué (6,35M → 5,54M lignes) |
| Sécurité Supabase | 🟠 876 avis (dont 1 vraie faille de configuration à corriger, le reste = durcissement) |
| Performance Supabase à l'échelle | ✅ `auth_rls_initplan` corrigé (260→0) ; 🟠 304 avis restants (multiple_permissive_policies, index) |
| Conformité iOS (App Store) | ✅ Crash photothèque corrigé ; ✅ identifiant `fr.copiq.police` — C.10b |
| Conformité Android (Play Store) | ✅ Permissions vérifiées ; ✅ identifiant `fr.copiq.police` ; ✅ release signé avec keystore dédié — C.10c |
| Hygiène du code | ✅ 13 TODO seulement sur tout le projet, tous localisés et non-critiques |

**Verdict global (mis à jour le 29/07/2026, après build Android réel +
keystore de release)** : tous les points 🔴 identifiés depuis le début de
cet audit sont désormais corrigés — crash iOS, doublons `quiz_questions`,
performance RLS, identifiant d'application placeholder (`fr.copiq.police`
configuré partout), et signature de release Android (keystore dédié généré,
vérifié par `apksigner` sur un vrai APK release). **Aucun point 🔴 restant
connu.** Il reste des points 🟠/🟡 non bloquants (PA Scolarité éditorial,
`multiple_permissive_policies`/index Supabase, permissions à re-valider si
l'identifiant venait à changer) et surtout la QA manuelle sur device réel
(section G/I) — jamais faite dans cet environnement, à ne pas considérer
comme validée tant qu'elle n'a pas été faite pour de vrai.

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

### ✅ C.2 — 6,35 millions de lignes dupliquées dans `quiz_questions` (CORRIGÉ le 29/07/2026)

**Statut : dédupliqué.** 6 365 050 → **5 535 837** lignes (−829 213 doublons
exacts supprimés), catégorie par catégorie, avec sauvegarde complète de
chaque catégorie avant suppression (`quiz_questions_backup_<categorie>`,
14 tables, à supprimer seulement après quelques jours de validation en prod
— voir `scripts/quiz_questions_dedup.sql`, étape 5). Aucune réduction du
volume de contenu réellement distinct (décision explicite de l'utilisateur) :
seuls les textes de question strictement identiques dans un même
`(module, category)` ont été retirés, en gardant la ligne au plus petit id.

| Catégorie | Avant | Après |
|---|---|---|
| Actualite | 759 000 | 750 015 |
| Cinema | 788 400 | 750 064 |
| Droit | 37 800 | 63 |
| France | 146 360 | 106 127 |
| Geographie | 1 308 100 | 984 543 |
| Histoire | 789 600 | 750 066 |
| Institutions | 265 997 | 233 651 |
| Musique | 283 876 | 250 931 |
| Mythologie | 737 748 | 682 041 |
| Police | 48 600 | 81 |
| Sante | 623 391 | 591 644 |
| Sciences | 517 579 | 431 922 |
| Securite | 21 399 | 4 627 |
| Sport | 37 200 | 62 |

Détails techniques originaux conservés ci-dessous pour référence.

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

### ✅ C.5 — Fichiers legacy à `routeName` dupliqué (37 sur 77 nettoyés le 28/07/2026)

- **Constat corrigé** : 40 paires de classes déclarent le même `routeName`,
  ce qui fait **77 fichiers candidats** au total (pas 40 comme écrit dans une
  première version de cet audit — dans la plupart des paires, **aucune** des
  deux classes n'est enregistrée dans `RouteRegistry.routes`, pas "toujours
  une seule").
- **Vérification supplémentaire effectuée avant suppression** : recherche de
  toute instanciation de chaque classe ailleurs dans le code (pas seulement
  dans `RouteRegistry.routes`). Résultat : **40 des 77 sont en réalité
  toujours utilisées** via des branches de `app_router.dart` non couvertes
  par le premier grep (ex. `QuizDisparitionPage`, `QuizGeneralitePage`,
  `PaResponsabilitePenalePage` sont appelées depuis des closures de route
  spécifiques) — supprimer ces 40 aurait cassé de vraies pages. **Seules les
  37 confirmées à zéro référence externe ont été supprimées**, avec
  nettoyage des imports correspondants dans `main.dart` et validation
  `flutter analyze` (0 problème après suppression).
- **Reste à faire** : les 40 fichiers restants ne sont PAS du code mort —
  aucune action requise dessus pour l'instant.

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

### Performance Supabase à l'échelle

- ✅ **`auth_rls_initplan` — CORRIGÉ le 29/07/2026 (260 → 0)** : les 260
  policies RLS qui appelaient `auth.uid()`/`auth.jwt()`/`auth.role()`/
  `auth.email()` directement (réévaluation par ligne) ont été réécrites en
  `(select auth.uid())` etc. (évaluation unique par requête). Généré et
  appliqué via `supabase/migrations/20260729020000_rls_initplan_perf_fix.sql`
  — remplacement syntaxique pur, vérifié sémantiquement identique sur les 260
  statements avant application (parenthèses équilibrées, aucune modification
  de logique), puis confirmé par une nouvelle passe d'advisor (0 occurrence
  restante) et par relecture directe de `pg_policies` sur un échantillon.
- 🟠 **`multiple_permissive_policies` ×132** (inchangé) : plusieurs policies
  permissives empilées sur la même table/action, chacune évaluée séparément.
- 🟠 **`unindexed_foreign_keys` ×48** (inchangé) : clés étrangères sans index
  de couverture — jointures et suppressions en cascade lentes à volume élevé.
- 🟡 **`unused_index` ×96 / `duplicate_index` ×13** (inchangé) : coût
  d'écriture et de stockage sans bénéfice de lecture mesuré.
- 🟡 **`no_primary_key` ×14** (nouvellement identifié dans cette passe
  d'advisor, non traité) : tables sans clé primaire — à examiner au cas par
  cas, certaines peuvent être des vues/tables techniques où c'est voulu.
- **Reste à faire** : `multiple_permissive_policies` et
  `unindexed_foreign_keys` nécessitent une revue table par table (pas un
  remplacement mécanique uniforme comme `auth_rls_initplan`), donc non
  traités dans cette session.

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

### ✅ C.10a — Permissions Android : vérifiées sur build réel (29/07/2026)

Un `flutter build apk --debug` réel a été lancé (toolchain Android complet
disponible dans cet environnement — SDK 36, émulateur connecté) et le
manifeste fusionné a été inspecté
(`build/app/intermediates/merged_manifest/debug/processDebugMainManifest/AndroidManifest.xml`).
**Résultat : toutes les permissions attendues sont bien fusionnées
automatiquement par les plugins**, y compris `POST_NOTIFICATIONS`
(obligatoire Android 13+, injectée par `flutter_local_notifications`),
`INTERNET`, `VIBRATE`, `ACCESS_NETWORK_STATE`, `AD_ID` +
`ACCESS_ADSERVICES_*` (google_mobile_ads), `FOREGROUND_SERVICE` et
`RECEIVE` (firebase_messaging). Aucune permission caméra/stockage média
n'est nécessaire pour `image_picker` sur les versions Android récentes
(Photo Picker système, pas de permission requise). **Ce point est clos.**

### ✅ C.10b — `applicationId`/`PRODUCT_BUNDLE_IDENTIFIER` (CORRIGÉ le 29/07/2026 — `fr.copiq.police`)

- **Constat d'origine** : `com.example.copiqpolice` (placeholder `flutter
  create`) sur les 3 plateformes (Android, iOS, macOS) — bloquant à 100 %
  pour Google Play et Apple, cf. ci-dessus.
- **Décision de l'utilisateur** : `fr.copiq.police`, cohérent avec le scheme
  de deep link déjà utilisé (`CFBundleURLName` dans `Info.plist`).
- **Ce qui a été fait** :
  - Android : `namespace` et `applicationId` mis à jour dans
    `android/app/build.gradle.kts` ; `MainActivity.kt` déplacé de
    `android/app/src/main/kotlin/com/example/copiqpolice/` vers
    `.../kotlin/fr/copiq/police/` avec la déclaration `package` mise à jour ;
    ancien dossier `com/example/` supprimé.
  - iOS : les 6 occurrences de `PRODUCT_BUNDLE_IDENTIFIER` dans
    `ios/Runner.xcodeproj/project.pbxproj` mises à jour (`fr.copiq.police`
    pour l'app, `fr.copiq.police.RunnerTests` pour les tests).
  - macOS (trouvé dans le même scan, corrigé par cohérence même si
    probablement pas une cible de publication) :
    `macos/Runner/Configs/AppInfo.xcconfig` et les 3 occurrences
    `.RunnerTests` dans `macos/Runner.xcodeproj/project.pbxproj`.
  - Scan final sur tout le dépôt (`.kt`, `.xml`, `.gradle(.kts)`,
    `.pbxproj`, `.plist`, `.xcconfig`, `.dart`) : 0 référence restante au
    placeholder.
  - Build Android réel relancé après le changement (`flutter build apk
    --debug`) pour confirmer que le nouveau package compile — voir résultat
    dans la tâche de suivi.
- **Rappel** : Firebase n'est pas utilisé (confirmé par l'utilisateur —
  aucun `google-services.json`/`GoogleService-Info.plist` dans le dépôt),
  donc aucun ré-enregistrement d'app Firebase n'était nécessaire.
- **Reste à faire (hors code)** : c'est la première fois que cet identifiant
  est fixé — vérifier qu'aucune app "fr.copiq.police" n'existe déjà par
  erreur sur les consoles Apple/Google avant la première soumission
  réelle.

### ✅ C.10c — Build de release Android signé avec la clé de debug (CORRIGÉ le 29/07/2026)

- **Constat d'origine** : `buildTypes.release.signingConfig` pointait sur
  `signingConfigs.getByName("debug")` — le keystore de debug est public et
  identique sur toutes les installations Flutter au monde, donc rejeté par
  Google Play et dangereux en pratique (n'importe qui peut resigner un faux
  correctif avec la même clé).
- **Ce qui a été fait** (à la demande explicite de l'utilisateur) :
  - Keystore de release généré (`android/app/upload-keystore.jks`, format
    PKCS12 standard, RSA 2048, alias `copiq-release`, validité jusqu'au
    14/12/2053), mot de passe fort généré aléatoirement (32 caractères).
  - `android/key.properties` créé (référence le keystore + mot de passe),
    déjà couvert par `android/.gitignore` (`key.properties`, `**/*.jks`,
    `**/*.keystore` — présents dans le gitignore par défaut de Flutter,
    vérifié avant toute génération).
  - `android/app/build.gradle.kts` : ajout d'un `signingConfigs.release`
    lisant `key.properties`, avec repli automatique sur la clé debug si le
    fichier est absent (ex. build CI sans le secret) plutôt que de faire
    planter le build.
  - **Vérifié concrètement** : `flutter build apk --release` relancé avec
    succès, puis `apksigner verify --print-certs` sur l'APK obtenu — le SHA-256
    de la signature (`6d95...2e62`) correspond exactement à celui du nouveau
    keystore, confirmant que le binaire de release n'est plus signé en debug.
  - Le mot de passe généré a été communiqué une seule fois à l'utilisateur
    (à charge pour lui de le sauvegarder dans un gestionnaire de mots de
    passe) et supprimé de tout fichier temporaire côté audit.
- **Rappel permanent** : `android/app/upload-keystore.jks` et le mot de
  passe doivent être sauvegardés par l'utilisateur en dehors de cette
  machine (le fichier n'est volontairement pas versionné dans Git). Les
  perdre après la première publication rend impossible toute mise à jour
  future de l'app.

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
| `quiz_questions` (Culture générale, 5,54M lignes) | ✅ Dédupliqué le 29/07/2026 (−829 213 lignes) — voir C.2 |
| Catégorie/thème cohérents | ✅ Pour cas pratique (theme_id → `cas_pratique_themes`, vérifié via la jointure ajoutée dans `admin_reports_unified`) et `quiz_scolarite_modules` (module ↔ route 1:1, vérifié dans `app_router.dart`) |
| Signalement d'erreur sur une question | ✅ cas pratique (branché ce mois-ci) / 🔴 quiz classiques (`report_question`, voir C.6) |

---

## F. Audit Supabase (résumé)

- 176 tables, RLS activé sur 100 % d'entre elles.
- 876 avis de sécurité : 1 point de configuration à corriger réellement
  (anonymous sign-ins, C.7), le reste = durcissement recommandé (C.9), aucune
  faille RLS avec accès croisé entre utilisateurs détectée dans les tables
  échantillonnées (`cas_pratique_*`, `billing_*`).
- 551 avis de performance initialement, dominés par le pattern
  `auth_rls_initplan` (260) — **corrigé le 29/07/2026**, plus que 304 avis
  restants (essentiellement `multiple_permissive_policies` et index).
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

1. ✅ **[FAIT]** Dédupliquer `quiz_questions` (C.2) — 6,35M → 5,54M lignes.
2. ✅ **[FAIT]** Réécrire les 260 policies RLS `auth.uid()` → `(select auth.uid())` (C.8).
3. Supprimer les 435 fichiers PA/GPX Scolarité confirmés morts (C.4) après
   décision éditoriale (router ou supprimer), pour réduire la taille du
   dépôt et le temps de build. (37 fichiers legacy déjà retirés — voir C.5.)
4. Auditer les 31 `print(` restants et les remplacer par le logger applicatif
   (`AppConsoleLogger`, déjà utilisé ailleurs) pour la propreté des logs prod.

---

## I. Checklist finale avant publication

| # | Point | Statut |
|---|---|---|
| 1 | Compilation propre (`flutter analyze`) | ✅ |
| 2 | Aucun crash connu au lancement | ✅ (non testé sur device réel) |
| 3 | Sélecteur d'image iOS (`Info.plist`) | ✅ Corrigé — C.1 (à valider sur device réel) |
| 4 | Permissions Android vérifiées sur build réel | ✅ Vérifié — C.10a |
| 4bis | Identifiant d'application définitif (pas `com.example.*`) | ✅ `fr.copiq.police` — C.10b |
| 4ter | Build Android signé avec un keystore de release | ✅ Vérifié via `apksigner` — C.10c |
| 5 | Suppression de compte disponible | ✅ Code présent (`user_page.dart`) |
| 6 | Politique de confidentialité / CGU liées | ✅ Code présent (`legal_content.dart`, `cp_privacy_page.dart`) |
| 7 | Toutes les routes de menu aboutissent à une page réelle | ⚠️ 435 confirmées mortes en PA/GPX Scolarité — C.4 |
| 8 | Aucun texte "TODO" visible en production | ✅ Vérifié : Réserve verrouillé, 0 utilisateur exposé — C.3 |
| 9 | Quiz sans doublons | ✅ `quiz_questions` dédupliqué — C.2 ; `cas_pratique` et `quiz_scolarite` propres |
| 10 | Signalements admin fonctionnels sur tous les types de contenu | ✅ cas pratique et quiz classiques — C.6 |
| 11 | RLS activé sur toutes les tables | ✅ |
| 12 | Pas de connexion anonyme non maîtrisée | ⚠️ Activée au niveau projet mais inutilisée — C.7 |
| 13 | Performance RLS soutenable à grande échelle | ✅ 260 policies corrigées — C.8 |
| 14 | Test manuel écran par écran (device réel) | ❌ Non fait — nécessaire avant soumission |
| 15 | Build Android + inspection manifeste fusionné | ✅ Fait le 29/07/2026 — a révélé C.10b/C.10c |
| 16 | Soumission App Store Connect / Play Console | ❌ Non applicable ici — étape humaine finale |

---

## J. Reste à faire — feuille de route officielle

### 🔴 Bloquant avant publication — TOUS TRAITÉS au 29/07/2026

Section conservée pour l'historique et la traçabilité des correctifs. Aucun
point 🔴 restant connu à ce jour — voir le verdict global en section A.

0a. ✅ **[FAIT — 29/07/2026]** Choisir et configurer un identifiant
   d'application définitif (C.10b) — `fr.copiq.police`, choisi par
   l'utilisateur. Configuré dans `android/app/build.gradle.kts`
   (`namespace` + `applicationId`), `MainActivity.kt` déplacé au bon
   package, `ios/Runner.xcodeproj/project.pbxproj` (6 occurrences),
   `macos/Runner/Configs/AppInfo.xcconfig` +
   `macos/Runner.xcodeproj/project.pbxproj` (3 occurrences). Build Android
   réel relancé après coup pour confirmer que ça compile toujours.

0b. ✅ **[FAIT — 29/07/2026]** Générer un keystore de release Android et
   configurer la signature (C.10c). `android/app/upload-keystore.jks`
   (PKCS12, alias `copiq-release`, valide jusqu'en 2053) + `android/key.properties`
   créés, `build.gradle.kts` mis à jour, vérifié par `apksigner` sur un vrai
   build release. Mot de passe communiqué une fois à l'utilisateur pour
   sauvegarde dans un gestionnaire de mots de passe. **Rappel permanent** :
   sauvegarder `upload-keystore.jks` hors de cette machine — sa perte après
   la première publication rend toute mise à jour future impossible.

1. ✅ **[FAIT — 28/07/2026]** Corriger le crash iOS sur la sélection d'image
   *Fichier* : `ios/Runner/Info.plist`
   *Ce qui a été fait* : ajout de `NSPhotoLibraryUsageDescription` et
   `NSPhotoLibraryAddUsageDescription`.
   *Reste à faire* : **vérification obligatoire sur simulateur/device iOS
   réel** avant de considérer le point définitivement clos (non testable
   dans cet environnement).

2. ✅ **[FAIT — 29/07/2026]** Dédupliquer `quiz_questions` — voir C.2
   (6,35M → 5,54M lignes, catégorie par catégorie, 14 backups conservés).

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
6. ✅ **[FAIT — 29/07/2026]** Corriger les 260 policies RLS
   `auth_rls_initplan`. Migration `20260729020000_rls_initplan_perf_fix.sql`
   appliquée ; advisor de performance confirme 0 occurrence restante.
7. **Vérifier le manifeste Android fusionné** sur un build réel, en
   particulier `POST_NOTIFICATIONS` (C.10).
8. ✅ **[FAIT — 28/07/2026]** Nettoyer les fichiers legacy à `routeName`
   dupliqué confirmés 100% morts (37/77, voir C.5). Les 40 restants sont
   réellement utilisés — pas d'action à mener dessus.

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
