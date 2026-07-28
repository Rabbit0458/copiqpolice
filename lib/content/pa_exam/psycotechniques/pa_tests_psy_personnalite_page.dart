// COP'IQ — Tests psychotechniques PA : « Personnalité & comportements ».
// Page pédagogique distincte des exercices : repères pour aborder les
// questionnaires de personnalité de la sélection Policier Adjoint.
// Aucune donnée psychologique n'est collectée, aucun diagnostic n'est posé.

import 'package:flutter/material.dart';

import 'pa_psycho_brand.dart';
import 'pa_tests_psy_hub_pages.dart';

class PaTestsPsyPersonnalitePage extends StatelessWidget {
  static const String routeName = PaTestsPsyRoutes.personnalite;
  const PaTestsPsyPersonnalitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaPsyScaffold(
      badge: 'Personnalité & comportements',
      title: 'Aborder les questionnaires de personnalité',
      subtitle:
          'Des repères simples pour répondre sereinement, sans chercher à '
          '« jouer un rôle ». Cette section est pédagogique : elle ne pose '
          'aucun diagnostic et n’enregistre aucun profil psychologique.',
      headerIcon: Icons.self_improvement_rounded,
      headerColor: PaPsychoBrand.cPersonnalite,
      children: const [
        PaPsyReveal(
          index: 3,
          child: PaPsyInfoBlock(
            title: 'La cohérence avant tout',
            icon: Icons.link_rounded,
            color: PaPsychoBrand.cPersonnalite,
            text:
                'Les questionnaires reposent souvent sur des questions '
                'proches posées de plusieurs manières. Des réponses '
                'contradictoires se remarquent immédiatement. Réponds avec '
                'constance : mieux vaut un profil naturel et cohérent qu’un '
                'personnage idéal impossible à tenir.',
          ),
        ),
        PaPsyReveal(
          index: 4,
          child: PaPsyInfoBlock(
            title: 'L’honnêteté paie',
            icon: Icons.verified_user_rounded,
            color: PaPsychoBrand.good,
            text:
                'Chercher à deviner « la bonne réponse » conduit à des '
                'profils artificiels et incohérents. Les évaluateurs '
                'cherchent des personnes fiables et stables, pas des '
                'candidats parfaits. Réponds en pensant à ce que tu fais '
                'réellement, pas à ce que tu crois qu’on attend.',
          ),
        ),
        PaPsyReveal(
          index: 5,
          child: PaPsyInfoBlock(
            title: 'Comportements professionnels',
            icon: Icons.local_police_rounded,
            color: PaPsychoBrand.cRaisonnement,
            text:
                'Le métier de Policier Adjoint demande du sang-froid, le '
                'respect du cadre hiérarchique, le sens du travail en '
                'équipe et la maîtrise de soi face à des situations '
                'tendues. Lorsque des mises en situation te sont proposées, '
                'privilégie les réponses mesurées : alerter, rendre compte, '
                'appliquer les consignes, garder son calme.',
          ),
        ),
        PaPsyReveal(
          index: 6,
          child: PaPsyInfoBlock(
            title: 'Stabilité et gestion des émotions',
            icon: Icons.favorite_rounded,
            color: PaPsychoBrand.warn,
            text:
                'Le questionnaire peut aborder ta réaction au stress, à la '
                'fatigue ou à la critique. Il est normal d’avoir des '
                'émotions ; ce qui compte, c’est de montrer que tu sais les '
                'reconnaître et les canaliser. Évite les réponses extrêmes '
                'systématiques (« jamais », « toujours ») lorsqu’une '
                'réponse nuancée est plus fidèle.',
          ),
        ),
        PaPsyReveal(
          index: 7,
          child: PaPsyInfoBlock(
            title: 'Entraînement ≠ diagnostic',
            icon: Icons.info_rounded,
            color: PaPsychoBrand.accent,
            text:
                'COP’IQ ne reproduit pas les tests officiels de '
                'personnalité, qui sont des outils protégés administrés par '
                'des professionnels. Cette page t’aide simplement à '
                'comprendre l’esprit de l’exercice. Aucun résultat, score '
                'ou profil psychologique n’est calculé ni enregistré ici.',
          ),
        ),
      ],
    );
  }
}
