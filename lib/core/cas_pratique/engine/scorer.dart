// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Question Scorer + Attempt Scorer     ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.7, 2.8)║
// ║  Tâche      : CODE-027                                                  ║
// ║                                                                         ║
// ║  Question scorer : somme pondérée des points → score normalisé à       ║
// ║                    max_points (typiquement 5)                           ║
// ║  Attempt scorer  : somme des questions → score total /15                ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:copiqpolice/core/cas_pratique/engine/keyword_matcher.dart';
import 'package:copiqpolice/core/cas_pratique/engine/point_evaluator.dart';

/// Résultat de scoring d'une question.
class QuestionScoreResult {
  final String questionId;
  final double score;        // 0..maxPoints
  final double maxPoints;
  final double percent;      // 0..100
  final List<PointEvalResult> points;

  const QuestionScoreResult({
    required this.questionId,
    required this.score,
    required this.maxPoints,
    required this.percent,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'score': score,
        'max_points': maxPoints,
        'percent': percent,
        'points': points.map((p) => p.toDetailJson()).toList(),
      };
}

/// Données d'entrée pour scorer une question.
class QuestionScoringInput {
  final String questionId;
  final int maxPoints;
  final String userAnswer;
  final List<EngineRubricPoint> rubricPoints;
  /// Mapping point_id → liste de groupes ordonnés
  final Map<String, List<EngineKeywordGroup>> groupsByPoint;

  const QuestionScoringInput({
    required this.questionId,
    required this.maxPoints,
    required this.userAnswer,
    required this.rubricPoints,
    required this.groupsByPoint,
  });
}

/// Scorer pour une question.
class QuestionScorer {
  const QuestionScorer({this.evaluator = const PointEvaluator()});

  final PointEvaluator evaluator;

  QuestionScoreResult score(QuestionScoringInput input, KeywordMatcher matcher) {
    final ctx = KeywordMatchContext.build(input.userAnswer);
    final pointResults = <PointEvalResult>[];

    double rawScore = 0.0;
    double maxPossible = 0.0;

    for (final p in input.rubricPoints) {
      final groups = input.groupsByPoint[p.id] ?? const <EngineKeywordGroup>[];
      final r = evaluator.evaluate(
        point: p,
        groups: groups,
        ctx: ctx,
        matcher: matcher,
      );
      pointResults.add(r);
      rawScore += r.score;
      maxPossible += r.weight;
    }

    // Normalisation au max_points cible (5 par défaut)
    final normalized = maxPossible == 0
        ? 0.0
        : (rawScore / maxPossible) * input.maxPoints;
    final clamped = normalized.clamp(0.0, input.maxPoints.toDouble());
    final percent = input.maxPoints == 0 ? 0.0 : (clamped / input.maxPoints) * 100.0;

    return QuestionScoreResult(
      questionId: input.questionId,
      score: clamped.toDouble(),
      maxPoints: input.maxPoints.toDouble(),
      percent: percent,
      points: pointResults,
    );
  }
}

/// Données d'entrée pour scorer une tentative complète.
class AttemptScoringInput {
  /// Réponses utilisateur par question_id
  final Map<String, String> answersByQuestionId;
  /// Données scoring de chaque question (sans userAnswer — pris depuis answersByQuestionId)
  final List<QuestionScoringSpec> questions;

  const AttemptScoringInput({
    required this.answersByQuestionId,
    required this.questions,
  });
}

class QuestionScoringSpec {
  final String questionId;
  final int maxPoints;
  final List<EngineRubricPoint> rubricPoints;
  final Map<String, List<EngineKeywordGroup>> groupsByPoint;

  const QuestionScoringSpec({
    required this.questionId,
    required this.maxPoints,
    required this.rubricPoints,
    required this.groupsByPoint,
  });
}

/// Résultat de scoring d'une tentative complète.
class AttemptScoreResult {
  final double totalScore;
  final double totalMax;
  final double percent;
  final List<QuestionScoreResult> questionResults;

  const AttemptScoreResult({
    required this.totalScore,
    required this.totalMax,
    required this.percent,
    required this.questionResults,
  });

  Map<String, dynamic> toJson() => {
        'total_score': totalScore,
        'total_max': totalMax,
        'percent': percent,
        'questions': questionResults.map((q) => q.toJson()).toList(),
      };
}

/// Scorer pour une tentative complète (orchestre les questions).
class AttemptScorer {
  AttemptScorer({QuestionScorer? questionScorer, KeywordMatcher? matcher})
      : _qs = questionScorer ?? const QuestionScorer(),
        _matcher = matcher ?? KeywordMatcher();

  final QuestionScorer _qs;
  final KeywordMatcher _matcher;

  AttemptScoreResult score(AttemptScoringInput input) {
    final results = <QuestionScoreResult>[];
    double total = 0.0;
    double max = 0.0;

    for (final qs in input.questions) {
      final userAnswer = input.answersByQuestionId[qs.questionId] ?? '';
      final r = _qs.score(
        QuestionScoringInput(
          questionId: qs.questionId,
          maxPoints: qs.maxPoints,
          userAnswer: userAnswer,
          rubricPoints: qs.rubricPoints,
          groupsByPoint: qs.groupsByPoint,
        ),
        _matcher,
      );
      results.add(r);
      total += r.score;
      max += r.maxPoints;
    }

    final percent = max == 0 ? 0.0 : (total / max) * 100.0;

    return AttemptScoreResult(
      totalScore: total,
      totalMax: max,
      percent: percent,
      questionResults: results,
    );
  }
}
