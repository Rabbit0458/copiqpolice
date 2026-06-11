// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : PointEvaluator (CODE-049)             ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/keyword_matcher.dart';
import 'package:copiqpolice/core/cas_pratique/engine/point_evaluator.dart';
import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';

EngineKeyword _kw(String value) => EngineKeyword(
      value: value,
      synDictId: null,
      isPhrase: false,
      isNegation: false,
      fuzzyMaxDist: 1,
    );

EngineKeywordGroup _g(int pos, List<String> values, {bool optional = false}) =>
    EngineKeywordGroup(
      id: 'g$pos',
      position: pos,
      description: null,
      isOptional: optional,
      keywords: values.map(_kw).toList(),
    );

const _point = EngineRubricPoint(
  id: 'p1',
  position: 1,
  label: 'Qualifier l\'infraction',
  weight: 2.0,
  isRequired: true,
  kind: 'core',
  explanationMd: null,
);

void main() {
  const evaluator = PointEvaluator();
  final matcher = KeywordMatcher();

  group('PointEvaluator.evaluate', () {
    test('aucun groupe → missing (score = 0)', () {
      final ctx = KeywordMatchContext.build('rien');
      final r = evaluator.evaluate(
        point: _point,
        groups: const [],
        ctx: ctx,
        matcher: matcher,
      );
      expect(r.status, equals(PointStatus.missing));
      expect(r.score, equals(0.0));
    });

    test('tous les groupes required matchés → covered (score = weight)', () {
      final groups = [
        _g(1, ['degradation', 'vandalisme']),
        _g(2, ['autrui']),
      ];
      final ctx = KeywordMatchContext.build('vandalisme du bien d autrui');
      final r = evaluator.evaluate(
        point: _point,
        groups: groups,
        ctx: ctx,
        matcher: matcher,
      );
      expect(r.status, equals(PointStatus.covered));
      expect(r.score, equals(2.0));
    });

    test('un seul groupe required sur deux → partial (score = weight × 0.5)', () {
      final groups = [
        _g(1, ['degradation', 'vandalisme']),
        _g(2, ['autrui']),
      ];
      // Le second groupe (autrui) ne matche pas
      final ctx = KeywordMatchContext.build('il y a eu degradation hier');
      final r = evaluator.evaluate(
        point: _point,
        groups: groups,
        ctx: ctx,
        matcher: matcher,
      );
      expect(r.status, equals(PointStatus.partial));
      expect(r.score, equals(1.0));
    });

    test('groupes optionnels exclus du ratio "required"', () {
      final groups = [
        _g(1, ['degradation']),
        _g(2, ['autrui']),
        _g(3, ['volontaire'], optional: true), // bonus non comptable
      ];
      // Les 2 required matchent → covered même si l'optionnel manque
      final ctx = KeywordMatchContext.build(
        'degradation du bien d autrui',
      );
      final r = evaluator.evaluate(
        point: _point,
        groups: groups,
        ctx: ctx,
        matcher: matcher,
      );
      expect(r.status, equals(PointStatus.covered));
    });

    test('aucun groupe required matché → missing', () {
      final groups = [
        _g(1, ['degradation']),
        _g(2, ['autrui']),
      ];
      final ctx = KeywordMatchContext.build('aucun mot pertinent ici');
      final r = evaluator.evaluate(
        point: _point,
        groups: groups,
        ctx: ctx,
        matcher: matcher,
      );
      expect(r.status, equals(PointStatus.missing));
      expect(r.score, equals(0.0));
    });
  });
}
