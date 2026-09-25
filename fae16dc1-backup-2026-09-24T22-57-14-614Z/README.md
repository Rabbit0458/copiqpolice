# COP'IQ Web — architecture et maintenance

> Source : `copiq-web/deploy/docs/README.md`, recopié dans `fae16dc1/`.

---

## 1. Ce dossier

`fae16dc1/` est un **dossier généré**. Il est produit par
`copiq-web/scripts/publish-static.mjs` à partir de `copiq-web/out`, lui-même
produit par `next build`.

**N'écrivez jamais directement dedans** : la publication suivante le remplace
et renomme l'ancien en `fae16dc1-backup-<horodatage>/`. Tout se modifie dans
`copiq-web/src/`.

```
copiq-web/src  ──next build──▶  copiq-web/out  ──publish-static.mjs──▶  fae16dc1/  ──FTP──▶  copiq.fr
```

Voir `DEPLOYMENT.md` pour la procédure de transfert.

## 2. Pile technique

| Élément | Choix | Pourquoi |
|---|---|---|
| Framework | Next.js 16, App Router, `output: "export"` | hébergement mutualisé Apache, aucun serveur Node à administrer |
| CSS | Tailwind v4 + variables CSS | thème clair/sombre piloté par `--surface`, `--on-surface`… |
| Typographie | **Instrument Sans**, famille unique | police déjà embarquée dans l'application Flutter (`assets/fonts/InstrumentSans-*`) ; accents français complets ; auto-hébergée par `next/font` donc aucune requête tierce. La hiérarchie d'affichage vient du poids, de l'interlettrage négatif et de l'échelle, pas d'une deuxième fonte |
| Backend | Supabase (Auth, Postgres + RLS, Storage, Edge Functions) | partagé avec l'application mobile : même compte, même progression |
| Paiement web | Stripe via Edge Functions | l'export statique ne peut pas héberger de webhook |
| Paiement mobile | RevenueCat → App Store / Google Play | `purchases_flutter` côté Flutter |

## 3. Arborescence utile

```
copiq-web/src/
├── app/
│   ├── page.tsx                 Accueil → features/landing/landing-v4.tsx
│   ├── not-found.tsx            404
│   ├── layout.tsx               Coque racine, police, copiq-config.js
│   ├── robots.ts, sitemap.ts
│   ├── (public)/                Pages publiques (en-tête + pied de page communs)
│   │   ├── preparation/[slug]/  Guides SEO  ← src/data/seo-pages.ts
│   │   ├── ressources/          Hub éditorial
│   │   ├── tarifs/  blog/  faq/  contact/  informations/
│   │   └── cgu/  privacy/  mentions-legales/     ← contenu juridique, à ne pas réécrire
│   ├── (auth)/                  login, signup, forgot-password, confirm
│   ├── (dashboard)/             Application web authentifiée (22 routes)
│   ├── admin/                   ZONE INTERDITE — ne pas modifier
│   └── api/                     Non déployé (export statique). Code mort conservé.
├── components/
│   ├── brand/copiq-logo.tsx     Seul point d'entrée du logo officiel
│   ├── marketing/               Vitrine
│   ├── layout/                  Barre latérale et en-tête de l'application
│   ├── ui/                      Primitives partagées
│   └── admin/                   ZONE INTERDITE
├── config/pathways.ts           Nomenclature des 4 parcours — SOURCE DE VÉRITÉ
├── data/
│   ├── marketing.ts             Faits produit sourcés, assets, tarifs, lancement
│   ├── seo-pages.ts             Contenu des guides
│   ├── blog.ts, modules.ts
├── features/
│   ├── landing/landing-page.tsx Ancienne vitrine — CONSERVÉE pour rollback
│   └── landing/landing-v4.tsx   Vitrine actuelle
├── lib/supabase/                Client, serveur, middleware
└── styles/globals.css           Jetons + design system COP'IQ Web V4
```

## 4. Design system

Tout est dans `src/styles/globals.css`. Le bloc de la refonte commence à la
bannière « DESIGN SYSTEM — COP'IQ WEB V4 » et est **purement additif** :
supprimer ce bloc rend le fichier à son état antérieur.

### Couleurs

| Jeton | Valeur | Emploi |
|---|---|---|
| `--brand` | `#1147D9` | bleu France COP'IQ, actions principales |
| `--navy` | `#000B36` | bleu nuit, fonds immersifs |
| `--copiq-red` | `#E0162B` | **accent de marque**, relevé dans le logo |
| `--danger` | `#EF4444` | **erreurs uniquement** — ne jamais l'utiliser comme accent |
| `--surface`, `--on-surface`, `--outline` | variables | suivent le thème clair/sombre |

