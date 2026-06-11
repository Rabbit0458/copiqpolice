// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Synonym Resolver                     ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.5)     ║
// ║  Tâche      : CODE-024                                                  ║
// ║                                                                         ║
// ║  Résout un Keyword vers sa liste de candidats à matcher :              ║
// ║   - Si `syn_dict_id` est set → on lit le dictionnaire mutualisé        ║
// ║   - Sinon → on prend la value littérale                                 ║
// ╚════════════════════════════════════════════════════════════════════════╝

/// Représentation minimale d'un Keyword côté moteur.
///
/// Note : ce modèle est local au moteur. Il est rempli à partir de la table
/// `cas_pratique_keywords` côté serveur. Le client client ne le voit JAMAIS
/// directement (RLS), sauf en mode offline où la rubric est cachée.
class EngineKeyword {
  final String? value;
  final String? synDictId;
  final bool isPhrase;
  final bool isNegation;
  final int fuzzyMaxDist;

  const EngineKeyword({
    required this.value,
    required this.synDictId,
    required this.isPhrase,
    required this.isNegation,
    required this.fuzzyMaxDist,
  });

  factory EngineKeyword.fromJson(Map<String, dynamic> j) => EngineKeyword(
        value: j['value'] as String?,
        synDictId: j['syn_dict_id'] as String?,
        isPhrase: (j['is_phrase'] as bool?) ?? false,
        isNegation: (j['is_negation'] as bool?) ?? false,
        fuzzyMaxDist: (j['fuzzy_max_dist'] as int?) ?? 1,
      );
}

/// Représentation d'une entrée du dictionnaire mutualisé.
class EngineSynDict {
  final String id;
  final String slug;
  final List<String> terms;

  const EngineSynDict({
    required this.id,
    required this.slug,
    required this.terms,
  });

  factory EngineSynDict.fromJson(Map<String, dynamic> j) => EngineSynDict(
        id: j['id'] as String,
        slug: j['slug'] as String,
        terms: ((j['terms'] as List?) ?? const [])
            .map((t) => t.toString())
            .toList(growable: false),
      );
}

/// Résolveur de synonymes : keyword → liste de termes à essayer.
///
/// Le résolveur **ne normalise pas** les termes — c'est au caller de le faire
/// pour s'assurer de la cohérence avec le texte utilisateur.
class SynonymResolver {
  SynonymResolver(Map<String, EngineSynDict> dictById)
      : _dictById = Map.unmodifiable(dictById);

  final Map<String, EngineSynDict> _dictById;

  /// Liste des candidats pour un keyword donné.
  ///
  /// - Si `kw.synDictId` non null ET présent dans le dict → on retourne tous
  ///   les termes du dict.
  /// - Sinon → on retourne `[kw.value!]`.
  /// - Si les deux sont null/invalides → liste vide.
  List<String> resolve(EngineKeyword kw) {
    if (kw.synDictId != null && _dictById.containsKey(kw.synDictId)) {
      return _dictById[kw.synDictId]!.terms;
    }
    if (kw.value != null && kw.value!.isNotEmpty) {
      return [kw.value!];
    }
    return const [];
  }

  /// Nombre d'entrées en mémoire (debug).
  int get dictCount => _dictById.length;
}
