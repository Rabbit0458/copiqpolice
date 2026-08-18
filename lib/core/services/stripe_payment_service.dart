// lib/core/services/stripe_payment_service.dart
//
// COP'IQ — Stripe payments orchestration (client side).
// All Stripe API calls happen server-side in Supabase Edge Functions.
// This service:
//   - launches Stripe Checkout (subscription) in the system browser
//   - opens the Stripe Customer Portal
//   - cancels the active subscription at period end
//   - on app resume, asks SubscriptionService to refresh so realtime + RPC
//     reconcile the entitlement immediately after Stripe webhook fires.
//
// Plans: 'week' | 'month' | 'year' — must match enum subscription_plan in DB.
//
// Setup (env vars in Supabase project → Edge Functions → Secrets):
//   STRIPE_SECRET_KEY
//   STRIPE_WEBHOOK_SECRET
//   STRIPE_PRICE_WEEK   (Stripe price ID, recurring weekly,  €4.99)
//   STRIPE_PRICE_MONTH  (Stripe price ID, recurring monthly, €8.99)
//   STRIPE_PRICE_YEAR   (Stripe price ID, recurring yearly,  €86.99)
//   STRIPE_SUCCESS_URL  (optional — defaults to https://copiqpolice.app/payment-success)
//   STRIPE_CANCEL_URL   (optional)
//   STRIPE_PORTAL_RETURN_URL (optional)

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'revenuecat_payment_service.dart';
import 'subscription_service.dart';

enum CopiqPlan { week, month, year }

/// Source de vérité unique des prix affichés en UI. Doit rester synchronisé
/// avec les montants des price ID Stripe (STRIPE_PRICE_WEEK/MONTH/YEAR,
/// voir en-tête de fichier) — un seul endroit à modifier si le prix change.
extension CopiqPlanX on CopiqPlan {
  String get id => switch (this) {
    CopiqPlan.week => 'week',
    CopiqPlan.month => 'month',
    CopiqPlan.year => 'year',
  };

  String get label => switch (this) {
    CopiqPlan.week => 'Hebdomadaire',
    CopiqPlan.month => 'Mensuel',
    CopiqPlan.year => 'Annuel',
  };

  String get title => switch (this) {
    CopiqPlan.week => 'Semaine',
    CopiqPlan.month => 'Mensuel',
    CopiqPlan.year => 'Annuel',
  };

  double get priceEur => switch (this) {
    CopiqPlan.week => 4.99,
    CopiqPlan.month => 8.99,
    CopiqPlan.year => 86.99,
  };

  String get priceLabel => switch (this) {
    CopiqPlan.week => '4,99 € / semaine',
    CopiqPlan.month => '8,99 € / mois',
    CopiqPlan.year => '86,99 € / an',
  };

  String get subtitle => switch (this) {
    CopiqPlan.week => 'Renouvellement automatique • Accès intégral 7 jours',
    CopiqPlan.month => 'Renouvellement automatique',
    CopiqPlan.year => '20 % d’économie • Renouvellement automatique',
  };

  String get badge => switch (this) {
    CopiqPlan.week => 'Découverte',
    CopiqPlan.month => 'Recommandé',
    CopiqPlan.year => '-20 %',
  };

  String get valueLine => switch (this) {
    CopiqPlan.week => 'Idéal pour tester COP’IQ à fond',
    CopiqPlan.month => 'Le plus flexible • Résiliation en 30 secondes',
    CopiqPlan.year => 'Meilleur prix sur l’année',
  };

  List<String> get details => switch (this) {
    CopiqPlan.week => const [
      'Accès complet concours + scolarité + quiz',
      'Entraînements illimités (culture G + psycho + langues)',
      'Annulable à tout moment (effet fin de période)',
    ],
    CopiqPlan.month => const [
      'Tout débloqué + entraînements illimités',
      'Mises à jour incluses — chaque semaine',
      'Annulable à tout moment (effet fin de période)',
    ],
    CopiqPlan.year => const [
      'Accès complet 12 mois + mises à jour incluses',
      'Le meilleur rapport valeur / prix',
      'Annulable à tout moment (effet fin de période)',
    ],
  };

  bool get highlighted => this == CopiqPlan.month;
}

/// Web : payé par Stripe Checkout (navigateur externe).
/// Mobile (iOS/Android) : payé par In-App Purchase (App Store / Google Play),
/// obligatoire pour le contenu numérique débloqué dans l'app (règle Apple
/// 3.1.1) — ne jamais afficher une mention Stripe sur mobile, ce serait faux.
String get kCopiqBillingLine => kIsWeb
    ? 'Facturé par carte bancaire via Stripe (paiement sécurisé, navigateur externe)'
    : 'Facturé via App Store / Google Play (renouvellement automatique)';

class StripePaymentService {
  StripePaymentService._();
  static final StripePaymentService instance = StripePaymentService._();

  SupabaseClient get _sb => Supabase.instance.client;

  // ── Public API ─────────────────────────────────────────────────────────

  /// `functions.invoke()` THROWS a [FunctionException] on any non-2xx
  /// response instead of returning it — a plain `res.status != 200` check
  /// after the await is dead code, it never runs. Server error codes (ex:
  /// 'stripe_customer_not_found') travel in `FunctionsHttpException.details`
  /// (the parsed JSON body), so they must be extracted here in the catch.
  String _reasonFromError(Object e) {
    if (e is FunctionException) {
      final details = e.details;
      final serverError = details is Map ? details['error'] : null;
      if (serverError is String && serverError.isNotEmpty) return serverError;
      return 'server_error_${e.status}';
    }
    return 'exception:$e';
  }

