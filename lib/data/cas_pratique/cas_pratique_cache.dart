// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Cache local                                   ║
// ║  Référence : docs/cas_pratique/10_API_SURFACE.md (section 5)            ║
// ║  Tâche      : CODE-017                                                  ║
// ║                                                                         ║
// ║  Stratégie : shared_preferences (déjà disponible dans le projet)        ║
// ║  Chaque entrée = JSON + timestamp. TTL contrôlé à la lecture.           ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TTL des différentes catégories de cache.
class CacheTtl {
  CacheTtl._();

  static const Duration themes        = Duration(hours: 24);
  static const Duration casesList     = Duration(hours: 1);
  static const Duration caseDetail    = Duration(days: 7);
  static const Duration myProgress    = Duration(minutes: 5);
}

/// Cache local du module Cas Pratique.
///
/// **Pourquoi shared_preferences ?**
/// - Déjà utilisé par d'autres modules de COP'IQ
/// - Pas de nouvelle dépendance (Hive nécessite init + adapters)
/// - Suffisant pour ~50 cas × ~10 ko = 500 ko (largement OK)
///
/// **API** :
/// ```dart
/// final cache = CasPratiqueCache();
/// await cache.init();
/// await cache.put('themes', jsonEncode(themes));
/// final cached = await cache.getFresh('themes', ttl: CacheTtl.themes);
/// ```
class CasPratiqueCache {
  CasPratiqueCache._();

  /// Singleton — un seul cache pour toute l'app.
  static final CasPratiqueCache instance = CasPratiqueCache._();

  SharedPreferences? _prefs;

  // Préfixe pour éviter de polluer les autres modules
  static const String _prefix = 'cp_cache.';
  static const String _tsSuffix = '.ts';

  bool get isReady => _prefs != null;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> _sp() async {
    if (_prefs != null) return _prefs!;
    await init();
    return _prefs!;
  }

  // ─── Lecture / écriture brutes ──────────────────────────────────────────

  /// Écrit une entrée + son timestamp courant.
  Future<void> put(String key, String value) async {
    final sp = await _sp();
    final pk = '$_prefix$key';
    await sp.setString(pk, value);
    await sp.setInt('$pk$_tsSuffix', DateTime.now().millisecondsSinceEpoch);
  }

  /// Lit une entrée si elle existe ET qu'elle n'est pas expirée.
  /// Retourne `null` sinon.
  Future<String?> getFresh(String key, {required Duration ttl}) async {
    final sp = await _sp();
    final pk = '$_prefix$key';
    final ts = sp.getInt('$pk$_tsSuffix');
    if (ts == null) return null;

    final age = DateTime.now().millisecondsSinceEpoch - ts;
    if (age > ttl.inMilliseconds) {
      if (kDebugMode) debugPrint('[CpCache] $key expired (age=${age}ms)');
      return null;
    }
    return sp.getString(pk);
  }

  /// Lit une entrée même si expirée. Renvoie le couple (value, ageMs).
  Future<({String? value, int? ageMs})> getRaw(String key) async {
    final sp = await _sp();
    final pk = '$_prefix$key';
    final value = sp.getString(pk);
    final ts = sp.getInt('$pk$_tsSuffix');
    final age = ts == null
        ? null
        : DateTime.now().millisecondsSinceEpoch - ts;
    return (value: value, ageMs: age);
  }

  /// Supprime une entrée.
  Future<void> remove(String key) async {
    final sp = await _sp();
    final pk = '$_prefix$key';
    await sp.remove(pk);
    await sp.remove('$pk$_tsSuffix');
  }

  /// Supprime toutes les entrées du module Cas Pratique.
  Future<void> clearAll() async {
    final sp = await _sp();
    final keys = sp.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final k in keys) {
      await sp.remove(k);
    }
    if (kDebugMode) debugPrint('[CpCache] cleared ${keys.length} entries');
  }

  // ─── Helpers JSON typés ─────────────────────────────────────────────────

  /// Sauvegarde un Map ou une List sérialisable en JSON.
  Future<void> putJson(String key, Object value) async {
    await put(key, jsonEncode(value));
  }

  /// Lit et désérialise. Retourne null si manquant ou expiré.
  Future<Object?> getFreshJson(String key, {required Duration ttl}) async {
    final raw = await getFresh(key, ttl: ttl);
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } catch (e) {
      if (kDebugMode) debugPrint('[CpCache] $key decode error: $e');
      return null;
    }
  }

  // ─── Brouillons (drafts) — utilisés par auto-save ───────────────────────

  /// Sauvegarde locale immédiate d'un brouillon (avant sync Supabase).
  /// Utile en cas de crash : on retrouve la réponse au redémarrage.
  Future<void> saveDraft({
    required String attemptId,
    required String questionId,
    required String text,
  }) async {
    final key = 'draft.$attemptId.$questionId';
    await put(key, text);
  }

  Future<String?> readDraft({
    required String attemptId,
    required String questionId,
  }) async {
    final key = 'draft.$attemptId.$questionId';
    final r = await getRaw(key);
    return r.value;
  }

  Future<void> clearDraft({
    required String attemptId,
    required String questionId,
  }) async {
    await remove('draft.$attemptId.$questionId');
  }

  Future<void> clearDraftsForAttempt(String attemptId) async {
    final sp = await _sp();
    final prefix = '${_prefix}draft.$attemptId.';
    final keys = sp.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (final k in keys) {
      await sp.remove(k);
      await sp.remove('$k$_tsSuffix');
    }
  }
}
