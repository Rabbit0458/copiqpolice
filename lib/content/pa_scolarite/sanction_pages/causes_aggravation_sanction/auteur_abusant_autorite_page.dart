import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAuteurAbusantAutoritePage extends StatelessWidget {
  const PaAuteurAbusantAutoritePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/auteur_abusant_autorite';

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
          "Auteur abusant de son autorité",
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
                // Intro (sans répéter le titre dans le body)
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
                      text:
                          "Par une personne qui abuse de l'autorité que lui confèrent ses fonctions.",
                      style: TextStyle(fontWeight: FontWeight.w700),
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
                      "Cette circonstance aggrave les infractions commises par des personnes ayant une autorité générale due aux fonctions qu'elles exercent à l'égard d'un certain nombre de personnes.",
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Il s'agit d'une circonstance aggravante personnelle. Ses effets ne s'étendent pas aux coauteurs de l'infraction.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: '2 : CONDITIONS',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: const [
                    _SubTitle(
                      "2.1 - La personne ayant autorité sur la victime",
                    ),
                    _Paragraph(
                      "Ces personnes ne rentrent pas dans le cadre des ascendants. Il s'agit notamment des professeurs, médecins, prêtres, marabout, etc.",
                    ),
                    SizedBox(height: 12),
                    _SubTitle("2.2 - Les fonctions exercées"),
                    _Paragraph(
                      "Les fonctions exercées peuvent être publiques ou privées.",
                    ),
                    SizedBox(height: 12),
                    _SubTitle("2.3 - L'abus de l’autorité"),
                    _Paragraph(
                      "L'aggravation est encourue lorsque l'auteur de l'infraction a abusé de cette autorité pour commettre des actes répréhensibles auxquels elle s'applique.",
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
                    _Paragraph.rich([
                      const TextSpan(text: "➤ LE VIOL (ARTICLE "),
                      law("222-24, 5° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "➤ LES AGRESSIONS SEXUELLES (ARTICLE ",
                      ),
                      law("222-28, 3° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "➤ LES AGRESSIONS SEXUELLES SUR MINEUR DE QUINZE ANS OU PERSONNE VULNÉRABLE (ARTICLE ",
                      ),
                      law("222-30, 3° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "➤ LE HARCÈLEMENT SEXUEL (ARTICLE "),
                      law("222-33 III, 1° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "➤ LA TRAITE DES ÊTRES HUMAINS (ARTICLE ",
                      ),
                      law("225-4-2, 8° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "➤ LE PROXÉNÉTISME (ARTICLE "),
                      law("225-7, 5° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "➤ LE RECOURS À LA PROSTITUTION DE MINEUR (ARTICLE ",
                      ),
                      law("225-12-2, 3° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "➤ LES ATTEINTES SEXUELLES SANS VIOLENCE SUR MINEUR DE QUINZE ANS (ARTICLE ",
                      ),
                      law("227-26, 2° C.P."),
                      const TextSpan(
                        text: ") ET DE PLUS DE QUINZE ANS (ARTICLE ",
                      ),
                      law("227-27, 2° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "➤ LES TORTURES OU ACTES DE BARBARIE (ARTICLE ",
                      ),
                      law("222-3, al. 18 C.P."),
                      const TextSpan(text: ")"),
                    ]),
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
