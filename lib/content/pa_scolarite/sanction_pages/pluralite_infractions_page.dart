import 'package:flutter/material.dart';
import 'package:copiqpolice/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart';

class PaPluraliteInfractionsPage extends StatelessWidget {
  const PaPluraliteInfractionsPage({super.key});
  static const String routeName = '/pa/dps_dpg/sanctions/pluralite_infractions';

  @override
  Widget build(BuildContext context) => const PremiumSanctionLessonPage(
    appBarTitle: 'Pluralité d’infractions',
    heroTitle: 'Plusieurs infractions, une réponse cohérente',
    heroSubtitle: 'Concours, cumul, non bis in idem et confusion des peines.',
    objective:
        'Déterminer comment plusieurs faits ou qualifications s’articulent, sans prononcer deux sanctions pour les mêmes faits.',
    keywords: [
      'Concours réel',
      'Concours idéal',
      'Non bis in idem',
      'Confusion',
    ],
    sections: [
      SanctionLessonSection(
        number: '01',
        icon: Icons.call_split_rounded,
        title: 'Concours d’infractions',
        subtitle: 'Distinguer concours réel et concours idéal',
        points: [
          'Le concours réel résulte de plusieurs faits distincts constituant plusieurs infractions.',
          'Le concours idéal apparaît lorsqu’un même fait reçoit plusieurs qualifications.',
          'Le cumul des peines reste soumis aux règles et plafonds prévus par les textes.',
        ],
      ),
      SanctionLessonSection(
        number: '02',
        icon: Icons.filter_2_outlined,
        title: 'Non bis in idem',
        subtitle: 'Pas de double condamnation pour les mêmes faits',
        points: [
          'Comparer les faits, les parties, la période et la nature des sanctions.',
          'Vérifier l’articulation entre procédures pénales et administratives.',
        ],
      ),
      SanctionLessonSection(
        number: '03',
        icon: Icons.merge_type_rounded,
        title: 'Confusion des peines',
        subtitle: 'Regrouper totalement ou partiellement des peines',
        points: [
          'La confusion peut réunir des peines prononcées pour des faits distincts.',
          'La décision relève du juge et doit respecter les limites légales.',
          'La motivation tient compte des faits et de la personnalité du condamné.',
        ],
      ),
    ],
    checklist: [
      'Construire une chronologie précise des faits, lieux, victimes et qualifications.',
      'Éviter les qualifications contradictoires ou les doubles poursuites.',
      'Justifier concrètement toute demande de confusion ou son refus.',
    ],
    links: [
      SanctionLessonLink(
        icon: Icons.gavel_rounded,
        title: 'Classification des peines',
        subtitle: 'Natures, alternatives et mesures de sûreté',
        route: '/pa/dps_dpg/sanctions/classification_peines',
      ),
      SanctionLessonLink(
        icon: Icons.trending_up_rounded,
        title: 'Causes d’aggravation',
        subtitle: 'Récidive et circonstances aggravantes',
        route: '/pa/dps_dpg/sanctions/causes_aggravation',
      ),
    ],
  );
}
