// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Parity test : Dart engine ↔ fixtures expected ║
// ║  Tâche      : CODE-052                                                  ║
// ║                                                                         ║
// ║  Lance le moteur Dart sur les mêmes fixtures que                       ║
// ║  `tests/parity/dart_vs_ts.test.ts` et vérifie que `total_score`,        ║
// ║  `total_max`, `percent` correspondent au `expected` figé.              ║
// ║                                                                         ║
// ║  Si CE test passe ET que le test TS passe → parité Dart↔TS garantie    ║
// ║  à 0.01 près (les deux engines produisent les mêmes scores sur les     ║
// ║  fixtures partagées).                                                   ║
// ║                                                                         ║
// ║  Run :                                                                  ║
// ║    flutter test test/cas_pratique/parity_test.dart                      ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/keyword_matcher.dart';
import 'package:copiqpolice/core/cas_pratique/engine/point_evaluator.dart';
import 'package:copiqpolice/core/cas_pratique/engine/scorer.dart';
import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';

const String _fixturesDir = 'tests/parity/fixtures';
const List<String> _fixtureNames = [
  'scenario_1_perfect',
  'scenario_2_partial',
  'scenario_3_missing',
  'scenario_4_fuzzy_phrase_multi',
];

Map<String, dynamic> _loadFixture(String name) {
  final file = File('$_fixturesDir/$name.json');
  if (!file.existsSync()) {
    throw StateError('Fixture introuvable : ${file.absolute.path}');
  }
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

({
  List<QuestionScoringSpec> specs,
  Map<String, EngineSynDict> dictById,
  Map<String, String> answers,
  ({double totalScore, double totalMax, double percent}) expected,
})
_build(Map<String, dynamic> fixture) {
  final dicts = <String, EngineSynDict>{};
  for (final d in (fixture['dicts'] as List? ?? const [])) {
    final m = Map<String, dynamic>.from(d as Map);
    dicts[m['id'] as String] = EngineSynDict.fromJson(m);
  }

  final allGroupsByPoint = <String, List<EngineKeywordGroup>>{};
  final specs = <QuestionScoringSpec>[];
  for (final qRaw in (fixture['questions'] as List? ?? const [])) {
    final q = Map<String, dynamic>.from(qRaw as Map);
    final qid = q['id'] as String;
    final points = <EngineRubricPoint>[];
    for (final pRaw in (q['points'] as List? ?? const [])) {
      final p = Map<String, dynamic>.from(pRaw as Map);
      points.add(
        EngineRubricPoint(
          id: p['id'] as String,
          position: (p['position'] as int?) ?? 0,
          label: p['label'] as String? ?? '',
          weight: (p['weight'] is num) ? (p['weight'] as num).toDouble() : 1.0,
          isRequired: p['is_required'] as bool? ?? true,
          kind: p['kind'] as String? ?? 'core',
          explanationMd: null,
        ),
      );
      final groups = <EngineKeywordGroup>[];
      for (final gRaw in (p['groups'] as List? ?? const [])) {
        final g = Map<String, dynamic>.from(gRaw as Map);
        final keywords = <EngineKeyword>[];
        for (final kwRaw in (g['keywords'] as List? ?? const [])) {
          final kw = Map<String, dynamic>.from(kwRaw as Map);
          keywords.add(
            EngineKeyword(
              value: kw['value'] as String?,
              synDictId: kw['syn_dict_id'] as String?,
              isPhrase: kw['is_phrase'] as bool? ?? false,
              isNegation: kw['is_negation'] as bool? ?? false,
              fuzzyMaxDist: (kw['fuzzy_max_dist'] as int?) ?? 1,
            ),
          );
        }
        groups.add(
          EngineKeywordGroup(
            id: g['id'] as String,
            position: (g['position'] as int?) ?? 0,
            description: null,
            isOptional: g['is_optional'] as bool? ?? false,
            keywords: keywords,
          ),
        );
      }
      allGroupsByPoint[p['id'] as String] = groups;
    }
    specs.add(
      QuestionScoringSpec(
        questionId: qid,
        maxPoints: (q['max_points'] as int?) ?? 5,
        rubricPoints: points,
        groupsByPoint: allGroupsByPoint,
      ),
    );
  }

  final answers = <String, String>{};
  for (final entry in (fixture['answers'] as Map? ?? const {}).entries) {
    answers[entry.key.toString()] = entry.value?.toString() ?? '';
  }

  final exp = Map<String, dynamic>.from(fixture['expected'] as Map);
  final expected = (
    totalScore: (exp['total_score'] as num).toDouble(),
    totalMax: (exp['total_max'] as num).toDouble(),
    percent: (exp['percent'] as num).toDouble(),
  );

  return (specs: specs, dictById: dicts, answers: answers, expected: expected);
}

void main() {
  group('Parity Dart ↔ fixtures (CODE-052)', () {
    for (final name in _fixtureNames) {
      test(name, () {
        final fixture = _loadFixture(name);
        final built = _build(fixture);

        final scorer = AttemptScorer(
          matcher: KeywordMatcher(
            synonymResolver: SynonymResolver(built.dictById),
          ),
        );
        final result = scorer.score(
          AttemptScoringInput(
            answersByQuestionId: built.answers,
            questions: built.specs,
          ),
        );

        expect(
          result.totalScore,
          closeTo(built.expected.totalScore, 0.01),
          reason: 'total_score mismatch sur $name',
        );
        expect(
          result.totalMax,
          closeTo(built.expected.totalMax, 0.01),
          reason: 'total_max mismatch sur $name',
        );
        expect(
          result.percent,
          closeTo(built.expected.percent, 0.01),
          reason: 'percent mismatch sur $name',
        );
      });
    }
  });
}
