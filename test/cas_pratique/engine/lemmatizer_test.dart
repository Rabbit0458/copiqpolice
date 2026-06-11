// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : FrLemmatizer (CODE-049)               ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/lemmatizer.dart';

void main() {
  const lemma = FrLemmatizer();

  group('FrLemmatizer.stem', () {
    test('retire un suffixe -ation long', () {
      // 'degradation' → retire 'ation' → 'degrad'
      expect(lemma.stem('degradation'), equals('degrad'));
    });

    test('retire -aient', () {
      // 'degradaient' length=11, retire 5 → 'degrad' (6 chars, ok)
      expect(lemma.stem('degradaient'), equals('degrad'));
    });

    test('respecte la longueur minimale (5 chars)', () {
      // Mot trop court → inchangé
      expect(lemma.stem('cas'), equals('cas'));
      expect(lemma.stem('mots'), equals('mots'));
    });

    test('respecte la longueur minimale restante (4 chars)', () {
      // 'cris' (4 chars) → trop court à la base
      expect(lemma.stem('cris'), equals('cris'));
      // 'pries' length=5, mais après '-s' on a 'prie' (4 chars OK)
      expect(lemma.stem('pries'), equals('prie'));
    });

    test('ne touche pas aux mots de la whitelist', () {
      for (final w in [
        'plus', 'mais', 'sans', 'sous', 'avec', 'pour', 'dans',
        'les', 'des', 'mes', 'tes', 'ses', 'nos', 'vos',
      ]) {
        expect(lemma.stem(w), equals(w), reason: 'whitelist : $w');
      }
    });

    test('stemAll mappe une liste', () {
      final out = lemma.stemAll(['degradation', 'dans', 'voitures']);
      expect(out, equals(['degrad', 'dans', 'voitur']));
    });
  });
}
