// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : QuestionScorer + AttemptScorer        ║
// ║  CODE-049                                                               ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/keyword_matcher.dart';
import 'package:copiqpolice/core/cas_pratique/engine/point_evaluator.dart';
import 'package:copiqpolice/core/cas_pratique/engine/scorer.dart';
import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';

EngineKeyword _kw(String v) => EngineKeyword(
      value: v,
      synDictId: null,
      isPhrase: false,
      isNegation: false,
      fuzzyMaxDist: 1,
    );

EngineKeywordGroup _g(int pos, List<String> values) => EngineKeywordGroup(
      id: 'g$pos',
      position: pos,
      description: null,
      isOptional: false,
      keywords: values.map(_kw).toList(),
    );

EngineRubricPoint _point(String id, double w) => EngineRubricPoint(
      id: id,
      position: 1,
      label: 'Point $id',
      weight: w,
      isRequired: true,
      kind: 'core',
      explanationMd: null,
    );

void main() {
  group('QuestionScorer', () {
    const scorer = QuestionScorer();
    final matcher = KeywordMatcher();

    test('réponse parfaite → score = maxPoints', () {
      final input = QuestionScoringInput(
        questionId: 'q1',
        maxPoints: 5,
        userAnswer: 'degradation et vandalisme du bien d autrui',
        rubricPoints: [
          _point('p1', 1.0),
          _point('p2', 1.0),
        ],
        groupsByPoint: {
          'p1': [_g(1, ['degradation'])],
          'p2': [_g(1, ['autrui'])],
        },
      );
      final r = scorer.score(input, matcher);
      expect(r.score, equals(5.0));
      expect(r.percent, equals(100.0));
      expect(r.points, hasLength(2));
    });

    test('réponse vide → score = 0', () {
      final input = QuestionScoringInput(
        questionId: 'q1',
        maxPoints: 5,
        userAnswer: '',
        rubricPoints: [_point('p1', 1.0)],
        groupsByPoint: {
          'p1': [_g(1, ['degradation'])],
        },
      );
      final r = scorer.score(input, matcher);
      expect(r.score, equals(0.0));
      expect(r.percent, equals(0.0));
    });

    test('score normalisé sur maxPoints', () {
      // 1 point sur 2 → 50% → 2.5/5
      final input = QuestionScoringInput(
        questionId: 'q1',
        maxPoints: 5,
        userAnswer: 'degradation seulement',
        rubricPoints: [
          _point('p1', 1.0),
          _point('p2', 1.0),
        ],
        groupsByPoint: {
          'p1': [_g(1, ['degradation'])],
          'p2': [_g(1, ['nimporte'])],
        },
      );
      final r = scorer.score(input, matcher);
      expect(r.score, closeTo(2.5, 0.001));
      expect(r.percent, closeTo(50.0, 0.001));
    });
  });

  group('AttemptScorer', () {
    final attemptScorer = AttemptScorer();

    test('agrège plusieurs questions', () {
      final input = AttemptScoringInput(
        answersByQuestionId: {
          'q1': 'degradation du bien',
          'q2': 'plainte deposee',
        },
        questions: [
          QuestionScoringSpec(
            questionId: 'q1',
            maxPoints: 5,
            rubricPoints: [_point('p1', 1.0)],
            groupsByPoint: {
              'p1': [_g(1, ['degradation'])],
            },
          ),
          QuestionScoringSpec(
            questionId: 'q2',
            maxPoints: 5,
            rubricPoints: [_point('p2', 1.0)],
            groupsByPoint: {
              'p2': [_g(1, ['plainte'])],
            },
          ),
        ],
      );
      final r = attemptScorer.score(input);
      expect(r.questionResults, hasLength(2));
      expect(r.totalScore, equals(10.0));
      expect(r.totalMax, equals(10.0));
      expect(r.percent, equals(100.0));
    });

    test('question manquante dans answers → score 0 sur cette question', () {
      final input = AttemptScoringInput(
        answersByQuestionId: {'q1': 'degradation'},
        questions: [
          QuestionScoringSpec(
            questionId: 'q1',
            maxPoints: 5,
            rubricPoints: [_point('p1', 1.0)],
            groupsByPoint: {
              'p1': [_g(1, ['degradation'])],
            },
          ),
          QuestionScoringSpec(
            questionId: 'q2',
            maxPoints: 5,
            rubricPoints: [_point('p2', 1.0)],
            groupsByPoint: {
              'p2': [_g(1, ['plainte'])],
            },
          ),
        ],
      );
      final r = attemptScorer.score(input);
      expect(r.totalScore, equals(5.0));
      expect(r.totalMax, equals(10.0));
      expect(r.percent, equals(50.0));
    });
  });
}
