import 'package:flutter/material.dart';
import 'package:copiqpolice/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaCausesAggravationPage extends StatelessWidget {
  const PaCausesAggravationPage({super.key});
  static const String routeName = '/pa/dps_dpg/sanctions/causes_aggravation';

  @override
  Widget build(BuildContext context) => PremiumSanctionLessonPage(
    appBarTitle: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
      "f00001",
      'Causes d’aggravation',
    ),
    heroTitle: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
      "f00002",
      'Aggravation de la sanction',
    ),
    heroSubtitle: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
      "f00003",
      'Identifier ce qui augmente la qualification ou l’échelle de la peine.',
    ),
    objective: ScolariteText.value(
      "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
      "f00004",
      'Reconnaître la récidive, les circonstances aggravantes et les qualités protégées, puis relever les éléments nécessaires dans la procédure.',
    ),
    keywords: [
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
        "f00005",
        'Récidive',
      ),
      'Circonstances',
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
        "f00006",
        'Victime protégée',
      ),
      'Motivation',
    ],
    sections: [
      SanctionLessonSection(
        number: '01',
        icon: Icons.history_rounded,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00007",
          'Récidive légale',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00008",
          'Antécédent définitif et délais légaux',
        ),
        points: [
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00009",
            'Vérifier l’existence d’une condamnation définitive et la nature de la nouvelle infraction.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00010",
            'Contrôler les délais légaux avant de retenir la récidive.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00011",
            'Relever les références et dates du jugement antérieur.',
          ),
        ],
      ),
      SanctionLessonSection(
        number: '02',
        icon: Icons.warning_amber_rounded,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00012",
          'Circonstances aggravantes',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00013",
          'Contexte, moyen employé et qualité de la victime',
        ),
        points: [
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00014",
            'Vulnérabilité, autorité publique, préméditation, réunion ou bande organisée.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00015",
            'Arme, véhicule utilisé comme arme ou commission dans un lieu protégé.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00016",
            'L’aggravation peut relever le maximum ou modifier la qualification.',
          ),
        ],
      ),
      SanctionLessonSection(
        number: '03',
        icon: Icons.verified_user_outlined,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00017",
          'Qualités protégées',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00018",
          'Statut de la victime ou relation avec l’auteur',
        ),
        points: [
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00019",
            'Mineur, conjoint, magistrat, policier ou autre qualité prévue par le texte.',
          ),
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
            "f00020",
            'La qualité et le contexte doivent apparaître précisément dans la procédure.',
          ),
        ],
      ),
    ],
    checklist: [
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
        "f00021",
        'Rassembler les pièces objectives : jugement, casier, constatations et témoignages.',
      ),
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
        "f00022",
        'Identifier la circonstance exacte et vérifier le texte applicable.',
      ),
      ScolariteText.value(
        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
        "f00023",
        'Distinguer clairement qualification aggravée et individualisation de la peine.',
      ),
    ],
    links: [
      SanctionLessonLink(
        icon: Icons.gavel_rounded,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00024",
          'Classification des peines',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00025",
          'Peines principales, complémentaires et mesures de sûreté',
        ),
        route: '/pa/dps_dpg/sanctions/classification_peines',
      ),
      SanctionLessonLink(
        icon: Icons.account_tree_outlined,
        title: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00026",
          'Pluralité d’infractions',
        ),
        subtitle: ScolariteText.value(
          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_page.dart",
          "f00027",
          'Concours, cumul et confusion des peines',
        ),
        route: '/pa/dps_dpg/sanctions/pluralite_infractions',
      ),
    ],
  );
}
