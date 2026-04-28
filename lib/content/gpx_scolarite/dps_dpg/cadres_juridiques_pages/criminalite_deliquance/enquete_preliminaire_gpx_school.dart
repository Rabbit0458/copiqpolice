import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnquetePreliminaireGpxSchool extends StatelessWidget {
  const EnquetePreliminaireGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/criminalite_organisee/enquete_preliminaire';

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
          'Enquête préliminaire – criminalité organisée',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w700,
            fontSize: 16.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle(
                '2.2 – L’enquête préliminaire relative à la criminalité organisée',
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'L’enquête préliminaire en matière de criminalité et de délinquance '
                'organisées obéit à des règles de durée et de procédure spécifiques, '
                'plus strictes que le droit commun, en raison de la gravité des faits '
                'et des moyens d’investigation mis en œuvre.',
              ),

              const SizedBox(height: 20),
              _ConditionCard(
                title: '2.2.1 – La durée de l’enquête',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Lorsque l’enquête porte sur des infractions relevant de la criminalité '
                    'et de la délinquance organisées, sa durée ne peut excéder trois ans à '
                    'compter du premier acte d’audition libre, de garde à vue ou de '
                    'perquisition d’une personne, y compris si cet acte est intervenu dans '
                    'le cadre d’une enquête de flagrance.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Ce délai peut être renouvelé une fois pour deux ans, sur autorisation '
                    'écrite et motivée du procureur de la République.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Tout acte d’enquête concernant la personne ayant fait l’objet d’une '
                    'audition libre, d’une garde à vue ou d’une perquisition, intervenant '
                    'après l’expiration de ces délais, est nul.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Le choix de la qualification pénale est donc déterminant pour le '
                          'délai butoir de l’enquête. Il convient d’y apporter une attention '
                          'particulière pour chaque mis en cause dès le début de l’enquête. '
                          'Ce choix appartient au procureur de la République, qui doit '
                          'vérifier que les infractions entrent dans le champ d’application '
                          'des articles 706-73 et 706-73-1 du Code de procédure pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: '2.2.2 – Dispositions communes',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Dans le domaine de la criminalité organisée, un certain nombre '
                    'd’instruments procéduraux spécifiques sont communs à l’enquête de '
                    'flagrance et à l’enquête préliminaire.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Il en est ainsi, notamment, des dispositions relatives :',
                  ),
                  SizedBox(height: 4),
                  _IntroBullet(text: 'à la surveillance ;'),
                  _IntroBullet(text: 'aux opérations d’infiltration ;'),
                  _IntroBullet(text: 'à la garde à vue ;'),
                  _IntroBullet(
                    text:
                        'aux perquisitions en matière de trafic de stupéfiants et de '
                        'proxénétisme ;',
                  ),
                  _IntroBullet(
                    text:
                        'aux modalités de mise en œuvre des interceptions de correspondances.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Les perquisitions en matière de trafic de stupéfiants reposent sur '
                          'l’article 706-28 du Code de procédure pénale et celles en matière '
                          'de proxénétisme sur l’article 706-35 du Code de procédure pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Conformément à l’article 706-95-11 du Code de procédure pénale, un '
                          'cadre commun a été créé pour trois techniques d’enquête : '
                          'l’IMSI-catcher, la sonorisation et la fixation d’images, ainsi que '
                          'la captation de données informatiques. Ces dispositions sont '
                          'applicables lors de l’enquête de flagrance, de l’enquête '
                          'préliminaire ou de l’information judiciaire pour les infractions '
                          'mentionnées aux articles 706-73 et 706-73-1 du Code de procédure '
                          'pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              const _SubTitle('2.2.3 – Les perquisitions'),
              const SizedBox(height: 6),
              const _Paragraph(
                'En matière d’enquête préliminaire, les perquisitions obéissent à des règles '
                'dérogatoires lorsque les faits relèvent de la criminalité organisée.',
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title:
                    '2.2.3.1 – Les perquisitions de nuit en dehors des locaux d’habitation',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-90, alinéa 1, du Code de procédure pénale dispose : '
                          '« Si les nécessités de l’enquête préliminaire relative à l’une des '
                          'infractions entrant dans le champ d’application des articles '
                          '706-73 et 706-73-1 l’exigent, le juge des libertés et de la '
                          'détention du tribunal judiciaire peut, à la requête du procureur '
                          'de la République, décider que les perquisitions, visites '
                          'domiciliaires et saisies de pièces à conviction pourront être '
                          'effectuées en dehors des heures prévues à l’article 59, lorsque '
                          'ces opérations ne concernent pas des locaux d’habitation. »',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le régime dérogatoire est uniquement applicable aux infractions '
                    'entrant dans le champ d’application des articles 706-73 et 706-73-1 '
                    'du Code de procédure pénale, si les nécessités de l’enquête '
                    'l’exigent.',
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-90 du Code de procédure pénale permet donc de procéder à '
                          'des perquisitions de nuit lorsqu’elles ne concernent pas des locaux '
                          'd’habitation. Des dispositions spécifiques sont prévues en matière '
                          'de terrorisme.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’officier de police judiciaire ne peut procéder à une perquisition '
                          'de nuit sans qu’une ordonnance préalable du juge des libertés et de '
                          'la détention ne l’y autorise expressément. Cette ordonnance est mise '
                          'en œuvre selon les modalités de l’article 706-92 du Code de '
                          'procédure pénale, décrites dans la procédure de flagrant délit.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-93 du Code de procédure pénale précise que les '
                          'perquisitions menées en dehors des heures légales, conformément à '
                          'l’article 706-90 du Code de procédure pénale, ne peuvent avoir '
                          'd’autre objet que la recherche et la constatation des infractions '
                          'visées dans la décision du juge des libertés et de la détention. '
                          'Le fait que les perquisitions révèlent des infractions autres que '
                          'celles visées dans cette décision ne constitue pas une cause de '
                          'nullité des procédures incidentes.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title:
                    '2.2.3.2 – Les perquisitions sans l’assentiment de la personne',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 76, alinéa 4, du Code de procédure pénale dispose que les '
                          'perquisitions et saisies de pièces à conviction peuvent être '
                          'effectuées sans l’assentiment de la personne chez qui elles ont '
                          'lieu si les nécessités de l’enquête, relative à un crime ou à un '
                          'délit puni d’une peine d’emprisonnement d’une durée égale ou '
                          'supérieure à trois ans, l’exigent.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'En matière de criminalité organisée, l’application combinée des '
                          'articles 76, alinéa 4, et 706-90 du Code de procédure pénale permet '
                          'à l’officier de police judiciaire de procéder à des perquisitions '
                          'sans l’assentiment de la personne concernée, y compris de nuit, '
                          'pour l’une des infractions entrant dans le champ des articles '
                          '706-73 et 706-73-1, dès lors qu’il ne s’agit pas de locaux '
                          'd’habitation. Ces opérations sont autorisées par décision écrite et '
                          'motivée du juge des libertés et de la détention, à la requête du '
                          'procureur de la République.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title:
                    '2.2.3.3 – Les perquisitions en l’absence de la personne gardée à vue ou détenue',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Les dispositions de l’article 706-94, alinéa 2, du Code de procédure '
                          'pénale permettent à l’officier de police judiciaire, dans le cadre '
                          'de l’une des infractions visées aux articles 706-73 et 706-73-1 du '
                          'Code de procédure pénale, de perquisitionner au domicile d’une '
                          'personne gardée à vue ou détenue, en dehors de sa présence, lorsque '
                          'la perquisition est réalisée sans l’assentiment de la personne dans '
                          'les conditions prévues aux articles 76 et 706-90 du Code de '
                          'procédure pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Cette perquisition doit respecter les éléments suivants :',
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        'le transport sur place de l’intéressé doit être évité en raison de '
                        'risques graves (troubles à l’ordre public, risque d’évasion, '
                        'disparition possible des preuves pendant le temps nécessaire au '
                        'transport) ;',
                  ),
                  _BulletPoint(
                    text:
                        'l’officier de police judiciaire doit bénéficier de l’accord préalable '
                        'du juge des libertés et de la détention, l’autorisation écrite du '
                        'magistrat étant jointe à la procédure ;',
                  ),
                  _BulletPoint(
                    text:
                        'le respect des droits de la défense doit être assuré par la présence, '
                        'lors des opérations de perquisition, soit de deux témoins requis par '
                        'l’officier de police judiciaire dans les conditions de l’article 57 '
                        'du Code de procédure pénale, soit d’un représentant désigné par '
                        'celui dont le domicile est en cause.',
                  ),
                  SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Les régimes spécifiques de perquisitions en matière de trafic de '
                            'stupéfiants et de proxénétisme (article 706-35 du Code de '
                            'procédure pénale) s’appliquent de la même façon qu’en flagrant '
                            'délit.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 26),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours vérifier '
                        'la qualification exacte des faits et la base légale (articles 706-73 '
                        'et suivants du Code de procédure pénale) avant de déterminer le '
                        'régime applicable à l’enquête préliminaire.',
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
