import 'package:flutter/material.dart';
import 'package:copiqpolice/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPluraliteInfractionsPage extends StatelessWidget {
  const PaPluraliteInfractionsPage({super.key});
  static const String routeName = '/pa/dps_dpg/sanctions/pluralite_infractions';

  @override
  Widget build(BuildContext context) => PremiumSanctionLessonPage(
    appBarTitle: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
      "f00001",
      'Pluralité d’infractions',
    ),
    heroTitle: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
      "f00002",
      'Plusieurs infractions, une réponse cohérente',
    ),
    heroSubtitle: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
      "f00003",
      'Concours, cumul, non bis in idem et confusion des peines.',
    ),
    objective: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
      "f00004",
      'Déterminer comment plusieurs faits ou qualifications s’articulent, sans prononcer deux sanctions pour les mêmes faits.',
    ),
    keywords: [
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
        "f00005",
        'Concours réel',
      ),
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
        "f00006",
        'Concours idéal',
      ),
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
        "f00007",
        'Non bis in idem',
      ),
      'Confusion',
    ],
    sections: [
      SanctionLessonSection(
        number: '01',
        icon: Icons.call_split_rounded,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00008",
          'Concours d’infractions',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00009",
          'Distinguer concours réel et concours idéal',
        ),
        points: [
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00010",
            'Le concours réel résulte de plusieurs faits distincts constituant plusieurs infractions.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00011",
            'Le concours idéal apparaît lorsqu’un même fait reçoit plusieurs qualifications.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00012",
            'Le cumul des peines reste soumis aux règles et plafonds prévus par les textes.',
          ),
        ],
      ),
      SanctionLessonSection(
        number: '02',
        icon: Icons.filter_2_outlined,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00013",
          'Non bis in idem',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00014",
          'Pas de double condamnation pour les mêmes faits',
        ),
        points: [
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00015",
            'Comparer les faits, les parties, la période et la nature des sanctions.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00016",
            'Vérifier l’articulation entre procédures pénales et administratives.',
          ),
        ],
      ),
      SanctionLessonSection(
        number: '03',
        icon: Icons.merge_type_rounded,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00017",
          'Confusion des peines',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00018",
          'Regrouper totalement ou partiellement des peines',
        ),
        points: [
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00019",
            'La confusion peut réunir des peines prononcées pour des faits distincts.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00020",
            'La décision relève du juge et doit respecter les limites légales.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
            "f00021",
            'La motivation tient compte des faits et de la personnalité du condamné.',
          ),
        ],
      ),
    ],
    checklist: [
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
        "f00022",
        'Construire une chronologie précise des faits, lieux, victimes et qualifications.',
      ),
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
        "f00023",
        'Éviter les qualifications contradictoires ou les doubles poursuites.',
      ),
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
        "f00024",
        'Justifier concrètement toute demande de confusion ou son refus.',
      ),
    ],
    links: [
      SanctionLessonLink(
        icon: Icons.gavel_rounded,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00025",
          'Classification des peines',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00026",
          'Natures, alternatives et mesures de sûreté',
        ),
        route: '/pa/dps_dpg/sanctions/classification_peines',
      ),
      SanctionLessonLink(
        icon: Icons.trending_up_rounded,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00027",
          'Causes d’aggravation',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/pluralite_infractions_page.dart",
          "f00028",
          'Récidive et circonstances aggravantes',
        ),
        route: '/pa/dps_dpg/sanctions/causes_aggravation',
      ),
    ],
  );
}
