import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaInfractionCriminaliteOrganiseePage extends StatelessWidget {
  const PaInfractionCriminaliteOrganiseePage({super.key});
  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/infractions';

  TextSpan _lawArticle(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(title: const Text('Infractions – Criminalité organisée')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle(
                'Les infractions relevant de la criminalité et délinquance organisées',
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La loi distingue trois catégories d\'infractions relevant de la '
                      'délinquance et de la criminalité organisées, en fonction de leur gravité. '
                      'Cette distinction a donné lieu à la rédaction des ',
                ),
                _lawArticle('articles 706-73'),
                const TextSpan(text: ' , '),
                _lawArticle('706-73-1'),
                const TextSpan(text: ' et '),
                _lawArticle('706-74'),
                const TextSpan(text: ' du Code de procédure pénale.'),
              ]),
              const SizedBox(height: 16),

              // 1.1
              _ConditionCard(
                title:
                    '1.1 – Les infractions listées à l’article 706-73 du Code de procédure pénale',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    const TextSpan(text: 'L’article '),
                    _lawArticle('706-73'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale énumère les formes les plus graves '
                          'et complexes de la criminalité et de la délinquance organisées. '
                          'Les nouveaux moyens d\'investigation et les règles procédurales '
                          'dérogatoires sont applicables à l’ensemble des infractions listées dans cet article :',
                    ),
                  ]),
                  const SizedBox(height: 10),

                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '1° Crime de meurtre commis en bande organisée prévu par le 8° de l\'article ',
                      ),
                      _lawArticle('221-4'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '1° bis Crime de meurtre commis en concours, au sens de l\'article ',
                      ),
                      _lawArticle('132-2'),
                      const TextSpan(
                        text:
                            ' du Code pénal, avec un ou plusieurs autres meurtres ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '2° Crime de tortures et d\'actes de barbarie commis en bande organisée prévu par l\'article ',
                      ),
                      _lawArticle('222-4'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '2° bis Crime de viol commis en concours, au sens de l’article ',
                      ),
                      _lawArticle('132-2'),
                      const TextSpan(
                        text:
                            ' du Code pénal, avec un ou plusieurs autres viols commis sur d’autres victimes ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '3° Crimes et délits de trafic de stupéfiants prévus par les articles ',
                      ),
                      _lawArticle('222-34 à 222-40'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '4° Crimes et délits d\'enlèvement et de séquestration commis en bande organisée prévus par l\'article ',
                      ),
                      _lawArticle('224-5-2'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '5° Crimes et délits aggravés de traite des êtres humains prévus par les articles ',
                      ),
                      _lawArticle('225-4-2 à 225-4-7'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '6° Crimes et délits aggravés de proxénétisme prévus par les articles ',
                      ),
                      _lawArticle('225-7 à 225-12'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '7° Crime de vol commis en bande organisée prévu par l\'article ',
                      ),
                      _lawArticle('311-9'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '8° Crimes aggravés d\'extorsion prévus par les articles ',
                      ),
                      _lawArticle('312-6'),
                      const TextSpan(text: ' et '),
                      _lawArticle('312-7'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '9° Crime de destruction, dégradation et détérioration d\'un bien commis en bande organisée prévu par l\'article ',
                      ),
                      _lawArticle('322-8'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '10° Crimes en matière de fausse monnaie prévus par les articles ',
                      ),
                      _lawArticle('442-1'),
                      const TextSpan(text: ' et '),
                      _lawArticle('442-2'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '11° Crimes et délits constituant des actes de terrorisme prévus par les articles ',
                      ),
                      _lawArticle('421-1 à 421-6'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '11° bis Crimes portant atteinte aux intérêts fondamentaux de la nation prévus au titre Iᵉʳ du livre IV du Code pénal et crimes mentionnés à l\'article ',
                      ),
                      _lawArticle('411-12'),
                      const TextSpan(
                        text:
                            ' du même code, commis dans le but de servir les intérêts d\'une puissance étrangère ou d\'une entreprise ou d\'une organisation étrangère ou sous contrôle étranger ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '12° Délits en matière d\'armes et de produits explosifs prévus aux articles ',
                      ),
                      _lawArticle('222-52 à 222-54'),
                      const TextSpan(text: ', '),
                      _lawArticle('222-56 à 222-59'),
                      const TextSpan(text: ', '),
                      _lawArticle('322-6-1'),
                      const TextSpan(text: ' et '),
                      _lawArticle('322-11-1'),
                      const TextSpan(text: ' du Code pénal, aux articles '),
                      _lawArticle('L. 2339-2'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 2339-3'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 2339-10'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 2341-4'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 2353-4'),
                      const TextSpan(text: ' et '),
                      _lawArticle('L. 2353-5'),
                      const TextSpan(
                        text: ' du Code de la défense ainsi qu\'aux articles ',
                      ),
                      _lawArticle('L. 317-2'),
                      const TextSpan(text: ' et '),
                      _lawArticle('L. 317-7'),
                      const TextSpan(
                        text: ' du Code de la sécurité intérieure ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '13° Crimes et délits d\'aide à l\'entrée, à la circulation et au séjour irréguliers d\'un étranger en France commis en bande organisée prévus par les articles ',
                      ),
                      _lawArticle('L. 823-1'),
                      const TextSpan(text: ' et '),
                      _lawArticle('L. 823-2'),
                      const TextSpan(
                        text:
                            ' du Code de l\'entrée et du séjour des étrangers et du droit d\'asile et crime de direction ou d\'organisation d\'un groupement ayant pour objet la commission de ces infractions prévu aux articles ',
                      ),
                      _lawArticle('L. 823-3'),
                      const TextSpan(text: ' et '),
                      _lawArticle('L. 823-3-1'),
                      const TextSpan(text: ' du même code ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '14° Délits de blanchiment prévus par les articles ',
                      ),
                      _lawArticle('324-1'),
                      const TextSpan(text: ' et '),
                      _lawArticle('324-2'),
                      const TextSpan(
                        text:
                            ' du Code pénal, ou de recel prévus par les articles ',
                      ),
                      _lawArticle('321-1'),
                      const TextSpan(text: ' et '),
                      _lawArticle('321-2'),
                      const TextSpan(
                        text:
                            ' du même code, du produit, des revenus ou des choses provenant des infractions mentionnées aux 1° à 13° ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '15° Crimes ou délits d\'association de malfaiteurs prévus par l\'article ',
                      ),
                      _lawArticle('450-1'),
                      const TextSpan(
                        text:
                            ' du Code pénal, lorsqu\'ils ont pour objet la préparation de l\'une des infractions mentionnées aux 1° à 14° et 17° ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '16° Délit de non-justification de ressources correspondant au train de vie, prévu par l\'article ',
                      ),
                      _lawArticle('321-6-1'),
                      const TextSpan(
                        text:
                            ' du Code pénal, lorsqu\'il est en relation avec l\'une des infractions mentionnées aux 1° à 15° et 17° ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '17° Crime de détournement d\'aéronef, de navire ou de tout autre moyen de transport commis en bande organisée prévu par l\'article ',
                      ),
                      _lawArticle('224-6-1'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '18° Crimes et délits punis de dix ans d\'emprisonnement, contribuant à la prolifération des armes de destruction massive et de leurs vecteurs entrant dans le champ d\'application de l\'article ',
                      ),
                      _lawArticle('706-167'),
                      const TextSpan(text: ' du Code de procédure pénale ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '19° Délit d\'exploitation d\'une mine ou de disposition d\'une substance concessible sans titre d\'exploitation ou autorisation, accompagné d\'atteintes à l\'environnement, commis en bande organisée, prévu à l\'article ',
                      ),
                      _lawArticle('L. 512-2'),
                      const TextSpan(
                        text:
                            ' du Code minier, lorsqu\'il est connexe avec l\'une des infractions mentionnées aux 1° à 17° du présent article ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '20° Délits mentionnés au dernier alinéa de l\'article ',
                      ),
                      _lawArticle('223-15-2'),
                      const TextSpan(text: ' et au 2° du III de l\'article '),
                      _lawArticle('223-15-3'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '21° Délits prévus au dernier alinéa de l\'article ',
                      ),
                      _lawArticle('414'),
                      const TextSpan(
                        text:
                            ' du Code des douanes, lorsqu\'ils sont commis en bande organisée (contrebande, importation ou exportation portant sur des marchandises dangereuses pour la santé, la moralité ou la sécurité publiques, dont la liste est fixée par arrêté du ministre chargé des douanes).',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    bodySpans: [
                      const TextSpan(
                        text:
                            'La décision n° 2004-492 DC du Conseil constitutionnel, rendue le 2 mars 2004, '
                            'apporte des précisions importantes sur les infractions de délinquance et de criminalité organisées retenues par la loi. '
                            'Le vol commis en bande organisée ne peut faire l\'objet de mesures dérogatoires en matière de procédure pénale que s\'il présente des éléments de gravité suffisants : '
                            'une atteinte grave à la sécurité, à la dignité ou à la vie des personnes doit être caractérisée. '
                            'Il appartient à l\'autorité judiciaire d\'apprécier l\'existence de tels éléments de gravité. ',
                      ),
                      const TextSpan(
                        text:
                            'Le Conseil constitutionnel a également précisé que le délit d\'aide au séjour irrégulier d\'un étranger en France, commis en bande organisée, ne saurait concerner les organisations humanitaires d\'aide aux étrangers. '
                            'De plus, s\'applique à la qualification d\'une telle infraction le principe énoncé à l\'article ',
                      ),
                      _lawArticle('121-3'),
                      const TextSpan(
                        text:
                            ' du Code pénal, selon lequel il n\'y a point de délit sans intention de le commettre.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 1.2
              _ConditionCard(
                title:
                    '1.2 – Les infractions listées à l’article 706-73-1 du Code de procédure pénale',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    const TextSpan(text: 'L’article '),
                    _lawArticle('706-73-1'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale réglemente un régime procédural spécifique pour les infractions suivantes :',
                    ),
                  ]),
                  const SizedBox(height: 10),

                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '1° Délit d\'escroquerie en bande organisée, prévu au dernier alinéa de l\'article ',
                      ),
                      _lawArticle('313-2'),
                      const TextSpan(
                        text:
                            ' du Code pénal, délit d\'atteinte aux systèmes de traitement automatisé de données commis en bande organisée, prévu à l\'article ',
                      ),
                      _lawArticle('323-4-1'),
                      const TextSpan(
                        text:
                            ' du même code, et délit d\'évasion commis en bande organisée prévu au second alinéa de l\'article ',
                      ),
                      _lawArticle('434-30'),
                      const TextSpan(text: ' du même code ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '2° Délits de dissimulation d\'activités ou de salariés, de recours aux services d\'une personne exerçant un travail dissimulé, de marchandage de main-d\'œuvre, de prêt illicite de main-d\'œuvre ou d\'emploi d\'étranger sans titre de travail, commis en bande organisée, prévus aux 1° et 3° de l\'article ',
                      ),
                      _lawArticle('L. 8221-1'),
                      const TextSpan(text: ' et aux articles '),
                      _lawArticle('L. 8221-3'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8221-5'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8224-1'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8224-2'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8231-1'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8234-1'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8234-2'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8241-1'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8243-1'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8243-2'),
                      const TextSpan(text: ', '),
                      _lawArticle('L. 8251-1'),
                      const TextSpan(text: ' et '),
                      _lawArticle('L. 8256-2'),
                      const TextSpan(text: ' du Code du travail ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text: '3° Délits de blanchiment, prévus à l\'article ',
                      ),
                      _lawArticle('324-1'),
                      const TextSpan(
                        text:
                            ' du Code pénal, ou de recel, prévus aux articles ',
                      ),
                      _lawArticle('321-1'),
                      const TextSpan(text: ' et '),
                      _lawArticle('321-2'),
                      const TextSpan(
                        text:
                            ' du même code, du produit, des revenus ou des choses provenant des infractions mentionnées aux 1° et 2° du présent article ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '3° bis Délits de blanchiment prévus à l\'article ',
                      ),
                      _lawArticle('324-2'),
                      const TextSpan(
                        text:
                            ' du Code pénal, à l\'exception de ceux mentionnés au 14° de l\'article ',
                      ),
                      _lawArticle('706-73'),
                      const TextSpan(text: ' du Code de procédure pénale ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '4° Crimes ou délits d\'association de malfaiteurs, prévus à l\'article ',
                      ),
                      _lawArticle('450-1'),
                      const TextSpan(
                        text:
                            ' du Code pénal, lorsqu\'ils ont pour objet la préparation de l\'une des infractions mentionnées aux 1° à 3° du présent article ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '4° bis Délit de concours à une organisation criminelle prévu à l\'article ',
                      ),
                      _lawArticle('450-1-1'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '5° Délit de non-justification de ressources correspondant au train de vie, prévu à l\'article ',
                      ),
                      _lawArticle('321-6-1'),
                      const TextSpan(
                        text:
                            ' du Code pénal, lorsqu\'il est en relation avec l\'une des infractions mentionnées aux 1° à 4° du présent article ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '6° Délits d\'importation, d\'exportation, de transit, de transport, de détention, de vente, d\'acquisition ou d\'échange d\'un bien culturel prévus à l\'article ',
                      ),
                      _lawArticle('322-3-2'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '7° Délits d\'atteintes au patrimoine naturel commis en bande organisée, prévus à l\'article ',
                      ),
                      _lawArticle('L. 415-6'),
                      const TextSpan(text: ' du Code de l\'environnement ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '8° Délits de trafic de produits phytopharmaceutiques commis en bande organisée, prévus au 3° de l\'article ',
                      ),
                      _lawArticle('L. 253-17-1'),
                      const TextSpan(text: ', au II des articles '),
                      _lawArticle('L. 253-15'),
                      const TextSpan(text: ' et '),
                      _lawArticle('L. 253-16'),
                      const TextSpan(text: ' et au III de l\'article '),
                      _lawArticle('L. 254-12'),
                      const TextSpan(
                        text: ' du Code rural et de la pêche maritime ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '9° Délits relatifs aux déchets mentionnés au I de l\'article ',
                      ),
                      _lawArticle('L. 541-46'),
                      const TextSpan(
                        text:
                            ' du Code de l\'environnement commis en bande organisée, prévus au VII du même article ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '10° Délit de participation à la tenue d\'une maison de jeux d\'argent et de hasard commis en bande organisée, prévu au premier alinéa de l\'article ',
                      ),
                      _lawArticle('L. 324-1'),
                      const TextSpan(
                        text:
                            ' du Code de la sécurité intérieure, et délits d\'importation, de fabrication, de détention, de mise à disposition de tiers, d\'installation et d\'exploitation d\'appareil de jeux d\'argent et de hasard ou d\'adresse commis en bande organisée, prévus au premier alinéa de l\'article ',
                      ),
                      _lawArticle('L. 324-4'),
                      const TextSpan(text: ' du même code ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '11° Délits portant atteinte aux intérêts fondamentaux de la nation prévus aux articles ',
                      ),
                      _lawArticle('411-5'),
                      const TextSpan(text: ', '),
                      _lawArticle('411-7'),
                      const TextSpan(text: ' et '),
                      _lawArticle('411-8'),
                      const TextSpan(
                        text: ', aux deux premiers alinéas de l\'article ',
                      ),
                      _lawArticle('412-2'),
                      const TextSpan(text: ', à l\'article '),
                      _lawArticle('413-1'),
                      const TextSpan(
                        text: ' et au troisième alinéa de l\'article ',
                      ),
                      _lawArticle('413-13'),
                      const TextSpan(
                        text:
                            ' du Code pénal, ainsi que les délits mentionnés à l\'article ',
                      ),
                      _lawArticle('411-12'),
                      const TextSpan(
                        text:
                            ' du même code, commis dans le but de servir les intérêts d\'une puissance étrangère ou d\'une entreprise ou d\'une organisation étrangère ou sous contrôle étranger, lorsque cette circonstance porte la durée de la peine d\'emprisonnement à cinq ans au moins ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '12° Délits d\'administration d\'une plateforme en ligne pour permettre la cession de produits, de contenus ou de services dont la cession, l\'offre, l\'acquisition ou la détention sont manifestement illicites et délits d\'intermédiation ou de séquestre ayant pour objet unique ou principal de mettre en œuvre, de dissimuler ou de faciliter ces opérations, prévus à l\'article ',
                      ),
                      _lawArticle('323-3-2'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '13° Délit de mise à disposition d\'instruments de facilitation de la fraude sociale en bande organisée prévu à l\'article ',
                      ),
                      _lawArticle('L. 114-13'),
                      const TextSpan(text: ' du Code de la sécurité sociale ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '14° Crimes et délits de corruption d\'agent public et de trafic d\'influence, prévus aux articles ',
                      ),
                      _lawArticle('432-11'),
                      const TextSpan(text: ', '),
                      _lawArticle('433-1'),
                      const TextSpan(text: ', '),
                      _lawArticle('433-2'),
                      const TextSpan(text: ', '),
                      _lawArticle('434-9'),
                      const TextSpan(text: ', '),
                      _lawArticle('434-9-1'),
                      const TextSpan(text: ', '),
                      _lawArticle('435-1 à 435-4'),
                      const TextSpan(text: ' et '),
                      _lawArticle('435-7 à 435-10'),
                      const TextSpan(text: ' du Code pénal ;'),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '15° Délits de corruption commis en bande organisée, prévus aux articles ',
                      ),
                      _lawArticle('445-1 à 445-2-2'),
                      const TextSpan(text: ' du Code pénal.'),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const _Paragraph(
                    'Ces différentes infractions bénéficient des règles dérogatoires applicables '
                    'en matière de criminalité organisée, à l\'exclusion de celles figurant à '
                    'l’article 706-88 du Code de procédure pénale relatives à la prolongation '
                    'exceptionnelle de la garde à vue de quatre jours.',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 1.3
              _ConditionCard(
                title:
                    '1.3 – Les infractions visées à l’article 706-74 du Code de procédure pénale',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    const TextSpan(text: 'L’article '),
                    _lawArticle('706-74'),
                    const TextSpan(
                      text:
                          ' du Code de procédure pénale liste une autre série d\'infractions pour lesquelles les règles procédurales spécifiques à la criminalité organisée ne sont applicables que dans les cas où la loi le prévoit expressément. Il s\'agit des :',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _LawBullet(
                    spans: [
                      TextSpan(
                        text:
                            '• crimes et délits commis en bande organisée, autres que ceux relevant des articles 706-73 et 706-73-1 du Code de procédure pénale ;',
                      ),
                    ],
                  ),
                  _LawBullet(
                    spans: [
                      const TextSpan(
                        text:
                            '• crimes ou délits d\'association de malfaiteurs prévus aux deuxième et troisième alinéas de l\'article ',
                      ),
                      _lawArticle('450-1'),
                      const TextSpan(
                        text:
                            ' du Code pénal et ne concernant pas les infractions énumérées au 15° de l\'article ',
                      ),
                      _lawArticle('706-73'),
                      const TextSpan(
                        text:
                            ' du Code de procédure pénale ou du 4° de l\'article ',
                      ),
                      _lawArticle('706-73-1'),
                      const TextSpan(text: ' du même code.'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//--------------------------- Widgets perso + bullet riche --------------------

class _LawBullet extends StatelessWidget {
  const _LawBullet({required this.spans});

  final List<TextSpan> spans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_rounded,
            size: 18,
            color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1F1F1F).withValues(alpha: .92),
                ),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 16.5,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 15.5,
          color: isDark ? Colors.white : const Color(0xFF0D47A1),
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text!,
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans!,
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withValues(alpha: .95),
          ),
          children: [
            TextSpan(
              text: '$title : ',
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
