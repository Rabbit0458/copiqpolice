# COP'IQ Web — Journal des modifications

> Source : `copiq-web/deploy/docs/CHANGELOG.md`, recopié dans `fae16dc1/`.

---

## Refonte de la vitrine — 2026-09-25

Refonte **UI/UX**. Aucun fichier supprimé, aucune URL cassée, aucune table ni
migration Supabase touchée, `admin/` non modifié.

### Ajouté

| Fichier | Rôle |
|---|---|
| `src/components/brand/copiq-logo.tsx` | Point d'entrée unique du logo officiel, ratio 1:1 verrouillé |
| `src/components/marketing/hero.tsx` | Hero : composition à trois plans + photographie officielle |
| `src/components/marketing/product-composition.tsx` | Panneaux d'interface COP'IQ en DOM réel |
| `src/components/marketing/sections.tsx` | Parcours, bande cas pratiques, fonctionnalités, photolangage, témoignages, clôture, mention d'indépendance |
| `src/components/marketing/pricing-section.tsx` | Tarifs |
| `src/components/marketing/faq-section.tsx` | FAQ (`<details>` natif) + données structurées |
| `src/components/marketing/site-chrome.tsx` | En-tête et pied de page publics |
| `src/components/marketing/reveal.tsx` | Mécanisme de reveal unique |
| `src/features/landing/landing-v4.tsx` | Nouvelle vitrine |
| `src/data/marketing.ts` | Faits produit sourcés, assets, tarifs, lancement, témoignages |
| `src/data/seo-pages.ts` | Contenu des sept guides de préparation |
| `src/app/(public)/preparation/[slug]/page.tsx` | `/preparation/*` |
| `src/app/(public)/ressources/page.tsx` | Hub Ressources |
| `src/app/not-found.tsx` | 404 COP'IQ |
| `deploy/docs/*.md` | Documents de livraison |

