// COP'IQ — Concentration (comptage de lettres / repérage d'intrus).
// Distinct de "Attention visuelle" (qui compare deux textes).

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class ConcentrationPage extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/concentration';

  const ConcentrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Concentration',
        exerciseSubtitle:
            'Comptage, repérage d’intrus, suites de symboles : reste focus.',
        exerciseIcon: Icons.center_focus_strong_rounded,
        exerciseColor: PsychoBrand.cConcentration,
        routeName: ConcentrationPage.routeName,
        category: PsychoCategory.concentration,
        tableName: PsychoTable.concentration,
        introHidePrefKey: 'psycho_intro_hide_concentration_v1',
        objectiveText:
            'Maintenir une attention soutenue pour repérer une lettre, '
            'un chiffre ou un intrus dans une suite. Compétence clef '
            'pour les tâches de surveillance et de saisie.',
        howToText:
            'Lis attentivement le stimulus présenté, puis réponds à la '
            'question (combien de fois, quel intrus, quelle séquence identique…).',
        exampleText:
            'Combien de "L" dans "LE LIEUTENANT LANCE LA LETTRE LENTEMENT" ? → 6.',
        tipText:
            'Aide-toi mentalement d’un balayage régulier : groupe par 3 ou 4 caractères.',
        timerText: '35 secondes par question. Le chrono se relance à chaque nouvelle question.',
        questionDuration: 35,
        sessionLength: 10,
      ),
    );
  }
}
