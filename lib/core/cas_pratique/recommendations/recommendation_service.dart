// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Recommendation service                        ║
// ║  Tâche      : CODE-062                                                  ║
// ║                                                                         ║
// ║  Consomme `fn_cp_recommend_next_cases(p_user_id, p_n)` créée par la    ║
// ║  migration 20260518000008. Retourne une liste de `RecommendedCase`    ║
// ║  avec la raison (`reason`) qui motive la suggestion.                  ║
// ║                                                                         ║
// ║  `reason` ∈ {                                                            ║
// ║    'weakest_theme_new'     : thème faible, jamais fait                  ║
// ║    'weakest_theme_replay'  : thème faible, à rejouer (score < 50%)     ║
// ║    'fresh'                 : cas récent / newcomer                      ║
// ║  }                                                                       ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum RecommendationReason {
  weakestThemeNew,
  weakestThemeReplay,
  fresh,
  unknown,
}

extension RecommendationReasonX on RecommendationReason {
  /// Texte FR court pour l'UI (chip / label).
  String get label {
    switch (this) {
      case RecommendationReason.weakestThemeNew:
        return 'Ton thème à travailler';
      case RecommendationReason.weakestThemeReplay:
        return 'À retenter';
      case RecommendationReason.fresh:
        return 'Recommandé';
      case RecommendationReason.unknown:
        return 'Suggéré';
    }
  }

  /// Phrase explicative plus longue.
  String get motivation {
    switch (this) {
      case RecommendationReason.weakestThemeNew:
        return 'Ce thème est celui où ta moyenne est la plus basse.';
      case RecommendationReason.weakestThemeReplay:
        return 'Tu peux remonter ton score sur ce cas.';
      case RecommendationReason.fresh:
        return 'Une nouveauté qui correspond à ton niveau.';
      case RecommendationReason.unknown:
        return '';
    }
  }
}

class RecommendedCase {
  final String caseId;
  final String slug;
  final String title;
  final String? themeId;
  final String? themeSlug;
  final int year;
  final String? month;
  final String difficulty;
  final int estimatedMinutes;
  final int totalPoints;
  final RecommendationReason reason;
  final double priorityScore;

  const RecommendedCase({
    required this.caseId,
    required this.slug,
    required this.title,
    required this.themeId,
    required this.themeSlug,
    required this.year,
    required this.month,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.totalPoints,
    required this.reason,
    required this.priorityScore,
  });

  factory RecommendedCase.fromJson(Map<String, dynamic> j) {
    RecommendationReason parseReason(String? s) {
      switch (s) {
        case 'weakest_theme_new':    return RecommendationReason.weakestThemeNew;
        case 'weakest_theme_replay': return RecommendationReason.weakestThemeReplay;
        case 'fresh':                return RecommendationReason.fresh;
        default:                     return RecommendationReason.unknown;
      }
    }

    return RecommendedCase(
      caseId: (j['case_id'] ?? '') as String,
      slug: (j['slug'] ?? '') as String,
      title: (j['title'] ?? '') as String,
      themeId: j['theme_id'] as String?,
      themeSlug: j['theme_slug'] as String?,
      year: (j['year'] is num) ? (j['year'] as num).toInt() : 0,
      month: j['month'] as String?,
      difficulty: (j['difficulty'] ?? 'moyen') as String,
      estimatedMinutes: (j['estimated_minutes'] is num)
          ? (j['estimated_minutes'] as num).toInt()
          : 15,
      totalPoints: (j['total_points'] is num)
          ? (j['total_points'] as num).toInt()
          : 15,
      reason: parseReason(j['reason'] as String?),
      priorityScore: (j['priority_score'] is num)
          ? (j['priority_score'] as num).toDouble()
          : 0.0,
    );
  }
}

class RecommendationService {
  RecommendationService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final RecommendationService instance = RecommendationService._();

  final SupabaseClient _sb;

  /// Cache mémoire 5 min (la recommandation peut être un peu stale sans souci UX).
  List<RecommendedCase>? _cached;
  DateTime? _cachedAt;
  static const Duration _kCacheTtl = Duration(minutes: 5);

  Future<List<RecommendedCase>> getNext({
    int n = 3,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cached != null && _cachedAt != null) {
      if (DateTime.now().difference(_cachedAt!) < _kCacheTtl) {
        return _cached!;
      }
    }
    try {
      final raw = await _sb.rpc(
        'fn_cp_recommend_next_cases',
        params: {'p_n': n},
      );
      if (raw is! List) return const [];
      final list = raw
          .whereType<Map<String, dynamic>>()
          .map(RecommendedCase.fromJson)
          .toList(growable: false);
      _cached = list;
      _cachedAt = DateTime.now();
      return list;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RecommendationService] getNext failed: $e');
      }
      return _cached ?? const [];
    }
  }

  void invalidate() {
    _cachedAt = null;
  }
}
