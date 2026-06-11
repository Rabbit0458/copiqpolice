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

import 'subscription_service.dart';

enum CopiqPlan { week, month, year }

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
}

class StripePaymentService {
  StripePaymentService._();
  static final StripePaymentService instance = StripePaymentService._();

  SupabaseClient get _sb => Supabase.instance.client;

  // ── Public API ─────────────────────────────────────────────────────────

  /// Launches Stripe Checkout for [plan] in an external browser.
  /// On return (deep-link/app resume), [SubscriptionService.refresh] reconciles state.
  Future<StripeLaunchResult> startCheckout(CopiqPlan plan) async {
    HapticFeedback.lightImpact();

    if (_sb.auth.currentUser == null) {
      return StripeLaunchResult.failure('not_authenticated');
    }

    try {
      final res = await _sb.functions.invoke(
        'stripe-create-checkout',
        body: {'plan': plan.id},
      );

      if (res.status != 200 || res.data is! Map) {
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
        print('[STRIPE] checkout error: $e\n$st');
      }
      return StripeLaunchResult.failure('exception:$e');
    }
  }

  /// Opens the Stripe Customer Portal (manage billing / payment methods / cancel).
  Future<StripeLaunchResult> openPortal() async {
    if (_sb.auth.currentUser == null) {
      return StripeLaunchResult.failure('not_authenticated');
    }
    try {
      final res = await _sb.functions.invoke('stripe-portal');
      if (res.status != 200 || res.data is! Map) {
        return StripeLaunchResult.failure('server_error_${res.status}');
      }
      final url = (res.data as Map)['url'] as String?;
      if (url == null) return StripeLaunchResult.failure('no_portal_url');
      final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!ok) return StripeLaunchResult.failure('cannot_launch_browser');
      _scheduleRefreshOnResume();
      return StripeLaunchResult.success(url);
    } catch (e) {
      return StripeLaunchResult.failure('exception:$e');
    }
  }

  /// Cancels the active subscription at period end.
  /// Returns the period-end date (when access actually stops).
  Future<CancelResult> cancelAtPeriodEnd() async {
    if (_sb.auth.currentUser == null) {
      return const CancelResult(ok: false, reason: 'not_authenticated');
    }
    try {
      final res = await _sb.functions.invoke('stripe-cancel-subscription');
      if (res.status != 200 || res.data is! Map) {
        if (res.status == 404) return const CancelResult(ok: false, reason: 'no_active_subscription');
        return CancelResult(ok: false, reason: 'server_error_${res.status}');
      }
      final data = (res.data as Map).cast<String, dynamic>();
      final endIso = data['current_period_end'] as String?;
      DateTime? end;
      if (endIso != null) end = DateTime.tryParse(endIso);
      // Refresh entitlement to reflect cancel_at_period_end immediately
      await SubscriptionService.instance.refresh(force: true, withQuota: true);
      return CancelResult(ok: true, periodEnd: end);
    } catch (e) {
      return CancelResult(ok: false, reason: 'exception:$e');
    }
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
  factory StripeLaunchResult.success(String url) => StripeLaunchResult._(ok: true, url: url);
  factory StripeLaunchResult.failure(String reason) => StripeLaunchResult._(ok: false, reason: reason);
}

class CancelResult {
  final bool ok;
  final DateTime? periodEnd;
  final String? reason;
  const CancelResult({required this.ok, this.periodEnd, this.reason});
}
