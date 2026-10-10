# 04 — Contrôle d'accès, choix de parcours et abonnements

Périmètre : app Flutter `/home/claude/app/lib` (lecture seule), docs `progression/`, site Next.js `/home/claude/work/copiq-web/src`.
Aucune définition SQL des RPC n'est présente dans ce dépôt (pas de dossier `supabase/`) : les contrats ci-dessous sont déduits des appels clients et des docs.

---

## 1. Choix du parcours dans l'app

### 1.1 Stockage
- Table `public.user_profiles`, colonnes `user_track` et `user_mode` (clé `user_id`), + cache SharedPreferences `selected_track` / `user_mode`.
- Source de vérité runtime : `lib/core/services/user_context_service.dart`
  ```dart
  //   track : 'gpx' | 'pa' | 'reserve'
  //   mode  : 'school' | 'exam' | 'active'
  static const String fallback = gpx;   // UserTracks
  static const String fallback = exam;  // UserModes
  ```
  Lecture : `.from('user_profiles').select('user_track, user_mode').eq('user_id', user.id)`.
- Le programme de scolarité (sous-choix « art »/programme) est stocké localement via `SchoolProgramPreferences.readGpx()/readPa()` (pas en base).

### 1.2 Flux
1. `lib/features/onboarding/mode_picker.dart` — choix École / Concours / (Actif si activé).
   ```dart
   final userModeString = mode == UserMode.school ? 'school' : 'exam';
   await _upsertProfile(userMode: userModeString);   // user_profiles.upsert(onConflict: 'user_id')
   ... pushReplacement(GradePickerScreen())
   ```
   Option « Je suis actif » visible uniquement si `_activeModeEnabled` (RPC `active_mode_public_config`, re-poll toutes les 12 s). Sélection → force `user_mode='active'`, `user_track='gpx'`, puis route `/active-home` si `ownerPreviewActive || status.granted`, sinon `/active-verification`.
2. `lib/features/onboarding/grade_picker.dart` — choix PA / GPX / Réserviste.
   ```dart
   'user_track': userTrack, // 'pa' | 'gpx' | 'reserve'
   // 🔒 RÉSERVISTE — fonctionnalité verrouillée (bientôt disponible)
   if (g == GradeChoice.reserve) { AppNotifier.info(... 'Bientôt disponible' ...); return; }
   ```
   La carte Réserviste n'est affichée que si `grade_picker_public_config().reserve_enabled` ; même affichée, le tap est bloqué.
3. `lib/features/home/home_bootstrap.dart` — routage :
   - mode invalide → `/mode_picker` ; track invalide → `/grade_picker`
   - `mode=='active'` → `ActiveAccessService().status()` → `/active-home` ou `/active-verification`
   - `track=='reserve'` → renvoyé vers `/grade_picker` (garde-fou legacy, contenu Réserve inachevé)
   - gpx+exam → `HomePageGpxExam` ; gpx+school → programme (restauré ou `GpxSchoolArt`) → `HomePageGpxSchool`
   - pa+exam → `HomePagePaExam` ; pa+school → programme (restauré ou `PaSchoolArt`) → `HomePagePaSchool`
4. Changement de parcours : `lib/features/home/user_page.dart:311` → `pushNamed('/mode_picker')` (bouton « Changer de parcours ») ; `home_page_policier_actif.dart:_leave()` efface `user_mode`/`selected_track` locaux puis `/mode_picker`. **Aucune vérification d'abonnement au moment du choix/changement** : n'importe quel compte peut choisir n'importe lequel des 4 parcours.

### 1.3 Réserve
`home_page_reserve_exam.dart`, `home_page_reserve_school.dart`, `features/reserve/accueil_reserve.dart`, `onboarding/reserve_school.dart` existent mais ne sont **pas routés** (bootstrap redirige `reserve` vers grade_picker, grade_picker bloque le tap). Considérer Réserve comme hors périmètre / désactivé.

---

## 2. Qui exige quoi — matrice d'accès

| Parcours | Accès au parcours | Gating du contenu |
|---|---|---|
| PA Concours (`pa`/`exam`) | libre | quota gratuit hebdo (10) + verrou global, pas de PremiumRequiredPage |
| GPX Concours (`gpx`/`exam`) | libre | quota gratuit hebdo (10) consommé sur les feuilles quiz + verrou global |
| PA Scolarité (`pa`/`school`) | libre | **tout contenu direct (cours, quiz, module) = Premium obligatoire** ; listes de catégories libres |
| GPX Scolarité (`gpx`/`school`) | libre | **idem PA Scolarité** (+ garde au niveau de chaque cours individuel) |
| Policier actif (`active`) | **vérification serveur** (4 questions, 4/4 requis) ou `owner_preview_active` ; **pas d'abonnement** | aucun check premium |
| Réserve | désactivé | — |

