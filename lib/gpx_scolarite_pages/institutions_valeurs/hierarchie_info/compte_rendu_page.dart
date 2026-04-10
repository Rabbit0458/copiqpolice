import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompteRenduPage extends StatelessWidget {
  const CompteRenduPage({super.key});

  static const String routeName =
      '/gpx/institution/hierarchie_info/compte_rendu';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

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
          "Hiérarchie & information",
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
            "Le compte-rendu",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / idée générale
          _ConditionCard(
            title: "Définition",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les policiers doivent rendre compte, en permanence, de leurs activités à l’autorité hiérarchique.\n\n"
                "Le compte-rendu peut être effectué oralement ou prendre la forme d’un rapport ou d’une mention de main courante.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Obligations (élément « légal/pro » en haut)
          _ConditionCard(
            title: "I — Règle professionnelle",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’obligation de rendre compte sans délai à la hiérarchie de tout fait ou incident "
                "à caractère personnel ou se rapportant à l’exécution du service s’applique à tous les policiers.\n\n"
                "La hiérarchie doit être tenue informée :\n"
                "• de l’évolution des faits signalés ;\n"
                "• des suites données.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principe
          _ConditionCard(
            title: "II — Le compte-rendu",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Principe"),
              _Paragraph("Le compte-rendu est un exposé qui doit être :"),
              SizedBox(height: 10),
              _BulletPoint(text: "Exact et objectif"),
              _BulletPoint(text: "Circonstancié"),
              _BulletPoint(text: "Clair et concis"),
              SizedBox(height: 12),
              _Paragraph(
                "Il relate l’action du policier :\n"
                "• sur des faits auxquels il a participé ;\n"
                "• soit comme témoin ;\n"
                "• soit comme acteur ;\n"
                "• et sur les décisions qu’il a été amené à prendre pour assurer sa mission.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Structure (grille)
          _ConditionCard(
            title: "B) Structure (grille de rédaction)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Pour effectuer un compte-rendu clair et précis, il est recommandé d’utiliser une grille "
                "répondant aux questions essentielles :",
              ),
              SizedBox(height: 10),
              _IntroBullet(text: "Quand ?"),
              _IntroBullet(text: "Où ?"),
              _IntroBullet(text: "Quoi ?"),
              _IntroBullet(text: "Comment ?"),
              _IntroBullet(text: "Qui ?"),
              _IntroBullet(text: "Conséquences ?"),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette grille évite les oublis, améliore la lisibilité et facilite l’exploitation du compte-rendu par la hiérarchie.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Développement (détaillé et pédagogique)
          _ConditionCard(
            title: "C) Développement (contenu attendu)",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("1) QUAND ?"),
              _BulletPoint(text: "Date et heure des faits / de l’événement."),

              SizedBox(height: 10),

              _SubTitle("2) OÙ ?"),
              _BulletPoint(
                text: "Lieu précis (adresse, secteur, point de repère).",
              ),

              SizedBox(height: 10),

              _SubTitle("3) QUI ?"),
              _Paragraph("Personnes impliquées ou en cause :"),
              SizedBox(height: 8),
              _BulletPoint(text: "Auteurs"),
              _BulletPoint(text: "Victimes"),
              _BulletPoint(text: "Plaignants / requérants"),
              _BulletPoint(text: "Témoins"),

              SizedBox(height: 10),

              _SubTitle("4) QUOI ?"),
              _Paragraph("Nature des faits / de l’événement / de la demande :"),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Faits : accident de circulation, trouble, dégradation…",
              ),
              _BulletPoint(text: "Événement : explosion d’immeuble, incendie…"),
              _BulletPoint(
                text: "Demande : intervention des secours, renseignements…",
              ),

              SizedBox(height: 10),

              _SubTitle("5) COMMENT ?"),
              _Paragraph(
                "Circonstances dans lesquelles se sont déroulés les faits :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Ce que l’on a vu ou entendu en distinguant : direct (constatations) / indirect (déclarations).",
              ),

              SizedBox(height: 12),

              _SubTitle("6) CONSÉQUENCES ?"),
              _Paragraph("Conséquences constatées et actions menées :"),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Pour les victimes : blessures, hospitalisation, préjudices matériels.",
              ),
              _BulletPoint(
                text:
                    "Pour la police : recherches, interpellation, conduite/convocation au commissariat, garde des lieux, déviation de circulation, avis aux secours ou aux autorités compétentes…",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse / rappel qualité
          _ConditionCard(
            title: "En résumé",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Rendre compte sans délai et tenir la hiérarchie informée de l’évolution et des suites.",
              ),
              _BulletPoint(
                text:
                    "Rédiger un compte-rendu exact, objectif, circonstancié, clair et concis.",
              ),
              _BulletPoint(
                text:
                    "Utiliser la grille : Quand / Où / Qui / Quoi / Comment / Conséquences.",
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
