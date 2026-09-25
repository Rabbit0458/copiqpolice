import 'package:supabase_flutter/supabase_flutter.dart';

class CopiqCoachPreferencesService {
  CopiqCoachPreferencesService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<DateTime?> loadTargetExamDate() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final row = await _client
        .from('coach_user_preferences')
        .select('target_exam_date')
        .eq('user_id', user.id)
        .maybeSingle();
    final raw = row?['target_exam_date']?.toString();
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> saveTargetExamDate(DateTime date) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    await _client.from('coach_user_preferences').upsert({
      'user_id': user.id,
      'target_exam_date': date.toIso8601String().substring(0, 10),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> saveWeeklySummary(Map<String, Object> metrics) async {
    final user = _client.auth.currentUser;
    if (user == null) return;
    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    await _client.from('coach_weekly_summaries').upsert({
      'user_id': user.id,
      'week_start': monday.toIso8601String().substring(0, 10),
      'metrics': metrics,
      'generated_at': now.toUtc().toIso8601String(),
    });
  }
}
