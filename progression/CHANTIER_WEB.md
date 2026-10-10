# CHANTIER WEB — Parité parfaite entre l’application COP’IQ et copiq.fr

> **Fichier de pilotage du chantier web.** À lire en premier à chaque reprise.
> Créé le 9 octobre 2026. Mis à jour à chaque livraison (journal en bas).
>
> Objectif : un site qui correspond **exactement** à l’application (mêmes parcours, mêmes cartes, mêmes contenus, mêmes règles d’accès) et qui est **synchronisé** avec elle (même base Supabase `nuoonagnkhbeeymtvrcn`, mêmes tables, mêmes écritures), avec une interface web haut de gamme et des animations fluides.

| Symbole | Signification |
|---|---|
| ✅ | fait, testé et livré |
| 🟡 | en cours / partiel |
| ⬜ | à faire |
| 📱 | disponible dans l’app, pas encore sur le site (page « Disponible dans l’application » affichée) |

---

## 1. Règles du chantier

1. **L’application Flutter est la référence.** Le site ne crée pas de seconde vérité : il lit et écrit les mêmes tables, avec les mêmes noms (`module_name`, `quiz_name`, `track`, `mode`…), pour que le suivi soit identique sur le téléphone et sur l’ordinateur.
2. **On ne supprime rien.** Les anciennes pages du site restent dans le code (non reliées si remplacées). Intouchables : dossier `admin`, page de confirmation e-mail (`/confirm`), `/auth/callback`, page `https://copiq.fr/reset-password/` (présente seulement sur le serveur).
3. **Règle d’uniformisation** (`REGLE_PERMANENTE_UNIFORMISATION_COPIQ.md`) : une correction faite sur un écran est appliquée à tous les écrans homologues des 4 parcours.
4. Source du site : `copiq-web/`. Export hébergé : `fae16dc1/` (jamais modifié à la main ; régénéré puis envoyé **en entier** avec FileZilla).
5. Inventaire détaillé de l’app (fait le 9/10/2026, à garder à jour) : dossier de travail `inventaire/` (4 fichiers, ~3 500 lignes) résumé ci-dessous.

---

## 2. Ce que fait l’application (inventaire)

### 2.1 Choix du parcours et droits d’accès

- Le parcours est stocké dans `user_profiles.user_track` (`pa` | `gpx`) et `user_profiles.user_mode` (`exam` | `school`). Écrans : `onboarding/mode_picker.dart` → `grade_picker.dart` → `home_bootstrap.dart`.
- **Premium** = RPC `is_user_premium(uid)` (abonnement Stripe, achat App Store / Google Play ou propriétaire). Résumé complet par `get_my_entitlement()` : rôle, `premium`, plan, statut, quota gratuit.
- **Concours (PA / GPX)** : accessibles à tous ; quota gratuit de **10 lancements de quiz par 7 jours** (`free_weekly_usage`, RPC `consume_free_request`), illimité en Premium.
- **Scolarité (PA / GPX)** : **réservée aux abonnés Premium** (`canAccessPremiumContent` → `PremiumRequiredPage`).
- Mode « Policier actif » : accès par vérification (`active_access_status`), hors abonnement. Mode « Réserve » : désactivé.
- ⚠️ Côté base, aucune règle Premium n’est imposée (RLS = connecté + publié). Le contrôle est fait par l’app, et maintenant par le site.

### 2.2 Les 4 accueils (Home)

Structure commune : salutation « Bonjour {prénom} » → recherche → titre du parcours → « Sélection de contenu » → **deck de cartes glissantes** (`_HeroDeck`) → bloc sous le deck → barre de navigation à 5 onglets (Accueil, Suivi, Forum, Favoris, Profil).

Deck : pile de cartes (pas un carrousel classique), carte active à 78 % de la largeur, voisines à 90 %, décalées de 52 px et abaissées de 18 px, opacité 75 %, glisser au doigt puis ressort (raideur 420, amortissement 32). Carte : image plein cadre, dégradé noir, favori, sur-titre, titre, bouton « Découvrir » / « Reprendre ».

