import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommissionRogatoireGpxSchool extends StatelessWidget {
  const CommissionRogatoireGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/criminalite_organisee/commission_rogatoire';

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
        centerTitle: true,
        title: Text(
          'Commission rogatoire – criminalité organisée',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle(
                '2.3 – La procédure de commission rogatoire relative à la criminalité organisée',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Un certain nombre de dispositions procédurales relatives à la '
                'criminalité et à la délinquance organisées sont communes à '
                'l’enquête de flagrance et à l’exécution d’une commission rogatoire.',
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'La différence principale tient à l’autorité judiciaire compétente : '
                'dans le cadre d’une commission rogatoire, l’autorité délégante est '
                'le juge d’instruction, qui se substitue au procureur de la '
                'République ou au juge des libertés et de la détention.',
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Des spécificités demeurent toutefois propres à l’information '
                'judiciaire, notamment en matière d’infiltration, de perquisitions '
                'et de techniques spéciales d’enquête.',
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: '2.3.1 – L’infiltration',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Les opérations d’infiltration peuvent également être mises en œuvre '
                    'dans le cadre d’une information judiciaire ouverte pour des faits '
                    'relevant de la criminalité organisée.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En matière d’infiltration, l’autorisation préalable du juge '
                          'd’instruction aux opérations d’infiltration est soumise pour avis '
                          '(non suspensif) au procureur de la République (Article 706-81 du '
                          'Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              const _SubTitle('2.3.2 – Les perquisitions'),
              const SizedBox(height: 6),
              const _Paragraph(
                'Sous commission rogatoire, les perquisitions obéissent à un régime '
                'proche de celui de la flagrance, mais adapté à l’information '
                'judiciaire et placé sous le contrôle du juge d’instruction.',
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: '2.3.2.1 – La perquisition de nuit',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  const _SubTitle('2.3.2.1.1 – Le principe'),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’Article 706-91 du Code de procédure pénale dispose : « Si les '
                          'nécessités de l’information relative à l’une des infractions '
                          'entrant dans le champ d’application des articles 706-73 et '
                          '706-73-1 l’exigent, le juge d’instruction peut autoriser les '
                          'officiers de police judiciaire agissant sur commission rogatoire '
                          'à procéder à des perquisitions, visites domiciliaires et saisies '
                          'de pièces à conviction en dehors des heures prévues à l’article '
                          '59, lorsque ces opérations ne concernent pas des locaux '
                          'd’habitation. En cas d’urgence, le juge d’instruction peut '
                          'également autoriser les officiers de police judiciaire à '
                          'procéder à ces opérations dans les locaux d’habitation : 1°) '
                          'lorsqu’il s’agit d’un crime ou d’un délit flagrant ; 2°) lorsqu’il '
                          'existe un risque immédiat de disparition des preuves ou des '
                          'indices matériels ; 3°) lorsqu’il existe une ou plusieurs raisons '
                          'plausibles de soupçonner qu’une ou plusieurs personnes se '
                          'trouvant dans les locaux où la perquisition doit avoir lieu sont '
                          'en train de commettre des crimes ou des délits entrant dans le '
                          'champ d’application des articles 706-73 et 706-73-1 ; 4°) lorsque '
                          'leur réalisation, dans le cadre d’une information relative à une '
                          'ou plusieurs infractions mentionnées au 11° de l’article 706-73, '
                          'est nécessaire afin de prévenir un risque d’atteinte à la vie ou '
                          'à l’intégrité physique. »',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph(
                    'Les officiers de police judiciaire peuvent donc procéder à des '
                    'perquisitions de nuit, en dehors des locaux d’habitation, avec '
                    'l’autorisation préalable du juge d’instruction.',
                  ),
                  const SizedBox(height: 4),
                  const _Paragraph(
                    'En cas d’urgence, avec l’autorisation du juge d’instruction, les '
                    'officiers de police judiciaire peuvent également perquisitionner de '
                    'nuit dans les locaux d’habitation.',
                  ),
                  const SizedBox(height: 6),
                  const _Paragraph(
                    'Les perquisitions de nuit prévues par l’Article 706-91 du Code de '
                    'procédure pénale ne peuvent intervenir que dans les cas limitativement '
                    'énumérés suivants :',
                  ),
                  const SizedBox(height: 4),
                  const _BulletPoint(
                    text:
                        'lorsqu’il s’agit d’un crime ou d’un délit flagrant ;',
                  ),
                  const _BulletPoint(
                    text:
                        'lorsqu’il existe un risque immédiat de disparition de preuves ou '
                        'd’indices matériels ;',
                  ),
                  const _BulletPoint(
                    text:
                        'lorsqu’il existe une ou plusieurs raisons plausibles de '
                        'soupçonner qu’une ou plusieurs personnes présentes dans les '
                        'locaux sont en train de commettre des crimes ou délits relevant '
                        'des articles 706-73 et 706-73-1 du Code de procédure pénale ;',
                  ),
                  const SizedBox(height: 8),
                  const _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Exemple : risque immédiat de disparition de preuves ou de '
                            'documents si les auteurs présumés ont été alertés de la '
                            'localisation des enquêteurs et peuvent profiter de la nuit pour '
                            'détruire les éléments matériels de l’infraction.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle(
                    '2.3.2.1.2 – Les conditions de mise en œuvre',
                  ),
                  const _Paragraph(
                    'L’officier de police judiciaire ne peut réaliser une perquisition hors '
                    'des heures légales sans autorisation préalable du juge d’instruction. '
                    'Cette autorisation prend la forme d’une ordonnance écrite et motivée.',
                  ),
                  const SizedBox(height: 4),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'Comme en enquête de flagrance, l’Article 706-92 du Code de '
                          'procédure pénale précise les modalités de mise en œuvre de cette '
                          'ordonnance (références aux mentions obligatoires, contrôle du '
                          'magistrat, etc.).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle('2.3.2.1.3 – Les limites'),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’Article 706-93 du Code de procédure pénale précise que les '
                          'perquisitions prévues par l’Article 706-91 du Code de procédure '
                          'pénale ne peuvent avoir d’autre objet que la recherche et la '
                          'constatation des infractions visées dans la décision du juge '
                          'd’instruction. Le fait que les perquisitions révèlent des '
                          'infractions autres que celles visées dans cette décision ne '
                          'constitue pas une cause de nullité des procédures incidentes.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 20),
              _ConditionCard(
                title:
                    '2.3.2.2 – Les perquisitions en l’absence de la personne gardée à vue ou détenue',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Sous commission rogatoire, l’officier de police judiciaire peut, dans '
                    'certains cas, perquisitionner au domicile d’une personne gardée à vue '
                    'ou détenue en l’absence de cette dernière.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’officier de police judiciaire a la possibilité de perquisitionner '
                          'au domicile d’une personne gardée à vue ou détenue, en dehors de '
                          'sa présence, dans les conditions prévues par l’Article 706-94, '
                          'alinéa 1, du Code de procédure pénale et selon les mêmes modalités '
                          'que dans le cadre de l’enquête de flagrance.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Les régimes spécifiques de perquisitions en matière de trafic de '
                            'stupéfiants (Article 706-28 du Code de procédure pénale) et de '
                            'proxénétisme (Article 706-35 du Code de procédure pénale) '
                            's’appliquent aussi au stade de l’instruction. Ils sont détaillés '
                            'dans la partie relative à l’enquête de flagrance en matière de '
                            'criminalité organisée.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _ConditionCard(
                title: '2.3.3 – Les techniques spéciales d’enquête',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Les trois techniques spéciales d’enquête prévues par la section '
                    'spéciale du Code de procédure pénale sont également utilisables dans '
                    'le cadre de l’information judiciaire :',
                  ),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text: 'recours à un dispositif de type IMSI-catcher ;',
                  ),
                  _IntroBullet(text: 'sonorisation et fixation d’images ;'),
                  _IntroBullet(text: 'captation de données informatiques.'),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Ces techniques d’enquête, prévues aux articles 706-95-11 à '
                          '706-102-5 du Code de procédure pénale, peuvent être mises en '
                          'œuvre si les nécessités de l’information judiciaire relative à '
                          'l’une des infractions entrant dans le champ d’application des '
                          'articles 706-73 et 706-73-1 l’exigent.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Elles sont autorisées par le juge d’instruction, après avis du '
                    'procureur de la République.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En cas d’urgence résultant d’un risque imminent de dépérissement '
                          'des preuves ou d’atteinte grave aux personnes ou aux biens, '
                          'l’autorisation du juge d’instruction peut être délivrée sans avis '
                          'préalable du procureur de la République (Article 706-95-13 du '
                          'Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Cette autorisation est délivrée pour une durée de quatre mois, '
                          'renouvelable dans les mêmes conditions de forme et de durée, sans '
                          'que la durée totale des opérations ne puisse excéder deux ans '
                          '(Article 706-95-16 du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 26),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours vérifier '
                        'la base légale exacte (articles 706-73 et suivants du Code de '
                        'procédure pénale) avant de mettre en œuvre une commission rogatoire '
                        'en matière de criminalité organisée.',
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
