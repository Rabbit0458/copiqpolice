import 'package:supabase_flutter/supabase_flutter.dart';

import 'pa_exam_progress_models.dart';
import 'pa_exam_progress_source_registry.dart';

class PaExamProgressRepository {
  PaExamProgressRepository(this._client);
  final SupabaseClient _client;

  Future<List<PaProgressActivity>> fetchQuizActivities(String userId) async {
    final rows = await _client
        .from('quiz_history')
        .select(
          'id, module_name, quiz_name, correct_count, total_questions, '
          'started_at, finished_at, completed_at',
        )
        .eq('uid', userId)
        .eq('track', 'pa')
        .eq('mode', 'exam')
        .not('completed_at', 'is', null)
        .order('finished_at', ascending: false)
        .limit(500);

    return List<Map<String, dynamic>>.from(rows as List)
        .map((row) {
          final moduleName = (row['module_name'] ?? '').toString().trim();
          final quizName = (row['quiz_name'] ?? '').toString().trim();
          final key = paModuleKeyFromNames(moduleName, quizName);
          final meta = paModuleMeta(key);
          return PaProgressActivity(
            id: 'quiz:${row['id']}',
            source: PaProgressSource.quiz,
            moduleKey: key,
            moduleLabel: meta.label,
            title: _cleanTitle(quizName.isEmpty ? moduleName : quizName),
            correct: _integer(row['correct_count']),
            total: _integer(row['total_questions']),
            finishedAt: _date(row['finished_at'] ?? row['completed_at']),
            route: meta.route,
          );
        })
        .where((activity) => activity.finishedAt.year > 2000)
        .toList();
  }

  Future<List<PaProgressActivity>> fetchPsychotechniqueActivities(
    String userId,
  ) async {
    final rows = await _client
        .from('tests_psychotechnique_history')
        .select(
          'id, exercise_type, correct_answers, total_questions, '
          'duration_seconds, created_at',
        )
        .eq('user_id', userId)
        .eq('module', 'pa_psychotechnique')
        .eq('mode', 'concours')
        .order('created_at', ascending: false)
        .limit(300);
    final meta = paModuleMeta('psychotechnique');
    return List<Map<String, dynamic>>.from(rows as List)
        .map((row) {
          final type = (row['exercise_type'] ?? '').toString();
          return PaProgressActivity(
            id: 'psy:${row['id']}',
            source: PaProgressSource.psychotechnique,
            moduleKey: 'psychotechnique',
            moduleLabel: meta.label,
            title: _psyTitle(type),
            correct: _integer(row['correct_answers']),
            total: _integer(row['total_questions']),
            durationSeconds: _integer(row['duration_seconds']),
            finishedAt: _date(row['created_at']),
            route: meta.route,
          );
        })
        .where((activity) => activity.finishedAt.year > 2000)
        .toList();
  }

  Future<List<PaProgressActivity>> fetchPhotolangageActivities(
    String userId,
  ) async {
    final rows = await _client
        .from('photolangage_attempts')
        .select(
          'id, case_id, pedagogical_score, elapsed_seconds, submitted_at, '
          'created_at, status',
        )
        .eq('user_id', userId)
        .eq('track', 'pa')
        .eq('mode', 'exam')
        .eq('status', 'submitted')
        .order('submitted_at', ascending: false)
        .limit(100);
    final meta = paModuleMeta('photolangage');
    return List<Map<String, dynamic>>.from(rows as List)
        .map((row) {
          final score = _integer(row['pedagogical_score']).clamp(0, 100);
          return PaProgressActivity(
            id: 'photo:${row['id']}',
            source: PaProgressSource.photolangage,
            moduleKey: 'photolangage',
            moduleLabel: meta.label,
            title: 'Exercice de photolangage',
            correct: score,
            total: 100,
            durationSeconds: _integer(row['elapsed_seconds']),
            finishedAt: _date(row['submitted_at'] ?? row['created_at']),
            route: meta.route,
          );
        })
        .where((activity) => activity.finishedAt.year > 2000)
        .toList();
  }

  Future<List<PaProgressErrorSummary>> fetchErrorSummaries(
    String userId,
  ) async {
    final rows = await _client
        .from('quiz_answer_history')
        .select('module_key, is_correct')
        .eq('user_id', userId)
        .eq('track', 'pa')
        .eq('mode', 'exam')
        .order('answered_at', ascending: false)
        .limit(1000);
    final totals = <String, int>{};
    final wrong = <String, int>{};
    for (final row in List<Map<String, dynamic>>.from(rows as List)) {
      final key = (row['module_key'] ?? 'autres').toString();
      totals[key] = (totals[key] ?? 0) + 1;
      if (row['is_correct'] != true) wrong[key] = (wrong[key] ?? 0) + 1;
    }
    final result = totals.entries
        .map(
          (entry) => PaProgressErrorSummary(
            moduleKey: entry.key,
            moduleLabel: paModuleMeta(entry.key).label,
            wrongCount: wrong[entry.key] ?? 0,
            totalCount: entry.value,
          ),
        )
        .where((item) => item.wrongCount > 0)
        .toList();
    result.sort((a, b) => b.wrongCount.compareTo(a.wrongCount));
    return result;
  }

  Future<PaPlacementBaseline?> fetchPlacement(String userId) async {
    final rows = await _client
        .from('placement_results')
        .select('score_pct, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1);
    final list = List<Map<String, dynamic>>.from(rows as List);
    if (list.isEmpty) return null;
    return PaPlacementBaseline(
      percent: _integer(list.first['score_pct']).clamp(0, 100),
      createdAt: _date(list.first['created_at']),
    );
  }

  int _integer(dynamic value) =>
      value is num ? value.round() : int.tryParse('$value') ?? 0;

  DateTime _date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '')?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);

  String _cleanTitle(String value) => value
      .replaceFirst(RegExp(r'^PA\s*-\s*', caseSensitive: false), '')
      .replaceFirst(RegExp(r'^Quiz\s+', caseSensitive: false), '')
      .trim();

  String _psyTitle(String type) => switch (type) {
    'attention_visuelle' => 'Attention visuelle',
    'suite_logique' => 'Suites logiques',
    'calcul' || 'calcul_mental' => 'Calcul mental',
    'concentration' => 'Concentration',
    'verbal' || 'logique_verbale' => 'Logique verbale',
    'raisonnement' || 'raisonnement_logique' => 'Raisonnement logique',
    _ => 'Exercice psychotechnique',
  };
}
