import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaMortPage extends StatelessWidget {
  const PaMortPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/mort';

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
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
            "f00001",
            'La mort',
          ),
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
                // Bandeau (phrase)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: .06,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: .08,
                      ),
                    ),
                  ),
                  child: _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                        "f00002",
                        "« Ayant entraîné la mort sans intention de la donner ».",
                      ),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                    "f00003",
                    '1 : DÉFINITION',
                  ),
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                            "f00004",
                            "Cette circonstance aggravante peut être retenue lorsque l’infraction commise a entraîné la mort. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                            "f00005",
                            "L’auteur n’a jamais voulu donner volontairement la mort à autrui.",
                          ),
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                            "f00006",
                            "Il s’agit d’une circonstance aggravante réelle. Ses effets s’étendent à tous les auteurs, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                            "f00007",
                            "coauteurs et complices de l’infraction.",
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                    "f00008",
                    '2 : CONDITIONS',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                        "f00009",
                        "2.1 - La nécessité d’une relation de cause à effet",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00010",
                          "Il est nécessaire qu’il existe entre l’acte délictueux et le décès de la victime une relation de cause à effet (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00011",
                          "Cass. crim., 17 janvier 1991",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                        "f00012",
                        "2.2 - L’indifférence de l’état préexistant de la victime",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                            "f00013",
                            "La circonstance peut être retenue quel que soit l’état de santé de la personne avant qu’elle ne soit victime de l’infraction, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                            "f00014",
                            "même s’il a concouru au décès de la victime alors que tel n’aurait pas été le cas pour une personne en bonne santé.",
                          ),
                    ),
                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                            "f00015",
                            "Le lien causal doit être établi, mais l’état antérieur de la victime n’exclut pas la circonstance aggravante, même s’il a contribué au décès.",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3 : Champ d'application
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                    "f00016",
                    '3 : CHAMP D’APPLICATION',
                  ),
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                        "f00017",
                        "Cette circonstance aggravante peut notamment s’appliquer aux infractions suivantes :",
                      ),
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00018",
                          "• Les tortures ou actes de barbarie (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00019",
                          "article 222-6 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00020",
                          "• Les violences (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00021",
                          "articles 222-7, 222-14 al. 2 et 222-14-1 al. 2 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00022",
                          "• L’administration de substances nuisibles (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00023",
                          "article 222-15 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00024",
                          "• Le viol (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00025",
                          "article 222-25 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00026",
                          "• Le délaissement d’une personne hors d’état de se protéger (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00027",
                          "article 223-4 al. 2 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00028",
                          "• L’enlèvement et la séquestration (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00029",
                          "article 224-2 al. 2 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00030",
                          "• Le délaissement d’un mineur de quinze ans (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00031",
                          "article 227-2 al. 2 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00032",
                          "• La mise en péril des mineurs (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00033",
                          "article 227-16 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00034",
                          "• Le vol commis avec violences (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00035",
                          "article 311-10 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00036",
                          "• L’extorsion commise avec violences (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00037",
                          "article 312-7 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00038",
                          "• Les destructions, dégradations et détériorations (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/mort_page.dart",
                          "f00039",
                          "articles 322-5 al. 6 et 322-10 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
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
          children: [...bodySpans],
        ),
      ),
    );
  }
}
