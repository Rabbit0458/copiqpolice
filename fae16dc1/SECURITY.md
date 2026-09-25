# COP'IQ Web — Sécurité

> Source : `copiq-web/deploy/docs/SECURITY.md`, recopié dans `fae16dc1/`.
> Ce fichier ne contient **aucun secret** et ne doit jamais en contenir :
> il est publié à la racine du site.

---

## 1. Modèle de sécurité

Le site est un **export statique**. Il n'exécute aucun code serveur et ne
détient aucun secret. Tout ce qui est sensible se passe ailleurs :

| Opération | Où elle s'exécute | Ce qui la protège |
|---|---|---|
| Authentification | Supabase Auth | JWT, session côté client, RLS en base |
| Accès aux données | Supabase | **RLS PostgreSQL** — le navigateur n'a que la clé anon |
| Création d'un paiement | Edge Function `cas_pratique_create_checkout` | JWT obligatoire, prix résolu côté serveur |
| Attribution de Premium | Edge Function `cas_pratique_stripe_webhook` | signature Stripe vérifiée côté serveur |
| Correction des cas pratiques | Edge Function `cas_pratique_correct_attempt` | rate limiting `fn_cp_consume_token` |
| Administration | `/admin` + contrôles PostgreSQL | mot de passe + TOTP + code staff, imposés en base |

**Conséquence pratique :** modifier une valeur dans le navigateur ne donne pas
Premium. Le niveau d'abonnement est lu depuis `cas_pratique_subscriptions`,
écrit uniquement par le webhook Stripe côté serveur.

## 2. Ce qui est exposé dans `fae16dc1/`, volontairement

`copiq-config.js` contient deux valeurs **publiques par nature** :

```js
window.COPIQ_CONFIG = {
  SUPABASE_URL: "https://<projet>.supabase.co",
  SUPABASE_ANON_KEY: "<clé anon>",
  SITE_URL: "https://copiq.fr"
}
```

La clé anon est faite pour être dans le navigateur : c'est la RLS qui protège
les données, pas le secret de cette clé.

**Ce qui n'est jamais dans l'export :** `SUPABASE_SERVICE_ROLE_KEY`,
`STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`. Le script de publication ne
copie que l'URL et la clé anon. Si vous voyez une de ces trois valeurs dans un
fichier de `fae16dc1/`, **ne déployez pas** et prévenez immédiatement.

## 3. En-têtes HTTP (`.htaccess`)

Déjà en place, non modifiés par la refonte :

- HTTPS forcé (301) ;
- `Strict-Transport-Security: max-age=31536000; includeSubDomains` ;
- `X-Frame-Options: SAMEORIGIN`, `X-Content-Type-Options: nosniff` ;
- `Referrer-Policy: strict-origin-when-cross-origin` ;
- `Permissions-Policy: camera=(), microphone=(), geolocation=()` ;
- `Options -Indexes` (pas de listing de dossiers) ;
- CSP complète : `object-src 'none'`, `base-uri 'self'`,
  `frame-ancestors 'self'`, `form-action` limité à Stripe Checkout,
  `connect-src` limité à Supabase et à l'API Stripe.

La refonte n'a eu besoin d'**aucun assouplissement** de la CSP : les images
officielles viennent du bucket public Supabase, déjà couvert par
`img-src https:`, et la police Instrument Sans est auto-hébergée par
`next/font` (aucune requête vers Google Fonts au rendu).

## 4. Paiement — état vérifié

`cas_pratique_create_checkout` fait déjà l'essentiel correctement :

- JWT obligatoire, vérifié par `auth.getUser(jwt)` ;
- `plan` validé contre une liste blanche `["week","month","year"]` ;
- **le prix n'est jamais fourni par le client** : le Price ID vient des
  variables d'environnement de la fonction, puis est revérifié auprès de
  Stripe (actif, récurrent, bon intervalle) ;
- URLs de retour contraintes par une **allowlist d'hôtes et de chemins**
  (`sanitizeReturnUrl`) — pas de redirection ouverte ;
- le Stripe Customer est retrouvé ou créé côté serveur, avec
  `supabase_user_id` en metadata ;
- côté client, le bouton se verrouille pendant l'appel : un double-clic ne
  crée pas deux sessions.

### Actions recommandées, non appliquées

