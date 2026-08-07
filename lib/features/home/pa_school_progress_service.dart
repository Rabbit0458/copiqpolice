import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import 'pa_exam_progress_calculator.dart';
import 'pa_exam_progress_models.dart';
import 'pa_exam_progress_service.dart';
import 'pa_exam_progress_source_registry.dart';

/// Source de vérité du suivi « Scolarité — Policier Adjoint ».
///
/// Les quiz de scolarité utilisent déjà `quiz_history` avec le contexte
/// utilisateur courant. Ce service isole strictement `pa / school` afin de ne
/// jamais mélanger les résultats du concours, de GPX ou d'un autre parcours.
class PaSchoolProgressService implements PaExamProgressDataSource {
  PaSchoolProgressService({SupabaseClient? client})
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
          .eq('track', 'pa')
          .eq('mode', 'school')
          .not('finished_at', 'is', null)
          .order('finished_at', ascending: false)
          .limit(750);

      final activities = List<Map<String, dynamic>>.from(rows as List)
          .map(_activityFromRow)
          .where((activity) => activity.finishedAt.year > 2000)
          .toList(growable: false);

      final snapshot = _calculator.build(
        activities: activities,
        errors: const [],
        dailyGoal: await _loadDailyGoal(),
        now: DateTime.now(),
      );
      return PaProgressLoaded(snapshot);
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

  PaProgressActivity _activityFromRow(Map<String, dynamic> row) {
    final module = (row['module_name'] ?? '').toString().trim();
    final quiz = (row['quiz_name'] ?? '').toString().trim();
    final title = quiz.isNotEmpty ? quiz : module;
    final key = paSchoolModuleKey(title);
    final meta = paSchoolModuleMeta(key);
    return PaProgressActivity(
      id: 'pa-school:${row['id']}',
      source: PaProgressSource.quiz,
      moduleKey: key,
      moduleLabel: meta.label,
      title: title.isEmpty ? 'Quiz de scolarité' : title,
      correct: _integer(row['correct_count']),
      total: _integer(row['total_questions']),
      finishedAt: _date(row['finished_at'] ?? row['completed_at']),
      route: meta.route,
    );
  }

  @override
  Future<void> saveDailyGoal(int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('pa_school_daily_goal', value.clamp(1, 10));
  }

  Future<int> _loadDailyGoal() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getInt('pa_school_daily_goal') ?? 3).clamp(1, 10);
  }

  int _integer(dynamic value) =>
      value is num ? value.round() : int.tryParse('$value') ?? 0;

  DateTime _date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '')?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

String paSchoolModuleKey(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('institution') ||
      normalized.contains('déontolog') ||
      normalized.contains('deontolog') ||
      normalized.contains('hiérarch') ||
      normalized.contains('hierarch')) {
    return 'institutions_valeurs';
  }
  if (normalized.contains('rout') ||
      normalized.contains('circulation') ||
      normalized.contains('véhicule')) {
    return 'circulation_routiere';
  }
  if (normalized.contains('pénal') ||
      normalized.contains('penal') ||
      normalized.contains('dps') ||
      normalized.contains('dpg') ||
      normalized.contains('enquête') ||
      normalized.contains('enquete')) {
    return 'dps_dpg';
  }
  if (normalized.contains('intervention') ||
      normalized.contains('patrouille') ||
      normalized.contains('radio')) {
    return 'intervention';
  }
  return 'fondamentaux';
}

PaProgressModuleMeta paSchoolModuleMeta(String key) => switch (key) {
  'institutions_valeurs' => const PaProgressModuleMeta(
    key: 'institutions_valeurs',
    label: 'Institution & valeurs',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF2563EB),
    route: '/pa/institution/deontologie/quiz',
  ),
  'circulation_routiere' => const PaProgressModuleMeta(
    key: 'circulation_routiere',
    label: 'Circulation routière',
    icon: Icons.directions_car_filled_rounded,
    color: Color(0xFF0F766E),
    route: '/pa/dps_dpg/quiz/quiz_circulation_routiere',
  ),
  'dps_dpg' => const PaProgressModuleMeta(
    key: 'dps_dpg',
    label: 'DPS / DPG',
    icon: Icons.gavel_rounded,
    color: Color(0xFF7C3AED),
    route: '/home-pa-school',
  ),
  'intervention' => const PaProgressModuleMeta(
    key: 'intervention',
    label: 'Intervention professionnelle',
    icon: Icons.local_police_rounded,
    color: Color(0xFFEA580C),
    route: '/home-pa-school',
  ),
  _ => const PaProgressModuleMeta(
    key: 'fondamentaux',
    label: 'Fondamentaux de scolarité',
    icon: Icons.school_rounded,
    color: Color(0xFF64748B),
    route: '/home-pa-school',
  ),
};
