// COP'IQ — Photolangage PA : « Analyse de l'épreuve ».
// Parcours pédagogique structuré : objectif, attentes du jury, méthode,
// exemples acceptable / à éviter, mini quiz (indicatif, non noté),
// checklist avant de rendre.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppNotifier;

import '../psycotechniques/pa_psycho_brand.dart';
import '../psycotechniques/pa_tests_psy_hub_pages.dart'
    show PaPsyInfoBlock, PaPsyReveal, PaPsyScaffold;
import 'pa_photolangage_core.dart';

class PaPhotolangageAnalysePage extends StatefulWidget {
  static const String routeName = PaPhotolangageRoutes.analyse;
  const PaPhotolangageAnalysePage({super.key});

  @override
  State<PaPhotolangageAnalysePage> createState() =>
      _PaPhotolangageAnalysePageState();
}

class _PaPhotolangageAnalysePageState extends State<PaPhotolangageAnalysePage> {
  static const _doneKey = 'pa_photolangage_analyse_done_v1';

  final Map<int, int> _quizAnswers = {};
  bool _lessonDone = false;

  static const _quiz = [
    (
      'Que faut-il décrire dans cette épreuve ?',
      [
        'Ce que l’on imagine de l’histoire',
        'Uniquement ce qui est visible sur la photographie',
        'Son opinion personnelle sur la scène',
      ],
      1,
    ),
    (
      'Quel ordre de description est recommandé ?',
      [
        'Du général au particulier',
        'Au hasard, selon l’inspiration',
        'Du détail le plus petit au plus grand',
      ],
      0,
    ),
    (
      '« Un policier interpelle un voleur » : quel est le problème ?',
      [
        'La phrase est trop courte',
        'Rien, c’est une bonne description',
        '« Voleur » est une interprétation non justifiée par l’image',
      ],
      2,
    ),
    (
      'Quand utiliser « semble » ou « paraît » ?',
      [
        'Dans toutes les phrases, par prudence',
        'Jamais',
        'Uniquement quand un élément est réellement incertain',
      ],
      2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadDone();
  }

  Future<void> _loadDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() => _lessonDone = prefs.getBool(_doneKey) ?? false);
    } catch (_) {}
  }

  Future<void> _markDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_doneKey, true);
    } catch (_) {}
    if (!mounted) return;
    setState(() => _lessonDone = true);
    AppNotifier.success(
      context,
      title: 'Avancement enregistré',
      message: 'Passe maintenant aux étapes de la réussite.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Analyse de l’épreuve',
      title: 'Comprendre le photolangage',
      subtitle:
          'Une photographie d’une scène de la vie courante, 20 minutes '
          'd’entraînement COP’IQ, et un objectif : décrire fidèlement, en '
          'français correct, ce que tu observes.',
      headerIcon: Icons.insights_rounded,
      headerColor: PaPsychoBrand.accent,
      children: [
        const PaPsyReveal(
          index: 3,
          child: PaPsyInfoBlock(
            title: 'À quoi sert l’exercice ?',
            icon: Icons.flag_rounded,
            color: PaPsychoBrand.accent,
            text:
                'Le commentaire de photographie sert d’aide à la décision '
                'du jury lors de la sélection de Policier Adjoint. Il '
                'vérifie ta capacité à t’exprimer correctement en français '
                'écrit : orthographe, grammaire, conjugaison, syntaxe, '
                'ponctuation, richesse du vocabulaire — et ta capacité à '
                'observer une image puis à restituer fidèlement ce qui est '
                'visible.',
          ),
        ),
        const PaPsyReveal(
          index: 4,
          child: PaPsyInfoBlock(
            title: 'Ce que le jury cherche à observer',
            icon: Icons.visibility_rounded,
            color: PaPsychoBrand.cSuiteLogique,
            text:
                '• Une description claire et organisée.\n'
                '• Un français écrit correct et relu.\n'
                '• Un vocabulaire précis et varié.\n'
                '• Une observation méthodique et complète.\n'
                '• La distinction entre observation et interprétation.',
          ),
        ),
        const PaPsyReveal(
          index: 5,
          child: PaPsyInfoBlock(
            title: 'Ce que l’exercice n’est pas',
            icon: Icons.do_not_disturb_on_rounded,
            color: PaPsychoBrand.bad,
            text:
                'Ce n’est ni une dissertation, ni une rédaction '
                'd’imagination, ni une enquête. N’invente pas d’histoire, '
                'd’intention, de sentiment, d’identité, d’infraction ou de '
                'cause que l’image ne montre pas. Ne donne pas ton avis '
                'personnel et n’écris pas un récit romancé.',
          ),
        ),
        const PaPsyReveal(
          index: 6,
          child: PaPsyInfoBlock(
            title: 'La méthode « du général au particulier »',
            icon: Icons.zoom_in_rounded,
            color: PaPsychoBrand.cRaisonnement,
            text:
                '1. Identifier la nature générale de la scène.\n'
                '2. Présenter le cadre et le lieu observable.\n'
                '3. Décrire les plans de l’image (premier plan, second '
                'plan, arrière-plan).\n'
                '4. Décrire les personnes, objets et actions visibles.\n'
                '5. Utiliser des repères spatiaux.\n'
                '6. Rester factuel du début à la fin.\n'
                '7. Relire et corriger le français.',
          ),
        ),
        const PaPsyReveal(
          index: 7,
          child: PaPsyInfoBlock(
            title: 'Le vocabulaire spatial à maîtriser',
            icon: Icons.explore_rounded,
            color: PaPsychoBrand.cCalcul,
            text:
                'Au premier plan • au second plan • à l’arrière-plan • au '
                'centre • sur la gauche • sur la droite • dans la partie '
                'supérieure • dans la partie inférieure • à proximité • '
                'derrière • devant • entre • à côté de • on distingue • on '
                'observe • la photographie représente • la scène se '
                'déroule.\n\n« Semble » et « paraît » : uniquement quand '
                'l’incertitude est réelle.',
          ),
        ),
        const PaPsyReveal(
          index: 8,
          child: PaPsyInfoBlock(
            title: 'Les erreurs qui pénalisent',
            icon: Icons.warning_amber_rounded,
            color: PaPsychoBrand.warn,
            text:
                '• Inventer ce que l’image ne montre pas.\n'
                '• Répéter « il y a » dans chaque phrase.\n'
                '• Négliger accords, verbes et homophones.\n'
                '• Sauter d’un élément à l’autre sans ordre.\n'
                '• Écrire des phrases interminables.\n'
                '• Rendre sa copie sans la relire.',
          ),
        ),
        PaPsyReveal(
          index: 9,
          child: _ExampleCard(
            good:
                '« Au premier plan, deux policiers en tenue se tiennent '
                'près d’un véhicule blanc. »',
            bad:
                '« Deux policiers viennent d’arrêter un dangereux criminel '
                'qui a sûrement volé la voiture. »',
          ),
        ),
        const SizedBox(height: 8),
        PaPsyReveal(
          index: 10,
          child: Text(
            'Vérifie ta compréhension',
            style: PaPsychoBrand.h2(context),
          ),
        ),
        const SizedBox(height: 4),
        PaPsyReveal(
          index: 11,
          child: Text(
            'Mini quiz indicatif — sans note ni enregistrement.',
            style: PaPsychoBrand.small(context),
          ),
        ),
        const SizedBox(height: 12),
        for (var q = 0; q < _quiz.length; q++)
          PaPsyReveal(
            index: 12 + q,
            child: _QuizCard(
              question: _quiz[q].$1,
              options: _quiz[q].$2,
              correctIndex: _quiz[q].$3,
              selected: _quizAnswers[q],
              onSelect: (i) => setState(() => _quizAnswers[q] = i),
            ),
          ),
        const SizedBox(height: 10),
        PaPsyReveal(
          index: 16,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: _lessonDone ? null : _markDone,
              icon: Icon(
                _lessonDone ? Icons.check_circle_rounded : Icons.check_rounded,
              ),
              label: Text(_lessonDone ? 'Leçon terminée' : 'J’ai compris'),
              style: FilledButton.styleFrom(
                backgroundColor: PaPsychoBrand.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: PaPsychoBrand.good.withValues(
                  alpha: .25,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        PaPsyReveal(
          index: 17,
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, PaPhotolangageRoutes.etapes),
              icon: const Icon(Icons.route_rounded),
              label: const Text('Voir les étapes de la réussite'),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String good;
  final String bad;
  const _ExampleCard({required this.good, required this.bad});

  @override
  Widget build(BuildContext context) {
    Widget row(IconData icon, Color color, String label, String text) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: PaPsychoBrand.small(
                        context,
                      ).copyWith(color: color, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(text, style: PaPsychoBrand.body(context)),
                  ],
                ),
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: PaPsychoBrand.card(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exemple commenté', style: PaPsychoBrand.h3(context)),
            const SizedBox(height: 12),
            row(
              Icons.check_circle_rounded,
              PaPsychoBrand.good,
              'ACCEPTABLE',
              good,
            ),
            row(Icons.cancel_rounded, PaPsychoBrand.bad, 'À ÉVITER', bad),
            Text(
              'Rien sur l’image ne permet d’affirmer « criminel », '
              '« volé » ni « arrêté ». Décris les positions, les tenues, '
              'les objets : les faits.',
              style: PaPsychoBrand.small(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final int? selected;
  final ValueChanged<int> onSelect;

  const _QuizCard({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: PaPsychoBrand.card(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: PaPsychoBrand.h3(context)),
            const SizedBox(height: 10),
            for (var i = 0; i < options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onSelect(i),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: selected == null
                          ? Colors.transparent
                          : i == correctIndex
                          ? PaPsychoBrand.good.withValues(alpha: .12)
                          : (selected == i
                                ? PaPsychoBrand.bad.withValues(alpha: .10)
                                : Colors.transparent),
                      border: Border.all(
                        color: selected == null
                            ? PaPsychoBrand.borderColor(context)
                            : i == correctIndex
                            ? PaPsychoBrand.good
                            : (selected == i
                                  ? PaPsychoBrand.bad
                                  : PaPsychoBrand.borderColor(context)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            options[i],
                            style: PaPsychoBrand.body(context),
                          ),
                        ),
                        if (selected != null && i == correctIndex)
                          const Icon(
                            Icons.check_rounded,
                            color: PaPsychoBrand.good,
                            size: 18,
                          ),
                        if (selected == i && i != correctIndex)
                          const Icon(
                            Icons.close_rounded,
                            color: PaPsychoBrand.bad,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
