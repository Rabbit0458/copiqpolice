// COP'IQ — Tests psychotechniques PA : « Entraînements — Corrigés ».
// Historique des sessions PA UNIQUEMENT :
//   - quiz_history                 → filtre track = 'pa'
//   - tests_psychotechnique_history → filtre module = 'pa_psychotechnique'
// Les résultats GPX ne sont jamais affichés ici, et réciproquement les
// sessions PA ne polluent jamais l'historique GPX.

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pa_psycho_brand.dart';
import 'pa_tests_psy_hub_pages.dart';

class PaTestsPsyCorrigesPage extends StatefulWidget {
  static const String routeName = PaTestsPsyRoutes.entrainementsCorriges;
  const PaTestsPsyCorrigesPage({super.key});

  @override
  State<PaTestsPsyCorrigesPage> createState() => _PaTestsPsyCorrigesPageState();
}

class _PaAttempt {
  final String title;
  final String? route;
  final int correct;
  final int total;
  final DateTime? date;
  final int? durationSeconds;
  const _PaAttempt({
    required this.title,
    required this.route,
    required this.correct,
    required this.total,
    required this.date,
    this.durationSeconds,
  });

  int get percent => total <= 0 ? 0 : ((correct / total) * 100).round();

  String get level {
    final p = percent;
    if (p >= 90) return 'Très bonne maîtrise';
    if (p >= 75) return 'Bonne maîtrise';
    if (p >= 60) return 'Satisfaisant';
    if (p >= 40) return 'En progression';
    return 'Bases à renforcer';
  }
}

class _PaTestsPsyCorrigesPageState extends State<PaTestsPsyCorrigesPage> {
  final _sb = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  List<_PaAttempt> _attempts = const [];

  static const _quizRouteByName = <String, String>{
    'PA - Quiz tests psychotechniques calcul': PaTestsPsyRoutes.exCalcul,
    'PA - Quiz tests psychotechniques concentration':
        PaTestsPsyRoutes.exConcentration,
    'PA - Quiz tests psychotechniques raisonnement':
        PaTestsPsyRoutes.exRaisonnement,
    'PA - Quiz tests psychotechniques verbal':
        PaTestsPsyRoutes.exLogiqueVerbale,
  };

