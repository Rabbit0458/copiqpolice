// COP'IQ — Calcul mental.
// Wrapper léger autour de PsychoQuizPage.

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class CalculMentalPage extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/calcul_mental';

  const CalculMentalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Calcul mental',
        exerciseSubtitle:
            'Renforce ta vitesse et ta justesse en arithmétique de tête.',
        exerciseIcon: Icons.calculate_rounded,
        exerciseColor: PsychoBrand.cCalcul,
        routeName: CalculMentalPage.routeName,
        category: PsychoCategory.calculMental,
        tableName: PsychoTable.calculMental,
        introHidePrefKey: 'psycho_intro_hide_calcul_mental_v1',
        objectiveText:
            'Résoudre des opérations simples (addition, soustraction, '
            'multiplication, division, pourcentages) le plus rapidement '
            'et le plus précisément possible.',
        howToText:
            'Lis l’opération affichée puis sélectionne la bonne réponse '
            'parmi les choix proposés. Ne réfléchis pas trop longtemps : '
            'la vitesse fait partie du test.',
        exampleText: '17 + 28 = ?  →  45',
        tipText:
            'Astuce : arrondis aux dizaines pour calculer plus vite, '
            'puis ajuste avec la différence.',
        timerText: '30 secondes par question. Le chrono se relance à chaque nouvelle question.',
        questionDuration: 30,
        sessionLength: 10,
      ),
    );
  }
}
