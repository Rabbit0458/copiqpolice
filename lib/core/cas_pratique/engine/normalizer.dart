// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Normalizer                           ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.1)     ║
// ║  Tâche      : CODE-019                                                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

/// Options de normalisation.
class NormalizerOptions {
  /// Retirer la ponctuation (`!?,.;:` etc.) — défaut true.
  final bool stripPunctuation;

  /// Préserver les apostrophes (`l'école` → `l'ecole`) au lieu de les retirer.
  final bool keepApostrophes;

  /// Longueur max d'entrée (perfo). Au-delà on tronque.
  final int maxInputLength;

  const NormalizerOptions({
    this.stripPunctuation = true,
    this.keepApostrophes = false,
    this.maxInputLength = 10000,
  });

  static const NormalizerOptions standard = NormalizerOptions();
}

/// Normalisateur de texte pour le matching keyword.
///
/// Pipeline :
///   1. Tronquer à `maxInputLength`
///   2. Unicode NFD (décomposition canonique)
///   3. Retirer les diacritiques (accents, cédilles, etc.)
///   4. Gestion des ligatures (œ → oe, æ → ae)
///   5. Remplacer NBSP par espace
///   6. Lowercase
///   7. Optionnel : retirer ponctuation
///   8. Collapse whitespace
///   9. Trim
class Normalizer {
  const Normalizer();

  /// Applique le pipeline complet.
  String normalize(String input, {NormalizerOptions opts = NormalizerOptions.standard}) {
    if (input.isEmpty) return '';
    var s = input;
    if (s.length > opts.maxInputLength) {
      s = s.substring(0, opts.maxInputLength);
    }
    s = _stripDiacritics(s);
    s = _replaceLigatures(s);
    s = s.replaceAll(' ', ' ');
    s = s.toLowerCase();
    if (opts.stripPunctuation) {
      s = _stripPunctuation(s, keepApostrophes: opts.keepApostrophes);
    }
    s = _collapseWhitespace(s);
    return s.trim();
  }

  /// Variante légère : juste lowercase + collapse whitespace (utile pour
  /// l'affichage ou des comparaisons souples qui doivent garder les accents).
  String softNormalize(String input) {
    return input.replaceAll(' ', ' ').toLowerCase().trim();
  }

  // ─── Internals ───────────────────────────────────────────────────────────

  /// Retire les caractères de combinaison Unicode (U+0300 .. U+036F).
  /// Approche manuelle car la lib `unorm` n'est pas dispo par défaut en Dart.
  ///
  /// Pour les caractères courants français, on map directement.
  String _stripDiacritics(String s) {
    final buffer = StringBuffer();
    for (final rune in s.runes) {
      final mapped = _diacriticMap[rune];
      if (mapped != null) {
        buffer.write(mapped);
      } else {
        // Combining characters block : on les ignore
        if (rune >= 0x0300 && rune <= 0x036F) continue;
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  String _replaceLigatures(String s) {
    return s
        .replaceAll('œ', 'oe')
        .replaceAll('Œ', 'OE')
        .replaceAll('æ', 'ae')
        .replaceAll('Æ', 'AE')
        .replaceAll('ﬁ', 'fi')
        .replaceAll('ﬂ', 'fl');
  }

  String _stripPunctuation(String s, {required bool keepApostrophes}) {
    if (keepApostrophes) {
      return s.replaceAll(RegExp(r"[^a-z0-9\s']"), ' ');
    }
    return s.replaceAll(RegExp(r"[^a-z0-9\s]"), ' ');
  }

  String _collapseWhitespace(String s) {
    return s.replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Mapping caractère accentué → équivalent ASCII.
  /// Couvre le français + quelques cas européens courants.
  static const Map<int, String> _diacriticMap = {
    // a
    0x00E0: 'a', 0x00E1: 'a', 0x00E2: 'a', 0x00E3: 'a', 0x00E4: 'a', 0x00E5: 'a',
    0x00C0: 'A', 0x00C1: 'A', 0x00C2: 'A', 0x00C3: 'A', 0x00C4: 'A', 0x00C5: 'A',
    // c
    0x00E7: 'c', 0x00C7: 'C',
    // e
    0x00E8: 'e', 0x00E9: 'e', 0x00EA: 'e', 0x00EB: 'e',
    0x00C8: 'E', 0x00C9: 'E', 0x00CA: 'E', 0x00CB: 'E',
    // i
    0x00EC: 'i', 0x00ED: 'i', 0x00EE: 'i', 0x00EF: 'i',
    0x00CC: 'I', 0x00CD: 'I', 0x00CE: 'I', 0x00CF: 'I',
    // n
    0x00F1: 'n', 0x00D1: 'N',
    // o
    0x00F2: 'o', 0x00F3: 'o', 0x00F4: 'o', 0x00F5: 'o', 0x00F6: 'o', 0x00F8: 'o',
    0x00D2: 'O', 0x00D3: 'O', 0x00D4: 'O', 0x00D5: 'O', 0x00D6: 'O', 0x00D8: 'O',
    // u
    0x00F9: 'u', 0x00FA: 'u', 0x00FB: 'u', 0x00FC: 'u',
    0x00D9: 'U', 0x00DA: 'U', 0x00DB: 'U', 0x00DC: 'U',
    // y
    0x00FD: 'y', 0x00FF: 'y',
    0x00DD: 'Y', 0x0178: 'Y',
  };
}
