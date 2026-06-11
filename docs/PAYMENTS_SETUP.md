# 💳 COP'IQ — Guide de mise en place du système de paiement & monétisation

> **À lire en premier**. Ce guide te prend par la main de zéro jusqu'à un système qui encaisse.
> Toute la logique côté serveur a déjà été déployée. Tu n'as qu'à brancher tes comptes
> Stripe et AdMob et coller quelques clés.

---

## 1. Vue d'ensemble (architecture)

```
Flutter (mobile)
   │
   │  abonnement_page.dart  ──►  StripePaymentService  ──►  Edge Function
   │                                                         "stripe-create-checkout"
   │                                                                │
   │                                                                ▼
   │                                                         Stripe Checkout
   │                                                         (page sécurisée externe)
   │                                                                │
   │                                                       paiement validé
   │                                                                │
   │                                                                ▼
   │                                                         Edge Function
   │                                                         "stripe-webhook"
   │                                                                │
   │  ◄──────  Postgres (Supabase) — subscription_payement, billing_invoices
   │            │
   │  Realtime + RPC is_user_premium() + get_my_entitlement()
   │            │
   ▼            ▼
SubscriptionGate  ←  bloque/débloque l'app sans redémarrage
```

**Source de vérité** : la table `public.subscription_payement` mise à jour
exclusivement par le webhook Stripe. Le client ne peut PAS écrire dedans (RLS bloque).

---

## 2. Comptes à créer

| Service | URL | Pourquoi |
|---|---|---|
| **Stripe** | https://dashboard.stripe.com/register | Encaissement abonnements |
| **AdMob** | https://apps.admob.com | Monétisation utilisateurs gratuits |

---

## 3. ⚙️ Configuration Stripe (10 minutes)

### 3.1. Créer 3 produits dans Stripe Dashboard

Dans `Dashboard → Products → + Add product` :

| Produit | Prix | Récurrence | Devise |
|---|---|---|---|
| COP'IQ Hebdomadaire | **4,99 €** | Weekly | EUR |
| COP'IQ Mensuel | **8,99 €** | Monthly | EUR |
| COP'IQ Annuel | **86,99 €** | Yearly | EUR |

Pour chaque produit, **copie le `price_id`** (commence par `price_…`) — tu en auras besoin.

### 3.2. Récupérer les clés API

`Dashboard → Developers → API keys` :
- **Secret key** : `sk_live_…` (ou `sk_test_…` en mode test) — **NE JAMAIS** la mettre dans le code Flutter.

### 3.3. Configurer le Webhook Stripe

`Dashboard → Developers → Webhooks → + Add endpoint`

- **URL** : `https://nuoonagnkhbeeymtvrcn.supabase.co/functions/v1/stripe-webhook`
- **Events à écouter** (sélectionne ces 6) :
  - `checkout.session.completed`
  - `customer.subscription.created`
  - `customer.subscription.updated`
  - `customer.subscription.deleted`
  - `invoice.paid`
  - `invoice.payment_failed`

Une fois créé, **copie le `Signing secret`** (`whsec_…`).

### 3.4. Activer le Customer Portal

`Dashboard → Settings → Billing → Customer portal` :
- Active "Allow customers to cancel subscriptions"
- Configure les pages d'accueil / footer (logo COP'IQ)
- Sauvegarde

---

## 4. 🔐 Coller les secrets dans Supabase

`Supabase Dashboard → Project Settings → Edge Functions → Manage secrets`
ou via le CLI :

```bash
supabase secrets set STRIPE_SECRET_KEY=sk_live_xxxxx
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_xxxxx
supabase secrets set STRIPE_PRICE_WEEK=price_xxxxx
supabase secrets set STRIPE_PRICE_MONTH=price_xxxxx
supabase secrets set STRIPE_PRICE_YEAR=price_xxxxx

# Optionnel (sinon valeurs par défaut) :
supabase secrets set STRIPE_SUCCESS_URL=https://copiqpolice.app/payment-success
supabase secrets set STRIPE_CANCEL_URL=https://copiqpolice.app/payment-cancel
supabase secrets set STRIPE_PORTAL_RETURN_URL=https://copiqpolice.app/account
```

