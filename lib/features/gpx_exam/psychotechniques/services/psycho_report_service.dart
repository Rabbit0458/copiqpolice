// COP'IQ — Service de signalement des questions psychotechniques.
// Cible : public.tests_psycotechnique_report
//
// Tous les exercices psychotechniques signalent dans cette même table,
// peu importe leur table source.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/psycho_question.dart';

class PsychoReportService {
  PsychoReportService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<bool> sendReport({
    required PsychoQuestion question,
    required String reportType,
    String? message,
    String? page,
    String? sub,
  }) async {
    final user = _supabase.auth.currentUser;
    final email = user?.email;
    final uid = user?.id;
    try {
      await _supabase.from('tests_psycotechnique_report').insert({
        'user_uid': uid,
        'email': email,
        'question_id': question.id,
        'module': question.module,
        'category': question.category,
        'difficulty': question.difficulty,
        'question': question.question,
        'options': question.options.map((o) => o.toMap()).toList(),
        'answer': question.answer,
        'explanation': question.explanation,
        'sub': sub,
        'report_type': reportType,
        'message': message,
        'page': page ?? question.tableName,
        'status': 'new',
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
