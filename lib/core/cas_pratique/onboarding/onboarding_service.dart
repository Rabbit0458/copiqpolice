// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Onboarding service                            ║
// ║  Tâche      : CODE-063                                                  ║
// ║                                                                         ║
// ║  Wrapper léger pour persister/lire le flag `cas_pratique_onboarding_  ║
// ║  done` côté Supabase Auth (user metadata) ET en cache local              ║
// ║  shared_preferences (pour offline + boot rapide).                       ║
// ║                                                                         ║
// ║  Pourquoi côté Supabase Auth ?                                          ║
// ║   - Indépendant du device : si l'user se reconnecte sur un autre       ║
// ║     téléphone, on ne lui repropose pas l'onboarding.                   ║
// ║                                                                         ║
// ║  Pourquoi aussi côté shared_preferences ?                               ║
// ║   - Lecture instantanée au boot sans round-trip réseau.                 ║
// ║                                                                         ║
// ║  API :                                                                   ║
// ║   - hasCompleted()           → bool (lit le cache local d'abord)        ║
// ║   - markCompleted()          → write Supabase + local                    ║
// ║   - reset() (debug/admin)    → efface les deux                           ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CasPratiqueOnboardingService {
  CasPratiqueOnboardingService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final CasPratiqueOnboardingService instance =
      CasPratiqueOnboardingService._();

  final SupabaseClient _sb;

  /// Clé shared_preferences (cache local).
  static const String _kLocalKey = 'cas_pratique_onboarding_done';

  /// Clé user_metadata côté Supabase.
  static const String _kRemoteKey = 'cas_pratique_onboarding_done';

  /// Lit le flag. Vérifie d'abord le cache local (rapide) puis le métadata
  /// distant si nécessaire (cas du multi-device).
  Future<bool> hasCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_kLocalKey) == true) return true;

      // Sinon : check côté user_metadata Supabase
      final user = _sb.auth.currentUser;
      final remote = user?.userMetadata?[_kRemoteKey];
      if (remote == true) {
        await prefs.setBool(_kLocalKey, true);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OnboardingService] hasCompleted failed: $e');
      }
      return false;
    }
  }

  /// Marque comme terminé (local + distant).
  Future<void> markCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kLocalKey, true);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OnboardingService] markCompleted local failed: $e');
      }
    }
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return; // pas connecté → seul le local est mis à jour
      final next = Map<String, dynamic>.from(user.userMetadata ?? const {});
      next[_kRemoteKey] = true;
      await _sb.auth.updateUser(UserAttributes(data: next));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[OnboardingService] markCompleted remote failed: $e');
      }
    }
  }

  /// Reset complet (utile en debug / depuis l'admin).
  Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kLocalKey);
    } catch (_) {}
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return;
      final next = Map<String, dynamic>.from(user.userMetadata ?? const {});
      next.remove(_kRemoteKey);
      await _sb.auth.updateUser(UserAttributes(data: next));
    } catch (_) {}
  }
}
