# COP'IQ — Audit final avant publication (28 juillet 2026, révisé le 30/07)

**Méthode** : chaque ligne de ce document est issue d'une vérification réelle —
lecture de code, requête SQL exécutée sur la base de production, sortie de
`flutter analyze`, ou lecture des manifestes `AndroidManifest.xml` /
`Info.plist`. Rien n'est estimé ni supposé. Ce document **remplace** la
version du 26/07/2026.

**Dernière mise à jour : 31/07/2026** — optimisations Supabase sûres,
normalisation des quiz, suppression des sauvegardes temporaires, nettoyage des
logs et ajout des tests automatisés de routes. La refonte des
cas pratiques puis des 212 quiz de l'application (section K). C'est la première
session menée **avec un appareil réel sous les yeux** : plusieurs anomalies que
les audits précédents ne pouvaient pas voir — la section G le disait
explicitement — ont été trouvées et corrigées à cette occasion.

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
| Compilation / lint (`flutter analyze`) | ✅ **0 problème** — relancé le 31/07 après les nettoyages |
| Rendu visuel sur appareil réel | 🟠 Première session de test réel le 30/07 (cas pratiques + quiz culture générale). 9 anomalies visuelles trouvées et corrigées — K.1 à K.3. Les autres écrans restent non testés |
| Routing (boutons → pages) | ✅ 0 route de menu cassée (vérifié exhaustivement sur PA Scolarité) ; ~359 fichiers `.dart` inutilisés = code mort, pas un trou de contenu — C.4 |
| Contenu GPX Exam / GPX Scolarité | ✅ Fonctionnellement complet, routé, quiz alimentés |
| Contenu PA Exam | ✅ Fonctionnellement complet |
| Contenu PA Scolarité | ✅ Fonctionnellement complet — sujets partagés avec GPX Scolarité via redirection active, 0 sujet inaccessible (rectifié le 29/07, voir C.4) |
| Contenu Réserve | ✅ Contenu inachevé mais correctement verrouillé (0 utilisateur exposé, défense en profondeur ajoutée) |
| Base de données (structure) | ✅ 176 tables, RLS activé partout, cas pratique et signalements sains |
| Base de données (hygiène des données) | ✅ **Corrigé** — `quiz_questions` dédupliqué (6,35M → 5,54M lignes) |
| Sécurité Supabase | ✅ Connexions anonymes désactivées ; `search_path` et vue admin durcis. 689 avis de durcissement restent |
| Performance Supabase à l'échelle | ✅ `auth_rls_initplan` 260→0 ; FK sans index 48→0 ; index dupliqués 13→0 |
| Conformité iOS (App Store) | ✅ Crash photothèque corrigé ; ✅ identifiant Apple enregistré `fr.copiq.app` — C.10b |
| Conformité Android (Play Store) | ✅ Permissions vérifiées ; ✅ identifiant `fr.copiq.app` ; ✅ release signé avec keystore dédié — C.10c |
| Hygiène du code | ✅ 13 TODO seulement sur tout le projet, tous localisés et non-critiques |

