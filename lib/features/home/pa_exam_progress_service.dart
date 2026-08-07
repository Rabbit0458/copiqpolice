import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pa_exam_progress_calculator.dart';
import 'pa_exam_progress_models.dart';
import 'pa_exam_progress_repository.dart';

abstract interface class PaExamProgressDataSource {
  Future<PaProgressLoadResult> load();
  Future<void> saveDailyGoal(int value);
}

class PaExamProgressService implements PaExamProgressDataSource {
  PaExamProgressService({
    SupabaseClient? client,
    PaExamProgressCalculator calculator = const PaExamProgressCalculator(),
  }) : _client = client ?? Supabase.instance.client,
       _calculator = calculator;

  final SupabaseClient _client;
  final PaExamProgressCalculator _calculator;

  @override
  Future<PaProgressLoadResult> load() async {
    final user = _client.auth.currentUser;
    if (user == null) return const PaProgressSignedOut();
    final repository = PaExamProgressRepository(_client);
    try {
      final primary = await repository.fetchQuizActivities(user.id);
      final warnings = <String>[];

      Future<T?> optional<T extends Object>(
        Future<T?> future,
        String label,
      ) async {
        try {
          return await future;
        } catch (_) {
          warnings.add(label);
          return null;
        }
      }

      final results = await Future.wait<Object?>([
        optional(
          repository.fetchPsychotechniqueActivities(user.id),
          'psychotechniques',
        ),
        optional(
          repository.fetchPhotolangageActivities(user.id),
          'photolangage',
        ),
        optional(repository.fetchErrorSummaries(user.id), 'erreurs détaillées'),
        optional(repository.fetchPlacement(user.id), 'positionnement'),
        _loadDailyGoal(),
      ]);
      final activities = <PaProgressActivity>[
        ...primary,
        ...?results[0] as List<PaProgressActivity>?,
        ...?results[1] as List<PaProgressActivity>?,
      ];
      final snapshot = _calculator.build(
        activities: activities,
        errors: results[2] as List<PaProgressErrorSummary>? ?? const [],
        dailyGoal: results[4] as int? ?? 3,
        now: DateTime.now(),
        placement: results[3] as PaPlacementBaseline?,
        partialWarning: warnings.isEmpty
            ? null
            : 'Certaines données (${warnings.join(', ')}) ne sont pas disponibles pour le moment.',
      );
      return PaProgressLoaded(snapshot);
    } on PostgrestException catch (error) {
      return PaProgressLoadFailure(_friendlyMessage(error.code));
    } catch (_) {
      return const PaProgressLoadFailure(
        'Impossible de charger ta progression pour le moment.',
      );
    }
  }

  @override
  Future<void> saveDailyGoal(int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('pa_exam_daily_goal', value.clamp(1, 10));
  }

  Future<int> _loadDailyGoal() async {
    final preferences = await SharedPreferences.getInstance();
    return (preferences.getInt('pa_exam_daily_goal') ?? 3).clamp(1, 10);
  }

  String _friendlyMessage(String? code) {
    if (code == '42501') {
      return 'Tes données sont protégées, mais leur accès doit être rétabli. Réessaie un peu plus tard.';
    }
    return 'Impossible de charger ta progression pour le moment.';
  }
}
