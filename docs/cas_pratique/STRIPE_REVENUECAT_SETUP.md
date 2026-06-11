# COP'IQ — Stripe + RevenueCat setup

Réf : `docs/cas_pratique/PROGRESSION_CODE.md` — CODE-085

---

## 1. Stratégie hybride

| Plateforme | Solution recommandée | Pourquoi |
|---|---|---|
| **Web** | Stripe Checkout direct | Pas de commission Apple/Google, contrôle complet |
| **Android** | RevenueCat (vers Stripe ou Google Play Billing) | Apple/Google exigent leur billing pour le contenu numérique |
| **iOS** | RevenueCat → Apple StoreKit | Idem, requis par Apple Review Guidelines |

**Pourquoi RevenueCat ?**
- Unifie les receipts Apple + Google + Stripe sur une seule API
- Gère le restore purchases, les subscriptions, les family sharing
- Webhooks vers Supabase pour sync `cas_pratique_subscriptions`
- Free tier généreux : 10k MTR gratuits

---

## 2. Setup Stripe (web + admin)

### 2.1. Création du Stripe Account

1. https://dashboard.stripe.com/register → activer Live mode après KYC
2. Settings → Branding → upload logo COP'IQ + couleur primaire `#1147D9`
3. Settings → Tax → activer EU VAT collection
4. Settings → Customer portal → activer (pour `openCustomerPortal()` côté app)

### 2.2. Produit + Prices

Dashboard → Products → New :
```
Name        : COP'IQ Premium
Description : Accès illimité aux cas pratiques, concours blancs, export PDF.
Pricing     :
  - 9,99 € EUR / month (recurring)
  - 89,99 € EUR / year (recurring) -- 25% de réduction
Metadata    :
  entitlements: "unlimited_cases,concours_blanc,pdf_export,leaderboard,annales_full,edge_correction,support_priority"
  source: "copiq_web"
```

Récupère les `price_id` (commencent par `price_`). Tu les passeras au front.

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
```

### 2.5. Déploiement des edge functions

```bash
supabase functions deploy cas_pratique_stripe_webhook --no-verify-jwt
supabase functions deploy cas_pratique_create_checkout
```

> `--no-verify-jwt` pour le webhook car Stripe ne sait pas envoyer le JWT Supabase. La signature `stripe-signature` valide l'authenticité.

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

## 4. Setup RevenueCat (mobile)

### 4.1. Création du projet

1. https://app.revenuecat.com → New project "COP'IQ"
2. Apps :
   - iOS app `com.copiq.copiqpolice`
   - Android app `com.copiq.copiqpolice`
3. Lier au compte Stripe : Project → Integrations → Stripe → connect avec `sk_live_...` (read-only key suffit)

### 4.2. Products & Entitlements

```
Entitlement : "premium"
  Description : COP'IQ Premium
  Products attached :
    - copiq_premium_monthly (iOS App Store + Google Play)
    - copiq_premium_yearly  (idem)
    - price_xxx_monthly     (Stripe)
    - price_xxx_yearly      (Stripe)
```

### 4.3. App Store Connect

1. Apps → COP'IQ → In-App Purchases → Subscriptions
2. Group : `copiq_premium`
3. Subscription : `copiq_premium_monthly`
   - Price : 9,99 €
   - Localization FR + EN
4. Idem pour `copiq_premium_yearly` (89,99 €)
5. Soumettre pour review (~24h)

### 4.4. Google Play Console

1. Apps → COP'IQ → Monetize → Subscriptions
2. Base plan : `monthly` à 9,99 €
3. Auto-renewing
4. Idem yearly

### 4.5. RevenueCat webhook → Supabase

RevenueCat → Project → Integrations → Webhooks → Add webhook :
- URL : `https://<project>.supabase.co/functions/v1/cas_pratique_revenuecat_webhook` *(à créer si besoin — pour l'instant Stripe webhook suffit côté web ; le mobile peut écrire directement via le SDK)*

---

## 5. Intégration Flutter (mobile)

### 5.1. Ajouter au pubspec

```yaml
dependencies:
  url_launcher: ^6.3.2          # ✅ déjà présent
  # Pour RevenueCat (à ajouter quand on intègre iOS/Android billing) :
  # purchases_flutter: ^8.0.0
```

### 5.2. Côté code

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
  priceId: const String.fromEnvironment('STRIPE_PRICE_MONTHLY'),
);
```

### 5.3. Quand RevenueCat est intégré (iOS/Android)

Créer `lib/core/payments/cp_payments_revenuecat.dart` qui implémente
`CpPaymentsInterface` en utilisant `purchases_flutter` :
- `Purchases.configure(...)` au démarrage
- `Purchases.getOfferings()` pour récupérer les products
- `Purchases.purchasePackage(...)` pour acheter
- `Purchases.restorePurchases()` pour restaurer

Puis brancher :
```dart
CpPayments.I.bindImpl(CpPaymentsRevenueCat());
```

---

## 6. Conformité Apple / Google

⚠️ **CRITIQUE** : sur iOS/Android, **NE PAS** ouvrir Stripe Checkout pour acheter un abonnement à du contenu numérique → rejet à la review.

→ Sur mobile : utiliser **uniquement** RevenueCat → StoreKit/Play Billing.
→ Stripe Checkout est OK uniquement :
  - Sur le **web**
  - Pour des **services hors-app** (consulting, contenu physique)
  - Pour des **abonnements à des services externes** (rare)

Solution actuelle : `CpPayments.startCheckout` ouvre une URL externe. Sur web ça marche, sur mobile ça redirige vers le navigateur. Pour Apple Review, il faut désactiver `startCheckout` sur iOS et utiliser RevenueCat.

---

## 7. Variables d'environnement à mettre dans dart-define

```
--dart-define=STRIPE_PRICE_MONTHLY=price_xxx
--dart-define=STRIPE_PRICE_YEARLY=price_xxx
--dart-define=REVENUECAT_API_KEY_IOS=appl_xxx
--dart-define=REVENUECAT_API_KEY_ANDROID=goog_xxx
--dart-define=REVENUECAT_ENTITLEMENT=premium
```

---

## 8. Checklist de mise en prod

- [ ] Stripe Live mode activé
- [ ] Webhook configuré + secret stocké
- [ ] Edge functions déployées
- [ ] Test bout-en-bout : checkout → webhook → DB → UI rafraîchie
- [ ] RevenueCat configuré pour iOS + Android
- [ ] App Store Connect : subscriptions approuvées
- [ ] Google Play : subscriptions actives
- [ ] Politique de remboursement publiée
- [ ] CGV publiées
- [ ] Test de `restore_purchases` fonctionnel
- [ ] Test de `cancel_at_period_end` → tier reste premium jusqu'à la fin
- [ ] Test de `past_due` → notification utilisateur
- [ ] Monitoring webhook activé dans Sentry

---

## 9. Métriques à suivre

| Métrique | Cible mois 6 |
|---|---|
| Taux conversion paywall → checkout | 5% |
| Taux conversion checkout → paid | 70% |
| MRR (Monthly Recurring Revenue) | 2 000 € |
| Churn mensuel | < 8% |
| Trial → Paid conversion | 35% |
| LTV (lifetime value) | 95 € |
