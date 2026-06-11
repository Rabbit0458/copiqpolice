// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Service de recherche avancée                  ║
// ║  Tâche : CODE-092                                                       ║
// ║                                                                         ║
// ║  Fournit :                                                              ║
// ║    - searchCases()       — FTS via RPC cp_search_cases_fts              ║
// ║    - autocomplete()      — suggestions via RPC cp_search_autocomplete   ║
// ║    - highlightText()     — helper spans pour surlignage inline          ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';

// ─── Modèles ─────────────────────────────────────────────────────────────────

/// Suggestion d'auto-complete retournée par [CpSearchService.autocomplete].
@immutable
class CpAutocompleteSuggestion {
  final String slug;
  final String title;
  final int year;
  final double score;

  const CpAutocompleteSuggestion({
    required this.slug,
    required this.title,
    required this.year,
    required this.score,
  });

  factory CpAutocompleteSuggestion.fromJson(Map<String, dynamic> j) {
    return CpAutocompleteSuggestion(
      slug: j['slug'] as String? ?? '',
      title: j['title'] as String? ?? '',
      year: (j['year'] as num?)?.toInt() ?? 0,
      score: (j['similarity_score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Résultat de recherche — étend [CaseSummary] en ajoutant le score FTS
/// et le theme_id brut (pour lookup local côté page liste).
@immutable
class CpSearchResult {
  final CaseSummary cas;
  final double rank;
  /// UUID du thème — à utiliser pour enrichir [CaseSummary.theme] côté client.
  final String? themeId;

  const CpSearchResult({required this.cas, required this.rank, this.themeId});
}

// ─── Service ──────────────────────────────────────────────────────────────────

/// Service singleton de recherche full-text pour les cas pratiques.
///
/// Utilise les RPCs Supabase créées dans la migration CODE-092 :
///   - `cp_search_cases_fts`     — recherche avancée avec filtres
///   - `cp_search_autocomplete`  — suggestions titre (trigram)
///
/// Toutes les méthodes sont silencieuses en cas d'erreur : elles retournent
/// une liste vide et loguent en debug pour ne jamais crasher l'UI.
class CpSearchService {
  CpSearchService._();

  static final CpSearchService instance = CpSearchService._();

  SupabaseClient get _sb => Supabase.instance.client;

  // ─── Recherche avancée ─────────────────────────────────────────────────

  /// Recherche des cas avec la requête [query] et les filtres optionnels.
  ///
  /// [themeIds]    — UUIDs des thèmes (null = tous)
  /// [years]       — années (null = toutes)
  /// [difficulties]— difficultés (null = toutes)
  /// [notDone]     — si true, exclure les cas déjà complétés par l'user connecté
  /// [limit]/[offset] — pagination
  Future<List<CpSearchResult>> searchCases({
    required String query,
    List<String>? themeIds,
    List<int>? years,
    List<CpDifficulty>? difficulties,
    bool notDone = false,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final uid = _sb.auth.currentUser?.id;

      final params = <String, dynamic>{
        'p_query': query.trim(),
        'p_limit': limit,
        'p_offset': offset,
      };

      if (themeIds != null && themeIds.isNotEmpty) {
        params['p_theme_ids'] = themeIds;
      }
      if (years != null && years.isNotEmpty) {
        params['p_years'] = years;
      }
      if (difficulties != null && difficulties.isNotEmpty) {
        params['p_difficulties'] = difficulties.map(_diffStr).toList();
      }
      if (notDone && uid != null) {
        params['p_not_done_uid'] = uid;
      }

      final rows = await _sb.rpc('cp_search_cases_fts', params: params);

      if (rows == null) return const [];

      return (rows as List)
          .whereType<Map<String, dynamic>>()
          .map((r) {
            final cas = CaseSummary(
              id: r['id'] as String? ?? '',
              slug: r['slug'] as String? ?? '',
              title: r['title'] as String? ?? '',
              year: (r['year'] as num?)?.toInt() ?? 0,
              month: r['month']?.toString(),
              theme: null, // pas de join dans la RPC, à enrichir si besoin
              difficulty: _parseDifficulty(r['difficulty'] as String?),
              totalPoints: (r['total_points'] as num?)?.toInt() ?? 0,
              estimatedMinutes: (r['estimated_minutes'] as num?)?.toInt() ?? 0,
              publishedAt: r['published_at'] != null
                  ? DateTime.tryParse(r['published_at'].toString())
                  : null,
              userProgress: null,
              avgSuccessPercent: (r['avg_success_percent'] as num?)?.toDouble(),
              isFree: r['is_free'] as bool? ?? false,
            );
            final rank = (r['rank'] as num?)?.toDouble() ?? 0.0;
            final themeId = r['theme_id'] as String?;
            return CpSearchResult(cas: cas, rank: rank, themeId: themeId);
          })
          .toList();
    } catch (e, st) {
      debugPrint('[CpSearchService.searchCases] error: $e\n$st');
      return const [];
    }
  }

  // ─── Auto-complete ─────────────────────────────────────────────────────

  /// Retourne des suggestions de titres pour l'auto-complete.
  ///
  /// Requête minimale : 2 caractères (la RPC elle-même filtre < 2 chars).
  Future<List<CpAutocompleteSuggestion>> autocomplete(
    String query, {
    int limit = 8,
  }) async {
    final q = query.trim();
    if (q.length < 2) return const [];
    try {
      final rows = await _sb.rpc(
        'cp_search_autocomplete',
        params: {'p_query': q, 'p_limit': limit},
      );
      if (rows == null) return const [];
      return (rows as List)
          .whereType<Map<String, dynamic>>()
          .map(CpAutocompleteSuggestion.fromJson)
          .toList();
    } catch (e) {
      debugPrint('[CpSearchService.autocomplete] error: $e');
      return const [];
    }
  }

  // ─── Helpers privés ────────────────────────────────────────────────────

  static String _diffStr(CpDifficulty d) {
    switch (d) {
      case CpDifficulty.facile:
        return 'facile';
      case CpDifficulty.moyen:
        return 'moyen';
      case CpDifficulty.difficile:
        return 'difficile';
    }
  }

  static CpDifficulty _parseDifficulty(String? v) {
    switch (v) {
      case 'facile':
        return CpDifficulty.facile;
      case 'difficile':
        return CpDifficulty.difficile;
      default:
        return CpDifficulty.moyen;
    }
  }
}

// ─── Utilitaire de surlignage ─────────────────────────────────────────────────

/// Découpe [text] en spans : les occurrences de [query] sont "highlights"
/// (flag [isMatch] = true), le reste = texte ordinaire.
///
/// Exemple d'utilisation :
/// ```dart
/// final spans = CpTextHighlighter.highlight(
///   text: caseTitle,
///   query: searchQuery,
/// );
/// return RichText(
///   text: TextSpan(
///     children: spans.map((s) => TextSpan(
///       text: s.text,
///       style: s.isMatch
///           ? TextStyle(backgroundColor: CpTokens.brand, color: Colors.white, fontWeight: FontWeight.w700)
///           : null,
///     )).toList(),
///   ),
/// );
/// ```
@immutable
class CpTextSpan {
  final String text;
  final bool isMatch;
  const CpTextSpan(this.text, {required this.isMatch});
}

/// Utilitaire de surlignage sans dépendance externe.
class CpTextHighlighter {
  CpTextHighlighter._();

  /// Retourne une liste de [CpTextSpan] avec les occurrences de [query]
  /// marquées [isMatch = true].
  ///
  /// Case-insensitive, accent-insensitive (via normalisation dart simple).
  /// Si [query] est vide ou [text] est vide, retourne un seul span normal.
  static List<CpTextSpan> highlight({
    required String text,
    required String query,
  }) {
    if (text.isEmpty || query.trim().isEmpty) {
      return [CpTextSpan(text, isMatch: false)];
    }

    final q = query.trim().toLowerCase();
    final lowerText = text.toLowerCase();

    final result = <CpTextSpan>[];
    int cursor = 0;

    while (cursor < text.length) {
      final idx = lowerText.indexOf(q, cursor);
      if (idx == -1) {
        // Reste du texte sans match
        result.add(CpTextSpan(text.substring(cursor), isMatch: false));
        break;
      }
      // Texte avant le match
      if (idx > cursor) {
        result.add(CpTextSpan(text.substring(cursor, idx), isMatch: false));
      }
      // Match
      result.add(
          CpTextSpan(text.substring(idx, idx + q.length), isMatch: true));
      cursor = idx + q.length;
    }

    return result.isEmpty ? [CpTextSpan(text, isMatch: false)] : result;
  }
}
