// lib/features/home/pa_progression_service.dart
//
// Service de progression pour la Home "Concours — Policier Adjoint" (PA exam).
//
// Portée STRICTE : ne lit QUE l'activité liée à la préparation au concours
// Policier Adjoint (track = 'pa', mode = 'exam'). Aucune donnée GPX / School
// n'est prise en compte.
//
// Source : table `quiz_history` (RLS : uid = auth.uid()) → seules les lignes
// de l'utilisateur connecté remontent. On y ajoute un filtre explicite
// track='pa' + mode='exam' pour ne garder que le concours PA.
//
// Fournit 3 informations pour la section "Continue ta préparation" :
//   1. La dernière activité (pour la carte "Reprendre").
//   2. Le streak (nombre de jours consécutifs de révision).
//   3. L'objectif du jour (nombre de quiz terminés aujourd'hui / cible).

import 'package:supabase_flutter/supabase_flutter.dart';

/// Cible d'exercices à réaliser par jour (objectif du jour).
const int kPaDailyGoal = 3;

/// Dernière activité de révision PA exam (pour la carte "Reprendre").
class PaResumeActivity {
  /// Nom du quiz (ex : "PA - Quiz culture générale police").
  final String quizName;

  /// Nom du module/épreuve (ex : "PA - Culture générale").
  final String moduleName;

  /// Score en % (0-100) de la dernière tentative, ou null si non pertinent.
  final int? scorePercent;

  /// Nombre de bonnes réponses.
  final int correctCount;

  /// Nombre total de questions.
  final int totalQuestions;

  /// Date de la dernière activité.
  final DateTime finishedAt;

  const PaResumeActivity({
    required this.quizName,
    required this.moduleName,
    required this.scorePercent,
    required this.correctCount,
    required this.totalQuestions,
    required this.finishedAt,
  });
}

/// Instantané complet de la progression PA exam pour l'écran d'accueil.
class PaProgressSnapshot {
  /// Dernière activité (null si l'utilisateur n'a encore rien fait).
  final PaResumeActivity? resume;

  /// Jours consécutifs de révision (0 si aucune activité récente).
  final int streakDays;

  /// Quiz terminés aujourd'hui.
  final int doneToday;

  /// Cible du jour.
  final int dailyGoal;

  const PaProgressSnapshot({
    required this.resume,
    required this.streakDays,
    required this.doneToday,
    required this.dailyGoal,
  });

  /// Instantané vide (utilisateur non connecté / aucune donnée).
  static const empty = PaProgressSnapshot(
    resume: null,
    streakDays: 0,
    doneToday: 0,
    dailyGoal: kPaDailyGoal,
  );

  bool get hasActivity => resume != null;

  /// Objectif du jour atteint ?
  bool get goalReached => doneToday >= dailyGoal;
}

class PaProgressionService {
  PaProgressionService._();
  static final PaProgressionService instance = PaProgressionService._();

  SupabaseClient get _supa => Supabase.instance.client;

  /// Récupère tout ce dont la section "Continue ta préparation" a besoin,
  /// en une seule lecture réseau (puis calculs locaux).
  Future<PaProgressSnapshot> fetchSnapshot() async {
    final user = _supa.auth.currentUser;
    if (user == null) return PaProgressSnapshot.empty;

    try {
      // On récupère l'historique PA exam récent (200 dernières lignes suffisent
      // largement pour un streak + l'activité du jour). RLS garantit déjà que
      // ce sont uniquement les lignes de l'utilisateur.
      final rows = await _supa
          .from('quiz_history')
          .select(
            'quiz_name, module_name, score, correct_count, '
            'total_questions, finished_at, completed_at',
          )
          .eq('track', 'pa')
          .eq('mode', 'exam')
          .order('finished_at', ascending: false)
          .limit(200);

      final list = (rows as List).cast<Map<String, dynamic>>();
      if (list.isEmpty) return PaProgressSnapshot.empty;

      // --- 1) Dernière activité ---------------------------------------
      final first = list.first;
      final resume = _mapResume(first);

      // --- 2) Dates d'activité (jour local) pour streak + objectif -----
      final activityDays = <DateTime>{};
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      int doneToday = 0;

      for (final r in list) {
        final dt = _parseDate(r['finished_at']) ?? _parseDate(r['completed_at']);
        if (dt == null) continue;
        final local = dt.toLocal();
        final day = DateTime(local.year, local.month, local.day);
        activityDays.add(day);
        if (day == today) doneToday++;
      }

      // --- 3) Streak : jours consécutifs en remontant depuis aujourd'hui
      final streak = _computeStreak(activityDays, today);

      return PaProgressSnapshot(
        resume: resume,
        streakDays: streak,
        doneToday: doneToday,
        dailyGoal: kPaDailyGoal,
      );
    } catch (_) {
      // En cas d'erreur réseau/permission, on dégrade proprement.
      return PaProgressSnapshot.empty;
    }
  }

  PaResumeActivity? _mapResume(Map<String, dynamic> r) {
    final finishedAt =
        _parseDate(r['finished_at']) ?? _parseDate(r['completed_at']);
    if (finishedAt == null) return null;

    final quizName = (r['quiz_name'] as String?)?.trim();
    final moduleName = (r['module_name'] as String?)?.trim();

    final total = (r['total_questions'] as num?)?.toInt() ?? 0;
    final correct = (r['correct_count'] as num?)?.toInt() ?? 0;
    final rawScore = (r['score'] as num?)?.toInt();
    // On ne garde le score que s'il est pertinent (au moins 1 question).
    final scorePercent = total > 0 ? rawScore : null;

    return PaResumeActivity(
      quizName: (quizName == null || quizName.isEmpty)
          ? (moduleName ?? 'Ta préparation')
          : quizName,
      moduleName: (moduleName == null || moduleName.isEmpty)
          ? 'Concours Policier Adjoint'
          : moduleName,
      scorePercent: scorePercent,
      correctCount: correct,
      totalQuestions: total,
      finishedAt: finishedAt.toLocal(),
    );
  }

  /// Streak = nombre de jours consécutifs avec au moins une activité,
  /// en partant d'aujourd'hui (ou d'hier si rien fait aujourd'hui, pour ne pas
  /// "casser" le streak avant la fin de journée).
  int _computeStreak(Set<DateTime> days, DateTime today) {
    if (days.isEmpty) return 0;

    // Point de départ : aujourd'hui si actif, sinon hier.
    final yesterday = today.subtract(const Duration(days: 1));
    DateTime cursor;
    if (days.contains(today)) {
      cursor = today;
    } else if (days.contains(yesterday)) {
      cursor = yesterday;
    } else {
      return 0; // streak rompu
    }

    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }
}
