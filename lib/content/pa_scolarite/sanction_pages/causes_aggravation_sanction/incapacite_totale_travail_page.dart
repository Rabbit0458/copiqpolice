import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaIncapaciteTotaleTravailPage extends StatelessWidget {
  const PaIncapaciteTotaleTravailPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/incapacite_totale_travail';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgTop = isDark
        ? const Color(0xFF0B1220)
        : const Color(0xFFEAF2FF);
    final Color bgBottom = isDark ? const Color(0xFF070B12) : Colors.white;

    final Color cardBlue = isDark
        ? const Color(0xFF0F1B2E)
        : const Color(0xFFF3F7FF);
    final Color cardAmber = isDark
        ? const Color(0xFF1B1610)
        : const Color(0xFFFFF7E6);
    final Color cardTeal = isDark
        ? const Color(0xFF0F1E1B)
        : const Color(0xFFF0FFFB);

    const accentBlue = Color(0xFF1565C0);
    const accentAmber = Color(0xFFF9A825);
    const accentTeal = Color(0xFF00897B);

    final Color titleColor = isDark ? Colors.white : const Color(0xFF0B1B3A);

    const Color lawRed = Color(0xFFD32F2F);

    TextSpan law(String txt) => TextSpan(
      text: txt,
      style: const TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Incapacité totale de travail",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Intro (sans répéter le titre dans la page)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 
                      .06,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 
                        .08,
                      ),
                    ),
                  ),
                  child: const _Paragraph.rich([
                    TextSpan(text: "« "),
                    TextSpan(
                      text: "Ayant entraîné une incapacité totale de travail.",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: " »"),
                  ]),
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: '1 : DÉFINITION',
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: const [
                    _Paragraph(
                      "L'incapacité totale de travail mesure la gravité des atteintes corporelles ou psychiques subies par la victime de l'infraction. L'I.T.T. ne doit pas être confondue avec l'arrêt de travail propre au droit social.",
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Une victime n'exerçant aucune activité professionnelle (enfant, retraité,...) peut donc se voir prescrire une I.T.T.",
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Il s'agit d'une circonstance aggravante réelle. Ses effets s'étendent à tous les auteurs, coauteurs et complices de l'infraction.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: '2 : CONDITIONS',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    const _SubTitle('2.1 - Le caractère total'),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "L'I.T.T. doit, pour constituer la circonstance, être totale. Elle n'implique pas nécessairement l'impossibilité pour la victime de se livrer à un effort physique afin d'accomplir elle-même certaines tâches ménagères ",
                      ),
                      const TextSpan(text: "("),
                      law("Cass. crim., n° 81-92.856 du 22 novembre 1982"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "L'I.T.T. ne s'applique pas seulement à l'activité professionnelle mais s'étend à toute l'activité courante et aux efforts physiques de toutes sortes nécessaires à la vie de chaque jour ",
                      ),
                      const TextSpan(text: "("),
                      law("Cass. crim., 7 mars 1967"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 12),
                    const _SubTitle('2.2 - La durée'),
                    const _Paragraph(
                      "La durée est prise en compte par paliers selon l'infraction que l'I.T.T. aggrave :",
                    ),
                    const SizedBox(height: 8),
                    const _IntroBullet(text: "inférieure ou égale à 8 jours,"),
                    const _IntroBullet(text: "supérieure à 8 jours,"),
                    const _IntroBullet(
                      text: "inférieure ou égale à trois mois,",
                    ),
                    const _IntroBullet(text: "supérieure à trois mois."),
                    const SizedBox(height: 12),
                    const _SubTitle('2.3 - La preuve'),
                    const _Paragraph(
                      "Le juge a un pouvoir d'appréciation en vue de rechercher dans quelle mesure la victime s'est trouvée hors d'état d'effectuer un travail corporel.",
                    ),
                    const SizedBox(height: 8),
                    const _Paragraph(
                      "La preuve doit être rapportée par la partie poursuivante. Il peut s'agir de certificats médicaux, mais le juge peut également se baser sur des rapports d'experts.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: "3 : CHAMP D'APPLICATION",
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    const _Paragraph(
                      "Cette circonstance peut aggraver notamment :",
                    ),
                    const SizedBox(height: 10),

                    // On met les références en rouge via une NotaBox (propre + lisible)
                    _NotaBox(
                      title: 'Références',
                      bodySpans: [
                        const TextSpan(text: "• Les violences : "),
                        law(
                          "articles 222-11 à 222-14-1, 222-14-5 et R.625-1 du C.P.",
                        ),
                        const TextSpan(
                          text:
                              "\n• Les atteintes involontaires à l’intégrité de la personne : ",
                        ),
                        law("articles 222-19 à 222-21 et R.625-2 du C.P."),
                        const TextSpan(
                          text:
                              "\n• L’administration de substances nuisibles : ",
                        ),
                        law("article 222-15 du C.P."),
                        const TextSpan(text: "\n• Les agressions sexuelles : "),
                        law("article 222-28, 1° du C.P."),
                        const TextSpan(text: "\n• Le vol : "),
                        law("articles 311-5, 1° et 311-6 du C.P."),
                        const TextSpan(text: "\n• L’extorsion : "),
                        law("articles 312-2 et 312-3 du C.P."),
                        const TextSpan(
                          text:
                              "\n• Destructions, dégradations et détériorations : ",
                        ),
                        law("articles 322-5 al. 5, 322-7 et 322-8, 2° du C.P."),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ IMPORTANT : tes widgets personnalisés (_ConditionCard, _SubTitle, _Paragraph, _IntroBullet,
// _BulletPoint, _NotaBox) sont déjà fournis : colle-les sous ce commentaire EXACTEMENT tels quels.

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
