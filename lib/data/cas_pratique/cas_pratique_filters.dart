// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Service de filtres (persistance shared_prefs) ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 3 filtres)        ║
// ║  Tâche      : CODE-038                                                  ║
// ║                                                                         ║
// ║  - Modèle immutable `CasPratiqueFilters` (years / themeSlugs /          ║
// ║    difficulties)                                                        ║
// ║  - Service singleton qui sauvegarde / charge dans shared_preferences   ║
// ║    via le wrapper CasPratiqueCache (préfixe `cp_cache.`).               ║
// ║                                                                         ║
// ║  Pas de TTL sur les filtres : ils persistent jusqu'à reset explicite.  ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:convert';

import 'package:copiqpolice/data/cas_pratique/cas_pratique_cache.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository.dart'
    show CaseSortBy;
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';

/// Représentation immutable de l'état des filtres de la liste cas pratique.
class CasPratiqueFilters {
  final Set<int> years;
  final Set<String> themeSlugs;
  final Set<CpDifficulty> difficulties;

  /// CODE-092 — Filtre "Non fait" : exclure les cas déjà complétés par l'user.
  final bool notDone;

  const CasPratiqueFilters({
    this.years = const <int>{},
    this.themeSlugs = const <String>{},
    this.difficulties = const <CpDifficulty>{},
    this.notDone = false,
  });

  /// Filtres vides (aucune restriction).
  static const CasPratiqueFilters empty = CasPratiqueFilters();

  bool get isEmpty =>
      years.isEmpty && themeSlugs.isEmpty && difficulties.isEmpty && !notDone;

  bool get isNotEmpty => !isEmpty;

  /// Nombre total de critères actifs (toutes catégories confondues).
  int get totalActive =>
      years.length + themeSlugs.length + difficulties.length + (notDone ? 1 : 0);

  /// Nombre de **catégories** actives (max 4 : années + thèmes + difficultés + non fait).
  int get activeCategories =>
      (years.isNotEmpty ? 1 : 0) +
      (themeSlugs.isNotEmpty ? 1 : 0) +
      (difficulties.isNotEmpty ? 1 : 0) +
      (notDone ? 1 : 0);

  CasPratiqueFilters copyWith({
    Set<int>? years,
    Set<String>? themeSlugs,
    Set<CpDifficulty>? difficulties,
    bool? notDone,
  }) {
    return CasPratiqueFilters(
      years: years ?? this.years,
      themeSlugs: themeSlugs ?? this.themeSlugs,
      difficulties: difficulties ?? this.difficulties,
      notDone: notDone ?? this.notDone,
    );
  }

  CasPratiqueFilters withYears(Set<int> v) => copyWith(years: v);
  CasPratiqueFilters withThemes(Set<String> v) => copyWith(themeSlugs: v);
  CasPratiqueFilters withDifficulties(Set<CpDifficulty> v) =>
      copyWith(difficulties: v);
  // CODE-092 — toggle "Non fait"
  CasPratiqueFilters withNotDone(bool v) => copyWith(notDone: v);
  CasPratiqueFilters toggleNotDone() => copyWith(notDone: !notDone);

  CasPratiqueFilters cleared() => empty;

  Map<String, dynamic> toJson() => {
        'years': years.toList()..sort(),
        'theme_slugs': themeSlugs.toList()..sort(),
        'difficulties': difficulties.map(difficultyToString).toList()..sort(),
        'not_done': notDone,
      };