> Les variables `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`
> sont injectées automatiquement par la plateforme. Tu n'as rien à faire.

---

## 5. 🧪 Tester le paiement (mode test)

1. Mets-toi en **mode test** dans Stripe (toggle en haut à droite).
2. Crée des produits **avec les mêmes prix** côté test.
3. Mets dans Supabase les `price_id` test + `sk_test_…` + un nouveau webhook test.
4. Lance l'app, va sur `/abonnement`, clique sur un plan.
5. Stripe Checkout s'ouvre dans le navigateur → utilise une carte de test :
   - Numéro : `4242 4242 4242 4242`
   - Expire : n'importe quelle date future
   - CVC : `123`
6. Paye → reviens dans l'app → ton accès doit se débloquer
   automatiquement en quelques secondes (realtime).

---

## 6. 👑 Mode Fondateur (owner)

Ton compte (`kaisouartani@gmail.com`) a déjà été promu **owner** en BDD.
Cela signifie :
- ✅ Accès Premium total, **sans payer**, **sans expiration**.
- ✅ Aucune publicité affichée.
- ✅ Bandeau "Mode Fondateur" visible sur la page Facturation.
- ✅ Accès à toutes les pages premium (cas pratiques GPX, langues, etc.).

### Promouvoir un autre compte (test, démo, etc.)

Depuis le **panel admin web** ou via SQL :

```sql
UPDATE public.user_profiles
SET role = 'owner'        -- ou 'admin' / 'moderator' / 'user' / 'active'
WHERE user_id = '<UUID>';
```

Côté admin panel (Next.js / React), expose un bouton qui appelle le RPC :

```ts
await supabase.rpc('set_user_role', {
  p_user_id: userId,
  p_role: 'owner', // 'owner' nécessite que l'appelant soit déjà owner
});
```

### Rôles disponibles

| Rôle | Effet |
|---|---|
| `user` | Plan gratuit standard (10 quiz/semaine + pubs) |
| `active` | (rôle legacy — équivalent user) |
| `moderator` | (futur — modération forum) |
| `admin` | Accès lecture des données admin (pas Premium auto) |
| `owner` | **Bypass total** — Premium permanent + admin |

---

## 7. 📺 Configuration AdMob

### 7.1. Console AdMob

1. https://apps.admob.com → **Apps → Add app**.
2. Crée une app pour Android (`COP'IQ`) et une pour iOS (`COP'IQ`).
3. Pour chaque app, crée 2 unités publicitaires :
   - **Interstitial** (fin de quiz)
   - **Rewarded** (regarder pour récupérer 1 quiz)

### 7.2. Coller les IDs réels

#### Android — `android/app/src/main/AndroidManifest.xml`

Remplace la ligne avec `ca-app-pub-3940256099942544~3347511713` (test) par
ton **App ID Android** réel.

#### iOS — `ios/Runner/Info.plist`

Remplace `ca-app-pub-3940256099942544~1458002511` (test) par ton
**App ID iOS** réel.

#### Code Flutter — `lib/core/services/ad_service.dart`

Remplace les 4 `REPLACE_ME_*` par tes 4 Ad Unit IDs (interstitial × 2 plateformes,
rewarded × 2 plateformes).

> ⚠️ **NE JAMAIS** publier en prod avec les test IDs — Google peut bannir ton compte.

### 7.3. Brancher les pubs

Dans `main.dart`, ajoute après l'init Supabase :

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:copiqpolice/core/services/ad_service.dart';

