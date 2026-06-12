import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCirconstancesAggravantesPage extends StatelessWidget {
  const PaCirconstancesAggravantesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/circonstances_aggravantes';

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
          'Les circonstances aggravantes',
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
                // Intro (sans répéter le titre)
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Paragraph(
                        "La peine encourue par l'auteur d'une infraction peut être aggravée lorsque celle-ci a été commise dans une circonstance considérée par la loi comme aggravant la criminalité de l'acte.",
                      ),
                      SizedBox(height: 10),
                      _Paragraph(
                        "\"Si un même fait ne peut être retenu comme constitutif à la fois d'un crime et d'une circonstance aggravante accompagnant une autre infraction, rien ne s'oppose à ce qu'une même circonstance soit retenue comme aggravant des crimes distincts\" (Cass. crim., 7 février 2007).",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: 'NOTIONS GÉNÉRALES',
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    const _Paragraph(
                      "Une circonstance n'est aggravante que lorsque la loi le décide expressément. Elle les énumère de manière limitative et détermine pour chaque cas l'aggravation de la peine encourue.",
                    ),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Une circonstance aggravante peut modifier la nature de la peine encourue par l'auteur de l'infraction et par conséquent la nature de l'infraction.",
                    ),
                    const SizedBox(height: 10),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "Les circonstances aggravantes sont dites spéciales car elles ne s'appliquent qu'aux auteurs des infractions pour lesquelles la loi les prévoit. On peut distinguer celles qui tiennent aux conséquences dommageables de l'infraction, à la personne de la victime, à la personne de l'auteur, aux moyens employés pour commettre l'infraction, au lieu de l'infraction. Seules seront ici traitées les circonstances aggravantes citées par le code pénal aux ",
                      ),
                      law("articles 132-71 à 132-80"),
                      const TextSpan(
                        text:
                            " ainsi que celles communes à plusieurs infractions et d'une application fréquente.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "La jurisprudence les classe en deux catégories.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: '1 : CIRCONSTANCES AGGRAVANTES PERSONNELLES',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: const [
                    _Paragraph(
                      "Il s'agit des circonstances aggravantes qui augmentent uniquement la culpabilité de celui qui agit car elles sont liées à sa personnalité. Tel est le cas de la récidive qui est « purement » personnelle et qui ne s'étend donc pas au coauteur ou au complice.",
                    ),
                    SizedBox(height: 12),
                    _Paragraph(
                      "Cependant, les circonstances aggravantes personnelles liées à la qualité ou à la fonction ne semblent pas être exclusives à l'auteur. Elles ne sont donc pas dites « purement personnelles ».",
                    ),
                    SizedBox(height: 10),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            "En effet, un arrêt de la chambre criminelle de la cour de cassation indique que : « Sont applicables au complice les circonstances aggravantes liées à la qualité de l'auteur principal » (",
                      ),
                      TextSpan(
                        text: "Cass. crim., 7 septembre 2005",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: ")."),
                    ]),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Elle consacre ainsi le principe de l'emprunt de criminalité (étudié ultérieurement dans les principes généraux de la responsabilité pénale).",
                    ),
                    SizedBox(height: 10),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            "Le complice encourt la responsabilité de toutes les circonstances qui qualifient l'acte poursuivi sans qu'il soit nécessaire que celles-ci aient été connues de lui (",
                      ),
                      TextSpan(
                        text: "Cass. crim., 21 mai 1996",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: ")."),
                    ]),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: '2 : CIRCONSTANCES AGGRAVANTES RÉELLES',
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: const [
                    _Paragraph(
                      "Il s'agit des circonstances aggravantes qui s'attachent à la matérialité du fait poursuivi dont elles ne peuvent être séparées.",
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Elles ne peuvent donc pas exister à l'égard de l'un des participants sans exister en même temps à l'égard de tous les autres, qu'ils soient auteurs, coauteurs ou complices.",
                    ),
                    SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              "La doctrine, quant à elle, ajoute une troisième catégorie : les circonstances aggravantes mixtes (tenant à la fois à la qualité de l'auteur et à la criminalité de l'acte) qui semblent donc être assimilées par la jurisprudence aux circonstances aggravantes réelles.",
                        ),
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
