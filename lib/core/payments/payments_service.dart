// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Payments service (Stripe + RevenueCat ready)     ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-085             ║
// ║                                                                           ║
// ║  Façade légère sans dépendance externe forcée.                            ║
// ║   • Lit le tier courant via la vue `cp_my_subscription` (CODE-084)        ║
// ║   • Crée une Checkout Session via edge fn `cas_pratique_create_checkout`  ║
// ║   • Ouvre l'URL Stripe Checkout dans le navigateur natif                  ║
// ║   • Expose un état Listenable pour rebuild les widgets dépendants         ║
// ║                                                                           ║
// ║  Pour brancher RevenueCat plus tard (paywall iOS/Android natif) :        ║
// ║   1. Ajouter purchases_flutter au pubspec                                 ║
// ║   2. Créer CpRevenueCatPayments implements CpPaymentsInterface           ║
// ║   3. Appeler CpPayments.I.bindImpl(myRevenueCat) au démarrage            ║
// ║                                                                           ║
// ║  Usage minimal :                                                          ║
// ║   final tier = await CpPayments.I.refreshTier();                         ║
// ║   if (tier == CpTier.free) { Navigator.push(... paywall ...); }          ║
// ║   await CpPayments.I.startCheckout(priceId: 'price_xxx');                ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ──────────────────────────────────────────────────────────────────────────
//  Modèles
// ──────────────────────────────────────────────────────────────────────────

enum CpTier { free, premiumTrial, premium }

extension CpTierX on CpTier {
  String get wireValue {
    switch (this) {
      case CpTier.free:
        return 'free';
      case CpTier.premiumTrial:
        return 'premium_trial';
      case CpTier.premium:
        return 'premium';
    }
  }

  bool get isPaid =>
      this == CpTier.premium || this == CpTier.premiumTrial;

  static CpTier fromWire(String? value) {
    switch (value) {
      case 'premium':
        return CpTier.premium;
      case 'premium_trial':
        return CpTier.premiumTrial;
      default:
        return CpTier.free;
    }
  }
}

/// Snapshot d'abonnement (mappé sur la vue `cp_my_subscription`).
@immutable
class CpSubscription {
  final String userId;
  final CpTier tier;
  final String status;
  final bool cancelAtPeriodEnd;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? trialEndsAt;
  final List<String> entitlements;
  final DateTime? updatedAt;

  const CpSubscription({
    required this.userId,
    required this.tier,
    required this.status,
    required this.cancelAtPeriodEnd,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.trialEndsAt,
    required this.entitlements,
    required this.updatedAt,
  });

  /// Souscription "free" par défaut, pour les users sans entrée DB.
  factory CpSubscription.free(String userId) => CpSubscription(
        userId: userId,
        tier: CpTier.free,
        status: 'active',
        cancelAtPeriodEnd: false,
        currentPeriodStart: null,
        currentPeriodEnd: null,
        trialEndsAt: null,
        entitlements: const [],
        updatedAt: null,
      );

  factory CpSubscription.fromMap(Map<String, dynamic> m) {
    DateTime? parseTs(Object? v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString())?.toUtc();
    }

    final entitlementsRaw = m['entitlements'];
    final entitlements = <String>[];
    if (entitlementsRaw is List) {
      for (final e in entitlementsRaw) {
        if (e is String) entitlements.add(e);
      }
    }

    return CpSubscription(
      userId: m['user_id']?.toString() ?? '',
      tier: CpTierX.fromWire(m['tier']?.toString()),
      status: m['status']?.toString() ?? 'active',
      cancelAtPeriodEnd: m['cancel_at_period_end'] == true,
      currentPeriodStart: parseTs(m['current_period_start']),
      currentPeriodEnd: parseTs(m['current_period_end']),
      trialEndsAt: parseTs(m['trial_ends_at']),
      entitlements: entitlements,
      updatedAt: parseTs(m['updated_at']),
    );
  }

  /// True si l'utilisateur a accès à la feature donnée.
  bool hasEntitlement(String key) =>
      tier.isPaid && entitlements.contains(key);

  /// Convenience pour les checks rapides.
  bool get isPremium => tier.isPaid;
  bool get isOnTrial => tier == CpTier.premiumTrial;
}

