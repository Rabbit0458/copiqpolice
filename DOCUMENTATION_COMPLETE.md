# DOCUMENTATION COMPLÈTE — CopIQ Police

> Fichier de référence pour l'adaptation de l'application mobile Flutter en site web.
> Généré le : 2026-07-01

---

## TABLE DES MATIÈRES

1. [Architecture Générale](#1-architecture-générale)
2. [Application Mobile Flutter](#2-application-mobile-flutter)
   - 2.1 Point d'entrée — main.dart
   - 2.2 Routeur — app_router.dart
   - 2.3 Features : Auth
   - 2.4 Features : Onboarding
   - 2.5 Features : Home
   - 2.6 Features : Forum
   - 2.7 Features : Psychotechniques
   - 2.8 Features : Placement
   - 2.9 Features : Bookmarks, Notes, Memos
   - 2.10 Features : Reserve
   - 2.11 Features : Feedback
3. [Core Fonctionnel Flutter](#3-core-fonctionnel-flutter)
   - 3.1 Services principaux
   - 3.2 Moteur de cas pratiques
   - 3.3 Gamification
   - 3.4 Paiements / Abonnements
   - 3.5 Notifications
   - 3.6 Analytics
   - 3.7 Widgets partagés
4. [Contenu Pédagogique (lib/content/)](#4-contenu-pédagogique-libcontent)
   - 4.1 Structure générale
   - 4.2 Concours PA (Police Adjoint)
   - 4.3 Concours GPX (Gardien de la Paix)
   - 4.4 Examens GPX
   - 4.5 Réserve
   - 4.6 Paywall content
5. [Données & Modèles](#5-données--modèles)
   - 5.1 Modèles Flutter
   - 5.2 Schéma Supabase inféré
6. [Site Web Next.js](#6-site-web-nextjs)
   - 6.1 Architecture
   - 6.2 Layout global
   - 6.3 Pages publiques
   - 6.4 Pages authentifiées (dashboard)
   - 6.5 Pages auth
   - 6.6 Composants partagés
   - 6.7 Hooks
   - 6.8 Configuration & Infrastructure
7. [Fonctionnalités Clés — Description Détaillée](#7-fonctionnalités-clés--description-détaillée)
   - 7.1 Système de quiz
   - 7.2 Système d'abonnement / Paywall
   - 7.3 Cas pratiques (moteur IA)
   - 7.4 Forum communautaire
   - 7.5 Psychotechniques
   - 7.6 Système XP / Gamification
   - 7.7 Placement test
8. [Guide d'Adaptation Web](#8-guide-dadaptation-web)

---

## 1. ARCHITECTURE GÉNÉRALE

### 1.1 Vue d'ensemble

COP'IQ Police est une plateforme de préparation aux concours de la Police Nationale française. Elle couvre deux filières :

- **PA (Police Adjoint)** : concours d'entrée pour devenir policier adjoint
- **GPX (Gardien de la Paix)** : concours d'entrée pour devenir gardien de la paix (niveau supérieur)

Chaque filière est déclinée en deux modes :
- **Mode Scolarité** : cours structurés par modules, pour les élèves en formation initiale
- **Mode Concours (Exam)** : préparation aux épreuves (QCM, cas pratiques, psychotechniques, culture générale, langues)

L'application mobile Flutter (iOS/Android) est le produit principal. Le site web Next.js est une version complémentaire en cours de développement.

### 1.2 Stack technique

**Flutter (mobile) :**
- Dart / Flutter SDK
- Supabase Flutter (`supabase_flutter`) : base de données, auth, storage, realtime, edge functions
- `shared_preferences` : persistance locale (favoris, préférences, cache)
- `google_fonts` : typographie
- `firebase_messaging` : notifications push FCM
- `url_launcher` : ouverture Stripe Checkout en navigateur externe
- `image_picker` : upload d'images dans le forum
- State management : architecture "services singletons" + `ValueNotifier` (pas de Riverpod ni Provider)
- Navigation : `Navigator` impératif + routes nommées via `RouteRegistry`
- Design system maison (tokens dans `cp_tokens.dart`, thème dans `app_notifier.dart`)

**Next.js (web) :**
- Next.js 14+ App Router (React Server Components)
- TypeScript
- Supabase SSR (`@supabase/ssr`) : auth côté serveur via cookies
- Tailwind CSS + CSS variables custom
- `next-themes` : dark/light mode
- Framer Motion : animations sur la landing page
- `react-hot-toast` : notifications toast
- Stripe (`stripe` npm) : paiements côté serveur
- Lucide React : icônes

**Backend partagé :**
- Supabase (PostgreSQL + Auth + Storage + Realtime + Edge Functions)
- Stripe : gestion des abonnements (webhook + checkout sessions)
- Firebase Cloud Messaging (FCM) : push notifications
- PostHog : analytics produit (côté Flutter)
- Sentry : monitoring d'erreurs (côté Flutter)

---

## 2. APPLICATION MOBILE FLUTTER

### 2.1 Point d'entrée — main.dart

**Chemin :** `lib/main.dart`
**Rôle :** Bootstrap complet de l'application. Fichier déclaré comme `library copiqpolice_app` qui utilise le mécanisme `part`/`part of` pour partager ses imports avec `routes/app_router.dart`.

**Fonctionnalités :**
- Initialisation de Supabase (URL + anon key)
- Configuration de Firebase Messaging
- Initialisation de Sentry (monitoring)
- Enregistrement des services singletons (SubscriptionService, CpPushService…)
- Lancement de `MaterialApp` avec `onGenerateRoute` → `appOnGenerateRoute`
- Gestion du thème (light/dark) via `AppSettingsController`
- Session hydration : mécanisme de retry sur `Supabase.instance.client.auth.currentUser` avec backoff exponentiel (120ms → 600ms) avant de rediriger vers la home

**Classes critiques dans main.dart :**
- `AppAuthClientOptions` : wrapper Supabase auth options (autoRefreshToken, persistSession)
- `GoTrueRecoverCompat` : extension pour `recoverSessionFromStorage()` (compat Supabase versions)
- `_waitForSessionUser()` : attente active de la session (timeout 6s)
- `_ensureSessionHydrated()` : vérifie la session + tente recovery si absente

**Imports :** Tous les imports de l'app (plus de 800 lignes) sont déclarés ici pour être disponibles dans `app_router.dart` via le mécanisme `part of`.

---

### 2.2 Routeur — app_router.dart

**Chemin :** `lib/routes/app_router.dart`
**Rôle :** `part of` de `main.dart`. Contient la fonction `appOnGenerateRoute()` et la classe `RouteRegistry`.

**Fonctionnalités :**
- `appOnGenerateRoute(RouteSettings settings)` : switch sur `settings.name` pour générer les routes. Gère les cas spéciaux (`/signup`, `/login`, `/signin`, `SavingScreen`) avec des builders custom incluant des callbacks.
- `RouteRegistry.routes` : `Map<String, WidgetBuilder>` statique contenant TOUTES les routes de l'app (plusieurs centaines).

**Routes principales connues :**
```
/onboarding           → OnboardingScreen
/welcome              → WelcomeAfterSignupPage
/placement-intro      → PlacementIntro
/placement            → PlacementTest
/favoris              → FavorisHomePage
/institutions         → InstitutionPage
/procedure_penale     → ProcedurePenalePage
/picker               → ModePickerScreen
/abonnement           → AbonnementPage
/premium-required     → PremiumRequiredPage
/home_pa_school       → HomePagePaSchool
/home-bootstrap       → HomeBootstrap
/home-gpx-exam        → HomePageGpxExam
+ plusieurs centaines de routes de contenu
  (ex: /gpx/generalites/classification_infractions → ClassificationInfractionsPage)
```

**Service complémentaire :** `lib/core/services/route_registry.dart` — `RouteRegistry` helper qui mappe labels UI → routes réelles avec normalisation des accents/ponctuation. Utilisé pour le moteur de recherche.

---

### 2.3 Features : Auth

**Chemin :** `lib/features/auth/`

#### signup.dart
**Widget :** `SignUpPage(onSignedUp: (email, password) => ...)`
**Rôle :** Inscription en 4 étapes (wizard `PageController`) :
1. Nom & prénom
2. Email + vérification de disponibilité (debounce 800ms, RPC Supabase)
3. Mot de passe (double saisie)
4. Ville + téléphone + acceptation des CGU

**Logique clé :**
- Email availability check via `_emailDebounce` (Timer) + appel Supabase
- Validation champ par champ avec messages d'erreur inline
- Appel `Supabase.instance.client.auth.signUp()` à la fin
- Callback `onSignedUp(email, password)` → navigation vers `ConfirmEmailPage`
- Design : fond dégradé bleu nuit (`#000B36` → `#1147D9`), support `reduceMotion`

#### signin.dart
**Widget :** `SignInPage(onSignedIn: () => ...)`
**Rôle :** Connexion email/mot de passe.
**Logique :**
- `SharedPreferences` pour "Se souvenir de moi" (clés : `signin_remember_me`, `signin_remember_email`)
- `Supabase.instance.client.auth.signInWithPassword()`
- Callback `onSignedIn()` → navigation vers `/picker` (post-login)
- Design institutionnel Police Nationale : fond photo bâtiment + overlay bleu

#### reset_password.dart
**Widget :** `ResetPasswordPage`
**Rôle :** Formulaire envoi email de réinitialisation via `supabase.auth.resetPasswordForEmail()`

#### confirm_email.dart
**Widget :** `ConfirmEmailPage`
**Route :** `ConfirmEmailPage.routeName = '/confirm-email'`
**Rôle :** Écran d'attente confirmation email post-inscription. Affiche l'email, bouton "Renvoyer" (cooldown).

---

### 2.4 Features : Onboarding

**Chemin :** `lib/features/onboarding/`

#### onboarding_screen.dart
**Widget :** `OnboardingScreen(onSkip, onFinish, onLogin)`
**Rôle :** Écran d'accueil première ouverture. 3 slides (PageView) :
1. "Le concours. Tu le décroches." — QCM, cas concrets, oraux (PA & GPX)
2. "Tu comprends. Tu retiens." — Corrections claires + explications
3. "Tu progresses. Chaque jour." — Objectifs, stats, routine

**Logique :**
- Animation "idle" sur hero (AnimationController, 5s loop)
- Haptic feedback aux snaps
- SharedPreferences key `onboarding_theme_dark` pour persister le thème choisi
- Palette : light (`#1147D9`/`#174FE0`) et dark (`#000B36`/`#001041`)

#### mode_picker.dart
**Widget :** `ModePickerScreen(schoolCardKey, examCardKey, onModeSelectedOverride, lockToSchoolOnly)`
**Rôle :** Choix du mode utilisateur : "Je prépare le concours" (exam) vs "Je suis en scolarité" (school).

**Logique :**
- Sauvegarde `user_mode` dans `SharedPreferences` ET upsert dans `public.user_profiles` (Supabase)
- Redirige vers `GradePickerScreen`
- `lockToSchoolOnly` : mode tutoriel (empêche la sélection concours)
- `onModeSelectedOverride` : hook pour tutoriel sans navigation réelle

**Enum `UserMode` :** `exam` | `school` (défini dans `home_page.dart`)

#### grade_picker.dart
**Widget :** `GradePickerScreen`
**Rôle :** Choix de la filière (PA ou GPX) après le choix du mode. Persiste dans SharedPreferences.

#### gpx_school.dart
**Exports :** `GpxSchoolProgram`, `GpxSchoolArt`
**Rôle :** Programme affiché pendant l'onboarding GPX scolarité.

#### pa_school.dart, reserve_school.dart
**Rôle :** Variantes onboarding pour les filières PA et Réserve.

#### discovery_tutorial.dart
**Widget :** Tutoriel de découverte interactif (spotlight sur les éléments UI avec `GlobalKey`).

---

### 2.5 Features : Home

**Chemin :** `lib/features/home/`

#### home_page.dart
**Widget principal :** `HomePage` (point d'entrée commun)
**Rôle :** Configuration centrale des catégories pour toutes les combinaisons Mode × Filière.

**Types exportés (utilisés par toutes les homes) :**
```dart
enum UserMode { exam, school }
enum Track { gpx, pa, reserve }

class CategoryConfig {
  final String label;
  final String badge;
  final String image;
  final String route;
  final List<SubCategoryConfig>? subcategories;
}

class SubCategoryConfig {
  final String label;
  final String route;
}
```

**`categoriesConfig`** : `Map<UserMode, Map<Track, List<CategoryConfig>>>` — la configuration exhaustive de tous les modules/sous-modules disponibles dans chaque combinaison (school×gpx, school×pa, exam×gpx, exam×pa). C'est le "catalogue" de l'app.

**Exemple pour `school × gpx` :**
- Généralités (8 sous-modules : Classification infractions, L'infraction, La tentative, La complicité, Légitime défense, Armes, Libertés publiques, Rétention locaux)
- Cadres juridiques (cadres d'enquête, flagrant délit, enquête préliminaire, commission rogatoire, etc.)
- Droit pénal général, Sanctions, Crimes/délits contre personnes, contre biens, contre la Nation
- Stupéfiants, Mineurs & famille, Circulation routière
- Institutions & valeurs, Mémento circulation, Policier & intervention (initial + avancé), PV APJ20

#### home_bootstrap.dart
**Widget :** `HomeBootstrap`
**Route :** `/home-bootstrap`
**Rôle :** "Dispatcher" — lit le mode et la filière sauvegardés, redirige vers la bonne home page.

#### home_page_gpx_school.dart
**Widget :** `HomePageGpxSchool`
**Rôle :** Home principale pour le mode GPX Scolarité. Design avancé avec :
- Deck de cartes animé (physics-based, `flutter/physics.dart`)
- Barre de navigation bottom (Journal, Favoris, Profil)
- ProgressCard (progression de l'utilisateur)
- Intégration tutoriel (GlobalKeys : `apjTileKey`, `modeGradeButtonKey`, `heroDeckKey`…)
- `UserMode` + `Track` switcher en haut
- Support `tutorialLock` global (bloque les taps pendant le tutoriel)
- Premium guard intégré : `PremiumGuard` avant ouverture des modules payants

#### home_page_gpx_exam.dart
**Widget :** `HomePageGpxExam`
**Route :** `HomePageGpxExam.routeName = '/home-gpx-exam'`
**Rôle :** Home pour le mode GPX Concours.
- Navigation bottom 3 tabs (Accueil, Journal, Profil)
- Barre de recherche avec debounce (TextEditingController + Timer) + auto-navigation via `RouteRegistry`
- Liste des catégories du mode concours GPX (culture générale, psychotechniques, cas pratiques, langues, concours blanc, structure du concours)
- `PageStorageBucket` pour sauvegarder le scroll de chaque tab
- `usernameLoader` static : pont pour charger le username (injecté au boot)

#### home_page_pa_school.dart
**Widget :** `HomePagePaSchool` — Même architecture que GPX School, filière PA

#### home_page_pa_exam.dart
**Widget :** `HomePagePaExam` — Home concours filière PA

#### home_page_reserve_school.dart / home_page_reserve_exam.dart
**Widgets :** Homes pour la filière Réserve

#### home_bootstrap.dart
**Widget :** `HomeBootstrap` — dispatcher lecture prefs → redirection

#### profil_page.dart
**Widget :** Page profil utilisateur : avatar, stats (XP, level), historique des quiz, paramètres.

#### parametre_home.dart
**Widget :** Paramètres : thème dark/light, notifications, compte (déconnexion, suppression), CGU.

#### favoris_home.dart
**Widget :** `FavorisHomePage`
**Route :** `/favoris`
**Rôle :** Liste des modules mis en favoris. Utilise `FavoritesStore.I` (singleton SharedPreferences).

#### journal_home.dart / journal_gpx_school.dart / journal_pa_school.dart / journal_pa_exam_page.dart
**Rôle :** Journal de progression de l'utilisateur — historique des quiz tentés, scores, recommandations de révision.

#### journal_gpx_school_courses_page.dart
**Rôle :** Liste des cours disponibles avec statut de progression pour GPX School.

#### abonnement_page.dart
**Widget :** `AbonnementPage`
**Route :** `/abonnement`
**Rôle :** Paywall interne à l'app mobile. Affiche les 3 plans (semaine €4,99, mois €8,99, année €86,99). Lance `StripePaymentService.instance.startCheckout()` qui ouvre le navigateur externe.

#### premium_required_page.dart
**Widget :** `PremiumRequiredPage`
**Route :** `/premium-required`
**Rôle :** Page interstitielle quand un contenu premium est atteint sans abonnement.

#### details_page.dart
**Widget :** Page détail d'une catégorie (affiche les sous-modules cliquables).

#### category_detail_cards_page.dart
**Widget :** Variante de détail avec cartes enrichies.

#### annales_page.dart
**Widget :** Annales d'examens passés.

#### concours_blanc_page.dart
**Widget :** Concours blanc (examen en conditions réelles, 30 minutes, 10 questions officielles).

#### gpx_exam_concours_home_page.dart / gpx_exam_culture_generale_page.dart
**Rôle :** Sous-sections du mode concours GPX.

#### information_page.dart
**Widget :** Page d'information générale sur le concours.

#### user_page.dart
**Widget :** Page profil public d'un autre utilisateur (forum).

#### facture_page.dart
**Widget :** Facture / détails de l'abonnement en cours (plan, date renouvellement, cancel).

#### annulation_conditions_page.dart
**Widget :** Conditions d'annulation de l'abonnement.

#### gpx_school_config.dart
**Rôle :** Configuration des modules GPX School (liste ordonnée des catégories + metadata).

#### widgets/daily_reminder_tile.dart
**Widget :** Tile de rappel quotidien (streak, objectif du jour).

---

### 2.6 Features : Forum

**Chemin :** `lib/features/forum/`

#### forum_espace_exam_gpx.dart
**Widget :** `ForumEspaceExamGPXPage`
**Rôle :** Forum communautaire complet pour l'espace Concours GPX.

**Tables Supabase utilisées :**
- `forum_posts_exam_gpx` : posts du forum, jointure `user_profiles(role)`
- `user_profiles` : profil + rôle de l'utilisateur

**Fonctionnalités :**
- Feed de posts avec pagination
- Création de post + upload d'image (`image_picker`)
- Overlay de recherche (debounce 400ms, recherche contenu + username)
- Modération :
  - Badges rôle : `active` = coche bleue, `moderator` = coche jaune, `admin` = coche rouge
  - Menu "..." : report, block, delete (mod+), promote/demote moderator (admin only)
- Gestion du mute (ban temporaire ou permanent avec raison)
- Profil chargé au bootstrap : `_loadMe()` → `user_profiles`
- Statut mute : `_loadMuteStatus()`
- Blocage d'utilisateurs : `_blockedUserIds` (Set local)

#### forum_theme.dart
**Rôle :** Thème visuel du forum (couleurs, styles de posts, badges).

#### member_picker_sheet.dart
**Widget :** Bottom sheet pour sélectionner un membre (modération : promouvoir/rétrograder).

---

### 2.7 Features : Psychotechniques

**Chemin :** `lib/features/gpx_exam/psychotechniques/`

#### models/psycho_question.dart
**Classes :**
```dart
class PsychoOption {
  final String key;
  final String label;
  final String? imageUrl;
}

class PsychoQuestion {
  final String id;
  final String tableName;   // ex: 'tests_psyco_calcul_mental'
  final String module;      // 'psychotechnique'
  final String category;    // ex: 'calcul_mental'
  final String difficulty;  // 'Facile' | 'Moyenne' | 'Difficile'
  final String question;
  final String? prompt;
  final List<PsychoOption> options;
  final String answer;
  final String? explanation;
  final String? hint;
  final String? imageUrl;
  final Map<String, dynamic>? figureData;
  final Map<String, dynamic> rawData;
}
```

#### services/psycho_question_service.dart
**Classe :** `PsychoQuestionService`
**Tables Supabase (une table par catégorie) :**
```
tests_psyco_calcul_mental
tests_psyco_logique_verbale
tests_psyco_raisonnement_logique
tests_psyco_raisonnement_spatial
tests_psyco_rotations_symetries
tests_psyco_concentration
tests_psyco_attention_visuelle
tests_psyco_suite_logique
```

**Algorithme de chargement (anti-ORDER BY RANDOM()) :**
1. Générer un seed aléatoire
2. Requête `rand_key >= seed` avec `is_active = true` + filtres difficulté
3. Si résultats insuffisants : compléter avec `rand_key < seed`
4. Fusionner et mélanger localement

**Méthode principale :** `loadByCategory({ category, difficulty, limit })` → dispatche vers la méthode spécifique.

**Méthodes compteurs :** `countByCategory(category, difficulty)` → pour afficher "X questions disponibles" dans l'écran de sélection de difficulté.

#### pages/psycho_quiz_page.dart
**Widget :** `PsychoQuizPage(config: PsychoQuizConfig)`
**Rôle :** Moteur générique pour tous les exercices psychotechniques.

**Config `PsychoQuizConfig` :**
```dart
class PsychoQuizConfig {
  final String exerciseTitle;
  final String exerciseSubtitle;
  final IconData exerciseIcon;
  final Color exerciseColor;
  final String routeName;
  final String category;       // ex: PsychoCategory.calculMental
  final String tableName;
  final String introHidePrefKey; // SharedPreferences key unique
  final int questionDuration;    // secondes par question (défaut: 30)
  final int sessionLength;       // nb questions (défaut: 10)
  final String objectiveText;
  final String howToText;
  final String? exampleText;
  final String? tipText;
  final String timerText;
}
```

**Phases :** `_Phase { difficulty, intro, loading, quiz, result, error }`

**Flux :**
1. `difficulty` → `PsychoDifficultyScreen` : choix facile/moyenne/difficile
2. `intro` → `PsychoIntroScreen` : explication de l'exercice (cachable via SharedPrefs)
3. `loading` → chargement depuis Supabase
4. `quiz` → affichage questions + timer par question
5. `result` → `PsychoResultScreen` : score, détail, bouton recommencer
6. Sauvegarde dans `PsychoHistoryService`

#### Catégories disponibles (8) :
- `calcul_mental` : additions/soustractions/multiplications chronométrées
- `logique_verbale` : syllogismes, analogies
- `raisonnement_logique` : déductions
- `raisonnement_spatial` : figures géométriques
- `rotations_symetries` : rotations 2D/3D
- `concentration` : exercices d'attention soutenue
- `attention_visuelle` : repérage de différences/similitudes
- `suite_logique` : suites numériques ou figuratives

#### Pages spécifiques :
- `calcul_mental_page.dart`, `logique_verbale_page.dart`, `raisonnement_logique_page.dart`, `raisonnement_spatial_page.dart`, `rotations_symetries_page.dart`, `concentration_page.dart`, `suites_logiques_page.dart`
- Chaque page instancie `PsychoQuizPage` avec sa propre `PsychoQuizConfig`

#### services/psycho_history_service.dart
**Rôle :** Sauvegarde des résultats de sessions dans Supabase (`psycho_history` table) et localement.

#### services/psycho_report_service.dart
**Rôle :** Signalement d'une question erronée via Supabase.

#### widgets/
- `psycho_brand.dart` : éléments visuels de marque du module psycho
- `psycho_cube_renderer.dart` : rendu 3D des cubes (exercices raisonnement spatial)
- `psycho_dialogs.dart` : dialogues (abandon, confirmation)
- `psycho_difficulty_screen.dart` : sélection de difficulté avec compteurs
- `psycho_intro_screen.dart` : intro animée avec checkbox "ne plus afficher"
- `psycho_quiz_widgets.dart` : carte question, options A/B/C/D, timer circulaire
- `psycho_result_screen.dart` : récapitulatif score + détail question par question
- `psycho_states.dart` : états UI supplémentaires

#### pages/mode_concours_page.dart
**Widget :** Mode "Concours complet" — enchaînement de toutes les catégories en temps limité.

#### pages/comprendre_epreuve_psycho_page.dart
**Widget :** Guide de compréhension de l'épreuve psychotechnique du concours GPX.

---

### 2.8 Features : Placement

**Chemin :** `lib/features/placement/`

#### placement_engine.dart
**Classe :** `PlacementEngine`
**Rôle :** Moteur de test de niveau adaptatif (IRT simplifié).

**Algorithme :**
- 6 questions par domaine (`PlacementDomain`)
- Difficulté initiale : `medium`
- Si réponse correcte : monte en difficulté (easy→medium→hard)
- Si réponse incorrecte : descend (hard→medium→easy)
- Score pondéré par `question.weight`

**Calcul résultat :**
```dart
String get level {
  if (pct < 40) return "Fondamentaux insuffisants";
  if (pct < 60) return "Niveau intermédiaire";
  if (pct < 80) return "Bon niveau";
  return "Niveau avancé";
}
```

#### placement_questions.dart
**Rôle :** Base de données statique des questions de placement (Dart pur, pas Supabase).
**Enum `PlacementDomain`** : domaines couverts (droit pénal, procédure, institutions…)

#### placement_test.dart
**Widget :** `PlacementTest(onFinished: () => ...)`
**Route :** `/placement`
**Rôle :** UI du test de placement — affiche les questions une par une, gère le timer, appelle l'engine.

#### placement_intro.dart
**Widget :** `PlacementIntro`
**Route :** `/placement-intro`
**Rôle :** Écran d'introduction avant le test de placement.

#### welcome_after_signup.dart
**Widget :** `WelcomeAfterSignupPage`
**Route :** `/welcome`
**Rôle :** Page de bienvenue post-inscription → propose le test de placement ou la navigation directe.

---

### 2.9 Features : Bookmarks, Notes, Memos

#### cp_bookmarks_service.dart
**Chemin :** `lib/features/bookmarks/cp_bookmarks_service.dart`
**Classe :** `CpBookmarks.I` (singleton)

**Modèle `CpBookmark` :**
```dart
class CpBookmark {
  final String caseId;
  final String caseSlug;
  final String caseTitle;
  final int? caseYear;
  final String? themeId;
  final String? difficulty;
  final DateTime bookmarkedAt;
  final String? note;
}
```

**API :**
- `toggleBookmark(caseId)` → bool (nouvel état) via RPC atomique Supabase
- `isBookmarked(caseId)` → bool (cache local synchrone)
- `bookmarksStream` → `Stream<List<CpBookmark>>`
- Hydratation au login + watch Realtime Supabase

**Vue Supabase :** `cp_my_bookmarks` (join avec cas_pratique_cases)

#### cp_user_notes_service.dart
**Chemin :** `lib/features/notes/cp_user_notes_service.dart`
**Classe :** `CpUserNotes.I` (singleton)

**Modèle `CpUserNote` :**
```dart
class CpUserNote {
  final String id, userId, body;
  final String? attemptId, questionId, rubricPointId, caseId;
  final List<String> tags;
  final String? color;
  final DateTime createdAt, updatedAt;
  // Champs enrichis (vue cp_my_notes_enriched)
  final String? caseSlug, caseTitle;
  final int? caseYear, questionPosition;
}
```

**API :** `create()`, `update()`, `delete()`, `listForAttempt()`, `search(query)`
**Vue Supabase :** `cp_my_notes_enriched`

#### cp_memos_page.dart
**Chemin :** `lib/features/memos/cp_memos_page.dart`
**Widgets :** `CpMemosListPage` + `CpMemoReaderPage`
**Routes :**
- `/cas-pratique/memos` → liste des fiches mémo
- `/cas-pratique/memos/reader` → lecteur (arg: `{ 'slug': 'deontologie-5-points' }`)

**Modèles :**
```dart
class CpMemoListItem {
  final String id, slug, title;
  final String? excerpt;
  final List<String> tags;
  final int readingTimeMinutes;
  final bool isPremium, isReadByUser;
}

class CpMemoFull {
  final String id, slug, title, contentMd;
  final int readingTimeMinutes;
}
```

**Vue Supabase :** `cp_memos_with_read_state`
**Tracking :** RPC `cp_memo_mark_read(memo_id, duration_seconds)` au départ du reader.

---

### 2.10 Features : Reserve

**Chemin :** `lib/features/reserve/`

#### accueil_reserve.dart
**Widget :** `AccueilReservePage`
**Rôle :** Home spécifique à la filière Réserve (ancienne gendarmerie/police de réserve).

---

### 2.11 Features : Feedback

#### saving_screen.dart
**Chemin :** `lib/features/feedback/saving_screen.dart`
**Widget :** `SavingScreen(payload: Map<String, dynamic>)`
**Route :** `SavingScreen.routeName`
**Rôle :** Écran de sauvegarde/confirmation après une action importante (fin de quiz, soumission cas pratique). Affiche un état de chargement puis un résumé.

---

## 3. CORE FONCTIONNEL FLUTTER

### 3.1 Services principaux

**Chemin :** `lib/core/services/`

#### subscription_service.dart
**Classe :** `SubscriptionService.instance` (singleton + ValueNotifier)

**Tables Supabase :**
- `subscription_payement` : `(user_id, plan, status, valid_until, updated_at)`
- `free_weekly_usage` : `(user_id, window_start, used)`

**RPCs Supabase :**
- `is_user_premium(p_user_id uuid)` → bool
- `consume_free_request()` → json `(allowed, remaining, resets_at, premium, reason)`

**Modèle `FreeQuota` :**
```dart
class FreeQuota {
  final int used, limit;
  final DateTime windowStart, lastUsedAt, resetsAt;
  int get remaining => (limit - used).clamp(0, limit);
  static const Duration windowDuration = Duration(days: 7);
}
```

**Logique de quota :** 10 requêtes gratuites par fenêtre de 7 jours. La reset est calculée depuis `updated_at` (dernière requête) + 7 jours. Normalisation côté client si la date de reset est passée.

**`SubscriptionState`** : état courant (premium bool, quota, plan, expiry).

**Realtime :** écoute les changements sur `subscription_payement` pour mise à jour immédiate post-paiement.

#### entitlement_service.dart
**Classe :** `EntitlementService.instance` (singleton)

**RPC Supabase :** `get_my_entitlement()` → payload complet

**Modèle `Entitlement` :**
```dart
class Entitlement {
  final bool authenticated;
  final String role;   // 'owner' | 'admin' | 'moderator' | 'active' | 'user'
  final bool isOwner, isAdmin, premium;
  final String plan;   // 'free' | 'week' | 'month' | 'year'
  final String status; // 'active' | 'trial' | 'cancelled' | 'expired' | 'past_due'
  final DateTime? validUntil;
  final bool cancelAtPeriodEnd;
  final int freeUsed, freeLimit, freeRemaining;
  final DateTime? freeResetsAt;
}
```

**Rôle :** Source de vérité enrichie pour le gating UI (owner bypass, plan détaillé, expiry).

#### quiz_history_service.dart
**Classe :** `QuizHistoryService`

**Table Supabase :** `quiz_attempts` (ou similaire)

**Modèle `QuizAttempt` :**
```dart
class QuizAttempt {
  final int id;
  final String uid, moduleName, quizName;
  final int score, totalQuestions, correctCount;
  final DateTime? completedAt, startedAt, finishedAt;
  int get percent => (correctCount / totalQuestions * 100).round();
}
```

**`ThemeAggregate` :** agrégat par thème (nb tentatives, total questions, correct total).

**API :** `fetchHistory(userId)`, `fetchThemeAggregates(userId)`

#### favorites.dart
**Classe :** `FavoritesStore.I` (singleton)
**Stockage :** SharedPreferences (clé `favorites_v1`, liste JSON)

**Modèle `FavoriteItem` :**
```dart
class FavoriteItem {
  final String route, title, subtitle, image;
  final double rating;
  final int reviews;
}
```

**API :** `isFavorite(route)`, `toggle(item)`, `favorites` (ValueNotifier)

#### route_registry.dart
**Classe :** `RouteRegistry`
**Rôle :** Mappe labels UI (normalisés : minuscules, sans accents, sans ponctuation) → routes réelles.
**Méthodes :** `register(label, route)`, `alias(alias, route)`, `routeFor(label)`, `fromCategories(cats)` (builder static)

#### premium_guard.dart
```dart
bool canAccessPremiumContent(SubscriptionState state) {
  return state.isPremium;
}
```

#### account_deletion_service.dart / account_management_service.dart
**Rôle :** Suppression de compte (anonymisation données) et gestion du compte utilisateur.

#### ad_service.dart
**Rôle :** Service publicités (désactivées pour les premium).

#### deep_links_service.dart
**Rôle :** Gestion des deep links (redirection post-paiement Stripe, partage de cas pratique).

#### notifications_service.dart
**Rôle :** Service notifications locales (complémentaire à `cp_push_service.dart`).

#### user_context_service.dart
**Rôle :** Cache du contexte utilisateur (user_id, email, profil) pour éviter les lectures répétées.

#### subscription_gate.dart
**Widget :** `SubscriptionGate` — wrapper qui vérifie l'abonnement avant d'afficher du contenu.

#### quiz_router.dart
**Rôle :** Routing contextuel pour les quiz (module → page quiz correspondante).

#### stripe_payment_service.dart
**Classe :** `StripePaymentService.instance`
**Enum `CopiqPlan` :** `week | month | year`
**Prix :** `week` €4,99 / `month` €8,99 / `year` €86,99

**API :**
- `startCheckout(CopiqPlan plan)` → lance checkout Stripe en navigateur externe
- `openCustomerPortal()` → portail Stripe pour gérer l'abonnement
- `cancelAtPeriodEnd()` → annulation

**Edge Functions Supabase invoquées :**
- `stripe-create-checkout` : body `{plan}` → retourne `{url}`
- `stripe-create-portal` : retourne `{url}`

**Flux post-paiement :** app resume (deep link) → `SubscriptionService.refresh()` → reconciliation Realtime.

---

### 3.2 Moteur de cas pratiques

**Chemin :** `lib/core/cas_pratique/engine/`

#### correction_engine.dart
**Classe :** `CorrectionEngine`
**Version :** `kEngineVersion = '2.0.0'`

**Flux de correction :**
1. Charger questions (`cas_pratique_questions` : id, max_points, position)
2. Charger rubric_points (`cas_pratique_rubric_points` : id, question_id, position, label, weight, is_required, kind, explanation_md)
3. Charger keyword_groups + keywords + synonyms_dictionary
4. Exécuter `AttemptScorer` (question par question)
5. INSERT dans `cas_pratique_corrections` + `cas_pratique_correction_details`
6. UPDATE `cas_pratique_attempts` (status=completed, total_score, percent, time_spent_ms)
7. Retourner `api.Correction` enrichi

**Note architecture :** la rubric est ADMIN-ONLY côté RLS. En production, la correction passe par une edge function `cas_pratique_correct_attempt` (serveur). Le moteur local sert pour le mode offline ou les tests admin.

#### scorer.dart
**Classes :**
```dart
class QuestionScoreResult {
  final String questionId;
  final double score, maxPoints, percent;
  final List<PointEvalResult> points;
}

class QuestionScoringInput {
  final String questionId;
  final int maxPoints;
  final String userAnswer;
  final List<EngineRubricPoint> rubricPoints;
  final Map<String, List<EngineKeywordGroup>> groupsByPoint;
}

class QuestionScorer {   // score(input, matcher) → QuestionScoreResult
class AttemptScorer {    // scoreAll(inputs, matcher) → total/max/percent
```

**Algorithme :** somme pondérée des points de rubrique (`weight`) → score normalisé à `max_points` (typiquement 5). Total cas : somme des questions → score /15.

#### keyword_matcher.dart
**Rôle :** Correspondance mots-clés dans la réponse utilisateur. Utilise `Tokenizer`, `Normalizer`, `Lemmatizer`, `SynonymResolver`.

**`KeywordMatchContext.build(answer)`** → contexte pré-calculé (tokens normalisés + lemmatisés) réutilisé pour tous les rubric_points d'un même cas.

#### tokenizer.dart
**Rôle :** Découpage du texte en tokens (mots), gestion de la ponctuation française.

#### normalizer.dart
**Rôle :** Normalisation Unicode : suppression diacritiques, minuscules, déduplication espaces.

#### lemmatizer.dart
**Rôle :** Lemmatisation simple du français (dictionnaire statique, pas de NLP externe).

#### levenshtein.dart
**Rôle :** Distance de Levenshtein pour la tolérance aux fautes de frappe dans le matching.

#### synonym_resolver.dart
**Rôle :** Résolution des synonymes depuis `synonyms_dictionary` (table Supabase).

#### negation_detector.dart
**Rôle :** Détection des négations dans la réponse (empêche de valider "je n'ai pas trouvé" comme réponse correcte contenant le mot-clé "trouvé").

#### point_evaluator.dart
**Classe :** `PointEvaluator`
**Rôle :** Évalue si un `EngineRubricPoint` est présent dans la réponse (en utilisant les keyword_groups).

```dart
class PointEvalResult {
  final String pointId;
  final double score, weight;
  final bool matched;
  // toDetailJson() pour persister dans cas_pratique_correction_details
}
```

---

### 3.3 Gamification

**Chemin :** `lib/core/cas_pratique/gamification/`

#### xp_service.dart
**Classe :** `XpService.instance`
**RPC Supabase :** `fn_cp_xp_total(uuid)` → total XP + niveau

**Niveaux (10 paliers) :**
```dart
const List<LevelSpec> kXpLevels = [
  LevelSpec(level: 1,  name: 'Recrue',         threshold: 0,     nextThreshold: 100),
  LevelSpec(level: 2,  name: 'Apprenti',       threshold: 100,   nextThreshold: 250),
  LevelSpec(level: 3,  name: 'Cadet',          threshold: 250,   nextThreshold: 500),
  LevelSpec(level: 4,  name: 'Gardien',        threshold: 500,   nextThreshold: 1000),
  LevelSpec(level: 5,  name: 'Brigadier',      threshold: 1000,  nextThreshold: 2000),
  LevelSpec(level: 6,  name: 'Lieutenant',     threshold: 2000,  nextThreshold: 4000),
  LevelSpec(level: 7,  name: 'Capitaine',      threshold: 4000,  nextThreshold: 8000),
  LevelSpec(level: 8,  name: 'Commandant',     threshold: 8000,  nextThreshold: 16000),
  LevelSpec(level: 9,  name: 'Commissaire',    threshold: 16000, nextThreshold: 32000),
  LevelSpec(level: 10, name: "Légende COP'IQ", threshold: 32000, nextThreshold: MAX_INT),
];
```

**Modèle `XpStatus` :** totalXp, level, levelName, xpIntoLevel, xpToNextLevel, levelProgressPercent, isMaxLevel, leveledUpFromPrevious(prev).
**Stream :** `XpService.stream` → émet à chaque `refresh()` (pour célébrer level-ups).

#### badges_service.dart
**Classe :** `BadgesService.instance`

**Tables Supabase :**
- `cas_pratique_badges` : catalog (slug, label, description, icon, color_hex, kind, sort_order)
- `cas_pratique_user_badges` : unlocks (user_id, badge_slug, unlocked_at, metadata)

**RPC Supabase :** `fn_cp_check_and_unlock_badges(uuid)` → retourne les nouveaux badges débloqués

**Modèles :**
```dart
class Badge { String slug, label, description, icon, colorHex, kind; int sortOrder; }
class UnlockedBadge { Badge badge; DateTime unlockedAt; Map<String, dynamic> metadata; }
```

**API :**
- `listAll()` → catalog complet
- `listMyUnlocks()` → unlocks de l'user (joints au catalog)
- `checkAndUnlock()` → appelle RPC SQL + émet les nouveaux via `newUnlocks` Stream

**Badges connus (inférés du web) :** first_quiz, first_cp, streak_7, perfect_score, xp_100, xp_500, premium

#### streaks_service.dart
**Classe :** `StreaksService.instance`
**RPC Supabase :** `fn_cp_compute_streak(uuid)`

**Modèle `StreakStatus` :**
```dart
class StreakStatus {
  final int count;
  final bool isAtRisk;
  final DateTime? lastActivityAt, brokenAt;
  final int availableFreezes;
  bool get isActive => count > 0;
  bool get isBroken => brokenAt != null;
  int? get nextMilestone { /* prochain dans [3,7,14,30,60,100,200,365] */ }
}
```

**Freezes :** jokers pour ne pas perdre le streak (availableFreezes).

#### leaderboard_service.dart
**Classe :** `LeaderboardService.instance`
**Cache mémoire :** 2 minutes (matview rafraîchie 1x/h)

**RPCs Supabase :**
- `fn_cp_get_leaderboard(p_limit)` → top N (anonymisés)
- `fn_cp_my_leaderboard_position()` → position de l'user courant

**Modèles :**
```dart
class LeaderboardEntry {
  int rank; String anonHandle; int weeklyXp, actionsCount; DateTime? lastActionAt; bool isSelf;
}
class MyLeaderboardPosition {
  bool inLeaderboard; int? rank, weeklyXp, actionsCount; String? anonHandle; int total; double? percentile;
}
```

#### referral_service.dart
**Classe :** `ReferralService.instance`
**RPCs Supabase :**
- `fn_cp_get_or_create_my_referral_code()` → code + stats
- `fn_cp_redeem_referral_code(p_code)` → applique le code (500 XP par filleul converti)

**Modèle `ReferralCodeStatus` :** code, createdAt, referralsCount, xpEarnedFromReferrals, xpPerReferral (500)
**`shareLink(baseUrl)`** → deeplink de partage

**Enum `RedeemError` :** notAuthenticated, invalidCode, codeNotFound, selfReferral, alreadyReferred, unknown

---

### 3.4 Paiements / Abonnements

#### payments_service.dart (lib/core/payments/)
**Classe :** `CpPayments.I` (singleton, interface pluggable)

**Enum `CpTier` :** `free | premiumTrial | premium`

**Modèle `CpSubscription` :**
```dart
class CpSubscription {
  String userId; CpTier tier; String status; bool cancelAtPeriodEnd;
  DateTime? currentPeriodStart, currentPeriodEnd, trialEndsAt;
  List<String> entitlements;
}
```

**Vue Supabase :** `cp_my_subscription`

**API :**
- `refreshTier()` → CpTier courant
- `startCheckout(priceId)` → launch Stripe Checkout (edge fn `cas_pratique_create_checkout`)
- `bindImpl(impl)` → point d'extension (tests / mocks). Stripe reste le seul provider de production.

#### subscription_service.dart (lib/core/cas_pratique/subscription/)
**Placeholder CODE-064 :** vérifie `user_metadata.cas_pratique_premium = true` (override dev).
À remplacer par le vrai check Stripe (CODE-084).

---

### 3.5 Notifications

#### cp_push_service.dart
**Classe :** `CpPushService.I` (singleton)
**Enum `CpNotifTopic` :**
```dart
enum CpNotifTopic {
  newCase('cp_new_case', 'Nouveaux cas', ...),
  streakRisk('cp_streak_risk', 'Alerte streak', ...),
  appealResult('cp_appeal_result', 'Résultat de tes appels', ...),
  leaderboard('cp_leaderboard', 'Classement hebdo', ...),
}
```

**Fonctionnalités :**
- Abonnement/désabonnement aux topics FCM par catégorie
- Opt-in granulaire (SharedPreferences + sync Supabase)
- Quiet hours : 22h→8h (heure locale, timezone Europe/Paris)
- Sauvegarde token FCM dans Supabase

**Modèle `CpNotifPrefs` :** `topics: Map<CpNotifTopic, bool>`, `quietStartHour=22`, `quietEndHour=8`

#### cp_notif_prefs_page.dart
**Widget :** Page de gestion des préférences de notifications.

---

### 3.6 Analytics

#### analytics_service.dart (lib/core/analytics/)
**Interface `CpAnalyticsInterface` :** (implémentation PostHog)

**Events produit :**
```dart
Future<void> identify(String? userId)
Future<void> caseOpened({ caseSlug, themeId, difficulty, totalQuestions })
Future<void> caseStarted({ caseSlug, attemptId, themeId, difficulty })
Future<void> questionAnswered({ caseSlug, attemptId, questionIndex, totalQuestions, answerLengthChars })
Future<void> questionValidated({ caseSlug, attemptId, questionIndex, scoreObtained, scoreMax, isCorrect })
Future<void> correctionShown({ caseSlug, attemptId, totalScore })
// etc.
```

**Règles PII :** Ne jamais envoyer le texte brut des réponses, nom, email, numéro. Uniquement UUIDs, slugs, scores, longueurs.

**Intégration :** `CpAnalytics.I.bind(postHogApiKey, postHogHost)` dans main.dart.

#### analytics_service.dart (lib/core/services/)
**Rôle :** Analytics globales de l'app (distincts du cas pratique analytics).

---

### 3.7 Widgets partagés

**Chemin :** `lib/core/widgets/` et `lib/core/cas_pratique/widgets/`

#### paywall_gate.dart
**Widget :** `PaywallGate(child, featureName, peek=true)`
**Rôle :** Wrapper de contenu premium. Si user free → overlay blurred + CTA abonnement. Si premium (owner bypass inclus) → child affiché.
**Écoute :** `SubscriptionService.instance.state` (refresh instantané post-paiement).

#### app_notifier.dart
**Classes :**
- `AppSettingsController` : dark/light mode, `ValueNotifier<ThemeMode>`
- `AppNotifier` : snackbar/toast manager global

#### quiz_limit_dialog.dart / quiz_report_dialog.dart / copiq_report_question_sheet.dart
**Widgets :** Dialogs pour limite quiz atteinte, signalement de question.

#### copiq_difficulty_selection_page.dart
**Widget :** Sélection de difficulté générique (utilisé par quiz classiques).

#### cas_pratique_scaffold.dart
**Widget :** Scaffold spécifique cas pratique (barre de progression, état de la tentative).

#### answer_text_area.dart
**Widget :** Zone de saisie de la réponse cas pratique (multi-ligne, compteur caractères).

#### appeal_sheet.dart
**Widget :** Bottom sheet pour contester une correction (appel d'une note).

#### score_reveal.dart
**Widget :** Animation de révélation du score final.

#### filter_chips_row.dart / multi_select_sheet.dart / sort_bottom_sheet.dart
**Widgets :** UI de filtrage et tri de la liste des cas pratiques.

#### point_pill.dart
**Widget :** Badge circulaire affichant les points obtenus sur un rubric_point.

#### cp_advanced_search_bar.dart
**Widget :** Barre de recherche avancée (filtres inline).

#### skeletons/skeleton_box.dart / skeleton_card.dart
**Widgets :** Placeholders de chargement animés.

---

## 4. CONTENU PÉDAGOGIQUE (lib/content/)

### 4.1 Structure générale du contenu

Le dossier `lib/content/` contient environ **1 400+ fichiers Dart** représentant les leçons et quiz intégrés dans l'app. Il y a 1636 fichiers Dart au total dans le projet.

**Deux types de fichiers :**
1. **Pages de cours** : widgets Flutter affichant du contenu pédagogique formaté (texte enrichi, tableaux, points clés). Nommés `*_page.dart` ou `*_contenu_page.dart`.
2. **Pages de quiz** : widgets affichant des QCM sur un thème donné. Nommés `quiz_*_page.dart`.

**Pattern commun des pages de quiz :**
```dart
// Exemple: quiz_classification_infractions_page.dart
class QuizClassificationInfractionsPage extends StatefulWidget {
  static const String routeName = '/gpx/quiz/generalites/classification_infractions';
}

// Données injectées (list de Question):
const List<Question> _questions = [
  Question(
    text: 'Question ?',
    options: ['A', 'B', 'C', 'D'],
    correctIndex: 2,
    explanation: 'Explication...',
  ),
  ...
];
```

**Pattern commun des pages de cours :**
```dart
class ClassificationInfractionsContenuPage extends StatelessWidget {
  // Affiche des sections LessonSection ou du texte formaté
  // Utilise RichText, ExpansionTile, Table pour structurer le contenu
}
```

---

### 4.2 Concours PA (Police Adjoint)

**Chemin racine :** `lib/content/pa_scolarite/`

#### institution_valeurs_pages/
Institutions, valeurs, organisation de la Police Nationale :
- `accueil_public_charte_victimes/` : charte Marianne, accueil des victimes
- `deontologie_code_commente/` : code de déontologie commenté
- `dgpn_dgsi_pp/` : DGPN, DGSI, Préfecture de Police
- `droits_obligations/` : droits et obligations du fonctionnaire
- `egalite_diversite_protections/` : égalité, diversité, non-discrimination
- `enquete_administrative/` : procédure d'enquête administrative
- `formation_initiale/` : programme de formation initiale PA
- `hierarchie_personnels/` : structure hiérarchique, grades
- `histoire_police/` : histoire de la Police Nationale
- `horaires_service_sp/` : horaires, service en période de sûreté publique
- `hors_service_intervenir/` : obligations d'intervention hors service
- `information_hierarchie_cr_rapports/` : comptes-rendus, rapports à la hiérarchie
- `laicite_religions/` : laïcité et fait religieux en service
- `memento_notes_methodo/` : méthodes de rédaction administrative
- `organisation_pn/` : organigramme Police Nationale
- `regles_emploi_pa/` : règles spécifiques au corps PA
- `respect_salut_presentation/` : protocole, présentation, salut
- `sanctions_recompenses/` : régime disciplinaire et récompenses
- `usage_reseaux_sociaux/` : usage des réseaux sociaux en qualité de policier

#### cadres_juridiques_pages/
Cadres d'enquête pénale pour la filière PA :
- `cadres_enquete/` : vue d'ensemble des cadres d'enquête
- `commission_rogatoire/` : commission rogatoire (délégation JI→OPJ)
- `controle_identite/` : contrôle d'identité (art. 78-2 CPP)
- `criminalite_deliquance/` : statistiques et cartographie
- `disparition/` : personnes disparues (procédures)
- `enquete_flagrant_delit/` : enquête de flagrant délit
- `enquete_preliminaire/` : enquête préliminaire
- `entraide_judiciaire/` : entraide judiciaire internationale
- `flagrant_delit/` : notion de flagrance
- `mort_inconnue/` : découverte de cadavre inconnu
- `personne_grievement_blessee/` : procédure personne grièvement blessée
- `personnes_en_fuite/` : personnes en fuite (procédures)
- `autres_cadres_enquete/` : autres cadres (instruction, PNA…)

#### atteintes_personnes_pages/
Infractions contre les personnes :
- `atteinte_personnalite/` : diffamation, injure, vie privée
- `atteinte_volontaire/` : violences volontaires
- `atteintes_involontaires/` : homicide et blessures involontaires
- `atteintes_volontaires_integrite/` : atteintes à l'intégrité physique (OVIC, ITT)
- `dignite_personne/` : harcèlement, discrimination
- `enregistrement_diffusion_images/` : droit à l'image
- `mise_en_danger/` : mise en danger de la vie d'autrui
- `viol_inceste_agressions/` : crimes sexuels

#### atteintes_biens_pages/
Infractions contre les biens :
- `contrefacons_falsifications/`
- `destructions_degradations/`
- `recel_non_justification/`
- `stad/` : STAD (Système de Traitement Automatisé de Données)
- `voisines_du_vol/` : extorsion, chantage, escroquerie, abus de confiance

#### atteintes_nation_pages/
Infractions contre la Nation :
- `abus_autorite/` : abus d'autorité, corruption passive/active
- `atteintes_action_justice/` : entrave à la justice
- `atteintes_administration/` : faux en écriture publique, détournement
- `faux_usage_faux/`
- `probite/` : favoritisme, prise illégale d'intérêts

#### procedure_penale_pages/
Procédure pénale spécifique PA :
- `pp_auditions_pv/`
- `pp_controle_identite/`
- `pp_gav/` : garde à vue
- `pp_infractions_specifiques/`
- `pp_mesures_contrainte/`
- `pp_perquisitions/`
- `pp_pv_regles/` : règles de rédaction des PV
- `pp_saisies_scelles/`

#### policier_intervention_pages/
**C'est le module le plus riche du PA.** Covers toutes les situations d'intervention :
- `accident_circulation/`, `accident_circulation_securite/`
- `alertes_bombe/`
- `autres/` : situations diverses
- `camera_pieton/` : utilisation de la caméra piéton
- `conduite_vp/` : conduite des véhicules de police
- `domicile/`, `domicile_violations_bruits_differend/`
- `enregistrement_diffusion_images/`
- `equipements_securite/` : gilet pare-balles, menottes
- `etre_filme_vp/` : conduite à tenir quand filmé
- `fichiers_fpr/` : fichiers de police (FPR, STIC, JUDEX)
- `formulaires_utiles/` : formulaires administratifs
- `gav_gestion/` : gestion de la garde à vue
- `indicateurs_basculement/` : basculement flagrance ↔ préliminaire
- `ipm/` : investigation de police militaire
- `main_courante_declaration/`
- `menottage/`
- `objets_bagages_suspects/`
- `palpation_securite/`
- `patrouille/`, `patrouille_radio_tph900/`
- `plans_orsec/`
- `poursuites_accidents_amaris/` : AMARIS (Accidents lors de Mission)
- `primo_intervenant_scene_infraction/`
- `prise_de_service/`, `prise_service_appel_registres/`
- `risque_evasion_amaris/`
- `securite_fouille_integrale/`
- `signalement_descriptif/` : signalement physique d'un individu
- `signaux_sonores_lumineux/` : avertisseurs sonores/lumineux
- `stupefiants_identification_detection/`
- `types_accidents_regulation/`
- `violences_conjugales_conduite/`

#### Autres modules PA :
- `armes_munitions_pages/` : classification, législation, sécurité
- `circulation_pages/` : code de la route spécifique police
- `dpg_pages/` : droit pénal général (loi pénale, responsabilité)
- `formation_initiale/`
- `institution_valeurs/` (ancienne structure, doublons)
- `libertes_publiques_pages/` : libertés individuelles, collectives, garanties
- `mineurs_famille_pages/` : mineur, autorité parentale, abandon
- `organisation_judiciaire_pages/`
- `organisation_pn/`
- `sanction_pages/` : causes aggravation, classification peines, pluralité
- `stupefiants_pages/`
- `tentative/`
- `quiz_scolarite_pa/` : quiz récapitulatifs PA

---

### 4.3 Concours GPX (Gardien de la Paix)

**Chemin racine :** `lib/content/gpx_scolarite/`

#### dps_dpg/ (Droit Pénal Spécialisé et Droit Pénal Général)
Le cœur du programme GPX.

**generalite_pages/ :**
- `classification_infractions/` : crimes/délits/contraventions
- `complicite/` : conditions, participation, répression
- `hierarchie_police/` : OPJ, APJ, APJA, assistants d'enquête
- `infraction/` : éléments légal/matériel/moral
- `legitime_defense/` : personnes, biens, cas présumés
- `libertés_publiques/` : collectives, garanties, individuelles, introduction
- `quizz_généralité/` : quiz sur toutes les généralités
- `retention_locaux_police/` : mesures administratives et judiciaires
- `tentative/` : conditions, répression, infructueuse
- `usage_des_armes/` : cadre légal L.435-1 CSI

**cadres_juridiques_pages/ :**
- `cadres_enquete/`
- `commission_rogatoire/` : perquisitions, fouilles, saisies, scellés, mandat recherche, GAV, réquisitions, violation
- `controle_identite/`
- `criminalite_deliquance/`
- `disparition/`
- `enquete_preliminaire/` : domaine, procédure, constatations, fouilles, GAV, audition, saisie comptes bancaires
- `entraide_judiciaire/`
- `flagrant_delit/` : notion, panorama, domaine, procédure
- `mort_inconnue/`
- `personne_grievement_blessee/`
- `personnes_en_fuite/`
- `quiz_cadres_juridiques/`

**crime_delit_bien_pages/ :** contrefaçons, destructions, recel, STAD, voisines du vol + quiz

**crime_delit_contre_personne_pages/ :** atteintes personnalité, volontaires, involontaires, dignité, enregistrement images, mise en danger, viol/agressions + quiz

**crime_delit_nation_pages/ :** abus autorité, atteintes justice/administration, faux, probité + quiz

**droit_pénale_général_pages/** + quiz

**sanction_pages/** : aggravation, pluralité + quiz

**stupéfiants_pages/**

**mineurs_famille_pages/**

**libertés_publiques_pages/**

**infraction_circulation_routière_pages/**

**armes_munitions_pages/**

**procédure_pénale_pages/** + quiz

#### institutions_valeurs/
- `accueil_public/`, `deontologie/`, `formation_initiale/`, `hierarchie_info/`, `histoire/`, `laicite/`
- `quiz_institutions_valeurs/`

#### memento_circulation/
Mémento spécifique aux infractions routières GPX :
- `controle_routier/`
- `equipements/`
- `procedures/`
- `regles_usage_voies/`

#### policier_intervention_initial/ et policier_intervention_avance/
Interventions terrain (initial = première année, avancé = deuxième année) :
- `accident_circulation/`
- `animal/` (intervention animaux dangereux)
- `autres/`
- `debit_boissons/`
- `domicile/`
- `etrangers/`
- `malades_mentaux/`
- `mineurs/`
- `patrouille/`
- `prise_de_service/`
- `stupefiants/`
- `formulaires_utiles/`

#### pv_apj20/
Rédaction de procès-verbaux (APJ 20°) :
- `audition_suspect/`, `circulation_routiere/` (alcool, contravention 5e, stupéfiants)
- `confrontation/`, `constatations/`, `controle_identite/`, `gav_suspect_libre/`
- `interpellation/`, `introduction/`, `ipm/`
- `perquisition_preliminaire/`, `plainte/`
- `procedures_speciales/etrangers/`
- `requisitions/`, `temoignage/`

#### shared/
- `institution_page.dart` : page institution partagée PA+GPX
- `procedure_penale_page.dart` : procédure pénale partagée

#### quiz_scolarite_gpx/
Quiz récapitulatifs GPX (tous modules).

---

### 4.4 Examens GPX

**Chemin :** `lib/content/gpx_exam/`

#### cas_pratique/
Pages et widgets du module Cas Pratiques :
- `cas_pratique_excercice/` : 6 cas statiques (case_1 à case_6) + `case_dynamic_page.dart` (cas depuis Supabase)
- `cas_pratique_list_confiug.dart` : configuration de la liste des cas
- `cas_pratique_onboarding.dart` : intro au module cas pratiques
- `cas_pratique_onboarding_premium.dart` : onboarding version premium
- `cas_pratique_welcome_page.dart` : page d'accueil des cas pratiques
- `concours_blanc_page.dart` : page concours blanc (variante cas pratique)
- `cp_privacy_page.dart` : politique de confidentialité cas pratiques
- `leaderboard_page.dart` : classement hebdomadaire
- `my_appeals_page.dart` : mes appels (contestations de notes)
- `pdf_exporter.dart` : export PDF de la correction
- `referral_page.dart` : page parrainage
- `share_score_page.dart` : partage du score sur réseaux sociaux
- `widgets/home_recommendation_widget.dart` : widget recommandation sur la home

#### culture_generale/
14 quiz de culture générale :
- `quiz_culture_generale_actualite.dart`
- `quiz_culture_generale_cinema.dart`
- `quiz_culture_generale_droit.dart`
- `quiz_culture_generale_france.dart`
- `quiz_culture_generale_geographie.dart`
- `quiz_culture_generale_histoire_france.dart`
- `quiz_culture_generale_institutions_europeens.dart`
- `quiz_culture_generale_musique.dart`
- `quiz_culture_generale_mythologie.dart`
- `quiz_culture_generale_police.dart`
- `quiz_culture_generale_sante.dart`
- `quiz_culture_generale_sciences.dart`
- `quiz_culture_generale_securite_routiere.dart`
- `quiz_culture_generale_sport.dart`

#### langue_etrangere/
- `quiz_langue_etrangere_allemand.dart`
- `quiz_langue_etrangere_anglais.dart`
- `quiz_langue_etrangere_espagnol.dart`

#### psycotechniques/
(Contenu statique, distincte du module dynamique dans `features/gpx_exam/psychotechniques/`)
- `attention_visuelle_page.dart`
- `quiz_tests_psycotechniques_calcul.dart`
- `quiz_tests_psycotechniques_concentration.dart`
- `quiz_tests_psycotechniques_raisonnement.dart`
- `quiz_tests_psycotechniques_suite_logiques.dart`
- `quiz_tests_psycotechniques_suite_verbal.dart`

#### structure_gpx_concours/
- `gpx_admissibilite_page.dart` : épreuves d'admissibilité
- `gpx_admission_page.dart` : épreuves d'admission
- `tableau_recapitulatif_epreuves_gpx_page.dart` : tableau récapitulatif complet

---

### 4.5 Réserve

**Chemin :** `lib/content/reserve_scolarite/`
- `introduction/` : introduction à la réserve citoyenne/opérationnelle

---

### 4.6 Paywall content

**Chemin :** `lib/content/paywall/`
Pages ou widgets spécifiques au paywall (accroches premium dans le contenu).

---

## 5. DONNÉES & MODÈLES

### 5.1 Modèles Flutter

#### Cas pratiques (lib/data/cas_pratique/models/cas_pratique_models.dart)

```dart
// Taxonomie
class CpTheme {
  final String id, slug, label, colorHex, icon;
  final int sortOrder;
}

// Difficulté
enum CpDifficulty { facile, moyen, difficile }

// Progression utilisateur sur un cas
class UserCaseProgress { /* best_score, attempts_count, last_attempt_at */ }

// Résumé de cas (liste)
class CaseSummary {
  final String id, slug, title;
  final String? themeId, themeLabel, themeColorHex;
  final CpDifficulty difficulty;
  final int? year;
  final bool isFree;
  final int questionsCount;
  final UserCaseProgress? userProgress;
  final DateTime? createdAt;
}

// Détail complet d'un cas
class CaseDetail extends CaseSummary {
  final String? contextMd;  // texte de mise en situation
  final List<CpQuestion> questions;
}

// Question
class CpQuestion {
  final String id, caseId, text;
  final int maxPoints, position;
  final List<RubricPoint> rubricPoints;
}

// Point de rubrique
class RubricPoint {
  final String id, questionId, label;
  final double weight;
  final bool isRequired;
  final String kind;   // 'keyword' | 'manual'
  final String? explanationMd;
  final int position;
  final List<KeywordGroup> keywordGroups;
}

// Tentative
class Attempt {
  final String id, userId, caseId;
  final String status;   // 'in_progress' | 'completed'
  final DateTime startedAt;
  final DateTime? submittedAt;
  final double? score;   // 0..maxPoints total
  final double? percent; // 0..100
}

// Réponse utilisateur
class Answer {
  final String id, attemptId, questionId, caseSlugLegacy;
  final int questionIndex;
  final String text;
  final bool isDraft;
  final DateTime? savedAt;
}

// Correction complète
class Correction {
  final String id, attemptId, caseId, userId;
  final double totalScore, maxScore, percent;
  final int timeSpentMs;
  final String engineVersion;
  final List<QuestionCorrection> questionCorrections;
  final DateTime correctedAt;
}

// Correction par question
class QuestionCorrection {
  final String questionId;
  final double score, maxPoints;
  final List<PointDetail> points;
}
```

#### Filtres (cas_pratique_filters.dart)
```dart
class CasPratiqueFilters {
  final Set<int> years;
  final Set<String> themeSlugs;
  final Set<CpDifficulty> difficulties;
  final bool notDone;  // filtrer les cas déjà complétés
}

enum CaseSortBy { recent, scoreAsc, scoreDesc, durationAsc, durationDesc, alphabetical }
```

---

### 5.2 Schéma Supabase inféré

Tables et vues identifiées dans le code :

#### Tables auth
```sql
-- Gérée par Supabase Auth
auth.users (id uuid, email, user_metadata jsonb, ...)

public.user_profiles (
  user_id uuid REFERENCES auth.users,
  user_mode text,         -- 'exam' | 'school'
  username text,
  role text,              -- 'owner' | 'admin' | 'moderator' | 'active' | 'user'
  updated_at timestamptz
)
```

#### Tables abonnement
```sql
public.subscription_payement (
  user_id uuid,
  plan text,              -- 'free' | 'week' | 'month' | 'year'
  status text,            -- 'active' | 'trial' | 'cancelled' | 'expired' | 'past_due'
  valid_until timestamptz,
  updated_at timestamptz
)

public.free_weekly_usage (
  user_id uuid,
  window_start timestamptz,
  used int,
  updated_at timestamptz
)

-- Vue enrichie (cas pratique)
cas_pratique_subscriptions (
  user_id uuid,
  tier text,              -- 'free' | 'premium' | 'premium_trial'
  status text,
  stripe_customer_id text,
  stripe_subscription_id text,
  stripe_price_id text,
  stripe_product_id text,
  current_period_start timestamptz,
  current_period_end timestamptz,
  cancel_at_period_end bool,
  canceled_at timestamptz,
  trial_ends_at timestamptz,
  entitlements text[],
  created_at, updated_at
)
```

#### Tables quiz
```sql
public.quiz_attempts (
  id int,
  uid uuid,
  email text,
  module_name text,
  quiz_name text,
  score int,
  total_questions int,
  correct_count int,
  completed_at timestamptz,
  started_at timestamptz,
  finished_at timestamptz
)

-- Tables psychotechniques (une par catégorie)
public.tests_psyco_calcul_mental (
  id, question text, options jsonb, answer text, explanation text,
  difficulty text, is_active bool, rand_key float
)
-- idem pour les 7 autres catégories
```

#### Tables cas pratiques
```sql
public.cas_pratique_cases (
  id uuid, title text, theme_id uuid, difficulty text,
  is_free bool, content text,
  created_at, updated_at
)

public.cas_pratique_questions (
  id uuid, case_id uuid, text text, max_points int, position int
)

public.cas_pratique_rubric_points (
  id uuid, question_id uuid, position int, label text,
  weight float, is_required bool, kind text, explanation_md text
)

public.cas_pratique_themes (
  id uuid, slug text, label text, color text, icon text, sort_order int
)

public.cas_pratique_attempts (
  id uuid, user_id uuid, case_id uuid,
  status text, started_at timestamptz, submitted_at timestamptz,
  score float, percent float, time_spent_ms int,
  total_score float, max_score float
)

public.cas_pratique_corrections (
  id uuid, attempt_id uuid, case_id uuid, user_id uuid,
  total_score float, max_score float, percent float,
  time_spent_ms int, engine_version text, corrected_at timestamptz
)

public.cas_pratique_correction_details (
  id uuid, correction_id uuid, question_id uuid,
  score float, max_points float, details jsonb
)

public.cas_pratique_user_progress (
  id uuid, user_id uuid, case_id uuid,
  best_score float, attempts_count int, last_attempt_at timestamptz
)

public.cas_pratique_user_bookmarks (
  id uuid, user_id uuid, case_id uuid, created_at timestamptz
)

public.cas_pratique_xp_ledger (
  id uuid, user_id uuid, amount int, reason text, created_at
)
```

#### Tables gamification
```sql
public.cas_pratique_badges (
  slug text PRIMARY KEY, label text, description text,
  icon text, color_hex text, kind text, sort_order int
)

public.cas_pratique_user_badges (
  user_id uuid, badge_slug text, unlocked_at timestamptz, metadata jsonb
)

-- Matview leaderboard (rafraîchie 1x/h)
public.cp_leaderboard_weekly (...) -- top users par XP semaine
```

#### Tables notes/memos
```sql
public.cas_pratique_user_notes (
  id uuid, user_id uuid, attempt_id uuid, question_id uuid,
  rubric_point_id uuid, case_id uuid, body text,
  tags text[], color text, created_at, updated_at
)

public.cas_pratique_memos (
  id uuid, slug text, title text, content_md text,
  tags text[], reading_time_minutes int, is_premium bool
)

public.cas_pratique_memo_reads (
  user_id uuid, memo_id uuid, read_at timestamptz, duration_seconds int
)
```

#### Tables forum
```sql
public.forum_posts_exam_gpx (
  id uuid, user_id uuid, content text, image_url text,
  created_at timestamptz
)
-- + jointure user_profiles pour le role/badge

-- Web :
public.forum_posts (id, category_id, author_id, title, content, likes_count, reply_count, pinned, locked, created_at)
public.forum_categories (id, slug, name, description, color, posts_count)
public.forum_replies (id, post_id, author_id, content, likes_count, is_hidden, created_at)
```

#### RPCs Supabase
```sql
is_user_premium(p_user_id uuid) → bool
consume_free_request() → json
get_my_entitlement() → json
fn_cp_xp_total(uuid) → json
fn_cp_compute_streak(uuid) → json
fn_cp_check_and_unlock_badges(uuid) → json[]
fn_cp_get_leaderboard(p_limit int) → table
fn_cp_my_leaderboard_position() → json
fn_cp_get_or_create_my_referral_code() → json
fn_cp_redeem_referral_code(p_code text) → json
cp_memo_mark_read(memo_id uuid, duration_seconds int) → void
```

#### Edge Functions Supabase
```
stripe-create-checkout       : {plan} → {url}
stripe-create-portal         : {} → {url}
stripe-cancel-subscription   : {} → {}
cas_pratique_correct_attempt : {user_id, scenario, answer, theme} → correction json
```

---

## 6. SITE WEB NEXT.JS

### 6.1 Architecture

**Chemin racine :** `/sessions/pensive-festive-cori/mnt/copiq-web/src/`

Structure Next.js 14 App Router avec groupes de routes :
```
src/
├── app/
│   ├── layout.tsx                     # Root layout (Providers, fonts)
│   ├── page.tsx                       # Landing page publique
│   ├── robots.ts / sitemap.ts
│   ├── globals.css                    # Variables CSS + reset
│   ├── (auth)/                        # Groupe auth (layout auth)
│   │   ├── layout.tsx
│   │   ├── login/page.tsx
│   │   ├── signup/page.tsx
│   │   └── forgot-password/page.tsx
│   ├── (dashboard)/                   # Groupe dashboard (layout sidebar)
│   │   ├── layout.tsx
│   │   ├── dashboard/page.tsx
│   │   ├── profil/page.tsx
│   │   ├── progression/page.tsx
│   │   ├── historique/page.tsx
│   │   ├── favoris/page.tsx
│   │   ├── abonnement/page.tsx
│   │   ├── parametres/page.tsx
│   │   ├── notifications/page.tsx
│   │   ├── forum/page.tsx
│   │   ├── forum/nouveau/page.tsx
│   │   ├── forum/post/page.tsx
│   │   ├── gpx/
│   │   │   ├── scolarite/page.tsx
│   │   │   ├── quiz/page.tsx
│   │   │   ├── quiz/[moduleId]/page.tsx + gpx-quiz-client.tsx
│   │   │   ├── cours/[moduleId]/page.tsx + gpx-cours-client.tsx
│   │   │   └── cas-pratiques/page.tsx
│   │   ├── pa/
│   │   │   ├── scolarite/page.tsx
│   │   │   ├── quiz/page.tsx
│   │   │   ├── quiz/[moduleId]/page.tsx + pa-quiz-client.tsx
│   │   │   └── cours/[moduleId]/page.tsx + pa-cours-client.tsx
│   │   ├── psychotechniques/
│   │   │   ├── page.tsx
│   │   │   └── [type]/page.tsx + psycho-client.tsx
│   │   ├── culture-generale/page.tsx
│   │   ├── langues/page.tsx
│   │   └── concours-blanc/page.tsx
│   ├── (public)/                      # Groupe public (layout minimal)
│   │   ├── layout.tsx
│   │   ├── blog/page.tsx + [slug]/page.tsx
│   │   ├── tarifs/page.tsx
│   │   ├── contact/page.tsx
│   │   ├── cgu/page.tsx
│   │   ├── privacy/page.tsx
│   │   └── beta/page.tsx
│   └── auth/callback/page.tsx
├── components/
│   ├── layout/
│   │   ├── sidebar.tsx
│   │   └── header.tsx
│   ├── providers.tsx
│   └── ui/
│       ├── badge.tsx, button.tsx, card.tsx
│       ├── progress.tsx, skeleton.tsx
│       └── theme-toggle.tsx
├── features/
│   ├── auth/
│   ├── cas-pratiques/
│   ├── concours-blanc/
│   ├── cours/
│   ├── dashboard/
│   ├── forum/
│   ├── landing/
│   ├── parametres/
│   ├── premium/
│   ├── profil/
│   ├── psychotechniques/
│   └── quiz/
├── hooks/
│   ├── use-auth.ts
│   └── use-subscription.ts
├── lib/
│   ├── stripe/client.ts
│   ├── supabase/client.ts + server.ts + middleware.ts
│   └── utils.ts
├── data/
│   ├── blog.ts
│   └── modules.ts               # Contenu statique PA + GPX (hardcodé en Dart côté mobile)
├── types/
│   ├── index.ts
│   └── supabase.ts
└── styles/globals.css
```

---

### 6.2 Layout global

#### app/layout.tsx
- Root layout Next.js
- Providers : `ThemeProvider` (next-themes), `Toaster` (react-hot-toast)
- Fonts : Instrument Sans (corps) + Sora ou similaire (titres)

#### app/(auth)/layout.tsx
Layout minimal pour les pages de connexion/inscription (fond plein, pas de sidebar).

#### app/(dashboard)/layout.tsx
Layout dashboard complet :
- `<Sidebar user tier />` : navigation latérale (desktop)
- `<Header user tier />` : barre du haut (mobile + desktop)
- Zone de contenu scrollable
- Vérification session côté serveur (redirect → /login si non connecté)
- Fetch du tier d'abonnement au chargement du layout

---

### 6.3 Pages publiques

#### app/page.tsx → LandingPage
**Composant :** `features/landing/landing-page.tsx`
**Sections :**
1. **Hero** : carrousel d'images (5 photos Supabase Storage), titre animé (Framer Motion), CTA "Commencer gratuitement" + "Voir les tarifs"
2. **Features flip cards** : 6 cartes retournables (Cours Juridiques, Quiz, Cas Pratiques IA, Psychotechniques, Culture Générale, Concours Blancs)
3. **Témoignages** : 3 témoignages avec scores et avatars DiceBear
4. **Tarifs** : plans Gratuit / Mensuel €8,99 / Annuel €86,99
5. **CTA final** : section inscription

**Assets :** images hébergées sur Supabase Storage (`nuoonagnkhbeeymtvrcn.supabase.co`)

#### app/(public)/tarifs/page.tsx
Page tarifs standalone (plans, comparaison, FAQ).

#### app/(public)/blog/page.tsx + [slug]/page.tsx
Blog statique — données depuis `src/data/blog.ts`.

#### app/(public)/contact/page.tsx, cgu/page.tsx, privacy/page.tsx
Pages légales et contact.

#### app/(public)/beta/page.tsx
Page d'accès bêta.

---

### 6.4 Pages authentifiées (dashboard)

#### dashboard/page.tsx → DashboardContent
**Props :** `{ user, sub, totalXp, freeQuota }`
**Contenu :**
- Salutation + bouton "Passer Premium" si free
- Grille stats (XP, Abonnement, Quota semaine, Streak)
- Grille modules (6 tuiles : PA, GPX, Cas Pratiques, Culture Générale, Psychotechniques, Concours Blanc)
- Section "Progression rapide" avec barre XP niveau

**Logique :**
- `tier = sub?.tier ?? 'free'`
- `isPremium = tier === 'premium' || tier === 'premium_trial'`
- `freeRemaining = Math.max(0, 10 - (freeQuota?.used ?? 0))`

#### gpx/scolarite/page.tsx
Hub GPX Scolarité : liste des modules disponibles (avec locks premium).

#### gpx/quiz/page.tsx → QuizSelectionPage
**Composant :** `features/quiz/quiz-selection.tsx`
**Props :** `{ track: 'gpx', tier }`

**Modules GPX (12) :**
- Culture Générale (500q, gratuit), Droit Pénal (120q, gratuit), Procédure Pénale (150q, gratuit), Institutions (80q, gratuit)
- Cadres Juridiques (200q, premium), Policier & Intervention (180q, premium)
- Psychotechniques (300q, premium), Langues (150q, premium)
- Armes (60q, premium), Stupéfiants (70q, premium)
- Circulation (100q, premium), Mineurs (80q, premium)

**Total : ~1 760 questions GPX**

#### gpx/quiz/[moduleId]/page.tsx + gpx-quiz-client.tsx
**Composant client :** `features/quiz/quiz-engine.tsx`
**Fonctionnement :**
- Chargement questions depuis `DEMO_QUESTIONS` (statique) ou Supabase (en production)
- Affichage question par question avec options A/B/C/D
- Feedback immédiat (correct/incorrect + explication)
- Score final avec CTA (recommencer, voir cours, autres quiz)
- Sauvegarde dans `quiz_attempts` Supabase

**Questions actuelles :** statiques hardcodées (droit-penal : 5q, procedure-penale : 3q, culture-generale : 2q). Migration vers Supabase prévue.

#### gpx/cours/[moduleId]/page.tsx + gpx-cours-client.tsx
**Fonctionnement :**
- `getModuleById(moduleId)` depuis `src/data/modules.ts`
- Vérification auth + tier Supabase côté client
- Si module premium + free → `CoursReader` affiche paywall
- Navigation breadcrumb : Dashboard → GPX Scolarité → Module

#### pa/quiz/, pa/cours/, pa/scolarite/
Mêmes patterns que GPX mais pour la filière PA. Modules PA (12) avec ~1 230 questions.

#### gpx/cas-pratiques/page.tsx
**Composant :** `features/cas-pratiques/cas-pratiques-interface.tsx`
**Props :** `{ userId, tier, freeUsed, freeTotal, recentAttempts, userEmail }`

**Phases :** `idle → writing → submitting → result`

**Flux :**
1. `idle` : choix du thème (6 thèmes : Vol, Violences, Stupéfiants, Routier, Procédure, Déontologie) + bouton "Générer un scénario"
2. `writing` : affichage du scénario + textarea réponse (min 100 chars)
3. `submitting` : appel edge function `cas_pratique_correct_attempt`
4. `result` : affichage de la correction (score, points détaillés, feedback)

**Quota :** 10 cas/semaine gratuit. Premium = illimité. Gestion côté edge function avec `quota_exceeded` error.

#### psychotechniques/page.tsx
Hub psychotechniques : 3 types disponibles (calcul, suites-logiques, raisonnement). Autres "bientôt disponibles".

#### psychotechniques/[type]/page.tsx + psycho-client.tsx
**Composant :** `features/psychotechniques/psycho-exercice.tsx`
**Paramètre `type` :** `calcul | suites-logiques | raisonnement`

**Générateurs locaux (côté client, pas Supabase) :**
- `genCalcul()` : opération aléatoire (+/-/×/÷) avec 4 choix
- `genSuiteLogique()` : suite arithmétique
- `genRaisonnement()` : syllogismes (3 hardcodés)

**Chrono :** 60 secondes, score en fin de session.

#### forum/page.tsx
**Composant :** `features/forum/forum-list.tsx`
**Fonctionnalités :**
- Filtrage par catégorie (chips)
- Liste des posts (titre, extrait, compteur réponses, date, pin)
- Navigation vers `/forum/[id]`

#### forum/nouveau/page.tsx → `features/forum/new-post-form.tsx`
Formulaire de création de post (titre + contenu + catégorie).

#### forum/post/page.tsx → `features/forum/forum-post.tsx`
Affichage d'un post + ses réponses.

#### abonnement/page.tsx → AbonnementContent
**Composant :** `features/premium/abonnement-content.tsx`
**Plans :** week (€4,99), month (€8,99 + essai 1 sem), year (€86,99 économie 20%)

**Flux paiement :**
```typescript
handleSubscribe(plan) → POST /api/stripe/checkout → { url } → window.location.href = url
handlePortal() → POST /api/stripe/portal → { url } → window.location.href = url
```

**Affiche :**
- Notification succès/annulation (query params `?success=1` ou `?canceled=1`)
- Abonnement actuel (plan, statut, date renouvellement, cancel_at_period_end)
- Cards 3 plans avec CTA
- Bouton "Portail Stripe" si abonné

#### profil/page.tsx → ProfilContent
**Composant :** `features/profil/profil-content.tsx`
**Sections :**
- Header avec avatar initiales + gradient Police bleu
- Barre XP + niveau (7 seuils : 0/100/250/500/1000/2000/5000)
- Grille stats (XP, Niveau, Modules, Badges)
- Galerie badges avec métadonnées (first_quiz, streak_7, perfect_score…)
- Progression par module

#### progression/page.tsx
Statistiques avancées de progression (graphiques, historique).

#### historique/page.tsx
Historique de toutes les tentatives de quiz.

#### favoris/page.tsx
Favoris (bookmarks de cas pratiques).

#### parametres/page.tsx → `features/parametres/parametres-content.tsx`
Paramètres : thème, notifications, compte.

#### notifications/page.tsx
Centre de notifications.

---

### 6.5 Pages auth

#### (auth)/login/page.tsx → `features/auth/login-form.tsx`
Formulaire email/password. Supabase `signInWithPassword()`. Redirect vers `/dashboard`.

#### (auth)/signup/page.tsx → `features/auth/signup-form.tsx`
Formulaire inscription. Supabase `signUp()`. Email verification flow.

#### (auth)/forgot-password/page.tsx → `features/auth/forgot-password-form.tsx`
Email de reset. Supabase `resetPasswordForEmail()`.

#### auth/callback/page.tsx
Callback OAuth/magic link. Gère l'échange code → session Supabase.

---

### 6.6 Composants partagés

#### components/layout/sidebar.tsx
**Props :** `{ user: User, tier: CpTier }`
**Sections de navigation :**
1. (sans titre) : Dashboard, Progression, Historique, Favoris
2. "Policier Adjoint" : Scolarité PA, Quiz PA, Cours PA (premium)
3. "Gardien de la Paix" : Scolarité GPX, Quiz GPX, Cas Pratiques (premium), Culture Générale, Psychotechniques, Langues, Concours Blanc (premium)
4. "Communauté" : Forum, Notifications

**Premium section :**
- Si premium : badge "Premium actif" gradient brand
- Si free : CTA "Passer Premium" avec couronne

#### components/layout/header.tsx
**Props :** `{ user: User, tier: CpTier }`
**Éléments :** toggle dark/light, notifications bell, menu utilisateur (profil, paramètres, déconnexion)

#### components/providers.tsx
```tsx
<ThemeProvider attribute="class" defaultTheme="system" enableSystem>
  {children}
  <Toaster position="top-right" toastOptions={{ ... }} />
</ThemeProvider>
```

#### components/ui/
- `button.tsx` : variants (default, outline, ghost, premium)
- `card.tsx` : card avec prop `hover` (shadow au survol)
- `badge.tsx` : badges colorés
- `progress.tsx` : barre de progression
- `skeleton.tsx` : placeholder chargement
- `theme-toggle.tsx` : bouton toggle thème

#### features/cours/cours-reader.tsx
**Props :** `{ module: CourseModule, tier: string, userEmail?: string }`

**Anti-copie :**
- `contextmenu` désactivé sur le contenu
- Raccourcis clavier (Ctrl+C/A/S/P/U) bloqués
- Watermark via `data-watermark={userEmail}` (CSS)

**Paywall inline :** si `module.isPremium && !isPremium` → écran lock avec CTA.

**Rendu Markdown :** parser maison (regex) — pas de dépendance `flutter_markdown`/`react-markdown`.

---

### 6.7 Hooks

#### hooks/use-auth.ts
```typescript
function useAuth(): { user: User | null, loading: boolean, supabase: SupabaseClient }
```
- `supabase.auth.getUser()` au mount
- Listener `onAuthStateChange` pour les changements de session
- Nettoyage `subscription.unsubscribe()` au démontage

#### hooks/use-subscription.ts
```typescript
function useSubscription(userId: string | undefined): { tier: string, loading: boolean }
```
- Requête `cas_pratique_subscriptions` Supabase pour `tier`
- Par défaut : `"free"` si aucune entrée

---

### 6.8 Configuration & Infrastructure

#### lib/supabase/client.ts
```typescript
function createClient(): SupabaseClient<Database>
// Runtime config : window.COPIQ_CONFIG (chargé depuis /copiq-config.js)
// Fallback : env vars NEXT_PUBLIC_SUPABASE_URL + NEXT_PUBLIC_SUPABASE_ANON_KEY
```

#### lib/supabase/server.ts
```typescript
const createClient = makeClient(url, anon_key)        // Client RSC (cookies)
const createServiceClient = makeClient(url, service_key) // Admin (service role)
```
Utilise `@supabase/ssr` avec `cookies()` de `next/headers`.

#### lib/supabase/middleware.ts
```typescript
async function updateSession(request: NextRequest): Promise<{ supabaseResponse, user }>
```
Rafraîchit la session Supabase à chaque requête via cookies. Retourne l'user pour les redirections.

#### lib/stripe/client.ts
```typescript
function getStripe(): Stripe   // singleton
// Stripe('STRIPE_SECRET_KEY', { apiVersion: '2026-06-24.dahlia' })
```

#### lib/utils.ts
```typescript
cn(...inputs)                      // clsx + tailwind-merge
formatDate(date, options?)         // fr-FR locale
formatPercent(value)
formatScore(correct, total)
getInitials(name)
truncate(str, maxLength)
pluralize(count, singular, plural)

TIER_LABELS = { free: "Gratuit", premium: "Premium", premium_trial: "Essai Premium" }
PLAN_LABELS = { week: "Hebdomadaire", month: "Mensuel", year: "Annuel" }
PLAN_PRICES = { week: "4,99 €/sem", month: "8,99 €/mois", year: "86,99 €/an" }
```

#### data/modules.ts
Contenu cours statique PA + GPX hardcodé (en Dart dans lib/content/ côté mobile) :
- `PA_COURSE_MODULES` : 5 modules (Droit Pénal, Procédure Pénale, Droit Administratif, Institutions, Déontologie)
- `GPX_COURSE_MODULES` : 3 modules (Droit Pénal Approfondi, Procédure Pénale Avancée, Sécurité Intérieure)
- Sections avec contenu Markdown inline (très complet)
- `getModuleById(id)`, `getAllModules()`

#### types/supabase.ts
Types TypeScript manuels des tables Supabase (à synchroniser avec `supabase gen types`).

#### types/index.ts
Types globaux de l'app :
```typescript
interface UserProfile { id, email, full_name, avatar_url, tier, xp, created_at }
interface QuizQuestion { id, text, options, correctIndex, explanation?, category? }
interface QuizAttempt { id, uid, moduleName, quizName, score, totalQuestions, correctCount, ... }
interface CourseModule { id, slug, title, description, category, isPremium, sections, color? }
interface CourseSection { id, title, content, order }
interface Subscription { userId, tier, status, currentPeriodEnd, cancelAtPeriodEnd, ... }
interface ForumPost { id, categoryId, authorId, authorName, title, content, ... }
type CpTier = 'free' | 'premium' | 'premium_trial'
type CopiqPlan = 'week' | 'month' | 'year'
```

---

## 7. FONCTIONNALITÉS CLÉS — DESCRIPTION DÉTAILLÉE

### 7.1 Système de quiz

**Mobile (Flutter) :**
- Questions stockées **statiquement dans lib/content/** (fichiers Dart, listes `const List<Question>`)
- Format `Question(text, options, correctIndex, explanation)` — pas de modèle global unique
- Chaque quiz est un StatefulWidget indépendant avec son propre état
- Historique sauvegardé dans Supabase (`quiz_attempts`)
- Limite de tentatives pour les free users (via `consume_free_request()`)
- Difficulté sélectionnable avant certains quiz (via `CopiqDifficultySelectionPage`)
- Signalement de question via `CopiqReportQuestionSheet`

**Web (Next.js) :**
- Questions actuellement **hardcodées** dans `quiz-engine.tsx` (DEMO_QUESTIONS)
- En production : chargement depuis Supabase (même tables que mobile)
- Module IDs : `droit-penal`, `procedure-penale`, `culture-generale`, etc.
- Score calculé localement, sauvegardé via Supabase client

---

### 7.2 Système d'abonnement / Paywall

**Plans :**
| Plan | Prix | Durée |
|------|------|-------|
| Gratuit | 0€ | Permanente |
| Hebdomadaire | 4,99€/sem | 7 jours |
| Mensuel | 8,99€/mois | 1 mois (essai 1 sem) |
| Annuel | 86,99€/an | 12 mois (éco. ~20%) |

**Quota gratuit :** 10 cas pratiques / 7 jours glissants. Toutes les autres fonctionnalités (quiz de base, cours intro, forum) sont gratuites.

**Flux paiement mobile :**
1. User tape "S'abonner" → `StripePaymentService.instance.startCheckout(plan)`
2. Edge function `stripe-create-checkout` crée une Stripe Checkout Session
3. `url_launcher` ouvre le navigateur externe → page Stripe
4. Stripe redirige vers deep link app (`copiqpolice://payment-success`)
5. App resume → `SubscriptionService.refresh()` → RPC `is_user_premium` → mise à jour état

**Flux paiement web :**
1. User clique CTA → `POST /api/stripe/checkout { plan }`
2. Stripe Checkout Session créée → redirect `window.location.href = url`
3. Stripe webhook → mise à jour `cas_pratique_subscriptions`
4. Redirect vers `/abonnement?success=1`

**Gating mobile :**
- `PremiumGuard` : `canAccessPremiumContent(SubscriptionService.state.value)` → redirect `/premium-required`
- `PaywallGate` widget : overlay blurred + CTA si free
- Owner role bypass : `Entitlement.isOwner` → toujours premium

**Gating web :**
- `module.isPremium && !isPremium` → CoursReader affiche écran lock
- Quiz modules premium → lock icon + lien `/abonnement`
- Cas pratiques → quota check côté edge function

---

### 7.3 Cas pratiques (moteur IA)

**Concept :** L'utilisateur reçoit un scénario policier (mise en situation réelle) et doit rédiger une réponse complète (procédure à suivre, infractions identifiées, actes à rédiger). L'IA corrige et note sur 15.

**Architecture correction :**
```
Réponse utilisateur
    ↓
Normalisation (accents, casse, ponctuation)
    ↓ Tokenizer → Normalizer → Lemmatizer
Tokens normalisés
    ↓ Synonym Resolver (table synonyms_dictionary)
Tokens enrichis
    ↓ Negation Detector
Tokens filtrés
    ↓ KeywordMatcher (distance Levenshtein)
Pour chaque rubric_point :
    ↓ KeywordGroup matching (OR entre groupes, AND au sein d'un groupe)
    ↓ PointEvaluator (matched ? weight : 0)
Score question = somme(weights) / max_points × max_points
Score total = somme(questions) / 15
```

**Stockage résultats :**
- `cas_pratique_corrections` : score global
- `cas_pratique_correction_details` : score par question avec détail des rubric_points
- `cas_pratique_xp_ledger` : XP gagnés

**Fonctionnalités complémentaires :**
- **Appels (Appeals)** : l'utilisateur peut contester une correction → modération admin
- **Leaderboard** : classement hebdomadaire anonymisé (handles aléatoires, XP semaine)
- **Concours blancs** : 10 questions officielles en 30 minutes
- **Export PDF** : `pdf_exporter.dart` (résumé correction)
- **Partage** : `share_score_page.dart` (image générée)
- **Fiches mémo** : fiches de révision liées aux thèmes des cas (`cp_memos_page.dart`)
- **Notes personnelles** : annotations sur les corrections (`cp_user_notes_service.dart`)

---

### 7.4 Forum communautaire

**Mobile :** `ForumEspaceExamGPXPage`
- Table `forum_posts_exam_gpx`
- Rôles : user/active/moderator/admin avec badges visuels
- Features : création, upload image, recherche, report, block, modération

**Web :** `ForumList` + `ForumPost` + `NewPostForm`
- Tables `forum_posts` + `forum_categories` + `forum_replies`
- Filtrage par catégorie
- 6 catégories : général, droit-pénal, procédure, psychotechniques, annonces, cas-pratiques

**Modération :**
- Mute temporaire ou permanent avec raison
- Masquage de messages (is_hidden)
- Épinglage de posts (pinned)
- Verrou de discussion (locked)

---

### 7.5 Psychotechniques

**8 types d'exercices mobile (Supabase) :**
1. Calcul mental chronométré
2. Logique verbale (syllogismes, analogies)
3. Raisonnement logique (déductions)
4. Raisonnement spatial (figures)
5. Rotations et symétries (cubes 3D)
6. Concentration (matrices, attention)
7. Attention visuelle (repérage)
8. Suites logiques (numérique/figurative)

**3 types web (générateur local) :**
1. Calcul : ops aléatoires +/-/×/÷
2. Suites logiques : progression arithmétique
3. Raisonnement : 3 syllogismes hardcodés

**Paramètres :** 3 niveaux de difficulté, timer par question (30s mobile, 60s total web), 10 questions/session.

**Historique :** sauvegardé dans `psycho_history` (mobile) et `quiz_attempts` (web).

---

### 7.6 Système XP / Gamification

**Sources d'XP :**
- Correction d'un cas pratique (selon score)
- Réussite d'un quiz
- Lecture d'une fiche mémo (`cp_memo_mark_read`)
- Parrainage (500 XP/filleul)
- Streak daily (bonus quotidien)

**Niveaux (10 paliers) :** Recrue (0) → Légende COP'IQ (32000+)

**Badges :** débloqués automatiquement via RPC `fn_cp_check_and_unlock_badges()` après chaque action.

**Streak :** calculé par `fn_cp_compute_streak()`. Freezes = jokers pour préserver le streak. Alerte "at risk" avant minuit si pas d'activité.

**Leaderboard :** matview rafraîchie 1x/heure, top N anonymisés (handles aléatoires), position personnelle avec percentile.

---

### 7.7 Placement test

**But :** évaluer le niveau initial de l'utilisateur post-inscription pour personnaliser les recommandations.

**Algorithme IRT adaptatif simplifié :**
- 3 niveaux de difficulté (easy/medium/hard)
- 6 questions par domaine
- Ajustement dynamique selon les réponses
- Score pondéré → résultat : Fondamentaux insuffisants / Intermédiaire / Bon niveau / Avancé

**Questions :** base statique Dart (pas Supabase), plusieurs domaines du programme.

---

## 8. GUIDE D'ADAPTATION WEB

### 8.1 Ce qui existe déjà sur le web

| Fonctionnalité mobile | Statut web |
|----------------------|------------|
| Auth (login/signup/reset) | FAIT — Supabase SSR |
| Dashboard accueil | FAIT — dashboard-content.tsx |
| Quiz PA + GPX (modules libres) | FAIT — quiz-engine.tsx (questions statiques) |
| Cours PA + GPX | FAIT — cours-reader.tsx (contenu data/modules.ts) |
| Cas pratiques (interface basique) | FAIT — cas-pratiques-interface.tsx |
| Forum | FAIT — forum-list.tsx + forum-post.tsx |
| Psychotechniques (3 types) | FAIT — psycho-exercice.tsx (générateur local) |
| Abonnement / Paywall Stripe | FAIT — abonnement-content.tsx |
| Profil utilisateur | FAIT — profil-content.tsx |
| Paramètres | FAIT — parametres-content.tsx |
| Landing page | FAIT — landing-page.tsx |
| Dark/light mode | FAIT — next-themes |
| Sidebar + Header responsive | FAIT |

### 8.2 Ce qui manque sur le web

| Fonctionnalité mobile | À implémenter sur web | Priorité |
|----------------------|----------------------|----------|
| Quiz depuis Supabase (5000+ questions) | Remplacer DEMO_QUESTIONS par fetch Supabase | HAUTE |
| Tous les modules quiz (12 GPX, 12 PA) | Étendre quiz-selection.tsx → routes dynamiques | HAUTE |
| Psychotechniques depuis Supabase (8 types) | Réécrire psycho-exercice.tsx → PsychoQuestionService web | HAUTE |
| Système XP en temps réel | Afficher XP gagné après action, level-up animation | HAUTE |
| Gamification (badges, streaks) | Pages/widgets dédiés | MOYENNE |
| Leaderboard | Page `/leaderboard` | MOYENNE |
| Bookmarks cas pratiques | Service CpBookmarks adapté | MOYENNE |
| Notes personnelles | Service CpUserNotes adapté | MOYENNE |
| Fiches mémo | Page `/memos` | MOYENNE |
| Mode scolarité / mode concours | Pas de distinction mode sur web | MOYENNE |
| Filières PA vs GPX switchable | Le web sépare déjà PA et GPX | FAIBLE |
| Notifications push | Web Push API ou email | FAIBLE |
| Export PDF correction | react-pdf ou similar | FAIBLE |
| Partage score | Web Share API | FAIBLE |
| Test de placement | Page `/placement` | FAIBLE |
| Mode Réserve | Non prévu sur web pour l'instant | —— |
| Concours blanc complet | Page `/concours-blanc` (existe, à étoffer) | MOYENNE |

### 8.3 Mapping routes mobile → web

| Route mobile | Route web |
|-------------|-----------|
| `/picker` | Sélection mode via Dashboard |
| `/home-gpx-exam` | `/dashboard` (tab GPX) |
| `/home_pa_school` | `/pa/scolarite` |
| `/abonnement` | `/abonnement` |
| `/favoris` | `/favoris` |
| `/gpx/generalites/classification_infractions` | `/gpx/cours/droit-penal-gpx` (section) |
| `/gpx/quiz/...` | `/gpx/quiz/[moduleId]` |
| `/cas-pratique/...` | `/gpx/cas-pratiques` |
| `/cas-pratique/memos` | À créer `/memos` |
| `/leaderboard` | À créer `/leaderboard` |
| Forum GPX | `/forum` |

### 8.4 Considérations d'adaptation

**Contenu pédagogique :**
Le contenu PA et GPX est actuellement dans 1400+ fichiers Dart statiques sur mobile. Pour le web, deux approches :
1. **Migration progressive** : port du contenu vers `data/modules.ts` (déjà commencé) — long mais simple
2. **Supabase CMS** : stocker le contenu en DB (tables `course_sections` avec markdown) et le charger dynamiquement — scalable mais plus complexe

**Mode de navigation :**
Sur mobile, l'utilisateur choisit un mode (scolarité/concours) et une filière (PA/GPX), puis navigue dans ce contexte. Sur web, la sidebar expose toutes les filières directement (plus simple, adapté au grand écran).

**Quiz depuis Supabase :**
Les tables de quiz mobile (`quiz_attempts`, questions statiques en Dart) doivent être migrées vers des tables Supabase pour le web. Pattern recommandé :
```sql
-- Table quiz_questions (à créer)
CREATE TABLE quiz_questions (
  id uuid DEFAULT gen_random_uuid(),
  module_id text,      -- ex: 'droit-penal-pa'
  track text,          -- 'pa' | 'gpx'
  text text,
  options text[],
  correct_index int,
  explanation text,
  difficulty text,
  is_active bool DEFAULT true,
  rand_key float DEFAULT random()
);
```

**Psychotechniques Supabase sur web :**
Les tables `tests_psyco_*` (8 tables) existent dans Supabase. Le web peut les requêter directement (même logique que le service Flutter, portée en TypeScript).

**Gamification :**
Les RPCs Postgres (`fn_cp_xp_total`, `fn_cp_compute_streak`, etc.) sont accessibles depuis le web via `supabase.rpc('fn_cp_xp_total', { uuid: userId })`. Aucune réécriture côté backend nécessaire.

**Temps réel :**
Supabase Realtime (canaux) peut être utilisé côté web pour les mêmes fonctionnalités qu'en mobile (leaderboard live, streak alerts, nouvelles corrections d'appels).


---

## 9. CARTOGRAPHIE COMPLÈTE DES COURS

> **Instructions pour l'IA** : Cette section liste chaque page de cours de l'application mobile Flutter avec son chemin exact. Pour créer la version web d'un cours :
> 1. Lis le fichier Dart indiqué (il contient le texte, les sous-sections, et parfois un quiz)
> 2. Copie-colle le contenu textuel des sections `LessonSection`, `RichText`, `Text()`, ou des listes `_cards` dans le composant Next.js correspondant
> 3. Crée une page web sous `src/app/(dashboard)/[concours]/scolarite/[module]/page.tsx`
> 4. Chaque page doit avoir : titre, contenu en prose, bouton quiz si applicable

---

### 9.1 CONCOURS PA — POLICE ADJOINT (`lib/content/pa_scolarite/`)

#### Institutions & Valeurs (`institution_valeurs_pages/`)

| Titre lisible | Fichier source (relatif à lib/) |
|---|---|
| Hub institutions & valeurs | content/pa_scolarite/institution_valeurs_pages/institution_valeurs_page.dart |
| Accueil public & charte victimes | content/pa_scolarite/institution_valeurs_pages/accueil_public_charte_victimes/accueil_public_charte_victimes_page.dart |
| Déontologie — code commenté | content/pa_scolarite/institution_valeurs_pages/deontologie_code_commente/deontologie_code_commente_page.dart |
| DGPN, DGSI, Préfecture de Police | content/pa_scolarite/institution_valeurs_pages/dgpn_dgsi_pp/dgpn_dgsi_pp_page.dart |
| Droits & obligations du policier | content/pa_scolarite/institution_valeurs_pages/droits_obligations/droits_obligations_page.dart |
| Égalité, diversité, protections | content/pa_scolarite/institution_valeurs_pages/egalite_diversite_protections/egalite_diversite_protections_page.dart |
| Enquête administrative | content/pa_scolarite/institution_valeurs_pages/enquete_administrative/enquete_administrative_page.dart |
| Formation initiale PA | content/pa_scolarite/institution_valeurs_pages/formation_initiale/formation_initiale_page.dart |
| Hiérarchie des personnels | content/pa_scolarite/institution_valeurs_pages/hierarchie_personnels/hierarchie_personnels_page.dart |
| Histoire de la Police Nationale | content/pa_scolarite/institution_valeurs_pages/histoire_police/histoire_police_page.dart |
| Horaires de service — service public | content/pa_scolarite/institution_valeurs_pages/horaires_service_sp/horaires_service_sp_page.dart |
| Intervenir hors service | content/pa_scolarite/institution_valeurs_pages/hors_service_intervenir/hors_service_intervenir_page.dart |
| Information hiérarchie — CR & rapports | content/pa_scolarite/institution_valeurs_pages/information_hierarchie_cr_rapports/information_hierarchie_cr_rapports_page.dart |
| Laïcité & religions | content/pa_scolarite/institution_valeurs_pages/laicite_religions/laicite_religions_page.dart |
| Mémento prise de notes & méthodologie | content/pa_scolarite/institution_valeurs_pages/memento_notes_methodo/memento_notes_methodo_page.dart |
| Organisation de la Police Nationale | content/pa_scolarite/institution_valeurs_pages/organisation_pn/organisation_pn_page.dart |
| Règles d'emploi du PA | content/pa_scolarite/institution_valeurs_pages/regles_emploi_pa/regles_emploi_pa_page.dart |
| Respect, salut & présentation | content/pa_scolarite/institution_valeurs_pages/respect_salut_presentation/respect_salut_presentation_page.dart |
| Sanctions & récompenses | content/pa_scolarite/institution_valeurs_pages/sanctions_recompenses/sanctions_recompenses_page.dart |
| Usage des réseaux sociaux | content/pa_scolarite/institution_valeurs_pages/usage_reseaux_sociaux/usage_reseaux_sociaux_page.dart |

#### Formation initiale (`formation_initiale/`)

| Titre lisible | Fichier source |
|---|---|
| Formation initiale policier adjoint | content/pa_scolarite/formation_initiale/formation_initiale_policier_adjoint_page.dart |
| Mémento prise de notes — méthodologie | content/pa_scolarite/formation_initiale/memento_prise_de_notes_methodologie_page.dart |

#### Droit Pénal Général — DPG (`dpg_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub DPG | content/pa_scolarite/dpg_pages/dpg_page.dart |
| Classification des infractions | content/pa_scolarite/dpg_pages/classification_infractions_contenu_page.dart |
| Classification infractions — loi pénale | content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart |
| Éléments constitutifs de l'infraction | content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart |
| Étendue application des lois | content/pa_scolarite/dpg_pages/gpx_school_etendue_application_lois_page.dart |
| Généralités législation pénale | content/pa_scolarite/dpg_pages/gpx_school_generalites_legislation_penale_page.dart |
| Responsabilité pénale — causes d'irresponsabilité | content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_causes_irresponsabilite_page.dart |
| Responsabilité pénale — complicité & coaction | content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart |
| Responsabilité pénale — personnes morales | content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_personnes_morales_page.dart |
| Responsabilité pénale — principes généraux | content/pa_scolarite/dpg_pages/gpx_school_responsabilite_penale_principes_generaux_page.dart |
| Loi pénale (sous-page) | content/pa_scolarite/dpg_pages/loi_penale/loi_penale_page.dart |
| Loi pénale — contenu | content/pa_scolarite/dpg_pages/loi_penale_contenu_page.dart |
| Responsabilité pénale (sous-page) | content/pa_scolarite/dpg_pages/responsabilite_penale/responsabilite_penale_page.dart |
| Responsabilité pénale — contenu | content/pa_scolarite/dpg_pages/responsabilite_penale_contenu.dart |

#### Tentative (`tentative/`)

| Titre lisible | Fichier source |
|---|---|
| Intro tentative | content/pa_scolarite/tentative/tentative_intro_page.dart |
| Tentative — contenu | content/pa_scolarite/tentative/tentative_contenu_page.dart |
| Conditions de la tentative | content/pa_scolarite/tentative/condition_tentative_page.dart |
| Tentative infructueuse | content/pa_scolarite/tentative/infructueuse_tentative_page.dart |
| Répression de la tentative | content/pa_scolarite/tentative/repression_tentative_page.dart |

#### Cadres juridiques (`cadres_juridiques_pages/`)

**Flagrant délit**

| Titre lisible | Fichier source |
|---|---|
| Intro flagrant délit | content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_intro_page.dart |
| Notion de flagrant délit | content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_notion_page.dart |
| Panorama flagrant délit | content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_panorama_page.dart |
| Domaine flagrant délit | content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_domaine_page.dart |
| Procédure flagrant délit | content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart |
| Flagrant délit — contenu | content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_contenu_page.dart |

**Enquête préliminaire**

| Titre lisible | Fichier source |
|---|---|
| Intro enquête préliminaire | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_intro_page.dart |
| Enquête préliminaire — contenu | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_contenu_page.dart |
| Ch.1 Domaine enquête préliminaire | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart |
| Ch.2 Procédure enquête préliminaire | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre2_procedure_page.dart |
| Constatations & réquisitions | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart |
| Fouilles enquête préliminaire | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_fouilles_page.dart |
| Garde à vue — enquête préliminaire | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart |
| Saisie comptes bancaires | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_prelim_saisie_comptes_bancaires_page.dart |

**Commission rogatoire**

| Titre lisible | Fichier source |
|---|---|
| Intro commission rogatoire | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_intro.dart |
| Commission rogatoire — contenu | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_contenu_page.dart |
| Ch.1 Commission rogatoire | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart |
| Ch.2 Commission rogatoire | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart |
| Ch.3 Commission rogatoire | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart |
| Garde à vue (CR) | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/garde_a_vue.dart |
| Mandat de recherche | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/mandat_recherche.dart |
| Perquisitions & fouilles | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/perquisitions_fouilles_page.dart |
| Réquisitions | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart |
| Saisies & scellés | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart |
| Violation du contrôle judiciaire | content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart |

**Contrôle d'identité**

| Titre lisible | Fichier source |
|---|---|
| Intro contrôle d'identité | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_intro_page.dart |
| Contrôle d'identité — contenu | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_contenu_page.dart |
| Cadre général | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart |
| Ch.1 introduction | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_chap1_introduction_page.dart |
| Ch.1 contenu | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap1_page.dart |
| Ch.3 contenu | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_contenu_chap3_page.dart |
| Contrôles préventifs | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_controles_preventifs_gpx_school_page.dart |
| Distinction identité/réglementation | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_distinction_identite_reglementation_gpx_school_page.dart |
| Locaux professionnels | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_locaux_professionnels_gpx_school_page.dart |
| Moyens de preuve d'identité | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_moyens_preuve_identite_gpx_school_page.dart |
| Séjour des étrangers | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_sejour_etrangers_gpx_school_page.dart |
| Visites véhicules/bagages/navires | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart |
| Zone frontière | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_zone_frontiere_gpx_school_page.dart |
| Relevé d'identité | content/pa_scolarite/cadres_juridiques_pages/controle_identite/releve_identite_gpx_school_page.dart |
| Vérification identité — introduction | content/pa_scolarite/cadres_juridiques_pages/controle_identite/verification_identite_introduction_gpx_school.dart |
| Vérification identité — procédure | content/pa_scolarite/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart |
| Vérification identité — PV | content/pa_scolarite/cadres_juridiques_pages/controle_identite/verification_identite_proces_verbal_gpx_school.dart |
| Vérification identité — recherche | content/pa_scolarite/cadres_juridiques_pages/controle_identite/verification_identite_recherche_gpx_school.dart |
| Vérification identité — rétention | content/pa_scolarite/cadres_juridiques_pages/controle_identite/verification_identite_retention_gpx_school.dart |

**Criminalité organisée**

| Titre lisible | Fichier source |
|---|---|
| Intro criminalité & délinquance | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/criminalite_deliquance_intro_page.dart |
| Criminalité organisée — contenu | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/criminalite_organisee_contenu_page.dart |
| Infractions de criminalité organisée | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/infraction_criminalite_organisee.dart |
| Règles dérogatoires criminalité organisée | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart |
| Garde à vue criminalité organisée | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart |
| Enquête préliminaire (CO) | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart |
| Commission rogatoire (CO) | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart |
| Perquisition (CO) | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart |
| Interceptions | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/interceptions_gpx_school.dart |
| Lutte financement criminalité | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/lutte_financement_gpx_school.dart |
| Autres techniques d'enquête | content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart |

**Disparitions inquiétantes**

| Titre lisible | Fichier source |
|---|---|
| Intro disparitions inquiétantes | content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_intro.dart |
| Disparitions — contenu | content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_contenu.dart |
| Conditions disparition inquiétante | content/pa_scolarite/cadres_juridiques_pages/disparition/disparition_inquietante_conditions_gpx_school.dart |
| Enquête disparition | content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_enquete_gpx_school.dart |
| Procédure disparition | content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart |

**Mort inconnue**

| Titre lisible | Fichier source |
|---|---|
| Intro mort inconnue | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_intro_page.dart |
| Mort inconnue — intro page | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_page_intro.dart |
| Mort inconnue — contenu | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_page_contenu.dart |
| Conditions | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_condition.dart |
| Procédure | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart |
| Actes d'enquête | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_enquete.dart |
| Actes délégués | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart |
| Actes juge instruction | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart |
| Suites de l'enquête | content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_suites_enquete.dart |

**Personnes en fuite**

| Titre lisible | Fichier source |
|---|---|
| Intro personnes en fuite | content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_intro.dart |
| Personnes en fuite — contenu | content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart |
| Conditions | content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_condition_gpx_school.dart |
| Procédure | content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart |
| Techniques spéciales | content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_techniques_speciales_gpx_school.dart |

**Personne grièvement blessée**

| Titre lisible | Fichier source |
|---|---|
| Intro | content/pa_scolarite/cadres_juridiques_pages/personne_grievement_blessee/personne_intro.dart |
| Contenu | content/pa_scolarite/cadres_juridiques_pages/personne_grievement_blessee/personne_contenu.dart |

**Entraide judiciaire**

| Titre lisible | Fichier source |
|---|---|
| Intro entraide judiciaire | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_intro_page.dart |
| Entraide — contenu | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_contenu_page.dart |
| Entraide internationale | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart |
| Eurojust | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/eurojust_page.dart |
| Extradition droit commun | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart |
| Extradition modalités de transmission | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_modalites_transmission_page.dart |
| Extradition simplifiée UE | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart |
| MAE — définition | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_definition_page.dart |
| MAE — exécution par juridictions FR | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart |
| MAE — mandat par juridictions FR | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart |
| MAE — mise en œuvre | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_mise_en_oeuvre_page.dart |
| Réseau judiciaire européen | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/reseau_judiciaire_europeen_page.dart |
| Traité de Prüm | content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/traite_prum_page.dart |

#### Procédure pénale (`procedure_penale_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub procédure pénale | content/pa_scolarite/procedure_penale_pages/procedure_penale_page.dart |
| Action publique — titre préliminaire ch.1 | content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart |
| Action publique — sujets ch.2 | content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart |
| Action publique — exercice ch.3 | content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_3_exercice_action_publique_page.dart |
| Action publique — extinction ch.4 | content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_4_extinction_action_publique_page.dart |
| Action publique & action civile | content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_page.dart |
| Action publique — tableau | content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart |
| Autorités PJ — intro | content/pa_scolarite/procedure_penale_pages/pp_action_publique_autorites_pj_intro_page.dart |
| Autorités PJ | content/pa_scolarite/procedure_penale_pages/pp_action_publique_autorites_pj_page.dart |
| Autorités investies — intro | content/pa_scolarite/procedure_penale_pages/autorites_investies_intro.dart |
| Autorités investies — contenu | content/pa_scolarite/procedure_penale_pages/autorites_investies_contenu.dart |
| Autorités PJ habituelles | content/pa_scolarite/procedure_penale_pages/pp_autorites_investies_pj_habituelles_page.dart |
| Autorités PJ occasionnelles | content/pa_scolarite/procedure_penale_pages/pp_autorites_investies_pj_occasionnelles_page.dart |
| Ministère public — organisation intro | content/pa_scolarite/procedure_penale_pages/organisation_ministere_intro.dart |
| Ministère public — contenu | content/pa_scolarite/procedure_penale_pages/pp_organisation_ministere_public_contenu_page.dart |
| Juridictions pénales | content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart |
| Juridiction — intro | content/pa_scolarite/procedure_penale_pages/juridiction_intro_page.dart |
| Juridiction — contenu | content/pa_scolarite/procedure_penale_pages/juridiction_contenu_page.dart |
| Juridictions — principes généraux | content/pa_scolarite/procedure_penale_pages/juridictions_principes_generaux_page.dart |
| Juridictions — exécution décisions | content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart |
| Chambre d'instruction | content/pa_scolarite/procedure_penale_pages/pp_chambre_instruction.dart |
| JLD | content/pa_scolarite/procedure_penale_pages/pp_jld.dart |
| Auditions & PV — règles | content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart |
| Auditions & PV (sous-page) | content/pa_scolarite/procedure_penale_pages/pp_auditions_pv/pp_auditions_pv_page.dart |
| Contrôle d'identité (PP) | content/pa_scolarite/procedure_penale_pages/pp_controle_identite/pp_controle_identite_page.dart |
| GAV — conditions de placement | content/pa_scolarite/procedure_penale_pages/pp_gav_conditions_placement_page.dart |
| GAV — droits de la personne gardée | content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart |
| GAV (sous-page) | content/pa_scolarite/procedure_penale_pages/pp_gav/pp_gav_page.dart |
| Mesures de contrainte | content/pa_scolarite/procedure_penale_pages/pp_mesures_contrainte/pp_mesures_contrainte_page.dart |
| Assignation à résidence — conditions | content/pa_scolarite/procedure_penale_pages/pp_assignation_residence_conditions.dart |
| Contrôle judiciaire — intro | content/pa_scolarite/procedure_penale_pages/controle_judiciaire_intro.dart |
| Contrôle judiciaire — contenu | content/pa_scolarite/procedure_penale_pages/controle_judiciaire_contenu.dart |
| Contrôle judiciaire — ch.1 | content/pa_scolarite/procedure_penale_pages/pp_controle_judiciaire_chapitre1.dart |
| Contrôle judiciaire — ch.2 | content/pa_scolarite/procedure_penale_pages/pp_controle_judiciaire_chapitre2.dart |
| Contrôle judiciaire — tableau | content/pa_scolarite/procedure_penale_pages/pp_controle_judiciaire_tableau.dart |
| Détention provisoire — intro | content/pa_scolarite/procedure_penale_pages/detention_provisoire_intro.dart |
| Détention provisoire — contenu | content/pa_scolarite/procedure_penale_pages/detention_provisoire_contenu.dart |
| Placement en détention provisoire | content/pa_scolarite/procedure_penale_pages/pp_placement_detention_provisoire.dart |
| Déroulement détention provisoire | content/pa_scolarite/procedure_penale_pages/pp_deroulement_detention_provisoire.dart |
| Fin de détention provisoire | content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart |
| Tableau détention provisoire | content/pa_scolarite/procedure_penale_pages/pp_detention_provisoire_tableau.dart |
| Réparation détention injustifiée | content/pa_scolarite/procedure_penale_pages/pp_reparation_detention_injustifiee.dart |
| Bracelet électronique — intro | content/pa_scolarite/procedure_penale_pages/bracelet_contenu_page.dart |
| Bracelet — déroulement mesure | content/pa_scolarite/procedure_penale_pages/pp_bracelet_deroulement_mesure.dart |
| Bracelet — modalités de placement | content/pa_scolarite/procedure_penale_pages/pp_bracelet_modalites_placement.dart |
| Instruction préparatoire — intro | content/pa_scolarite/procedure_penale_pages/instruction_preparatoire_intro.dart |
| Instruction préparatoire — contenu | content/pa_scolarite/procedure_penale_pages/instruction_preparatoire_contenu.dart |
| Instruction préparatoire — détail | content/pa_scolarite/procedure_penale_pages/instruction_preparatoire_contenu_detail.dart |
| Instruction — ch.1 | content/pa_scolarite/procedure_penale_pages/pp_instruction_chapitre_1.dart |
| Instruction — ouverture | content/pa_scolarite/procedure_penale_pages/pp_instruction_ouverture.dart |
| Instruction — pouvoirs | content/pa_scolarite/procedure_penale_pages/pp_instruction_pouvoirs.dart |
| Instruction — clôture | content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart |
| Mineurs — principes généraux | content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart |
| Mineurs — rétention & mandats | content/pa_scolarite/procedure_penale_pages/pp_mineurs_retention_mandats.dart |
| Mineurs — instruction préparatoire | content/pa_scolarite/procedure_penale_pages/pp_mineurs_instruction_preparatoire.dart |
| Dispositions mineurs instruction | content/pa_scolarite/procedure_penale_pages/pp_dispositions_mineurs_instruction_contenu.dart |
| Mandats de justice — contenu | content/pa_scolarite/procedure_penale_pages/mandats_justice_contenu.dart |
| Mandats — principes généraux | content/pa_scolarite/procedure_penale_pages/pp_mandats_principes_generaux.dart |
| Mandats — types | content/pa_scolarite/procedure_penale_pages/pp_mandats_types.dart |
| Mandats — sanctions irrégularités | content/pa_scolarite/procedure_penale_pages/pp_mandats_sanctions_irregularites.dart |
| Nullité — intro | content/pa_scolarite/procedure_penale_pages/nullite_intro_page.dart |
| Nullité — contenu | content/pa_scolarite/procedure_penale_pages/nullite_contenu_page.dart |
| Nullités textuelles | content/pa_scolarite/procedure_penale_pages/pp_nullites_textuelles_page.dart |
| Nullités substantielles | content/pa_scolarite/procedure_penale_pages/pp_nullites_substantielles_page.dart |
| Action en nullité | content/pa_scolarite/procedure_penale_pages/pp_action_en_nullite_page.dart |
| Effets de la nullité | content/pa_scolarite/procedure_penale_pages/pp_effets_nullite_page.dart |
| Contrôle mission PJ — chambre instruction | content/pa_scolarite/procedure_penale_pages/controle_mission_contenu_page.dart |
| Contrôle mission — intro | content/pa_scolarite/procedure_penale_pages/controle_mission_intro_page.dart |
| Contrôle mission — chambre instruction | content/pa_scolarite/procedure_penale_pages/pp_controle_mission_pj_chambre_instruction_page.dart |
| Contrôle mission — inspection générale | content/pa_scolarite/procedure_penale_pages/pp_controle_mission_pj_inspection_generale_justice_page.dart |
| Contrôle mission — rôle procureur général | content/pa_scolarite/procedure_penale_pages/pp_controle_mission_pj_role_procureur_general_page.dart |
| Perquisitions (sous-page) | content/pa_scolarite/procedure_penale_pages/pp_perquisitions/pp_perquisitions_page.dart |
| Saisies & scellés (sous-page) | content/pa_scolarite/procedure_penale_pages/pp_saisies_scelles/pp_saisies_scelles_page.dart |
| PV — règles (sous-page) | content/pa_scolarite/procedure_penale_pages/pp_pv_regles/pp_pv_regles_page.dart |
| Infractions spécifiques | content/pa_scolarite/procedure_penale_pages/pp_infractions_specifiques/pp_infractions_specifiques_page.dart |

#### Sanctions (`sanction_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub sanctions | content/pa_scolarite/sanction_pages/sanction_page.dart |
| Classification légale des peines | content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart |
| Classification des mesures de sûreté | content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart |
| Classification des peines — contenu | content/pa_scolarite/sanction_pages/classification_peines_contenu_page.dart |
| Classification peines (sous-page) | content/pa_scolarite/sanction_pages/classification_peines/classification_peines_page.dart |
| Causes d'aggravation | content/pa_scolarite/sanction_pages/causes_aggravation_page.dart |
| Causes d'aggravation — contenu | content/pa_scolarite/sanction_pages/causes_aggravation_sanction_contenu_page.dart |
| Circonstances aggravantes | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/circonstances_aggravantes_page.dart |
| Auteur abusant de son autorité | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/auteur_abusant_autorite_page.dart |
| Auteur ascendant de la victime | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/auteur_ascendant_victime_page.dart |
| Auteur dépositaire de l'autorité | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/auteur_depositaire_autorite_page.dart |
| Auteur ivre ou sous stupéfiants | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/auteur_ivre_ou_stupefiants_page.dart |
| Bande organisée | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart |
| Caractère homophobe | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/caractere_homophobe_page.dart |
| Caractère raciste | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/caractere_raciste_page.dart |
| Effraction | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/effraction_page.dart |
| Escalade | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/escalade_page.dart |
| Établissement d'enseignement | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/etablissement_enseignement_page.dart |
| Guet-apens | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/guet_apens_page.dart |
| ITT — incapacité totale | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/incapacite_totale_travail_page.dart |
| Minorité de 15 ans | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/minorite_quinze_ans_page.dart |
| Mort | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart |
| Moyen de cryptologie | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/moyen_cryptologie_page.dart |
| Mutilation/infirmité permanente | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mutilation_infirmité_permanente_page.dart |
| Port ou usage d'arme | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart |
| Préméditation | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart |
| Qualité conjoint/concubin/partenaire | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart |
| Témoin/victime/partie civile | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/temoin_victime_partie_civile_page.dart |
| Utilisation réseau de communication | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/utilisation_reseau_communication_page.dart |
| Victime ascendant de l'auteur | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_ascendant_auteur_page.dart |
| Victime chargée de mission | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_chargee_mission_page.dart |
| Victime dépositaire de l'autorité | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart |
| Victime parenté de la personne | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_parente_personne_page.dart |
| Victime en situation de prostitution | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_prostitution_page.dart |
| Vulnérabilité de la victime | content/pa_scolarite/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart |
| Pluralité d'infractions — contenu | content/pa_scolarite/sanction_pages/pluralite_infractions_contenu_page.dart |
| Concours réel d'infractions | content/pa_scolarite/sanction_pages/pluralite_infractions/concours_reel_infractions_page.dart |
| Récidive | content/pa_scolarite/sanction_pages/pluralite_infractions/recidive_page.dart |
| Réitération d'infractions | content/pa_scolarite/sanction_pages/pluralite_infractions/reiteration_infractions_page.dart |

#### Atteintes aux personnes (`atteintes_personnes_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub atteintes personnes | content/pa_scolarite/atteintes_personnes_pages/atteintes_personnes_page.dart |
| Enlèvement & séquestration | content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart |
| Atteintes volontaires à la vie — contenu | content/pa_scolarite/atteintes_personnes_pages/atteinte_volontaire/atteintes_volontaires_vie_contenu_page.dart |
| Meurtre | content/pa_scolarite/atteintes_personnes_pages/atteinte_volontaire/meurtre_page.dart |
| Empoisonnement | content/pa_scolarite/atteintes_personnes_pages/atteinte_volontaire/empoisonnement_page.dart |
| Atteintes involontaires — contenu | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_contenu_page.dart |
| Homicide involontaire | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/homicide_involontaire_contenu_page.dart |
| Atteintes invo. — ITT < 3 mois | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart |
| Atteintes invo. — ITT > 3 mois | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_superieure_3_mois_contenu_page.dart |
| Violation délibérée obligation | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_violation_manifestement_deliberee_obligation_contenu_page.dart |
| Violences volontaires qualifiées | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_volontaires_qualifiees_violences_contenu_page.dart |
| Conducteur VTM | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_conducteur_vtm_page.dart |
| Participation groupement violent | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/participation_groupement_violent_page.dart |
| Violences avec arme/FSI/pompier | content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/violences_volontaires_arme_personne_depositaire_transport_pompier_contenu_page.dart |
| Atteintes volontaires intégrité — contenu | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/atteintes_volontaires_integrite_contenu_page.dart |
| Appels/messages malveillants | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/appels_messages_malveillants_agressions_sonores_page.dart |
| Embuscade | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart |
| Menace sans condition | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/menace_sans_condition_page.dart |
| Menaces avec condition | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/menaces_avec_condition_page.dart |
| Outrage sexiste | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart |
| Tortures & actes de barbarie | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/tortures_actes_barbarie_page.dart |
| Violences habituelles couple/ex | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/violences_habituelles_couple_ex_page.dart |
| Violences habituelles mineur/vulnérable | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/violences_habituelles_mineur_vulnerable_contenu_page.dart |
| Violences sur FSI | content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/violences_sur_fsi_page.dart |
| Viol & agressions sexuelles — contenu | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_inceste_agressions_contenu_page.dart |
| Viol | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart |
| Viol incestueux | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_incestueux_page.dart |
| Viol majeur mineur -15 ans | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_majeur_mineur_15_page.dart |
| Agression majeur mineur -15 ans | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart |
| Agression sexuelle incestueuse | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart |
| Agressions sexuelles autres que viol | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agressions_sexuelles_autres_que_viol_page.dart |
| Contrainte atteinte sexuelle tiers | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart |
| Exhibition sexuelle | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/exhibition_sexuelle_page.dart |
| Harcèlement sexuel | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/harcelement_sexuel_page.dart |
| Mineur -15 violences/contrainte | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/mineur_15_violences_contrainte_menace_surprise_page.dart |
| Personne vulnérable | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart |
| Substance pour viol/agression | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart |
| Administration substances nuisibles | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart |
| Dignité de la personne — contenu | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/dignite_personne_contenu_page.dart |
| Discriminations | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/discriminations_contenu_page.dart |
| Proxénétisme | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/proxenetisme_page.dart |
| Proxénétisme hôtelier | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/proxenetisme_hotelier_page.dart |
| Proxénétisme — assimilation | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/proxenetisme_assimilation_page.dart |
| Recours prostitution mineurs/vulnérables | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/recours_prostitution_mineurs_personnes_vulnerables_contenu_page.dart |
| Rétribution inexistante/insuffisante | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/retribution_inexistante_insuffisante_personne_vulnerable_dependante_page.dart |
| Soumission conditions indignes | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart |
| Traite des êtres humains | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/traite_etres_humains_page.dart |
| Dissimulation forcée du visage | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/dissimulation_forcee_visage_page.dart |
| Atteinte intégrité cadavre | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/atteinte_integrite_cadavre_page.dart |
| Violation/profanation tombeaux | content/pa_scolarite/atteintes_personnes_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart |
| Atteinte personnalité — contenu | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_personnalite_contenu_page.dart |
| Atteinte intimité vie privée | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_intimite_vie_privee.dart |
| Atteinte intimité de la personne | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_intimite_personne.dart |
| Atteinte représentation de la personne | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_representation_personne_contenu_page.dart |
| Atteinte secret correspondances | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart |
| Atteinte secret professionnel | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_professionnel.dart |
| Dénonciation calomnieuse | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart |
| Diffusion enregistrement sexuel sans accord | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/diffusion_enregistrement_document_caractere_sexuel_sans_accord_contenu_page.dart |
| Violation correspondances électroniques | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_correspondances_voie_electronique_contenu_page.dart |
| Violation domicile particulier | content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/violation_domicile_particulier_contenu_page.dart |
| Enregistrement/diffusion images — contenu | content/pa_scolarite/atteintes_personnes_pages/enregistrement_diffusion_images/enregistrement_diffusion_images_contenu_page.dart |
| Enregistrement images de violence | content/pa_scolarite/atteintes_personnes_pages/enregistrement_diffusion_images/enregistrement_images_violence_contenu_page.dart |
| Diffusion images de violence | content/pa_scolarite/atteintes_personnes_pages/enregistrement_diffusion_images/diffusion_images_violence_contenu_page.dart |
| Mise en danger — contenu | content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_contenu_page.dart |
| Risque causé à autrui | content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart |
| Non-assistance à personne en péril | content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_assistance_personne_peril_page.dart |
| Non-obstacle crime/délit | content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/non_obstacle_commission_crime_delit_page.dart |
| Délaissement personne hors d'état | content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/delaissement_personne_hors_etat_page.dart |
| Abus frauduleux ignorance/faiblesse | content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/abus_frauduleux_ignorance_faiblesse_page.dart |
| Diffusion informations mise en danger | content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart |

#### Atteintes aux biens (`atteintes_biens_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub atteintes aux biens | content/pa_scolarite/atteintes_biens_pages/atteintes_biens_page.dart |
| Vol | content/pa_scolarite/atteintes_biens_pages/vol_page.dart |
| Infractions voisines du vol — contenu | content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/voisines_du_vol_contenu_page.dart |
| Abus de confiance | content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/abus_de_confiance_contenu_page.dart |
| Chantage | content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/chantage_contenu_page.dart |
| Demande de fonds sous contrainte | content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/demande_fonds_sous_contrainte_contenu_page.dart |
| Escroquerie | content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/escroquerie_contenu_page.dart |
| Extorsion | content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/extorsion_contenu_page.dart |
| Filouteries | content/pa_scolarite/atteintes_biens_pages/voisines_du_vol/filouteries_contenu_page.dart |
| Recel & non-justification — contenu | content/pa_scolarite/atteintes_biens_pages/recel_non_justification/recel_non_justification_contenu_page.dart |
| Recel | content/pa_scolarite/atteintes_biens_pages/recel_non_justification/recel_page.dart |
| Non-justification de ressources | content/pa_scolarite/atteintes_biens_pages/recel_non_justification/non_justification_ressources.dart |
| Destructions & dégradations — contenu | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/destructions_degradations_contenu_page.dart |
| Biens culturels publics classés | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart |
| Dangereuses personnes — intentionnelle | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/dangereuses_personnes_intentionnelle_contenu_page.dart |
| Dangereuses personnes — non intentionnelle | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/dangereuses_personnes_non_intentionnelle_contenu_page.dart |
| Détention transport sans motif légitime | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/detention_transport_sans_motif_legitime_contenu_page.dart |
| Détention transport substances | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/detention_transport_substances_preparation_contenu_page.dart |
| Diffusion procédés d'engins | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/diffusion_procedes_fabrication_engins_destruction_contenu_page.dart |
| Fausses alertes | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/fausses_alertes_contenu_page.dart |
| Menaces avec condition | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/menaces_avec_condition_contenu_page.dart |
| Menaces sans condition | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/menaces_sans_condition_contenu_page.dart |
| Sans danger — dommage important | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/sans_danger_dommage_important_contenu_page.dart |
| Sans danger — dommage léger | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/sans_danger_dommage_leger_contenu_page.dart |
| Tags & inscriptions | content/pa_scolarite/atteintes_biens_pages/destructions_degradations/tags_inscriptions_signes_dessins_contenu_page.dart |
| STAD — contenu | content/pa_scolarite/atteintes_biens_pages/stad/stad_contenu_page.dart |
| Accès/maintien frauduleux STAD | content/pa_scolarite/atteintes_biens_pages/stad/acces_maintien_frauduleux_stad_page.dart |
| Association malfaiteurs informatique | content/pa_scolarite/atteintes_biens_pages/stad/association_malfaiteurs_informatique_page.dart |
| Données adaptées pour infractions | content/pa_scolarite/atteintes_biens_pages/stad/donnees_adaptees_commettre_infractions_page.dart |
| Introduction/suppression/modification données | content/pa_scolarite/atteintes_biens_pages/stad/introduction_suppression_modification_donnees_page.dart |
| Contrefaçons & falsifications chèques | content/pa_scolarite/atteintes_biens_pages/contrefacons_falsifications/contrefacons_falsifications_cheques_page.dart |

#### Atteintes à la nation (`atteintes_nation_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub atteintes à la nation | content/pa_scolarite/atteintes_nation_pages/atteintes_nation_page.dart |
| Association de malfaiteurs | content/pa_scolarite/atteintes_nation_pages/association_malfaiteurs_contenu_page.dart |
| Abus d'autorité — particuliers | content/pa_scolarite/atteintes_nation_pages/abus_autorite/abus_autorite_particuliers_contenu_page.dart |
| Atteintes inviolabilité domicile | content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_inviolabilite_domicile_contenu_page.dart |
| Atteintes secret correspondances | content/pa_scolarite/atteintes_nation_pages/abus_autorite/atteintes_secret_correspondances_contenu_page.dart |
| Discriminations (nation) | content/pa_scolarite/atteintes_nation_pages/abus_autorite/discriminations_contenu_page.dart |
| Atteintes action justice — contenu | content/pa_scolarite/atteintes_nation_pages/atteintes_action_justice/atteintes_action_justice_contenu_page.dart |
| Non-dénonciation de crime | content/pa_scolarite/atteintes_nation_pages/atteintes_action_justice/non_denonciation_crime_contenu_page.dart |
| Témoignage mensonger | content/pa_scolarite/atteintes_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart |
| Atteintes à l'administration — contenu | content/pa_scolarite/atteintes_nation_pages/atteintes_administration/atteintes_administration_contenu_page.dart |
| Menaces envers dépositaire de l'autorité | content/pa_scolarite/atteintes_nation_pages/atteintes_administration/menaces_envers_depositaire_autorite_contenu_page.dart |
| Menaces/violences dérogation service public | content/pa_scolarite/atteintes_nation_pages/atteintes_administration/menaces_violences_intimidation_derogation_service_public_contenu_page.dart |
| Provocation à la rébellion | content/pa_scolarite/atteintes_nation_pages/atteintes_administration/provocation_directe_rebellion_contenu_page.dart |
| Rébellion | content/pa_scolarite/atteintes_nation_pages/atteintes_administration/rebellion_contenu_page.dart |
| Faux & usage de faux — contenu | content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_usage_faux_contenu_page.dart |
| Faux certifcats/attestations | content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_certificats_ou_attestations_contenu_page.dart |
| Faux document administratif | content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_document_administratif_page.dart |
| Faux écritures publiques/authentiques | content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart |
| Faux & usage de faux (page) | content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart |
| Délivrance indue document administratif | content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/delivrance_indue_document_administratif_page.dart |
| Obtention indue document administratif | content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/obtention_indue_document_administratif_contenu_page.dart |
| Probité — contenu | content/pa_scolarite/atteintes_nation_pages/probite/probite_contenu_page.dart |
| Concussion | content/pa_scolarite/atteintes_nation_pages/probite/concussion_page.dart |
| Corruption | content/pa_scolarite/atteintes_nation_pages/probite/corruption_page.dart |
| Trafic d'influence | content/pa_scolarite/atteintes_nation_pages/probite/trafic_influence_contenu_page.dart |

#### Armes & munitions (`armes_munitions_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub armes & munitions | content/pa_scolarite/armes_munitions_pages/armes_munitions_page.dart |
| Introduction armes | content/pa_scolarite/armes_munitions_pages/armes_introduction_contenu_page.dart |
| Définitions armes | content/pa_scolarite/armes_munitions_pages/armes_definitions_contenu_page.dart |
| Classification des armes | content/pa_scolarite/armes_munitions_pages/armes_classification_contenu_page.dart |
| Acquisition/détention — catégories A/B | content/pa_scolarite/armes_munitions_pages/armes_acquisition_detention_ab_contenu_page.dart |
| Matériels de guerre — éléments | content/pa_scolarite/armes_munitions_pages/armes_materiels_guerre_elements_contenu_page.dart |
| Port/transport — catégories C/D | content/pa_scolarite/armes_munitions_pages/armes_port_transport_cd_contenu_page.dart |
| Règles acquisition/détention | content/pa_scolarite/armes_munitions_pages/armes_regles_acquisition_detention_contenu_page.dart |
| Règles port/transport | content/pa_scolarite/armes_munitions_pages/armes_regles_port_transport_contenu_page.dart |

#### Stupéfiants (`stupefiants_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub stupéfiants | content/pa_scolarite/stupefiants_pages/stupefiants_page.dart |
| Introduction stupéfiants | content/pa_scolarite/stupefiants_pages/introduction_contenu_page.dart |
| Usage illicite | content/pa_scolarite/stupefiants_pages/usage_illicite_contenu_page.dart |
| Cession & offre | content/pa_scolarite/stupefiants_pages/cession_offre_contenu_page.dart |
| Transport, détention, offre | content/pa_scolarite/stupefiants_pages/transport_detention_offre_contenu_page.dart |
| Production & fabrication | content/pa_scolarite/stupefiants_pages/production_fabrication_contenu_page.dart |
| Import/export | content/pa_scolarite/stupefiants_pages/import_export_contenu_page.dart |
| Facilitation de l'usage | content/pa_scolarite/stupefiants_pages/facilitation_usage_contenu_page.dart |
| Provocation d'un majeur | content/pa_scolarite/stupefiants_pages/provocation_majeur_contenu_page.dart |
| Direction & organisation | content/pa_scolarite/stupefiants_pages/direction_organisation_contenu_page.dart |
| Blanchiment produit stupéfiants | content/pa_scolarite/stupefiants_pages/blanchiment_produit_contenu_page.dart |

#### Circulation routière (`circulation_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub circulation | content/pa_scolarite/circulation_pages/circulation_page.dart |
| Agents verbalisateurs | content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart |
| État alcoolique | content/pa_scolarite/circulation_pages/etat_alcoolique_contenu_page.dart |
| Ivresse | content/pa_scolarite/circulation_pages/ivresse_contenu_page.dart |
| Conduite sous stupéfiants | content/pa_scolarite/circulation_pages/conduite_stupefiants_contenu_page.dart |
| Défaut d'assurance | content/pa_scolarite/circulation_pages/defaut_assurance_page.dart |
| Défaut de permis | content/pa_scolarite/circulation_pages/defaut_permis_contenu_page.dart |
| Délit de fuite | content/pa_scolarite/circulation_pages/delit_fuite_page.dart |
| Grand excès de vitesse | content/pa_scolarite/circulation_pages/grand_exces_vitesse_page.dart |
| Incitation/organisation/promotion | content/pa_scolarite/circulation_pages/incitation_organisation_promotion_page.dart |
| Plaques & inscriptions | content/pa_scolarite/circulation_pages/plaques_inscriptions_page.dart |
| Refus d'obtempérer | content/pa_scolarite/circulation_pages/refus_obtemperer_page.dart |
| Refus de vérifications | content/pa_scolarite/circulation_pages/refus_verifications_contenu_page.dart |
| Rodéo motorisé | content/pa_scolarite/circulation_pages/rodeo_motorise_contenu_page.dart |

#### Libertés publiques (`libertes_publiques_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub libertés publiques | content/pa_scolarite/libertes_publiques_pages/libertes_publiques_page.dart |
| Notion de libertés publiques | content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart |
| Déclaration des droits de l'homme | content/pa_scolarite/libertes_publiques_pages/introduction/declaration_droits_homme_page.dart |
| Sources des libertés publiques | content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart |
| Régime juridique libertés publiques | content/pa_scolarite/libertes_publiques_pages/introduction/regime_juridique_libertes_publiques_page.dart |
| Sûreté & liberté individuelle | content/pa_scolarite/libertes_publiques_pages/individuelles/surete_liberte_individuelle_page.dart |
| Liberté d'aller et venir | content/pa_scolarite/libertes_publiques_pages/individuelles/liberte_aller_venir_detail_page.dart |
| Droit à la vie privée | content/pa_scolarite/libertes_publiques_pages/individuelles/droit_vie_privee_page.dart |
| Respect de la personne — législation | content/pa_scolarite/libertes_publiques_pages/individuelles/respect_personne_legislation_page.dart |
| CNIL & protection des données | content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart |
| Liberté de la presse | content/pa_scolarite/libertes_publiques_pages/collectives/liberte_presse_page.dart |
| Régime des attroupements | content/pa_scolarite/libertes_publiques_pages/collectives/regime_attroupements_page.dart |
| Régime des manifestations | content/pa_scolarite/libertes_publiques_pages/collectives/regime_manifestations_page.dart |
| Contrôle constitutionnalité des lois | content/pa_scolarite/libertes_publiques_pages/garanties/controle_constitutionnalite_lois_page.dart |
| Recours juridictionnels | content/pa_scolarite/libertes_publiques_pages/garanties/recours_juridictionnels_page.dart |
| Recours non juridictionnels | content/pa_scolarite/libertes_publiques_pages/garanties/recours_non_juridictionnels_page.dart |
| Recours organes internationaux | content/pa_scolarite/libertes_publiques_pages/garanties/recours_organes_internationaux_page.dart |

#### Mineurs & famille (`mineurs_famille_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub mineurs & famille | content/pa_scolarite/mineurs_famille_pages/mineurs_famille_page.dart |
| Abandon de famille — contenu | content/pa_scolarite/mineurs_famille_pages/abandon_famille/abandon_de_famille_contenu_page.dart |
| Autorité parentale | content/pa_scolarite/mineurs_famille_pages/autorite_parentale/autorite_parentale_page.dart |
| Défaut notification transfert | content/pa_scolarite/mineurs_famille_pages/autorite_parentale/defaut_notification_transfert_contenu_page.dart |
| Non-représentation enfant mineur | content/pa_scolarite/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur_contenu_page.dart |
| Soustraction mineur par ascendant | content/pa_scolarite/mineurs_famille_pages/autorite_parentale/soustraction_enfant_mineur_par_ascendant_contenu_page.dart |
| Soustraction mineur sans fraude | content/pa_scolarite/mineurs_famille_pages/autorite_parentale/soustraction_enfant_mineur_sans_fraude_contenu_page.dart |
| Mise en péril des mineurs | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/mise_en_peril_des_mineurs_page.dart |
| Atteintes sexuelles mineur -15 ans | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_15_contenu_page.dart |
| Atteintes sexuelles mineur +15 ans | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/atteintes_sexuelles_majeur_mineur_plus_15_contenu_page.dart |
| Corruption de mineur | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/corruption_mineur_contenu_page.dart |
| Diffusion message violent mineur | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart |
| Exploitation image porno mineur | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/exploitation_image_porno_mineur_contenu_page.dart |
| Privation aliments/soins mineur -15 | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart |
| Propositions sexuelles mineur en ligne | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/propositions_sexuelles_mineur_15_en_ligne_contenu_page.dart |
| Provocation mineur crime/délit | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/provocation_directe_mineur_crime_delit_contenu_page.dart |
| Provocation mineur à l'alcool | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/provocation_mineur_alcool_contenu_page.dart |
| Provocation mineur aux stupéfiants | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart |
| Provocation à la pédopornographie | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/provocation_pedopornographie_contenu_page.dart |
| Soustraction parent obligations légales | content/pa_scolarite/mineurs_famille_pages/mise_en_peril/soustraction_parent_obligations_legales_contenu_page.dart |
| Violation ordonnances JAF | content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/violation_ordonnances_jaf_page.dart |
| Défaut notification changement domicile | content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart |
| Non-respect ordonnance de protection | content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart |

#### Organisation judiciaire (`organisation_judiciaire_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub organisation judiciaire | content/pa_scolarite/organisation_judiciaire_pages/organisation_judiciaire_hub_page.dart |
| Structure judiciaire | content/pa_scolarite/organisation_judiciaire_pages/structure_judiciaire_page.dart |
| Juridictions pénales | content/pa_scolarite/organisation_judiciaire_pages/juridictions_penales_page.dart |
| Ministère public | content/pa_scolarite/organisation_judiciaire_pages/ministere_public_page.dart |
| Juge d'instruction | content/pa_scolarite/organisation_judiciaire_pages/juge_instruction_page.dart |
| Voies de recours | content/pa_scolarite/organisation_judiciaire_pages/voies_recours_page.dart |

#### Organisation PN (`organisation_pn/`)

| Titre lisible | Fichier source |
|---|---|
| Hub organisation | content/pa_scolarite/organisation_pn/organisation_page.dart |
| Hiérarchie PN | content/pa_scolarite/organisation_pn/hierarchie_pn_page.dart |
| Organigramme MI | content/pa_scolarite/organisation_pn/organigramme_mi_page.dart |
| Organigrammes PN | content/pa_scolarite/organisation_pn/organigrammes_pn_page.dart |
| DGSI | content/pa_scolarite/organisation_pn/dgsi_page.dart |
| Préfecture de Police | content/pa_scolarite/organisation_pn/prefecture_police_page.dart |
| Horaires de service SP | content/pa_scolarite/organisation_pn/horaires_service_sp_page.dart |
| Règles d'emploi du PA | content/pa_scolarite/organisation_pn/regles_emploi_pa_page.dart |

#### Policier en intervention (`policier_intervention_pages/`)

| Titre lisible | Fichier source |
|---|---|
| Hub policier intervention | content/pa_scolarite/policier_intervention_pages/policier_intervention_page.dart |
| Prise de service — appel | content/pa_scolarite/policier_intervention_pages/prise_de_service/prise_service_appel_page.dart |
| Prise de service — applications | content/pa_scolarite/policier_intervention_pages/prise_de_service/prise_service_applications_page.dart |
| Prise de service — registres | content/pa_scolarite/policier_intervention_pages/prise_de_service/prise_service_registres_page.dart |
| Prise de service — GAV | content/pa_scolarite/policier_intervention_pages/prise_de_service/prise_service_garde_a_vue_page.dart |
| Prise de service — fouille intégrale | content/pa_scolarite/policier_intervention_pages/prise_de_service/prise_service_fouille_integrale_page.dart |
| Prise de service — risque évasion | content/pa_scolarite/policier_intervention_pages/prise_de_service/prise_service_risque_evasion_fuite_page.dart |
| Patrouille | content/pa_scolarite/policier_intervention_pages/patrouille/patrouille_patrouille_page.dart |
| Communication radio | content/pa_scolarite/policier_intervention_pages/patrouille/communication_radio_page.dart |
| Procédure radio | content/pa_scolarite/policier_intervention_pages/patrouille/procedure_radio_page.dart |
| Mémo TPH-900 | content/pa_scolarite/policier_intervention_pages/patrouille/memo_tph_900_page.dart |
| Conduite véhicules de police | content/pa_scolarite/policier_intervention_pages/patrouille/conduite_vehicules_police_page.dart |
| Caméra-piéton | content/pa_scolarite/policier_intervention_pages/patrouille/camera_pieton_page.dart |
| Utilité caméra-piéton | content/pa_scolarite/policier_intervention_pages/patrouille/utilite_camera_pieton_page.dart |
| Enregistrement/diffusion images & paroles | content/pa_scolarite/policier_intervention_pages/patrouille/enregistrement_diffusion_images_paroles_page.dart |
| Équipements de sécurité | content/pa_scolarite/policier_intervention_pages/patrouille/equipements_securite_page.dart |
| Interrogation FPR | content/pa_scolarite/policier_intervention_pages/patrouille/interrogation_fpr_page.dart |
| Principaux fichiers | content/pa_scolarite/policier_intervention_pages/patrouille/principaux_fichiers_page.dart |
| Menottage | content/pa_scolarite/policier_intervention_pages/patrouille/menottage_page.dart |
| Palpation de sécurité | content/pa_scolarite/policier_intervention_pages/patrouille/palpation_securite_page.dart |
| Signalement & descriptif | content/pa_scolarite/policier_intervention_pages/patrouille/signalement_descriptif_page.dart |
| Signaux sonores & lumineux | content/pa_scolarite/policier_intervention_pages/patrouille/signaux_sonores_lumineux_page.dart |
| Synthèse indicateurs de basculement | content/pa_scolarite/policier_intervention_pages/patrouille/synthese_indicateurs_basculement_page.dart |
| Types accidents & régulation | content/pa_scolarite/policier_intervention_pages/accident_circulation/types_accidents_circulation_page.dart |
| Sécurité trajet & lieux | content/pa_scolarite/policier_intervention_pages/accident_circulation/securite_trajet_lieux_page.dart |
| Régulation de la circulation | content/pa_scolarite/policier_intervention_pages/accident_circulation/regulation_circulation_page.dart |
| Bruits & tapages | content/pa_scolarite/policier_intervention_pages/domicile/bruits_tapages_page.dart |
| Différend familial | content/pa_scolarite/policier_intervention_pages/domicile/differend_familial_page.dart |
| Violation de domicile | content/pa_scolarite/policier_intervention_pages/domicile/violation_domicile_page.dart |
| Violences conjugales | content/pa_scolarite/policier_intervention_pages/domicile/violences_conjugales_page.dart |
| Alertes à la bombe | content/pa_scolarite/policier_intervention_pages/autres/alertes_a_la_bombe_page.dart |
| Identification produits suspects | content/pa_scolarite/policier_intervention_pages/autres/identification_detection_produits_suspects_page.dart |
| Ivresse publique manifeste | content/pa_scolarite/policier_intervention_pages/autres/ivresse_publique_manifeste_page.dart |
| Plans ORSEC | content/pa_scolarite/policier_intervention_pages/autres/plans_orsec_page.dart |
| Primo-intervenant scène infraction | content/pa_scolarite/policier_intervention_pages/autres/primo_scene_infraction_amaris_page.dart |
| Formulaires utiles | content/pa_scolarite/policier_intervention_pages/formulaires_utiles/formulaires_utiles_page.dart |
| Avis rétention permis | content/pa_scolarite/policier_intervention_pages/formulaires_utiles/avis_retention_permis_page.dart |
| Fiche descriptive fourrière | content/pa_scolarite/policier_intervention_pages/formulaires_utiles/fiche_descriptive_fourriere_page.dart |
| Fiche immobilisation | content/pa_scolarite/policier_intervention_pages/formulaires_utiles/fiche_immobilisation_page.dart |

#### Quiz PA (`quiz_scolarite_pa/`)

> Ces fichiers contiennent les questions/réponses QCM. Route web cible : `/pa/quiz/[sujet]`

- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_introduction.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_generalite_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_hierarchie_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_infraction_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_classification_infractions_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_complicite_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_tentative_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_legitime_defense_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_droit_penale.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_responsabilite_penal_general.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_usage_armes_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_retention_locaux_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_page_cadres_juridique.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_flagrant_delit_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_enquete_preliminaire_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_commission_rogatoire_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_controle_identite.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_criminalite_organisee.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_disparitions_inquietantes.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_mort_inconnue.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_personnes_fuite.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_action_publique_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_juridiction_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_instruction_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_controle_judiciaire.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_detention_provisoire_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_bracelet_electronique.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_nullite_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_mandats_justice.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_dispositions_applicables_mineurs.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_sanction.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_sanction_classification.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_sanction_aggravation.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_sanction_pluralite.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_crimes_delits_personne.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteintes_volontaires.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteintes_involontaires.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteintes_integrite.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_dignite_personne.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteinte_personnalite.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_viol_inceste_agressions.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_enregistrement_diffusion_images.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_mise_en_danger.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_crimes_delits_bien.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_voisines_du_vol.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_recel_non_justification.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_destructions_degradations.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_stad.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_crimes_delits_nation.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteintes_administration.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_atteintes_action_justice.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_abus_autorite.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_faux_usage_faux.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_probite.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_armes_munitions_pages.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_stupéfiants.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_circulation_routiere.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_libertes_publiques_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_libertes_publiques_individuelles_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_libertes_publiques_collectives_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_libertes_publiques_garanties_page.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_mineurs_famille.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_autorite_parentale.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_abandon_famille.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_mise_peril_mineurs.dart
- content/pa_scolarite/quiz_scolarite_pa/pa_quiz_violation_ordonnances_jaf.dart


---

### 9.2 CONCOURS GPX — GARDIEN DE LA PAIX (`lib/content/gpx_scolarite/`)

#### Institutions & Valeurs (`institutions_valeurs/`)

**Accueil public**

| Titre lisible | Fichier source |
|---|---|
| Charte accueil public & victimes | content/gpx_scolarite/institutions_valeurs/accueil_public/charte_accueil_public_victimes_page.dart |
| Démarches administratives | content/gpx_scolarite/institutions_valeurs/accueil_public/demarches_administratives_page.dart |
| Doctrine accueil victimes VC | content/gpx_scolarite/institutions_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart |
| Protection des locaux de police | content/gpx_scolarite/institutions_valeurs/accueil_public/protection_locaux_police_page.dart |
| Référentiel Marianne | content/gpx_scolarite/institutions_valeurs/accueil_public/referentiel_marianne_page.dart |

**Déontologie**

| Titre lisible | Fichier source |
|---|---|
| Droits & obligations des policiers | content/gpx_scolarite/institutions_valeurs/deontologie/droits_obligations_policiers_page.dart |
| Enquête administrative | content/gpx_scolarite/institutions_valeurs/deontologie/enquete_administrative_page.dart |
| Code de déontologie commenté | content/gpx_scolarite/institutions_valeurs/deontologie/gpx_code_deontologie_commente_page.dart |
| Intervenir hors service AMARIS | content/gpx_scolarite/institutions_valeurs/deontologie/hors_service_amaris_page.dart |
| Marques extérieures de respect | content/gpx_scolarite/institutions_valeurs/deontologie/marques_exterieures_respect_page.dart |
| Réseaux sociaux | content/gpx_scolarite/institutions_valeurs/deontologie/reseaux_sociaux_page.dart |
| Sanctions & récompenses | content/gpx_scolarite/institutions_valeurs/deontologie/sanctions_recompenses_page.dart |

**Formation initiale**

| Titre lisible | Fichier source |
|---|---|
| Formation initiale GPX | content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_formation_initiale_formation_page.dart |
| Mémento prise de note — méthodologie | content/gpx_scolarite/institutions_valeurs/formation_initiale/gpx_memento_prise_de_note_methodologie_page.dart |

**Hiérarchie & information**

| Titre lisible | Fichier source |
|---|---|
| Compte-rendu | content/gpx_scolarite/institutions_valeurs/hierarchie_info/compte_rendu_page.dart |
| Formalisme du rapport | content/gpx_scolarite/institutions_valeurs/hierarchie_info/formalisme_rapport_page.dart |
| Modèles de rapports | content/gpx_scolarite/institutions_valeurs/hierarchie_info/modeles_rapports_page.dart |

**Histoire**

| Titre lisible | Fichier source |
|---|---|
| Histoire — repères chronologiques | content/gpx_scolarite/institutions_valeurs/histoire/histoire_reperes_page.dart |

**Laïcité**

| Titre lisible | Fichier source |
|---|---|
| Charte laïcité — services publics | content/gpx_scolarite/institutions_valeurs/laicite/charte_laicite_services_publics_page.dart |
| Laïcité — DLPAJ | content/gpx_scolarite/institutions_valeurs/laicite/gpx_laicite_dlpaj_page.dart |
| Rites & cultes en France | content/gpx_scolarite/institutions_valeurs/laicite/rites_cultes_france_page.dart |

**Quiz Institutions & Valeurs GPX**

- content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_accueil_public.dart
- content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_deontologie.dart
- content/gpx_scolarite/institutions_valeurs/quiz_institutions_valeurs/quiz_organisation_page.dart

#### DPS/DPG — Droit Pénal Spécial & Général (`dps_dpg/`)

**Généralités DPG**

| Titre lisible | Fichier source |
|---|---|
| Classification des infractions — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/classification_infractions_contenu_page.dart |
| Crime | content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/crime_page.dart |
| Délit | content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/delit_page.dart |
| Contravention | content/gpx_scolarite/dps_dpg/generalite_pages/classification_infractions/contravention_page.dart |
| Infraction — intro | content/gpx_scolarite/dps_dpg/generalite_pages/infraction/infraction_intro_page.dart |
| Infraction — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/infraction/infraction_contenu_page.dart |
| Élément légal | content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_legal_page.dart |
| Élément matériel | content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_materiel_page.dart |
| Élément moral | content/gpx_scolarite/dps_dpg/generalite_pages/infraction/element_moral_page.dart |
| Complicité — intro | content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_intro_page.dart |
| Complicité — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_contenu_page.dart |
| Complicité — conditions | content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_condition_page.dart |
| Complicité — participation | content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_participation_page.dart |
| Complicité — répression | content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_repression_page.dart |
| Tentative — intro | content/gpx_scolarite/dps_dpg/generalite_pages/tentative/tentative_intro_page.dart |
| Tentative — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/tentative/tentative_contenu_page.dart |
| Conditions de la tentative | content/gpx_scolarite/dps_dpg/generalite_pages/tentative/condition_tentative_page.dart |
| Tentative infructueuse | content/gpx_scolarite/dps_dpg/generalite_pages/tentative/infructueuse_tentative_page.dart |
| Répression de la tentative | content/gpx_scolarite/dps_dpg/generalite_pages/tentative/repression_tentative_page.dart |
| Hiérarchie police — intro | content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_intro_page.dart |
| Hiérarchie — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_contenu_page.dart |
| Hiérarchie — OPJ | content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_opj_page.dart |
| Hiérarchie — APJ | content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_apj_page.dart |
| Hiérarchie — APJA | content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_apja_page.dart |
| Hiérarchie — assistants enquête | content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_assistants_enquete_page.dart |
| Légitime défense — intro | content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_intro_page.dart |
| Légitime défense — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_contenu_page.dart |
| Légitime défense — personnes | content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_personnes_page.dart |
| Légitime défense — biens | content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart |
| Légitime défense — cas présumés | content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_cas_presumes_page.dart |
| Usage des armes — intro | content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_intro_page.dart |
| Usage des armes — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart |
| Usage armes — conditions préalables | content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_conditions_prealables_page.dart |
| Usage armes — lien légitime défense | content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_lien_legitime_defense_page.dart |
| Usage armes — situations | content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart |
| Rétention locaux police — intro | content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_locaux_intro.dart |
| Rétention locaux — contenu | content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_locaux_contenu.dart |
| Rétention — principes | content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_principes_page.dart |
| Rétention — mesures admin | content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart |
| Rétention — mesures judiciaires | content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_judiciaires_page.dart |

**Droit pénal général (version école GPX)**

| Titre lisible | Fichier source |
|---|---|
| Classification infractions — loi pénale | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/classification_infractions_page_loi_penal.dart |
| Classification infractions — contenu | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/classification_infractions_contenu_page.dart |
| Généralités législation pénale | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/gpx_school_generalites_legislation_penale_page.dart |
| Étendue application lois | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/gpx_school_etendue_application_lois_page.dart |
| Éléments constitutifs infraction | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/gpx_school_elements_constitutifs_infraction_page.dart |
| Responsabilité pénale — principes généraux | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/gpx_school_responsabilite_penale_principes_generaux_page.dart |
| Responsabilité pénale — irresponsabilité | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/gpx_school_responsabilite_penale_causes_irresponsabilite_page.dart |
| Responsabilité pénale — complicité | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/gpx_school_responsabilite_penale_complicite_coaction_page.dart |
| Responsabilité pénale — personnes morales | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/gpx_school_responsabilite_penale_personnes_morales_page.dart |
| Loi pénale — contenu | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/loi_penale_contenu_page.dart |
| Responsabilité pénale — contenu | content/gpx_scolarite/dps_dpg/droit_pénale_général_pages/responsabilite_penale_contenu.dart |

**Libertés publiques (GPX)**

| Titre lisible | Fichier source |
|---|---|
| Libertés publiques — intro contenu | content/gpx_scolarite/dps_dpg/libertés_publiques_pages/libertes_publiques_introduction_contenu_page.dart |
| Notion de libertés publiques | content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/notion_libertes_publiques_page.dart |
| Déclaration des droits de l'homme 1789 | content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart |
| Sources des libertés publiques | content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/sources_libertes_publiques_page.dart |
| Régime juridique & réglementation | content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/regime_juridique_reglementation_amenagement_page.dart |

**Cadres juridiques GPX** — mêmes sous-sections que PA, répertoire `dps_dpg/cadres_juridiques_pages/`

> Les fichiers cadres juridiques GPX sont identiques à ceux de PA en termes de structure. Référence : `content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/[sous-dossier]/[fichier].dart`
> Sous-dossiers : `flagrant_delit/`, `enquete_preliminaire/`, `commission_rogatoire/`, `controle_identite/`, `criminalite_deliquance/`, `disparition/`, `mort_inconnue/`, `personnes_en_fuite/`, `personne_grievement_blessee/`, `entraide_judiciaire/`

**Procédure pénale GPX** — répertoire `dps_dpg/procédure_pénale_pages/`

> Mêmes fichiers que PA `procedure_penale_pages/`, préfixe `content/gpx_scolarite/dps_dpg/procédure_pénale_pages/`

**Infractions circulation routière GPX** (`dps_dpg/infraction_circulation_routière_pages/`)

| Titre lisible | Fichier source |
|---|---|
| État alcoolique | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/etat_alcoolique_contenu_page.dart |
| Ivresse | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/ivresse_contenu_page.dart |
| Conduite sous stupéfiants | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/conduite_stupefiants_contenu_page.dart |
| Défaut d'assurance | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/defaut_assurance_page.dart |
| Défaut de permis | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/defaut_permis_contenu_page.dart |
| Délit de fuite | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/delit_fuite_page.dart |
| Grand excès de vitesse | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/grand_exces_vitesse_page.dart |
| Incitation/organisation/promotion | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/incitation_organisation_promotion_page.dart |
| Plaques & inscriptions | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/plaques_inscriptions_page.dart |
| Refus d'obtempérer | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/refus_obtemperer_page.dart |
| Refus de vérifications | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/refus_verifications_contenu_page.dart |
| Rodéo motorisé | content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart |

**Armes & munitions GPX** (`dps_dpg/armes_munitions_pages/`)

> Mêmes fichiers que PA armes, préfixe `content/gpx_scolarite/dps_dpg/armes_munitions_pages/`
> Fichiers : `armes_introduction_contenu_page.dart`, `armes_definitions_contenu_page.dart`, `armes_classification_contenu_page.dart`, `armes_acquisition_detention_ab_contenu_page.dart`, `armes_materiels_guerre_elements_contenu_page.dart`, `armes_port_transport_cd_contenu_page.dart`, `armes_regles_acquisition_detention_contenu_page.dart`, `armes_regles_port_transport_contenu_page.dart`
> Quiz intégré : `quiz_armes_munitions_pages.dart`

**Stupéfiants GPX** (`dps_dpg/stupéfiants_pages/`)

> Mêmes fichiers que PA stupéfiants, préfixe `content/gpx_scolarite/dps_dpg/stupéfiants_pages/`
> Quiz intégré : `quiz_stupéfiants.dart`

**Sanctions GPX** (`dps_dpg/sanction_pages/`)

> Mêmes fichiers que PA sanctions, préfixe `content/gpx_scolarite/dps_dpg/sanction_pages/`
> Quiz intégrés : `quiz_sanction/quiz_sanction.dart`, `quiz_sanction_aggravation.dart`, `quiz_sanction_classification.dart`, `quiz_sanction_pluralite.dart`

**Crimes & délits contre les personnes GPX** (`dps_dpg/crime_delit_contre_personne_pages/`)

> Structure identique à PA `atteintes_personnes_pages/`, préfixe `content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/`
> Sous-dossiers : `atteinte_volontaire/`, `atteintes_involontaires/`, `atteintes_volontaires_integrite/`, `viol_inceste_agressions/`, `dignite_personne/`, `atteinte_personnalite/`, `enregistrement_diffusion_images/`, `mise_en_danger/`
> Quiz intégrés : `quiz_crime_delit_personne/quiz_*.dart`

**Crimes & délits contre les biens GPX** (`dps_dpg/crime_delit_bien_pages/`)

> Structure identique à PA `atteintes_biens_pages/`, préfixe `content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/`
> Sous-dossiers : `voisines_du_vol/`, `recel_non_justification/`, `destructions_degradations/`, `stad/`, `contrefacons_falsifications/`
> Quiz intégrés : `quiz_crime_delit_bien_pages/quiz_*.dart`

**Crimes & délits contre la nation GPX** (`dps_dpg/crime_delit_nation_pages/`)

> Structure identique à PA `atteintes_nation_pages/`, préfixe `content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/`
> Sous-dossiers : `abus_autorite/`, `atteintes_action_justice/`, `atteintes_administration/`, `faux_usage_faux/`, `probite/`
> Quiz intégrés : `quiz_delit_nation/quiz_*.dart`

**Mineurs & famille GPX** (`dps_dpg/mineurs_famille_pages/`)

> Structure identique à PA `mineurs_famille_pages/`, préfixe `content/gpx_scolarite/dps_dpg/mineurs_famille_pages/`
> Quiz intégrés : `quiz_mineurs_pages/quiz_*.dart`

#### Mémento Circulation (`memento_circulation/`)

**Contrôle routier**

| Titre lisible | Fichier source |
|---|---|
| Cadre légal contrôle routier | content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart |
| Permis de conduire | content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart |
| Assurance obligatoire | content/gpx_scolarite/memento_circulation/controle_routier/assurance_obligatoire_page.dart |
| Certificat d'immatriculation | content/gpx_scolarite/memento_circulation/controle_routier/certificat_immatriculation_page.dart |
| Contrôle technique | content/gpx_scolarite/memento_circulation/controle_routier/controle_technique_page.dart |
| BSR | content/gpx_scolarite/memento_circulation/controle_routier/bsr_page.dart |

**Équipements**

| Titre lisible | Fichier source |
|---|---|
| Casque cycliste | content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart |
| Casque & gants moto | content/gpx_scolarite/memento_circulation/equipements/casque_gants_page.dart |
| Ceinture & retenue enfant | content/gpx_scolarite/memento_circulation/equipements/ceinture_retenue_enfant_page.dart |
| Chargement | content/gpx_scolarite/memento_circulation/equipements/chargement_page.dart |
| Éclairage & signalisation | content/gpx_scolarite/memento_circulation/equipements/eclairage_signalisation_page.dart |
| Essuie-glace | content/gpx_scolarite/memento_circulation/equipements/essuie_glace_page.dart |
| Gilet haute visibilité | content/gpx_scolarite/memento_circulation/equipements/gilet_haute_visibilite_page.dart |
| Nuisances véhicules | content/gpx_scolarite/memento_circulation/equipements/nuisances_vehicules_page.dart |
| Plaques | content/gpx_scolarite/memento_circulation/equipements/plaques_page.dart |
| Pneumatiques | content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart |
| Rétroviseurs & vision | content/gpx_scolarite/memento_circulation/equipements/retroviseurs_vision_page.dart |

**Procédures**

| Titre lisible | Fichier source |
|---|---|
| Amende forfaitaire | content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_page.dart |
| Amende forfaitaire délictuelle | content/gpx_scolarite/memento_circulation/procedures/amende_forfaitaire_delictuelle_page.dart |
| Conduite sous alcool | content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart |
| Conduite après usage stupéfiants | content/gpx_scolarite/memento_circulation/procedures/conduite_apres_usage_stupefiants_page.dart |
| Consignation | content/gpx_scolarite/memento_circulation/procedures/consignation_page.dart |
| Immobilisation | content/gpx_scolarite/memento_circulation/procedures/immobilisation_page.dart |
| Mise en fourrière | content/gpx_scolarite/memento_circulation/procedures/mise_en_fourriere_page.dart |
| Permis à points | content/gpx_scolarite/memento_circulation/procedures/permis_a_points_page.dart |
| Rétention permis de conduire | content/gpx_scolarite/memento_circulation/procedures/retention_permis_conduire_page.dart |

**Règles usage voies**

| Titre lisible | Fichier source |
|---|---|
| Principes généraux de circulation | content/gpx_scolarite/memento_circulation/regles_usage_voies/principes_generaux_circulation_page.dart |

#### Policier en intervention initial (`policier_intervention_initial/`)

**Prise de service**

| Titre lisible | Fichier source |
|---|---|
| Prise de service — appel | content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_appel_page.dart |
| Prise de service — applications | content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_applications_page.dart |
| Prise de service — registres | content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_registres_page.dart |
| Prise de service — GAV | content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_garde_a_vue_page.dart |
| Prise de service — fouille intégrale | content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_fouille_integrale_page.dart |
| Prise de service — risque évasion | content/gpx_scolarite/policier_intervention_initial/prise_de_service/prise_service_risque_evasion_fuite_page.dart |

**Patrouille**

| Titre lisible | Fichier source |
|---|---|
| Patrouille | content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart |
| Communication radio | content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart |
| Procédure radio | content/gpx_scolarite/policier_intervention_initial/patrouille/procedure_radio_page.dart |
| Mémo TPH-900 | content/gpx_scolarite/policier_intervention_initial/patrouille/memo_tph_900_page.dart |
| Conduite véhicules de police | content/gpx_scolarite/policier_intervention_initial/patrouille/conduite_vehicules_police_page.dart |
| Caméra-piéton | content/gpx_scolarite/policier_intervention_initial/patrouille/camera_pieton_page.dart |
| Utilité caméra-piéton | content/gpx_scolarite/policier_intervention_initial/patrouille/utilite_camera_pieton_page.dart |
| Enregistrement/diffusion images | content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart |
| Équipements de sécurité | content/gpx_scolarite/policier_intervention_initial/patrouille/equipements_securite_page.dart |
| Interrogation FPR | content/gpx_scolarite/policier_intervention_initial/patrouille/interrogation_fpr_page.dart |
| Principaux fichiers | content/gpx_scolarite/policier_intervention_initial/patrouille/principaux_fichiers_page.dart |
| Menottage | content/gpx_scolarite/policier_intervention_initial/patrouille/menottage_page.dart |
| Palpation de sécurité | content/gpx_scolarite/policier_intervention_initial/patrouille/palpation_securite_page.dart |
| Signalement & descriptif | content/gpx_scolarite/policier_intervention_initial/patrouille/signalement_descriptif_page.dart |
| Signaux sonores & lumineux | content/gpx_scolarite/policier_intervention_initial/patrouille/signaux_sonores_lumineux_page.dart |
| Indicateurs de basculement | content/gpx_scolarite/policier_intervention_initial/patrouille/synthese_indicateurs_basculement_page.dart |

**Accident circulation**

| Titre lisible | Fichier source |
|---|---|
| Types accidents & circulation | content/gpx_scolarite/policier_intervention_initial/accident_circulation/types_accidents_circulation_page.dart |
| Sécurité trajet & lieux | content/gpx_scolarite/policier_intervention_initial/accident_circulation/securite_trajet_lieux_page.dart |
| Régulation de la circulation | content/gpx_scolarite/policier_intervention_initial/accident_circulation/regulation_circulation_page.dart |

**Domicile**

| Titre lisible | Fichier source |
|---|---|
| Bruits & tapages | content/gpx_scolarite/policier_intervention_initial/domicile/bruits_tapages_page.dart |
| Différend familial | content/gpx_scolarite/policier_intervention_initial/domicile/differend_familial_page.dart |
| Violation de domicile | content/gpx_scolarite/policier_intervention_initial/domicile/violation_domicile_page.dart |
| Violences conjugales | content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart |

**Autres interventions**

| Titre lisible | Fichier source |
|---|---|
| Alertes à la bombe | content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart |
| Identification produits suspects | content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart |
| Ivresse publique manifeste | content/gpx_scolarite/policier_intervention_initial/autres/ivresse_publique_manifeste_page.dart |
| Plans ORSEC | content/gpx_scolarite/policier_intervention_initial/autres/plans_orsec_page.dart |
| Primo-intervenant scène infraction | content/gpx_scolarite/policier_intervention_initial/autres/primo_scene_infraction_amaris_page.dart |

**Formulaires utiles**

| Titre lisible | Fichier source |
|---|---|
| Avis rétention permis | content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/avis_retention_permis_page.dart |
| Fiche descriptive fourrière | content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_descriptive_fourriere_page.dart |
| Fiche immobilisation | content/gpx_scolarite/policier_intervention_initial/formulaires_utiles/fiche_immobilisation_page.dart |

#### Policier en intervention avancé (`policier_intervention_avance/`)

| Titre lisible | Fichier source |
|---|---|
| Accident — annoncer mauvaise nouvelle | content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart |
| Accident — avis à la famille | content/gpx_scolarite/policier_intervention_avance/accident_circulation/avis_famille_page.dart |
| Accident — modèles de plan | content/gpx_scolarite/policier_intervention_avance/accident_circulation/modeles_plan_page.dart |
| Accident — plan des lieux | content/gpx_scolarite/policier_intervention_avance/accident_circulation/plan_lieux_technique_page.dart |
| Accident — renseignements à recueillir | content/gpx_scolarite/policier_intervention_avance/accident_circulation/renseignements_a_recueillir_page.dart |
| Accident — tableau de synthèse | content/gpx_scolarite/policier_intervention_avance/accident_circulation/tableau_synthese_page.dart |
| Animal — chien dangereux | content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart |
| Animal — catégories de chiens | content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart |
| Animal — maltraitance animale | content/gpx_scolarite/policier_intervention_avance/animal/maltraitance_animale_page.dart |
| Animal — protocole morsure | content/gpx_scolarite/policier_intervention_avance/animal/protocole_morsure_page.dart |
| Autres — agression armée/crapuleux | content/gpx_scolarite/policier_intervention_avance/autres/agression_armee_crapuleux_page.dart |
| Autres — alarme établissement | content/gpx_scolarite/policier_intervention_avance/autres/alarme_etablissement_page.dart |
| Autres — incendie primo | content/gpx_scolarite/policier_intervention_avance/autres/incendie_primo_page.dart |
| Autres — levée de doute agression armée | content/gpx_scolarite/policier_intervention_avance/autres/levee_doute_agression_armee_page.dart |
| Autres — plan Vigipirate | content/gpx_scolarite/policier_intervention_avance/autres/plan_vigipirate_page.dart |
| Autres — sinistre | content/gpx_scolarite/policier_intervention_avance/autres/sinistre_page.dart |
| Autres — violation de bar | content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart |
| Débit de boissons — contrôle | content/gpx_scolarite/policier_intervention_avance/debit_boissons/controle_debits_boissons_page.dart |
| Débit de boissons — intervention | content/gpx_scolarite/policier_intervention_avance/debit_boissons/intervention_debit_boissons_page.dart |
| Étrangers — accord Schengen | content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart |
| Étrangers — coopération UE | content/gpx_scolarite/policier_intervention_avance/etrangers/cooperation_ue_page.dart |
| Étrangers — titres de séjour | content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart |
| Malades mentaux — intervenir | content/gpx_scolarite/policier_intervention_avance/malades_mentaux/intervenir_malades_mentaux_page.dart |
| Malades mentaux — soins sans consentement | content/gpx_scolarite/policier_intervention_avance/malades_mentaux/soins_sans_consentement_page.dart |
| Mineurs — protection voie publique | content/gpx_scolarite/policier_intervention_avance/mineurs/protection_mineurs_voie_publique_page.dart |
| Mineurs — statut juridique | content/gpx_scolarite/policier_intervention_avance/mineurs/statut_juridique_mineur_page.dart |
| Stupéfiants — AFD | content/gpx_scolarite/policier_intervention_avance/stupefiants/amende_forfaitaire_delictuelle_page.dart |

#### PV APJ20 — Procès-verbaux (`pv_apj20/`)

**Introduction**

| Titre lisible | Fichier source |
|---|---|
| Préambule PV | content/gpx_scolarite/pv_apj20/introduction/preambule_page.dart |
| Procès-verbaux | content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart |
| Procédure | content/gpx_scolarite/pv_apj20/introduction/procedure_page.dart |
| État civil | content/gpx_scolarite/pv_apj20/introduction/etat_civil_page.dart |

**Constatations**

| Titre lisible | Fichier source |
|---|---|
| Constatations — généralités | content/gpx_scolarite/pv_apj20/constatations/constatations_generalites_page.dart |
| Canevas PV | content/gpx_scolarite/pv_apj20/constatations/canevas_pv_page.dart |

**Plainte**

| Titre lisible | Fichier source |
|---|---|
| Plainte — généralités | content/gpx_scolarite/pv_apj20/plainte/plainte_generalites_page.dart |
| PV saisine personne dénommée | content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_denommee_page.dart |
| PV saisine personne dénommée (suite) | content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_denommee_suite_page.dart |
| PV saisine personne inconnue | content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_inconnue_page.dart |
| PV saisine CX | content/gpx_scolarite/pv_apj20/plainte/pv_saisine_cx_page.dart |
| PV victime violences conjugales | content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart |
| Document info synthétique | content/gpx_scolarite/pv_apj20/plainte/document_info_synthetique_page.dart |
| Présentation grille de danger | content/gpx_scolarite/pv_apj20/plainte/presentation_grille_danger_page.dart |

**Contrôle d'identité**

| Titre lisible | Fichier source |
|---|---|
| CI — généralités | content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart |
| PV contrôle d'identité | content/gpx_scolarite/pv_apj20/controle_identite/pv_controle_identite_page.dart |
| PV CI fiche de recherche | content/gpx_scolarite/pv_apj20/controle_identite/pv_ci_fiche_recherche_page.dart |

**Interpellation**

| Titre lisible | Fichier source |
|---|---|
| Interpellation — généralités | content/gpx_scolarite/pv_apj20/interpellation/interpellation_generalites_page.dart |
| Conduite au poste | content/gpx_scolarite/pv_apj20/interpellation/conduite_au_poste_page.dart |
| Compte-rendu OPJ | content/gpx_scolarite/pv_apj20/interpellation/compte_rendu_opj_page.dart |
| Mandats | content/gpx_scolarite/pv_apj20/interpellation/mandats_page.dart |
| Notification de mandat | content/gpx_scolarite/pv_apj20/interpellation/notification_mandat_page.dart |
| Recherches infructueuses mandat | content/gpx_scolarite/pv_apj20/interpellation/recherches_infructueuses_mandat_page.dart |
| PV interpellation | content/gpx_scolarite/pv_apj20/interpellation/pv_interpellation_page.dart |
| PV CI découverte arme | content/gpx_scolarite/pv_apj20/interpellation/pv_ci_decouverte_arme_page.dart |

**GAV & suspect libre**

| Titre lisible | Fichier source |
|---|---|
| GAV — généralités | content/gpx_scolarite/pv_apj20/gav_suspect_libre/gav_generalites_page.dart |
| Suspect libre — généralités | content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart |
| Avocat — généralités | content/gpx_scolarite/pv_apj20/gav_suspect_libre/avocat_generalites_page.dart |
| Entretien GAV avocat | content/gpx_scolarite/pv_apj20/gav_suspect_libre/entretien_gav_avocat_page.dart |
| Notification droits suspect majeur | content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_droits_suspect_majeur_emprisonnement_page.dart |
| Notification droits art. 65 CPP | content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_droits_article_65_cpp_page.dart |
| Notification audition libre sans emprisonnement | content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_audition_libre_sans_emprisonnement_page.dart |
| Notification GAV droits APJ | content/gpx_scolarite/pv_apj20/gav_suspect_libre/notification_gav_droits_apj_page.dart |

**Audition du suspect**

| Titre lisible | Fichier source |
|---|---|
| Audition suspect — généralités | content/gpx_scolarite/pv_apj20/audition_suspect/audition_suspect_generalites_page.dart |
| Audition suspect libre | content/gpx_scolarite/pv_apj20/audition_suspect/audition_suspect_libre_page.dart |
| Audition en GAV | content/gpx_scolarite/pv_apj20/audition_suspect/audition_gav_page.dart |
| Audition libre — notification droits | content/gpx_scolarite/pv_apj20/audition_suspect/audition_libre_notification_droits_sans_emprisonnement_page.dart |
| Civilement responsable — généralités | content/gpx_scolarite/pv_apj20/audition_suspect/civilement_responsable_generalites_page.dart |
| Civilement responsable — canevas | content/gpx_scolarite/pv_apj20/audition_suspect/civilement_responsable_generalites__canevas_page.dart |

**Témoignage**

| Titre lisible | Fichier source |
|---|---|
| Témoignage — généralités | content/gpx_scolarite/pv_apj20/temoignage/temoignage_generalites_page.dart |
| Audition des témoins | content/gpx_scolarite/pv_apj20/temoignage/audition_temoins_page.dart |
| Enquête de voisinage | content/gpx_scolarite/pv_apj20/temoignage/enquete_voisinage_page.dart |

**Confrontation**

| Titre lisible | Fichier source |
|---|---|
| Confrontation — généralités | content/gpx_scolarite/pv_apj20/confrontation/confrontation_generalites_page.dart |
| Confrontation victime GAV | content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_gav_page.dart |
| Confrontation victime suspect libre | content/gpx_scolarite/pv_apj20/confrontation/confrontation_victime_suspect_libre_emprisonnement_page.dart |

**Réquisitions**

| Titre lisible | Fichier source |
|---|---|
| Réquisitions — généralités | content/gpx_scolarite/pv_apj20/requisitions/requisitions_generalites_page.dart |
| Réquisition personne | content/gpx_scolarite/pv_apj20/requisitions/requisition_personne_page.dart |
| Rapport réquisition personne | content/gpx_scolarite/pv_apj20/requisitions/rapport_requisition_personne_page.dart |

**Perquisition préliminaire**

| Titre lisible | Fichier source |
|---|---|
| Perquisition préliminaire — généralités | content/gpx_scolarite/pv_apj20/perquisition_preliminaire/perquisition_preliminaire_generalites_page.dart |
| Perquisition — perquisition | content/gpx_scolarite/pv_apj20/perquisition_preliminaire/perquisition_preliminaire_perquisition_page.dart |
| Fouille véhicule | content/gpx_scolarite/pv_apj20/perquisition_preliminaire/fouille_vehicule_preliminaire_page.dart |

**IPM**

| Titre lisible | Fichier source |
|---|---|
| IPM — généralités | content/gpx_scolarite/pv_apj20/ipm/ipm_generalites_page.dart |
| PV IPM examen médical | content/gpx_scolarite/pv_apj20/ipm/pv_ipm_examen_medical_page.dart |
| PV IPM remise à tiers | content/gpx_scolarite/pv_apj20/ipm/pv_ipm_remise_tiers_page.dart |

**Circulation routière — alcool**

| Titre lisible | Fichier source |
|---|---|
| Contrôle alcoolémie AS | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart |
| Conduite CEEA positif ou refus | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/conduite_poste_ceea_positif_ou_refus_page.dart |
| Fiches ABC | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/fiches_abc_page.dart |
| Interpellation état d'ivresse | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/interpellation_etat_ivresse_page.dart |
| Prélèvement sanguin | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/prelevement_sanguin_page.dart |
| Réquisition examen clinique | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/requisition_examen_clinique_prelevement_page.dart |
| Tableau des taux | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/tableau_taux_page.dart |
| Vérification/notification taux CEEA | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/verification_notification_taux_ceea_page.dart |
| Vérification taux CEI | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/verification_taux_cei_page.dart |

**Circulation routière — stupéfiants**

| Titre lisible | Fichier source |
|---|---|
| Stupéfiants — généralités | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/stupefiants_generalites_page.dart |
| Dépistage positif ou refus | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/conduite_poste_depistage_positif_ou_refus_page.dart |
| Fiche suivi salivaire | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_salivaire_page.dart |
| Fiche suivi sanguin | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/fiche_suivi_sanguine_page.dart |
| Formulaire information | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/formulaire_information_page.dart |
| Prélèvement sanguin établir usage | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/prelevement_sanguin_etablir_usage_page.dart |
| Refus de vérifications | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/refus_verifications_page.dart |
| Réquisition examen clinique & expertise | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/requisition_examen_clinique_prelevement_expertise_page.dart |
| Suite prélèvement sanguin | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/suite_prelevement_sanguin_page.dart |
| Vérifications établir usage | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/verifications_etablir_usage_stupefiants_page.dart |

**Circulation — contravention 5e**

| Titre lisible | Fichier source |
|---|---|
| Grand excès de vitesse | content/gpx_scolarite/pv_apj20/circulation_routiere/contravention_5e/grand_exces_vitesse_page.dart |
| Tableau des vitesses | content/gpx_scolarite/pv_apj20/circulation_routiere/contravention_5e/tableau_vitesses_page.dart |

**Procédures spéciales — Étrangers**

| Titre lisible | Fichier source |
|---|---|
| Étrangers — généralités | content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/etrangers_generalites_page.dart |
| CI contrôle séjour & circulation | content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/ci_controle_sejour_circulation_page.dart |
| Contrôle séjour & circulation | content/gpx_scolarite/pv_apj20/procedures_speciales/etrangers/controle_sejour_circulation_page.dart |

#### Quiz GPX Scolarité (`quiz_scolarite_gpx/`)

> 66 fichiers quiz couvrant toutes les matières GPX. Route web cible : `/gpx/quiz/[sujet]`

- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_introduction.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_generalite_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_hierarchie_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_infraction_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_classification_infractions_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_complicite_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_tentative_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_legitime_defense_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_droit_penale.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_responsabilite_penal_general.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_usage_armes_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_retention_locaux_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_page_cadres_juridique.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_flagrant_delit_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_enquete_preliminaire_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_commission_rogatoire_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_controle_identite.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_criminalite_organisee.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_disparitions_inquietantes.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_mort_inconnue.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_personnes_fuite.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_action_publique_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_juridiction_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_instruction_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_controle_judiciaire.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_detention_provisoire_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_bracelet_electronique.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_nullite_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_mandats_justice.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_dispositions_applicables_mineurs.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_sanction.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_sanction_classification.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_sanction_aggravation.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_sanction_pluralite.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_armes_munitions_pages.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_stupéfiants.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_circulation_routiere.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_libertes_publiques_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_libertes_publiques_individuelles_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_libertes_publiques_collectives_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_libertes_publiques_garanties_page.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_crimes_delits_personne.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_atteintes_volontaires.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_atteintes_involontaires.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_atteintes_integrite.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_dignite_personne.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_atteinte_personnalite.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_viol_inceste_agressions.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_enregistrement_diffusion_images.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_mise_en_danger.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_crimes_delits_bien.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_voisines_du_vol.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_recel_non_justification.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_destructions_degradations.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_stad.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_crimes_delits_nation.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_atteintes_administration.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_atteintes_action_justice.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_abus_autorite.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_faux_usage_faux.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_probite.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_mineurs_famille.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_autorite_parentale.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_abandon_famille.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_mise_peril_mineurs.dart
- content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_violation_ordonnances_jaf.dart


---

### 9.3 EXAMENS GPX (`lib/content/gpx_exam/`)

#### Structure du concours GPX (`structure_gpx_concours/`)

| Titre lisible | Fichier source |
|---|---|
| Admissibilité GPX | content/gpx_exam/structure_gpx_concours/gpx_admissibilite_page.dart |
| Admission GPX | content/gpx_exam/structure_gpx_concours/gpx_admission_page.dart |
| Tableau récapitulatif épreuves GPX | content/gpx_exam/structure_gpx_concours/tableau_recapitulatif_epreuves_gpx_page.dart |

#### Culture générale (`culture_generale/`)

> Ces fichiers sont des quiz QCM de culture générale. Route web cible : `/gpx/exam/culture-generale/[sujet]`

| Titre lisible | Fichier source |
|---|---|
| Quiz actualité | content/gpx_exam/culture_generale/quiz_culture_generale_actualite.dart |
| Quiz cinéma | content/gpx_exam/culture_generale/quiz_culture_generale_cinema.dart |
| Quiz droit | content/gpx_exam/culture_generale/quiz_culture_generale_droit.dart |
| Quiz France | content/gpx_exam/culture_generale/quiz_culture_generale_france.dart |
| Quiz géographie | content/gpx_exam/culture_generale/quiz_culture_generale_geographie.dart |
| Quiz histoire de France | content/gpx_exam/culture_generale/quiz_culture_generale_histoire_france.dart |
| Quiz institutions européennes | content/gpx_exam/culture_generale/quiz_culture_generale_institutions_europeens.dart |
| Quiz musique | content/gpx_exam/culture_generale/quiz_culture_generale_musique.dart |
| Quiz mythologie | content/gpx_exam/culture_generale/quiz_culture_generale_mythologie.dart |
| Quiz police | content/gpx_exam/culture_generale/quiz_culture_generale_police.dart |
| Quiz santé | content/gpx_exam/culture_generale/quiz_culture_generale_sante.dart |
| Quiz sciences | content/gpx_exam/culture_generale/quiz_culture_generale_sciences.dart |
| Quiz sécurité routière | content/gpx_exam/culture_generale/quiz_culture_generale_securite_routiere.dart |
| Quiz sport | content/gpx_exam/culture_generale/quiz_culture_generale_sport.dart |

#### Langues étrangères (`langue_etrangere/`)

| Titre lisible | Fichier source |
|---|---|
| Quiz allemand | content/gpx_exam/langue_etrangere/quiz_langue_etrangere_allemand.dart |
| Quiz anglais | content/gpx_exam/langue_etrangere/quiz_langue_etrangere_anglais.dart |
| Quiz espagnol | content/gpx_exam/langue_etrangere/quiz_langue_etrangere_espagnol.dart |

#### Tests psychotechniques (`psycotechniques/`)

| Titre lisible | Fichier source |
|---|---|
| Attention visuelle | content/gpx_exam/psycotechniques/attention_visuelle_page.dart |
| Quiz calcul | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_calcul.dart |
| Quiz concentration | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_concentration.dart |
| Quiz raisonnement | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_raisonnement.dart |
| Quiz suites logiques | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_suite_logiques.dart |
| Quiz suite verbale | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_suite_verbal.dart |

#### Cas pratiques (`cas_pratique/`)

| Titre lisible | Fichier source |
|---|---|
| Accueil cas pratique | content/gpx_exam/cas_pratique/cas_pratique_welcome_page.dart |
| Cas pratique 1 | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_1_page.dart |
| Cas pratique 2 | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_2_page.dart |
| Cas pratique 3 | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_3_page.dart |
| Cas pratique 4 | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_4_page.dart |
| Cas pratique 5 | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_5_page.dart |
| Cas pratique 6 | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_6_page.dart |
| Cas pratique dynamique | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_dynamic_page.dart |
| Concours blanc | content/gpx_exam/cas_pratique/concours_blanc_page.dart |
| Leaderboard | content/gpx_exam/cas_pratique/leaderboard_page.dart |

---

### 9.4 RÉSERVE SCOLARITÉ (`lib/content/reserve_scolarite/`)

| Titre lisible | Fichier source |
|---|---|
| Introduction réserve | content/reserve_scolarite/introduction/reserve_introduction_page.dart |

---

## 10. INSTRUCTIONS DE MIGRATION WEB PAR COURS

> **Comment utiliser cette section** : Pour chaque cours listé ci-dessous, lis le fichier Dart et convertis-le en page Next.js.

### Template de prompt à utiliser :

```
Voici le contenu du fichier Dart de la leçon "[NOM DU COURS]" :
[COLLE ICI LE CONTENU DU FICHIER .dart]

Convertis ce cours en une page Next.js (TypeScript) pour le site copiq.fr.
La page doit :
- Être dans src/app/(dashboard)/[concours]/scolarite/[module]/page.tsx
- Utiliser "use client"
- Afficher le contenu en sections lisibles avec Tailwind CSS
- Reprendre fidèlement tout le texte et les sous-sections du cours mobile
- Inclure un bouton "Faire le quiz" si le cours a un quiz associé
- Respecter le design du site (fond sombre, couleurs CopIQ)
```

### Conventions de nommage des routes web

| Concours | Pattern route | Exemple |
|---|---|---|
| PA scolarité | `/pa/scolarite/[module]/[page]` | `/pa/scolarite/dpg/classification-infractions` |
| GPX scolarité | `/gpx/scolarite/[module]/[page]` | `/gpx/scolarite/dps-dpg/classification-infractions` |
| GPX exam | `/gpx/exam/[matiere]/[page]` | `/gpx/exam/culture-generale/actualite` |
| Quiz PA | `/pa/quiz/[sujet]` | `/pa/quiz/classification-infractions` |
| Quiz GPX | `/gpx/quiz/[sujet]` | `/gpx/quiz/circulation-routiere` |
| PV APJ20 | `/gpx/pv-apj20/[section]/[page]` | `/gpx/pv-apj20/plainte/pv-saisine` |

### Cours par priorité de migration

#### PRIORITÉ 1 — PA Scolarité (cours fondamentaux)

| Titre | Fichier source | Route web cible | Has quiz |
|---|---|---|---|
| Classification des infractions | content/pa_scolarite/dpg_pages/classification_infractions_contenu_page.dart | /pa/scolarite/dpg/classification-infractions | oui |
| Infraction — éléments constitutifs | content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart | /pa/scolarite/dpg/elements-constitutifs | oui |
| Loi pénale | content/pa_scolarite/dpg_pages/loi_penale_contenu_page.dart | /pa/scolarite/dpg/loi-penale | oui |
| Responsabilité pénale | content/pa_scolarite/dpg_pages/responsabilite_penale_contenu.dart | /pa/scolarite/dpg/responsabilite-penale | oui |
| Histoire de la Police | content/pa_scolarite/institution_valeurs_pages/histoire_police/histoire_police_page.dart | /pa/scolarite/institutions/histoire-police | non |
| Organisation PN | content/pa_scolarite/institution_valeurs_pages/organisation_pn/organisation_pn_page.dart | /pa/scolarite/institutions/organisation-pn | non |
| Déontologie commentée | content/pa_scolarite/institution_valeurs_pages/deontologie_code_commente/deontologie_code_commente_page.dart | /pa/scolarite/institutions/deontologie | non |
| Droits & obligations | content/pa_scolarite/institution_valeurs_pages/droits_obligations/droits_obligations_page.dart | /pa/scolarite/institutions/droits-obligations | non |
| Flagrant délit — contenu | content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_contenu_page.dart | /pa/scolarite/cadres-juridiques/flagrant-delit | oui |
| Enquête préliminaire — contenu | content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_contenu_page.dart | /pa/scolarite/cadres-juridiques/enquete-preliminaire | oui |
| Contrôle d'identité — contenu | content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_contenu_page.dart | /pa/scolarite/cadres-juridiques/controle-identite | oui |
| GAV — conditions de placement | content/pa_scolarite/procedure_penale_pages/pp_gav_conditions_placement_page.dart | /pa/scolarite/procedure-penale/gav-conditions | non |
| GAV — droits de la personne | content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart | /pa/scolarite/procedure-penale/gav-droits | non |
| Légitime défense | content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_contenu_page.dart | /pa/scolarite/dpg/legitime-defense | oui |
| Usage des armes | content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/usage_des_armes_contenu_page.dart | /pa/scolarite/dpg/usage-armes | oui |
| Viol & agressions — contenu | content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_inceste_agressions_contenu_page.dart | /pa/scolarite/atteintes-personnes/viol-agressions | oui |
| Atteintes à l'administration | content/pa_scolarite/atteintes_nation_pages/atteintes_administration/atteintes_administration_contenu_page.dart | /pa/scolarite/atteintes-nation/administration | oui |
| Stupéfiants — introduction | content/pa_scolarite/stupefiants_pages/introduction_contenu_page.dart | /pa/scolarite/stupefiants/introduction | oui |
| Classification des peines | content/pa_scolarite/sanction_pages/classification_peines_contenu_page.dart | /pa/scolarite/sanctions/classification-peines | oui |
| Rébellion | content/pa_scolarite/atteintes_nation_pages/atteintes_administration/rebellion_contenu_page.dart | /pa/scolarite/atteintes-nation/rebellion | non |

#### PRIORITÉ 2 — GPX Scolarité (cours spécifiques GPX)

| Titre | Fichier source | Route web cible | Has quiz |
|---|---|---|---|
| Hiérarchie OPJ/APJ/APJA | content/gpx_scolarite/dps_dpg/generalite_pages/hierarchie_police/hierarchie_contenu_page.dart | /gpx/scolarite/dps-dpg/hierarchie | oui |
| Rétention locaux police | content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_locaux_contenu.dart | /gpx/scolarite/dps-dpg/retention-locaux | oui |
| Complicité | content/gpx_scolarite/dps_dpg/generalite_pages/complicite/complicite_contenu_page.dart | /gpx/scolarite/dps-dpg/complicite | oui |
| Tentative | content/gpx_scolarite/dps_dpg/generalite_pages/tentative/tentative_contenu_page.dart | /gpx/scolarite/dps-dpg/tentative | oui |
| Libertés publiques intro | content/gpx_scolarite/dps_dpg/libertés_publiques_pages/libertes_publiques_introduction_contenu_page.dart | /gpx/scolarite/dps-dpg/libertes-publiques | oui |
| Criminalité organisée | content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/criminalite_organisee_contenu_page.dart | /gpx/scolarite/cadres-juridiques/criminalite-organisee | oui |
| Commission rogatoire | content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_contenu_page.dart | /gpx/scolarite/cadres-juridiques/commission-rogatoire | oui |
| Mort inconnue | content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_page_contenu.dart | /gpx/scolarite/cadres-juridiques/mort-inconnue | oui |
| Disparitions inquiétantes | content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/disparition/disparitions_inquietantes_contenu.dart | /gpx/scolarite/cadres-juridiques/disparitions | oui |
| Personnes en fuite | content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/personnes_en_fuite/personnes_en_fuite_contenu.dart | /gpx/scolarite/cadres-juridiques/personnes-fuite | oui |
| Entraide judiciaire | content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_contenu_page.dart | /gpx/scolarite/cadres-juridiques/entraide-judiciaire | non |
| Mandats de justice | content/gpx_scolarite/dps_dpg/procédure_pénale_pages/mandats_justice_contenu.dart | /gpx/scolarite/procedure-penale/mandats | oui |
| Détention provisoire | content/gpx_scolarite/dps_dpg/procédure_pénale_pages/detention_provisoire_contenu.dart | /gpx/scolarite/procedure-penale/detention-provisoire | oui |
| Contrôle judiciaire | content/gpx_scolarite/dps_dpg/procédure_pénale_pages/controle_judiciaire_contenu.dart | /gpx/scolarite/procedure-penale/controle-judiciaire | oui |
| Instruction préparatoire | content/gpx_scolarite/dps_dpg/procédure_pénale_pages/instruction_preparatoire_contenu.dart | /gpx/scolarite/procedure-penale/instruction | oui |
| Nullités | content/gpx_scolarite/dps_dpg/procédure_pénale_pages/nullite_contenu_page.dart | /gpx/scolarite/procedure-penale/nullites | oui |
| Traite des êtres humains | content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart | /gpx/scolarite/dps-dpg/traite-etres-humains | non |
| Probité (corruption) | content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/probite/probite_contenu_page.dart | /gpx/scolarite/dps-dpg/probite | oui |
| Faux & usage de faux | content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_usage_faux_contenu_page.dart | /gpx/scolarite/dps-dpg/faux-usage-faux | oui |

#### PRIORITÉ 3 — GPX Exam

| Titre | Fichier source | Route web cible | Has quiz |
|---|---|---|---|
| Structure admissibilité | content/gpx_exam/structure_gpx_concours/gpx_admissibilite_page.dart | /gpx/exam/structure/admissibilite | non |
| Structure admission | content/gpx_exam/structure_gpx_concours/gpx_admission_page.dart | /gpx/exam/structure/admission | non |
| Culture générale — Actualité | content/gpx_exam/culture_generale/quiz_culture_generale_actualite.dart | /gpx/exam/culture-generale/actualite | oui |
| Culture générale — France | content/gpx_exam/culture_generale/quiz_culture_generale_france.dart | /gpx/exam/culture-generale/france | oui |
| Culture générale — Histoire | content/gpx_exam/culture_generale/quiz_culture_generale_histoire_france.dart | /gpx/exam/culture-generale/histoire | oui |
| Culture générale — Police | content/gpx_exam/culture_generale/quiz_culture_generale_police.dart | /gpx/exam/culture-generale/police | oui |
| Langue — Anglais | content/gpx_exam/langue_etrangere/quiz_langue_etrangere_anglais.dart | /gpx/exam/langue/anglais | oui |
| Langue — Espagnol | content/gpx_exam/langue_etrangere/quiz_langue_etrangere_espagnol.dart | /gpx/exam/langue/espagnol | oui |
| Psychotechniques — Calcul | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_calcul.dart | /gpx/exam/psychotechniques/calcul | oui |
| Psychotechniques — Raisonnement | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_raisonnement.dart | /gpx/exam/psychotechniques/raisonnement | oui |
| Psychotechniques — Suites logiques | content/gpx_exam/psycotechniques/quiz_tests_psycotechniques_suite_logiques.dart | /gpx/exam/psychotechniques/suites-logiques | oui |
| Cas pratique 1 | content/gpx_exam/cas_pratique/cas_pratique_excercice/case_1_page.dart | /gpx/exam/cas-pratique/1 | non |

#### PRIORITÉ 4 — PV APJ20 (procès-verbaux modèles)

| Titre | Fichier source | Route web cible | Has quiz |
|---|---|---|---|
| Plainte — généralités | content/gpx_scolarite/pv_apj20/plainte/plainte_generalites_page.dart | /gpx/pv-apj20/plainte/generalites | non |
| PV saisine personne dénommée | content/gpx_scolarite/pv_apj20/plainte/pv_saisine_personne_denommee_page.dart | /gpx/pv-apj20/plainte/personne-denommee | non |
| GAV — généralités | content/gpx_scolarite/pv_apj20/gav_suspect_libre/gav_generalites_page.dart | /gpx/pv-apj20/gav/generalites | non |
| Audition suspect — généralités | content/gpx_scolarite/pv_apj20/audition_suspect/audition_suspect_generalites_page.dart | /gpx/pv-apj20/audition/generalites | non |
| Interpellation — généralités | content/gpx_scolarite/pv_apj20/interpellation/interpellation_generalites_page.dart | /gpx/pv-apj20/interpellation/generalites | non |
| Contrôle alcoolémie | content/gpx_scolarite/pv_apj20/circulation_routiere/alcool/as_controle_alcoolemie_page.dart | /gpx/pv-apj20/circulation/alcool | non |
| Dépistage stupéfiants | content/gpx_scolarite/pv_apj20/circulation_routiere/stupefiants/stupefiants_generalites_page.dart | /gpx/pv-apj20/circulation/stupefiants | non |
| Perquisition préliminaire | content/gpx_scolarite/pv_apj20/perquisition_preliminaire/perquisition_preliminaire_generalites_page.dart | /gpx/pv-apj20/perquisition/generalites | non |

---

## 11. NOTES TECHNIQUES POUR LA MIGRATION

### Structure d'un fichier Dart de cours

Un fichier de cours Flutter contient typiquement :
- **`routeName`** : la route mobile (ex: `/gpx/generalites/classification_infractions_cards`)
- **`_SectionCard` ou `_InfractionCard`** : cartes de contenu cliquables
- **`_p()` ou `Text()`** : paragraphes de texte
- **Sous-pages liées** : imports d'autres `.dart` pour le contenu détaillé

### Fichiers de quiz

Les fichiers `quiz_*.dart` contiennent une liste de `QuizQuestion` avec :
- `question` : le texte de la question
- `answers` : liste de réponses
- `correctIndex` : index de la bonne réponse
- `explanation` (optionnel) : explication de la réponse

Ces données sont stockées en Supabase. Pour la version web, interroger la table `quiz_questions` avec `WHERE topic = '[NOM_TOPIC]'`.

### Composant Next.js type pour un cours

```tsx
// src/app/(dashboard)/[concours]/scolarite/[module]/page.tsx
"use client";
import { useState } from "react";

export default function CoursPage() {
  return (
    <div className="min-h-screen bg-[#1a1a2e] text-white p-6">
      <h1 className="text-2xl font-black mb-6">TITRE DU COURS</h1>
      
      <section className="mb-8">
        <h2 className="text-lg font-bold text-blue-400 mb-3">Sous-section</h2>
        <p className="text-gray-200 leading-relaxed">
          Contenu du cours...
        </p>
      </section>
      
      {/* Bouton quiz si applicable */}
      <button className="mt-8 w-full py-4 bg-blue-600 hover:bg-blue-700 rounded-xl font-bold text-lg">
        Faire le quiz
      </button>
    </div>
  );
}
```

