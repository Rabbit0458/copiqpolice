// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Streaks service (gamification)                ║
// ║  Tâche      : CODE-056                                                  ║
// ║                                                                         ║
// ║  Consomme la fonction Postgres `fn_cp_compute_streak(uuid)` créée par  ║
// ║  la migration 20260518000002 et expose un modèle Dart immutable        ║
// ║  `StreakStatus` :                                                       ║
// ║   - `count`                : nombre de jours consécutifs                ║
// ║   - `isActive`             : count > 0                                   ║
// ║   - `isAtRisk`             : flag "tu vas perdre ton streak"            ║
// ║   - `lastActivityAt`       : dernier jour d'activité (UTC)              ║
// ║   - `brokenAt`             : non-null si le streak est cassé            ║
// ║   - `availableFreezes`     : nb de jokers restants                      ║
// ║   - `daysToNextMilestone`  : helper UI (3/7/14/30/100/365)              ║
// ║   - `nextMilestone`        : valeur de la prochaine étape               ║
// ║                                                                         ║
// ║  Usage :                                                                ║
// ║    final status = await StreaksService.instance.getStatus();           ║
// ║    if (status.isAtRisk) showWidget(...);                                ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Milestones gamification (utilisé pour l'UI : badges, célébrations).
const List<int> kStreakMilestones = [3, 7, 14, 30, 60, 100, 200, 365];

/// État immutable du streak.
class StreakStatus {
  final int count;
  final bool isAtRisk;
  final DateTime? lastActivityAt;
  final DateTime? brokenAt;
  final int availableFreezes;

  const StreakStatus({
    required this.count,
    required this.isAtRisk,
    required this.lastActivityAt,
    required this.brokenAt,
    required this.availableFreezes,
  });

  /// Streak vide (jamais commencé, ou cassé).
  static const StreakStatus empty = StreakStatus(
    count: 0,
    isAtRisk: false,
    lastActivityAt: null,
    brokenAt: null,
    availableFreezes: 0,
  );

  bool get isActive => count > 0;
  bool get isBroken => brokenAt != null;

  /// Prochain milestone strictement supérieur au count actuel (null si max atteint).
  int? get nextMilestone {
    for (final m in kStreakMilestones) {
      if (m > count) return m;
    }
    return null;
  }

  /// Jours restants pour atteindre le prochain milestone.
  int? get daysToNextMilestone {
    final m = nextMilestone;
    if (m == null) return null;
    return (m - count).clamp(0, m);
  }

  /// Texte d'encouragement adapté au statut (FR).
  String motivationLabel() {
    if (!isActive) {
      return 'Démarre ton streak en validant un cas aujourd\'hui.';
    }
    if (isAtRisk) {
      return 'Préserve ton streak de $count jour${count > 1 ? 's' : ''} : '
          'fais un cas avant la fin de la journée.';
    }
    final next = nextMilestone;
    if (next == null) {
      return 'Bravo, tu enchaînes les jours sans interruption !';
    }
    final remaining = daysToNextMilestone ?? 0;
    if (remaining == 0) {
      return 'Tu viens d\'atteindre le palier de $next jours 🎉';
    }
    return 'Plus que $remaining jour${remaining > 1 ? 's' : ''} '
        'avant le palier de $next.';
  }

  factory StreakStatus.fromJson(Map<String, dynamic> j) {
    DateTime? parseDay(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.tryParse(v.toString())?.toUtc();
      } catch (_) {
        return null;
      }
    }

    return StreakStatus(
      count: (j['count'] is num) ? (j['count'] as num).toInt() : 0,
      isAtRisk: j['is_at_risk'] == true,
      lastActivityAt: parseDay(j['last_activity_at']),
      brokenAt: parseDay(j['broken_at']),
      availableFreezes: (j['available_freezes'] is num)
          ? (j['available_freezes'] as num).toInt()
          : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'is_at_risk': isAtRisk,
        'last_activity_at': lastActivityAt?.toIso8601String(),
        'broken_at': brokenAt?.toIso8601String(),
        'available_freezes': availableFreezes,
      };

  @override
  String toString() =>
      'StreakStatus(count: $count, isAtRisk: $isAtRisk, '
      'lastActivityAt: $lastActivityAt, brokenAt: $brokenAt, '
      'availableFreezes: $availableFreezes)';
}

/// Service singleton pour récupérer / observer le streak de l'utilisateur courant.
class StreaksService {
  StreaksService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final StreaksService instance = StreaksService._();

  final SupabaseClient _sb;

  /// Cache mémoire pour limiter les RPC pendant une session.
  StreakStatus? _cached;
  DateTime? _cachedAt;
  static const Duration _kCacheTtl = Duration(minutes: 2);

  /// Récupère le streak en appelant `fn_cp_compute_streak` côté Postgres.
  /// Si `forceRefresh` est false et que le cache est frais → retourne le cache.
  Future<StreakStatus> getStatus({bool forceRefresh = false}) async {
    if (!forceRefresh && _cached != null && _cachedAt != null) {
      if (DateTime.now().difference(_cachedAt!) < _kCacheTtl) {
        return _cached!;
      }
    }
    final userId = _sb.auth.currentUser?.id;
    if (userId == null) {
      return StreakStatus.empty;
    }
    try {
      final raw = await _sb.rpc(
        'fn_cp_compute_streak',
        params: {'p_user_id': userId},
      );
      Map<String, dynamic> data;
      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is Map) {
        data = Map<String, dynamic>.from(raw);
      } else {
        data = const {};
      }
      final status = StreakStatus.fromJson(data);
      _cached = status;
      _cachedAt = DateTime.now();
      return status;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[StreaksService] getStatus failed: $e');
      }
      return _cached ?? StreakStatus.empty;
    }
  }

  /// Invalide le cache. À appeler après une validation de cas
  /// (la valeur en DB sera fraîche grâce au trigger).
  void invalidate() {
    _cached = null;
    _cachedAt = null;
  }

  /// Force une recompute côté DB. À appeler depuis l'écran de profil par ex.
  Future<StreakStatus> forceRecompute() => getStatus(forceRefresh: true);
}
