// COP'IQ — Rotations et symétries.

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class RotationsSymetriesPage extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/rotations';

  const RotationsSymetriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Rotations & symétries',
        exerciseSubtitle:
            'Identifie les axes de symétrie, anticipe les rotations.',
        exerciseIcon: Icons.auto_awesome_motion_rounded,
        exerciseColor: PsychoBrand.cRotation,
        routeName: RotationsSymetriesPage.routeName,
        category: PsychoCategory.rotationsSymetries,
        tableName: PsychoTable.rotationsSymetries,
        introHidePrefKey: 'psycho_intro_hide_rotations_v1',
        objectiveText:
            'Trouver la bonne figure ou réponse après une rotation, '
            'une symétrie axiale ou centrale. Travaille ta perception '
            'des transformations géométriques.',
        howToText:
            'Lis le type de transformation demandé. Visualise mentalement '
            'la figure transformée et compare aux options.',
        exampleText:
            'Quel chiffre reste identique après rotation de 180° ? → 8.',
        tipText:
            'Les chiffres "centro-symétriques" : 0, 8 et le chiffre 1 si dessiné centré.',
        timerText: '40 secondes par question. Le chrono se relance à chaque nouvelle question.',
        questionDuration: 40,
        sessionLength: 8,
      ),
    );
  }
}
