import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PVProcedurePage extends StatelessWidget {
  const PVProcedurePage({super.key});

  static const String routeName = '/gpx/pv_apj20/introduction/procedure';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMethod = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardFlow = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardRep = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
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
            "La procédure",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut (obligation respectée)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 20 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit les agents de police judiciaire (A.P.J.) et leurs missions dans le cadre de la procédure pénale.",
                ),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Mission des A.P.J. (article 20 CPP)"),
              const _BulletPoint(
                text: "Seconder les officiers de police judiciaire.",
              ),
              const _BulletPoint(
                text:
                    "Constater les crimes, les délits et les contraventions et en dresser procès-verbal.",
              ),
              const _BulletPoint(
                text:
                    "Recevoir par procès-verbal les déclarations de toutes personnes susceptibles de fournir des renseignements sur les auteurs et complices des infractions.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les A.P.J. ne peuvent exercer effectivement leurs attributions judiciaires que si leurs activités consistent, à titre principal, en des missions comportant l’exercice de la police judiciaire.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: "II — Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La procédure pénale policière peut être définie comme un ensemble de règles qui définissent la manière dont les policiers procèdent à leurs enquêtes.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Méthode de l’enquêteur
          _ConditionCard(
            title: "III — Méthode de travail",
            cardColor: cardMethod,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier qui débute une enquête doit respecter certaines méthodes : il relate, au fur et à mesure, tout ce qu’il a fait, vu ou tout ce qui a été dit devant lui.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il retranscrit ensuite ces éléments, de manière très précise, sur un acte officiel, signé de sa main : un procès-verbal.",
              ),
              SizedBox(height: 12),
              _SubTitle("Bon réflexe"),
              _BulletPoint(
                text:
                    "Écrire au fil de l’enquête : faits, constatations, paroles entendues, actions réalisées.",
              ),
              _BulletPoint(
                text:
                    "Rédiger un PV clair, précis, daté, structuré et exploitable.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Saisine + construction de la procédure
          _ConditionCard(
            title: "IV — Construction de la procédure",
            cardColor: cardFlow,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Le premier acte : la saisine"),
              const _Paragraph(
                "Le premier acte de la procédure, appelé « saisine », décrit la manière dont les services de police ont connaissance des faits.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) La procédure : un ensemble cohérent de PV"),
              const _Paragraph(
                "L’ensemble des procès-verbaux rédigés au cours d’une même enquête constitue une procédure.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les différents actes d’investigation sont généralement classés de manière chronologique.",
              ),
              const SizedBox(height: 12),

              _NotaBox(
                title: "Objectif",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Permettre une lecture fluide : comprendre l’affaire du début à la fin, sans zones d’ombre.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Transmission au magistrat + instructions
          _ConditionCard(
            title: "V — Fin d’enquête & transmission",
            cardColor: cardRep,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Lorsque les investigations sont terminées, la procédure est transmise au magistrat, qui décide ou non de poursuivre la (ou les) personne(s) mise(s) en cause.",
              ),
              SizedBox(height: 12),
              _SubTitle("Cadre d’emploi"),
              _Paragraph(
                "Des instructions émanant de chaque direction active précisent les modalités d’emploi des gardiens A.P.J. 20.",
              ),
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
