// lib/core/services/revenuecat_payment_service.dart
//
// COP'IQ — RevenueCat payments orchestration (iOS/Android, client side).
// Remplace Stripe Checkout sur mobile : Apple/Google exigent que le contenu
// numérique débloqué dans l'app passe par In-App Purchase natif (StoreKit /
// Play Billing), pas par un lien de paiement externe (règle Apple 3.1.1).
//
// Le webhook `cas_pratique_revenuecat_webhook` écrit dans la même table que
// le webhook Stripe (`cas_pratique_subscriptions`), donc `SubscriptionService`
// et `EntitlementService` continuent de fonctionner sans modification, sur
// web comme sur mobile.
//
// Convention : les packages de l'offering "current" RevenueCat doivent être
// identifiés `week` / `month` / `year` pour matcher `CopiqPlan.id` sans table
// de correspondance en dur (voir stripe_payment_service.dart).
//
// Setup (dart-define au build) :
//   REVENUECAT_API_KEY_IOS
//   REVENUECAT_API_KEY_ANDROID

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'stripe_payment_service.dart' show CopiqPlan, CopiqPlanX, StripeLaunchResult, CancelResult;
import 'subscription_service.dart';

class RevenueCatPaymentService {
  RevenueCatPaymentService._();
  static final RevenueCatPaymentService instance = RevenueCatPaymentService._();

  bool _configured = false;
  StreamSubscription<AuthState>? _authSub;

  SupabaseClient get _sb => Supabase.instance.client;

  /// À appeler une fois au démarrage (main.dart), uniquement sur mobile.
  Future<void> initialize() async {
    if (_configured) return;

    final apiKey = defaultTargetPlatform == TargetPlatform.iOS
        ? const String.fromEnvironment('REVENUECAT_API_KEY_IOS')
        : const String.fromEnvironment('REVENUECAT_API_KEY_ANDROID');

    if (apiKey.isEmpty) {
      if (kDebugMode) {
        debugPrint(
          '[RevenueCat] no API key for ${defaultTargetPlatform.name} — '
          'IAP paywall will fail until REVENUECAT_API_KEY_IOS/ANDROID is set.',
        );
      }
      return;
    }

    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }
    await Purchases.configure(PurchasesConfiguration(apiKey));
    _configured = true;

    final currentUser = _sb.auth.currentUser;
    if (currentUser != null) {
      await _identify(currentUser.id);
    }

    _authSub = _sb.auth.onAuthStateChange.listen((evt) async {
      switch (evt.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.tokenRefreshed:
          final uid = evt.session?.user.id;
          if (uid != null) await _identify(uid);
          break;
        case AuthChangeEvent.signedOut:
          await _deidentify();
          break;
        default:
          break;
      }
    });
  }

  Future<void> _identify(String supabaseUserId) async {
    if (!_configured) return;
    try {
      await Purchases.logIn(supabaseUserId);
    } catch (e) {
      if (kDebugMode) debugPrint('[RevenueCat] logIn error: $e');
    }
  }

  Future<void> _deidentify() async {
    if (!_configured) return;
    try {
      await Purchases.logOut();
    } catch (e) {
      if (kDebugMode) debugPrint('[RevenueCat] logOut error: $e');
    }
  }

  void dispose() {
    _authSub?.cancel();
    _authSub = null;
  }

  // ── Public API (miroir de StripePaymentService) ──────────────────────────

  Future<StripeLaunchResult> startCheckout(CopiqPlan plan) async {
    if (!_configured) {
      return StripeLaunchResult.failure('revenuecat_not_configured');
    }
    if (_sb.auth.currentUser == null) {
      return StripeLaunchResult.failure('not_authenticated');
    }

    HapticFeedback.lightImpact();

    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;
      if (offering == null) {
        return StripeLaunchResult.failure('no_offering_configured');
      }

      final package = offering.availablePackages.firstWhere(
        (p) => p.identifier == plan.id,
        orElse: () => throw StateError('package_not_found'),
      );

      await Purchases.purchasePackage(package);

      _scheduleRefreshOnResume();
      return StripeLaunchResult.success('revenuecat://purchase-success');
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return StripeLaunchResult.failure('user_cancelled');
      }
      if (kDebugMode) debugPrint('[RevenueCat] purchase error: $e');
      return StripeLaunchResult.failure('purchase_failed');
    } catch (e) {
      if (kDebugMode) debugPrint('[RevenueCat] purchase error: $e');
      return StripeLaunchResult.failure(
        e is StateError ? e.message : 'purchase_failed',
      );
    }
  }

  /// Apple/Google interdisent de gérer/annuler un abonnement par API — on
  /// ouvre la page native de gestion (App Store / Play Store), fournie par
  /// RevenueCat via `CustomerInfo.managementURL`.
  Future<StripeLaunchResult> openPortal() async {
    try {
      final info = await Purchases.getCustomerInfo();
      final url = info.managementURL;
      if (url == null || url.isEmpty) {
        return StripeLaunchResult.failure('no_active_subscription');
      }
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok) return StripeLaunchResult.failure('cannot_open_store_management');
      _scheduleRefreshOnResume();
      return StripeLaunchResult.success(url);
    } catch (e) {
      if (kDebugMode) debugPrint('[RevenueCat] getCustomerInfo error: $e');
      return StripeLaunchResult.failure('cannot_open_store_management');
    }
  }

  /// Même feuille native que [openPortal] : l'utilisateur y annule lui-même,
  /// aucune API programmatique d'annulation n'existe côté Apple/Google.
  Future<CancelResult> cancelAtPeriodEnd() async {
    final result = await openPortal();
    return CancelResult(ok: result.ok, reason: result.reason);
  }

  /// Obligatoire pour la review Apple : permet de récupérer un abonnement
  /// actif après réinstallation / changement d'appareil, sans nouveau paiement.
  Future<StripeLaunchResult> restorePurchases() async {
    if (!_configured) {
      return StripeLaunchResult.failure('revenuecat_not_configured');
    }
    try {
      await Purchases.restorePurchases();
      _scheduleRefreshOnResume();
      return StripeLaunchResult.success('restored');
    } catch (e) {
      if (kDebugMode) debugPrint('[RevenueCat] restore error: $e');
      return StripeLaunchResult.failure('restore_failed');
    }
  }

  // ── Internal ───────────────────────────────────────────────────────────

  Timer? _resumeTimer;
  void _scheduleRefreshOnResume() {
    _resumeTimer?.cancel();
    // Le webhook RevenueCat écrit en base généralement en 1-2s, mais on
    // réutilise le même pattern de retry que StripePaymentService.
    for (final s in const [2, 8, 20]) {
      Future.delayed(Duration(seconds: s), () {
        SubscriptionService.instance.refresh(force: true, withQuota: true);
      });
    }
  }
}
