import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCaractereHomophobePage extends StatelessWidget {
  const PaCaractereHomophobePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/caractere_homophobe';

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
          'Le caractère homophobe',
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
                // Bandeau (définition légale)
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
                    TextSpan(
                      text:
                          "« Lorsqu’un crime ou un délit est précédé, accompagné ou suivi de propos, écrits, images, objets ou actes de toute nature "
                          "qui soit portent atteinte à l’honneur ou à la considération de la victime ou d’un groupe de personnes dont fait partie la victime "
                          "à raison de son sexe, son orientation sexuelle ou identité de genre vraie ou supposée, soit établissent que les faits ont été commis "
                          "contre la victime pour l’une de ces raisons. »",
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: '1 : DÉFINITION',
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      law("L’article 132-77 du C.P."),
                      const TextSpan(
                        text:
                            " définit le caractère homophobe ou sexiste d’une infraction. Il prévoit une aggravation des sanctions prononcées "
                            "en répression des infractions commises pour des motifs d’homophobie ou de sexisme.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Cette circonstance aggravante est réelle. Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: '2 : CONDITIONS',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    const _Paragraph(
                      "Un crime ou un délit est aggravé dès lors qu’il est précédé, accompagné ou suivi de propos, écrits, images, objets ou actes de toute nature qui :",
                    ),
                    const SizedBox(height: 10),
                    const _BulletPoint(
                      text:
                          "soit portent atteinte à l’honneur ou à la considération de la victime ou d’un groupe de personnes dont fait partie la victime "
                          "à raison de son sexe, son orientation sexuelle ou identité de genre vraie ou supposée,",
                    ),
                    const _BulletPoint(
                      text:
                          "soit établissent que les faits ont été commis contre la victime pour l’une de ces raisons.",
                    ),
                    const SizedBox(height: 10),

                    const _SubTitle(
                      "2.1 - Le sexe, l’orientation sexuelle ou l’identité de genre",
                    ),
                    const _Paragraph(
                      "Cette circonstance aggravante vise non seulement les personnes homosexuelles, mais également les personnes transsexuelles "
                      "ou transgenres ou travesties.",
                    ),

                    const SizedBox(height: 10),
                    const _SubTitle(
                      "2.2 - La matérialisation du mobile de l’auteur",
                    ),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "Il s’agit exactement des mêmes éléments que ceux cités par ",
                      ),
                      law("l’article 132-76 du C.P."),
                      const TextSpan(
                        text:
                            " : propos, écrits, images, objets ou actes de toute nature visant la victime ou un groupe de personnes dont fait partie la victime. "
                            "Ces éléments permettront de caractériser le mobile homophobe de l’auteur ou son rejet des personnes transgenres ou transsexuelles.",
                      ),
                    ]),

                    const SizedBox(height: 10),
                    const _SubTitle("2.3 - Le but poursuivi"),
                    const _Paragraph(
                      "L’auteur agit en raison du sexe ou de l’orientation sexuelle ou de l’identité de genre vraie ou supposée de la victime. "
                      "La circonstance est constituée dès lors que l’auteur de l’infraction croyait que la victime était homosexuelle, transsexuelle "
                      "ou transgenre bien qu’elle ne l’ait pas été.",
                    ),

                    const SizedBox(height: 12),
                    const _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              "La circonstance peut être retenue même si l’orientation/identité de genre attribuée à la victime est seulement supposée par l’auteur.",
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3 : Champ d'application
                _ConditionCard(
                  title: '3 : CHAMP D’APPLICATION',
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      law("L’article 132-77 du C.P."),
                      const TextSpan(
                        text:
                            " généralise la circonstance aggravante d’homophobie, de sexisme et de transphobie. "
                            "Afin de respecter le principe constitutionnel de légalité des délits et des peines, cette circonstance aggravante générale n’est pas applicable :",
                      ),
                    ]),
                    const SizedBox(height: 10),

                    const _BulletPoint(
                      text:
                          "aux violences volontaires prévues à l’article 222-13 du C.P.",
                    ),
                    const _BulletPoint(
                      text:
                          "au délit de harcèlement sexuel (art. 222-33 du C.P.).",
                    ),
                    const _BulletPoint(
                      text:
                          "aux délits de discriminations prévus par le code pénal (art. 225-1 du C.P.).",
                    ),
                    const _BulletPoint(
                      text:
                          "aux délits visant à modifier l’orientation sexuelle ou l’identité de genre (art. 225-4-13 du C.P.).",
                    ),
                    const _BulletPoint(
                      text:
                          "aux délits de provocations, diffamations et injures discriminatoires prévus par la loi du 29 juillet 1881.",
                    ),
                    const _BulletPoint(
                      text:
                          "aux infractions déjà aggravées parce qu’elles sont commises par le conjoint, le concubin de la victime ou le partenaire lié à celle-ci par un PACS "
                          "(meurtre, tortures et actes de barbarie, certaines violences, menaces, viol, agressions sexuelles, harcèlement moral, etc.).",
                    ),
                    const _BulletPoint(
                      text:
                          "aux infractions déjà aggravées parce qu’elles sont commises contre une personne afin de la contraindre à contracter un mariage ou à conclure une union "
                          "ou en raison de son refus (meurtre, tortures et actes de barbarie, certaines violences, etc.).",
                    ),

                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Le caractère discriminatoire ne peut être à la fois un élément constitutif de l’infraction et une circonstance aggravante.",
                    ),

                    const SizedBox(height: 12),
                    const _SubTitle("Relèvement du maximum de la peine"),
                    const _Paragraph(
                      "Le maximum de la peine privative de liberté encourue est relevé ainsi qu’il suit :",
                    ),
                    const SizedBox(height: 8),

                    const _BulletPoint(
                      text:
                          "1° Porté à la réclusion criminelle à perpétuité lorsque l’infraction est punie de trente ans de réclusion criminelle.",
                    ),
                    const _BulletPoint(
                      text:
                          "2° Porté à trente ans de réclusion criminelle lorsque l’infraction est punie de vingt ans de réclusion criminelle.",
                    ),
                    const _BulletPoint(
                      text:
                          "3° Porté à vingt ans de réclusion criminelle lorsque l’infraction est punie de quinze ans de réclusion criminelle.",
                    ),
                    const _BulletPoint(
                      text:
                          "4° Porté à quinze ans de réclusion criminelle lorsque l’infraction est punie de dix ans d’emprisonnement.",
                    ),
                    const _BulletPoint(
                      text:
                          "5° Porté à dix ans d’emprisonnement lorsque l’infraction est punie de sept ans d’emprisonnement.",
                    ),
                    const _BulletPoint(
                      text:
                          "6° Porté à sept ans d’emprisonnement lorsque l’infraction est punie de cinq ans d’emprisonnement.",
                    ),
                    const _BulletPoint(
                      text:
                          "7° Porté au double lorsque l’infraction est punie de trois ans d’emprisonnement au plus.",
                    ),

                    const SizedBox(height: 12),
                    const _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              "Le mobile discriminatoire doit être prouvé (propos/écrits/images/actes, etc.) et ne peut pas compter deux fois "
                              "(élément constitutif + circonstance aggravante).",
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
