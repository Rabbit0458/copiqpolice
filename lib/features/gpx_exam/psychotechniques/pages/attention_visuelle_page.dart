// COP'IQ — Attention visuelle (refonte avec moteur générique).
// Compare deux textes : identiques ou différents.

import 'package:flutter/material.dart';

import '../services/psycho_question_service.dart';
import '../widgets/psycho_brand.dart';
import 'psycho_quiz_page.dart';

class AttentionVisuellePageNew extends StatelessWidget {
  static const String routeName =
      '/gpx_exam/concours/tests_psychotechniques/attention_visuelle';

  const AttentionVisuellePageNew({super.key});

  @override
  Widget build(BuildContext context) {
    return const PsychoQuizPage(
      config: PsychoQuizConfig(
        exerciseTitle: 'Attention visuelle',
        exerciseSubtitle:
            'Compare deux textes et repère la moindre différence.',
        exerciseIcon: Icons.visibility_rounded,
        exerciseColor: PsychoBrand.cAttention,
        routeName: AttentionVisuellePageNew.routeName,
        category: PsychoCategory.attentionVisuelle,
        tableName: PsychoTable.attentionVisuelle,
        introHidePrefKey: 'psycho_intro_hide_attention_visuelle_v2',
        objectiveText:
            'Détecter en quelques secondes si deux textes sont strictement '
            'identiques (mêmes lettres, accents, espaces, ponctuation).',
        howToText:
            'Lis les deux textes côte à côte puis choisis « Identiques » '
            'ou « Différents ».',
        timerText:
            '15 s par question. Le chrono se relance à chaque nouvelle paire.',
        questionDuration: 15,
        sessionLength: 12,
      ),
    );
  }
}
