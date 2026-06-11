// COP'IQ — Raisonnement spatial.

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class RaisonnementSpatialPage extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/spatial';

  const RaisonnementSpatialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Raisonnement spatial',
        exerciseSubtitle:
            'Visualise des figures, des pliages, des solides en 3D.',
        exerciseIcon: Icons.view_in_ar_rounded,
        exerciseColor: PsychoBrand.cSpatial,
        routeName: RaisonnementSpatialPage.routeName,
        category: PsychoCategory.raisonnementSpatial,
        tableName: PsychoTable.raisonnementSpatial,
        introHidePrefKey: 'psycho_intro_hide_raisonnement_spatial_v1',
        objectiveText:
            'Identifier la bonne représentation après transformation '
            '(pliage, dépliage, vue d’un solide). Tu testes ta '
            'visualisation mentale et ta perception 3D.',
        howToText:
            'Lis l’énoncé, regarde les options proposées et imagine '
            'mentalement la transformation avant de répondre.',
        exampleText:
            'Combien de faces possède un cube ? → 6.',
        tipText:
            'Si tu bloques, dessine mentalement le patron à plat puis replie-le.',
        timerText: '45 secondes par question. Le chrono se relance à chaque nouvelle question.',
        questionDuration: 45,
        sessionLength: 8,
      ),
    );
  }
}