| Parcours | Cartes du deck | Bloc sous le deck |
|---|---|---|
| PA concours | Les épreuves du concours PA · Photolangage · Tests psychotechniques · Connaissances générales | « Continue ta préparation » (dernier quiz, série, objectif 3/jour) |
| GPX concours | Structure du concours · Cas pratique · Culture générale (15 thèmes) · Langue étrangère · Tests psychotechniques (9) | « Ta prochaine étape » adaptative |
| PA scolarité | 3 programmes : Institution & Valeurs (7) · DPS/DPG (21) · Mémento circulation (3) | « Ta prochaine étape » (module au hasard) |
| GPX scolarité | 7 programmes : Institution & Valeurs · DPS/DPG · Mémento circulation · Intervention socle initial · Intervention socle avancé · Recueil PV APJ 20 · Dimension humaine | idem |

Cartographie pyramidale : parcours → programme → carte (domaine) → module (feuille) → cours ou quiz. **655 cartes et modules**, tous résolus. Arborescence portée sur le site : `copiq-web/src/data/app-tree.json` (générée par `tools/tree/gen_web_tree.py`).

### 2.3 Sources des contenus

| Contenu | Source | Sur le site |
|---|---|---|
| Culture générale PA/GPX (QCM) | `quiz_questions` filtrée par `category` (tirage `rand_key`) | ✅ |
| Quiz de scolarité (48 quiz, ~49 000 questions) | `quiz_scolarite_questions` par `module` | ✅ |
| Cours de scolarité (451 cours) | texte : `scolarite_content_fragments` (par fichier Dart, chapitre = `panel`) ; fiches dynamiques : `cours_scolarite.body_md` | ✅ |
| Épreuves du concours PA (tableau, visite médicale) | `cours_scolarite` | ✅ |
| Structure du concours GPX | pages Dart | 📱 |
| Langue étrangère (anglais, espagnol, allemand) | questions codées en dur dans Dart (348 à 441 par langue) | 📱 → à importer en base |
| Tests psychotechniques GPX | 8 tables `tests_psyco_*` + `tests_psychotechnique_history` | 📱 → lot 3 |
| Tests psychotechniques PA | 2 en base + 4 banques Dart (2 600 à 4 100 questions) | 📱 → lot 3 |
| Photolangage PA | `photolangage_cases` / `_drafts` / `_attempts` + Edge Function `photolangage-correct` | 📱 → lot 4 |
| Cas pratique GPX | `cas_pratique_*` + moteur de correction Dart | 📱 → lot 5 |
| Concours blanc | RPC `fn_cp_start_mock_exam` / `fn_cp_finish_mock_exam` (non ouvert dans l’app) | ⬜ |

### 2.4 Contrat d’écriture (synchronisation)

Identique pour tous les QCM :
1. **Début** : insertion `quiz_history` `{uid, email, module_name, quiz_name, score:0, correct_count:0, total_questions, mode, track, started_at}`. Le site crée la ligne à la **première réponse** (pas de ligne vide si on quitte sans jouer, comme l’app qui supprime une tentative à 0 réponse).
2. **Chaque réponse** : RPC `record_learning_answer` (17 paramètres, idempotente par `p_client_event_id`).
3. **Fin ou abandon** : mise à jour `quiz_history` `{total_questions: répondues, score: %, correct_count, finished_at, completed_at}`.

Noms repris de l’app : culture générale GPX `module_name='Culture générale'`, `quiz_name='Quiz culture générale <thème>'` ; PA préfixe `PA - ` ; scolarité `module_name` = domaine, `quiz_name` = titre du quiz.

---

## 3. Matrice de parité app ↔ site