  static const _exerciseMeta = <String, (String, String)>{
    'attention_visuelle': (
      'Attention visuelle',
      PaTestsPsyRoutes.exAttentionVisuelle,
    ),
    'suite_logique': ('Suites logiques', PaTestsPsyRoutes.exSuitesLogiques),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final user = _sb.auth.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
        _error = 'Connecte-toi pour voir ton historique.';
      });
      return;
    }

    try {
      final results = await Future.wait([
        _sb
            .from('quiz_history')
            .select(
              'module_name, quiz_name, correct_count, total_questions, '
              'started_at, finished_at',
            )
            .eq('uid', user.id)
            .eq('track', 'pa')
            // Uniquement les QCM psychotechniques PA : les autres quiz de
            // l'app (cours, fiches...) écrivent aussi dans quiz_history.
            .inFilter('quiz_name', _quizRouteByName.keys.toList())
            .order('started_at', ascending: false)
            .limit(60),
        _sb
            .from('tests_psychotechnique_history')
            .select(
              'exercise_type, correct_answers, total_questions, '
              'duration_seconds, created_at',
            )
            .eq('user_id', user.id)
            .eq('module', 'pa_psychotechnique')
            .order('created_at', ascending: false)
            .limit(60),
      ]);

      final quizRows = List<Map<String, dynamic>>.from(results[0] as List);
      final exoRows = List<Map<String, dynamic>>.from(results[1] as List);

      DateTime? parseTs(dynamic v) =>
          v == null ? null : DateTime.tryParse(v.toString())?.toLocal();

      final attempts = <_PaAttempt>[
        ...quizRows.map((r) {
          final name = (r['quiz_name'] ?? '').toString();
          final module = (r['module_name'] ?? '').toString();
          final title = module.replaceFirst('PA - ', '');
          return _PaAttempt(
            title: title.isEmpty ? 'QCM psychotechnique' : title,
            route: _quizRouteByName[name],
            correct: (r['correct_count'] as num?)?.toInt() ?? 0,
            total: (r['total_questions'] as num?)?.toInt() ?? 0,
            date: parseTs(r['finished_at'] ?? r['started_at']),
          );
        }),
        ...exoRows.map((r) {
          final type = (r['exercise_type'] ?? '').toString();
          final meta = _exerciseMeta[type];
          return _PaAttempt(
            title: meta?.$1 ?? type,
            route: meta?.$2,
            correct: (r['correct_answers'] as num?)?.toInt() ?? 0,
            total: (r['total_questions'] as num?)?.toInt() ?? 0,
            date: parseTs(r['created_at']),
            durationSeconds: (r['duration_seconds'] as num?)?.toInt(),
          );
        }),
      ];

      attempts.sort((a, b) {
        final da = a.date, db = b.date;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });

      if (!mounted) return;
      setState(() {
        _attempts = attempts;
        _loading = false;
      });
    } catch (e) {
      debugPrint('PA corrigés — chargement impossible: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Impossible de charger ton historique. Vérifie ta connexion.';
      });
    }
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} à '
        '${two(d.hour)}:${two(d.minute)}';
  }

  Color _scoreColor(int p) {
    if (p >= 75) return PaPsychoBrand.good;
    if (p >= 40) return PaPsychoBrand.warn;
    return PaPsychoBrand.bad;
  }

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Entraînements — Corrigés',
      title: 'Ton historique PA',
      subtitle:
          'Les résultats de tes sessions d’entraînement Policier Adjoint. '
          'Indicateurs pédagogiques COP’IQ — aucun score officiel.',
      headerIcon: Icons.history_rounded,
      headerColor: PaPsychoBrand.cHistorique,
      children: [
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error != null)
          PaPsyReveal(
            index: 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: PaPsychoBrand.card(context),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 40,
                    color: PaPsychoBrand.warn,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: PaPsychoBrand.body(context),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _load,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Réessayer'),
                    style: FilledButton.styleFrom(
                      backgroundColor: PaPsychoBrand.accent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (_attempts.isEmpty)
          PaPsyReveal(
            index: 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: PaPsychoBrand.card(context),
              child: Column(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 40,
                    color: PaPsychoBrand.accent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucune session pour le moment.\n'
                    'Lance ton premier entraînement pour voir tes résultats '
                    'apparaître ici.',
                    textAlign: TextAlign.center,
                    style: PaPsychoBrand.body(context),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      PaTestsPsyRoutes.entrainementsQcm,
                    ),
                    icon: const Icon(Icons.bolt_rounded),
                    label: const Text('Commencer un entraînement'),
                    style: FilledButton.styleFrom(
                      backgroundColor: PaPsychoBrand.accent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          for (var i = 0; i < _attempts.length; i++)
            PaPsyReveal(
              index: 3 + (i.clamp(0, 8)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AttemptCard(
                  attempt: _attempts[i],
                  scoreColor: _scoreColor(_attempts[i].percent),
                  dateLabel: _fmtDate(_attempts[i].date),
                ),
              ),
            ),
      ],
    );
  }
}

class _AttemptCard extends StatelessWidget {
  final _PaAttempt attempt;
  final Color scoreColor;
  final String dateLabel;
  const _AttemptCard({
    required this.attempt,
    required this.scoreColor,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: PaPsychoBrand.card(context),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: PaPsychoBrand.tinted(
              context,
              color: scoreColor,
              radius: 16,
            ),
            alignment: Alignment.center,
            child: Text(
              '${attempt.percent}%',
              style: PaPsychoBrand.h3(context).copyWith(color: scoreColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(attempt.title, style: PaPsychoBrand.h3(context)),
                const SizedBox(height: 2),
                Text(
                  '${attempt.correct}/${attempt.total} bonnes réponses — '
                  '${attempt.level}',
                  style: PaPsychoBrand.small(context),
                ),
                if (dateLabel.isNotEmpty)
                  Text(dateLabel, style: PaPsychoBrand.small(context)),
              ],
            ),
          ),
          if (attempt.route != null)
            IconButton(
              tooltip: 'Refaire cet exercice',
              onPressed: () => Navigator.pushNamed(context, attempt.route!),
              icon: const Icon(
                Icons.replay_rounded,
                color: PaPsychoBrand.accent,
              ),
            ),
        ],
      ),
    );
  }
}
