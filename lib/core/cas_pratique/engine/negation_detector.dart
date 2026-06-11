// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Negation Detector                    ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.5)     ║
// ║  Tâche      : CODE-023                                                  ║
// ║                                                                         ║
// ║  Détecte si un keyword est précédé d'une négation dans une fenêtre     ║
// ║  glissante de 5 tokens. Permet de distinguer "je dégrade" de "je ne    ║
// ║  dégrade pas".                                                          ║
// ╚════════════════════════════════════════════════════════════════════════╝

/// Détecte les négations dans le texte normalisé.
class NegationDetector {
  const NegationDetector();

  /// Mots-clés de négation FR (déjà normalisés).
  static const Set<String> negationWords = {
    'ne', 'n', 'pas', 'plus', 'jamais', 'aucun', 'aucune', 'aucuns', 'aucunes',
    'rien', 'sans', 'non', 'ni', 'nul', 'nulle', 'nulles',
  };

  /// Taille de la fenêtre rétrograde à examiner.
  static const int defaultWindow = 5;

  /// Vrai si un des `window` tokens précédant la position [keywordPos]
  /// (exclu) contient un mot de négation.
  bool isNegated(List<String> tokens, int keywordPos, {int window = defaultWindow}) {
    if (keywordPos <= 0) return false;
    final start = (keywordPos - window).clamp(0, tokens.length);
    for (var i = start; i < keywordPos; i++) {
      if (negationWords.contains(tokens[i])) return true;
    }
    return false;
  }

  /// Cherche la première occurrence du token [keyword] dans [tokens]
  /// puis vérifie sa négation.
  bool isKeywordNegated(List<String> tokens, String keyword, {int window = defaultWindow}) {
    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i] == keyword) {
        if (isNegated(tokens, i, window: window)) return true;
      }
    }
    return false;
  }

  /// Vérifie la négation d'une phrase (multi-mots) dans `fullText`.
  /// On regarde les `window` tokens qui précèdent la phrase.
  bool isPhraseNegated(String fullNormalized, String phrase, {int window = defaultWindow}) {
    final idx = fullNormalized.indexOf(phrase);
    if (idx < 0) return false;
    final before = fullNormalized.substring(0, idx).trim();
    if (before.isEmpty) return false;
    final beforeTokens = before.split(RegExp(r'\s+'));
    final start = (beforeTokens.length - window).clamp(0, beforeTokens.length);
    for (var i = start; i < beforeTokens.length; i++) {
      if (negationWords.contains(beforeTokens[i])) return true;
    }
    return false;
  }
}
