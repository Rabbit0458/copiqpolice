// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Leaderboard service (gamification)            ║
// ║  Tâche      : CODE-059                                                  ║
// ║                                                                         ║
// ║  Consomme :                                                              ║
// ║   - fn_cp_get_leaderboard(p_limit) → top N anonymisés                   ║
// ║   - fn_cp_my_leaderboard_position()  → position de l'user courant       ║
// ║                                                                         ║
// ║  Modèles immutables :                                                   ║
// ║   - `LeaderboardEntry` (rank, anonHandle, weeklyXp, actionsCount,      ║
// ║     lastActionAt, isSelf)                                               ║
// ║   - `MyLeaderboardPosition` (inLeaderboard, rank?, weeklyXp?,           ║
// ║     anonHandle?, total, percentile?)                                    ║
// ║                                                                         ║
// ║  Cache mémoire 2 min (le matview est rafraîchi 1×/h donc surdimensionné║
// ║  pour l'UX).                                                            ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardEntry {
  final int rank;
  final String anonHandle;
  final int weeklyXp;
  final int actionsCount;
  final DateTime? lastActionAt;
  final bool isSelf;

  const LeaderboardEntry({
    required this.rank,
    required this.anonHandle,
    required this.weeklyXp,
    required this.actionsCount,
    required this.lastActionAt,
    required this.isSelf,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> j) => LeaderboardEntry(
        rank: (j['rank'] is num) ? (j['rank'] as num).toInt() : 0,
        anonHandle: (j['anon_handle'] ?? '') as String,
        weeklyXp: (j['weekly_xp'] is num) ? (j['weekly_xp'] as num).toInt() : 0,
        actionsCount: (j['actions_count'] is num)
            ? (j['actions_count'] as num).toInt()
            : 0,
        lastActionAt: j['last_action_at'] == null
            ? null
            : DateTime.tryParse(j['last_action_at'].toString())?.toUtc(),
        isSelf: j['is_self'] == true,
      );
}

class MyLeaderboardPosition {
  final bool inLeaderboard;
  final int? rank;
  final int? weeklyXp;
  final int? actionsCount;
  final String? anonHandle;
  final int total;
  final double? percentile;

  const MyLeaderboardPosition({
    required this.inLeaderboard,
    required this.rank,
    required this.weeklyXp,
    required this.actionsCount,
    required this.anonHandle,
    required this.total,
    required this.percentile,
  });

  static const MyLeaderboardPosition outside = MyLeaderboardPosition(
    inLeaderboard: false,
    rank: null,
    weeklyXp: null,
    actionsCount: null,
    anonHandle: null,
    total: 0,
    percentile: null,
  );

  factory MyLeaderboardPosition.fromJson(Map<String, dynamic> j) =>
      MyLeaderboardPosition(
        inLeaderboard: j['in_leaderboard'] == true,
        rank: (j['rank'] is num) ? (j['rank'] as num).toInt() : null,
        weeklyXp:
            (j['weekly_xp'] is num) ? (j['weekly_xp'] as num).toInt() : null,
        actionsCount: (j['actions_count'] is num)
            ? (j['actions_count'] as num).toInt()
            : null,
        anonHandle: j['anon_handle'] as String?,
        total: (j['total'] is num) ? (j['total'] as num).toInt() : 0,
        percentile: (j['percentile'] is num)
            ? (j['percentile'] as num).toDouble()
            : null,
      );
}

class LeaderboardService {
  LeaderboardService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final LeaderboardService instance = LeaderboardService._();

  final SupabaseClient _sb;

  List<LeaderboardEntry>? _cachedTop;
  MyLeaderboardPosition? _cachedMe;
  DateTime? _cachedAt;
  static const Duration _kCacheTtl = Duration(minutes: 2);

  Future<List<LeaderboardEntry>> getTop({
    int limit = 100,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedTop != null && _cachedAt != null) {
      if (DateTime.now().difference(_cachedAt!) < _kCacheTtl) {
        return _cachedTop!;
      }
    }
    try {
      final raw = await _sb.rpc(
        'fn_cp_get_leaderboard',
        params: {'p_limit': limit},
      );
      if (raw is! List) return const [];
      final list = raw
          .whereType<Map<String, dynamic>>()
          .map(LeaderboardEntry.fromJson)
          .toList(growable: false);
      _cachedTop = list;
      _cachedAt = DateTime.now();
      return list;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[LeaderboardService] getTop failed: $e');
      }
      return _cachedTop ?? const [];
    }
  }

  Future<MyLeaderboardPosition> getMyPosition({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedMe != null && _cachedAt != null) {
      if (DateTime.now().difference(_cachedAt!) < _kCacheTtl) {
        return _cachedMe!;
      }
    }
    try {
      final raw = await _sb.rpc('fn_cp_my_leaderboard_position');
      Map<String, dynamic> data;
      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is Map) {
        data = Map<String, dynamic>.from(raw);
      } else {
        data = const {};
      }
      if (data['error'] != null) return MyLeaderboardPosition.outside;
      final me = MyLeaderboardPosition.fromJson(data);
      _cachedMe = me;
      _cachedAt = DateTime.now();
      return me;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[LeaderboardService] getMyPosition failed: $e');
      }
      return _cachedMe ?? MyLeaderboardPosition.outside;
    }
  }

  Future<void> refresh() async {
    _cachedTop = null;
    _cachedMe = null;
    _cachedAt = null;
    await Future.wait([
      getTop(forceRefresh: true),
      getMyPosition(forceRefresh: true),
    ]);
  }

  void invalidate() {
    _cachedAt = null;
  }
}