| Fonction | App | Site | État |
|---|---|---|---|
| Choix du parcours, scolarité verrouillée sans Premium | ✅ | ✅ | ✅ 09/10 |
| Verdict Premium identique (stores compris) | ✅ | ✅ `get_my_entitlement` | ✅ 09/10 |
| Quota gratuit 10 quiz / 7 jours | ✅ | ✅ `consume_free_request` au lancement | ✅ 09/10 |
| Accueil par parcours + deck de cartes | ✅ | ✅ version ordinateur (flèches, clavier, molette) | ✅ 09/10 |
| Recherche dans les contenus | ✅ | ✅ (cartes + modules) | ✅ 09/10 |
| Programmes de scolarité | ✅ | ✅ onglets | ✅ 09/10 |
| Page catégorie (liste de modules) | ✅ | ✅ | ✅ 09/10 |
| Lecteur de cours (chapitres) | ✅ | ✅ | ✅ 09/10 |
| Quiz : niveau + taille de session + correction + explication | ✅ | ✅ | ✅ 09/10 |
| « Continue ta préparation » / « Ta prochaine étape » | ✅ | ✅ | ✅ 09/10 |
| Suivi (progression) | ✅ | ✅ `/progression` | ✅ 09/10 |
| Favoris | ✅ (local) | 🟡 cœur sur les cartes (local) ; page `/favoris` à relier | ⬜ |
| Dernier module « Reprendre » | ✅ | ✅ | ✅ 09/10 |
| Signalement d’une question | ✅ | ⬜ | ⬜ |
| Tests psychotechniques | ✅ | 📱 | ⬜ lot 3 |
| Langue étrangère | ✅ | 📱 | ⬜ lot 2 |
| Photolangage | ✅ | 📱 | ⬜ lot 4 |
| Cas pratiques corrigés | ✅ | 📱 | ⬜ lot 5 |
| Forum par parcours | ✅ | 🟡 (anciennes données factices) | ⬜ lot 6 |
| Profil, paramètres, abonnement | ✅ | 🟡 | ⬜ lot 7 |

---

## 4. Feuille de route

- **Lot 1 — Socle et parité de navigation** ✅ (9/10/2026) : droits d’accès, choix du parcours, 4 accueils avec deck, catégories, lecteur de cours, quiz réels synchronisés, logo dans l’onglet et dans les aperçus de lien.
- **Lot 2 — Langue étrangère** ⬜ : importer les 3 banques Dart dans une table (`quiz_langue_questions` ou `quiz_questions` avec une catégorie dédiée) puis les servir au site **et** à l’app.
- **Lot 3 — Tests psychotechniques** ⬜ : GPX (8 tables `tests_psyco_*`, chronos, mode concours) puis PA ; écriture `tests_psychotechnique_history` comme l’app.
- **Lot 4 — Photolangage** ⬜ : sujets, chrono, brouillons, envoi, correction par l’Edge Function, résultat détaillé.
- **Lot 5 — Cas pratiques** ⬜ : portage du moteur de correction (`core/cas_pratique/engine`) ou passage en Edge Function partagée.
- **Lot 6 — Forum** ⬜ : vraies tables `forum_posts_*`, espace du parcours, badges.
- **Lot 7 — Compte** ⬜ : profil, favoris synchronisés, notifications, abonnement Stripe en production.
- **Lot 8 — Finitions** ⬜ : structure du concours GPX (contenu à mettre en base), mises en page spécifiques de certains cours (tableaux, organigrammes), tests 375 / 768 / 1024 / 1440 px.

---

## 5. Anomalies relevées dans l’app pendant l’inventaire (à corriger côté app)