**Verdict global (mis à jour le 29/07/2026, après build Android réel +
keystore de release)** : tous les points 🔴 identifiés depuis le début de
cet audit sont désormais corrigés — crash iOS, doublons `quiz_questions`,
performance RLS, identifiant d'application définitif (`fr.copiq.app`
configuré partout), et signature de release Android (keystore dédié généré,
vérifié par `apksigner` sur un vrai APK release). **Aucun point 🔴 restant
connu.** Il reste des points 🟠/🟡 non bloquants (nettoyage de code mort
PA Scolarité — 0 impact utilisateur, rectifié le 29/07 après signalement de
l'utilisateur, voir C.4 — `multiple_permissive_policies`/index Supabase,
permissions à re-valider si
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

### 🟠 « Mon suivi » — Concours Policier Adjoint (codé le 01/08/2026)

- ✅ Onglet Journal remplacé localement par **Mon suivi** avec score pondéré,
  objectif quotidien personnalisable, streak, calendrier sur 28 jours,
  évolution 7/30 jours, progression par matière, recommandation explicable,
  positionnement séparé, erreurs détaillées et historique triable.
- ✅ Sources strictes : `quiz_history` (`track='pa'`, `mode='exam'`),
  `tests_psychotechnique_history` (`module='pa_psychotechnique'`,
  `mode='concours'`) et photolangage explicitement PA Exam. Les réponses
  individuelles ne sont jamais comptées comme des sessions.
- ✅ Incohérences de quatre noms de tables Culture générale corrigées dans le
  code ; `history_id` est désormais envoyé par les QCM PA disposant d'une
  session canonique.
- ✅ 12 tests ciblés réussis (calculs + états UI + largeur 320 px) et analyse
  Flutter sans erreur sur le périmètre.
- 🟠 **À appliquer après autorisation explicite** : migration
  `20260801030000_pa_exam_progress_answer_history.sql`. Elle crée l'historique
  canonique des réponses, active une RLS propriétaire, reprend uniquement les
  anciennes réponses explicitement `exam_type='pa'`, harmonise les tables
  historiques et ajoute les discriminants PA Exam au photolangage. La
  protection d'exécution a refusé son application automatique en production ;
  tant qu'elle n'est pas appliquée, la page fonctionne avec les sessions
  principales mais affiche les détails secondaires comme indisponibles.
- 🟠 Après application : exécuter les advisors Supabase, vérifier une insertion
  réelle Culture générale/psychotechnique, puis effectuer la QA visuelle sur
  simulateur et appareil réel.

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
14 tables, supprimées le 31/07 après validation en production
— voir `scripts/quiz_questions_dedup.sql`, étape 5). Aucune réduction du
volume de contenu réellement distinct (décision explicite de l'utilisateur) :
seuls les textes de question strictement identiques dans un même
`(module, category)` ont été retirés, en gardant la ligne au plus petit id.

**Correctif du 30/07/2026** : l'auditeur de sécurité Supabase a signalé que
ces 14 tables de sauvegarde avaient RLS désactivé — lisibles/modifiables par
n'importe qui possédant la clé publique de l'app. RLS activé sans policy
(migration `20260730020000_enable_rls_quiz_backups.sql`) : accès client
totalement bloqué, accès dashboard/service_role inchangé. **Fait le 31/07** :
les 14 tables ont été supprimées après vérification des volumes par catégorie,
de l'index unique `(module, category, question)` et de l'absence de régression.

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
  (`reserve_introduction_page.dart` et les modules associés). Le code mort de
  navigation dans `grade_picker.dart` a été supprimé le 31/07.

### 🟡 C.4 — ~359 fichiers PA Scolarité non utilisés (CORRIGÉ/RECTIFIÉ le 29/07/2026 — 0 impact utilisateur confirmé)

- **Erreur de mon audit initial, corrigée après un signalement de
  l'utilisateur** ("normalement ils sont accessibles car quand je suis sur
  mon émulateur ça fonctionne") : j'avais présenté ces ~359 fichiers comme
  "pages inaccessibles" / "contenu manquant", en confondant deux choses
  différentes — l'existence de code mort (vrai) et l'inaccessibilité du
  contenu pour l'utilisateur (faux).
- **Ce qui se passe réellement**, vérifié dans
  `lib/features/home/home_page_pa_school.dart` : la plupart des sujets PA
  Scolarité sont **volontairement identiques** au contenu GPX Scolarité
  (droit pénal général, sanctions, atteintes aux personnes/biens,
  armes...). Le menu PA utilise une table de redirection active
  (`redirectConfigPaSchool`, consultée dans `_openRouteOrDetails` à chaque
  tap) qui bascule silencieusement vers la page GPX déjà écrite et routée,
  au lieu d'utiliser une page PA dédiée. Les fichiers `pa_scolarite/**`
  correspondants existent mais ne sont simplement jamais appelés — **par
  design**, pas par bug.
- **Vérification exhaustive faite** : extraction des 170 routes réellement
  utilisées par le menu PA Scolarité (`route:` dans `CategoryConfig`/
  `SubCategoryConfig`), croisées avec `RouteRegistry.routes`. Résultat :
  **144 routées directement, 26 sont des en-têtes de catégorie** (ont des
  `subcategories:`, donc — vérifié dans `_openRouteOrDetails` — n'ouvrent
  jamais directement une page, juste une liste de sous-rubriques). **0
  route de menu réellement cassée.**
- **Ce qui reste vrai** : ~359 fichiers `pa_scolarite/**` (+ quelques-uns en
  GPX Scolarité legacy) sont du code mort au sens strict — jamais importés
  ni instanciés. C'est un point de propreté de code (poids du dépôt, temps
  de build), **pas un manque de contenu pour l'utilisateur**.
- **Gravité reclassée** : 🟡 Amélioration (nettoyage), plus 🟠/🔴.
- **Solution** : supprimer ces fichiers par lot une fois confirmé, dossier
  par dossier, qu'aucun n'est le seul point d'entrée d'un sujet réellement
  distinct du GPX (à vérifier au cas par cas avant suppression en masse,
  cette vérification round complète n'a été faite que pour le menu PA
  Scolarité principal, pas pour d'éventuels autres points d'entrée comme la
  recherche interne).

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

### ✅ C.7 — Connexions anonymes Supabase désactivées le 31/07/2026

- **Constat** : l'avis `auth_allow_anonymous_sign_ins` était remonté sur 183
  tables (dont `admin_users`, `admin_audit_logs`, `billing_*`). Vérifié par
  grep : **aucun appel** à `signInAnonymously()` n'existe dans tout le code
  Flutter — la fonctionnalité "connexions anonymes" est activée au niveau du
  projet Supabase (Auth settings) sans être utilisée par l'app.
- **Gravité** : Majeure en potentiel (élargit inutilement la surface
  d'attaque : n'importe qui peut appeler l'API Supabase directement, obtenir
  un `auth.uid()` anonyme valide, et tester les policies RLS qui vérifient
  seulement `auth.uid() IS NOT NULL` sans exclure `is_anonymous`), nulle en
  exploitation confirmée.
