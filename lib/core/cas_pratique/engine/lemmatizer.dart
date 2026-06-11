// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Lemmatizer FR léger                  ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.3)     ║
// ║  Tâche      : CODE-021                                                  ║
// ║                                                                         ║
// ║  Ce n'est PAS un vrai lemmatiseur — c'est un stemmer FR par retrait    ║
// ║  de suffixes courants. Léger, rapide, suffisant pour la correction.    ║
// ╚════════════════════════════════════════════════════════════════════════╝

/// Stemmer FR léger.
///
/// Stratégie : retirer les suffixes les plus longs en premier.
/// Garde-fou : on ne stem que si le mot fait au moins 5 caractères, et on
/// laisse au moins 4 caractères après retrait.
class FrLemmatizer {
  const FrLemmatizer();

  /// Suffixes triés du plus long au plus court.
  static const List<String> _suffixes = [
    'aient',  // ils dégrad-aient
    'ation',  // dégrad-ation
    'ement',  // calm-ement
    'ions',   // nous dégrad-ions
    'iez',    // vous dégrad-iez
    'ait',    // il dégrad-ait
    'ais',    // je dégrad-ais
    'ant',    // dégrad-ant
    'ent',    // ils dégrad-ent
    'ons',    // nous dégrad-ons
    'ées',    // dégrad-ées
    'ée',     // dégrad-ée
    'és',     // dégrad-és
    'er',     // dégrad-er
    'ir',     // fin-ir
    're',     // mett-re
    'eux',    // valeur-eux
    'aux',    // valeur-aux  (pluriel de -al en -aux)
    'ses',    // évalu-ation > ses
    'eur',    // valeur, polic-eur (à utiliser avec prudence)
    'é',      // dégrad-é
    's',      // pluriel simple
    'x',      // chev-aux > chevau-x (pluriel particulier)
  ];

  /// Liste de mots qu'on **n'altère JAMAIS** (irréguliers ou trop courts).
  static const Set<String> _doNotStem = {
    'les', 'des', 'mes', 'tes', 'ses', 'nos', 'vos',
    'est', 'sont', 'sera', 'aura',
    'plus', 'mais', 'sans', 'sous', 'avec', 'pour', 'dans',
  };

  /// Retire le premier suffixe matché qui passe les garde-fous.
  ///
  /// Si aucun suffixe ne matche, retourne le token original.
  String stem(String token) {
    if (token.length < 5) return token;
    if (_doNotStem.contains(token)) return token;

    for (final suf in _suffixes) {
      final newLen = token.length - suf.length;
      if (newLen >= 4 && token.endsWith(suf)) {
        return token.substring(0, newLen);
      }
    }
    return token;
  }

  /// Stem tout une liste.
  List<String> stemAll(List<String> tokens) => tokens.map(stem).toList(growable: false);
}