1. **Culture générale « Histoire de France »** : l’app interroge la catégorie `Histoire`, qui **n’existe pas** dans `quiz_questions` (catégories réelles : Actualite, Cinema, Droit, France, Geographie, Institutions, Musique, Mythologie, Police, Sante, Sciences, Securite, Sport). Le quiz est donc vide dans l’app. Le site utilise `France`.
2. **Double décompte du quota** possible sur l’accueil GPX concours (décompte explicite + observateur de navigation).
3. Le quota est aussi consommé à l’ouverture de **pages de menu** dont le nom contient `quiz`, `/gpx_exam` ou `/pa_exam`.
4. `photolangage_attempts` est inséré sans `user_id`, `track` ni `mode` alors que le suivi PA filtre sur ces colonnes (à vérifier en base).
5. `quiz_scolarite_session` ne filtre pas `publication_status` (des questions non publiées peuvent sortir dans l’app).
6. Les modules de quiz importés ont des titres techniques (« Pa Quiz Stad.dart ») ; le site affiche les libellés du menu.
7. Sécurité : le contrôle Premium n’existe que dans les clients (app et site). Une règle serveur (RLS ou RPC) protégerait réellement les contenus de scolarité.

---

## 6. Journal des livraisons

### 9 octobre 2026 — Lot 1

- Inventaire complet de l’app (accueils, cartes, examens, scolarité, droits) et création de ce fichier.
- Site : droits via `get_my_entitlement` (abonnés App Store / Google Play reconnus), scolarité verrouillée sans Premium (choix du parcours, accueil, catégories, modules).
- Nouvel accueil `/dashboard` par parcours, identique à l’app : salutation, recherche, deck de cartes glissantes (ressort, glisser, flèches, clavier, molette), programmes de scolarité, « Continue ta préparation » / « Ta prochaine étape », série et objectif du jour, toutes les catégories.
- Pages `/parcours/categorie/` (liste de modules façon `_ModuleCard`) et `/parcours/module/` (cours, quiz ou contenu à venir).
- Lecteur de cours : texte de l’app (`scolarite_content_fragments`), chapitres, transitions, points clés.
- Quiz réels : choix du niveau et de la taille comme dans l’app, correction immédiate, explications, résultat animé, synchronisation `quiz_history` + `record_learning_answer`, quota gratuit.
- Menu latéral = cartes du deck du parcours. Logo PNG dans l’onglet (`favicon.ico`) et dans l’aperçu des liens partagés.
- 237 images de l’app converties en WebP pour le site (8,7 Mo).
- Mode sombre : le site suit désormais le bouton clair/sombre partout (variante `dark` liée à la classe `.dark`).
- Anciennes pages de démonstration (`/pa/quiz`, `/gpx/quiz`, `/culture-generale`, `/langues`, `/pa|gpx/scolarite`, `/pa|gpx/cours`) conservées dans le code mais redirigées vers l’accueil du parcours.
- Tests automatisés (navigateur) : 4 accueils, deck (glisser, flèches), recherche, catégorie, intro de quiz, quiz (écritures `quiz_history` + `record_learning_answer` vérifiées), lecteur de cours, choix du parcours, mobile 390 px sans débordement.

### 10 octobre 2026 — Correctifs visuels et synchronisation

