// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Bookmarks service                                ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-089             ║
// ║                                                                           ║
// ║  Singleton qui gère les bookmarks de cas pratiques :                      ║
// ║   • toggleBookmark(caseId) → bool (nouvel état) via RPC atomique         ║
// ║   • isBookmarked(caseId) sync (depuis cache local)                       ║
// ║   • bookmarksStream() pour rebuild la UI                                  ║
// ║   • Hydratation au login + watch Realtime                                ║
// ║                                                                           ║
// ║  Usage :                                                                  ║
// ║    final isFav = await CpBookmarks.I.toggleBookmark(caseId);             ║
// ║    HapticFeedback.lightImpact();                                          ║
// ║                                                                           ║
// ║    StreamBuilder(                                                         ║
// ║      stream: CpBookmarks.I.bookmarksStream,                              ║
// ║      builder: (_, snap) => Text('${snap.data?.length ?? 0} favoris'),    ║
// ║    )                                                                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ──────────────────────────────────────────────────────────────────────────
//  Modèle d'un bookmark enrichi (depuis la vue cp_my_bookmarks)
// ──────────────────────────────────────────────────────────────────────────

@immutable
class CpBookmark {
  final String caseId;
  final String caseSlug;
  final String caseTitle;
  final int? caseYear;
  final String? themeId;
  final String? difficulty;
  final DateTime bookmarkedAt;
  final String? note;

  const CpBookmark({
    required this.caseId,
    required this.caseSlug,
    required this.caseTitle,
    required this.caseYear,
    required this.themeId,
    required this.difficulty,
    required this.bookmarkedAt,
    required this.note,
  });

  factory CpBookmark.fromMap(Map<String, dynamic> m) {
    return CpBookmark(
      caseId: m['case_id']?.toString() ?? '',
      caseSlug: m['case_slug']?.toString() ?? '',
      caseTitle: m['case_title']?.toString() ?? 'Cas pratique',
      caseYear: (m['case_year'] as num?)?.toInt(),
      themeId: m['theme_id']?.toString(),
      difficulty: m['difficulty']?.toString(),
      bookmarkedAt:
          DateTime.tryParse(m['bookmarked_at']?.toString() ?? '') ??
              DateTime.now(),
      note: m['note']?.toString(),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Singleton
// ──────────────────────────────────────────────────────────────────────────

class CpBookmarks {
  CpBookmarks._();
  static final CpBookmarks I = CpBookmarks._();

  SupabaseClient get _sb => Supabase.instance.client;

  final Set<String> _cachedIds = <String>{};
  final List<CpBookmark> _cachedList = <CpBookmark>[];

  final _controller = StreamController<List<CpBookmark>>.broadcast();
  Stream<List<CpBookmark>> get bookmarksStream => _controller.stream;

  RealtimeChannel? _channel;
  bool _hydrated = false;

  /// True si le cas est dans les favoris (lecture cache, sync).
  bool isBookmarked(String caseId) => _cachedIds.contains(caseId);

  /// Liste actuelle (cache).
  List<CpBookmark> get current => List.unmodifiable(_cachedList);

  /// Nombre de favoris.
  int get count => _cachedList.length;

  // ── Hydratation initiale ────────────────────────────────────────────────

  Future<void> hydrate() async {
    if (_hydrated) return;
    await _refresh();
    _subscribeRealtime();
    _hydrated = true;
  }

  Future<void> _refresh() async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) {
        _cachedIds.clear();
        _cachedList.clear();
        _emit();
        return;
      }

      final data = await _sb
          .from('cp_my_bookmarks')
          .select()
          .order('bookmarked_at', ascending: false);

      _cachedIds.clear();
      _cachedList.clear();
      for (final row in data) {
        final bookmark =
            CpBookmark.fromMap(Map<String, dynamic>.from(row));
        _cachedList.add(bookmark);
        _cachedIds.add(bookmark.caseId);
            }
          _emit();
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[CpBookmarks] refresh error: $e\n$st');
      }
    }
  }

  // ── Toggle (atomique via RPC) ───────────────────────────────────────────

  /// Bascule l'état favori et retourne le nouvel état.
  /// Met à jour le cache optimistiquement, rollback en cas d'erreur.
  Future<bool> toggleBookmark(String caseId) async {
    final wasBookmarked = _cachedIds.contains(caseId);

    // Optimistic update
    if (wasBookmarked) {
      _cachedIds.remove(caseId);
      _cachedList.removeWhere((b) => b.caseId == caseId);
    } else {
      _cachedIds.add(caseId);
      // On ne peut pas ajouter le titre tout de suite — refresh fera le job
    }
    _emit();

    try {
      final result = await _sb.rpc(
        'cp_toggle_bookmark',
        params: {'p_case_id': caseId},
      );
      final newState = result == true;

      // Synchronise le cache après RPC
      if (newState != !wasBookmarked) {
        // L'état réel diverge de l'optimiste → on refresh complet
        await _refresh();
      } else if (!wasBookmarked && newState) {
        // On vient de bookmarker → on récupère les détails
        await _refresh();
      }
      return newState;
    } catch (e, st) {
      // Rollback en cas d'erreur
      if (wasBookmarked) {
        _cachedIds.add(caseId);
      } else {
        _cachedIds.remove(caseId);
      }
      _emit();
      if (kDebugMode) {
        debugPrint('[CpBookmarks] toggle error: $e\n$st');
      }
      rethrow;
    }
  }

  // ── Realtime ────────────────────────────────────────────────────────────

  void _subscribeRealtime() {
    final user = _sb.auth.currentUser;
    if (user == null) return;
    _channel?.unsubscribe();

    _channel = _sb
        .channel('cp_bookmarks_${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'cas_pratique_user_bookmarks',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: user.id,
          ),
          callback: (_) => _refresh(),
        )
        .subscribe();
  }

  Future<void> stop() async {
    await _channel?.unsubscribe();
    _channel = null;
    _hydrated = false;
    _cachedIds.clear();
    _cachedList.clear();
    _emit();
  }

  // ── Helpers internes ────────────────────────────────────────────────────

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(List<CpBookmark>.unmodifiable(_cachedList));
  }
}
