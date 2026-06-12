import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCaractereRacistePage extends StatelessWidget {
  const PaCaractereRacistePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/caractere_raciste';

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
          'Le caractère raciste',
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
                          "à raison de son appartenance ou de sa non-appartenance, vraie ou supposée, à une prétendue race, une ethnie, une nation ou "
                          "une religion déterminée, soit établissent que les faits ont été commis contre la victime pour l’une de ces raisons. »",
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
                      law("L’article 132-76 du C.P."),
                      const TextSpan(
                        text:
                            " définit le caractère raciste d’une infraction. Il prévoit une aggravation systématique des peines.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Il s’agit d’une circonstance aggravante réelle. Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
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
                          "soit portent atteinte à l’honneur ou à la considération de la victime à raison de son appartenance ou de sa non-appartenance, "
                          "vraie ou supposée, à une prétendue race, à une ethnie, une nation ou une religion déterminée.",
                    ),
                    const _Paragraph(
                      "L’aggravation résulte de circonstances objectives, que la personne ait agi ou non pour des motifs discriminatoires.",
                    ),
                    const SizedBox(height: 8),
                    const _BulletPoint(
                      text:
                          "soit établissent que les faits ont été commis contre la victime pour l’une de ces raisons.",
                    ),
                    const SizedBox(height: 8),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "L’aggravation est possible même si ces éléments de fait ne portent pas atteinte à l’honneur ou à la considération de la victime, "
                            "dès lors qu’ils démontrent l’intention discriminatoire de leur auteur (exemple : choix des victimes revendiqué avant les faits) (",
                      ),
                      law("circulaire JUSD1712060C du 20 avril 2017"),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),
                    const _SubTitle(
                      "2.1 - L’appartenance de la victime à une catégorie",
                    ),
                    _Paragraph.rich([
                      law("L’article 132-76"),
                      const TextSpan(text: " vise quatre catégories :"),
                    ]),
                    const SizedBox(height: 10),

                    const _SubTitle("2.1.1 - L’ethnie"),
                    const _Paragraph.rich([
                      TextSpan(
                        text:
                            "Définition Larousse : « Groupement humain qui possède une structure familiale, économique et sociale homogène, et dont l’unité repose "
                            "sur une communauté de langue, de culture et de conscience de groupe. »",
                      ),
                    ]),

                    const SizedBox(height: 10),
                    const _SubTitle("2.1.2 - La nation"),
                    const _Paragraph.rich([
                      TextSpan(
                        text:
                            "Définition Larousse : « Ensemble des êtres humains vivant dans un même territoire, ayant une communauté d’origine, d’histoire, de culture, "
                            "de traditions, parfois de langue, et constituant une communauté politique. »",
                      ),
                    ]),

                    const SizedBox(height: 10),
                    const _SubTitle("2.1.3 - La prétendue race"),
                    const _Paragraph.rich([
                      TextSpan(
                        text:
                            "Définition Larousse : « Catégorie de classement de l’espèce humaine selon des critères morphologiques ou culturels, sans aucune base scientifique "
                            "et dont l’emploi est au fondement des divers racismes et de leurs pratiques. »",
                      ),
                    ]),

                    const SizedBox(height: 10),
                    const _SubTitle("2.1.4 - La religion"),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "Définition Larousse : « Ensemble déterminé de croyances et de dogmes définissant le rapport de l’homme avec le sacré. »\n\n",
                      ),
                      const TextSpan(
                        text: "« Une secte ne constitue pas une religion » (",
                      ),
                      law("C.A. Paris, 25 mars 1996"),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),
                    const _SubTitle(
                      "2.2 - La matérialisation du mobile de l’auteur",
                    ),
                    const _Paragraph(
                      "Ce sont les éléments objectifs tirés de la procédure qui permettront la mise en évidence et la constatation de cette circonstance aggravante.",
                    ),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Le mobile raciste, xénophobe ou antisémite de l’auteur peut se matérialiser par des actes portant atteinte à l’honneur ou à la considération de la victime :",
                    ),
                    const SizedBox(height: 8),
                    const _BulletPoint(
                      text: "Des propos (conversations, cris, injures, etc.).",
                    ),
                    const _BulletPoint(
                      text:
                          "Des écrits (lettres, graffitis, inscriptions, etc.).",
                    ),
                    const _BulletPoint(
                      text: "Des images (dessins, croquis, affiches, etc.).",
                    ),
                    const _BulletPoint(text: "Des objets."),
                    const _BulletPoint(text: "Des actes de toute nature."),
                    const _BulletPoint(
                      text:
                          "Un groupe de personnes dont fait partie la victime.",
                    ),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Il s’agit de permettre de prendre en compte des comportements et actes racistes, xénophobes ou antisémites de l’auteur. "
                      "Ces agissements ne visent pas nécessairement spécifiquement la victime mais conditionnent la commission de l’infraction principale.",
                    ),

                    const SizedBox(height: 12),
                    const _SubTitle("2.3 - Le but poursuivi"),
                    const _Paragraph(
                      "L’auteur peut agir pour différentes raisons :",
                    ),
                    const SizedBox(height: 8),

                    const _SubTitle(
                      "2.3.1 - L’appartenance ou la non-appartenance",
                    ),
                    const _Paragraph(
                      "L’auteur agit soit parce que la victime fait partie d’une des catégories précitées, soit parce qu’elle n’appartient pas à l’une de ces catégories.",
                    ),

                    const SizedBox(height: 10),
                    const _SubTitle("2.3.2 - L’appartenance vraie ou supposée"),
                    const _Paragraph(
                      "Peu importe que l’auteur de l’infraction ait agi à tort, croyant que la victime appartenait ou n’appartenait pas à l’une des catégories.",
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
                      law("L’article 132-76 du C.P."),
                      const TextSpan(
                        text:
                            " généralise la circonstance aggravante de racisme. Afin de respecter le principe constitutionnel de légalité des délits et des peines, "
                            "cette circonstance aggravante générale n’est pas applicable :",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _BulletPoint(
                      text:
                          "aux délits de discriminations prévus par le code pénal ;",
                    ),
                    const _BulletPoint(
                      text:
                          "aux délits de provocations, diffamations et injures discriminatoires prévus par la loi du 29 juillet 1881 ;",
                    ),
                    const _BulletPoint(
                      text:
                          "aux violences volontaires prévues à l’article 222-13 du C.P.",
                    ),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "En effet, le caractère discriminatoire ne peut être à la fois un élément constitutif de l’infraction et une circonstance aggravante.",
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
                              "On ne peut pas cumuler : si le caractère discriminatoire est déjà un élément constitutif de l’infraction, "
                              "il ne peut pas être repris comme circonstance aggravante.",
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