// ──────────────────────────────────────────────────────────────────────────
//  Entitlements catalogue — clés alignées avec metadata Stripe Product
// ──────────────────────────────────────────────────────────────────────────

abstract class CpEntitlements {
  CpEntitlements._();
  static const String unlimitedCases = 'unlimited_cases';
  static const String concoursBlanc = 'concours_blanc';
  static const String pdfExport = 'pdf_export';
  static const String leaderboard = 'leaderboard';
  static const String annalesFull = 'annales_full';
  static const String edgeCorrection = 'edge_correction';
  static const String supportPriority = 'support_priority';
}

// ──────────────────────────────────────────────────────────────────────────
//  Interface
// ──────────────────────────────────────────────────────────────────────────

abstract class CpPaymentsInterface {
  Future<CpSubscription> refreshTier();
  Future<String?> startCheckout({
    required String priceId,
    String? successUrl,
    String? cancelUrl,
    bool allowPromotionCodes = true,
  });
  Future<void> openCustomerPortal();
}

// ──────────────────────────────────────────────────────────────────────────
//  Singleton + impl Supabase + Stripe Checkout web
// ──────────────────────────────────────────────────────────────────────────

class CpPayments extends ChangeNotifier implements CpPaymentsInterface {
  CpPayments._();
  static final CpPayments _instance = CpPayments._();
  static CpPayments get I => _instance;

  CpSubscription? _current;
  CpSubscription get current =>
      _current ?? CpSubscription.free('anonymous');

  CpTier get tier => current.tier;
  bool get isPremium => current.isPremium;

  @override
  Future<CpSubscription> refreshTier() async {
    try {
      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;
      if (user == null) {
        _current = CpSubscription.free('anonymous');
        notifyListeners();
        return _current!;
      }

      final res = await sb
          .from('cp_my_subscription')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (res == null) {
        _current = CpSubscription.free(user.id);
      } else {
        _current = CpSubscription.fromMap(Map<String, dynamic>.from(res));
      }
      notifyListeners();
      return _current!;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[CpPayments] refreshTier error: $e\n$st');
      }
      _current ??= CpSubscription.free(
          Supabase.instance.client.auth.currentUser?.id ?? 'anonymous');
      return _current!;
    }
  }

  /// Crée la Checkout Session via edge fn et ouvre l'URL dans le navigateur.
  /// Retourne l'URL ouverte (ou null en cas d'échec).
  @override
  Future<String?> startCheckout({
    required String priceId,
    String? successUrl,
    String? cancelUrl,
    bool allowPromotionCodes = true,
  }) async {
    try {
      final sb = Supabase.instance.client;
      final res = await sb.functions.invoke(
        'cas_pratique_create_checkout',
        body: {
          'price_id': priceId,
          if (successUrl != null) 'success_url': successUrl,
          if (cancelUrl != null) 'cancel_url': cancelUrl,
          'allow_promotion_codes': allowPromotionCodes,
        },
      );

      final data = res.data;
      if (data is! Map || data['url'] is! String) {
        if (kDebugMode) {
          debugPrint('[CpPayments] checkout response invalid: $data');
        }
        return null;
      }
      final url = data['url'] as String;
      final ok = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      return ok ? url : null;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[CpPayments] startCheckout error: $e\n$st');
      }
      return null;
    }
  }

  /// Ouvre le portail Customer Stripe (gestion abonnement / facturation).
  /// Nécessite une edge fn `cas_pratique_customer_portal` à créer.
  @override
  Future<void> openCustomerPortal() async {
    try {
      final sb = Supabase.instance.client;
      final res = await sb.functions.invoke(
        'cas_pratique_customer_portal',
        body: {'return_url': 'copiqpolice://settings'},
      );
      final data = res.data;
      if (data is Map && data['url'] is String) {
        await launchUrl(
          Uri.parse(data['url'] as String),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CpPayments] openCustomerPortal error: $e');
      }
    }
  }

  /// Permet de swap l'implémentation (ex: RevenueCat) plus tard.
  void bindImpl(CpPaymentsInterface impl) {
    _delegated = impl;
  }

  CpPaymentsInterface? _delegated;
}
