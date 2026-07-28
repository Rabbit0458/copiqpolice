// COP'IQ — Connaissances générales PA : « Entraînements — Corrigés ».
// Historique des QCM culture générale PA UNIQUEMENT :
//   quiz_history → track = 'pa' + quiz_name dans la liste des QCM PA culture.
// Les résultats GPX (track = 'gpx') ne sont jamais affichés ici, et les
// autres modules PA (psychotechniques, cours...) sont exclus par quiz_name.

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../psycotechniques/pa_psycho_brand.dart';
import '../psycotechniques/pa_tests_psy_hub_pages.dart'
    show PaPsyReveal, PaPsyScaffold;
import 'pa_cg_hub_pages.dart';

class PaCgCorrigesPage extends StatefulWidget {
  static const String routeName = PaCgRoutes.entrainementsCorriges;
  const PaCgCorrigesPage({super.key});

  @override
  State<PaCgCorrigesPage> createState() => _PaCgCorrigesPageState();
}

class _CgAttempt {
  final String title;
  final String? route;
  final int correct;
  final int total;
  final DateTime? date;
  const _CgAttempt({
    required this.title,
    required this.route,
    required this.correct,
    required this.total,
    required this.date,
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

class _PaCgCorrigesPageState extends State<PaCgCorrigesPage> {
  final _sb = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  List<_CgAttempt> _attempts = const [];

  /// quiz_name PA → (titre affiché, route pour refaire).
  static const _metaByQuizName = <String, (String, String)>{
    'PA - Quiz culture générale histoire': (
      'Histoire de France',
      PaCgRoutes.exHistoire,
    ),
    'PA - Quiz culture générale institutions européennes': (
      'Institutions européennes',
      PaCgRoutes.exInstitutions,
    ),
    'PA - Quiz culture générale actualité': (
      'Actualité',
      PaCgRoutes.exActualite,
    ),
    'PA - Quiz culture générale géographie': (
      'Géographie',
      PaCgRoutes.exGeographie,
    ),
    'PA - Quiz culture générale France': (
      'Langue française',
      PaCgRoutes.exFrancais,
    ),
    'PA - Quiz culture générale sport': (
      'Sport & culture générale',
      PaCgRoutes.exSport,
    ),
    'PA - Quiz culture générale sciences': ('Sciences', PaCgRoutes.exSciences),
    'PA - Quiz culture générale santé': ('Santé', PaCgRoutes.exSante),
    'PA - Quiz culture générale police': (
      'Police & sécurité',
      PaCgRoutes.exPolice,
    ),
    'PA - Quiz culture générale mythologie': (
      'Mythologie',
      PaCgRoutes.exMythologie,
    ),
    'PA - Quiz culture générale musique': ('Musique', PaCgRoutes.exMusique),
    'PA - Quiz culture générale cinéma': ('Cinéma', PaCgRoutes.exCinema),
    'PA - Quiz culture générale droit': (
      'Droit & culture générale',
      PaCgRoutes.exDroit,
    ),
    'PA - Quiz culture générale sécurité routière': (
      'Sécurité routière',
      PaCgRoutes.exSecuriteRoutiere,
    ),
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
      final rows = await _sb
          .from('quiz_history')
          .select(
            'quiz_name, correct_count, total_questions, started_at, '
            'finished_at, completed_at',
          )
          .eq('uid', user.id)
          .eq('track', 'pa')
          .inFilter('quiz_name', _metaByQuizName.keys.toList())
          .order('started_at', ascending: false)
          .limit(80);

      DateTime? parseTs(dynamic v) =>
          v == null ? null : DateTime.tryParse(v.toString())?.toLocal();

      final attempts = List<Map<String, dynamic>>.from(rows as List).map((r) {
        final meta = _metaByQuizName[(r['quiz_name'] ?? '').toString()];
        return _CgAttempt(
          title: meta?.$1 ?? 'Connaissances générales',
          route: meta?.$2,
          correct: (r['correct_count'] as num?)?.toInt() ?? 0,
          total: (r['total_questions'] as num?)?.toInt() ?? 0,
          date: parseTs(
            r['completed_at'] ?? r['finished_at'] ?? r['started_at'],
          ),
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _attempts = attempts;
        _loading = false;
      });
    } catch (e) {
      debugPrint('PA culture corrigés — chargement impossible: $e');
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
      title: 'Ton historique',
      subtitle:
          'Les résultats de tes QCM de connaissances générales PA. '
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
                    'Aucun QCM pour le moment.\n'
                    'Lance ton premier entraînement pour voir tes résultats '
                    'apparaître ici.',
                    textAlign: TextAlign.center,
                    style: PaPsychoBrand.body(context),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      PaCgRoutes.entrainementsQcm,
                    ),
                    icon: const Icon(Icons.bolt_rounded),
                    label: const Text('Commencer un QCM'),
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
                child: _CgAttemptCard(
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

class _CgAttemptCard extends StatelessWidget {
  final _CgAttempt attempt;
  final Color scoreColor;
  final String dateLabel;
  const _CgAttemptCard({
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
              tooltip: 'Refaire ce QCM',
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
