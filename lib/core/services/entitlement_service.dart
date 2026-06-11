// lib/core/services/entitlement_service.dart
//
// COP'IQ — Entitlement (role + plan + quota + expiry).
// Wraps a single RPC `get_my_entitlement()` to give the UI everything it
// needs in one call. Used by:
//   - PaywallGate (block premium content)
//   - Owner banner (founder/dev mode)
//   - facture_page (current plan card)
//
// This is complementary to SubscriptionService (which handles realtime
// + quota + the lock dialog). When in doubt, prefer SubscriptionService
// for "is this user premium right now?" — this service exposes the
// richer entitlement payload (role, valid_until, cancel_at_period_end…).

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Entitlement {
  final bool authenticated;
  final String role; // 'owner' | 'admin' | 'moderator' | 'active' | 'user'
  final bool isOwner;
  final bool isAdmin; // owner OR admin
  final bool premium; // any source: owner bypass, paid sub, trial
  final String plan;  // 'free' | 'week' | 'month' | 'year'
  final String status;// 'active' | 'trial' | 'cancelled' | 'expired' | 'past_due'
  final DateTime? validUntil;
  final bool cancelAtPeriodEnd;
  final int freeUsed;
  final int freeLimit;
  final int freeRemaining;
  final DateTime? freeResetsAt;

  const Entitlement({
    required this.authenticated,
    required this.role,
    required this.isOwner,
    required this.isAdmin,
    required this.premium,
    required this.plan,
    required this.status,
    required this.validUntil,
    required this.cancelAtPeriodEnd,
    required this.freeUsed,
    required this.freeLimit,
    required this.freeRemaining,
    required this.freeResetsAt,
  });

  static const Entitlement guest = Entitlement(
    authenticated: false,
    role: 'user',
    isOwner: false,
    isAdmin: false,
    premium: false,
    plan: 'free',
    status: 'expired',
    validUntil: null,
    cancelAtPeriodEnd: false,
    freeUsed: 0,
    freeLimit: 10,
    freeRemaining: 10,
    freeResetsAt: null,
  );

  factory Entitlement.fromJson(Map<String, dynamic> j) {
    DateTime? parse(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return Entitlement(
      authenticated: j['authenticated'] == true,
      role: (j['role'] ?? 'user').toString(),
      isOwner: j['is_owner'] == true,
      isAdmin: j['is_admin'] == true,
      premium: j['premium'] == true,
      plan: (j['plan'] ?? 'free').toString(),
      status: (j['status'] ?? 'active').toString(),
      validUntil: parse(j['valid_until']),
      cancelAtPeriodEnd: j['cancel_at_period_end'] == true,
      freeUsed: (j['free_used'] is num) ? (j['free_used'] as num).toInt() : 0,
      freeLimit: (j['free_limit'] is num) ? (j['free_limit'] as num).toInt() : 10,
      freeRemaining: (j['free_remaining'] is num) ? (j['free_remaining'] as num).toInt() : 10,
      freeResetsAt: parse(j['free_resets_at']),
    );
  }

  /// Should the app show ads to this user? Premium users (incl. owner) get NO ads.
  bool get shouldShowAds => !premium;

  /// Pretty label for the current plan.
  String get planLabel => switch (plan) {
    'week' => 'Hebdomadaire',
    'month' => 'Mensuel',
    'year' => 'Annuel',
    _ => 'Gratuit',
  };
}

class EntitlementService {
  EntitlementService._();
  static final EntitlementService instance = EntitlementService._();

  SupabaseClient get _sb => Supabase.instance.client;

  final ValueNotifier<Entitlement> state = ValueNotifier<Entitlement>(Entitlement.guest);

  Completer<Entitlement>? _inflight;

  Future<Entitlement> refresh({bool force = false}) async {
    if (_inflight != null && !force) return _inflight!.future;
    _inflight = Completer<Entitlement>();
    try {
      final raw = await _sb.rpc('get_my_entitlement');
      Map<String, dynamic> j;
      if (raw is Map) {
        j = raw.map((k, v) => MapEntry(k.toString(), v));
      } else {
        j = const {};
      }
      final ent = j['authenticated'] == true ? Entitlement.fromJson(j) : Entitlement.guest;
      state.value = ent;
      _inflight!.complete(ent);
      return ent;
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[ENTITLEMENT] refresh error: $e');
      }
      _inflight!.complete(state.value);
      return state.value;
    } finally {
      _inflight = null;
    }
  }
}