- **Synchronisation réparée (site ET app)** : la RPC `record_learning_answer` échouait (« permission denied for table quiz_answer_history ») car elle utilisait `ON CONFLICT DO UPDATE` sans droit UPDATE. Remplacée par `ON CONFLICT DO NOTHING` + relecture de l’id (même signature, même retour, idempotence conservée). Testée dans une transaction annulée. Migration : `copiq-web/supabase/migrations/20261010000500_fix_record_learning_answer_upsert.sql`. Avant ce correctif, plus aucune réponse détaillée n’était enregistrée depuis le 6 octobre, y compris depuis l’app.
- Deck : cartes au format portrait comme sur le téléphone, éventail centré, cartes voisines opaques assombries (plus de texte superposé), hauteur adaptée à l’écran.
- Accueil : salutation et recherche sur une ligne, programmes en pastilles compactes, typographie allégée.
- Catégories : en-tête compact (visuel portrait) et modules en lignes lisibles (vignette, « Module n », type) au lieu de grandes bannières identiques.
- Quiz : écran de départ compact, question et réponses à taille raisonnable, bouton « Question suivante » qui ne recouvre plus l’explication.
- Libellés nettoyés (plus de « d\'enquête »), logo ajouté dans la barre du haut, icône d’onglet servie sous un nouveau nom pour forcer Safari à la recharger.

### 10/10 — 01 h 40 · Refonte visuelle v6 (retour « mise en page ne ressemble à rien »)
- Système visuel unique calqué sur l’app pour tout l’espace connecté : fond #F5F6F8, encre #1C1C1C, cartes blanches 24 px, CTA anthracite ; mode sombre neutre #0E0F12 (tokens limités à l’espace connecté via `html:has(.cq-app-shell)`, admin non touché).
- Menu latéral clair, pastille active anthracite ; bouton Premium et avatar en encre ; conteneur unique 1240 px.
- Accueil : salutation + recherche + bouton « changer de parcours », titre du parcours, programmes sur une ligne, deck fidèle à l’app (carte 80 %, voisines à 90 % qui dépassent derrière, ressort 420/32) + panneau de la catégorie active (modules au programme, « Voir les N modules »), puis « Ta prochaine étape » et « Ma régularité ». Grille « Toutes les catégories » retirée.
- Nouvel en-tête image commun (`features/parcours/ui.tsx` : PageHero) pour catégorie, cours, quiz, contenu à venir.
- Catégorie : cartes module de l’app (_ModuleCard) quand les modules ont leurs images, sinon sommaire numéroté (fini les vignettes répétées).
- Quiz : réglages à gauche, récapitulatif + Commencer à droite. Cours : sommaire en carte + chapitre.
- 141 images recadrées (bande grise de ~72 px en bas des visuels de l’app).
- Vérifié 1440×900, 1000×640, mobile 390, clair/sombre. fae16dc1 remplacé (sauvegarde fae16dc1-backup-20261009-2337).
- Reste à harmoniser au même style : Progression (bandeau bleu nuit), Historique, Favoris, Profil, Abonnement, Forum, Paramètres (lot 7).

### 10/10 — 05 h 30 · Cours manquants (retour « tu oublies énormément de cours »)
- Cause : l’arborescence du site s’arrêtait au 2e niveau des cartes de l’app. Beaucoup de feuilles ouvrent en réalité une page d’accroche (« COMMENCER »), un sommaire de sous-cours (cartes « PDF ») ou plusieurs pages ; le site n’affichait que la page d’accroche (3 lignes) ou le sommaire.
- Correctif : nouveau graphe de navigation des fichiers Dart (`tools/courses/graph.py` + `resolve.py`, routes nommées, `routeName` statiques, `push` directs) appelé par `gen_web_tree.py`. Chaque cours suit la navigation réelle de l’app : intro → contenu, sommaires → sous-cours (jusqu’à 3 niveaux) + quiz du sommaire (module déduit du chemin, 45/45 vérifiés en base).
- Résultat scolarité : 449 → 896 cours, 106 sommaires, 126 quiz (dont 78 quiz de sommaires). Ex. « De la responsabilité pénale » → Principes généraux, Complicité et coaction, Personnes morales, Causes d’irresponsabilité + quiz ; « Cadres juridiques » 11 → 58 cours.
- Anomalie app corrigée côté site : « Contrôles et vérifications d’identité » (GPX) ouvrait le flagrant délit ; le site ouvre le vrai cours (introduction, chapitre 1 avec 9 parties, relevé, vérification d’identité, quiz). À corriger dans l’app : `home_page_gpx_school.dart` l. 4010.
- Lecteur de cours refait comme l’app : une page qui défile en cartes colorées (couleurs reprises des pages Flutter), sous-titres numérotés, listes cochées, encadrés « Exemple / Idée clé », références légales en rouge, sommaire fixe qui suit la lecture + progression. Les lignes Dart coupées sont recollées en vrais paragraphes (`course-parse.ts`).
- Limites connues : quelques mots constants du code Dart ne sont pas dans `scolarite_content_fragments` (ex. « Selon » devant « l’article 121-7 »), donc absents du site ; « Découverte d’une personne grièvement blessée » n’a pas de contenu dans l’app non plus (page vide).
