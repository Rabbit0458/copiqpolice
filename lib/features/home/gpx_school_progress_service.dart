import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pa_exam_progress_calculator.dart';
import 'pa_exam_progress_models.dart';
import 'pa_exam_progress_service.dart';
import 'pa_exam_progress_source_registry.dart';
import 'quiz_progress_enrichment.dart';

/// Source de vérité du suivi « Scolarité — Gardien de la paix ».
///
/// Le filtre serveur `gpx / school` empêche tout mélange avec les résultats
/// du concours GPX, de Policier adjoint ou d'un autre parcours.
class GpxSchoolProgressService implements PaExamProgressDataSource {
  GpxSchoolProgressService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final _calculator = const PaExamProgressCalculator();

  @override
  Future<PaProgressLoadResult> load() async {
    final user = _client.auth.currentUser;
    if (user == null) return const PaProgressSignedOut();

    try {
      final rows = await _client
          .from('quiz_history')
          .select(
            'id, module_name, quiz_name, correct_count, total_questions, '
            'started_at, finished_at, completed_at',
          )
          .eq('uid', user.id)
          .eq('track', 'gpx')
          .eq('mode', 'school')
          .order('started_at', ascending: false)
          .limit(750);

      final rawActivities = List<Map<String, dynamic>>.from(rows as List)
          .map(_activityFromRow)
          .where((activity) => activity.finishedAt.year > 2000)
          .toList(growable: false);
      final activities = await enrichQuizProgress(
        client: _client,
        userId: user.id,
        track: 'gpx',
        mode: 'school',
        activities: rawActivities,
      );

      return PaProgressLoaded(
        _calculator.build(
          activities: activities,
          errors: _errorSummaries(activities),
          dailyGoal: await _loadDailyGoal(),
          now: DateTime.now(),
        ),
      );
    } on PostgrestException catch (error) {
      if (error.code == '42501') {
        return const PaProgressLoadFailure(
          'Tes résultats sont protégés mais leur accès doit être rétabli.',
        );
      }
      return const PaProgressLoadFailure(
        'Impossible de charger ton suivi de scolarité pour le moment.',
      );
    } catch (_) {
      return const PaProgressLoadFailure(
        'Impossible de charger ton suivi de scolarité pour le moment.',
      );
    }
  }

  List<PaProgressErrorSummary> _errorSummaries(
    List<PaProgressActivity> activities,
  ) {
    final totals = <String, int>{};
    final wrong = <String, int>{};
    for (final activity in activities) {
      for (final answer in activity.answers) {
        totals[activity.moduleKey] = (totals[activity.moduleKey] ?? 0) + 1;
        if (!answer.isCorrect) {
          wrong[activity.moduleKey] = (wrong[activity.moduleKey] ?? 0) + 1;
        }
      }
    }
    return totals.entries
        .where((entry) => (wrong[entry.key] ?? 0) > 0)
        .map(
          (entry) => PaProgressErrorSummary(
            moduleKey: entry.key,
            moduleLabel: gpxSchoolModuleMeta(entry.key).label,
            wrongCount: wrong[entry.key] ?? 0,
            totalCount: entry.value,
          ),
        )
        .toList(growable: false)
      ..sort((a, b) => b.wrongCount.compareTo(a.wrongCount));
  }

  PaProgressActivity _activityFromRow(Map<String, dynamic> row) {
    final module = (row['module_name'] ?? '').toString().trim();
    final quiz = (row['quiz_name'] ?? '').toString().trim();
    final title = quiz.isNotEmpty ? quiz : module;
    final key = gpxSchoolModuleKey(title);
    final meta = gpxSchoolModuleMeta(key);
    return PaProgressActivity(
      id: 'gpx-school:${row['id']}',
      source: PaProgressSource.quiz,
      moduleKey: key,
      moduleLabel: meta.label,
      title: title.isEmpty ? 'Quiz de scolarité' : title,
      correct: _integer(row['correct_count']),
      total: _integer(row['total_questions']),
      finishedAt: _date(
        row['finished_at'] ?? row['completed_at'] ?? row['started_at'],
      ),
      route: meta.route,
    );
  }

  @override
  Future<void> saveDailyGoal(int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('gpx_school_daily_goal', value.clamp(1, 10));
  }

  Future<int> _loadDailyGoal() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getInt('gpx_school_daily_goal') ?? 3).clamp(1, 10);
  }

  int _integer(dynamic value) =>
      value is num ? value.round() : int.tryParse('$value') ?? 0;

  DateTime _date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '')?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

String gpxSchoolModuleKey(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('institution') ||
      normalized.contains('organisation') ||
      normalized.contains('déontolog') ||
      normalized.contains('deontolog') ||
      normalized.contains('hiérarch')) {
    return 'institution_organisation';
  }
  if (normalized.contains('judiciaire') ||
      normalized.contains('pénal') ||
      normalized.contains('penal') ||
      normalized.contains('enquête') ||
      normalized.contains('enquete')) {
    return 'police_judiciaire';
  }
  if (normalized.contains('rout') || normalized.contains('circulation')) {
    return 'securite_routiere';
  }
  if (normalized.contains('intervention') ||
      normalized.contains('patrouille') ||
      normalized.contains('violence') ||
      normalized.contains('arme')) {
    return 'intervention';
  }
  if (normalized.contains('accueil') ||
      normalized.contains('victime') ||
      normalized.contains('public')) {
    return 'public_victimes';
  }
  return 'fondamentaux';
}

PaProgressModuleMeta gpxSchoolModuleMeta(String key) => switch (key) {
  'institution_organisation' => const PaProgressModuleMeta(
    key: 'institution_organisation',
    label: 'Institution & organisation',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF2563EB),
    route: '/home-gpx-school',
  ),
  'police_judiciaire' => const PaProgressModuleMeta(
    key: 'police_judiciaire',
    label: 'Police judiciaire & droit pénal',
    icon: Icons.gavel_rounded,
    color: Color(0xFF7C3AED),
    route: '/home-gpx-school',
  ),
  'securite_routiere' => const PaProgressModuleMeta(
    key: 'securite_routiere',
    label: 'Sécurité routière',
    icon: Icons.directions_car_filled_rounded,
    color: Color(0xFF0F766E),
    route: '/home-gpx-school',
  ),
  'intervention' => const PaProgressModuleMeta(
    key: 'intervention',
    label: 'Intervention professionnelle',
    icon: Icons.local_police_rounded,
    color: Color(0xFFEA580C),
    route: '/home-gpx-school',
  ),
  'public_victimes' => const PaProgressModuleMeta(
    key: 'public_victimes',
    label: 'Accueil du public & victimes',
    icon: Icons.support_agent_rounded,
    color: Color(0xFFDB2777),
    route: '/home-gpx-school',
  ),
  _ => const PaProgressModuleMeta(
    key: 'fondamentaux',
    label: 'Fondamentaux de scolarité',
    icon: Icons.school_rounded,
    color: Color(0xFF64748B),
    route: '/home-gpx-school',
  ),
};
