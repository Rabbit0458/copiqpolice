import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPAutoritesInvestiesPJHabituellesPage extends StatelessWidget {
  const PPAutoritesInvestiesPJHabituellesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_autorites_investies_pj_habituelles';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF0D47A1); // bleu foncé
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.88);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF111317) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Autorités de police judiciaire',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================== TITRE PRINCIPAL =======================
              Text(
                'Chapitre 1 – Les autorités investies de\nfonctions habituelles de police judiciaire',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  height: 1.15,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Comme le précise le texte, la police judiciaire est composée des officiers de police judiciaire, '
                      'des agents de police judiciaire et des agents de police judiciaire adjoints, des assistants d’enquête, '
                      'ainsi que des fonctionnaires et agents auxquels sont attribuées certaines fonctions de police judiciaire. '
                      'Ces autorités exercent les missions définies par ',
                ),
                TextSpan(
                  text: 'l’Article 14 du Code de Procédure Pénale',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : constater les infractions à la loi pénale, en rassembler les preuves '
                      'et en rechercher les auteurs, tant qu’une information n’est pas ouverte.',
                ),
              ]),
              const SizedBox(height: 10),

              const _IntroBullet(
                text:
                    'Officiers, agents et agents adjoints de police judiciaire sont le cœur opérationnel des enquêtes pénales.',
              ),
              const _IntroBullet(
                text:
                    'Des assistants d’enquête et de nombreux fonctionnaires spécialisés complètent le dispositif, chacun dans un domaine précis.',
              ),

              const SizedBox(height: 22),

              // ================== 1.1 OFFICIERS DE POLICE JUDICIAIRE ========
              _ConditionCard(
                title: '1.1 Les officiers de police judiciaire (O.P.J.)',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _SubTitle(
                    '1.1.1 La liste des officiers de police judiciaire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Le Code de Procédure Pénale réserve aux officiers de police judiciaire un rôle prééminent : '
                          'ils exercent tous les pouvoirs définis par ',
                    ),
                    TextSpan(
                      text: 'l’Article 14 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ', commandent les agents de police judiciaire et sont en relation directe avec le procureur de la République et le juge d’instruction. '
                          'La qualité d’officier de police judiciaire est énumérée par ',
                    ),
                    TextSpan(
                      text: 'l’Article 16 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' :'),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(text: 'Les maires et leurs adjoints.'),
                  const _BulletPoint(
                    text:
                        'Les officiers et gradés de la gendarmerie, ainsi que certains gendarmes désignés nominativement après avis conforme d’une commission.',
                  ),
                  const _BulletPoint(
                    text:
                        'Les inspecteurs généraux, sous-directeurs de police active, contrôleurs généraux, commissaires de police, officiers de police et fonctionnaires du corps d’encadrement et d’application de la police nationale, désignés nominativement.',
                  ),
                  const _BulletPoint(
                    text:
                        'Les directeurs et sous-directeurs de la police judiciaire et les directeurs et sous-directeurs de la gendarmerie.',
                  ),
                  const SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: const [
                      TextSpan(
                        text:
                            'Certains fonctionnaires du corps de commandement et d’encadrement bénéficient, de façon limitée, de la qualité d’officier de police judiciaire pour la seule recherche des infractions au Code de la route et des atteintes involontaires à la vie et à l’intégrité commises à l’occasion d’accidents de la circulation. Ils ne peuvent ni décider d’une garde à vue, ni visiter les véhicules.',
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle('1.1.2 La réserve opérationnelle'),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Lorsqu’ils servent dans la réserve opérationnelle, les fonctionnaires de la police nationale ou les militaires de la gendarmerie nationale, '
                          'actifs ou à la retraite, ayant eu la qualité d’officier de police judiciaire, peuvent conserver cette qualité pendant cinq ans à compter de la date de leur départ à la retraite, '
                          'dans les conditions prévues par ',
                    ),
                    TextSpan(
                      text: 'l’Article 16-1 A du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        'Actualisation des connaissances et aptitude professionnelle requises.',
                  ),
                  const _BulletPoint(
                    text:
                        'Affectation sur des missions comportant l’exercice effectif des attributions d’officier de police judiciaire.',
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle('1.1.3 Mode de désignation et habilitation'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Pour certaines catégories, la qualité d’officier de police judiciaire résulte de plein droit de la fonction (maire, adjoint, directeur ou sous-directeur de la police judiciaire ou de la gendarmerie). '
                          'Pour les autres, la désignation suit les règles fixées par les textes réglementaires, puis est complétée par une habilitation du procureur général. '
                          'Ainsi, les fonctionnaires mentionnés aux 2°, 3° et 4° de ',
                    ),
                    TextSpan(
                      text: 'l’Article 16 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' et ceux visés par l’Article 16-1 A ne peuvent exercer leurs attributions que s’ils sont affectés à un emploi comportant cet exercice '
                          'et en vertu d’une décision du procureur général près la cour d’appel les habilitant personnellement.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        'Habilitation personnelle délivrée par le procureur général près la cour d’appel.',
                  ),
                  const _BulletPoint(
                    text:
                        'Possibilité de suspension ou retrait d’habilitation en cas de manquement.',
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    '1.1.4 Attributions des officiers de police judiciaire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les officiers de police judiciaire sont chargés de constater les infractions à la loi pénale, d’en rassembler les preuves et d’en rechercher les auteurs, tant qu’aucune information n’est ouverte, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article 14 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. Ils exécutent également les délégations et réquisitions des juridictions d’instruction, reçoivent les plaintes et dénonciations, mènent les enquêtes de flagrance ou préliminaires et réalisent les enquêtes patrimoniales prévues par ',
                    ),
                    TextSpan(
                      text: 'l’Article 17 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Ils doivent rendre compte sans délai au procureur de la République des infractions dont ils ont connaissance et lui adresser directement leurs procès-verbaux à la clôture des opérations. Les délégations des juridictions d’instruction donnent lieu aux mêmes obligations de compte rendu.',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ================== 1.2 AGENTS DE POLICE JUDICIAIRE ==========
              _ConditionCard(
                title:
                    '1.2 Les agents de police judiciaire (A.P.J. et A.P.J.A.)',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _SubTitle(
                    '1.2.1 Catégories d’agents de police judiciaire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Après les officiers, le Code de Procédure Pénale mentionne les agents de police judiciaire, répartis en deux groupes : les agents de police judiciaire proprement dits et les agents de police judiciaire adjoints. '
                          'Les qualités sont définies notamment par ',
                    ),
                    TextSpan(
                      text:
                          'les Articles 20, 20-1 et 21 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        'Agents de police judiciaire : militaires de la gendarmerie nationale n’ayant pas la qualité d’officier de police judiciaire, fonctionnaires des services actifs de la police nationale, et certains réservistes bénéficiant d’une expérience suffisante.',
                  ),
                  const _BulletPoint(
                    text:
                        'Agents de police judiciaire adjoints : policiers adjoints, réservistes, agents de police municipale, gardes champêtres, contrôleurs de la préfecture de police, etc.',
                  ),

                  const SizedBox(height: 10),

                  const _SubTitle(
                    '1.2.2 Attributions des agents de police judiciaire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les agents de police judiciaire agissent sous l’autorité des officiers de police judiciaire qu’ils doivent seconder. '
                          'Ils constatent les crimes, délits et contraventions et en dressent procès-verbal, peuvent conduire des enquêtes préliminaires, '
                          'procéder à des auditions sur instruction d’un officier de police judiciaire et participer aux contrôles d’identité dans le respect de ',
                    ),
                    TextSpan(
                      text: 'l’Article 78-2 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. Ils n’ont pas compétence pour décider des mesures de garde à vue, mais en assurent fréquemment l’exécution matérielle.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Les agents de police judiciaire adjoints ont des attributions plus limitées : aide matérielle à l’enquête, constatation de certaines contraventions (notamment au Code de la route), '
                    'participation aux opérations sur instruction d’un officier de police judiciaire, relevé d’identité dans les conditions fixées par la loi, etc.',
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle(
                    '1.2.3 Compétence territoriale des agents de police judiciaire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les agents de police judiciaire et les agents de police judiciaire adjoints sont compétents dans les limites territoriales où ils exercent leurs fonctions habituelles, '
                          'ainsi que dans celles où l’officier de police judiciaire responsable du service auprès duquel ils sont mis à disposition exerce ses fonctions, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article 21-1 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. Lorsqu’ils secondent un officier de police judiciaire bénéficiant d’une extension de compétence, ils profitent de cette extension pour la durée de l’enquête.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),

              // ================== 1.3 ASSISTANTS D'ENQUÊTE ==================
              _ConditionCard(
                title: '1.3 Les assistants d’enquête',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Créés par la loi d’orientation et de programmation du ministère de l’Intérieur de 2023, les assistants d’enquête constituent une nouvelle catégorie d’acteurs de la police judiciaire. '
                          'Leur statut et leurs missions sont encadrés par ',
                    ),
                    TextSpan(
                      text: 'l’Article 21-3 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ', complété par les Articles réglementaires qui en précisent les modalités d’application.',
                    ),
                  ]),
                  const SizedBox(height: 8),

                  const _SubTitle('1.3.1 Statut'),
                  const _BulletPoint(
                    text:
                        'Recrutés parmi certains militaires du corps de soutien de la gendarmerie nationale, personnels administratifs de catégorie B et agents de police judiciaire adjoints.',
                  ),
                  const _BulletPoint(
                    text:
                        'Soumis à une formation spécifique et à un examen certifiant leur aptitude.',
                  ),
                  const _BulletPoint(
                    text:
                        'Entrée en fonction après prestation de serment devant le tribunal judiciaire du ressort d’affectation.',
                  ),

                  const SizedBox(height: 10),

                  const _SubTitle('1.3.2 Missions'),
                  const _Paragraph(
                    'Les assistants d’enquête ont pour mission de seconder les officiers et agents de police judiciaire de la police et de la gendarmerie nationales. '
                    'Ils agissent uniquement à la demande expresse et sous le contrôle de ces derniers, ne peuvent recevoir d’instructions que d’eux et sont tenus au secret professionnel. '
                    'Ils établissent des procès-verbaux pour les actes limitativement énumérés par la loi.',
                  ),
                  const SizedBox(height: 8),

                  const _SubTitle('Convocations et notifications'),
                  const _BulletPoint(
                    text:
                        'Convocation de personnes devant être entendues par un officier ou un agent de police judiciaire et contact d’un interprète si nécessaire.',
                  ),
                  const _BulletPoint(
                    text:
                        'Notification aux victimes de leurs droits en application de l’Article 10-2 du Code de Procédure Pénale.',
                  ),
                  const _BulletPoint(
                    text:
                        'Convocations en justice prévues par l’Article 390-1 du Code de Procédure Pénale.',
                  ),

                  const SizedBox(height: 8),

                  const _SubTitle('Réquisitions et garde à vue'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Avec l’autorisation préalable du procureur de la République ou du juge des libertés et de la détention lorsque cela est exigé, ils peuvent établir certaines réquisitions, notamment celles prévues par ',
                    ),
                    TextSpan(
                      text:
                          'les Articles 60, 60-1, 60-3, 77-1, 77-1-1 et 99-5 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. En matière de garde à vue, ils réalisent diverses diligences (informations des proches, de l’employeur, de l’avocat, organisation de l’examen médical) sur instruction de l’officier ou de l’agent de police judiciaire.',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),

              // ============== TABLEAUX DES PRÉROGATIVES =====================
              _ConditionCard(
                title:
                    '1.4 Principales prérogatives des O.P.J., A.P.J., A.P.J.A. et assistants d’enquête',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _Paragraph(
                    'Les tableaux ci-dessous synthétisent, à la manière de ton support papier, les principales prérogatives des différentes catégories d’acteurs de la police judiciaire selon le cadre procédural. '
                    'Ils sont consultables en faisant défiler horizontalement si nécessaire.',
                  ),
                  const SizedBox(height: 14),

                  const _SubTitle(
                    '1.4.1 En enquête de flagrance (Articles 53 à 73 du Code de Procédure Pénale)',
                  ),
                  const _PrerogativesTableFlagrance(),
                  const SizedBox(height: 16),

                  const _SubTitle(
                    '1.4.2 En enquête préliminaire (Articles 75 à 78 du Code de Procédure Pénale)',
                  ),
                  const _PrerogativesTablePreliminaire(),
                  const SizedBox(height: 16),

                  const _SubTitle(
                    '1.4.3 En commission rogatoire (Articles 81 et 151 à 155 du Code de Procédure Pénale)',
                  ),
                  const _PrerogativesTableCommission(),
                  const SizedBox(height: 16),

                  const _SubTitle(
                    '1.4.4 Autres cadres d’enquête (mort de cause inconnue ou suspecte, disparition inquiétante, découverte d’une personne gravement blessée)',
                  ),
                  const _PrerogativesTableAutresCadres(),
                  const SizedBox(height: 16),

                  const _SubTitle('1.4.5 Autres prérogatives spécifiques'),
                  const _PrerogativesTableAutres(),
                ],
              ),

              const SizedBox(height: 26),

              // =================== 1.5 AUTRES FONCTIONNAIRES ================
              _ConditionCard(
                title:
                    '1.5 Fonctionnaires et agents chargés de certaines fonctions de police judiciaire',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Au-delà de la police nationale et de la gendarmerie nationale, de nombreux fonctionnaires et agents disposent de pouvoirs de police judiciaire '
                          'dans un champ strictement défini par la loi : agents des services forestiers, douaniers, agents des finances publiques, officiers judiciaires de l’environnement, gardes particuliers, etc. '
                          'Leur intervention est encadrée notamment par ',
                    ),
                    TextSpan(
                      text:
                          'les Articles 22, 28, 28-1, 28-2, 28-1-1, 28-3 et 29 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 10),
                  const _BulletPoint(
                    text:
                        'Officiers de douane judiciaire et officiers fiscaux judiciaires : compétences nationales, prérogatives proches de celles des officiers de police judiciaire dans des domaines fiscaux et douaniers déterminés.',
                  ),
                  const _BulletPoint(
                    text:
                        'Officiers judiciaires de l’environnement : inspecteurs de l’Office français de la biodiversité habilités à enquêter sur les atteintes à l’environnement.',
                  ),
                  const _BulletPoint(
                    text:
                        'Gardes particuliers assermentés : constatation des atteintes aux propriétés dont ils ont la garde, dans un périmètre strictement limité par leur commission et leur agrément.',
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

// ======================================================================
//                       TABLEAUX DES PRÉROGATIVES
// ======================================================================

class _PrerogativesTableFlagrance extends StatelessWidget {
  const _PrerogativesTableFlagrance();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color headerBg = isDark
        ? const Color(0xFF1C2833)
        : const Color(0xFFE3F2FD);
    final Color headerText = isDark ? Colors.white : const Color(0xFF0D47A1);
    final TextStyle cellStyle = GoogleFonts.fustat(
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
    );

    TextSpan _art(String label) => TextSpan(
      text: label,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all<Color>(headerBg),
        columns: [
          DataColumn(
            label: Text(
              'Acte / Prérogative',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'O.P.J.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.\n(sous contrôle O.P.J.)',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.A.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Assistant\nd’enquête',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
        ],
        rows: [
          // Arrestation auteur présumé
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(text: 'Arrestation de l’auteur présumé ('),
                      _art('Article 73 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
          // Garde à vue
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Placement en garde à vue et notification des droits (',
                      ),
                      _art('Articles 63 à 64-1 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
          // Perquisitions
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Perquisitions, saisies et opérations de flagrance (',
                      ),
                      _art(
                        'Articles 54 à 56 et 57 du Code de Procédure Pénale',
                      ),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('OUI, sur ordre de l’O.P.J.', style: cellStyle)),
              DataCell(
                Text(
                  'Assistance matérielle\n(oui, sans pouvoir propre)',
                  style: cellStyle,
                ),
              ),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
          // Auditions témoins
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text: 'Auditions de témoins et personnes entendues (',
                      ),
                      _art('Article 61 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(
                Text(
                  'OUI, dans la limite fixée\npar l’O.P.J.',
                  style: cellStyle,
                ),
              ),
              DataCell(
                Text(
                  'Rédaction de rapports\net renseignements',
                  style: cellStyle,
                ),
              ),
              DataCell(
                Text(
                  'Préparation des convocations,\nappels téléphoniques',
                  style: cellStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrerogativesTablePreliminaire extends StatelessWidget {
  const _PrerogativesTablePreliminaire();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color headerBg = isDark
        ? const Color(0xFF1C2833)
        : const Color(0xFFE3F2FD);
    final Color headerText = isDark ? Colors.white : const Color(0xFF0D47A1);
    final TextStyle cellStyle = GoogleFonts.fustat(
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
    );

    TextSpan _art(String label) => TextSpan(
      text: label,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all<Color>(headerBg),
        columns: [
          DataColumn(
            label: Text(
              'Acte / Prérogative',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'O.P.J.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.\n(sous contrôle O.P.J.)',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.A.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Assistant\nd’enquête',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Enquête préliminaire d’initiative ou sur instruction (',
                      ),
                      _art('Article 75 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text: 'Réquisitions judiciaires simples (',
                      ),
                      _art(
                        'Articles 77-1 et 77-1-1 du Code de Procédure Pénale',
                      ),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(
                Text('OUI, sous contrôle\nd’un O.P.J.', style: cellStyle),
              ),
              DataCell(Text('NON', style: cellStyle)),
              DataCell(
                Text(
                  'Rédaction de certaines\nréquisitions après autorisation',
                  style: cellStyle,
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Perquisitions avec accord de la personne ou autorisation du juge des libertés et de la détention (',
                      ),
                      _art('Articles 76 et 76-1 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('Assistance matérielle', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrerogativesTableCommission extends StatelessWidget {
  const _PrerogativesTableCommission();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color headerBg = isDark
        ? const Color(0xFF1C2833)
        : const Color(0xFFE3F2FD);
    final Color headerText = isDark ? Colors.white : const Color(0xFF0D47A1);
    final TextStyle cellStyle = GoogleFonts.fustat(
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
    );

    TextSpan _art(String label) => TextSpan(
      text: label,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all<Color>(headerBg),
        columns: [
          DataColumn(
            label: Text(
              'Acte / Prérogative',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'O.P.J.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.\n(sous contrôle O.P.J.)',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.A.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Assistant\nd’enquête',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text: 'Exécution d’une commission rogatoire (',
                      ),
                      _art('Articles 81 et 151 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(
                Text(
                  'OUI, sur délégation\net contrôle de l’O.P.J.',
                  style: cellStyle,
                ),
              ),
              DataCell(
                Text('Assistance matérielle\naux opérations', style: cellStyle),
              ),
              DataCell(
                Text(
                  'Préparation des convocations,\nnotifications',
                  style: cellStyle,
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Perquisitions, saisies et actes techniques sur commission rogatoire (',
                      ),
                      _art('Articles 152 à 155 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(
                Text(
                  'OUI, sous le contrôle\nstrict de l’O.P.J.',
                  style: cellStyle,
                ),
              ),
              DataCell(Text('NON', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrerogativesTableAutresCadres extends StatelessWidget {
  const _PrerogativesTableAutresCadres();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color headerBg = isDark
        ? const Color(0xFF1C2833)
        : const Color(0xFFE3F2FD);
    final Color headerText = isDark ? Colors.white : const Color(0xFF0D47A1);
    final TextStyle cellStyle = GoogleFonts.fustat(
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
    );

    TextSpan _art(String label) => TextSpan(
      text: label,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all<Color>(headerBg),
        columns: [
          DataColumn(
            label: Text(
              'Cadre / Acte',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'O.P.J.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.\n(sous contrôle O.P.J.)',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.A.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Assistant\nd’enquête',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Décès de cause inconnue ou suspecte, disparition inquiétante, personne gravement blessée (',
                      ),
                      _art('Articles 74 et 74-1 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(
                Text('Direction des opérations,\nOUI', style: cellStyle),
              ),
              DataCell(
                Text(
                  'OUI, exécution de missions\nconfiées par l’O.P.J.',
                  style: cellStyle,
                ),
              ),
              DataCell(Text('Assistance matérielle', style: cellStyle)),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrerogativesTableAutres extends StatelessWidget {
  const _PrerogativesTableAutres();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color headerBg = isDark
        ? const Color(0xFF1C2833)
        : const Color(0xFFE3F2FD);
    final Color headerText = isDark ? Colors.white : const Color(0xFF0D47A1);
    final TextStyle cellStyle = GoogleFonts.fustat(
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white70 : const Color(0xFF1F1F1F),
    );

    TextSpan _art(String label) => TextSpan(
      text: label,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all<Color>(headerBg),
        columns: [
          DataColumn(
            label: Text(
              'Autres prérogatives',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'O.P.J.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'A.P.J.A.',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Assistant\nd’enquête',
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
                color: headerText,
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Contrôle d’identité et vérifications associées (',
                      ),
                      _art('Articles 78-1 à 78-6 du Code de Procédure Pénale'),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI', style: cellStyle)),
              DataCell(Text('OUI, sur ordre de l’O.P.J.', style: cellStyle)),
              DataCell(
                Text(
                  'OUI, dans certains cas\nprévus par la loi',
                  style: cellStyle,
                ),
              ),
              DataCell(Text('NON', style: cellStyle)),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                RichText(
                  text: TextSpan(
                    style: cellStyle,
                    children: [
                      const TextSpan(
                        text:
                            'Techniques spéciales d’enquête (surveillance, infiltration, interceptions) dans le cadre de la criminalité organisée (',
                      ),
                      _art(
                        'Articles 706-80 et suivants du Code de Procédure Pénale',
                      ),
                      const TextSpan(text: ')'),
                    ],
                  ),
                ),
              ),
              DataCell(Text('OUI, direction des opérations', style: cellStyle)),
              DataCell(
                Text(
                  'Participation possible\nsous autorité O.P.J.',
                  style: cellStyle,
                ),
              ),
              DataCell(Text('Assistance matérielle', style: cellStyle)),
              DataCell(
                Text(
                  'Transcriptions ou tâches\nmatérielles sur demande O.P.J.',
                  style: cellStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TES WIDGETS PERSONNALISÉS EXACTS                    ///
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