- **Correction** : "Allow anonymous sign-ins" désactivé dans Authentication →
  Sign In / Providers. L'advisor confirme `auth_allow_anonymous_sign_ins`
  **183→0**.

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
- ✅ **`unindexed_foreign_keys` — CORRIGÉ le 31/07 (48→0)** : index de
  couverture ajoutés sans modifier les contraintes ni les données.
- ✅ **`duplicate_index` — CORRIGÉ le 31/07 (13→0)** : seuls les index
  strictement identiques ont été retirés.
- 🟡 **`unused_index`** : conservés jusqu'à disposer d'un historique de trafic
  suffisant ; les supprimer immédiatement aurait été risqué.
- 🟡 **`no_primary_key` ×14** (nouvellement identifié dans cette passe
  d'advisor, non traité) : tables sans clé primaire — à examiner au cas par
  cas, certaines peuvent être des vues/tables techniques où c'est voulu.
- **Reste à faire** : `multiple_permissive_policies` nécessite une revue table
  par table ; une fusion mécanique pourrait modifier les droits effectifs.

### 🟡 C.9 — Divers durcissements Supabase mineurs

- ✅ `function_search_path_mutable` ×7 : corrigé le 31/07 sans modifier les
  corps de fonction.
- `extension_in_public` ×2 (`citext`, `pg_trgm`) : à déplacer hors du schéma
  `public` par convention de sécurité Supabase.
- `rls_enabled_no_policy` ×1 : `cp_rate_limit_buckets` a RLS activé sans
  aucune policy (bloque tout accès direct — probablement voulu puisque
  cette table n'est manipulée que par des fonctions `SECURITY DEFINER`, mais
  aucune policy explicite ne documente cette intention).
- ✅ `materialized_view_in_api` ×1 : accès `anon`/`authenticated` révoqué le
  31/07 ; les chemins privilégiés restent disponibles.
- `auth_otp_long_expiry`, `auth_leaked_password_protection`,
  `vulnerable_postgres_version` : recommandations standards Supabase
  (raccourcir l'expiration OTP, activer la protection mots de passe compromis
  via HaveIBeenPwned, mettre à jour la version Postgres du projet).
- ✅ Après dédoublonnage, 1 370 lignes de `quiz_questions.options` restaient
  double-encodées. Normalisées le 31/07 (1 370→0), puis protégées par une
  contrainte imposant un tableau JSON.
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

### ✅ C.10b — `applicationId`/`PRODUCT_BUNDLE_IDENTIFIER` (`fr.copiq.app`, aligné le 01/08/2026)

- **Constat d'origine** : `com.example.copiqpolice` (placeholder `flutter
  create`) sur les 3 plateformes (Android, iOS, macOS) — bloquant à 100 %
  pour Google Play et Apple, cf. ci-dessus.
- **Décision finale de l'utilisateur** : `fr.copiq.app`, identifiant déjà
  enregistré dans Apple Developer. Le schéma de deep link applicatif
  `copiqpolice://` reste inchangé.
- **Ce qui a été fait** :
  - Android : `namespace` et `applicationId` mis à jour dans
    `android/app/build.gradle.kts` ; `MainActivity.kt` déplacé de
    `android/app/src/main/kotlin/fr/copiq/police/` vers
    `.../kotlin/fr/copiq/app/` avec la déclaration `package` mise à jour.
  - iOS : les 6 occurrences de `PRODUCT_BUNDLE_IDENTIFIER` dans
    `ios/Runner.xcodeproj/project.pbxproj` mises à jour (`fr.copiq.app`
    pour l'app, `fr.copiq.app.RunnerTests` pour les tests).
    `CFBundleDisplayName` et `CFBundleName` valent désormais `COP'IQ`.
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
- **Vérification Apple faite le 01/08** : l'identifiant `fr.copiq.app` est
  enregistré dans le compte Apple Developer sous le nom COPIQ. Reste à
  associer/importer le premier bundle dans Google Play Console.

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
| Interface des 212 quiz (4 zones) | ✅ Refondue et homogénéisée le 30/07 — voir K |
| Énoncés qui répètent leurs propres réponses | 🟡 Contourné à l'affichage (K.3), **pas corrigé en base** — voir K.5 |
| `cas_pratique_cases` (516 cas / 1 544 questions) | ✅ 0 doublon de titre |
| `quiz_scolarite_questions` (180, 15 modules × 12) | ✅ Répartition homogène, seulement 2 doublons de texte cross-module (mineur) |
| `quiz_questions` (Culture générale, 5,54M lignes) | ✅ Dédupliqué le 29/07/2026 (−829 213 lignes) — voir C.2 |
| Catégorie/thème cohérents | ✅ Pour cas pratique (theme_id → `cas_pratique_themes`, vérifié via la jointure ajoutée dans `admin_reports_unified`) et `quiz_scolarite_modules` (module ↔ route 1:1, vérifié dans `app_router.dart`) |
| Signalement d'erreur sur une question | ✅ cas pratique (branché ce mois-ci) / 🔴 quiz classiques (`report_question`, voir C.6) |

---

## F. Audit Supabase (résumé)

- 176 tables, RLS activé sur 100 % d'entre elles.
- 689 avis de sécurité après désactivation des connexions anonymes et les
  durcissements du 31/07 ; le reste = durcissement recommandé (C.9), aucune
  faille RLS avec accès croisé entre utilisateurs détectée dans les tables
  échantillonnées (`cas_pratique_*`, `billing_*`).
- 551 avis de performance initialement, dominés par le pattern
  `auth_rls_initplan` (260) — **corrigé le 29/07/2026**. Passe du 31/07 :
  `unindexed_foreign_keys` 48→0 et `duplicate_index` 13→0 ; les policies
  superposées et index sans usage mesuré restent à examiner prudemment.
- Aucune fuite d'admin détectée : les RPC admin vérifient toutes
  `has_admin_permission(...)` avant d'agir (vérifié sur
  `admin_reports_unified`, `admin_resolve_report`).

---

## G. Audit UX/UI

**Partiellement réalisé le 30/07/2026** — première session sur appareil Android
réel, écrans « Cas pratiques » et « Quiz culture générale » uniquement.

Ce que cette session a démontré : l'avertissement ci-dessous était fondé. Neuf
anomalies visuelles ou fonctionnelles ont été trouvées **en regardant l'app
tourner**, dont deux qui empêchaient purement et simplement l'affichage du
contenu (assertion de rendu, cartes vides) et une qui gelait l'application. Aucun
audit statique ne les avait vues. Détail en section K.

**Reste non testé** : tout le reste de l'application (PA Exam, PA Scolarité,
GPX Scolarité hors quiz, panel admin, parcours d'abonnement), iOS dans son
intégralité, le thème clair sur appareil réel, le paysage sur tablette
(l'app déclare le supporter sur iPad dans `Info.plist`), et le comportement au
clavier. Ne pas interpréter l'absence de mention comme une validation.

---

## H. Optimisations recommandées (hors bugs bloquants)

1. ✅ **[FAIT]** Dédupliquer `quiz_questions` (C.2) — 6,35M → 5,54M lignes.
2. ✅ **[FAIT]** Réécrire les 260 policies RLS `auth.uid()` → `(select auth.uid())` (C.8).
3. Supprimer les 435 fichiers PA/GPX Scolarité confirmés morts (C.4) après
   décision éditoriale (router ou supprimer), pour réduire la taille du
   dépôt et le temps de build. (37 fichiers legacy déjà retirés — voir C.5.)
4. ✅ **[FAIT — 31/07]** Les 30 appels `print(` applicatifs sont remplacés par
   `debugPrint`. Seule l'implémentation interne de `AppConsoleLogger` conserve
   volontairement un `print`.

---

## I. Checklist finale avant publication

| # | Point | Statut |
|---|---|---|
| 1 | Compilation propre (`flutter analyze`) | ✅ 0 problème le 31/07 |
| 2 | Aucun crash connu au lancement | ✅ (non testé sur device réel) |
| 3 | Sélecteur d'image iOS (`Info.plist`) | ✅ Corrigé — C.1 (à valider sur device réel) |
| 4 | Permissions Android vérifiées sur build réel | ✅ Vérifié — C.10a |
| 4bis | Identifiant d'application définitif (pas `com.example.*`) | ✅ `fr.copiq.app` — C.10b |
| 4ter | Build Android signé avec un keystore de release | ✅ Vérifié via `apksigner` — C.10c |
| 5 | Suppression de compte disponible | ✅ Code présent (`user_page.dart`) |
| 6 | Politique de confidentialité / CGU liées | ✅ Code présent (`legal_content.dart`, `cp_privacy_page.dart`) |
| 7 | Toutes les routes de menu aboutissent à une page réelle | ✅ Vérifié exhaustivement sur le menu PA Scolarité (144 directes + 26 en-têtes de catégorie, 0 cassée) — C.4 |
| 8 | Aucun texte "TODO" visible en production | ✅ Vérifié : Réserve verrouillé, 0 utilisateur exposé — C.3 |
| 9 | Quiz sans doublons | ✅ `quiz_questions` dédupliqué — C.2 ; `cas_pratique` et `quiz_scolarite` propres |
| 10 | Signalements admin fonctionnels sur tous les types de contenu | ✅ cas pratique et quiz classiques — C.6 |
| 11 | RLS activé sur toutes les tables | ✅ |
| 12 | Pas de connexion anonyme non maîtrisée | ✅ Désactivée et confirmée par l'advisor — C.7 |
| 13 | Performance RLS soutenable à grande échelle | ✅ 260 policies corrigées — C.8 |
| 14 | Test manuel écran par écran (device réel) | 🟠 Partiel — cas pratiques et quiz culture générale testés le 30/07 sur Android (9 anomalies trouvées, K.1-K.3). Tout le reste, et iOS en entier, non testé |
| 14bis | Quiz propagés vérifiés à l'écran (2 thèmes) | ❌ Non fait — 211 des 212 fichiers n'ont été validés que **statiquement** (équilibrage, appels, cycles de vie). Priorité après le point 1 |
| 15 | Build Android + inspection manifeste fusionné | ✅ Fait le 29/07/2026 — a révélé C.10b/C.10c |
| 16 | Soumission App Store Connect / Play Console | ❌ Non applicable ici — étape humaine finale |

---

## J. Reste à faire — feuille de route officielle

### 🔴 Bloquant avant publication — TOUS TRAITÉS au 29/07/2026

Section conservée pour l'historique et la traçabilité des correctifs. Aucun
point 🔴 restant connu à ce jour — voir le verdict global en section A.

0a. ✅ **[FAIT — 29/07/2026]** Choisir et configurer un identifiant
   d'application définitif (C.10b) — `fr.copiq.app`, aligné le 01/08 sur
   l'identifiant Apple existant. Configuré dans `android/app/build.gradle.kts`
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
   (6,35M → 5,54M lignes, catégorie par catégorie). Les 14 backups ont été
   validés puis supprimés le 31/07/2026.

### 🟠 Important

4. ✅ **[FAIT — 28/07/2026]** Brancher les signalements des quiz classiques
   (`report_question`) sur `admin_reports_unified` / `admin_resolve_report`.
   Migration `20260729010000_admin_reports_report_question.sql` appliquée et
   vérifiée (colonnes `archived`/`updated_at` ajoutées, branche `question`
   testée directement en SQL).
5. ✅ **[FAIT — 31/07/2026]** Désactiver "Allow anonymous sign-ins".
   Advisor : `auth_allow_anonymous_sign_ins` 183→0.
6. ✅ **[FAIT — 29/07/2026]** Corriger les 260 policies RLS
   `auth_rls_initplan`. Migration `20260729020000_rls_initplan_perf_fix.sql`
   appliquée ; advisor de performance confirme 0 occurrence restante.
7. ✅ **[FAIT — 29/07/2026]** Vérifier le manifeste Android fusionné sur un
   build réel (C.10a) — `POST_NOTIFICATIONS` et toutes les permissions
   attendues confirmées présentes.
8. ✅ **[FAIT — 28/07/2026]** Nettoyer les fichiers legacy à `routeName`
   dupliqué confirmés 100% morts (37/77, voir C.5). Les 40 restants sont
   réellement utilisés — pas d'action à mener dessus.

### 🟡 Amélioration

9. ✅ **[FAIT — 31/07]** Indexer les 48 clés étrangères et supprimer les 13
    index strictement dupliqués. Les index seulement marqués « inutilisés »
    restent conservés jusqu'à disposer d'un historique fiable.
10. ✅ **[FAIT — 31/07]** Ajouter `SET search_path` sur les 7 fonctions.
11. Déplacer `citext` et `pg_trgm` hors du schéma `public` (C.9).
12. Documenter/clarifier `cp_rate_limit_buckets` (RLS sans policy — C.9).
13. Raccourcir l'expiration OTP, activer la protection mots de passe
    compromis, mettre à jour la version Postgres du projet (C.9).
14. ✅ **[FAIT — 31/07]** Nettoyer les 30 `print(` applicatifs ; seul le
    backend interne de `AppConsoleLogger` conserve volontairement `print`.
15. Trancher les 2 doublons de questions cross-module dans
    `quiz_scolarite_questions` (C.9).
16. **Nettoyer les ~359 fichiers PA Scolarité confirmés inutilisés** (C.4,
    rectifié le 29/07/2026 — 0 impact utilisateur, contenu servi via
    redirection vers l'équivalent GPX déjà routé). Vérifier au cas par cas
    avant suppression en masse qu'aucun n'est un point d'entrée non couvert
    par l'audit du menu principal (recherche interne notamment, non
    vérifiée).

### ✅ C.11 — Câblage du menu PA Scolarité : 5 catégories entières ajoutées (FAIT le 29/07/2026)

Suite à un audit exhaustif du module `dpsDpg` (85 topics GPX comparés au menu
PA live, cf. `scripts/_dpsdpg_full_audit.md`), la quasi-totalité du contenu
manquant côté PA existait déjà en fichier mais n'était reliée à aucun menu
(pur travail de câblage, pas de rédaction). Traité dans cette session :

- 3 des 9 pages "Généralités" pointent maintenant vers leur vrai contenu PA
  dédié au lieu du contenu GPX partagé (Classification des infractions,
  L'infraction, La tentative). Les 5 restantes n'ont pas d'équivalent PA
  "Contenu" trouvé et restent sur le contenu GPX partagé (non régressif).
- **Armes & munitions** (8 pages + 1 quiz) — catégorie créée.
- **La sanction** (3 pages + 1 quiz) — catégorie créée.
- **Crimes & délits contre la nation** (6 pages + 5 quiz) — catégorie créée.
- **Atteintes aux mineurs & à la famille** (4 pages + 1 quiz) — catégorie
  créée.
- **Procédure Pénale** (4 pages + 4 quiz) — catégorie créée.
- Vérifié au passage : "Cadres juridiques" (9 sujets) et la granularité de
  "Circulation routière" (ivresse / état alcoolique / défaut d'assurance /
  refus de vérifications comme 4 pages distinctes, pas 1 page bundlée)
  étaient en réalité déjà câblés — l'audit initial les avait signalés à tort
  comme manquants ou groupés.
- **Vérification finale par script** (résout les `routeName` symboliques,
  pas seulement les chaînes littérales) : sur les **181 routes `/pa/...`**
  navigables depuis le menu PA Scolarité, **0 route cassée**. `flutter
  analyze` : 0 problème après chaque lot.

**Reste à faire (non bloquant)** :
- Réconcilier la catégorie "Crimes & délits contre la personne" : les
  libellés PA et GPX ne correspondent pas 1:1 (PA a des rubriques
  supplémentaires — discriminations, harcèlement sexuel... — et regroupe
  autrement viol/agressions). Nécessite une comparaison manuelle
  sujet-par-sujet avant tout remaniement, pas fait dans cette session.
- Les 66 quiz PA mentionnés dans l'audit initial comme "non câblés" sont en
  réalité très majoritairement déjà câblés en route (117 routes
  `/pa/.../quiz/...` recensées) — seule une minorité restait à exposer dans
  un menu, ce qui a été fait pour les 5 catégories ci-dessus. Pas
  d'inventaire exhaustif restant fait de tous les quiz PA existants vs
  menus.

### 🔵 Évolutions futures

20. **Chrono d'épreuve persistant** (K.1) — le compte à rebours des cas
    pratiques vit en mémoire : si l'app est tuée en pleine épreuve, il repart
    à zéro au retour. Le rendre incassable demande de stocker l'échéance sur
    la ligne `attempt` en base et de la relire au montage.
21. **Sous-libellé des niveaux de difficulté** (K.2) — les cartes Facile /
    Moyen / Difficile mesurent 112 px pour afficher une icône et un mot. Une
    seconde ligne (« Notions de base », « Le niveau du concours », « Pièges et
    détails ») justifierait cette hauteur et dirait à l'utilisateur ce qu'il
    choisit. Proposé, non réalisé.
22. **Détail chiffré du dialogue de sortie** — dans les 211 quiz propagés, le
    message est générique (« Tes réponses déjà validées sont enregistrées »).
    Seul `quiz_culture_generale_france.dart` affiche le compte exact, la
    famille allégée stockant ses réponses dans une liste et non une map.

17. ✅ **[FAIT — 31/07]** Test automatisé des menus principaux GPX/PA et des
    redirections PA Scolarité. Il a détecté puis permis de corriger les
    redirections qui n'étaient pas appliquées aux sous-rubriques. Le crawl de
    la recherche interne reste une amélioration distincte.
18. ✅ **[FAIT — 31/07]** Test de non-régression ajouté dans
    `test/core/menu_routes_test.dart` ; suite complète : **111 tests réussis**.
19. Étendre la déduplication `quiz_questions` à une politique d'insertion qui
    empêche la réintroduction de doublons (contrainte `UNIQUE(module,
    category, question)` ou vérification applicative avant insert).

---

## K. Session du 30/07/2026 — cas pratiques et refonte des 212 quiz

Première session menée sur appareil Android réel. Les anomalies ci-dessous ont
toutes été constatées à l'écran, pas déduites du code.

### ✅ K.1 — Cas pratiques : 6 correctifs

**Cartes de la liste invisibles** — assertion `A borderRadius can only be given
on borders with uniform colors` levée pendant `paint()`, à chaque frame. La
`BoxDecoration` combinait un `Border` non uniforme (liseré gauche opaque de 5 px,
trois autres côtés à 30 % d'opacité) avec un `borderRadius`. Flutter interrompait
le rendu : les cartes s'affichaient vides, seul le fond était peint. Corrigé par
un `Border.all` uniforme, le liseré passant dans un `Stack`.

**Bouton « Retour » inerte à l'ouverture d'un cas** — `showBack` valait
`_index > 0`, or sur la page d'intro il n'existe pas de page précédente : le
bouton était rendu désactivé. Séparé en deux intentions, reculer dans le
`PageView` ou quitter vers la liste.

**Bouton « Retour » définitivement mort sur la liste** — piège plus ancien,
révélé par la suppression de rebuilds parasites. `onTap: _navBusy ? () {} :
_goBack` lisait un état de navigation **dans `build`**, et `_navBusy` restait
vrai pendant toute la visite d'un cas (le `await pushNamed` ne se résout qu'au
retour). Le rebuild de la liste pendant l'animation de sortie figeait
`onTap: () {}`. Remplacé par un anti-rebond temporel de 400 ms, hors `build`.

**Compteur de cas faux** — le sous-titre affichait `cases.length`, soit la page
courante (40 → 79 → 118 au fil du scroll). Nouveau `countCases()` au repository,
via `count(CountOption.exact)` : requête `HEAD`, total dans l'en-tête
`Content-Range`, zéro ligne transférée. **516 cas publiés** vérifiés en base.

**Verrou anti-triche** — plus aucun retour possible dès la première question,
`PopScope` inclus, avec dialogue de confirmation. Bouton cahier ajouté pour
relire l'énoncé (seul accès au texte, puisque le retour est verrouillé).

**Chrono d'épreuve** — durée = `estimated_minutes` du cas (20/25/30 min),
démarré au clic sur « Je commence », donc la lecture de l'énoncé n'est pas
décomptée. Le temps restant est **recalculé depuis une échéance**, jamais
décrémenté : un compteur décrémenté dérive (frames sautées, app en arrière-plan)
et finirait par mentir sur une épreuve chronométrée. À 00:00, flush des
brouillons puis envoi automatique en correction. Limite connue → point 20.

### ✅ K.2 — Quiz culture générale : refonte visuelle

Travaillée sur `quiz_culture_generale_france.dart` avant propagation.

- **Fond** : le noir plat devient un dégradé navy avec halo et trois masses
  colorées dérivantes, décliné dans les **deux thèmes** (le clair a la même
  construction en lumineux, pas un aplat). Le splash de difficulté ne peint plus
  son propre fond : il laisse voir celui de la page, ce qui supprime une rupture
  de teinte et trois `AnimatedBuilder`.
- **Croix de feedback superposée au texte** : overlay flottant de 240 px
  supprimé. L'animation vit dans l'icône du bandeau, bornée, dimensionnée selon
  la largeur d'écran **et** le réglage de texte système. La réserve de 240 px
  sous la carte est récupérée.
- **Liseré fantôme au-dessus du bandeau** : le contour venait du `shape` d'un
  `Material`, le fond d'un `Container` enfant avec `margin: top 10`. Deux boîtes
  décalées de 10 px. Fusionnées en une seule `BoxDecoration`.
- **Cascades d'apparition** : splash (7 éléments, 920 ms) et questions
  (420 ms par élément, décalage 130 ms). Un contrôleur par écran, chaque élément
  lisant un `Interval` — pas un `Timer` par élément.
- **Clé de sous-arbre** : `page_${i}_${animVisible}_${_isCorrect}_${_currentChoice}`
  changeait **à chaque tap sur une option**, détruisant et recréant tout le
  sous-arbre. Réduite à `ValueKey('page_$i')`. Effet de bord gratuit : les
  options animent enfin leur passage au vert/rouge.
- **Couleurs des niveaux** alignées sur `_difficultyStyle` des cas pratiques
  (`#22C55E` / `#F59E0B` / `#EF4444`) : un « Difficile » a la même couleur
  partout dans l'app. Emojis 🌱🏅🏆 remplacés par des icônes Material, dont le
  dessin ne dépend plus de la police système.
- **Sécurité des sorties** : « Mettre fin » et la croix clôturaient sans rien
  demander. Confirmation ajoutée sur les deux, plus le geste retour système.
- **Bug de sauvegarde** : `_updateHistoryOnAbandon` écrivait `score: 0,
  correct_count: 0, total_questions: 0`. Répondre à 5 questions puis fermer
  effaçait les 5 résultats de l'historique. Supprimée ; tous les chemins passent
  par `_updateHistoryOnFinish`.
- **ANR corrigé** (introduit puis résolu dans la session) : `PopScope(canPop:
  false)` + `Navigator.maybePop()` → `maybePop` consulte les `PopScope`, se
  faisait refuser, rappelait la confirmation, en boucle synchrone. Gel de l'UI
  (« COP'IQ isn't responding »). Toutes les sorties utilisent `pop()`.
- Divers : compteur `Question x / y`, haptique à la sélection, défilement vers
  la correction, drapeau de signalement masqué hors quiz, contour et rayon du
  bouton secondaire alignés sur le principal, `width: 360` fixe de l'overlay de
  chargement (débordait sous 320 dp) passé en contrainte, `WillPopScope`
  déprécié → `PopScope`, accessibilité (`Semantics` radio, respect de
  « Réduire les animations »), deux `AnimationController` fantômes supprimés —
  dont un qui planifiait un tick à chaque frame pour repeindre zéro pixel.

### ✅ K.3 — Propagation aux 212 quiz de l'application

| Zone | Quiz modifiés |
|---|---|
| GPX Scolarité | 107 |
| PA Scolarité | 69 |
| PA Exam | 19 |
| GPX Exam | 17 |
| **Total** | **212** |

Deux familles de template identifiées — 27 fichiers complets (historique
Supabase, pagination, overlay de chargement) et 185 allégés (questions en dur) —
mais architecture UI commune. Propagation par **huit scripts successifs**, chacun
en tout-ou-rien par fichier, avec un parseur qui trouve les vraies parenthèses
fermantes en ignorant chaînes et commentaires. Tout fichier dont l'équilibrage
des délimiteurs cassait était **rejeté plutôt qu'écrit**. Scripts conservés dans
`/tmp/prop/` (non versionnés — à recréer si une propagation similaire est
nécessaire).

### ✅ K.4 — Erreurs introduites par la propagation, puis corrigées

Signalées par `flutter analyze` (428 issues), deux familles :

1. **`dispose()` dupliqué, ~211 fichiers.** Le splash avait un `dispose()` qui
   libérait deux contrôleurs ; ceux-ci supprimés, la méthode s'est vidée
   (`super.dispose()` seul) et l'injection du moteur de cascade en a ajouté une
   seconde → `duplicate_definition` + `unnecessary_overrides` sur la même ligne.
   Les `dispose()` vides ont été retirés.
2. **`pa_quiz_tests_psycotechniques_suite_logiques.dart`, 3 erreurs.** Structure
   atypique (une seule question à l'écran, pas de `PageView`, `pulseController`
   au lieu de `_pulseCtrl`) : paramètres `estActive`/`pulse` manquants à l'appel,
   et `question.sub` inexistant sur son modèle. Corrigé à la main.

Trois audits statiques repassés à zéro sur les 212 fichiers : équilibrage et
doublons de membres, paramètres requis des appels, cycles de vie des
contrôleurs (mixin présent, bon type, `dispose()` systématique).

✅ **`flutter analyze` relancé le 31/07** : 0 problème.

### 🟡 K.5 — Énoncés qui répètent leurs propres réponses (non corrigé en base)

Beaucoup de questions générées listent les options dans leur libellé : « Quelle
région est réputée pour les vins de Bordeaux : Auvergne-Rhône-Alpes,
Centre-Val de Loire, Martinique ou Nouvelle-Aquitaine ? », puis les quatre mêmes
options s'affichent en dessous. Le titre double de hauteur et la question perd sa
force.

Un nettoyage **à l'affichage** a été posé, volontairement conservateur : coupe au
dernier `:` seulement si toutes les options se retrouvent après lui, si la partie
conservée fait au moins 15 caractères, et si aucune option ne fait moins de
4 caractères (« oui », « non », « 12 » se retrouvent par hasard dans n'importe
quelle phrase). Sinon le libellé passe intact.

**C'est un filet, pas un remède.** La correction de fond est un `UPDATE` sur
`quiz_questions` — non fait, volume non mesuré.

---

## ✅ L — Communauté globale COP’IQ (01/08/2026)

- Forum Flutter partagé entre `pa_exam`, `gpx_exam`, `pa_school` et
  `gpx_school`, avec fil global ou spécialisé.
- Publications, commentaires, réactions, favoris, signalements et compteurs
  atomiques reliés à Supabase.
- Profils communautaires détaillés et réglages de confidentialité. Les fonctions
  publiques n'exposent jamais email, téléphone, ville ou anniversaire.
- Recherche PostgreSQL plein texte en français pour les publications, recherche
  de membres, filtres par espace et pagination limitée côté serveur.
- Création atomique d'une conversation depuis un profil, blocages vérifiés en
  base, messagerie Flutter et réception Realtime.
- Partage natif et partage interne vers une conversation, avec comptage
  idempotent.
- Abonnement/désabonnement aux discussions et notifications des réponses.
- Centre visuel de notifications avec états lus/non lus et navigation vers la
  publication, la conversation ou le commentaire précis concerné.
- Discussions hiérarchiques paginées : tri pertinent/récent/ancien, réponses
  imbriquées chargées par lots, retour au parent et indicateur Realtime des
  nouvelles réponses sans déplacement brutal du fil.
- Réactions sur les commentaires avec liste des membres, mentions de profils,
  brouillons automatiques et choix d'une réponse comme solution par l'auteur.
- Gestion complète des commentaires : modification, suppression conservant le
  fil, copie, signalement, blocage et états visuels de modération.
- Protections anti-spam en base (doublons rapprochés et rafales), compteur de
  réactions atomique et index dédiés aux fils volumineux.
- Liens profonds `/forum/<uuid>` pris en charge.
- 19 tables `community_*` protégées par RLS ; rôle `anon` sans privilège sur
  les données communautaires ; journal de modération immuable.
- Tests transactionnels Supabase réussis sans conserver de données de test :
  propriété, compteurs, recherche, profil public, partage, abonnements,
  notifications, messagerie, solution et anti-spam. `flutter analyze` :
  0 problème ; tests modèles : 7/7 réussis.

### 🟡 L.1 — Panel administrateur web séparé

Le code du panel web n'est volontairement pas inclus dans Flutter. Son cahier
des charges se trouve dans
`progression/PROMPT_PANEL_ADMIN_FORUM.md` et doit être exécuté dans le projet web
source avant de régénérer l'export destiné à l'hébergeur.

---

*Statut au 30/07/2026 : aucun point 🔴 connu. Les cas pratiques et les 212 quiz
de l'application ont été refondus et homogénéisés, avec 9 anomalies visuelles ou
fonctionnelles corrigées — dont deux qui empêchaient l'affichage du contenu et
une qui gelait l'app. Deux actions immédiates avant toute soumission :
**relancer `flutter analyze`** (K.4) et **tester les quiz sur appareil réel dans
les deux thèmes**, la propagation n'ayant été vérifiée que statiquement sur 211
des 212 fichiers. Le reste de l'application n'a jamais été regardé tourner
(section G).*
