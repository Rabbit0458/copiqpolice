// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : Normalizer (CODE-049)                 ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/normalizer.dart';

void main() {
  const norm = Normalizer();

  group('Normalizer.normalize', () {
    test('chaîne vide → vide', () {
      expect(norm.normalize(''), equals(''));
    });

    test('retire les accents français courants', () {
      expect(norm.normalize('dégradé'), equals('degrade'));
      expect(norm.normalize('élève'), equals('eleve'));
      expect(norm.normalize('crêpe'), equals('crepe'));
      expect(norm.normalize('français'), equals('francais'));
    });

    test('met en lowercase et collapse whitespace', () {
      expect(norm.normalize('  HELLO   World  '), equals('hello world'));
      expect(norm.normalize('A\nB\tC'), equals('a b c'));
    });

    test('gère les ligatures œ et æ', () {
      expect(norm.normalize('cœur'), equals('coeur'));
      expect(norm.normalize('Œuvre'), equals('oeuvre'));
      expect(norm.normalize('cæsar'), equals('caesar'));
    });

    test('retire la ponctuation par défaut', () {
      expect(
        norm.normalize("L'école, c'est important !"),
        equals('l ecole c est important'),
      );
      expect(norm.normalize('art. 322-1 CP.'), equals('art 322 1 cp'));
    });

    test('conserve les apostrophes si demandé', () {
      final r = norm.normalize(
        "L'école",
        opts: const NormalizerOptions(keepApostrophes: true),
      );
      expect(r, equals("l'ecole"));
    });

    test('tronque les entrées dépassant maxInputLength', () {
      final huge = 'a' * 11000;
      final r = norm.normalize(
        huge,
        opts: const NormalizerOptions(maxInputLength: 10),
      );
      expect(r.length, lessThanOrEqualTo(10));
    });

    test('remplace NBSP par espace standard', () {
      // NBSP U+00A0
      expect(norm.normalize('a b'), equals('a b'));
    });
  });

  group('Normalizer.softNormalize', () {
    test('lowercase + trim sans retirer les accents', () {
      expect(norm.softNormalize('  Élève  '), equals('élève'));
    });
  });
}
