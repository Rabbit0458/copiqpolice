// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : KeywordMatcher (CODE-049)             ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/keyword_matcher.dart';
import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';

EngineKeyword _kw({
  String? value,
  String? synDictId,
  bool isPhrase = false,
  bool isNegation = false,
  int fuzzyMaxDist = 1,
}) {
  return EngineKeyword(
    value: value,
    synDictId: synDictId,
    isPhrase: isPhrase,
    isNegation: isNegation,
    fuzzyMaxDist: fuzzyMaxDist,
  );
}

void main() {
  final matcher = KeywordMatcher();

  group('KeywordMatchContext.build', () {
    test('normalise + tokenise correctement', () {
      final ctx = KeywordMatchContext.build('Dégradation Volontaire !');
      expect(ctx.normalizedAnswer, equals('degradation volontaire'));
      expect(ctx.tokens, equals(['degradation', 'volontaire']));
      expect(ctx.tokenSet, contains('degradation'));
      expect(ctx.ngramSet, contains('degradation_volontaire'));
    });
  });

  group('KeywordMatcher.matches', () {
    test('match exact d\'un mot dans la réponse', () {
      final ctx = KeywordMatchContext.build("J'ai vu une dégradation.");
      expect(matcher.matches(_kw(value: 'degradation'), ctx), isTrue);
    });

    test('match d\'une phrase multi-mots', () {
      final ctx = KeywordMatchContext.build(
        "Il y a eu une atteinte aux biens hier.",
      );
      expect(
        matcher.matches(_kw(value: 'atteinte aux biens', isPhrase: true), ctx),
        isTrue,
      );
    });

    test('fuzzy match avec typo 1 caractère (mot ≥ 6 chars)', () {
      final ctx = KeywordMatchContext.build('vandelisme du véhicule');
      // 'vandelisme' vs 'vandalisme' : 1 substitution
      expect(
        matcher.matches(_kw(value: 'vandalisme', fuzzyMaxDist: 1), ctx),
        isTrue,
      );
    });

    test('mot trop court : pas de fuzzy', () {
      final ctx = KeywordMatchContext.build('boto');
      expect(
        matcher.matches(_kw(value: 'moto', fuzzyMaxDist: 2), ctx),
        isFalse,
      );
    });

    test('keyword non présent → false', () {
      final ctx = KeywordMatchContext.build('absolument rien à voir.');
      expect(matcher.matches(_kw(value: 'degradation'), ctx), isFalse);
    });

    test('keyword négué → false (sauf si is_negation)', () {
      final ctx = KeywordMatchContext.build('je ne degrade pas le bien');
      // sans is_negation : négué donc échec
      expect(matcher.matches(_kw(value: 'degrade'), ctx), isFalse);
      // is_negation = true : négation attendue, présente → succès
      expect(
        matcher.matches(_kw(value: 'degrade', isNegation: true), ctx),
        isTrue,
      );
    });
  });

  group('KeywordMatcher avec SynonymResolver', () {
    test('résout depuis le dict de synonymes', () {
      const dict = EngineSynDict(
        id: 'd1',
        slug: 'degrader',
        terms: ['vandalisme', 'saccager', 'casser'],
      );
      final resolver = SynonymResolver({'d1': dict});
      final m = KeywordMatcher(synonymResolver: resolver);
      final ctx =
          KeywordMatchContext.build('Il a saccagé la voiture');
      expect(
        m.matches(_kw(value: null, synDictId: 'd1', fuzzyMaxDist: 1), ctx),
        isTrue,
      );
    });
  });
}
