// lib/core/services/user_context_service.dart
//
// Source de vérité unique pour `user_track` et `user_mode`.
//
// - Lit `public.user_profiles.user_track` et `public.user_profiles.user_mode`
//   au démarrage et garde les valeurs en mémoire (singleton).
// - Tombe sur SharedPreferences si réseau KO (offline-tolerant).
// - Doit être rafraîchi quand l'utilisateur change de grade/mode
//   (`grade_picker.dart`, `mode_picker.dart`) en appelant `refresh()`.
//
// Utilisation :
//   final track = UserContextService.instance.track ?? 'gpx';
//   final mode  = UserContextService.instance.mode  ?? 'school';
//
// Les valeurs possibles :
//   track : 'gpx' | 'pa' | 'reserve'
//   mode  : 'school' | 'exam'

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Valeurs valides supportées (architecture évolutive — ne pas faire de if/else).
class UserTracks {
  static const String gpx = 'gpx';
  static const String pa = 'pa';
  static const String reserve = 'reserve';

  static const Set<String> values = {gpx, pa, reserve};

  static bool isValid(String? v) => v != null && values.contains(v);

  /// Fallback safe quand le track n'est pas connu (avant init / sans réseau).
  static const String fallback = gpx;
}

class UserModes {
  static const String school = 'school';
  static const String exam = 'exam';

  static const Set<String> values = {school, exam};

  static bool isValid(String? v) => v != null && values.contains(v);

  /// Fallback safe quand le mode n'est pas connu.
  static const String fallback = exam;
}

/// Singleton qui maintient en mémoire le track + mode courants.
///
/// Cycle de vie :
///   1. `await UserContextService.instance.init()` au démarrage (main.dart).
///   2. Après chaque écriture sur `user_profiles` (grade_picker, mode_picker),
///      appeler `await UserContextService.instance.refresh()`.
///   3. En lecture : `UserContextService.instance.track` /
///      `UserContextService.instance.mode`.
class UserContextService {
  UserContextService._();

  static final UserContextService instance = UserContextService._();

  /// Alias court (lecture/écriture rapide).
  static UserContextService get I => instance;

  // --- Clés SharedPreferences (cohérentes avec home_bootstrap.dart) ----------
  static const String _spKeyTrack = 'selected_track';
  static const String _spKeyMode = 'user_mode';

  /// Valeurs cache (null tant qu'init() n'a pas été appelé avec succès).
  String? _track;
  String? _mode;

  /// État d'init.
  bool _initialized = false;

  /// Notifier optionnel pour reconstruire des widgets si besoin.
  final ValueNotifier<String?> trackListenable = ValueNotifier<String?>(null);
  final ValueNotifier<String?> modeListenable = ValueNotifier<String?>(null);

  // ---------------------------------------------------------------------------
  // Accès en lecture
  // ---------------------------------------------------------------------------

  /// Track courant (nullable si pas encore initialisé).
  String? get track => _track;

  /// Mode courant (nullable si pas encore initialisé).
  String? get mode => _mode;

  /// Track courant avec fallback safe (jamais null).
  String get trackOrDefault => UserTracks.isValid(_track)
      ? _track!
      : UserTracks.fallback;

  /// Mode courant avec fallback safe (jamais null).
  String get modeOrDefault => UserModes.isValid(_mode)
      ? _mode!
      : UserModes.fallback;

  bool get isInitialized => _initialized;

  // ---------------------------------------------------------------------------
  // Init / refresh
  // ---------------------------------------------------------------------------

  /// À appeler une fois au démarrage de l'application.
  /// Charge depuis SharedPreferences (rapide) puis depuis Supabase
  /// (source de vérité) en arrière-plan.
  Future<void> init() async {
    if (_initialized) return;
    // 1) Cache local d'abord (instantané, pour ne pas bloquer le boot).
    await _loadFromLocal();
    // 2) Source de vérité = Supabase (en best-effort).
    await _loadFromSupabase();
    _initialized = true;
  }

  /// Force un re-fetch (à appeler après que l'utilisateur change track ou mode).
  Future<void> refresh() async {
    await _loadFromSupabase();
    await _persistLocal();
  }

  /// Met à jour manuellement le track (utilisé par grade_picker).
  Future<void> setTrack(String track) async {
    if (!UserTracks.isValid(track)) return;
    _track = track;
    trackListenable.value = track;
    await _persistLocal();
  }

  /// Met à jour manuellement le mode (utilisé par mode_picker).
  Future<void> setMode(String mode) async {
    if (!UserModes.isValid(mode)) return;
    _mode = mode;
    modeListenable.value = mode;
    await _persistLocal();
  }

  /// Reset (utile au logout).
  Future<void> clear() async {
    _track = null;
    _mode = null;
    _initialized = false;
    trackListenable.value = null;
    modeListenable.value = null;
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.remove(_spKeyTrack);
      await sp.remove(_spKeyMode);
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Interne
  // ---------------------------------------------------------------------------

  Future<void> _loadFromLocal() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final t = sp.getString(_spKeyTrack);
      final m = sp.getString(_spKeyMode);
      if (UserTracks.isValid(t)) {
        _track = t;
        trackListenable.value = t;
      }
      if (UserModes.isValid(m)) {
        _mode = m;
        modeListenable.value = m;
      }
    } catch (e) {
      debugPrint('[UserContextService] local read failed: $e');
    }
  }

  Future<void> _loadFromSupabase() async {
    try {
      final sb = Supabase.instance.client;
      final user = sb.auth.currentUser;
      if (user == null) return;
      final row = await sb
          .from('user_profiles')
          .select('user_track, user_mode')
          .eq('user_id', user.id)
          .maybeSingle();
      if (row == null) return;

      final t = (row['user_track'] as String?)?.trim().toLowerCase();
      final m = (row['user_mode'] as String?)?.trim().toLowerCase();

      if (UserTracks.isValid(t)) {
        _track = t;
        trackListenable.value = t;
      }
      if (UserModes.isValid(m)) {
        _mode = m;
        modeListenable.value = m;
      }
    } catch (e) {
      debugPrint('[UserContextService] supabase read failed: $e');
    }
  }

  Future<void> _persistLocal() async {
    try {
      final sp = await SharedPreferences.getInstance();
      if (_track != null) await sp.setString(_spKeyTrack, _track!);
      if (_mode != null) await sp.setString(_spKeyMode, _mode!);
    } catch (e) {
      debugPrint('[UserContextService] persist failed: $e');
    }
  }
}
