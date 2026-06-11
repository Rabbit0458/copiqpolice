// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Feature Flags Remote Config                      ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-076             ║
// ║                                                                           ║
// ║  Étend `CpFeatureFlags` avec une couche de remote config (Supabase).      ║
// ║  Lecture seule côté client via la vue `cp_feature_flags_public`.          ║
// ║                                                                           ║
// ║  Permet de :                                                              ║
// ║    • Activer/désactiver un flag SANS REDÉPLOIEMENT de l'app              ║
// ║    • Faire monter un rollout 1% → 10% → 50% → 100% via SQL               ║
// ║    • Couper net une feature buguée en réponse à une alerte Sentry        ║
// ║                                                                           ║
// ║  Mécanique                                                                ║
// ║    1. Au démarrage : fetch les flags (ou cache local si offline)         ║
// ║    2. Bind sur CpFeatureFlags.I.bindImpl(remoteImpl)                     ║
// ║    3. Périodiquement : refresh (default 15min)                           ║
// ║    4. Persistance : shared_preferences (clé `cp_feature_flags_v1`)        ║
// ║                                                                           ║
// ║  Usage                                                                    ║
// ║    final remote = CpFeatureFlagsRemote(                                   ║
// ║      supabase: Supabase.instance.client,                                  ║
// ║      userId: supabase.auth.currentUser?.id,                              ║
// ║      onExposed: (flag, variant) => CpAnalytics.I.screenViewed(           ║
// ║        'cp_experiment_exposed',                                           ║
// ║        extra: {'flag': flag, 'variant': variant},                         ║
// ║      ),                                                                   ║
// ║    );                                                                     ║
// ║    await remote.initialize();                                             ║
// ║    CpFeatureFlags.I.bindImpl(remote);                                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'feature_flags_service.dart';

// ──────────────────────────────────────────────────────────────────────────
//  Modèle interne — flag remote résolu
// ──────────────────────────────────────────────────────────────────────────

@immutable
class _RemoteFlag {
  final String key;
  final String valueType; // bool | string | int | double | variant
  final Object? defaultValue;
  final int? rolloutPercent;
  final String? segment;

  const _RemoteFlag({
    required this.key,
    required this.valueType,
    required this.defaultValue,
    required this.rolloutPercent,
    required this.segment,
  });

  factory _RemoteFlag.fromJson(Map<String, dynamic> j) {
    Object? parsed = j['value_default'];
    // value_default vient en JSONB → déjà décodé en Dart (bool/num/string/List)
    return _RemoteFlag(
      key: j['key'] as String,
      valueType: j['value_type'] as String? ?? 'string',
      defaultValue: parsed,
      rolloutPercent: (j['rollout_percent'] as num?)?.toInt(),
      segment: j['segment'] as String?,
    );
  }

  Map<String, Object?> toCache() => {
        'key': key,
        'value_type': valueType,
        'value_default': defaultValue,
        'rollout_percent': rolloutPercent,
        'segment': segment,
      };
}

// ──────────────────────────────────────────────────────────────────────────
//  Impl publique de CpFeatureFlagsInterface (à brancher via bindImpl)
// ──────────────────────────────────────────────────────────────────────────

class CpFeatureFlagsRemote implements CpFeatureFlagsInterface {
  CpFeatureFlagsRemote({
    required SupabaseClient supabase,
    String? userId,
    void Function(String flag, Object? variant)? onExposed,
    Duration refreshInterval = const Duration(minutes: 15),
    String tableOrView = 'cp_feature_flags_public',
  })  : _sb = supabase,
        _userId = userId,
        _onExposed = onExposed,
        _refreshInterval = refreshInterval,
        _tableOrView = tableOrView;

  // ── Config ───────────────────────────────────────────────────────────────
  final SupabaseClient _sb;
  String? _userId;
  final void Function(String, Object?)? _onExposed;
  final Duration _refreshInterval;
  final String _tableOrView;

  static const _kCacheKey = 'cp_feature_flags_v1';

  // ── État ─────────────────────────────────────────────────────────────────
  final Map<String, _RemoteFlag> _flags = {};
  Timer? _refreshTimer;
  bool _initialized = false;
  DateTime? _lastFetchedAt;

  bool get isInitialized => _initialized;
  DateTime? get lastFetchedAt => _lastFetchedAt;

  // ── Cycle de vie ─────────────────────────────────────────────────────────

