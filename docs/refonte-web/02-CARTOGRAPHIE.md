# COP'IQ — Refonte web · PHASE B : cartographie PROTÉGÉ / CONSERVÉ / REFONDU / NOUVEAU

Règle de lecture : **PROTÉGÉ** = je n'ouvre pas. **CONSERVÉ** = je lis, je
n'écris pas. **REFONDU** = je modifie, avec rollback documenté.
**NOUVEAU** = j'ajoute, rien n'est écrasé.

---

## PROTÉGÉ — interdiction absolue (§1, §30)

| Chemin | Raison |
|---|---|
| `copiq-web/src/app/admin/**` | Panel administrateur opérationnel, 21 pages |
| `copiq-web/src/components/admin/**` | `admin-gate.tsx` porte l'A2F (mot de passe + TOTP + code staff) |
| `copiq-web/src/lib/admin/**` | 2 700 lignes d'API admin |
| `supabase/migrations/**`, `supabase/rollbacks/**` | Schéma et RLS |
| `supabase/functions/**` | Backend en production (→ voir « recommandations » dans SECURITY.md, aucune modification appliquée) |
| `lib/**` (Flutter) | Application mobile — lue en source de vérité, jamais modifiée |
| `android/`, `ios/`, `fastlane/` | Chaînes de build boutiques |
| `copiq-web/src/app/api/**` | Code mort, mais laissé en place tel quel |
| `copiq-web/src/middleware.ts` | Inerte en export statique, laissé en place |
| `fae16dc1-backup-*/` | Sauvegardes de publications précédentes |

## CONSERVÉ — logique métier intacte (§2)

| Chemin | Rôle |
|---|---|
| `src/lib/supabase/{client,server,middleware}.ts` | Auth et accès données |
| `src/app/(dashboard)/layout.tsx` | Garde d'accès + parcours |
| `src/app/(dashboard)/abonnement/page.tsx` | **Seul chemin de paiement valide** (Edge Functions) |
| `src/features/pathway/**` | Sélection et persistance du parcours |
| `src/app/(auth)/**`, `src/app/auth/callback/page.tsx` | Tunnel d'authentification |
| `src/data/{blog,modules}.ts`, `src/config/pathways.ts` | Données de contenu |
| `src/lib/consent.ts`, `src/components/cookie-banner.tsx` | Conformité RGPD |
| `copiq-web/scripts/publish-static.mjs` | Pipeline de livraison (étendu, pas réécrit) |
| `copiq-web/deploy/.htaccess` | En-têtes de sécurité et rewrites (étendu, pas réécrit) |
| Contenu juridique de `/cgu`, `/privacy`, `/mentions-legales` | §46 — UI harmonisée, **texte non modifié** |

## REFONDU — UI/UX seulement

| Chemin | Nature du changement | Rollback |
|---|---|---|
| `src/app/page.tsx` | 1 ligne : l'import de la vitrine pointe sur la nouvelle version | remettre `LandingPage` |
| `src/app/(public)/layout.tsx` | En-tête et pied de page : logo officiel, navigation, mention d'indépendance, suppression des emojis | `git checkout` du fichier |
| `src/styles/globals.css` | **Ajout** d'un bloc de tokens « COP'IQ Web V4 » en fin de fichier ; aucun token existant n'est modifié | supprimer le bloc ajouté |
| `src/app/sitemap.ts` | Ajout des URLs manquantes et des nouvelles pages SEO | `git checkout` |
| `src/app/robots.ts` | Ajout des nouveaux chemins publics à `allow` | `git checkout` |
| `src/app/(public)/tarifs/page.tsx` | Refonte visuelle + ajout du plan hebdomadaire réel (4,99 €) ; **aucun prix inventé ni modifié** | `git checkout` |

> `src/features/landing/landing-page.tsx` n'est **pas** modifié et n'est **pas**
> supprimé. Il reste le point de retour immédiat.

## NOUVEAU — ajouts

| Chemin | Rôle |
|---|---|
| `src/features/landing/landing-v4.tsx` | Nouvelle vitrine |
| `src/components/marketing/**` | Composants de la vitrine (hero, bandes éditoriales, compositions produit, tarifs, FAQ, témoignages) |
| `src/components/brand/copiq-logo.tsx` | Composant unique qui sert le logo officiel, ratio verrouillé |
| `src/data/marketing.ts` | Faits produit, tous sourcés ; tableau de témoignages **vide** en attente du propriétaire |
| `src/data/seo-pages.ts` | Contenu des pages d'acquisition |
| `src/app/(public)/preparation/[slug]/page.tsx` | Pages SEO de préparation |
| `src/app/(public)/ressources/**` | Hub Ressources |
| `src/app/not-found.tsx` | 404 COP'IQ |
| `copiq-web/deploy/docs/{README,DEPLOYMENT,CHANGELOG,SECURITY}.md` | Documents de livraison recopiés dans `fae16dc1/` |
| `docs/refonte-web/**` | Audit, cartographie, décisions |

---

## Architecture SEO cible (§40)

Slugs courts, un seul `H1` par page, `canonical`, données structurées.

| URL | Cible |
|---|---|
| `/preparation/gardien-de-la-paix` | concours gardien de la paix / GPX |
| `/preparation/policier-adjoint` | concours policier adjoint |
| `/preparation/tests-psychotechniques` | psychotechniques police |
| `/preparation/cas-pratique` | cas pratique GPX |
| `/preparation/culture-generale` | culture générale police |
| `/preparation/oral` | préparation à l'oral |
| `/preparation/reserve` | réserve de la Police nationale |
| `/ressources` | hub éditorial (le blog existant y est agrégé, `/blog` reste en place) |

Aucune redirection n'est créée : ces URLs n'existaient pas.
`/blog` et `/blog/[slug]` sont **conservés** — pas de 301, pas de chaîne.

## Décisions techniques prises seules (§59)

1. **Typographie : Instrument Sans conservée, en famille unique.** C'est la
   police embarquée dans l'app Flutter (`assets/fonts/InstrumentSans-*`), elle
   couvre les accents français, elle est déjà chargée par `next/font` (donc
   auto-hébergée, sans requête tierce au rendu). La hiérarchie « display » est
   obtenue par le poids, l'interlettrage négatif et l'échelle — pas par une
   seconde fonte. Cela évite un mélange serif/sans arbitraire (§8) et coûte
   0 ko de plus. Une fonte d'affichage dédiée resterait possible plus tard sans
   rien casser.
2. **Le rouge COP'IQ devient un jeton distinct de `--danger`.** `#E0162B`,
   relevé dans le cerveau du logo. Il sert d'accent de marque ; `--danger`
   (`#EF4444`) reste réservé aux erreurs. Sans cette séparation, un accent de
   marque et un message d'erreur seraient indiscernables.
3. **Le logo est servi sur fond sombre.** Son PNG a un fond noir opaque : sur
   une surface claire il afficherait un carré noir. Le composant `CopiqLogo`
   l'enferme donc dans une pastille bleu nuit, ce qui respecte §61 (« son
   environnement peut recevoir lumière, halo, background ») sans toucher au fichier.
4. **Pas de copie locale des assets Supabase** (§71) : le bucket est public,
   la CSP et `next.config.ts` l'autorisent déjà, et `output: "export"` ne
   permettrait pas d'optimisation serveur de toute façon.
5. **Les compositions produit sont du DOM réel** et non des captures : aucune
   capture n'existe dans le dépôt, et fabriquer de faux écrans serait une preuve
   sociale inventée.