Ces deux points touchent une Edge Function en production : ils n'ont pas été
appliqués sans validation du propriétaire.

**S1 — Appliquer le rate limiting à la création de session.**
Le helper existe déjà (`supabase/functions/_shared/rate_limit.ts`, seau à
jetons sur `fn_cp_consume_token`) mais `cas_pratique_create_checkout` ne
l'appelle pas. Un JWT valide peut donc enchaîner les créations de session.
Cela ne facture personne, mais cela pollue Stripe et consomme du quota.
Correctif type, à ajouter juste après la validation du JWT :

```ts
import { consumeRateLimit, rateLimitedResponse, RATE_PROFILES } from "../_shared/rate_limit.ts"
// …
const rl = await consumeRateLimit(userClient, "cp.create_checkout", {
  scope: "cp.create_checkout", capacity: 10, refillPerWindow: 10, windowSeconds: 600,
})
if (!rl.allowed) return rateLimitedResponse(rl)
```

Attention : le profil `cp.create_checkout` doit exister côté PostgreSQL avant
le déploiement, sinon la fonction échouera — et comme il s'agit d'un paiement,
elle doit **échouer fermée** (refuser), ce qui bloquerait les abonnements.
À tester d'abord sur une branche Supabase.

**S2 — Clé d'idempotence Stripe.**
`stripe.checkout.sessions.create` peut recevoir une clé d'idempotence dérivée
de `userId + plan + fenêtre de temps`. Aujourd'hui la seule protection contre
le double-clic est côté navigateur, ce qui suffit en pratique mais pas en
théorie.

## 5. Autres constats

| # | Constat | Gravité | État |
|---|---|---|---|
| S3 | La CSP autorise `script-src 'unsafe-inline'`, nécessaire à l'hydratation Next actuelle | faible | dette documentée |
| S4 | `src/middleware.ts` existe mais n'est **jamais exécuté** (`output: "export"` ignore le middleware) — il ne protège rien | faible | documentaire ; ne pas s'en servir comme garde d'accès |
| S5 | `src/app/api/*` n'est pas déployé : quatre routes Stripe / suppression de compte sont du code mort | faible | conservé, non appelé |
| S6 | Aucune observabilité front : aucune erreur JavaScript n'est remontée | moyenne | voir §6 |

## 6. Observabilité (§34 du cahier des charges)

Rien n'est en place côté web aujourd'hui. Aucun service payant n'a été
souscrit à l'initiative de la refonte. Trois options, par coût croissant :

1. **Gratuit, immédiat.** `supabase.functions.invoke` journalise déjà côté
   Supabase : les journaux des Edge Functions donnent les erreurs de paiement
   et de correction, c'est-à-dire les plus critiques. À consulter dans le
   tableau de bord Supabase.
2. **Gratuit, à écrire.** Un `window.onerror` / `onunhandledrejection` qui
   POST vers une nouvelle Edge Function `web_client_error`, écrivant dans une
   table avec RLS en insertion seule et purge automatique. Compter une
   demi-journée. **Ne jamais y envoyer de JWT, d'e-mail ni de contenu de
   formulaire.**
3. **Payant.** Sentry ou équivalent. Nécessite d'ajouter son domaine à
   `connect-src` dans la CSP et de configurer le filtrage des données
   personnelles.

Recommandation : (1) tout de suite, (2) avant la sortie publique.

## 7. Principe « fail closed »

À vérifier après chaque déploiement : en cas d'échec, une opération sensible
doit **refuser**, pas laisser passer.

- Paiement : si `resolvePlanPrice` échoue, la fonction renvoie `503`
  `plan_not_configured` et **aucune session n'est créée**. Correct.
- Premium : attribué uniquement par le webhook, après vérification de
  signature. Aucun chemin client ne peut l'accorder. Correct.
- Correction de cas pratique : en cas d'indisponibilité, l'utilisateur voit
  une erreur et peut réessayer ; aucune note n'est inventée. Correct.
- Vitrine : dégradation élégante. Le contenu est statique et reste lisible même
  si Supabase est indisponible ; un repli `<noscript>` garantit que les
  sections restent visibles sans JavaScript.

## 8. Signaler une vulnérabilité

Utiliser le formulaire de contact du site. Ne publier aucun détail avant
correction. Ne joindre ni identifiants, ni jetons, ni données d'un autre
utilisateur.
