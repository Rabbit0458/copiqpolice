// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Subscription service (placeholder)            ║
// ║  Tâche      : CODE-064 (placeholder pour CODE-084 paywall complet)     ║
// ║                                                                         ║
// ║  Le paywall Stripe + revenue cat + edge function check est CODE-084.   ║
// ║  En attendant, ce service expose une API minimale `isPremium()` qui    ║
// ║  retourne false par défaut (tout user en free tier) — sauf override   ║
// ║  via user_metadata.cas_pratique_premium = true (utile pour les tests   ║
// ║  internes et les comptes admin).                                        ║
// ║                                                                         ║
// ║  Cette indirection permet de brancher tout le code UI / gating dès    ║
// ║  maintenant, et de juste remplacer la source de vérité en CODE-084.   ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CasPratiqueSubscriptionService {
  CasPratiqueSubscriptionService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final CasPratiqueSubscriptionService instance =
      CasPratiqueSubscriptionService._();

  final SupabaseClient _sb;

  /// Clé user_metadata utilisée comme override temporaire (avant CODE-084).
  static const String _kMetadataKey = 'cas_pratique_premium';

  /// Retourne `true` si l'user est abonné (placeholder : check user_metadata).
  /// Sera remplacé en CODE-084 par un check Supabase RPC qui interroge
  /// Stripe / RevenueCat.
  bool isPremium() {
    final user = _sb.auth.currentUser;
    if (user == null) return false;
    final meta = user.userMetadata;
    if (meta == null) return false;
    return meta[_kMetadataKey] == true;
  }

  /// True si l'user peut accéder à ce cas (free OU premium).
  bool canAccessCase({required bool isFree}) {
    return isFree || isPremium();
  }

  /// (Debug) Toggle l'override premium. Pour tester la UI lock en dev.
  Future<void> debugSetPremium(bool value) async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return;
      final next = Map<String, dynamic>.from(user.userMetadata ?? const {});
      next[_kMetadataKey] = value;
      await _sb.auth.updateUser(UserAttributes(data: next));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SubscriptionService] debugSetPremium failed: $e');
      }
    }
  }
}