### 2.1 Scolarité : réservé aux abonnés (pas aux « vérifiés »)
`lib/features/home/home_page_pa_school.dart:420-430` (même logique `home_page_gpx_school.dart:375-390`, `1355-1366`, `2029-2036`) :
```dart
if (subs != null && subs.isNotEmpty) {
  // ✅ Liste de cours → accès libre
  ... push(_CategoryDetailPage(...))
} else {
  // ✅ Contenu direct → guard premium
  final subState = SubscriptionService.instance.state.value;
  if (!canAccessPremiumContent(subState)) {
    await Navigator.of(context).pushNamed(PremiumRequiredPage.routeName);
    return;
  }
```
`lib/core/services/premium_guard.dart` :
```dart
bool canAccessPremiumContent(SubscriptionState state) => state.isPremium;
```
→ un utilisateur gratuit en Scolarité voit le home, les hubs/catégories, mais aucun cours/quiz/fiche. `PremiumRequiredPage` (`/premium-required`, `features/home/premium_required_page.dart`) : « Ce contenu est réservé aux abonnés COP'IQ Premium. Passe à l'abonnement pour accéder aux cours, fiches de révision, quiz et modules complets. » → bouton `/abonnement`.
NB : le garde est **client uniquement** (navigation) ; les pages de contenu scolarité sont compilées dans l'app, aucune vérification serveur.

### 2.2 Concours : quota freemium
- `home_page_gpx_exam.dart:171-200` `_openRouteWithQuota` : `guardAppAccess` puis, pour les routes feuilles quiz (`/gpx_exam/concours/culture_generale_`, `tests_psychotechniques/`, `langue_etrangere/exemples_`, `cas_pratique/`) → `consumeFreeRequest()` (RPC `consume_free_request`) ; si `!allowed` → dialogue « Limite atteinte ».
- `home_page_pa_exam.dart:1306`, `journal_pa_exam_page.dart:52` : `guardAppAccess` uniquement (verrou si quota épuisé).
- Consommation automatique globale : `main.dart:1581` NavigatorObserver → `SubscriptionService.onRoutePushed(name)` consomme pour toute route contenant `/quiz`, `/gpx_exam`, `/pa_exam` ou `quiz_` (sauf premium / déjà verrouillé, anti-doublon 3 s même route).
  ⚠️ Plausible double décompte GPX exam : `_openRouteWithQuota` consomme explicitement puis l'observer consomme à nouveau au push (l'anti-doublon ne connaît que `_lastConsumedRoute` posé par l'observer). À vérifier côté RPC.
- `guardAppAccess` (`subscription_service.dart:~478`) : si non premium et `quota.remaining <= 0` → dialogue de verrou avec CTA abonnement et **déblocage par pub récompensée** (`_rewardedUnlockHandler`, enregistré par le module AdMob).
- `SubscriptionGate` (`core/services/subscription_gate.dart`) : voile plein écran si `isLocked` (référencé seulement en commentaire dans `version_check.dart`).

### 2.3 Policier actif
- `lib/features/active/active_access_service.dart` : RPC `active_mode_public_config` (`available`, `revision`, `owner_preview_active`), `active_access_status` (`status`, `granted`, `verification_version`, `granted_at`, `revoked_at`, `cooldown_until`), `active_verification_get_questions`, `active_verification_submit(p_answers)`, `active_content_tree`, `active_learning_record`, table `active_learning_events`.
- `home_page_policier_actif.dart:75-90` re-vérifie au chargement : `if (!config.available) _showDisabled` ; `if (!access.granted) → /active-verification`.
- `progression/MODE_ACTIF_SECURISE.md` : 4 questions libres, réponses jamais envoyées au client, 4/4 ouvre durablement l'accès, 2 échecs → 10 min de cooldown serveur, audit complet ; admin `/admin/actif/` (owner + MFA) peut attribuer/restaurer/révoquer.
- Indépendant de l'abonnement : un actif vérifié non abonné y accède ; un abonné non vérifié n'y accède pas.

---

## 3. Modèle d'entitlement

### 3.1 Sources (fusionnées côté client)
| Source | Lecture app | Contenu |
|---|---|---|
| RPC `is_user_premium(p_user_id uuid) -> bool` | `SubscriptionService._fetchIsPremium()` | vérité DB (Stripe + droits stores isolés) |
| RevenueCat SDK, entitlement `premium` | `RevenueCatService.isPremium` (`kRevenueCatEntitlementId = 'premium'`) | achats natifs iOS/Android |
| RPC `get_my_entitlement() -> json` | `EntitlementService` | payload riche (rôle, plan, statut, quota, badge) |
| Vue `cp_my_subscription` | `CpPayments.refreshTier()` (`core/payments/payments_service.dart`) | `tier`, `status`, `trial_ends_at`, `entitlements[]`… (facture_page) |
| Table `cas_pratique_subscriptions` | realtime dans `SubscriptionService` (`kPremiumTable`) | ligne Stripe ; déclenche refresh |
| Table `free_weekly_usage` (`user_id, window_start, used, updated_at`) | `fetchFreeQuota()` + realtime | quota gratuit |

