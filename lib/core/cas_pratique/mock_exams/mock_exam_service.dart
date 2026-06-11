// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Mock exam service (concours blanc)            ║
// ║  Tâche      : CODE-061                                                  ║
// ║                                                                         ║
// ║  Service singleton qui consomme :                                       ║
// ║   - fn_cp_start_mock_exam(p_mock_exam_id)  → crée/reprend l'attempt     ║
// ║   - fn_cp_finish_mock_exam(p_mock_attempt_id) → finalise                ║
// ║   - fn_cp_mock_exam_leaderboard(p_mock_exam_id, p_limit)                ║
// ║                                                                         ║
// ║  + accès direct aux tables `cas_pratique_mock_exams`,                   ║
// ║  `cas_pratique_mock_exam_answers` (autosave réponse par question).      ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockExam {
  final String id;
  final String slug;
  final String title;
  final String? description;
  final int totalMinutes;
  final int totalPoints;
  final String status;

  const MockExam({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.totalMinutes,
    required this.totalPoints,
    required this.status,
  });

  factory MockExam.fromJson(Map<String, dynamic> j) => MockExam(
        id: j['id'] as String,
        slug: j['slug'] as String,
        title: j['title'] as String? ?? '',
        description: j['description'] as String?,
        totalMinutes:
            (j['total_minutes'] is num) ? (j['total_minutes'] as num).toInt() : 45,
        totalPoints:
            (j['total_points'] is num) ? (j['total_points'] as num).toInt() : 20,
        status: j['status'] as String? ?? 'draft',
      );
}

class MockExamAttempt {
  final String attemptId;
  final DateTime deadlineAt;
  final bool resumed;

  const MockExamAttempt({
    required this.attemptId,
    required this.deadlineAt,
    required this.resumed,
  });

  Duration remaining([DateTime? now]) {
    final n = now ?? DateTime.now().toUtc();
    final d = deadlineAt.difference(n);
    return d.isNegative ? Duration.zero : d;
  }
}

enum FinishStatus { submitted, expired, alreadyFinalized, notOwner, notFound, unknown }

class FinishResult {
  final bool ok;
  final FinishStatus status;
  final DateTime? finishedAt;

  const FinishResult({required this.ok, required this.status, this.finishedAt});
}

class MockLeaderboardEntry {
  final int rank;
  final String anonHandle;
  final double? percent;
  final double? totalScore;
  final int? timeSpentMs;
  final DateTime? submittedAt;
  final bool isSelf;

  const MockLeaderboardEntry({
    required this.rank,
    required this.anonHandle,
    required this.percent,
    required this.totalScore,
    required this.timeSpentMs,
    required this.submittedAt,
    required this.isSelf,
  });

  factory MockLeaderboardEntry.fromJson(Map<String, dynamic> j) =>
      MockLeaderboardEntry(
        rank: (j['rank'] is num) ? (j['rank'] as num).toInt() : 0,
        anonHandle: (j['anon_handle'] ?? '') as String,
        percent: (j['percent'] is num) ? (j['percent'] as num).toDouble() : null,
        totalScore: (j['total_score'] is num)
            ? (j['total_score'] as num).toDouble()
            : null,
        timeSpentMs: (j['time_spent_ms'] is num)
            ? (j['time_spent_ms'] as num).toInt()
            : null,
        submittedAt: j['submitted_at'] == null
            ? null
            : DateTime.tryParse(j['submitted_at'].toString())?.toUtc(),
        isSelf: j['is_self'] == true,
      );
}

class MockExamService {
  MockExamService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final MockExamService instance = MockExamService._();

  final SupabaseClient _sb;

  /// Liste les concours blancs publiés.
  Future<List<MockExam>> listPublished() async {
    try {
      final rows = await _sb
          .from('cas_pratique_mock_exams')
          .select('id, slug, title, description, total_minutes, total_points, status')
          .eq('status', 'published')
          .order('created_at', ascending: false);
      return (rows as List)
          .whereType<Map<String, dynamic>>()
          .map(MockExam.fromJson)
          .toList(growable: false);
    } catch (e) {
      if (kDebugMode) debugPrint('[MockExamService] listPublished failed: $e');
      return const [];
    }
  }

  /// Démarre (ou reprend) une tentative.
  Future<MockExamAttempt?> startOrResume(String mockExamId) async {
    try {
      final raw = await _sb.rpc(
        'fn_cp_start_mock_exam',
        params: {'p_mock_exam_id': mockExamId},
      );
      final m = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
      if (m['ok'] != true) return null;
      return MockExamAttempt(
        attemptId: m['attempt_id'] as String,
        deadlineAt: DateTime.parse(m['deadline_at'].toString()).toUtc(),
        resumed: m['resumed'] == true,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[MockExamService] startOrResume failed: $e');
      return null;
    }
  }

  /// Sauvegarde une réponse (upsert sur (mock_attempt_id, question_id)).
  Future<void> saveAnswer({
    required String mockAttemptId,
    required String questionId,
    required String text,
  }) async {
    try {
      await _sb.from('cas_pratique_mock_exam_answers').upsert(
        {
          'mock_attempt_id': mockAttemptId,
          'question_id': questionId,
          'text': text,
          'char_count': text.length,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'mock_attempt_id,question_id',
        ignoreDuplicates: false,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[MockExamService] saveAnswer failed: $e');
    }
  }

  /// Soumet (ou expire) une tentative.
  Future<FinishResult> finish(String mockAttemptId) async {
    try {
      final raw = await _sb.rpc(
        'fn_cp_finish_mock_exam',
        params: {'p_mock_attempt_id': mockAttemptId},
      );
      final m = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
      if (m['ok'] != true) {
        final err = (m['error'] ?? '').toString();
        FinishStatus status;
        switch (err) {
          case 'already_finalized': status = FinishStatus.alreadyFinalized; break;
          case 'not_owner':         status = FinishStatus.notOwner;         break;
          case 'attempt_not_found': status = FinishStatus.notFound;         break;
          default:                  status = FinishStatus.unknown;
        }
        return FinishResult(ok: false, status: status);
      }
      final st = (m['status'] ?? '').toString();
      return FinishResult(
        ok: true,
        status: st == 'expired' ? FinishStatus.expired : FinishStatus.submitted,
        finishedAt: m['finished_at'] == null
            ? null
            : DateTime.tryParse(m['finished_at'].toString())?.toUtc(),
      );
    } catch (e) {
      if (kDebugMode) debugPrint('[MockExamService] finish failed: $e');
      return const FinishResult(ok: false, status: FinishStatus.unknown);
    }
  }

  /// Classement post-soumission.
  Future<List<MockLeaderboardEntry>> getLeaderboard(
    String mockExamId, {
    int limit = 100,
  }) async {
    try {
      final raw = await _sb.rpc(
        'fn_cp_mock_exam_leaderboard',
        params: {'p_mock_exam_id': mockExamId, 'p_limit': limit},
      );
      if (raw is! List) return const [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(MockLeaderboardEntry.fromJson)
          .toList(growable: false);
    } catch (e) {
      if (kDebugMode) debugPrint('[MockExamService] getLeaderboard failed: $e');
      return const [];
    }
  }
}
