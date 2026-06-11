// COP'IQ — Raisonnement logique.

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class RaisonnementLogiquePage extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/raisonnement_logique';

  const RaisonnementLogiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Raisonnement logique',
        exerciseSubtitle:
            'Syllogismes, déductions, classements : entraîne ta logique pure.',
        exerciseIcon: Icons.psychology_alt_rounded,
        exerciseColor: PsychoBrand.cRaisonnement,
        routeName: RaisonnementLogiquePage.routeName,
        category: PsychoCategory.raisonnementLogique,
        tableName: PsychoTable.raisonnementLogique,
        introHidePrefKey: 'psycho_intro_hide_raisonnement_logique_v1',
        objectiveText:
            'Tirer la bonne conclusion à partir d’informations données. '
            'Ces questions évaluent ton aptitude à déduire, classer, '
            'transposer ou détecter un piège logique.',
        howToText:
            'Prends le temps de bien lire le prompt. Représente-toi '
            'mentalement la scène ou l’ordre logique avant de répondre.',
        exampleText:
            'Pierre > Paul > Jacques : qui est le plus grand ? → Pierre.',
        tipText:
            'Méfie-toi des pièges : "doubler le 2e" ne te place pas 1er.',
        timerText: '40 secondes par question. Le chrono se relance à chaque nouvelle question.',
        questionDuration: 40,
        sessionLength: 10,
      ),
    );
  }
}
