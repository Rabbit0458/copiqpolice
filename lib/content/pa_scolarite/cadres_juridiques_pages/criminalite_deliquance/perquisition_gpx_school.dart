import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPerquisitionGpxSchool extends StatelessWidget {
  const PaPerquisitionGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/perquisitions';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
? const Color(0xFF111218)
: const Color(0xFFFDFDFE);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perquisitions – criminalité organisée',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle('2.1.5 - Les perquisitions'),
              const SizedBox(height: 4),
              const _Paragraph(
                'Dans le cadre de la criminalité et de la délinquance organisées, '
                'les perquisitions font l’objet de régimes dérogatoires précis, '
                'notamment pour les perquisitions de nuit, le trafic de stupéfiants, '
                'le proxénétisme et les perquisitions au domicile d’une personne gardée '
                'à vue ou détenue.',
              ),

              const SizedBox(height: 20),
              const _SubTitle(
                '2.1.5.1 - La perquisition de nuit dans les locaux d’habitation',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: '2.1.5.1.1 - Le principe',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-89 du Code de procédure pénale dispose : ',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '« Si les nécessités de l’enquête de flagrance relative à l’une des '
                          'infractions entrant dans le champ d’application des articles '
                          '706-73 et 706-73-1 du Code de procédure pénale l’exigent, le juge des '
                          'libertés et de la détention du tribunal judiciaire peut, à la requête '
                          'du procureur de la République, autoriser que les perquisitions, '
                          'visites domiciliaires et saisies de pièces à conviction soient '
                          'opérées en dehors des heures prévues à l’article 59. »',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le régime dérogatoire est uniquement applicable aux infractions entrant '
                    'dans le champ des articles 706-73 et 706-73-1 du Code de procédure pénale, '
                    'lorsque les nécessités de l’enquête l’exigent.',
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: '2.1.5.1.2 - Les conditions de mise en œuvre',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-92 du Code de procédure pénale précise les modalités qui '
                          'doivent être respectées, à peine de nullité :',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'La perquisition doit être déterminée : l’autorisation à perquisitionner '
                    'ne doit pas être de portée générale. L’ordonnance doit être précise, '
                    'notamment sur le lieu et le moment de l’intervention.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'La perquisition doit faire l’objet d’une autorisation écrite du juge des '
                    'libertés et de la détention, à la requête du procureur de la République. '
                    'Cette autorisation prend la forme d’une ordonnance :',
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'précisant la qualification de l’infraction dont la preuve est recherchée ;',
                  ),
                  _BulletPoint(
                    text:
                        'précisant l’adresse des lieux concernés par les visites, perquisitions '
                        'et saisies ;',
                  ),
                  _BulletPoint(
                    text:
                        'motivée au regard des éléments de droit et de fait justifiant que la '
                        'perquisition est nécessaire et qu’elle ne peut être réalisée pendant '
                        'les heures légales (risque de déperdition des preuves, urgence, etc.).',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’autorisation est sollicitée par le procureur de la République qui dirige '
                    'l’enquête auprès du juge des libertés et de la détention compétent sur le '
                    'même tribunal judiciaire, quelle que soit la juridiction dans le ressort '
                    'de laquelle la perquisition doit avoir lieu. Le procureur de la République '
                    'peut également saisir le juge des libertés et de la détention du tribunal '
                    'judiciaire dans le ressort duquel la perquisition doit se dérouler, par '
                    'l’intermédiaire du procureur de la République de cette juridiction.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Les opérations sont réalisées sous le contrôle du magistrat qui les a '
                    'autorisées. Pour veiller au respect des dispositions légales, ce magistrat '
                    'peut se déplacer sur les lieux, quelle que soit leur localisation sur '
                    'l’ensemble du territoire national.',
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Version au 01/07/2025 – SDCP – Tous droits réservés.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title:
                    '2.1.5.1.3 - L’objet de la perquisition en matière de criminalité organisée',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-93 du Code de procédure pénale précise que les perquisitions '
                          'prévues par les articles 706-89 à 706-91 du Code de procédure pénale ne '
                          'peuvent avoir pour objet que la recherche et la constatation des '
                          'infractions visées dans la décision du juge des libertés et de la '
                          'détention ou du juge d’instruction.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le fait que les perquisitions révèlent des infractions autres que celles '
                    'visées dans la décision du juge des libertés et de la détention (ou du '
                    'juge d’instruction en commission rogatoire) ne constitue pas, en soi, une '
                    'cause de nullité des procédures incidentes.',
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.5.2 - Le maintien de deux régimes spécifiques',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title:
                    '2.1.5.2.1 - Perquisitions en matière de trafic de stupéfiants',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-28 du Code de procédure pénale dispose : ',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '« Pour la recherche et la constatation des infractions visées à '
                          'l’article 706-26, les visites, perquisitions et saisies prévues par '
                          'l’article 59 peuvent être opérées en dehors des heures prévues par '
                          'cet article à l’intérieur des locaux où l’on use en société de '
                          'stupéfiants ou dans lesquels sont fabriqués, transformés ou '
                          'entreposés illicitement des stupéfiants, lorsqu’il ne s’agit pas de '
                          'locaux d’habitation. Les actes prévus au présent article ne peuvent, '
                          'à peine de nullité, avoir un autre objet que la recherche et la '
                          'constatation des infractions visées à l’article 706-26. »',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'La possibilité pour l’officier de police judiciaire de s’affranchir du '
                    'respect des heures légales tient à la nature des locaux dans lesquels les '
                    'visites, perquisitions ou saisies peuvent être opérées. Il s’agit soit de '
                    'locaux « où l’on use en société de stupéfiants », soit de locaux servant à '
                    'la fabrication, la transformation ou l’entrepôt illicite de stupéfiants.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’officier de police judiciaire n’a pas à solliciter l’autorisation écrite '
                    'du juge des libertés et de la détention, à la demande du procureur de la '
                    'République (ou du juge d’instruction en commission rogatoire).',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Cependant, l’article 706-28 du Code de procédure pénale exclut la '
                    'réalisation de perquisitions de ce type dans une maison d’habitation ou '
                    'un appartement. Si l’officier de police judiciaire doit intervenir dans des '
                    'locaux d’habitation en dehors des heures légales, il doit recourir aux '
                    'dispositions générales de l’article 706-89 du Code de procédure pénale.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Le recours à l’article 706-28 du Code de procédure pénale est ouvert pour la '
                          'recherche et la constatation des infractions visées aux articles '
                          '222-34 à 222-40 du code pénal, ainsi que du délit de participation à '
                          'une association de malfaiteurs prévu par l’article 450-1 du code pénal '
                          'lorsqu’il a pour objet de préparer l’une des infractions des articles '
                          '222-34 à 222-40 du code pénal.',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Tout procès-verbal de visite, perquisition et saisies effectués en application '
                          'de l’article 706-28 du Code de procédure pénale pour la recherche ou la '
                          'constatation d’infractions autres que celles visées est frappé de nullité.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title:
                    '2.1.5.2.2 - Perquisitions en matière de proxénétisme (article 706-35 du Code de procédure pénale)',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-35 du Code de procédure pénale dispose : ',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '« Pour la recherche et la constatation des infractions visées à '
                          'l’article 706-34, les visites, perquisitions et saisies prévues par '
                          'l’article 59 peuvent être opérées à toute heure du jour et de la '
                          'nuit, à l’intérieur de tout hôtel, maison meublée, pension, débit de '
                          'boissons, club, cercle, dancing, lieu de spectacle et leurs annexes '
                          'et en tout autre lieu ouvert au public ou utilisé par le public '
                          'lorsqu’il est constaté que des personnes se livrant à la prostitution '
                          'y sont reçues habituellement. Les actes prévus au présent article ne '
                          'peuvent, à peine de nullité, être effectués pour un autre objet que '
                          'la recherche et la constatation des infractions visées à l’article '
                          '706-34. »',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Deux conditions de fond doivent être cumulativement remplies :',
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'il doit s’agir, d’abord, de certains lieux publics, mixtes ou privés '
                        'limitativement désignés, et plus généralement de tout autre lieu '
                        'ouvert au public ou utilisé par le public ;',
                  ),
                  _BulletPoint(
                    text:
                        'il importe, par ailleurs, qu’il soit constaté la réception habituelle '
                        'en ces lieux de personnes se livrant à la prostitution.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Le recours à l’article 706-35 du Code de procédure pénale est ouvert, à peine '
                          'de nullité, exclusivement pour la recherche et la constatation des '
                          'infractions visées aux articles 225-5 à 225-12-4 du code pénal, ainsi '
                          'que du délit de participation à une association de malfaiteurs prévu '
                          'par l’article 450-1 du code pénal lorsqu’il a pour objet de préparer '
                          'l’une de ces infractions.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Seuls les crimes et délits de proxénétisme aggravé prévus par les '
                            'articles 225-7 à 225-12 du code pénal relèvent de la criminalité '
                            'organisée. Le champ d’application de l’article 706-35 du Code de '
                            'procédure pénale est donc plus large que celui de la criminalité '
                            'organisée stricto sensu.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle(
                '2.1.5.3 - La perquisition au domicile d’une personne gardée à vue ou détenue',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title:
                    'Perquisition au domicile d’une personne gardée à vue ou détenue',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Les dispositions de l’article 706-94 du Code de procédure pénale permettent à '
                          'l’officier de police judiciaire, dans le cadre de l’une des infractions '
                          'prévues aux articles 706-73 et 706-73-1 du Code de procédure pénale, de '
                          'perquisitionner au domicile d’une personne gardée à vue ou détenue, en '
                          'dehors de sa présence, dans les conditions suivantes :',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        'Le transport sur place de l’intéressé doit être évité en raison de '
                        'risques graves :',
                  ),
                  _BulletPoint(text: 'troubles à l’ordre public ;'),
                  _BulletPoint(text: 'risque d’évasion ;'),
                  _BulletPoint(
                    text:
                        'risque de disparition des preuves pendant le temps nécessaire au transport.',
                  ),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        'L’officier de police judiciaire doit recueillir l’accord préalable du '
                        'procureur de la République (ou du juge d’instruction en commission '
                        'rogatoire). L’autorisation écrite du magistrat doit être jointe à la '
                        'procédure.',
                  ),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        'Le respect des droits de la défense doit être assuré par la présence, '
                        'lors des opérations de perquisition :',
                  ),
                  _BulletPoint(
                    text:
                        'soit de deux témoins requis par l’officier de police judiciaire dans les '
                        'conditions de l’article 57 du Code de procédure pénale ;',
                  ),
                  _BulletPoint(
                    text:
                        'soit d’un représentant désigné par la personne dont le domicile est en cause.',
                  ),
                ],
              ),

              const SizedBox(height: 26),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Version au 01/07/2025 – SDCP – Tous droits réservés. '
                        'Veiller à vérifier régulièrement les éventuelles réformes du Code de '
                        'procédure pénale ou du code pénal impactant ces régimes de '
                        'perquisition.',
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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
              ),
            ),
          ),
        ],
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
