// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — XP service (gamification)                     ║
// ║  Tâche      : CODE-057                                                  ║
// ║                                                                         ║
// ║  Consomme la fonction Postgres `fn_cp_xp_total(uuid)` créée par la     ║
// ║  migration 20260518000003 et expose un modèle Dart immutable           ║
// ║  `XpStatus` :                                                           ║
// ║   - totalXp / level / levelName                                         ║
// ║   - xpIntoLevel / xpToNextLevel / levelProgressPercent                  ║
// ║   - leveledUpFromPrevious(prev) : helper bool                           ║
// ║                                                                         ║
// ║  Le service expose aussi un Stream<XpStatus> qui se met à jour à       ║
// ║  chaque appel `refresh()` — utile pour brancher un widget réactif      ║
// ║  qui célèbre les level-ups.                                             ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Échelle de niveaux (synchro avec la fonction SQL — single source of truth).
class LevelSpec {
  final int level;
  final String name;
  final int threshold;
  final int nextThreshold;

  const LevelSpec({
    required this.level,
    required this.name,
    required this.threshold,
    required this.nextThreshold,
  });
}

const List<LevelSpec> kXpLevels = [
  LevelSpec(level: 1,  name: 'Recrue',          threshold: 0,     nextThreshold: 100),
  LevelSpec(level: 2,  name: 'Apprenti',        threshold: 100,   nextThreshold: 250),
  LevelSpec(level: 3,  name: 'Cadet',           threshold: 250,   nextThreshold: 500),
  LevelSpec(level: 4,  name: 'Gardien',         threshold: 500,   nextThreshold: 1000),
  LevelSpec(level: 5,  name: 'Brigadier',       threshold: 1000,  nextThreshold: 2000),
  LevelSpec(level: 6,  name: 'Lieutenant',      threshold: 2000,  nextThreshold: 4000),
  LevelSpec(level: 7,  name: 'Capitaine',       threshold: 4000,  nextThreshold: 8000),
  LevelSpec(level: 8,  name: 'Commandant',      threshold: 8000,  nextThreshold: 16000),
  LevelSpec(level: 9,  name: 'Commissaire',     threshold: 16000, nextThreshold: 32000),
  LevelSpec(level: 10, name: "Légende COP'IQ",  threshold: 32000, nextThreshold: 2147483647),
];

/// Snapshot immutable du statut XP.
class XpStatus {
  final int totalXp;
  final int level;
  final String levelName;
  final int xpIntoLevel;
  final int xpToNextLevel;
  final double levelProgressPercent;

  const XpStatus({
    required this.totalXp,
    required this.level,
    required this.levelName,
    required this.xpIntoLevel,
    required this.xpToNextLevel,
    required this.levelProgressPercent,
  });

  static const XpStatus empty = XpStatus(
    totalXp: 0,
    level: 1,
    levelName: 'Recrue',
    xpIntoLevel: 0,
    xpToNextLevel: 100,
    levelProgressPercent: 0,
  );

  bool get isMaxLevel => level >= kXpLevels.last.level;

  /// True si ce status représente un level-up strict par rapport à `prev`.
  bool leveledUpFromPrevious(XpStatus prev) => level > prev.level;

  /// Étape suivante (null si max).
  LevelSpec? get nextLevelSpec {
    final next = level + 1;
    for (final spec in kXpLevels) {
      if (spec.level == next) return spec;
    }
    return null;
  }

  factory XpStatus.fromJson(Map<String, dynamic> j) => XpStatus(
        totalXp: (j['total_xp'] is num) ? (j['total_xp'] as num).toInt() : 0,
        level: (j['level'] is num) ? (j['level'] as num).toInt() : 1,
        levelName: (j['level_name'] ?? 'Recrue').toString(),
        xpIntoLevel:
            (j['xp_into_level'] is num) ? (j['xp_into_level'] as num).toInt() : 0,
        xpToNextLevel: (j['xp_to_next_level'] is num)
            ? (j['xp_to_next_level'] as num).toInt()
            : 0,
        levelProgressPercent: (j['level_progress_percent'] is num)
            ? (j['level_progress_percent'] as num).toDouble()
            : 0.0,
      );

  Map<String, dynamic> toJson() => {
        'total_xp': totalXp,
        'level': level,
        'level_name': levelName,
        'xp_into_level': xpIntoLevel,
        'xp_to_next_level': xpToNextLevel,
        'level_progress_percent': levelProgressPercent,
      };

  @override
  String toString() =>
      'XpStatus(level=$level $levelName, xp=$totalXp, '
      'progress=${levelProgressPercent.toStringAsFixed(1)}%)';
}

/// Service singleton pour récupérer le statut XP et observer les changements.
class XpService {
  XpService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final XpService instance = XpService._();

  final SupabaseClient _sb;
  final StreamController<XpStatus> _controller =
      StreamController<XpStatus>.broadcast();

  XpStatus _last = XpStatus.empty;
  DateTime? _lastFetchedAt;
  static const Duration _kCacheTtl = Duration(minutes: 2);

  /// Stream des changements de status. Émet à chaque `refresh()` réussi.
  Stream<XpStatus> get changes => _controller.stream;

  /// Dernier status connu (cache mémoire — pas de RPC).
  XpStatus get current => _last;

  /// Récupère le status. Si `forceRefresh` est false et le cache frais → no-op réseau.
  Future<XpStatus> getStatus({bool forceRefresh = false}) async {
    if (!forceRefresh && _lastFetchedAt != null) {
      if (DateTime.now().difference(_lastFetchedAt!) < _kCacheTtl) {
        return _last;
      }
    }
    final userId = _sb.auth.currentUser?.id;
    if (userId == null) {
      _last = XpStatus.empty;
      return _last;
    }
    try {
      final raw = await _sb.rpc(
        'fn_cp_xp_total',
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
      final next = XpStatus.fromJson(data);
      final previous = _last;
      _last = next;
      _lastFetchedAt = DateTime.now();
      // Émet uniquement si vraiment changé (évite les rebuilds inutiles)
      if (next.totalXp != previous.totalXp || next.level != previous.level) {
        _controller.add(next);
      }
      return next;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[XpService] getStatus failed: $e');
      }
      return _last;
    }
  }

  /// Invalide le cache (à appeler après une correction validée).
  void invalidate() {
    _lastFetchedAt = null;
  }

  /// Force le re-fetch + émet sur le stream.
  Future<XpStatus> refresh() => getStatus(forceRefresh: true);

  /// Disposal — à appeler depuis main() ou en tearDown des tests.
  Future<void> dispose() async {
    await _controller.close();
  }
}
