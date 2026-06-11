import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEscaladePage extends StatelessWidget {
  const PaEscaladePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/escalade';

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
          "L'escalade",
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
                  child: const _Paragraph.rich([
                    TextSpan(text: "« "),
                    TextSpan(
                      text:
                          "L'escalade est le fait de s'introduire dans un lieu quelconque, soit par-dessus un élément de clôture, soit par toute ouverture non destinée à servir d'entrée.",
                      style: TextStyle(fontWeight: FontWeight.w800),
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
                      law("L'article 132-74 du C.P."),
                      const TextSpan(
                        text:
                            " définit l'escalade. Il s'agit d'une circonstance aggravante réelle. Ses effets s'étendent à tous les auteurs, coauteurs et complices de l'infraction.",
                      ),
                    ]),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Comme l'effraction, c'est le fait d'utiliser un moyen illicite pour pénétrer dans un lieu clos. La nature du moyen diffère de celui utilisé pour l'effraction. Il s'agit ici du franchissement d'une clôture ou de l'entrée par une issue non prévue à cet effet.",
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
                    _SubTitle('2.1 - Un endroit clos'),
                    _Paragraph(
                      "Il s'agit d'un endroit quelconque dont l'accès est normalement interdit aux tiers par une clôture (haie, mur, porte, portail, toiture, etc....).",
                    ),
                    SizedBox(height: 10),
                    _SubTitle("2.2 - L'usage d'un moyen"),
                    _Paragraph(
                      "Le moyen utilisé importe peu. Il peut s'agir d'un moyen prévu et organisé par l'auteur, trouvé par hasard ou improvisé (une échelle, un échafaudage, une corde, un grappin, etc.).",
                    ),
                    SizedBox(height: 8),
                    _Paragraph(
                      "Il en va de même pour toute intrusion par une issue n'étant pas de nature à servir d'entrée (fenêtre, soupirail, tunnel, etc....).",
                    ),
                    SizedBox(height: 10),
                    _SubTitle('2.3 - Le but poursuivi'),
                    _Paragraph(
                      "La circonstance d'escalade ne peut être réalisée que de l'extérieur vers l'intérieur comme précise le texte : « L'escalade est le fait de s'introduire... ».",
                    ),
                    SizedBox(height: 8),
                    _Paragraph(
                      "L'escalade aggrave la peine encourue par son auteur lorsqu'elle accompagne une infraction commise ou tentée pour laquelle la loi qui la réprime le prévoit.",
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
                    const _Paragraph(
                      "Le code pénal prévoit que la circonstance de commission par escalade est susceptible d'aggraver les infractions suivantes :",
                    ),
                    const SizedBox(height: 10),
                    const _BulletPoint(text: "Le vol (article 311-5, 3° C.P.)."),
                    const _BulletPoint(
                      text:
                          "Les destructions, dégradations, détériorations (article 322-3, 5° C.P.).",
                    ),
                    const SizedBox(height: 8),
                    // Version "parfaite" : on colore précisément les références
                    _NotaBox(
                      title: 'Références',
                      bodySpans: [
                        const TextSpan(text: "• "),
                        const TextSpan(text: "Vol : "),
                        law("article 311-5, 3° du C.P."),
                        const TextSpan(text: "\n• "),
                        const TextSpan(
                          text:
                              "Destructions / dégradations / détériorations : ",
                        ),
                        law("article 322-3, 5° du C.P."),
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
