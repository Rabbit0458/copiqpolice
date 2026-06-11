import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMoyenCryptologiePage extends StatelessWidget {
  const PaMoyenCryptologiePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/moyen_cryptologie';

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
          "Moyen de cryptologie",
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
                          "Lorsqu'un moyen de cryptologie au sens de l'article 29 de la loi n° 2004-575 du 21 juin 2004 pour la confiance dans l'économie numérique a été utilisé pour préparer ou commettre un crime ou un délit, ou pour en faciliter la préparation ou la commission, le maximum de la peine privative de liberté est relevé. ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: "\n\n"),
                    TextSpan(
                      text:
                          "Les dispositions du présent article ne sont toutefois pas applicables à l'auteur ou au complice de l'infraction qui, à la demande des autorités judiciaires ou administratives, leur a remis la version en clair des messages chiffrés ainsi que les conventions secrètes nécessaires au déchiffrement.",
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
                  children: [
                    _Paragraph.rich([
                      const TextSpan(text: "L'article "),
                      law("132-79"),
                      const TextSpan(
                        text:
                            " du C.P. définit l'utilisation d'un moyen de cryptologie. Il s'agit d'une circonstance aggravante réelle. Ses effets s'étendent à tous les auteurs, coauteurs et complices de l'infraction.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Cette circonstance a pour but de réprimer plus sévèrement les auteurs d'infractions qui ont utilisé un moyen permettant d'assurer la confidentialité des communications pour préparer, faciliter ou commettre les faits.",
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
                    const _SubTitle(
                      "2.1 - L'utilisation d’un moyen de cryptologie",
                    ),
                    const _Paragraph(
                      "Il s'agit d'un moyen permettant d'assurer la confidentialité des communications.",
                    ),
                    const SizedBox(height: 10),
                    _Paragraph.rich([
                      const TextSpan(text: "L'article "),
                      law("29"),
                      const TextSpan(text: " de la loi n° "),
                      law("2004-575"),
                      const TextSpan(
                        text:
                            " du 21 juin 2004 précise : « On entend par moyen de cryptologie, tout matériel ou logiciel conçu ou modifié pour transformer des données, qu'il s'agisse d'informations ou de signaux, à l'aide de conventions secrètes ou pour réaliser l'opération inverse avec ou sans convention secrète. Ces moyens de cryptologie ont principalement pour objet de garantir la sécurité du stockage ou de la transmission des données, en permettant d'assurer leur confidentialité, leur authentification ou le contrôle de leur intégrité. »",
                      ),
                    ]),
                    const SizedBox(height: 12),
                    const _SubTitle('2.2 - Le but poursuivi'),
                    const _Paragraph(
                      "Il s'agit de réprimer les infractions pour lesquelles un procédé technique a été utilisé.",
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
                      const TextSpan(text: "L'article "),
                      law("132-79"),
                      const TextSpan(
                        text:
                            " du code pénal est de portée générale. Ses dispositions s'appliquent à tous les crimes et délits qu'ils aient été commis ou tentés.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Cependant, cette circonstance ne sera pas applicable à l'auteur ou au complice de l'infraction qui : « à la demande des autorités judiciaires ou administratives, leur a remis la version en clair des messages chiffrés ainsi que les conventions secrètes nécessaires au déchiffrement. »",
                    ),
                    const SizedBox(height: 12),

                    _NotaBox(
                      title: 'Jurisprudence',
                      bodySpans: [
                        const TextSpan(
                          text:
                              "Le code de déverrouillage d'un téléphone mobile peut constituer une clé de déchiffrement, si ce téléphone est équipé d'un moyen de cryptologie ",
                        ),
                        const TextSpan(text: "("),
                        law("Cass. crim., n° 19-85.984 du 11 octobre 2020"),
                        const TextSpan(text: "). "),
                        const TextSpan(
                          text:
                              "L'utilisation d'un tel téléphone dans les conditions prévues par l'article ",
                        ),
                        law("132-79"),
                        const TextSpan(
                          text:
                              " pourrait donc constituer la circonstance aggravante.",
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