`subscription_service.dart` :
```dart
final premium = databasePremium || storePremium;   // RPC is_user_premium OR RevenueCat
static const int freeLimit = 10;
bool get isLocked => !isPremium && (quota?.remaining ?? 999) <= 0;
```
`entitlement_service.dart` : si `RevenueCatService.isPremium`, écrase le JSON RPC par `premium:true, plan: year|month, status:'active'`.

### 3.2 Valeurs
- `get_my_entitlement` : `role` `'owner'|'admin'|'moderator'|'active'|'user'` ; `is_owner`, `is_admin` ; `premium` (« any source: owner bypass, paid sub, trial ») ; `plan` `'free'|'week'|'month'|'year'` ; `status` `'active'|'trial'|'cancelled'|'expired'|'past_due'` ; `valid_until`, `cancel_at_period_end`, `free_used`, `free_limit` (10), `free_remaining`, `free_resets_at`, `quiz_attempts_count`, `badge_type`.
- `cp_my_subscription.tier` : `'free'|'premium_trial'|'premium'` (`CpTier`) ; `isPaid = premium || premium_trial`. Clés `entitlements[]` (`CpEntitlements`) : `unlimited_cases`, `concours_blanc`, `pdf_export`, `leaderboard`, `annales_full`, `edge_correction`, `support_priority` — **définies mais `hasEntitlement()` n'est utilisé nulle part** : tout est binaire premium/non premium.
- Owner : bypass premium via `get_my_entitlement.premium` (utilisé par `PaywallGate`) — mais `canAccessPremiumContent` lit `SubscriptionService` (`is_user_premium`), donc le bypass owner dépend de l'implémentation SQL de `is_user_premium` (non visible ici).

### 3.3 Plans / prix / essai
- Mobile (vendu) : `core/services/subscription_plan.dart` — `month` 8,99 €/mois (`fr.copiq.premium.monthly`, `copiq_premium_monthly`, `$rc_monthly`), `year` 79,99 €/an (`fr.copiq.premium.yearly`, `copiq_premium_yearly`, `$rc_annual`). Achat via RevenueCat uniquement (`abonnement_page.dart` → `RevenueCatService.purchase/restorePurchases`). Pas d'offre d'essai côté Apple (« Mensuel France 8,99 €, sans offre introductive » — SUIVI_PAIEMENTS_STORES).
- Stripe (web/historique) : checkout via edge fn `cas_pratique_create_checkout` (plan contrôlé `week|month|year`, price résolu serveur), portail `cas_pratique_customer_portal`, webhook `cas_pratique_stripe_webhook` → `cas_pratique_subscriptions`. Bloqué sur mobile : `usesNativeStoreBilling` (`core/payments/store_billing_policy.dart`) → `startCheckout` retourne `null` sur iOS/Android.
- Webhook stores : `cas_pratique_revenuecat_webhook` (v21 ACTIVE) ; migration `20260925095908_store_entitlements_isolated.sql` (droits natifs séparés de Stripe, sandbox/prod séparés).
- Essai : `trial` / `premium_trial` / `trial_ends_at` existent dans le modèle ; décision « quels abonnements bénéficient d'un essai de 7 jours » encore ouverte (STRIPE_PAIEMENTS_A_CONFIGURER §1). `content/paywall/cp_pricing_plans.dart` (ancien paywall `/cas-pratique/paywall`) affiche encore 9,99 €/mois + 7 j gratuits, 79 €/an, 149 € à vie avec `price_*_placeholder` → **incohérent et obsolète**.
- Codes promo : `content/paywall/cp_promo_redeem_sheet.dart` (edge fn `cas_pratique_redeem_promo`, erreurs : inexistant / pas activé / expiré / limite atteinte / déjà utilisé) — **widget orphelin, jamais instancié**. Checkout Stripe passe `allow_promotion_codes: true`. Parrainage : `referral_service.dart` (`fn_cp_get_or_create_my_referral_code`, `redeem_referral_code`).
- `core/cas_pratique/subscription/subscription_service.dart` : stub legacy (`user_metadata.cas_pratique_premium`), `canAccessCase` non utilisé.

---

## 4. Gratuit vs Premium par parcours (app)

