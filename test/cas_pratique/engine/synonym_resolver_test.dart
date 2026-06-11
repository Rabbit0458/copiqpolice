// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : SynonymResolver (CODE-049)            ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';

void main() {
  const dictId = 'dict_degrader';
  const dict = EngineSynDict(
    id: dictId,
    slug: 'degrader',
    terms: ['degrader', 'degradation', 'vandalisme', 'casser'],
  );

  group('SynonymResolver.resolve', () {
    test('keyword avec synDictId connu → renvoie tous les termes du dict', () {
      final resolver = SynonymResolver({dictId: dict});
      const kw = EngineKeyword(
        value: null,
        synDictId: dictId,
        isPhrase: false,
        isNegation: false,
        fuzzyMaxDist: 1,
      );
      expect(resolver.resolve(kw), equals(dict.terms));
    });

    test('keyword avec synDictId inconnu → fallback sur value', () {
      final resolver = SynonymResolver({});
      const kw = EngineKeyword(
        value: 'plainte',
        synDictId: 'inexistant',
        isPhrase: false,
        isNegation: false,
        fuzzyMaxDist: 0,
      );
      expect(resolver.resolve(kw), equals(['plainte']));
    });

    test('keyword sans synDictId ni value → liste vide', () {
      final resolver = SynonymResolver({});
      const kw = EngineKeyword(
        value: null,
        synDictId: null,
        isPhrase: false,
        isNegation: false,
        fuzzyMaxDist: 0,
      );
      expect(resolver.resolve(kw), isEmpty);
    });

    test('dictCount reflète bien la map injectée', () {
      final resolver = SynonymResolver({dictId: dict});
      expect(resolver.dictCount, equals(1));
    });
  });
}
