// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : Tokenizer (CODE-049)                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/tokenizer.dart';

void main() {
  const tok = Tokenizer();

  group('Tokenizer.tokenize', () {
    test('chaîne vide → liste vide', () {
      expect(tok.tokenize(''), isEmpty);
    });

    test('split simple sur whitespace', () {
      expect(tok.tokenize('un deux trois'), equals(['un', 'deux', 'trois']));
    });

    test('élimine les tokens vides', () {
      expect(tok.tokenize('  un   deux  '), equals(['un', 'deux']));
    });
  });

  group('Tokenizer.ngramSet', () {
    test('inclut unigrams, bigrams et trigrams', () {
      final s = tok.ngramSet(['a', 'b', 'c']);
      expect(s, containsAll(['a', 'b', 'c', 'a_b', 'b_c', 'a_b_c']));
      expect(s.length, equals(6));
    });

    test('sur 2 tokens : pas de trigram', () {
      final s = tok.ngramSet(['a', 'b']);
      expect(s, equals({'a', 'b', 'a_b'}));
    });

    test('sur 1 token : juste l\'unigram', () {
      final s = tok.ngramSet(['solo']);
      expect(s, equals({'solo'}));
    });
  });

  group('Tokenizer.ngramSetOf', () {
    test('maxN=4 sur 4 tokens → toutes les n-grams ≤ 4', () {
      final s = tok.ngramSetOf(['a', 'b', 'c', 'd'], 4);
      expect(s, contains('a_b_c_d'));
      expect(s, contains('a'));
      expect(s, contains('a_b'));
      expect(s, contains('a_b_c'));
    });
  });
}
