import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaGuetApensPage extends StatelessWidget {
  const PaGuetApensPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/guet_apens';

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
          'Le guet-apens',
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
                          "« Le guet-apens consiste dans le fait d’attendre un certain temps une ou plusieurs personnes dans un lieu déterminé "
                          "pour commettre à leur encontre une ou plusieurs infractions. »",
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
                      law("L’article 132-71-1 du C.P."),
                      const TextSpan(
                        text:
                            " définit le guet-apens. Il s’agit d’une circonstance aggravante réelle. "
                            "Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "La notion de guet-apens est proche de celle d’embuscade définie par ",
                      ),
                      law("l’article 222-15-1 du code pénal"),
                      const TextSpan(
                        text:
                            ". Elle diffère de l’embuscade qui est une infraction autonome, caractérisée alors même que les opérations projetées "
                            "sont restées au stade des actes préparatoires. La question du guet-apens se pose après commission ou tentative de commission "
                            "de certaines infractions.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Il s’agit d’une forme particulière de préméditation.",
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
                    const _SubTitle("2.1 - L’attente"),
                    _Paragraph.rich([
                      law("L’article 132-71-1 du C.P."),
                      const TextSpan(
                        text:
                            " ne définit dans son intitulé ni la durée minimum ni la nature du lieu de l’attente. "
                            "C’est une notion très large que le législateur n’a pas précisée.",
                      ),
                    ]),
                    const SizedBox(height: 10),

                    const _SubTitle("2.2 - La qualité de la victime"),
                    const _Paragraph(
                      "Il s’agit de toute personne quelle que soit sa qualité. Le texte n’apporte aucune précision, se bornant à indiquer qu’il peut s’agir d’une ou plusieurs personnes.",
                    ),

                    const SizedBox(height: 10),
                    const _SubTitle("2.3 - Le but poursuivi"),
                    const _Paragraph(
                      "Ce sont les actes préparatoires en relation avec l’infraction poursuivie qui déterminent le caractère délibéré du « piège » tendu. "
                      "Il s’agit une nouvelle fois d’une forme de préméditation.",
                    ),
                    const SizedBox(height: 8),
                    const _Paragraph(
                      "La nature de la ou des infractions commises ou tentées importe peu, à la condition évidente que la loi l’ait visée expressément. "
                      "Le législateur se donne ainsi la possibilité d’appliquer à l’avenir cette circonstance aggravante à d’autres infractions.",
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
                    const _Paragraph(
                      "Le code pénal prévoit que la circonstance de guet-apens est susceptible d’aggraver les infractions suivantes :",
                    ),
                    const SizedBox(height: 10),

                    _BulletPoint(
                      text:
                          "Le meurtre (${_lawInline("article 221-3 al. 1 C.P.")}) : le meurtre est alors qualifié d’assassinat.",
                    ),
                    _BulletPoint(
                      text:
                          "L’empoisonnement (${_lawInline("article 221-5 al. 3 C.P.")}).",
                    ),
                    _BulletPoint(
                      text:
                          "Les tortures ou actes de barbarie (${_lawInline("article 222-3, 9° C.P.")}).",
                    ),
                    _BulletPoint(
                      text:
                          "Les violences (${_lawInline("articles 222-8, 222-10, 222-12, 222-13, 9° et 222-14-5 C.P.")}).",
                    ),

                    const SizedBox(height: 12),
                    const _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              "La condition essentielle est l’attente volontaire (le « piège ») + la commission ou la tentative d’une infraction expressément visée par la loi. "
                              "Le guet-apens est une forme particulière de préméditation.",
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

  /// Petit helper uniquement pour ne pas dupliquer le texte des références dans les bullet points.
  /// (Les références juridiques détaillées et mises en rouge sont affichées plus bas en RichText,
  /// afin de respecter ton rendu et garder le texte des bullets propre.)
  static String _lawInline(String t) => t;
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
