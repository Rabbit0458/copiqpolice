// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Tokenizer + N-grams                  ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.2)     ║
// ║  Tâche      : CODE-020                                                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

/// Tokenizer simple basé sur le whitespace + générateur de n-grams.
///
/// Pourquoi des n-grams ?
/// - Pour reconnaître "dégradation volontaire" comme un bloc, pas juste
///   les deux mots isolément
/// - Améliore la précision sans surcoût en mémoire (Set hashé)
class Tokenizer {
  const Tokenizer();

  /// Tokens : split sur whitespace + filtre les tokens vides.
  List<String> tokenize(String normalized) {
    if (normalized.isEmpty) return const [];
    final parts = normalized.split(RegExp(r'\s+'));
    return parts.where((t) => t.isNotEmpty).toList(growable: false);
  }

  /// Génère unigrams + bigrams + trigrams (joinés par '_').
  ///
  /// Exemple :
  ///   tokens = ['degradation', 'volontaire', 'bien']
  ///   →  {
  ///        'degradation', 'volontaire', 'bien',
  ///        'degradation_volontaire', 'volontaire_bien',
  ///        'degradation_volontaire_bien'
  ///      }
  Set<String> ngramSet(List<String> tokens) {
    final out = <String>{...tokens};
    for (var i = 0; i + 1 < tokens.length; i++) {
      out.add('${tokens[i]}_${tokens[i + 1]}');
    }
    for (var i = 0; i + 2 < tokens.length; i++) {
      out.add('${tokens[i]}_${tokens[i + 1]}_${tokens[i + 2]}');
    }
    return out;
  }

  /// N-grams arbitraires (1..n).
  Set<String> ngramSetOf(List<String> tokens, int maxN) {
    final out = <String>{};
    for (var n = 1; n <= maxN; n++) {
      for (var i = 0; i + n - 1 < tokens.length; i++) {
        out.add(tokens.sublist(i, i + n).join('_'));
      }
    }
    return out;
  }
}