| Parcours | Gratuit | Premium |
|---|---|---|
| PA Concours | home, navigation, quiz/psychotechniques dans la limite de 10 lancements quiz / 7 jours glissants (puis verrou, déblocable par pub récompensée), publicités | quiz illimités, sans pub |
| GPX Concours | idem ; consommation explicite sur feuilles CG / psycho / langue / cas pratiques | illimité, sans pub |
| PA Scolarité | home, hubs, listes de catégories, outils perso (notes/mémos selon écrans) | **cours, quiz, fiches, modules** |
| GPX Scolarité | idem | **idem** |
| Actif | n/a — accès par vérification, pas par abonnement | n/a |
| Transverse | pubs (`ad_service.dart`: `_hasPremium` → pas de pub) | pas de pub ; items `is_premium` (mémos `cp_memos_page.dart`, photolangage PA) affichent un badge |

---

## 5. Web actuel vs app — écarts

Web (`src/config/pathways.ts`) :
```ts
export type UserTrack = "pa" | "gpx"
export type UserMode = "exam" | "school"
export type PathwayEntitlement = "free" | "premium" | "premium_trial"
export function getPathwayNavigation(id, entitlement) { void entitlement; return PATHWAYS[id].navigation }
```
- Choix : `choisir-parcours/page.tsx` → `changePathway()` (`pathway-provider.tsx`) upsert `user_profiles {user_track,user_mode}` et relit pour vérifier. `layout.tsx` redirige vers `/choisir-parcours` si profil sans parcours valide. Les 4 cartes sont librement sélectionnables (aligné app).
- Tier : `layout.tsx` et chaque page lisent **directement** `cas_pratique_subscriptions.tier` (`use-subscription.ts`, `gpx-cours-client.tsx`, `pa-quiz-client.tsx`, `psycho-client.tsx`, `cas-pratiques/page.tsx`, `concours-blanc/page.tsx`). Seul `profil/page.tsx` appelle `get_my_entitlement`.

Écarts :
1. **Source premium divergente** : web = `cas_pratique_subscriptions.tier` uniquement → un abonné App Store/Google Play (droits stores isolés) ou l'owner apparaît **gratuit sur le web**. App = `is_user_premium` ∪ RevenueCat. → Centraliser via `get_my_entitlement()` (ou `is_user_premium`) côté web.
2. **Scolarité non verrouillée sur le web** : app bloque tout contenu direct scolarité aux non-abonnés ; web ne gate que par `module.isPremium` (`data/modules.ts`, `cours-reader.tsx`) + flags `premium: true` sur Cas pratiques / Concours blanc dans la nav. `QuizEngine` reçoit `tier` sans l'utiliser.
3. **Quota freemium absent** : pas d'appel `consume_free_request` ni lecture `free_weekly_usage` côté quiz web (seul `cas-pratiques-interface.tsx` a un quota propre `freeTotal - freeUsed`). App : 10 quiz / 7 j.
4. **Mode actif absent** du parcours utilisateur web : types limités à `pa|gpx` × `exam|school` ; un profil `user_mode='active'` → `getPathwayFromProfile` = null → renvoyé vers `/choisir-parcours`, et le choix écrase `user_mode` (perte silencieuse du mode actif). Pas de `/active-verification` web (seul l'admin `app/admin/actif/` existe).
5. **Réserve** : absente du web (cohérent avec l'app où elle est désactivée), mais un profil legacy `reserve` tombera aussi sur `/choisir-parcours`.
6. **Programme de scolarité** (sous-choix GPX/PA school, stocké localement dans l'app via `SchoolProgramPreferences`) : non persisté en base → pas partageable app↔web.
7. **Rôles/owner** : web n'exploite pas `role`/`is_owner`/`badge_type` pour le gating (seulement badge profil).
8. **Prix/essai** : web Stripe (`/api/stripe/checkout`) vs app 8,99 €/79,99 € sans essai ; ancien paywall Flutter 9,99 €/79 €/149 € + 7 j. À unifier ; décision essai et codes promo encore ouverte.
9. `getPathwayNavigation` ignore l'entitlement (`void entitlement`) : rien n'est masqué/annoté selon le tier hormis la couronne sidebar.

## 6. Recommandation de centralisation (pour le web)
- Un seul hook `useEntitlement()` sur `rpc('get_my_entitlement')` (+ realtime sur `cas_pratique_subscriptions`) exposant `premium`, `role`, `plan`, `status`, `free_remaining`.
- `PathwayDefinition` : ajouter `access: { content: 'free_quota' | 'premium' }` → exam = quota, school = premium (contenu direct), et exposer `active` comme parcours spécial conditionné à `active_access_status().granted`.
- Ne pas écrire `user_mode` sur un profil `active` sans confirmation explicite.
- Garde serveur (RLS/RPC) souhaitable pour le contenu scolarité : aujourd'hui l'app ne protège qu'en navigation.