Nouvelles URLs (aucune redirection nécessaire, elles n'existaient pas) :

```
/preparation/gardien-de-la-paix
/preparation/policier-adjoint
/preparation/tests-psychotechniques
/preparation/cas-pratique
/preparation/culture-generale
/preparation/oral
/preparation/reserve
/ressources
```

### Modifié

| Fichier | Modification |
|---|---|
| `src/app/page.tsx` | Pointe sur `LandingV4` ; données structurées Organization / Service / FAQPage |
| `src/app/(public)/layout.tsx` | En-tête et pied de page refondus, logo officiel, mention d'indépendance, lien d'évitement |
| `src/app/(auth)/layout.tsx` | Chiffres non sourcés remplacés par des faits vérifiables, logo officiel, emoji retiré |
| `src/app/(public)/tarifs/page.tsx` | Refonte ; ajout du plan hebdomadaire 4,99 € ; tableau comparatif corrigé |
| `src/app/sitemap.ts` | Ajout des nouvelles pages et de `/faq`, `/informations`, `/notes-de-mise-a-jour` |
| `src/app/robots.ts` | Ajout des nouveaux chemins publics à `allow` |
| `src/app/layout.tsx` | Repli `<noscript>` pour que les sections restent lisibles sans JavaScript |
| `src/styles/globals.css` | Bloc « Design system COP'IQ Web V4 » ajouté en fin de fichier |
| `src/components/cookie-banner.tsx` | Contraste du lien « Politique de confidentialité » en thème sombre |
| `src/features/auth/login-form.tsx`, `confirm-email.tsx` | Contraste de deux libellés secondaires |

### Conservé intact

- `src/features/landing/landing-page.tsx` — ancienne vitrine, point de retour immédiat ;
- `src/app/admin/**`, `src/components/admin/**`, `src/lib/admin/**` — zone interdite ;
- `src/app/(dashboard)/**` — application web authentifiée, y compris le tunnel de paiement ;
- `src/app/api/**` — code non déployé par l'export statique, laissé en place ;
- le contenu juridique de `/cgu`, `/privacy`, `/mentions-legales` ;
- `supabase/**` — aucune migration, aucune RLS, aucune Edge Function modifiée.

---

## Corrections de fond incluses dans cette refonte

### 1. `tailwind.config.ts` n'était pas chargé

Le projet est en Tailwind v4 (`@import "tailwindcss"`), qui n'ouvre plus
`tailwind.config.ts` sans directive `@config`. Les classes `bg-brand`,
`text-brand`, `shadow-card`, `shadow-card-hover`, `animate-scale-in`…
utilisées dans `src/components/ui/`, `src/components/layout/`,
`src/features/auth/`, `src/features/quiz/` et `src/features/dashboard/`
**ne produisaient aucun style**. Vérifié sur le CSS compilé : `.bg-brand`
apparaissait 0 fois.

Les mêmes valeurs sont désormais déclarées en `@theme inline` dans
`globals.css`, en faisant référence aux variables CSS existantes pour que les
surfaces continuent de suivre le thème clair/sombre. Effet visible : le volet
gauche des pages de connexion et d'inscription, qui était censé être bleu
nuit, l'est enfin.

### 2. Preuve sociale inventée sur les pages d'authentification

`src/app/(auth)/layout.tsx` affichait « 95 % — Satisfaction », « 200+ Cours »
et « 5 000+ Questions » sans aucune source, et la vitrine affichait
« 5 000+ questions » deux blocs avant « Quiz de base (50 questions) ».

Remplacés par des faits recomptés et reproductibles
(`src/data/marketing.ts`, champ `source` de chaque fait) :

```bash
grep -rho --include="*.dart" -F "QuizQuestion("   lib | wc -l   # 53 838
grep -rho --include="*.dart" -F "PaQuizQuestion(" lib | wc -l   # 13 509
```

d'où l'affirmation retenue, volontairement basse : **« plus de 60 000
questions »**. Les 1 400+ fiches correspondent à
`760 + 650 + 39 + 35 = 1 484` fichiers de `lib/content/`.

### 3. Logo recréé en CSS

`(public)/layout.tsx` et `(auth)/layout.tsx` dessinaient un carré dégradé
avec la lettre « C ». Le logo officiel
(`assets/logo-png-copiq.png`) est maintenant servi par un composant unique.
Son PNG ayant un **fond noir opaque**, il est systématiquement posé dans une
pastille bleu nuit — sinon il afficherait un carré noir sur fond clair.

### 4. Liens publics vers des routes authentifiées

Le pied de page renvoyait vers `/pa/scolarite` et `/gpx/scolarite`, qui
exigent une session : un visiteur non connecté était éjecté vers `/login`.
Ces liens pointent désormais vers les pages `/preparation/*`.

### 5. Le plan hebdomadaire n'était pas sur la page Tarifs

Le plan `week` à 4,99 € est vendable et proposé dans `/abonnement`, mais
`/tarifs` ne présentait que 0 €, 8,99 € et 86,99 €.

### 6. Avantages annuels inexistants

Le tableau comparatif de `/tarifs` promettait « support prioritaire » et
« accès anticipé aux nouveautés » pour l'annuel. L'offre réelle ne fait
aucune différence de contenu entre les périodicités. Lignes retirées.

### 7. Contraste

Audit programmatique des ratios WCAG sur l'accueil, `/tarifs`,
`/preparation/*` et `/login`, dans les deux thèmes. Corrections : opacités de
texte blanc relevées de 30–45 % à 55 %, variantes sombres ajoutées sur les
libellés bleus, couleurs de parcours déplacées du texte vers une pastille
(plusieurs tombaient sous 4,5:1 en thème sombre). Résultat : 0 échec sur les
pages refondues.

### 8. Les `@layer` de Tailwind v4

Les primitives `cq-*` ont d'abord été écrites hors `@layer` : en v4, du CSS
non layé gagne contre `@layer utilities`, si bien que
`.cq-photo { position: relative }` écrasait `absolute` et cassait
silencieusement une mise en page. Elles sont désormais dans
`@layer components`, pour que les utilitaires Tailwind gardent le dernier mot.
Seuls le focus visible et le bloc `prefers-reduced-motion` restent hors layer,
volontairement.

---

## Points laissés à la décision du propriétaire

Ils sont signalés, **pas** modifiés.

1. **Libellé de repli du tarif annuel dans l'application.**
   `lib/core/services/subscription_plan.dart:36` affiche `79,99 € / an`, alors
   que Stripe et `lib/legal/legal_content.dart` disent 86,99 €. Le prix réel
   vient toujours de la boutique, donc l'impact est limité au temps de
   chargement — mais l'écart est visible.

2. **`lib/content/paywall/cp_pricing_plans.dart`.**
   Ce widget propose 9,99 €/mois, 79 €/an et un plan « à vie » à 149 € qui
   n'existe nulle part ailleurs. Il n'est importé par aucun fichier. À
   supprimer ou à aligner — décision commerciale.

3. **Témoignages.** `TESTIMONIALS` dans `src/data/marketing.ts` est
   volontairement vide : aucun retour utilisateur réel n'existe dans le dépôt.
   La section est construite et apparaît dès qu'un témoignage réel y est
   ajouté. Aucun prénom, aucune note, aucune citation n'a été inventé.

4. **Liens App Store et Google Play.** `LAUNCH` dans
   `src/data/marketing.ts` : mettre les deux URLs puis passer `status` à
   `"live"` le jour de la sortie. Tant qu'une URL est absente, aucun badge de
   boutique n'est affiché.

5. **Sémantique du variant `dark:` de Tailwind.** En v4 sans `@config`,
   `dark:` suit la préférence du système, pas la classe `.dark` posée par
   `next-themes`. Les composants de la refonte contournent le problème avec
   `[.dark_&]:`. Le corriger globalement (`@custom-variant dark
   (&:where(.dark, .dark *))`) changerait le rendu de 36 occurrences dans
   `admin/`, qui est une zone interdite : cette décision n'a donc pas été
   prise seule.

6. **Rate limiting sur la création de session Stripe.** Voir `SECURITY.md`.
