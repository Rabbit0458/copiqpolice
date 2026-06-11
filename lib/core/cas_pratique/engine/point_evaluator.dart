// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Point Evaluator                      ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.6)     ║
// ║  Tâche      : CODE-026                                                  ║
// ║                                                                         ║
// ║  Logique :                                                              ║
// ║    - ENTRE groupes  = ET (tous doivent matcher pour avoir "covered")    ║
// ║    - INTRA groupe   = OR (un seul keyword suffit à valider le groupe)   ║
// ║    - Groupes is_optional → ne comptent pas dans le ratio "required"    ║
// ║                                                                         ║
// ║  Classification finale :                                                ║
// ║    - 100% groupes required matchés  → covered  (score = weight)         ║
// ║    -  ≥50% groupes required matchés → partial  (score = weight × 0.5)   ║
// ║    -  sinon                          → missing  (score = 0)             ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:copiqpolice/core/cas_pratique/engine/keyword_matcher.dart';
import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';

/// Modèle moteur d'un point de rubric.
class EngineRubricPoint {
  final String id;
  final int position;
  final String label;
  final double weight;
  final bool isRequired;
  final String kind; // 'core' | 'bonus'
  final String? explanationMd;

  const EngineRubricPoint({
    required this.id,
    required this.position,
    required this.label,
    required this.weight,
    required this.isRequired,
    required this.kind,
    required this.explanationMd,
  });

  factory EngineRubricPoint.fromJson(Map<String, dynamic> j) => EngineRubricPoint(
        id: j['id'] as String,
        position: (j['position'] as int?) ?? 0,
        label: j['label'] as String,
        weight: (j['weight'] is num) ? (j['weight'] as num).toDouble() : 1.0,
        isRequired: (j['is_required'] as bool?) ?? true,
        kind: (j['kind'] as String?) ?? 'core',
        explanationMd: j['explanation_md'] as String?,
      );
}

/// Modèle moteur d'un groupe de keywords.
class EngineKeywordGroup {
  final String id;
  final int position;
  final String? description;
  final bool isOptional;
  final List<EngineKeyword> keywords;

  const EngineKeywordGroup({
    required this.id,
    required this.position,
    required this.description,
    required this.isOptional,
    required this.keywords,
  });

  factory EngineKeywordGroup.fromJson(Map<String, dynamic> j) => EngineKeywordGroup(
        id: j['id'] as String,
        position: (j['position'] as int?) ?? 0,
        description: j['description'] as String?,
        isOptional: (j['is_optional'] as bool?) ?? false,
        keywords: ((j['keywords'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(EngineKeyword.fromJson)
            .toList(growable: false),
      );
}

/// État de matching d'un groupe (debug + UI).
class GroupMatchResult {
  final String groupId;
  final bool isOptional;
  final bool matched;
  final List<String> matchedKeywords;

  const GroupMatchResult({
    required this.groupId,
    required this.isOptional,
    required this.matched,
    required this.matchedKeywords,
  });

  Map<String, dynamic> toJson() => {
        'group_id': groupId,
        'is_optional': isOptional,
        'matched': matched,
        'matched_keywords': matchedKeywords,
      };
}

/// Statut final d'un point.
enum PointStatus { covered, partial, missing }

String pointStatusToString(PointStatus s) => switch (s) {
      PointStatus.covered => 'covered',
      PointStatus.partial => 'partial',
      PointStatus.missing => 'missing',
    };

/// Résultat d'évaluation d'un point.
class PointEvalResult {
  final String pointId;
  final PointStatus status;
  final double score;
  final double weight;
  final List<GroupMatchResult> groupResults;

  const PointEvalResult({
    required this.pointId,
    required this.status,
    required this.score,
    required this.weight,
    required this.groupResults,
  });

  Map<String, dynamic> toDetailJson() => {
        'point_id': pointId,
        'status': pointStatusToString(status),
        'score': score,
        'weight': weight,
        'group_matches': groupResults.map((g) => g.toJson()).toList(),
      };
}

/// Évalue un point en combinant tous ses groupes.
class PointEvaluator {
  const PointEvaluator({this.partialThreshold = 0.5});

  /// Ratio minimum de groupes required matchés pour atteindre "partial".
  /// Au-delà de 1.0 = covered.
  final double partialThreshold;

  PointEvalResult evaluate({
    required EngineRubricPoint point,
    required List<EngineKeywordGroup> groups,
    required KeywordMatchContext ctx,
    required KeywordMatcher matcher,
  }) {
    if (groups.isEmpty) {
      return PointEvalResult(
        pointId: point.id,
        status: PointStatus.missing,
        score: 0.0,
        weight: point.weight,
        groupResults: const [],
      );
    }

    int requiredCount = 0;
    int requiredHits = 0;
    final groupResults = <GroupMatchResult>[];

    for (final g in groups) {
      final matchedKeywords = <String>[];
      var groupMatched = false;

      for (final kw in g.keywords) {
        final info = matcher.matchInfo(kw, ctx);
        if (info.matched) {
          matchedKeywords.add(info.matchedAgainst ?? kw.value ?? '?');
          groupMatched = true;
          // OR : un seul keyword suffit, on s'arrête
          break;
        }
      }

      if (!g.isOptional) {
        requiredCount++;
        if (groupMatched) requiredHits++;
      }

      groupResults.add(GroupMatchResult(
        groupId: g.id,
        isOptional: g.isOptional,
        matched: groupMatched,
        matchedKeywords: matchedKeywords,
      ));
    }

    final ratio = requiredCount == 0 ? 1.0 : (requiredHits / requiredCount);

    final PointStatus status;
    final double scoreFactor;
    if (ratio >= 1.0) {
      status = PointStatus.covered;
      scoreFactor = 1.0;
    } else if (ratio >= partialThreshold) {
      status = PointStatus.partial;
      scoreFactor = 0.5;
    } else {
      status = PointStatus.missing;
      scoreFactor = 0.0;
    }

    return PointEvalResult(
      pointId: point.id,
      status: status,
      score: point.weight * scoreFactor,
      weight: point.weight,
      groupResults: groupResults,
    );
  }
}
