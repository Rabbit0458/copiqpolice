# COP'IQ — Stripe setup

Réf : `docs/cas_pratique/PROGRESSION_CODE.md` — CODE-085

> **Stripe est le seul moteur de paiement de l'application.**
> Toute référence à RevenueCat / StoreKit / Play Billing a été retirée du repo
> le 2026-08-18. Ne pas réintroduire de second provider sans décision explicite.

---

## 1. Architecture

| Couche | Composant |
|---|---|
| **App Flutter** | `lib/core/services/stripe_payment_service.dart` (checkout / portal / cancel) |
| **App Flutter — Cas Pratique** | `lib/core/payments/payments_service.dart` (`CpPayments`) |
| **Web** | `copiq-web/src/lib/stripe/client.ts` + `copiq-web/src/app/api/stripe/{checkout,portal,webhook}` |
| **Serveur** | Edge functions Supabase : `cas_pratique_create_checkout`, `cas_pratique_customer_portal`, `cas_pratique_stripe_webhook` |
| **Source de vérité** | Table `cas_pratique_subscriptions` + vue `cp_my_subscription` |

Aucun appel à l'API Stripe ne part du client. Le client invoque une edge function,
qui utilise `STRIPE_SECRET_KEY` côté serveur et renvoie une URL à ouvrir.

---

## 2. Setup Stripe

### 2.1. Création du Stripe Account

1. https://dashboard.stripe.com/register → activer Live mode après KYC
2. Settings → Branding → upload logo COP'IQ + couleur primaire `#1147D9`
3. Settings → Tax → activer EU VAT collection
4. Settings → Customer portal → activer (pour `openPortal()` côté app)

### 2.2. Produit + Prices

Dashboard → Products → New :
```
Name        : COP'IQ Premium
Description : Accès illimité aux cas pratiques, concours blancs, export PDF.
Pricing     :
  -  4,99 € EUR / week   (recurring)
  -  8,99 € EUR / month  (recurring)
  - 86,99 € EUR / year   (recurring)
Metadata    :
  entitlements: "unlimited_cases,concours_blanc,pdf_export,leaderboard,annales_full,edge_correction,support_priority"
  source: "copiq_web"
```

> Les montants ci-dessus doivent rester synchronisés avec `CopiqPlanX.priceEur`
> dans `lib/core/services/stripe_payment_service.dart` — c'est la source de
> vérité des prix affichés en UI.

Récupère les `price_id` (commencent par `price_`).

### 2.3. Webhook

Dashboard → Developers → Webhooks → Add endpoint :

- URL : `https://<project>.supabase.co/functions/v1/cas_pratique_stripe_webhook`
- Events à écouter :
  - `checkout.session.completed`
  - `customer.subscription.created`
  - `customer.subscription.updated`
  - `customer.subscription.deleted`
  - `invoice.payment_failed`
  - `invoice.payment_succeeded`
- Récupère `whsec_...` et stocke-le

### 2.4. Variables d'environnement Supabase

```bash
supabase secrets set STRIPE_SECRET_KEY=sk_live_xxx
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_xxx
supabase secrets set STRIPE_PRICE_WEEK=price_xxx
supabase secrets set STRIPE_PRICE_MONTH=price_xxx
supabase secrets set STRIPE_PRICE_YEAR=price_xxx
```

Optionnel : `STRIPE_SUCCESS_URL`, `STRIPE_CANCEL_URL`, `STRIPE_PORTAL_RETURN_URL`.

### 2.5. Déploiement des edge functions

```bash
supabase functions deploy cas_pratique_stripe_webhook --no-verify-jwt
supabase functions deploy cas_pratique_create_checkout
supabase functions deploy cas_pratique_customer_portal
```

> `--no-verify-jwt` pour le webhook car Stripe ne sait pas envoyer le JWT
> Supabase. La signature `stripe-signature` valide l'authenticité.

---

## 3. Test local

### 3.1. Webhook Stripe CLI

```bash
# Installer le CLI : https://stripe.com/docs/stripe-cli
stripe listen --forward-to localhost:54321/functions/v1/cas_pratique_stripe_webhook

# Le CLI affiche un webhook secret de test → utiliser dans supabase secrets
```

