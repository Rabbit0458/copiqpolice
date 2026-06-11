// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Tests : NegationDetector (CODE-049)           ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/cas_pratique/engine/negation_detector.dart';

void main() {
  const neg = NegationDetector();

  group('NegationDetector.isNegated', () {
    test('rien avant la position → pas négué', () {
      expect(neg.isNegated(['degrade'], 0), isFalse);
    });

    test('"ne ... pas" détecté avant le keyword', () {
      // ne degrade pas → "degrade" en position 1, "ne" en position 0
      final tokens = ['ne', 'degrade', 'pas'];
      expect(neg.isNegated(tokens, 1), isTrue);
    });

    test('fenêtre limitée : négation trop loin → pas détectée', () {
      // 7 tokens entre la négation et le mot, default window = 5
      final tokens =
          ['ne', 'a', 'b', 'c', 'd', 'e', 'degrade'];
      expect(neg.isNegated(tokens, 6), isFalse);
    });

    test('mots "sans", "jamais", "aucun" déclenchent aussi', () {
      expect(neg.isNegated(['sans', 'plainte'], 1), isTrue);
      expect(neg.isNegated(['jamais', 'vu'], 1), isTrue);
      expect(neg.isNegated(['aucun', 'doute'], 1), isTrue);
    });
  });

  group('NegationDetector.isKeywordNegated', () {
    test('cherche le keyword puis vérifie la négation', () {
      final tokens = ['je', 'ne', 'degrade', 'pas', 'le', 'bien'];
      expect(neg.isKeywordNegated(tokens, 'degrade'), isTrue);
    });

    test('keyword non négué', () {
      final tokens = ['je', 'degrade', 'le', 'bien'];
      expect(neg.isKeywordNegated(tokens, 'degrade'), isFalse);
    });

    test('keyword introuvable → false', () {
      final tokens = ['je', 'ne', 'parle', 'pas'];
      expect(neg.isKeywordNegated(tokens, 'degrade'), isFalse);
    });
  });

  group('NegationDetector.isPhraseNegated', () {
    test('phrase négée dans le texte', () {
      expect(
        neg.isPhraseNegated('je ne depose pas plainte', 'depose plainte'),
        isFalse, // "ne" est avant "depose", "pas" entre → "depose plainte" pas trouvée
      );
      // Cas plus direct :
      expect(
        neg.isPhraseNegated('sans depot plainte', 'depot plainte'),
        isTrue,
      );
    });

    test('phrase introuvable → false', () {
      expect(neg.isPhraseNegated('je depose plainte', 'absente'), isFalse);
    });
  });
}
