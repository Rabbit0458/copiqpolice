# COP'IQ — Préparation aux concours de la Police Nationale

Application Flutter (iOS / Android) + site web Next.js, adossés à Supabase.

Quatre parcours : **Gardien de la Paix** (concours et école) et **Policier Adjoint**
(concours et école).

---

## Démarrage

```bash
flutter pub get
flutter run
```

```bash
cd copiq-web
npm install
npm run dev          # http://localhost:3000
npm run build        # génère l'export intermédiaire out/
```

Pour préparer automatiquement la livraison, double-cliquer sur
`PUBLIER_SITE.command`. Le script compile le site, contrôle les routes critiques,
reprend la configuration publique Supabase de l'app Flutter et remplace de façon
sûre `fae16dc1/`. **Seul le dossier `fae16dc1` est à glisser chez l'hébergeur.**

---

## Structure

| Chemin | Contenu |
|---|---|
| `lib/main.dart` | Point d'entrée. Contient les 1 391 imports ; `routes/app_router.dart` en est un `part`. |
| `lib/routes/app_router.dart` | **975 routes nommées.** Toute nouvelle page s'enregistre ici. |
| `lib/content/gpx_exam/` | GPX Concours — cas pratique, culture générale, psychotechniques, langues |
| `lib/content/gpx_scolarite/` | GPX École — 788 fichiers de cours et quiz |
| `lib/content/pa_exam/` | PA Concours — culture générale, psychotechniques, photolangage |
| `lib/content/pa_scolarite/` | PA École — 638 fichiers |
| `lib/features/` | Auth, home pages, forum, mémos, notes, favoris, onboarding |
| `lib/core/cas_pratique/engine/` | Moteur de correction (normalisation, lemmatisation, matching) |
| `lib/data/cas_pratique/` | Repository Supabase du module cas pratique |
| `copiq-web/` | Site Next.js — **source** (export statique) |
| `copiq-web/src/app/admin/` | **Panel administrateur** → `copiq.fr/admin` |
| `fae16dc1/` | Dossier final vérifié — à déposer tel quel chez l'hébergeur |
| `PUBLIER_SITE.command` | Compilation et régénération automatique de `fae16dc1/` |
| `supabase/migrations/` | Migrations SQL |
| `docs/` | Spécifications et annales PDF |
| `_archive/` | Fichiers retirés de la racine (ignoré par git) — voir `_archive/INDEX.md` |

---

## Ajouter une page

1. Créer le fichier avec `static const String routeName = '/...';`
2. Ajouter l'import dans **`lib/main.dart`**
3. Ajouter l'entrée dans **`RouteRegistry.routes`** (`lib/routes/app_router.dart`)
4. Ajouter le lien dans la home page du parcours concerné

> ⚠️ Les étapes 2 et 3 sont **obligatoires**. Un audit de juillet 2026 a trouvé
> 81 pages écrites mais jamais enregistrées : les utilisateurs tombaient sur
> l'écran 404. Voir `RESTE_A_FAIRE.md`.

---

## Panel administrateur

`https://copiq.fr/admin` — trois barrières : mot de passe, code Google
Authenticator, code staff personnel. Toute la sécurité est imposée dans
PostgreSQL, pas dans le navigateur.

Documentation : `copiq-web/src/app/admin/README.md`

---

## Documents de référence

| Fichier | Contenu |
|---|---|
| **`RESTE_A_FAIRE.md`** | **État réel du projet et travail restant. À lire en premier.** |
| `docs/PROGRESSION_GLOBAL.md` | Feuille de route par phases (A → N) |
| `ADMIN_PANEL_PROGRESSION.md` | Spécification du panel administrateur |
| `DOCUMENTATION_COMPLETE.md` | Documentation fonctionnelle détaillée |
| `docs/cas_pratique/` | Spécifications du module Cas Pratique |
| `_archive/INDEX.md` | Ce qui a été archivé et pourquoi |

---

## Avant de commiter

```bash
flutter analyze          # doit renvoyer 0 issue
flutter test
cd copiq-web && npm run build
```
