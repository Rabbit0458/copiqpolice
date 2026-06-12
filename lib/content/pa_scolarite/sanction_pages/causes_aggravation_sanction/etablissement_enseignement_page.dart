import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEtablissementEnseignementPage extends StatelessWidget {
  const PaEtablissementEnseignementPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/etablissement_enseignement';

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

    const lawRed = Color(0xFFD32F2F);

    TextSpan law(String text) => TextSpan(
      text: text,
      style: const TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Dans un établissement\nd’enseignement / d’éducation\nou dans les locaux de l’administration',
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
                // Bandeau citation
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DANS UN ÉTABLISSEMENT D’ENSEIGNEMENT,\nD’ÉDUCATION OU DANS LES LOCAUX DE\nL’ADMINISTRATION",
                        style: GoogleFonts.fustat(
                          fontSize: 14.5,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const _Paragraph.rich([
                        TextSpan(
                          text:
                              "« Dans des établissements d’enseignement ou d’éducation ou dans les locaux de l’administration, "
                              "ainsi que, lors des entrées et sorties des élèves ou du public ou dans un temps très voisin de celles-ci, "
                              "aux abords de ces établissements ou locaux. »",
                        ),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 1. Définition
                _ConditionCard(
                  title: '1 : DÉFINITION',
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: const [
                    _Paragraph(
                      "Cette circonstance aggravante vise à réprimer plus sévèrement certaines infractions "
                      "commises en milieu scolaire notamment, mais aussi dans les locaux de l’administration.",
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Il s’agit d’une circonstance aggravante réelle. Ses effets s’étendent à tous les auteurs, "
                      "coauteurs et complices de l’infraction.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2. Conditions
                _ConditionCard(
                  title: '2 : CONDITIONS',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: const [
                    _SubTitle('2.1 - La nature du lieu'),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            "L’infraction principale doit avoir été commise « dans des établissements d’enseignement ou d’éducation "
                            "ou dans les locaux de l’administration ».\n\n"
                            "Cette formule vise les écoles, les collèges, les lycées, les centres éducatifs, les établissements universitaires, "
                            "et les locaux administratifs dépendant de ces établissements d’enseignement.\n\n"
                            "Un arrêt de la chambre criminelle de la Cour de cassation du 14 octobre 2020 est venu préciser que la notion de "
                            "« locaux de l’administration » ne saurait être étendue à des locaux pouvant dépendre d’autres administrations.\n\n"
                            "Les faits peuvent avoir été commis dans quelque partie que ce soit de l’établissement (bureau, salle, escalier, cour, …). "
                            "Ils peuvent également être commis à l’extérieur, à condition que ce soit aux abords, c’est-à-dire à une distance pas trop importante "
                            "de l’entrée de l’établissement.",
                      ),
                    ]),
                    SizedBox(height: 10),
                    _SubTitle('2.2 - Le moment des faits'),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            "Aucune précision n’est apportée quant au moment de commission des faits dans ces établissements.\n\n"
                            "Concernant les abords, les faits devront avoir été commis au moment « des entrées et des sorties » "
                            "ou « dans un temps très voisin de celles-ci ».",
                      ),
                    ]),
                    SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              "Pour les faits commis aux abords, l’exigence porte sur le moment : entrées/sorties des élèves ou du public, "
                              "ou un temps très proche.",
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3. Champ d'application
                _ConditionCard(
                  title: '3 : CHAMP D’APPLICATION',
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    const _IntroBullet(
                      text:
                          "Cette circonstance aggravante peut s’appliquer notamment aux infractions suivantes :",
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• La provocation d’un mineur à l’usage des stupéfiants (",
                      ),
                      law("article 227-18 al. 2 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• La provocation d’un mineur à la détention ou au commerce de stupéfiants (",
                      ),
                      law("article 227-18-1 al. 2 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• La provocation d’un mineur à la consommation excessive de boissons alcooliques (",
                      ),
                      law("article 227-19 al. 3 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• La provocation d’un mineur à commettre un crime ou un délit (",
                      ),
                      law("article 227-21 al. 2 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Les violences volontaires ("),
                      law("articles 222-12 et 222-13, 11° C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• L’administration de substances nuisibles (",
                      ),
                      law("article 222-15 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• L’outrage à personne chargée d’une mission de service public (",
                      ),
                      law("article 433-5 al. 3 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• La cession ou l’offre illicites de stupéfiants à une personne en vue de sa consommation personnelle (",
                      ),
                      law("article 222-39 al. 2 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le vol ("),
                      law("article 311-4, 11° C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’extorsion ("),
                      law("article 312-2, 5° C.P."),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),

                    const _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              "Cette circonstance aggravante est une circonstance réelle : elle s’étend aux auteurs, coauteurs et complices. "
                              "Elle vise les faits commis dans l’établissement (toutes zones), et peut aussi viser l’extérieur si c’est aux abords "
                              "et au moment des entrées/sorties (ou un temps très voisin).",
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ IMPORTANT : Tes widgets personnalisés (_ConditionCard, _SubTitle, _Paragraph, etc.)
// sont déjà fournis : colle-les ici EXACTEMENT tels quels, sans modification.

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
