import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Texte rouge pour les articles de loi
TextSpan _lawRef(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700),
  );
}

class PPMandatsSanctionsIrregularitesPage extends StatelessWidget {
  const PPMandatsSanctionsIrregularitesPage({super.key});

  static const String routeName =
      '/gpx_scolarite/procedure_penale/mandats_sanctions_irregularites';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fond global de la page
    final Color bg = isDark ? const Color(0xFF10141A) : const Color(0xFFFFFFFF);

    final textMain = GoogleFonts.fustat(
      fontSize: 15.5,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : const Color(0xFF0D47A1),
    );

    final textSoft = GoogleFonts.fustat(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : const Color(0xFF424242),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        // on supprime la barre bleue
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF050505),
        ),
        title: Text(
          'Sanctions des irrégularités',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau d’intro — Chapitre 3
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0D47A1), const Color(0xFF002171)]
                        : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHAPITRE 3 : SANCTIONS DES IRRÉGULARITÉS DES MANDATS',
                      style: textMain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les irrégularités affectant les mandats judiciaires peuvent entraîner des '
                      'sanctions visant les personnes responsables ou les actes eux-mêmes. '
                      'Le respect des formes est essentiel pour garantir la liberté individuelle '
                      'et les droits de la défense.',
                      style: textSoft,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              //////////////////////////////////////////////////////////////
              /// 3.1 — SANCTIONS CONTRE LES PERSONNES
              //////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '3.1 — Sanctions contre les personnes',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  const _Paragraph(
                    'Plusieurs acteurs interviennent dans la chaîne de délivrance et '
                    'd’exécution des mandats. Certains d’entre eux peuvent voir leur '
                    'responsabilité engagée en cas d’irrégularités.',
                  ),

                  const SizedBox(height: 10),
                  const _SubTitle('Rôle du greffier'),
                  const _Paragraph(
                    'Le greffier est considéré comme responsable de la régularité formelle '
                    'des mandats. Il doit s’assurer que chaque mandat :',
                  ),
                  const _BulletPoint(text: 'est régulièrement signé et daté ;'),
                  const _BulletPoint(
                    text:
                        'est revêtu du sceau du magistrat ou de la juridiction compétente ;',
                  ),
                  const _BulletPoint(
                    text:
                        'mentionne l’identité complète de la personne visée ;',
                  ),
                  const _BulletPoint(
                    text:
                        'et, lorsque la loi l’exige, précise la nature des faits imputés, '
                        'leur qualification juridique ainsi que les textes applicables.',
                  ),

                  const SizedBox(height: 12),
                  const _SubTitle(
                    'Responsabilité disciplinaire des magistrats',
                  ),
                  const _Paragraph(
                    'Les éventuelles sanctions disciplinaires à l’encontre du juge '
                    'd’instruction, du juge des libertés et de la détention ou du procureur '
                    'de la République ne peuvent être prononcées que dans le cadre des '
                    'règles du statut de la magistrature.',
                  ),

                  const SizedBox(height: 12),
                  const _SubTitle(
                    'Responsabilité pénale en cas de détention arbitraire',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'En cas de détention arbitraire résultant du non-respect des délais '
                          'légaux, la responsabilité pénale des autorités peut être engagée. ',
                    ),
                    _lawRef('L’article 126 du Code de procédure pénale'),
                    const TextSpan(text: ' renvoie aux dispositions des '),
                    _lawRef('articles 432-4 à 432-6 du Code pénal'),
                    const TextSpan(
                      text:
                          ', qui répriment les atteintes volontaires à la liberté individuelle '
                          'commises par une personne dépositaire de l’autorité publique.',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Sont notamment visés les magistrats ou fonctionnaires (procureur '
                          'de la République, juge d’instruction, chef d’établissement '
                          'pénitentiaire) qui ont ordonné ou sciemment toléré une détention '
                          'arbitraire résultant de l’inobservation du délai de 24 heures fixé '
                          'pour l’interrogatoire de la personne arrêtée en vertu d’un mandat '
                          'd’amener. ',
                    ),
                    _lawRef(
                      'Les dispositions de l’article 126 du Code de procédure pénale',
                    ),
                    const TextSpan(
                      text:
                          ' sont également applicables au mandat d’arrêt, conformément à ',
                    ),
                    _lawRef(
                      'l’article 133 alinéa 1 du Code de procédure pénale',
                    ),
                    const TextSpan(text: '.'),
                  ]),
                ],
              ),

              const SizedBox(height: 20),

              //////////////////////////////////////////////////////////////
              /// 3.2 — SANCTIONS CONCERNANT LES ACTES
              //////////////////////////////////////////////////////////////
              _ConditionCard(
                title: '3.2 — Sanctions concernant les actes',
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  const _Paragraph(
                    'Les irrégularités peuvent porter soit sur la délivrance même du mandat '
                    '(vice de forme ou de fond), soit sur sa notification ou son exécution. '
                    'Les conséquences juridiques ne sont pas les mêmes.',
                  ),

                  const SizedBox(height: 10),
                  const _SubTitle('Irrégularités affectant la délivrance'),
                  const _Paragraph(
                    'Lorsque le mandat ne respecte pas les conditions de forme ou de fond '
                    'prévues par la loi (mentions obligatoires, compétence du magistrat, '
                    'base légale…), ces irrégularités peuvent entraîner la nullité du '
                    'mandat lui-même. La mesure privative ou restrictive de liberté repose '
                    'alors sur un titre irrégulier.',
                  ),

                  const SizedBox(height: 10),
                  const _SubTitle(
                    'Irrégularités de notification ou d’exécution',
                  ),
                  const _Paragraph(
                    'Les vices affectant la notification ou les modalités d’exécution '
                    'du mandat ne remettent pas nécessairement en cause l’existence du '
                    'mandat. Ils peuvent, en revanche, entraîner :',
                  ),
                  const _BulletPoint(
                    text:
                        'la nullité de l’exécution (par exemple, si les droits de la défense '
                        'n’ont pas été respectés) ;',
                  ),
                  const _BulletPoint(
                    text:
                        'ou la caducité du mandat lorsque son inexécution ou son exécution '
                        'irrégulière en a vidé les effets.',
                  ),

                  const SizedBox(height: 10),
                  const _SubTitle('Appréciation par la jurisprudence'),
                  const _Paragraph(
                    'La jurisprudence considère que seules les irrégularités substantielles, '
                    'de nature à porter atteinte aux droits de la défense ou aux garanties '
                    'fondamentales de la personne, justifient la nullité. Les simples '
                    'irrégularités de pure forme, sans grief, ne suffisent pas.',
                  ),

                  const SizedBox(height: 12),
                  _NotaBox(
                    title: 'INDEMNISATION',
                    bodySpans: [
                      const TextSpan(
                        text:
                            'Lorsqu’une détention irrégulière a été subie, une indemnisation '
                            'peut être accordée. Elle est décidée par le premier président de '
                            'la cour d’appel. L’État dispose ensuite d’un recours contre le '
                            'dénonciateur de mauvaise foi ou le faux témoin ayant provoqué la '
                            'détention injustifiée.',
                      ),
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
