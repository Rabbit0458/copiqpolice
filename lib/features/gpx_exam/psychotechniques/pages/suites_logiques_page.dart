// COP'IQ — Suites logiques (refonte avec moteur générique).
// Trouve le terme manquant d'une suite numérique ou alphabétique.

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class SuitesLogiquesPageNew extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/suites_logiques';

  const SuitesLogiquesPageNew({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Suites logiques',
        exerciseSubtitle:
            'Identifie la règle de progression et trouve le terme manquant.',
        exerciseIcon: Icons.timeline_rounded,
        exerciseColor: PsychoBrand.cSuiteLogique,
        routeName: SuitesLogiquesPageNew.routeName,
        category: PsychoCategory.suiteLogique,
        tableName: PsychoTable.suiteLogique,
        introHidePrefKey: 'psycho_intro_hide_suite_logique_v2',
        objectiveText:
            'Repérer la règle (arithmétique, géométrique, alternance, '
            'Fibonacci…) qui régit la suite et compléter le terme manquant.',
        howToText:
            'Lis la suite, trouve la règle, choisis le bon terme parmi les '
            'propositions.',
        timerText:
            '40 s par question. Le chrono se relance à chaque nouvelle suite.',
        questionDuration: 40,
        sessionLength: 10,
      ),
    );
  }
}
