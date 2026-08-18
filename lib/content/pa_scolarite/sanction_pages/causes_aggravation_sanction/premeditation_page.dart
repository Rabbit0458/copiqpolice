import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPremeditationPage extends StatelessWidget {
  const PaPremeditationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/premeditation';

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
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
            "f00001",
            'La préméditation',
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
                // Bandeau (citation)
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
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                        "f00002",
                        "« La préméditation est le dessein formé avant l’action de commettre un crime ou un délit déterminé. »",
                      ),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                    "f00003",
                    '1 : DÉFINITION',
                  ),
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00004",
                          "L’article 132-72 du C.P.",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00005",
                              " définit la préméditation. Elle se traduit par une résolution d’agir marquant la volonté mûre et réfléchie ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00006",
                              "de l’auteur d’atteindre le but qu’il s’est fixé.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                        "f00007",
                        "La jurisprudence parfois contradictoire la qualifie tantôt de réelle, tantôt de personnelle.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                    "f00008",
                    '2 : CONDITIONS',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                        "f00009",
                        "2.1 - Une résolution d’agir",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00010",
                              "La résolution d’agir s’inscrit dans un intervalle de temps plus ou moins long, qui n’est pas déterminé. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00011",
                              "L’antériorité à l’acte est nécessaire pour matérialiser la préméditation (",
                            ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00012",
                          "Cass. crim., 9 janvier 1990",
                        ),
                      ),
                      const TextSpan(text: ").\n\n"),
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00013",
                          "Cet intervalle de temps se situe entre la résolution de commettre l’acte et son exécution.",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                        "f00014",
                        "2.2 - Une volonté mûre et réfléchie",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                            "f00015",
                            "L’acte prémédité est médité et préparé. Il n’est donc pas spontané et ne peut pas faire suite à une pulsion. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                            "f00016",
                            "Ces éléments traduisent une volonté persistante et résolue d’appliquer le plan tracé à l’avance.",
                          ),
                    ),
                    const SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                        "f00017",
                        "2.3 - Le but poursuivi",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00018",
                              "Cette circonstance vise indifféremment une infraction commise ou tentée.\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00019",
                              "La préméditation se matérialise par des faits ou des circonstances qui se situent dans l’intervalle de temps ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00020",
                              "qui précède l’acte : « Elle doit être recherchée dans les faits qui ont accompagné l’acte de l’auteur principal » (",
                            ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00021",
                          "Cass. crim., 4 septembre 1976",
                        ),
                      ),
                      TextSpan(
                        text:
                            ").\n\n" +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00022",
                              "À titre d’exemple, il peut s’agir d’actes préparatoires, de menaces, de confidences, de la nature complexe de l’acte ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                              "f00023",
                              "traduisant sa nécessaire préparation, etc.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                            "f00024",
                            "L’élément clé est l’antériorité : on doit retrouver des indices (faits/circonstances) montrant une préparation entre la décision et l’exécution.",
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
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                    "f00025",
                    '3 : CHAMP D’APPLICATION',
                  ),
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                        "f00026",
                        "Le code pénal prévoit que la circonstance de commission avec préméditation est susceptible d’aggraver les infractions suivantes :",
                      ),
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00027",
                          "• Le meurtre (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00028",
                          "article 221-3 al. 1 C.P.",
                        ),
                      ),
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00029",
                          ", le meurtre est alors qualifié d’assassinat).",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00030",
                          "• L’empoisonnement (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00031",
                          "article 221-5 al. 3 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00032",
                          "• Les violences (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/premeditation_page.dart",
                          "f00033",
                          "articles 222-8, 222-10, 222-12, 222-13, 9° et 222-14-5 C.P.",
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
