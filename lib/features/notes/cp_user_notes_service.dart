// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — User notes service                               ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-091             ║
// ║                                                                           ║
// ║  CRUD des annotations privées de l'utilisateur sur sa copie corrigée.    ║
// ║                                                                           ║
// ║  Usage :                                                                  ║
// ║   await CpUserNotes.I.create(                                            ║
// ║     body: 'À revoir avant le concours',                                  ║
// ║     attemptId: attempt.id,                                                ║
// ║     questionId: q.id,                                                     ║
// ║     tags: ['revoir', 'important'],                                       ║
// ║   );                                                                      ║
// ║                                                                           ║
// ║   final notes = await CpUserNotes.I.listForAttempt(attempt.id);         ║
// ║   final search = await CpUserNotes.I.search('article 122');             ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ──────────────────────────────────────────────────────────────────────────
//  Modèle
// ──────────────────────────────────────────────────────────────────────────

@immutable
class CpUserNote {
  final String id;
  final String userId;
  final String? attemptId;
  final String? questionId;
  final String? rubricPointId;
  final String? caseId;
  final String body;
  final List<String> tags;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Champs enrichis (depuis la vue cp_my_notes_enriched)
  final String? caseSlug;
  final String? caseTitle;
  final int? caseYear;
  final int? questionPosition;

  const CpUserNote({
    required this.id,
    required this.userId,
    required this.attemptId,
    required this.questionId,
    required this.rubricPointId,
    required this.caseId,
    required this.body,
    required this.tags,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    this.caseSlug,
    this.caseTitle,
    this.caseYear,
    this.questionPosition,
  });

  factory CpUserNote.fromMap(Map<String, dynamic> m) {
    final tagsRaw = m['tags'];
    final tags = <String>[];
    if (tagsRaw is List) {
      for (final t in tagsRaw) {
        if (t is String) tags.add(t);
      }
    }
    return CpUserNote(
      id: m['id']?.toString() ?? '',
      userId: m['user_id']?.toString() ?? '',
      attemptId: m['attempt_id']?.toString(),
      questionId: m['question_id']?.toString(),
      rubricPointId: m['rubric_point_id']?.toString(),
      caseId: m['case_id']?.toString(),
      body: m['body']?.toString() ?? '',
      tags: tags,
      color: m['color']?.toString(),
      createdAt: DateTime.tryParse(m['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(m['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      caseSlug: m['case_slug']?.toString(),
      caseTitle: m['case_title']?.toString(),
      caseYear: (m['case_year'] as num?)?.toInt(),
      questionPosition: (m['question_position'] as num?)?.toInt(),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Singleton service
// ──────────────────────────────────────────────────────────────────────────

class CpUserNotes {
  CpUserNotes._();
  static final CpUserNotes I = CpUserNotes._();

  SupabaseClient get _sb => Supabase.instance.client;

  // ── Create ─────────────────────────────────────────────────────────────

  Future<CpUserNote?> create({
    required String body,
    String? attemptId,
    String? questionId,
    String? rubricPointId,
    String? caseId,
    List<String> tags = const [],
    String? color,
  }) async {
    try {
      final user = _sb.auth.currentUser;
      if (user == null) return null;
      if (body.trim().isEmpty) return null;
      if (body.length > 2000) return null;

      final inserted = await _sb
          .from('cas_pratique_user_notes')
          .insert({
            'user_id': user.id,
            if (attemptId != null) 'attempt_id': attemptId,
            if (questionId != null) 'question_id': questionId,
            if (rubricPointId != null) 'rubric_point_id': rubricPointId,
            if (caseId != null) 'case_id': caseId,
            'body': body.trim(),
            'tags': tags,
            if (color != null) 'color': color,
          })
          .select()
          .maybeSingle();

      if (inserted == null) return null;
      return CpUserNote.fromMap(Map<String, dynamic>.from(inserted));
    } catch (e, st) {
      if (kDebugMode) debugPrint('[CpUserNotes] create error: $e\n$st');
      return null;
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────

  Future<bool> update({
    required String noteId,
    String? body,
    List<String>? tags,
    String? color,
  }) async {
    try {
      final payload = <String, Object?>{};
      if (body != null) {
        final trimmed = body.trim();
        if (trimmed.isEmpty || trimmed.length > 2000) return false;
        payload['body'] = trimmed;
      }
      if (tags != null) payload['tags'] = tags;
      if (color != null) payload['color'] = color;
      if (payload.isEmpty) return false;

      await _sb
          .from('cas_pratique_user_notes')
          .update(payload)
          .eq('id', noteId);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('[CpUserNotes] update error: $e');
      return false;
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────

  Future<bool> delete(String noteId) async {
    try {
      await _sb
          .from('cas_pratique_user_notes')
          .delete()
          .eq('id', noteId);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('[CpUserNotes] delete error: $e');
      return false;
    }
  }

  // ── Read ───────────────────────────────────────────────────────────────

  Future<List<CpUserNote>> listAll({int limit = 100}) async {
    try {
      final data = await _sb
          .from('cp_my_notes_enriched')
          .select()
          .limit(limit);
      return data
          .whereType<Map>()
          .map((m) => CpUserNote.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint('[CpUserNotes] listAll error: $e');
      return const [];
    }
  }

  Future<List<CpUserNote>> listForAttempt(String attemptId) async {
    try {
      final data = await _sb
          .from('cp_my_notes_enriched')
          .select()
          .eq('attempt_id', attemptId);
      return data
          .whereType<Map>()
          .map((m) => CpUserNote.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint('[CpUserNotes] listForAttempt error: $e');
      return const [];
    }
  }

  Future<List<CpUserNote>> listForCase(String caseId) async {
    try {
      final data = await _sb
          .from('cp_my_notes_enriched')
          .select()
          .eq('case_id', caseId);
      return data
          .whereType<Map>()
          .map((m) => CpUserNote.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint('[CpUserNotes] listForCase error: $e');
      return const [];
    }
  }

  // ── Search ─────────────────────────────────────────────────────────────

  Future<List<CpUserNote>> search(String query, {int limit = 30}) async {
    try {
      final trimmed = query.trim();
      if (trimmed.isEmpty) return listAll(limit: limit);
      final data = await _sb.rpc(
        'cp_search_notes',
        params: {
          'p_query': trimmed,
          'p_limit': limit,
        },
      );
      if (data is! List) return const [];
      return data
          .whereType<Map>()
          .map((m) => CpUserNote.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint('[CpUserNotes] search error: $e');
      return const [];
    }
  }
}
