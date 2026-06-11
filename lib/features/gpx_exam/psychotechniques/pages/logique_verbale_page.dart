// COP'IQ — Logique verbale.

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class LogiqueVerbalePage extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/logique_verbale';

  const LogiqueVerbalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Logique verbale',
        exerciseSubtitle:
            'Synonymes, antonymes, analogies, intrus : muscle ton vocabulaire.',
        exerciseIcon: Icons.menu_book_rounded,
        exerciseColor: PsychoBrand.cVerbal,
        routeName: LogiqueVerbalePage.routeName,
        category: PsychoCategory.logiqueVerbale,
        tableName: PsychoTable.logiqueVerbale,
        introHidePrefKey: 'psycho_intro_hide_logique_verbale_v1',
        objectiveText:
            'Identifier la réponse correcte parmi un ensemble de mots '
            '(synonyme, antonyme, intrus, analogie). Tu travailles ta '
            'compréhension du sens et des relations entre les mots.',
        howToText:
            'Lis l’énoncé puis l’éventuel prompt. Choisis la réponse qui '
            'respecte le mieux la consigne (synonyme, antonyme, etc.).',
        exampleText:
            '"Quel mot complète : Voiture est à route comme bateau est à ___ ?"  →  Mer.',
        tipText:
            'Si tu hésites, élimine d’abord les options clairement fausses '
            'avant de choisir.',
        timerText: '30 secondes par question. Le chrono se relance à chaque nouvelle question.',
        questionDuration: 30,
        sessionLength: 10,
      ),
    );
  }
}