La séparation `--copiq-red` / `--danger` est volontaire : un accent de marque
et un message d'erreur doivent rester distinguables.

### Primitives `cq-*`

| Classe | Effet |
|---|---|
| `cq-night` | fond bleu nuit avec deux sources de lumière (bleu à gauche, rouge à droite) |
| `cq-synapse` | motif cérébral discret, deux dégradés radiaux, 0 requête réseau |
| `cq-halo` / `cq-halo-red` | halo derrière un élément mis en scène |
| `cq-edge-light` | filet lumineux en haut d'une carte sombre |
| `cq-photo` + `-grade` `-scrim` `-vignette` | traitement photographique : overlay bleu nuit, désaturation légère, voile horizontal pour le texte, vignettage. **Les fichiers originaux ne sont jamais modifiés** |
| `cq-display` `cq-title` `cq-lead` `cq-eyebrow` | échelle typographique |
| `cq-reveal` | reveal au scroll, au niveau des blocs de section |
| `cq-tap` | cible tactile de 44 px minimum |
| `cq-skip` | lien d'évitement |
| `cq-float` `cq-drift` `cq-grow` | mouvements lents, neutralisés par `prefers-reduced-motion` |

> Ces règles vivent dans `@layer components`. En Tailwind v4, du CSS hors
> layer gagne contre `@layer utilities` : sans ce layer,
> `.cq-photo { position: relative }` écraserait la classe `absolute`. Ne pas
> les en sortir. Seuls le focus visible et le bloc `prefers-reduced-motion`
> restent hors layer, volontairement.

### Règles de rédaction visuelle

Ce qui est proscrit, et pourquoi : dégradé violet SaaS générique, emojis dans
les titres, glassmorphism partout, grille de cartes identiques, badges
« BEST SELLER », fade-in sur chaque paragraphe, grain artificiel. Une
technologie n'est pas interdite en soi — elle l'est sans justification UX ou
d'identité.

## 5. Règles à respecter en maintenance

### Le logo

Toujours via `<CopiqLogo />` ou `<CopiqWordmark />`. Jamais recréé en CSS,
jamais recoloré, jamais étiré, jamais remplacé par une icône. Son PNG a un
**fond noir opaque** : il doit rester dans sa pastille sombre, sinon un carré
noir apparaît sur les surfaces claires.

### Les chiffres

Toute affirmation chiffrée passe par `src/data/marketing.ts` et **porte sa
source** dans le champ `source`. Interdits faute de source : nombre
d'utilisateurs, nombre de téléchargements, taux de réussite, classement,
témoignages. `TESTIMONIALS` est vide tant qu'aucun retour réel n'est fourni.

### La nomenclature

Les libellés des parcours viennent de `src/config/pathways.ts`, qui reflète
l'application. Ne pas inventer un second vocabulaire pour le web.

### L'indépendance institutionnelle

`INDEPENDENCE_NOTICE` doit rester visible sur la vitrine et dans le pied de
page de toutes les pages publiques. COP'IQ n'est pas le site officiel de la
Police nationale.

### Le paiement

Le seul chemin valide est
`supabase.functions.invoke("cas_pratique_create_checkout")`, depuis
`src/app/(dashboard)/abonnement/page.tsx`. Les routes `src/app/api/stripe/*`
ne sont **pas déployées** : ne pas y renvoyer de `fetch`.

### `admin/`

`src/app/admin/`, `src/components/admin/` et `src/lib/admin/` sont hors
périmètre. Ne rien y déplacer, renommer, refactoriser ni « moderniser ».

## 6. Ajouter du contenu

### Un guide de préparation

Ajouter une entrée dans `src/data/seo-pages.ts`. La route, le sitemap, le fil
d'Ariane, les données structurées et les liens croisés suivent
automatiquement. Aucun fichier de page à créer.

### Un article

Ajouter une entrée dans `src/data/blog.ts`. Il apparaît sur `/blog`, sur
`/ressources` et dans le sitemap.

### Une capacité produit

Ajouter une entrée dans `CAPABILITIES` (`src/data/marketing.ts`), avec son
champ `source` pointant le code qui l'implémente réellement.

## 7. Avant chaque publication

```bash
cd copiq-web
npx tsc --noEmit          # 0 erreur hors tests/ (voir note)
npm run lint
npm run build             # doit terminer par « Compiled successfully »
npm run publish:folder
```

Note : `npx tsc --noEmit` signale quatre erreurs `TS5097` dans `tests/`
(imports en `.ts`, exécutés par `node --experimental-strip-types`). Elles
préexistent à la refonte et n'affectent pas le build.

Puis la liste de vérification de `DEPLOYMENT.md` §4, en commençant par
`/admin/`.
