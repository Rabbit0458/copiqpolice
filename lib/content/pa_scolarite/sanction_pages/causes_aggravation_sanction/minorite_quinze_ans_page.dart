import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMinoriteQuinzeAnsPage extends StatelessWidget {
  const PaMinoriteQuinzeAnsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/minorite_quinze_ans';

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
          'La minorité de quinze ans',
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
                // Bandeau (définition courte)
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
                    TextSpan(text: "« Sur un mineur de 15 ans »."),
                  ]),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: '1 : DÉFINITION',
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: const [
                    _Paragraph(
                      "C’est l’âge de 15 ans accompli qui a été choisi pour déterminer la limite en dessous de laquelle "
                      "la circonstance aggravante est caractérisée (quel que soit l’âge en dessous de 15 ans).",
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Il s’agit d’une circonstance aggravante réelle. Ses effets s’étendent à tous les auteurs, "
                      "coauteurs et complices de l’infraction.",
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
                    const _SubTitle("2.1 - La détermination de l’âge"),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "C’est l’âge qu’avait la victime au moment des faits qui doit être pris en considération (Cass. crim., 21 mars 1957).\n\n"
                            "Il se calcule d’heure à heure (Cass. crim., ",
                      ),
                      law("n° 85-93.591 du 3 septembre 1985"),
                      const TextSpan(
                        text:
                            ").\n\n"
                            "À défaut d’acte ayant valeur probante, la preuve de l’âge du mineur peut se faire par tout moyen (Cass. crim., ",
                      ),
                      law("n° 91-82.771 du 17 juillet 1991"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 10),
                    const _SubTitle("2.2 - L’indifférence de l’âge apparent"),
                    const _Paragraph(
                      "Contrairement à d’autres circonstances aggravantes, le législateur n’exige pas que la minorité de quinze ans "
                      "soit apparente ou connue de l’auteur de l’infraction. Le mineur de quinze ans bénéficie donc d’une protection particulière.",
                    ),
                    const SizedBox(height: 12),
                    const _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              "La minorité de 15 ans n’a pas à être apparente ou connue : la protection est attachée à l’âge réel au moment des faits.",
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
                    const _IntroBullet(
                      text:
                          "Cette circonstance aggravante peut notamment aggraver les infractions suivantes :",
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      const TextSpan(text: "• Le meurtre ("),
                      law("article 221-4 1° C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’empoisonnement ("),
                      law("article 221-5 al. 3 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• Les tortures ou actes de barbarie (",
                      ),
                      law("article 222-3 1° C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Les violences volontaires ("),
                      law("articles 222-8, 222-10, 222-12 et 222-13, 1° C.P."),
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
                      const TextSpan(text: "• Le viol ("),
                      law("article 222-24 2° C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Les agressions sexuelles ("),
                      law("article 222-29-1 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "• L’administration d’une substance afin de commettre un viol ou une agression sexuelle (",
                      ),
                      law("article 222-30-1 al. 2 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• L’exhibition sexuelle ("),
                      law("article 222-32 al. 3 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le harcèlement sexuel ("),
                      law("article 222-33 III, 2° C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• La non-assistance à personne en péril (",
                      ),
                      law("article 223-6 al. 3 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• La provocation au suicide ("),
                      law("article 223-13 al. 2 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• L’enlèvement et la séquestration (",
                      ),
                      law("article 224-5 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "• Le proxénétisme ("),
                      law("article 225-7-1 C.P."),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "• Le recours à la prostitution de mineur (",
                      ),
                      law("article 225-12-2 al. 6 C.P."),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      const TextSpan(text: "• La mise en péril de mineurs ("),
                      law(
                        "articles 227-18 al. 2, 227-18-1 al. 2, 227-19 al. 3, 227-21 al. 2, 227-22 al. 3, 227-22-2 al. 2, 227-23-1 C.P.",
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