  /// Launches Stripe Checkout for [plan] in an external browser.
  /// On return (deep-link/app resume), [SubscriptionService.refresh] reconciles state.
  Future<StripeLaunchResult> startCheckout(CopiqPlan plan) async {
    if (!kIsWeb) return RevenueCatPaymentService.instance.startCheckout(plan);

    HapticFeedback.lightImpact();

    if (_sb.auth.currentUser == null) {
      return StripeLaunchResult.failure('not_authenticated');
    }

    try {
      final res = await _sb.functions.invoke(
        'cas_pratique_create_checkout',
        body: {'plan': plan.id},
      );

      if (res.data is! Map) {
        return StripeLaunchResult.failure('server_error_${res.status}');
      }

      final data = (res.data as Map).cast<String, dynamic>();
      final url = data['url'] as String?;
      if (url == null || url.isEmpty) {
        return StripeLaunchResult.failure('no_checkout_url');
      }

      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok) return StripeLaunchResult.failure('cannot_launch_browser');

      // Trigger a refresh on next resume — the webhook will have updated the DB.
      _scheduleRefreshOnResume();

      return StripeLaunchResult.success(url);
    } catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        debugPrint('[STRIPE] checkout error: $e\n$st');
      }
      return StripeLaunchResult.failure(_reasonFromError(e));
    }
  }

  /// Opens the Stripe Customer Portal (manage billing / payment methods / cancel).
  Future<StripeLaunchResult> openPortal() async {
    if (!kIsWeb) return RevenueCatPaymentService.instance.openPortal();

    if (_sb.auth.currentUser == null) {
      return StripeLaunchResult.failure('not_authenticated');
    }
    try {
      final res = await _sb.functions.invoke(
        'cas_pratique_customer_portal',
        body: {'return_url': 'copiqpolice://settings'},
      );
      if (res.data is! Map) {
        return StripeLaunchResult.failure('server_error_${res.status}');
      }
      final url = (res.data as Map)['url'] as String?;
      if (url == null) return StripeLaunchResult.failure('no_portal_url');
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!ok) return StripeLaunchResult.failure('cannot_launch_browser');
      _scheduleRefreshOnResume();
      return StripeLaunchResult.success(url);
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        debugPrint('[STRIPE] portal error: $e');
      }
      return StripeLaunchResult.failure(_reasonFromError(e));
    }
  }

  /// Cancels the active subscription at period end.
  /// Returns the period-end date (when access actually stops).
  Future<CancelResult> cancelAtPeriodEnd() async {
    if (!kIsWeb) return RevenueCatPaymentService.instance.cancelAtPeriodEnd();

    if (_sb.auth.currentUser == null) {
      return const CancelResult(ok: false, reason: 'not_authenticated');
    }
    try {
      final res = await _sb.functions.invoke(
        'cas_pratique_customer_portal',
        body: {'return_url': 'copiqpolice://settings'},
      );
      if (res.data is! Map) {
        return CancelResult(ok: false, reason: 'server_error_${res.status}');
      }
      final data = (res.data as Map).cast<String, dynamic>();
      final url = data['url'] as String?;
      if (url == null)
        return const CancelResult(ok: false, reason: 'no_portal_url');
      final launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        return const CancelResult(ok: false, reason: 'cannot_launch_browser');
      }
      // Le webhook Stripe met à jour la DB une fois l'annulation confirmée
      // dans le portail — on reconcilie l'entitlement au retour sur l'app.
      _scheduleRefreshOnResume();
      return const CancelResult(ok: true);
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        debugPrint('[STRIPE] cancel error: $e');
      }
      return CancelResult(ok: false, reason: _reasonFromError(e));
    }
  }

  /// Restaure un achat In-App existant (obligatoire côté Apple/Google).
  /// Sans équivalent Stripe web — Stripe n'a pas de notion de "restauration",
  /// le paiement web est déjà lié au compte via le Customer Portal.
  Future<StripeLaunchResult> restorePurchases() async {
    if (!kIsWeb) return RevenueCatPaymentService.instance.restorePurchases();
    return StripeLaunchResult.failure('unavailable_on_web');
  }

  // ── Internal ───────────────────────────────────────────────────────────

  Timer? _resumeTimer;
  void _scheduleRefreshOnResume() {
    _resumeTimer?.cancel();
    // Best-effort: refresh after 2s, 8s, 20s — by then the webhook has run.
    for (final s in const [2, 8, 20]) {
      Future.delayed(Duration(seconds: s), () {
        SubscriptionService.instance.refresh(force: true, withQuota: true);
      });
    }
  }
}

class StripeLaunchResult {
  final bool ok;
  final String? url;
  final String? reason;
  const StripeLaunchResult._({required this.ok, this.url, this.reason});
  factory StripeLaunchResult.success(String url) =>
      StripeLaunchResult._(ok: true, url: url);
  factory StripeLaunchResult.failure(String reason) =>
      StripeLaunchResult._(ok: false, reason: reason);
}

class CancelResult {
  final bool ok;
  final DateTime? periodEnd;
  final String? reason;
  const CancelResult({required this.ok, this.periodEnd, this.reason});
}
