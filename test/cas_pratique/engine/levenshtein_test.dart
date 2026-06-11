// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : Levenshtein (CODE-049)                ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/levenshtein.dart';

void main() {
  group('Levenshtein.distance', () {
    test('identiques → 0', () {
      expect(Levenshtein.distance('hello', 'hello'), equals(0));
      expect(Levenshtein.distance('', ''), equals(0));
    });

    test('substitution 1 char → 1', () {
      expect(Levenshtein.distance('chat', 'chai'), equals(1));
    });

    test('insertion 1 char → 1', () {
      expect(Levenshtein.distance('chat', 'chats'), equals(1));
    });

    test('classique kitten/sitting → 3', () {
      expect(Levenshtein.distance('kitten', 'sitting'), equals(3));
    });

    test('chaîne vide vs N chars → N', () {
      expect(Levenshtein.distance('', 'abcde'), equals(5));
      expect(Levenshtein.distance('abcde', ''), equals(5));
    });

    test('early exit avec maxDist', () {
      // Si la distance est très grande, on doit retourner maxDist+1
      final r = Levenshtein.distance(
        'aaaaaaaaaaaa',
        'bbbbbbbbbbbb',
        maxDist: 2,
      );
      expect(r, equals(3)); // maxDist + 1
    });
  });

  group('Levenshtein.ratio', () {
    test('identiques → 1.0', () {
      expect(Levenshtein.ratio('abc', 'abc'), equals(1.0));
    });

    test('totalement différents → ratio < 0.5', () {
      expect(Levenshtein.ratio('abc', 'xyz'), lessThan(0.5));
    });
  });

  group('Levenshtein.isWithin', () {
    test('typo 1 caractère matche avec maxDist=1', () {
      expect(Levenshtein.isWithin('degradation', 'degredation', 1), isTrue);
    });

    test('typo 2 caractères ne matche pas avec maxDist=1', () {
      expect(Levenshtein.isWithin('degradation', 'deggrdation', 1), isFalse);
    });
  });
}
