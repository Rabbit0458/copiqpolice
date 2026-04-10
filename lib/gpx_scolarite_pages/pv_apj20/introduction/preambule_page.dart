import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVPreambulePage extends StatelessWidget {
  const PVPreambulePage({super.key});

  static const String routeName = '/gpx/pv_apj20/introduction/preambule';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardSteps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMethod = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          "PV — APJ 20",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            "Préambule",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Académie de Police",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 15.5,
              height: 1.2,
              color: isDark ? Colors.white70 : const Color(0xFF0D47A1),
            ),
          ),

          const SizedBox(height: 12),

          // Intro / idée directrice
          _ConditionCard(
            title: "Idée directrice",
            cardColor: cardIntro,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’enquête de police se définit comme une suite d’actes ayant pour finalité la manifestation de la vérité.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Elle doit permettre de qualifier les faits, de rassembler les preuves et de rechercher les auteurs de l’infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition + finalité
          _ConditionCard(
            title: "Définition — ce qu’est une enquête",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Finalité"),
              _IntroBullet(text: "Manifester la vérité."),
              _IntroBullet(text: "Qualifier juridiquement les faits."),
              _IntroBullet(text: "Rassembler les preuves."),
              _IntroBullet(
                text: "Identifier et rechercher l’auteur (ou les auteurs).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Dossier de procédure
          _ConditionCard(
            title: "Le dossier de procédure",
            cardColor: cardSteps,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’enquêteur, qu’il soit officier ou agent de police judiciaire, constitue un dossier de la procédure.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Ce dossier comprend un nombre variable de procès-verbaux selon la gravité des faits et l’importance des investigations menées.",
              ),
              SizedBox(height: 12),
              _SubTitle("À retenir"),
              _BulletPoint(
                text:
                    "Le dossier s’adapte : plus les faits sont graves et l’enquête dense, plus le volume d’actes augmente.",
              ),
              _BulletPoint(
                text:
                    "Chaque acte (PV) doit être clair, daté, cohérent et exploitable par la suite (hiérarchie / parquet / juridiction).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Objectif du recueil
          _ConditionCard(
            title: "Objectif de ce recueil",
            cardColor: cardMethod,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Ce recueil présente les principaux procès-verbaux qu’un A.P.J. 20 peut être amené à rédiger, quel que soit son service d’affectation.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Il est conçu comme une aide pratique : les principales étapes d’une enquête de police sont exposées, pour te guider de manière structurée.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Organisation pédagogique"),
              const _BulletPoint(
                text:
                    "Une fiche de cours précède le ou les modèles de procès-verbaux.",
              ),
              const _BulletPoint(
                text:
                    "Un canevas fournit des explications sur le contenu propre à chaque acte.",
              ),
              const SizedBox(height: 12),

              // Petite note méthodo (sans copyWith)
              _NotaBox(
                title: "Conseil",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Avant de rédiger un PV, identifie toujours : le contexte, l’objectif de l’acte, les personnes concernées, et les éléments factuels indispensables. ",
                  ),
                  const TextSpan(
                    text:
                        "Ensuite seulement, structure la rédaction (chronologie, constatations, auditions, annexes).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Placeholder loi (si tu veux en mettre plus tard), mais je respecte ton contenu fourni (pas de loi dans le préambule).
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Remarque : si tu ajoutes plus tard des références légales (CPP / CP / CSI…), elles devront apparaître en ",
                ),
                TextSpan(
                  text: "rouge",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " conformément à ta règle d’affichage."),
              ]),
            ],
          ),
        ],
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
          border: Border.all(color: accent.withOpacity(.22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
                    : const Color(0xFF1F1F1F).withOpacity(.92),
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
        color: bgColor.withOpacity(isDark ? .7 : .95),
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
                : const Color(0xFF3E2723).withOpacity(.95),
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
