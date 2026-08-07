import 'package:flutter/material.dart';
import 'package:copiqpolice/content/pa_scolarite/sanction_pages/widgets/premium_sanction_lesson_page.dart';

class PaCausesAggravationPage extends StatelessWidget {
  const PaCausesAggravationPage({super.key});
  static const String routeName = '/pa/dps_dpg/sanctions/causes_aggravation';

  @override
  Widget build(BuildContext context) => const PremiumSanctionLessonPage(
    appBarTitle: 'Causes d’aggravation',
    heroTitle: 'Aggravation de la sanction',
    heroSubtitle:
        'Identifier ce qui augmente la qualification ou l’échelle de la peine.',
    objective:
        'Reconnaître la récidive, les circonstances aggravantes et les qualités protégées, puis relever les éléments nécessaires dans la procédure.',
    keywords: ['Récidive', 'Circonstances', 'Victime protégée', 'Motivation'],
    sections: [
      SanctionLessonSection(
        number: '01',
        icon: Icons.history_rounded,
        title: 'Récidive légale',
        subtitle: 'Antécédent définitif et délais légaux',
        points: [
          'Vérifier l’existence d’une condamnation définitive et la nature de la nouvelle infraction.',
          'Contrôler les délais légaux avant de retenir la récidive.',
          'Relever les références et dates du jugement antérieur.',
        ],
      ),
      SanctionLessonSection(
        number: '02',
        icon: Icons.warning_amber_rounded,
        title: 'Circonstances aggravantes',
        subtitle: 'Contexte, moyen employé et qualité de la victime',
        points: [
          'Vulnérabilité, autorité publique, préméditation, réunion ou bande organisée.',
          'Arme, véhicule utilisé comme arme ou commission dans un lieu protégé.',
          'L’aggravation peut relever le maximum ou modifier la qualification.',
        ],
      ),
      SanctionLessonSection(
        number: '03',
        icon: Icons.verified_user_outlined,
        title: 'Qualités protégées',
        subtitle: 'Statut de la victime ou relation avec l’auteur',
        points: [
          'Mineur, conjoint, magistrat, policier ou autre qualité prévue par le texte.',
          'La qualité et le contexte doivent apparaître précisément dans la procédure.',
        ],
      ),
    ],
    checklist: [
      'Rassembler les pièces objectives : jugement, casier, constatations et témoignages.',
      'Identifier la circonstance exacte et vérifier le texte applicable.',
      'Distinguer clairement qualification aggravée et individualisation de la peine.',
    ],
    links: [
      SanctionLessonLink(
        icon: Icons.gavel_rounded,
        title: 'Classification des peines',
        subtitle: 'Peines principales, complémentaires et mesures de sûreté',
        route: '/pa/dps_dpg/sanctions/classification_peines',
      ),
      SanctionLessonLink(
        icon: Icons.account_tree_outlined,
        title: 'Pluralité d’infractions',
        subtitle: 'Concours, cumul et confusion des peines',
        route: '/pa/dps_dpg/sanctions/pluralite_infractions',
      ),
    ],
  );
}