await MobileAds.instance.initialize();
await AdService.instance.init();
```

À la fin d'un quiz (sur l'écran de résultat) :

```dart
await AdService.instance.maybeShowInterstitial();
```

**Cooldown intégré** : 5 minutes minimum entre 2 interstitials. Premium = pas de pub.

Pour la pub récompensée (depuis le `_QuotaLockDialog` ou la page abonnement) :

```dart
final granted = await AdService.instance.showRewardedAndGrant();
if (granted) {
  AppNotifier.success(context, title: '+1 quiz', message: 'Profite-en !');
}
```

> ℹ️ Le code de `ad_service.dart` contient des blocs commentés montrant
> l'implémentation Google Mobile Ads complète. Décommente-les après avoir
> ajouté `google_mobile_ads` (déjà dans `pubspec.yaml`).

---

## 8. 🔒 Sécurité (déjà en place)

✅ **RLS activé** sur toutes les tables sensibles
✅ **`subscription_payement`** est **read-only** côté client — seul le webhook (RPC `set_user_subscription` SECURITY DEFINER) peut écrire
✅ **Webhook Stripe** vérifie obligatoirement la signature HMAC
✅ **Idempotence** : `subscription_events.stripe_event_id` est UNIQUE — pas de double-traitement
✅ **`is_user_premium()`** est une fonction SQL côté serveur — impossible à bypasser depuis le client
✅ **Rewarded ads** : RPC throttlée (1/30 sec) + nonce unique (anti-replay)
✅ **Owner role** : seul un `owner` peut promouvoir un autre `owner`

---

## 9. 🎯 Logique de quota gratuit

- **10 quiz / semaine** (free)
- Reset automatique 7 jours après la **dernière requête** (et non depuis la 1re)
- À l'épuisement → dialog "Limite atteinte" + CTA Premium ou "Regarder une pub"
- Les Premium (incl. Owner) **ne consomment pas** le quota

Tout passe par la RPC `consume_free_request()` (déjà appelée par le NavigatorObserver
existant `SubscriptionService.onRoutePushed`).

---

## 10. 🧰 Récap des Edge Functions déployées

| Function | Auth | Rôle |
|---|---|---|
| `stripe-create-checkout` | JWT | Crée la session Stripe Checkout pour un plan |
| `stripe-portal` | JWT | URL du Customer Portal Stripe (gérer paiement) |
| `stripe-cancel-subscription` | JWT | Annule à la fin de la période |
| `stripe-webhook` | **Pas de JWT** (signature Stripe) | Sync DB après évènements Stripe |

URL pour les hooks : `https://nuoonagnkhbeeymtvrcn.supabase.co/functions/v1/<name>`

---

## 11. 📋 Checklist finale avant production

- [ ] Stripe Dashboard : passé en mode **Live**
- [ ] Tous les `price_id` re-créés en mode Live et copiés dans Supabase Secrets
- [ ] Webhook Live re-créé (URL identique) + nouveau `whsec_…` dans Supabase Secrets
- [ ] Customer Portal configuré (logo, footer, conditions)
- [ ] AdMob : produit créé, App ID Android & iOS collés, vrais Ad Unit IDs collés
- [ ] **TEST** : achat avec une vraie carte (puis remboursement immédiat) → DB se met à jour ?
- [ ] **TEST** : annulation depuis la page Facturation → `cancel_at_period_end = true` ?
- [ ] **TEST** : compte free → 11e quiz bloque bien ?
- [ ] **TEST** : owner ne consomme pas le quota et ne voit pas de pub ?
- [ ] CGV/CGU mises à jour pour mentionner Stripe + auto-renouvellement
- [ ] App Store Review : décrire que les paiements sont via Stripe (web flow externe)

---

## 12. 🆘 Dépannage

**"Le paiement passe mais l'accès ne se débloque pas"**
1. Vérifie que le webhook Stripe a bien été déclenché : `Stripe Dashboard → Webhooks → ton endpoint → Recent events`.
2. Vérifie que la signature passe : si tu vois `400 bad_signature`, c'est que `STRIPE_WEBHOOK_SECRET` est faux.
3. Regarde les logs Supabase : `Dashboard → Edge Functions → stripe-webhook → Logs`.

**"L'app ne sait pas que je suis premium"**
- Force-refresh : tire vers le bas sur la page Facturation.
- Le service `SubscriptionService` polle toutes les 20s + écoute realtime.

**"Je veux donner accès gratuit à un testeur"**
```sql
UPDATE public.user_profiles SET role = 'owner' WHERE user_id = '<UUID>';
```
Effet immédiat — le testeur n'a pas besoin de redémarrer l'app.

**"Stripe rejette la carte"**
- En mode test, utilise `4242 4242 4242 4242`.
- En mode live, vérifie que ton compte Stripe est bien activé (KYC complet).

---

Bon lancement 🚀
