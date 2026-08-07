import 'package:supabase_flutter/supabase_flutter.dart';

import 'gpx_exam_progress_source_registry.dart';
import 'pa_exam_progress_models.dart';

class GpxExamProgressRepository {
  GpxExamProgressRepository(this._client);
  final SupabaseClient _client;

  Future<List<PaProgressActivity>> fetchQuizActivities(String userId) async {
    final rows = await _client
        .from('quiz_history')
        .select(
          'id, module_name, quiz_name, correct_count, total_questions, '
          'started_at, finished_at, completed_at',
        )
        .eq('uid', userId)
        .eq('track', 'gpx')
        .eq('mode', 'exam')
        .not('completed_at', 'is', null)
        .order('finished_at', ascending: false)
        .limit(500);

    return List<Map<String, dynamic>>.from(rows as List)
        .map((row) {
          final moduleName = (row['module_name'] ?? '').toString().trim();
          final quizName = (row['quiz_name'] ?? '').toString().trim();
          final key = gpxModuleKeyFromNames(moduleName, quizName);
          final meta = gpxModuleMeta(key);
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
        .eq('module', 'psychotechnique')
        .inFilter('mode', ['concours', 'concours_global'])
        .order('created_at', ascending: false)
        .limit(300);
    final meta = gpxModuleMeta('psychotechnique');
    return List<Map<String, dynamic>>.from(rows as List)
        .map(
          (row) => PaProgressActivity(
            id: 'psy:${row['id']}',
            source: PaProgressSource.psychotechnique,
            moduleKey: 'psychotechnique',
            moduleLabel: meta.label,
            title: _psyTitle((row['exercise_type'] ?? '').toString()),
            correct: _integer(row['correct_answers']),
            total: _integer(row['total_questions']),
            durationSeconds: _integer(row['duration_seconds']),
            finishedAt: _date(row['created_at']),
            route: meta.route,
          ),
        )
        .where((activity) => activity.finishedAt.year > 2000)
        .toList();
  }

  Future<List<PaProgressActivity>> fetchCaseActivities(String userId) async {
    final rows = await _client
        .from('cas_pratique_attempts')
        .select(
          'id,percent,time_spent_ms,finished_at,status,'
          'cas_pratique_cases(title)',
        )
        .eq('user_id', userId)
        .eq('status', 'completed')
        .not('finished_at', 'is', null)
        .order('finished_at', ascending: false)
        .limit(200);
    final meta = gpxModuleMeta('cas_pratique');
    return List<Map<String, dynamic>>.from(rows as List)
        .map((row) {
          final caseData = row['cas_pratique_cases'];
          final caseTitle = caseData is Map
              ? (caseData['title'] ?? '').toString().trim()
              : '';
          final percent = _integer(row['percent']).clamp(0, 100);
          return PaProgressActivity(
            id: 'case:${row['id']}',
            source: PaProgressSource.casePractical,
            moduleKey: 'cas_pratique',
            moduleLabel: meta.label,
            title: caseTitle.isEmpty ? 'Cas pratique' : caseTitle,
            correct: percent,
            total: 100,
            durationSeconds: (_integer(row['time_spent_ms']) / 1000).round(),
            finishedAt: _date(row['finished_at']),
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
        .eq('track', 'gpx')
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
    final result =
        totals.entries
            .map(
              (entry) => PaProgressErrorSummary(
                moduleKey: entry.key,
                moduleLabel: gpxModuleMeta(entry.key).label,
                wrongCount: wrong[entry.key] ?? 0,
                totalCount: entry.value,
              ),
            )
            .where((item) => item.wrongCount > 0)
            .toList()
          ..sort((a, b) => b.wrongCount.compareTo(a.wrongCount));
    return result;
  }

  int _integer(dynamic value) =>
      value is num ? value.round() : int.tryParse('$value') ?? 0;

  DateTime _date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '')?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);

  String _cleanTitle(String value) => value
      .replaceFirst(RegExp(r'^GPX\s*-\s*', caseSensitive: false), '')
      .replaceFirst(RegExp(r'^Quiz\s+', caseSensitive: false), '')
      .trim();

  String _psyTitle(String type) => switch (type) {
    'attention_visuelle' => 'Attention visuelle',
    'suite_logique' => 'Suites logiques',
    'calcul' || 'calcul_mental' => 'Calcul mental',
    'concentration' => 'Concentration',
    'verbal' || 'logique_verbale' => 'Logique verbale',
    'raisonnement' || 'raisonnement_logique' => 'Raisonnement logique',
    'spatial' || 'raisonnement_spatial' => 'Raisonnement spatial',
    'rotations' => 'Rotations et symétries',
    'mode_concours_global' => 'Mode concours',
    _ => 'Exercice psychotechnique',
  };
}
