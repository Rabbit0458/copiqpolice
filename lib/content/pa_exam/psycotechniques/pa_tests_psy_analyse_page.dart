// COP'IQ — Tests psychotechniques PA : « Analyse de l'épreuve ».
// Adaptation PA de la page pédagogique GPX « Comprendre l'épreuve ».
// Positionnement PA : les tests sont présentés comme un outil d'évaluation
// des aptitudes lors de la sélection, jamais comme une note officielle
// ou un classement.

import 'package:flutter/material.dart';

import 'pa_psycho_brand.dart';
import 'pa_tests_psy_hub_pages.dart';

class PaTestsPsyAnalysePage extends StatelessWidget {
  static const String routeName = PaTestsPsyRoutes.analyse;
  const PaTestsPsyAnalysePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Analyse de l’épreuve',
      title: 'Comprendre les tests psychotechniques',
      subtitle:
          'Une série d’exercices chronométrés qui évaluent ta logique, ta '
          'concentration et ta vitesse de raisonnement lors de la sélection '
          'de Policier Adjoint.',
      headerIcon: Icons.insights_rounded,
      headerColor: PaPsychoBrand.accent,
      children: [
        const PaPsyReveal(
          index: 3,
          child: PaPsyInfoBlock(
            title: 'À quoi servent ces tests ?',
            icon: Icons.flag_rounded,
            color: PaPsychoBrand.accent,
            text:
                'Lors de la sélection de Policier Adjoint, les tests '
                'psychotechniques aident le recruteur à apprécier des '
                'aptitudes utiles au métier : prise de décision rapide, '
                'attention soutenue, mémorisation et raisonnement logique. '
                'Ils constituent une aide à la décision : COP’IQ te prépare '
                'à les aborder sereinement, sans te donner de fausse note '
                'officielle ni de classement.',
          ),
        ),
        const PaPsyReveal(
          index: 4,
          child: PaPsyInfoBlock(
            title: 'Compétences évaluées',
            icon: Icons.checklist_rounded,
            color: PaPsychoBrand.cSuiteLogique,
            text:
                '• Logique numérique et verbale\n'
                '• Concentration et attention visuelle\n'
                '• Raisonnement et déduction\n'
                '• Mémoire de travail\n'
                '• Vitesse et précision sous contrainte de temps',
          ),
        ),
        const PaPsyReveal(
          index: 5,
          child: PaPsyInfoBlock(
            title: 'Ce que l’épreuve n’est pas',
            icon: Icons.do_not_disturb_on_rounded,
            color: PaPsychoBrand.bad,
            text:
                'Ce n’est ni un test d’intelligence, ni un diagnostic '
                'psychologique, ni un examen scolaire. Il n’y a pas de '
                '« bonne personnalité » à imiter : la régularité de ton '
                'entraînement et ta gestion du stress font la différence.',
          ),
        ),
        const PaPsyReveal(
          index: 6,
          child: PaPsyInfoBlock(
            title: 'Conseils pour réussir',
            icon: Icons.tips_and_updates_outlined,
            color: PaPsychoBrand.warn,
            text:
                '• Entraîne-toi régulièrement, même 10 min par jour.\n'
                '• Ne reste pas bloqué sur une question : passe et reviens.\n'
                '• Lis chaque énoncé deux fois en cas de doute.\n'
                '• Travaille le calcul mental sans calculatrice.\n'
                '• Familiarise-toi avec les formats pour éviter la surprise.\n'
                '• Respire et garde un rythme constant : la panique coûte '
                'plus de points que la difficulté des questions.',
          ),
        ),
        const SizedBox(height: 6),
        PaPsyReveal(
          index: 7,
          child: Text('Les exercices', style: PaPsychoBrand.h2(context)),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < paPsyExercises.length; i++)
          PaPsyReveal(
            index: 8 + i,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaPsyTile(info: paPsyExercises[i]),
            ),
          ),
        const SizedBox(height: 8),
        PaPsyReveal(
          index: 8 + paPsyExercises.length,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                PaTestsPsyRoutes.entrainementsQcm,
              ),
              icon: const Icon(Icons.bolt_rounded),
              label: const Text('Commencer un entraînement'),
              style: FilledButton.styleFrom(
                backgroundColor: PaPsychoBrand.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'InstrumentSans',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
