// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Distance de Levenshtein              ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.4)     ║
// ║  Tâche      : CODE-022                                                  ║
// ║                                                                         ║
// ║  Implémentation : matrice à 2 lignes (mémoire O(min(m,n)))             ║
// ║  Early exit : si toute une ligne dépasse maxDist, on s'arrête.         ║
// ╚════════════════════════════════════════════════════════════════════════╝

/// Distance d'édition Levenshtein.
class Levenshtein {
  const Levenshtein._();

  /// Distance entre deux chaînes (substitutions, insertions, suppressions
  /// pondérées à 1).
  ///
  /// - Si `maxDist` est fourni et que la distance dépasse cette valeur,
  ///   on retourne `maxDist + 1` (early exit) — utile pour fail-fast.
  static int distance(String a, String b, {int? maxDist}) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    // Si la diff de longueur excède maxDist, inutile d'aller plus loin
    if (maxDist != null && (a.length - b.length).abs() > maxDist) {
      return maxDist + 1;
    }

    final m = a.length;
    final n = b.length;

    var prev = List<int>.generate(n + 1, (j) => j, growable: false);
    var curr = List<int>.filled(n + 1, 0);

    for (var i = 1; i <= m; i++) {
      curr[0] = i;
      var rowMin = i;
      final ai = a.codeUnitAt(i - 1);
      for (var j = 1; j <= n; j++) {
        final cost = (ai == b.codeUnitAt(j - 1)) ? 0 : 1;
        final del = prev[j] + 1;
        final ins = curr[j - 1] + 1;
        final sub = prev[j - 1] + cost;
        var v = del;
        if (ins < v) v = ins;
        if (sub < v) v = sub;
        curr[j] = v;
        if (v < rowMin) rowMin = v;
      }
      if (maxDist != null && rowMin > maxDist) {
        return maxDist + 1;
      }
      final tmp = prev;
      prev = curr;
      curr = tmp;
    }
    return prev[n];
  }

  /// Ratio de similarité dans [0..1] : 1.0 = identique, 0.0 = totalement différent.
  static double ratio(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1.0;
    final maxLen = a.length > b.length ? a.length : b.length;
    if (maxLen == 0) return 1.0;
    return 1.0 - (distance(a, b) / maxLen);
  }

  /// Match rapide : retourne true si distance(a,b) ≤ maxDist.
  /// Plus efficace que `distance(...) <= maxDist` grâce à l'early exit.
  static bool isWithin(String a, String b, int maxDist) {
    return distance(a, b, maxDist: maxDist) <= maxDist;
  }
}