### 3.2. Trigger un event

```bash
stripe trigger checkout.session.completed
stripe trigger customer.subscription.updated
stripe trigger invoice.payment_failed
```

Vérifier dans Supabase → SQL Editor :
```sql
select user_id, tier, status, current_period_end
from cas_pratique_subscriptions
order by updated_at desc
limit 10;
```

---

## 4. Intégration Flutter

### 4.1. Dépendances

Aucun SDK de paiement n'est nécessaire. Le flux repose sur :

```yaml
dependencies:
  url_launcher: ^6.3.2          # ✅ déjà présent — ouvre l'URL Checkout
  supabase_flutter: ^2.12.4     # ✅ déjà présent — invoke des edge functions
```

### 4.2. Côté code — module Cas Pratique

```dart
// Au login / au démarrage :
await CpPayments.I.refreshTier();

// Avant d'accéder à une feature premium :
if (CpPayments.I.current.hasEntitlement(CpEntitlements.unlimitedCases)) {
  // OK, on continue
} else {
  Navigator.pushNamed(context, CpPaywallPage.routeName);
}

// Bouton "Passer Premium" :
final url = await CpPayments.I.startCheckout(
  priceId: const String.fromEnvironment('STRIPE_PRICE_MONTH'),
);
```

### 4.3. Côté code — page abonnement principale

```dart
// Souscription
await StripePaymentService.instance.startCheckout(CopiqPlan.month);

// Gestion / facturation
await StripePaymentService.instance.openPortal();

// Résiliation en fin de période
await StripePaymentService.instance.cancelAtPeriodEnd();
```

---

## 5. Conformité Apple / Google

⚠️ **Point de vigilance connu et assumé.**

Apple (App Store Review Guidelines 3.1.1) et Google (Play Payments Policy)
exigent leur propre système de facturation pour le contenu numérique consommé
dans l'application. Le flux actuel ouvre Stripe Checkout dans le navigateur
externe, ce qui peut motiver un rejet lors de la soumission.

Options si un rejet survient :

1. **Reader app / lien externe** — depuis 2024 Apple autorise, dans certaines
   juridictions et sous entitlement `StoreKit External Purchase Link`, un lien
   de paiement externe. Nécessite une demande auprès d'Apple et une commission
   réduite. À instruire avant soumission.
2. **Restreindre l'achat au web** — ne pas exposer de CTA d'achat dans les
   builds iOS/Android, et laisser l'utilisateur souscrire depuis `copiqpolice.app`.
   L'app se contente de lire l'entitlement via `cp_my_subscription`.

> Décision projet : Stripe uniquement. Ne pas réintroduire de couche
> d'achat intégré sans arbitrage explicite de Kaïs.

---

## 6. Variables d'environnement à mettre dans dart-define

```
--dart-define=STRIPE_PRICE_WEEK=price_xxx
--dart-define=STRIPE_PRICE_MONTH=price_xxx
--dart-define=STRIPE_PRICE_YEAR=price_xxx
```

---

## 7. Checklist de mise en prod

- [ ] Stripe Live mode activé
- [ ] Webhook configuré + secret stocké
- [ ] Edge functions déployées (`create_checkout`, `customer_portal`, `stripe_webhook`)
- [ ] Test bout-en-bout : checkout → webhook → DB → UI rafraîchie
- [ ] Customer portal Stripe activé et testé
- [ ] Politique de remboursement publiée
- [ ] CGV publiées
- [ ] Test de `cancel_at_period_end` → tier reste premium jusqu'à la fin
- [ ] Test de `past_due` → notification utilisateur
- [ ] Stratégie de conformité store arbitrée (cf. section 5)
- [ ] Monitoring webhook activé

---

## 8. Métriques à suivre

| Métrique | Cible mois 6 |
|---|---|
| Taux conversion paywall → checkout | 5% |
| Taux conversion checkout → paid | 70% |
| MRR (Monthly Recurring Revenue) | 2 000 € |
| Churn mensuel | < 8% |
| Trial → Paid conversion | 35% |
| LTV (lifetime value) | 95 € |
