// COP'IQ — Épreuve de photolangage PA : page d'accueil du module.
// Trois sous-parties + reprise de brouillon + statistiques légères.
// Tous les scores affichés sont des indicateurs d'entraînement COP'IQ,
// jamais une note officielle.

import 'package:flutter/material.dart';

import '../psycotechniques/pa_psycho_brand.dart';
import '../psycotechniques/pa_tests_psy_hub_pages.dart'
    show PaPsyExercise, PaPsyReveal, PaPsyScaffold, PaPsyTile;
import 'pa_photolangage_core.dart';

class PaPhotolangageHubPage extends StatefulWidget {
  static const String routeName = PaPhotolangageRoutes.home;
  const PaPhotolangageHubPage({super.key});

  @override
  State<PaPhotolangageHubPage> createState() => _PaPhotolangageHubPageState();
}

class _PaPhotolangageHubPageState extends State<PaPhotolangageHubPage> {
  final _repo = PaPhotolangageRepository.instance;

  PhotolangageDraft? _activeDraft;
  int _completedCount = 0;
  int? _averageScore;
  int? _bestRecentScore;
  bool _hasAttempts = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        _repo.latestActiveDraft(),
        _repo.fetchAttempts(limit: 60),
      ]);
      final draft = results[0] as PhotolangageDraft?;
      final attempts = results[1] as List<PhotolangageAttempt>;

      final scored = attempts
          .where((a) => a.pedagogicalScore != null)
          .map((a) => a.pedagogicalScore!)
          .toList();
      final completedCases = attempts.map((a) => a.caseId).toSet().length;

      if (!mounted) return;
      setState(() {
        _activeDraft = (draft != null && draft.text.trim().isNotEmpty)
            ? draft
            : null;
        _hasAttempts = attempts.isNotEmpty;
        _completedCount = completedCases;
        _averageScore = scored.isEmpty
            ? null
            : (scored.reduce((a, b) => a + b) / scored.length).round();
        _bestRecentScore = scored.isEmpty
            ? null
            : scored.take(5).reduce((a, b) => a > b ? a : b);
      });
    } catch (_) {
      // Statistiques non bloquantes.
    }
  }

  @override
  Widget build(BuildContext context) {
    const sections = [
      PaPsyExercise(
        title: 'Analyse de l’épreuve',
        description: 'Comprendre ce que le jury attend de ta description.',
        icon: Icons.insights_rounded,
        color: PaPsychoBrand.accent,
        route: PaPhotolangageRoutes.analyse,
      ),
      PaPsyExercise(
        title: 'Les étapes de la réussite',
        description:
            'La méthode COP’IQ en 7 étapes, de l’observation à la '
            'relecture.',
        icon: Icons.route_rounded,
        color: PaPsychoBrand.cSuiteLogique,
        route: PaPhotolangageRoutes.etapes,
      ),
      PaPsyExercise(
        title: 'Entraînements — sujets & corrigés',
        description:
            'Les cas photographiques chronométrés avec correction '
            'détaillée.',
        icon: Icons.photo_camera_rounded,
        color: PaPsychoBrand.cCalcul,
        route: PaPhotolangageRoutes.entrainements,
      ),
    ];

    return PaPsyScaffold(
      badge: 'Expression écrite',
      title: 'Épreuve de photolangage',
      subtitle:
          'Décrire fidèlement une photographie de la vie courante, en '
          'français correct et organisé. Entraîne-toi en conditions '
          'chronométrées : COP’IQ analyse ton texte et te donne un score '
          'pédagogique — un indicateur d’entraînement, pas une note '
          'officielle.',
      headerIcon: Icons.photo_library_rounded,
      headerColor: PaPsychoBrand.accent,
      children: [
        if (_activeDraft != null)
          PaPsyReveal(
            index: 3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.pushNamed(
                    context,
                    PaPhotolangageRoutes.entrainements,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: PaPsychoBrand.tinted(
                      context,
                      color: PaPsychoBrand.warn,
                      radius: 18,
                      alpha: .10,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.play_circle_fill_rounded,
                          color: PaPsychoBrand.warn,
                          size: 34,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reprendre mon exercice',
                                style: PaPsychoBrand.h3(context),
                              ),
                              Text(
                                'Un brouillon est en attente sur le cas '
                                '${_activeDraft!.caseId.replaceAll('case_', 'n° ')}.',
                                style: PaPsychoBrand.small(context),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: PaPsychoBrand.textMuted(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        for (var i = 0; i < sections.length; i++)
          PaPsyReveal(
            index: 4 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: sections[i]),
            ),
          ),
        if (_hasAttempts) ...[
          PaPsyReveal(
            index: 7,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(
                info: const PaPsyExercise(
                  title: 'Mon historique',
                  description: 'Toutes tes copies corrigées.',
                  icon: Icons.history_rounded,
                  color: PaPsychoBrand.cHistorique,
                  route: PaPhotolangageRoutes.historique,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          PaPsyReveal(
            index: 8,
            child: Row(
              children: [
                _StatChip(
                  label: 'Cas travaillés',
                  value: '$_completedCount',
                  color: PaPsychoBrand.accent,
                ),
                const SizedBox(width: 10),
                _StatChip(
                  label: 'Moyenne COP’IQ',
                  value: _averageScore == null ? '—' : '$_averageScore',
                  color: PaPsychoBrand.cSuiteLogique,
                ),
                const SizedBox(width: 10),
                _StatChip(
                  label: 'Meilleur récent',
                  value: _bestRecentScore == null ? '—' : '$_bestRecentScore',
                  color: PaPsychoBrand.good,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: PaPsychoBrand.card(context, radius: 14),
        child: Column(
          children: [
            Text(
              value,
              style: PaPsychoBrand.h2(context).copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: PaPsychoBrand.small(context),
            ),
          ],
        ),
      ),
    );
  }
}
