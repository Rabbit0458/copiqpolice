// Chemin : /gpx_scolarite_pages/procédure_pénale_pages/pp_juridictions_penales_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PpJuridictionsPenalesPage extends StatelessWidget {
  const PpJuridictionsPenalesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_juridictions_penales';

  // Helper pour les articles de loi en ROUGE
  TextSpan _law(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF111111) : const Color(0xFFF4F6FB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Juridictions pénales & voies de recours'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau d’en-tête / mémo version
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Version au 01/07/2025 – © COPIQ',
                  style: GoogleFonts.fustat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Les juridictions pénales jugent les infractions et appliquent les peines prévues par la loi. '
                      'On distingue les juridictions de droit commun, compétentes pour connaître de toutes les infractions '
                      'd’une catégorie déterminée, et les juridictions d’exception, dont la compétence est limitée par un texte particulier.',
                ),
              ]),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////////////
              /// 1. LES JURIDICTIONS DE DROIT COMMUN
              ////////////////////////////////////////////////////////
              _ConditionCard(
                title: '1.1 - Les juridictions de droit commun',
                cardColor: isDark ? const Color(0xFF1E2430) : Colors.white,
                accent: const Color(0xFF1565C0),
                titleColor: isDark
                    ? const Color(0xFFBBDEFB)
                    : const Color(0xFF0D47A1),
                children: [
                  const _SubTitle('1.1.1 - Le tribunal de police'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal de police juge les contraventions. Il est organisé et compétent selon les règles suivantes :\n\n',
                    ),
                  ]),
                  const _Paragraph(
                    'Organisation (1.1.1.1) : le tribunal de police est constitué par un juge du tribunal judiciaire, '
                    'un officier du ministère public et un greffier. Les fonctions du ministère public sont assurées '
                    'par le procureur de la République près le tribunal judiciaire ou par le commissaire de police selon les cas.',
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Compétence matérielle (1.1.1.2) : le tribunal de police est compétent pour juger toutes les contraventions. ',
                    ),
                    _law('Article 521 du Code de procédure pénale. '),
                    const TextSpan(
                      text:
                          'Il est également apte à connaître des contraventions connexes à un délit ou dont il a été saisi par erreur sous la qualification de délit.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Compétence territoriale : est compétent le tribunal de police du lieu de commission ou de constatation de l’infraction, '
                          'ou celui de la résidence du prévenu. ',
                    ),
                    _law('Article 522 alinéa 1 du Code de procédure pénale.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Pour certaines infractions (par exemple en matière de transports routiers), est compétent le tribunal du siège de l’entreprise détentrice du véhicule. ',
                    ),
                    _law('Article 522 alinéa 2 du Code de procédure pénale.'),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle('Modes de saisine (1.1.1.3)'),
                  const _Paragraph(
                    'Le tribunal de police peut être saisi par citation directe, convocation en justice, comparution volontaire ou renvoi d’une autre juridiction. '
                    'Les modes de saisine sont définis par le Code de procédure pénale, notamment pour la procédure de l’amende forfaitaire et la citation du prévenu.',
                  ),

                  const SizedBox(height: 16),
                  const _SubTitle('1.1.2 - Le tribunal correctionnel'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal correctionnel est la formation de jugement normale du tribunal judiciaire en matière pénale. '
                          'Il juge les délits, infractions punies d’une peine d’emprisonnement ou d’une amende importante. ',
                    ),
                    _law('Article 381 du Code de procédure pénale.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Composition (1.1.2.1) : dans sa formation ordinaire, le tribunal correctionnel est une juridiction collégiale composée d’un président et de deux juges. ',
                    ),
                    _law('Article 398 alinéa 1 du Code de procédure pénale.'),
                    const TextSpan(
                      text:
                          ' Le parquet est représenté par le procureur de la République. Pour certains délits énumérés par la loi, le tribunal peut siéger à juge unique.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Compétence (1.1.2.2) : le tribunal correctionnel juge tous les délits qui ne sont pas renvoyés devant une juridiction particulière. '
                          'Il peut également connaître de contraventions connexes à un délit. ',
                    ),
                    _law('Articles 381 et 466 du Code de procédure pénale.'),
                  ]),
                  const SizedBox(height: 8),
                  const _SubTitle('Modes de saisine (1.1.2.3)'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les modes de saisine du tribunal correctionnel sont listés par le Code de procédure pénale : comparution volontaire, citation directe, convocation en justice, '
                          'convocation par procès-verbal ("rendez-vous judiciaire"), comparution immédiate, comparution différée, ordonnance de renvoi du juge d’instruction ou de la chambre de l’instruction, '
                          'saisine d’office en cas d’infraction à l’audience, etc. ',
                    ),
                    _law(
                      'Articles 388, 389, 390, 390-1, 394, 395, 397-1-1, 419, 420-1, 675 à 678 du Code de procédure pénale.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Des procédures simplifiées existent : ordonnance pénale, comparution sur reconnaissance préalable de culpabilité, amende forfaitaire délictuelle. ',
                    ),
                    _law('Articles 495 à 495-25 du Code de procédure pénale.'),
                  ]),

                  const SizedBox(height: 16),
                  const _SubTitle('1.1.3 - La cour d’assises'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La cour d’assises juge les crimes. Elle est définie comme ayant plénitude de juridiction pour juger en premier ressort ou en appel les personnes renvoyées devant elle par décision de mise en accusation. ',
                    ),
                    _law('Article 231 du Code de procédure pénale.'),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Il existe une cour d’assises par département. Elle se tient en principe au siège de la cour d’appel ou au chef-lieu du département, dans les locaux du tribunal judiciaire.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Composition (1.1.3.1) : la cour d’assises comprend un élément professionnel, la cour, et un élément non professionnel, le jury. '
                    'La cour est composée d’un président et de deux assesseurs ; le jury est composé de six jurés en premier ressort et de neuf jurés en appel. '
                    'Un jury est tiré au sort à partir des listes électorales, selon une procédure encadrée par le Code de procédure pénale.',
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les jurés doivent prêter serment, notamment en référence à la présomption d’innocence et au principe selon lequel le doute profite à l’accusé. ',
                    ),
                    _law('Article 304 du Code de procédure pénale.'),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Le ministère public est représenté selon les cas par l’avocat général (lorsque la cour siège au siège de la cour d’appel) ou par le procureur de la République (lorsqu’elle siège dans les locaux du tribunal judiciaire).',
                  ),
                  const SizedBox(height: 10),

                  const _SubTitle('1.1.4 - La cour criminelle départementale'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La cour criminelle départementale est compétente pour juger en premier ressort les personnes majeures accusées de certains crimes punis de quinze ou vingt ans de réclusion criminelle, '
                          'lorsque le crime n’a pas été commis en état de récidive légale. Elle peut aussi connaître des délits connexes. ',
                    ),
                    _law(
                      'Articles 380-16 à 380-22 du Code de procédure pénale.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Elle est composée exclusivement de magistrats professionnels : un président et quatre assesseurs (sans jury populaire). '
                    'Les décisions sont motivées et susceptibles d’appel devant une autre cour d’assises.',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              ////////////////////////////////////////////////////////
              /// 1.2 - JURIDICTIONS D’EXCEPTION ET SPÉCIALISÉES
              ////////////////////////////////////////////////////////
              _ConditionCard(
                title: '1.2 - Les juridictions d’exception et spécialisées',
                cardColor: isDark ? const Color(0xFF1E2430) : Colors.white,
                accent: const Color(0xFF6A1B9A),
                titleColor: isDark
                    ? const Color(0xFFE1BEE7)
                    : const Color(0xFF4A148C),
                children: [
                  const _SubTitle('1.2.1 - Les juridictions pour mineurs'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les juridictions pour mineurs sont des juridictions d’exception dont la compétence est déterminée par la qualité de l’auteur (mineur) et par la nature de l’infraction. '
                          'Elles appliquent les règles du Code de justice pénale des mineurs et du Code de l’organisation judiciaire.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le juge des enfants est un magistrat spécialisé du siège, compétent pour juger les contraventions de 5ᵉ classe et de nombreux délits commis par les mineurs, '
                          'notamment selon la procédure de mise à l’épreuve éducative. ',
                    ),
                    _law(
                      'Article L.231-2 du Code de justice pénale des mineurs '
                      'et articles L.252-1 et suivants du Code de l’organisation judiciaire.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal pour enfants est présidé par le juge des enfants, assisté de deux assesseurs non professionnels choisis pour leur intérêt et leurs compétences en matière de protection de l’enfance. ',
                    ),
                    _law(
                      'Articles L.251-1 à L.251-6 du Code de l’organisation judiciaire.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La cour d’assises des mineurs est compétente pour les crimes commis par les mineurs de seize à dix-huit ans et pour certains délits ou crimes connexes. ',
                    ),
                    _law(
                      'Articles L.231-7 à L.231-10 du Code de justice pénale des mineurs '
                      'et 706-25 du Code de procédure pénale.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'L’appel des jugements rendus à l’égard des mineurs relève de la chambre spéciale des mineurs de la cour d’appel (chambre de l’enfance), '
                            'conformément aux dispositions du Code de justice pénale des mineurs.',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const _SubTitle(
                    '1.2.3 - Juridictions spécialisées en matière de terrorisme',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les crimes et délits à caractère terroriste peuvent être jugés par des juridictions parisiennes spécialisées (pôle antiterroriste du tribunal judiciaire de Paris et cour d’assises spéciale), '
                          'compétentes sur tout le territoire national. ',
                    ),
                    _law(
                      'Articles 706-16 à 706-25 du Code de procédure pénale.',
                    ),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En pratique, les crimes terroristes sont souvent confiés à la cour d’assises de Paris, composée uniquement de magistrats professionnels, '
                          'sans jury populaire. ',
                    ),
                    _law('Article 698-6 du Code de procédure pénale.'),
                  ]),

                  const SizedBox(height: 14),
                  const _SubTitle(
                    '1.2.4 - Juridictions spécialisées économiques et financières',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Dans les affaires d’une grande complexité en matière économique et financière (grand nombre d’auteurs, de victimes, opérations internationales, etc.), '
                          'la compétence territoriale d’un tribunal judiciaire peut être étendue au ressort de plusieurs cours d’appel pour l’enquête, la poursuite, l’instruction et le jugement. ',
                    ),
                    _law('Article 704 du Code de procédure pénale.'),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Un procureur de la République financier exerce ses attributions près le tribunal judiciaire de Paris, mais est compétent sur tout le territoire national pour la poursuite de certaines infractions économiques et financières. ',
                    ),
                    _law('Article 705 du Code de procédure pénale.'),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Certaines infractions boursières et financières sont expressément visées, notamment celles prévues aux articles L.465-1 à L.465-3-3 du Code monétaire et financier. ',
                    ),
                    _law(
                      'Articles 705-1 et 705-2 du Code de procédure pénale '
                      'et articles L.465-1 à L.465-3-3 du Code monétaire et financier.',
                    ),
                  ]),

                  const SizedBox(height: 14),
                  const _SubTitle(
                    '1.2.5 - Juridictions spécialisées en matière de criminalité organisée',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La compétence territoriale d’un tribunal judiciaire et d’une cour d’assises peut être étendue au ressort d’une ou plusieurs cours d’appel pour l’enquête, la poursuite, l’instruction et le jugement de certaines infractions de criminalité organisée, '
                          'celles listées à l’article 706-73 du Code de procédure pénale (terrorisme, trafics de stupéfiants, traite des êtres humains, crimes contre les intérêts fondamentaux de la Nation, etc.) '
                          'et à l’article 706-73-1. ',
                    ),
                    _law(
                      'Articles 706-73, 706-73-1 et 706-74 du Code de procédure pénale.',
                    ),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Pour ces infractions, le procureur de la République, le juge d’instruction et la formation correctionnelle spécialisée exercent une compétence concurrente à la compétence de droit commun. ',
                    ),
                    _law('Article 706-75 du Code de procédure pénale.'),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Huit juridictions interrégionales spécialisées (JIRS) ont été créées : Paris, Lyon, Marseille, Lille, Rennes, Bordeaux, Nancy et Fort-de-France. ',
                    ),
                    _law('Article D.47-3 du Code de procédure pénale.'),
                  ]),

                  const SizedBox(height: 14),
                  const _SubTitle(
                    '1.2.6 - Juridictions spécialisées en matière de crimes contre l’humanité et de crimes et délits de guerre',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les crimes contre l’humanité et les crimes et délits de guerre, ainsi que les infractions qui leur sont connexes, '
                          'sont susceptibles d’être jugés par les tribunaux territorialement compétents ou par des juridictions parisiennes spécialisées. ',
                    ),
                    _law('Article 628-1 du Code de procédure pénale.'),
                  ]),

                  const SizedBox(height: 14),
                  const _SubTitle(
                    '1.2.7 - Juridiction spécialisée dans les crimes sériels ou non élucidés',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le tribunal judiciaire de Nanterre, désigné comme pôle judiciaire national spécialisé, exerce une compétence concurrente avec les tribunaux territorialement compétents '
                          'pour l’enquête, la poursuite, l’instruction et le jugement des crimes sériels ou non élucidés, '
                          'ainsi que des crimes connexes. ',
                    ),
                    _law('Article 706-106-1 du Code de procédure pénale.'),
                  ]),
                  const SizedBox(height: 6),
                  const _IntroBullet(
                    text:
                        'Lorsque les investigations présentent une particulière complexité et :',
                  ),
                  const _IntroBullet(
                    text:
                        '✓ lorsque les crimes auront été commis ou seront susceptibles d’avoir été commis de manière répétée à des dates différentes par une même personne à l’encontre de différentes victimes ;',
                  ),
                  const _IntroBullet(
                    text:
                        '✓ et/ou lorsque leur auteur n’aura pas pu être identifié plus de 18 mois après la commission des faits.',
                  ),

                  const SizedBox(height: 14),
                  const _SubTitle('1.2.8 - Les autres juridictions'),
                  const _SubTitle('1.2.8.1 - Les tribunaux militaires'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les infractions militaires, ainsi que les crimes et délits de droit commun commis dans l’exercice du service par les militaires, '
                          'relèvent de juridictions spécialisées en matière militaire. En pratique, il s’agit d’un tribunal judiciaire par cour d’appel. ',
                    ),
                    _law('Article 697 du Code de procédure pénale.'),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Toute infraction commise par un militaire en dehors de l’exercice du service relève des juridictions de droit commun. ',
                    ),
                    _law('Article L.2 du Code de justice militaire.'),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Certains tribunaux judiciaires sont spécialement compétents pour les infractions commises par ou à l’encontre de militaires français hors du territoire national. ',
                    ),
                    _law('Article L.111-1 du Code de justice militaire.'),
                  ]),

                  const SizedBox(height: 10),
                  const _SubTitle(
                    '1.2.8.4 - Juridictions du littoral maritime spécialisées',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Certaines juridictions sont compétentes en matière de pollution des eaux maritimes par rejets de navires ou atteintes aux biens culturels maritimes. ',
                    ),
                    _law(
                      'Articles 706-107 à 706-111-2 du Code de procédure pénale.',
                    ),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Elles ont une compétence concurrente avec les tribunaux territorialement compétents, à tous les stades de la procédure : enquête, poursuite, instruction et jugement des infractions, '
                          'sauf pour certaines infractions commises en haute mer, qui relèvent de la compétence exclusive du tribunal judiciaire de Paris.',
                    ),
                  ]),

                  const SizedBox(height: 10),
                  const _SubTitle(
                    '1.2.8.5 - Juridictions en matière sanitaire et environnementale',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les articles 706-2 à 706-2-3 du Code de procédure pénale prévoient une procédure applicable aux infractions en matière sanitaire et environnementale. ',
                    ),
                    _law(
                      'Articles 706-2 à 706-2-3 du Code de procédure pénale.',
                    ),
                  ]),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La compétence territoriale d’un tribunal judiciaire peut être étendue au ressort d’une ou plusieurs cours d’appel pour l’enquête, la poursuite, l’instruction et, s’il s’agit de délits, le jugement des affaires complexes relatives :\n',
                    ),
                  ]),
                  const _IntroBullet(text: '✓ à un produit de santé ;'),
                  const _IntroBullet(
                    text:
                        '✓ à un produit destiné à l’alimentation de l’homme ou de l’animal ;',
                  ),
                  const _IntroBullet(
                    text:
                        '✓ à un produit ou une substance ou des pratiques et prestations de service médicales, paramédicales ou esthétiques régies en raison de leurs effets ou de leur dangerosité.',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Actuellement, les tribunaux judiciaires de Paris et Marseille sont désignés comme pôles spécialisés. ',
                    ),
                    _law('Article D.47-5 du Code de procédure pénale.'),
                  ]),
                ],
              ),

              const SizedBox(height: 24),

              ////////////////////////////////////////////////////////
              /// CHAPITRE 2 – LES VOIES DE RECOURS
              ////////////////////////////////////////////////////////
              _ConditionCard(
                title: 'CHAPITRE 2 : LES VOIES DE RECOURS',
                cardColor: isDark ? const Color(0xFF1E2430) : Colors.white,
                accent: const Color(0xFF3949AB),
                titleColor: isDark
                    ? const Color(0xFFC5CAE9)
                    : const Color(0xFF1A237E),
                children: [
                  const _SubTitle('2.1 - Les différentes voies de recours'),
                  const _Paragraph(
                    'Une décision rendue par une juridiction répressive n’acquiert autorité de chose jugée que lorsqu’elle n’est plus susceptible de voie de recours. '
                    'Selon la juridiction qui a rendu la décision, plusieurs voies de recours sont possibles et sont dirigées devant diverses instances.',
                  ),
                  const SizedBox(height: 10),

                  //////////////////////////////////////////////////
                  /// 2.1.1 - Voies de recours ordinaires
                  //////////////////////////////////////////////////
                  const _SubTitle('2.1.1 - Les voies de recours ordinaires'),
                  const _Paragraph(
                    'Ce sont celles qui sont ouvertes pour n’importe quel motif de fond ou de forme. '
                    'Elles comprennent essentiellement l’opposition et l’appel.',
                  ),

                  const SizedBox(height: 8),
                  const _SubTitle(
                    '2.1.1.1 - L’opposition (Art. 489 à 493-1 et 545 du C.P.P.)',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’opposition est possible lorsque le jugement a été rendu par défaut, c’est-à-dire lorsque le prévenu n’a pas comparu ou n’a pas été régulièrement avisé, '
                          'ou encore lorsqu’il justifie d’une excuse valable. ',
                    ),
                    _law(
                      'Articles 410, 412, 489 à 493-1 et 545 du Code de procédure pénale.',
                    ),
                  ]),
                  const SizedBox(height: 4),
                  const _SubTitle('2.1.1.1.1 - Délai'),
                  const _Paragraph(
                    'Le délai pour former opposition est en principe de 10 jours à compter de la signification du jugement si le prévenu réside en France métropolitaine, '
                    'et d’un mois s’il réside hors du territoire. Pour l’ordonnance pénale, des règles particulières s’appliquent.',
                  ),
                  const SizedBox(height: 4),
                  const _SubTitle('2.1.1.1.2 - Effet extinctif'),
                  const _Paragraph(
                    'L’opposition anéantit la décision rendue par défaut : celle-ci ne reçoit donc pas exécution. '
                    'L’opposition interrompt également la prescription de la peine et constitue le point de départ d’une nouvelle prescription de l’action publique.',
                  ),
                  const SizedBox(height: 4),
                  const _SubTitle('2.1.1.1.3 - Itératif défaut'),
                  const _Paragraph(
                    'Si le prévenu régulièrement avisé fait à nouveau défaut et ne comparaît pas, son opposition est déclarée non avenue. '
                    'La juridiction rend alors un jugement dit « débouté d’opposition » et la décision initiale reprend toute sa valeur. '
                    'Une nouvelle opposition n’est plus possible, mais la voie de l’appel reste ouverte.',
                  ),

                  const SizedBox(height: 10),
                  const _SubTitle('2.1.1.2 - L’appel'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’appel est une voie de recours qui permet à une juridiction supérieure de procéder à un nouvel examen de l’affaire jugée en première instance. ',
                    ),
                    _law(
                      'Articles 496 et suivants du Code de procédure pénale.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _SubTitle('2.1.1.2.1 - Décisions susceptibles d’appel'),
                  _Paragraph.rich([
                    const TextSpan(
                      text: 'Sont notamment susceptibles d’appel :\n',
                    ),
                  ]),
                  const _IntroBullet(
                    text:
                        '✓ les ordonnances juridictionnelles du juge d’instruction ou du juge des libertés et de la détention ;',
                  ),
                  const _IntroBullet(
                    text:
                        '✓ certaines décisions des juridictions de jugement ou de l’application des peines ;',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les jugements rendus en matière correctionnelle peuvent presque toujours faire l’objet d’un appel. '
                          'En matière contraventionnelle, l’appel n’est recevable que lorsque certaines conditions de gravité sont remplies. ',
                    ),
                    _law('Articles 496 et 546 du Code de procédure pénale.'),
                  ]),

                  const SizedBox(height: 6),
                  const _SubTitle('2.1.1.2.2 - Personnes pouvant former appel'),
                  const _Paragraph(
                    'Ont notamment qualité pour interjeter appel :\n'
                    '✓ en matière criminelle : l’accusé, le ministère public, le prévenu ou l’accusé, la partie civile pour ses seuls intérêts civils, la personne civilement responsable ;\n'
                    '✓ en matière correctionnelle : toutes les parties au procès (prévenu, ministère public, partie civile, civilement responsable, assureur, administrations poursuivantes…) ;\n'
                    '✓ en matière de police : le prévenu, la partie civile, la personne civilement responsable, le ministère public et, dans certains cas, même le procureur général.',
                  ),

                  const SizedBox(height: 6),
                  const _SubTitle('2.1.1.2.3 - Forme et délai'),
                  const _Paragraph(
                    'L’appel est formé par déclaration au greffe de la juridiction qui a rendu la décision. '
                    'Le délai est en principe de 10 jours à compter du prononcé du jugement ou de sa signification, selon le type de décision. '
                    'Des délais particuliers existent, notamment en matière de détention ou de mise en liberté.',
                  ),

                  const SizedBox(height: 6),
                  const _SubTitle('2.1.1.2.5 - Effets de l’appel'),
                  const _Paragraph(
                    '✓ Effet suspensif : le délai d’appel et, lorsque l’appel est formé, suspendent en principe l’exécution de la décision, sauf dans certains cas prévus par la loi (par exemple, maintien en détention).\n'
                    '✓ Effet dévolutif : l’affaire est rejugée par une juridiction supérieure (la cour d’appel, chambre des appels correctionnels ou chambre de l’instruction, selon les cas).',
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// TES WIDGETS PERSONNALISÉS EXACTS
///////////////////////////////////////////////////////////////////////////////

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
          border: Border.all(color: accent.withOpacity(.22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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

class _IntroBullet extends StatelessWidget {
  const _IntroBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.arrow_right_rounded,
              size: 18,
              color: bulletColor,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

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
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF1F1F1F).withOpacity(.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

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
        color: bgColor.withOpacity(isDark ? .7 : .95),
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
                : const Color(0xFF3E2723).withOpacity(.95),
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
