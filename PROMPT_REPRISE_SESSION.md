# Prompt de reprise — COP'IQ

> Copie **tout ce qui suit la ligne de séparation** et colle-le dans un nouveau chat.

---

Tu reprends le développement de **COP'IQ**, mon application mobile de préparation
aux concours de la Police Nationale française. Voici tout le contexte. Lis-le
entièrement avant d'agir.

## Qui je suis, ce que j'attends

Je m'appelle Kaïs. L'app est **à quelques tâches du dépôt sur les stores**.
Chaque tâche doit être réalisée minutieusement, avec le maximum de détails et un
professionnalisme digne des plus grandes entreprises. Rendu visuel parfait.

**Règles permanentes, non négociables :**

1. **Avant d'exécuter une tâche, vérifie qu'elle n'a pas déjà été faite.** Lis le
   code, interroge la base. Ne refais jamais un travail déjà en place.
2. **Ne casse pas l'app.** Aucune erreur générée. Si tu en produis une, tu la
   corriges toi-même.
3. **Vérifie ton travail** après chaque tâche (simulation SQL sous RLS, contrôle
   de syntaxe, cohérence des routes).
4. Archive dans `_archive/` au lieu de supprimer.
5. Applique les migrations Supabase toi-même.

## Architecture

| Élément | Chemin / valeur |
|---|---|
| Racine projet | `C:\Users\kaiso\Desktop\copiqpolice` |
| App Flutter | `lib/` — Dart 3.8 |
| Site + panel admin | `copiq-web/` — Next.js 16, `output: "export"` |
| Dossier livré à l'hébergeur | `fae16dc1/` (je le glisse entier à chaque MAJ) |
| Projet Supabase | `nuoonagnkhbeeymtvrcn` |
| Rapport d'état | `RESTE_A_FAIRE.md` (à la racine — **lis-le en premier**) |

**Quatre modules** : GPX Exam, GPX Scolarité, PA Exam, PA Scolarité.

**Pièges structurels à connaître :**

- `main.dart` déclare `library copiqpolice_app` ; `routes/app_router.dart` est un
  `part of`. **Tous les imports du routeur vivent dans `main.dart`.**
- `RouteRegistry.routes` contient **1033 routes, 0 doublon**. Une clé dupliquée
  écrase silencieusement la précédente — c'est ce qui cassait les pages psycho.
- Les `redirectConfig` des home pages ont été renommés
  (`redirectConfigHome`, `redirectConfigGpxSchool`, `redirectConfigPaSchool`).
  L'homonymie masquait un bug d'accent (`/gpx_scolarité_pages`) depuis des mois.
- **Next.js est en export statique : aucun code serveur ne tourne en prod.**
  Toute la sécurité doit vivre dans PostgreSQL (RLS + RPC `SECURITY DEFINER`).

## Sécurité — acquis à ne jamais casser

- Les **grilles de correction** (2 283 mots-clés) sont **inaccessibles en lecture
  directe**. Le moteur Dart passe par le RPC `cp_get_rubric_for_attempt(uuid)`,
  qui ne renvoie la grille que pour une tentative appartenant à l'appelant.
  **Ne rétablis jamais de SELECT direct sur `cas_pratique_rubric_points`,
  `cas_pratique_keyword_groups` ou `cas_pratique_keywords`.**
- Une fuite RGPD majeure a été refermée : `contact_messages` était lisible **et
  modifiable sans être connecté** ; 93 tables `quiz_*` exposaient l'e-mail et les
  réponses de tous les élèves. Le panel admin lit via RPC `SECURITY DEFINER`.
- Le panel admin (`copiq.fr/admin`) a **3 barrières** : mot de passe → TOTP
  (Google Authenticator, AAL2) → code staff.
- `replicate_token.txt` à la racine contient une **clé API en clair**. Elle est
  gitignorée mais **doit être révoquée et régénérée**.

## Cas pratique — le module le plus sensible

C'est celui qui ne fonctionnait pas du tout et qui a été réparé. État actuel :

- **22 cas publiés**, 62 questions, **405 points de correction**,
  **2 283 mots-clés**, 62 réponses modèles, **8 thèmes tous couverts**.
- Moteur : normaliseur → tokeniseur → lemmatiseur → Levenshtein → détecteur de
  négation → synonymes → matcher → évaluateur → scoreur.
  Sémantique : **ET** entre groupes, **OU** dans un groupe. Couvert = poids
  plein, ≥ 50 % = moitié, sinon 0. Normalisé sur `max_points`.
- Un trigger resynchronise `total_points` à chaque modification de question.
- Un garde refuse la publication d'un cas dépourvu de grille.

**Format pour semer une grille** — `fn_cp_seed_question_rubric(jsonb)` :

```json
{
  "case": "slug-du-cas",
  "q": 1,
  "refs": ["art. 78-2 CPP"],
  "perfect": "Réponse modèle en markdown, structurée et pédagogique.",
  "points": [
    { "label": "…", "weight": 3.0, "kind": "core",
      "expl": "…", "groups": [["mot","synonyme"], ["autre groupe"]] }
  ]
}
```

Les mots-clés s'écrivent **sans accents ni ponctuation** (le normaliseur les
retire). `kind` vaut `core` ou `bonus`.

## Vérification obligatoire après toute modification du module

Simuler un parcours élève complet **sous `role = authenticated` avec RLS
active**, en extrayant les identifiants de points **depuis le RPC**, jamais
depuis les tables protégées. Les 9 assertions doivent passer :
cas visible = 1, questions lisibles = 3, **grille en lecture directe = 0**,
**mots-clés en lecture directe = 0**, tentative créée, réponses = 3,
questions via RPC = 3, points via RPC = attendu, nettoyage OK.

## Ce qui reste à faire

| Priorité | Sujet |
|---|---|
| 🔴 P0 | `flutter analyze` + `flutter test` + test sur device réel (je dois le faire moi-même, Flutter n'est pas dans ton environnement) |
| 🟠 P1 | Activer Apple/Google dans le portail Apple Developer + Supabase (guide : `docs/AUTH_OAUTH_SETUP.md`) |
| 🟠 P1 | Checklist stores : comptes, keystore, certificats, captures, textes ASO |
| 🟠 P1 | Compléter les mentions légales : SIREN, adresse, médiateur (crochets à remplir dans `copiq-web/src/app/(public)/mentions-legales/page.tsx`) — omission punie par la LCEN art. 6 VI |
| 🟡 P2 | Enrichir les cas pratiques 22 → 40 |
| 🟡 P2 | Page de statut, audit d'accessibilité (VoiceOver/TalkBack), `flutter gen-l10n` |
| 🟡 P2 | Activer `pg_cron` (Database → Extensions) — non installé, requis pour les tâches planifiées |

## Limites de ton environnement

- **Flutter n'est pas installé** : tu ne peux pas compiler ni lancer les tests.
  Fais des vérifications statiques (parsing, équilibrage des délimiteurs,
  cohérence des routes et des imports).
- `sentry_flutter` est absent du `pubspec` et Firebase n'est pas configuré
  (pas de `google-services.json`). **N'appelle jamais `Firebase.initializeApp()`** :
  ça planterait au démarrage. Les crashs partent dans la table `app_logs`.

---

**Commence par lire `RESTE_A_FAIRE.md`, puis dis-moi ce que tu comptes faire
avant de coder.**