  factory CasPratiqueFilters.fromJson(Map<String, dynamic> j) {
    final years = <int>{};
    for (final v in (j['years'] as List? ?? const [])) {
      if (v is int) {
        years.add(v);
      } else if (v is num) {
        years.add(v.toInt());
      } else {
        final parsed = int.tryParse(v.toString());
        if (parsed != null) years.add(parsed);
      }
    }

    final themeSlugs = <String>{};
    for (final v in (j['theme_slugs'] as List? ?? const [])) {
      if (v is String && v.isNotEmpty) themeSlugs.add(v);
    }

    final difficulties = <CpDifficulty>{};
    for (final v in (j['difficulties'] as List? ?? const [])) {
      switch (v.toString()) {
        case 'facile':
          difficulties.add(CpDifficulty.facile);
          break;
        case 'difficile':
          difficulties.add(CpDifficulty.difficile);
          break;
        case 'moyen':
          difficulties.add(CpDifficulty.moyen);
          break;
      }
    }

    return CasPratiqueFilters(
      years: years,
      themeSlugs: themeSlugs,
      difficulties: difficulties,
      notDone: j['not_done'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CasPratiqueFilters) return false;
    return _setEq(years, other.years) &&
        _setEq(themeSlugs, other.themeSlugs) &&
        _setEq(difficulties, other.difficulties) &&
        notDone == other.notDone;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(years),
        Object.hashAllUnordered(themeSlugs),
        Object.hashAllUnordered(difficulties),
        notDone,
      );

  static bool _setEq<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    for (final v in a) {
      if (!b.contains(v)) return false;
    }
    return true;
  }

  @override
  String toString() =>
      'CasPratiqueFilters(years: $years, themeSlugs: $themeSlugs, '
      'difficulties: ${difficulties.map((e) => e.name).toList()}, '
      'notDone: $notDone)';
}

/// Service singleton de persistance des filtres.
///
/// Réutilise le même `SharedPreferences` que `CasPratiqueCache` via une
/// clé dédiée — pas de TTL : le filtre persiste tant que l'utilisateur
/// ne le retire pas (cohérent avec la majorité des apps mobiles).
class CasPratiqueFiltersService {
  CasPratiqueFiltersService._();

  static final CasPratiqueFiltersService instance =
      CasPratiqueFiltersService._();

  static const String _key = 'filters.list';
  static const String _sortKey = 'filters.list_sort';

  // ─── Tri (CODE-039) ────────────────────────────────────────────────────

  /// Tri par défaut si aucun préférence n'a été enregistrée.
  static const CaseSortBy defaultSort = CaseSortBy.recent;

  /// Charge la préférence de tri (CODE-039). Fallback `recent`.
  Future<CaseSortBy> loadSort() async {
    try {
      final raw = await CasPratiqueCache.instance.getRaw(_sortKey);
      final v = raw.value;
      if (v == null || v.isEmpty) return defaultSort;
      return _parseSortName(v);
    } catch (_) {
      return defaultSort;
    }
  }

  /// Sauvegarde la préférence de tri.
  Future<void> saveSort(CaseSortBy sort) async {
    try {
      await CasPratiqueCache.instance.put(_sortKey, sort.name);
    } catch (_) {
      /* silencieux */
    }
  }

  static CaseSortBy _parseSortName(String raw) {
    for (final v in CaseSortBy.values) {
      if (v.name == raw) return v;
    }
    return defaultSort;
  }

  // ─── Filtres ───────────────────────────────────────────────────────────

  /// Charge les filtres persistés. Retourne `empty` si rien.
  Future<CasPratiqueFilters> load() async {
    try {
      final raw = await CasPratiqueCache.instance.getRaw(_key);
      final v = raw.value;
      if (v == null) return CasPratiqueFilters.empty;
      final decoded = jsonDecode(v);
      if (decoded is Map<String, dynamic>) {
        return CasPratiqueFilters.fromJson(decoded);
      }
      if (decoded is Map) {
        return CasPratiqueFilters.fromJson(
          Map<String, dynamic>.from(decoded),
        );
      }
      return CasPratiqueFilters.empty;
    } catch (_) {
      return CasPratiqueFilters.empty;
    }
  }

  /// Sauvegarde les filtres. Si `empty` → on supprime l'entrée.
  Future<void> save(CasPratiqueFilters filters) async {
    try {
      if (filters.isEmpty) {
        await CasPratiqueCache.instance.remove(_key);
        return;
      }
      await CasPratiqueCache.instance.putJson(_key, filters.toJson());
    } catch (_) {
      /* silencieux : la persistance est une amélioration, pas un bloquant */
    }
  }

  /// Reset complet.
  Future<void> clear() => save(CasPratiqueFilters.empty);
}