  /// 1. Charge le cache local (instantané, offline-safe).
  /// 2. Lance un fetch réseau en background.
  /// 3. Programme un refresh périodique.
  Future<void> initialize() async {
    await _loadFromCache();
    _initialized = true;
    // Fire-and-forget : on n'attend pas le réseau
    unawaited(_fetchFromRemote());
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      unawaited(_fetchFromRemote());
    });
  }

  /// Stoppe le refresh périodique (à appeler au logout).
  void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Met à jour l'identifiant utilisateur (au login/logout).
  /// Invalide les buckets de rollout pour qu'ils soient recalculés.
  void identify(String? userId) {
    _userId = userId;
  }

  /// Force un fetch immédiat (utile après un message Sentry / push admin).
  Future<void> refresh() => _fetchFromRemote();

  // ── Persistance ──────────────────────────────────────────────────────────

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kCacheKey);
      if (raw == null || raw.isEmpty) return;
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;
      _flags.clear();
      for (final item in decoded) {
        if (item is! Map) continue;
        final flag = _RemoteFlag.fromJson(Map<String, dynamic>.from(item));
        _flags[flag.key] = flag;
      }
      if (kDebugMode) {
        debugPrint('[CpFeatureFlagsRemote] Loaded ${_flags.length} flags from cache');
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[CpFeatureFlagsRemote] cache load failed: $e\n$st');
      }
    }
  }

  Future<void> _saveCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _flags.values.map((f) => f.toCache()).toList(growable: false);
      await prefs.setString(_kCacheKey, jsonEncode(list));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[CpFeatureFlagsRemote] cache save failed: $e\n$st');
      }
    }
  }

  // ── Réseau ───────────────────────────────────────────────────────────────

  Future<void> _fetchFromRemote() async {
    try {
      final res = await _sb.from(_tableOrView).select();
      _flags.clear();
      for (final row in res) {
        final flag = _RemoteFlag.fromJson(Map<String, dynamic>.from(row));
        _flags[flag.key] = flag;
      }
      _lastFetchedAt = DateTime.now();
      await _saveCache();
      if (kDebugMode) {
        debugPrint('[CpFeatureFlagsRemote] Fetched ${_flags.length} flags');
      }
    } catch (e, st) {
      // Pas de fail : on garde la valeur cache, c'est résilient.
      if (kDebugMode) {
        debugPrint('[CpFeatureFlagsRemote] remote fetch failed: $e\n$st');
      }
    }
  }

  // ── Hash déterministe (identique à _CpFeatureFlagsLocal pour parité) ────

  int _bucket(String flagKey) {
    final input = '${_userId ?? 'anon'}:$flagKey';
    int hash = 0x811c9dc5;
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash % 100;
  }

  void _track(String flag, Object? variant) {
    final cb = _onExposed;
    if (cb == null) return;
    try {
      cb(flag, variant);
    } catch (_) {/* ignore */}
  }

  /// Pour un flag bool/typé, applique le rolloutPercent côté client.
  /// Si rolloutPercent est null → toujours `value_default`.
  /// Si rolloutPercent < 100 → on dépend du bucket utilisateur.
  Object? _resolveWithRollout(_RemoteFlag flag) {
    final percent = flag.rolloutPercent;
    if (percent == null || percent >= 100) {
      return flag.defaultValue;
    }
    if (percent <= 0) {
      // Hors rollout → on inverse la valeur si c'est un bool, sinon defaultValue
      if (flag.defaultValue is bool) {
        return !(flag.defaultValue as bool);
      }
      return flag.defaultValue;
    }
    final inside = _bucket(flag.key) < percent;
    if (flag.defaultValue is bool) {
      // Pour un bool : inside ⇒ defaultValue ; outside ⇒ inverse
      return inside ? flag.defaultValue : !(flag.defaultValue as bool);
    }
    // Pour les autres types : on retourne la valeur seulement si inside
    return inside ? flag.defaultValue : null;
  }

  // ── CpFeatureFlagsInterface ──────────────────────────────────────────────

  @override
  bool isEnabled(String key, {bool defaultValue = false}) {
    final flag = _flags[key];
    if (flag == null) {
      _track(key, defaultValue);
      return defaultValue;
    }
    final resolved = _resolveWithRollout(flag);
    final result = resolved is bool ? resolved : defaultValue;
    _track(key, result);
    return result;
  }

  @override
  String getString(String key, {String defaultValue = ''}) {
    final flag = _flags[key];
    if (flag == null) {
      _track(key, defaultValue);
      return defaultValue;
    }
    final v = flag.defaultValue;
    final result = v is String ? v : defaultValue;
    _track(key, result);
    return result;
  }

  @override
  int getInt(String key, {int defaultValue = 0}) {
    final flag = _flags[key];
    if (flag == null) {
      _track(key, defaultValue);
      return defaultValue;
    }
    final v = flag.defaultValue;
    final result =
        v is int ? v : (v is num ? v.toInt() : defaultValue);
    _track(key, result);
    return result;
  }

  @override
  double getDouble(String key, {double defaultValue = 0.0}) {
    final flag = _flags[key];
    if (flag == null) {
      _track(key, defaultValue);
      return defaultValue;
    }
    final v = flag.defaultValue;
    final result =
        v is double ? v : (v is num ? v.toDouble() : defaultValue);
    _track(key, result);
    return result;
  }

  @override
  String? assignVariant(String experimentKey, List<String> variants) {
    if (variants.isEmpty) return null;

    // Si flag remote présent et est de type variant avec une liste, on prend
    // la liste serveur en priorité (elle peut être différente du code Dart).
    final flag = _flags[experimentKey];
    List<String> finalVariants = variants;
    if (flag != null && flag.valueType == 'variant') {
      final remote = flag.defaultValue;
      if (remote is List) {
        final asStrings = remote
            .whereType<Object?>()
            .map((e) => e?.toString())
            .whereType<String>()
            .toList();
        if (asStrings.isNotEmpty) finalVariants = asStrings;
      }
    }
    final bucket = _bucket(experimentKey);
    final variant = finalVariants[bucket % finalVariants.length];
    _track(experimentKey, variant);
    return variant;
  }

  @override
  bool isInRollout(String key, int rolloutPercent) {
    // On respecte d'abord le rolloutPercent serveur si défini
    final flag = _flags[key];
    int effectivePercent = rolloutPercent;
    if (flag != null && flag.rolloutPercent != null) {
      effectivePercent = flag.rolloutPercent!;
    }
    if (effectivePercent <= 0) {
      _track('rollout:$key', false);
      return false;
    }
    if (effectivePercent >= 100) {
      _track('rollout:$key', true);
      return true;
    }
    final inside = _bucket(key) < effectivePercent;
    _track('rollout:$key', inside);
    return inside;
  }
}
