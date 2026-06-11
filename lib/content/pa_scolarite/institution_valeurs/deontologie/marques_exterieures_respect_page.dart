import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMarquesExterieuresRespectPage extends StatelessWidget {
  const PaMarquesExterieuresRespectPage({super.key});

  static const String routeName =
      '/pa/institution/deontologie/marques_respect';

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
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          "Déontologie",
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
            "Les marques extérieures de respect",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro (contexte)
          _ConditionCard(
            title: "Contexte",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Agissant en uniforme, les policiers doivent adopter un comportement net et irréprochable, "
                "tel qu’attendu des agents de l’autorité. Cela implique notamment la maîtrise des gestes "
                "de salut et de présentation, exécutés avec précision et tenue.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (même si la notion est “déonto/usage”, tu voulais un encart légal en premier)
          _ConditionCard(
            title: "Référence réglementaire",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Règlement général d’emploi (RGE) de la Police nationale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : encadre les usages, appellations et règles de tenue/comportement (salut, présentation, respect de la hiérarchie).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Objectif : garantir une attitude professionnelle, lisible et respectueuse, autant envers la hiérarchie qu’envers le public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Le salut
          _ConditionCard(
            title: "I — Le salut",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En uniforme, le salut est une marque de respect, de politesse et de considération envers tout interlocuteur. "
                "Une exécution parfaite traduit la disponibilité et l’attention du policier.",
              ),
              SizedBox(height: 12),
              _SubTitle("Sens et particularité (Police nationale)"),
              _Paragraph(
                "Le salut se distingue du salut militaire : il exprime à la fois le respect dû à la hiérarchie "
                "et un signe de courtoisie à l’égard du public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "A) Une marque de respect",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Le salut est dû à tout supérieur, qu’il soit en civil ou en tenue.",
              ),
              _BulletPoint(text: "Il est également dû au drapeau."),
              _BulletPoint(text: "Il est dû aux membres du corps préfectoral."),
              _BulletPoint(
                text: "Il est dû aux officiers de l’armée française.",
              ),
              _BulletPoint(
                text:
                    "Par extension : les autorités politiques et judiciaires sont saluées.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "B) Un signe de courtoisie",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Une pratique de la Police nationale veut qu’un salut bref marque, sur la voie publique, "
                "la prise de contact avec la personne qui requiert l’intervention du policier.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Présentation
          _ConditionCard(
            title: "II — La présentation",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La présentation s’entend de l’entrée dans un bureau, après y avoir été invité. "
                "Elle suit une logique simple : posture, salut, annonce, puis attente des ordres.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Déroulé pratique (pédagogique + visuel)
          _ConditionCard(
            title: "Déroulé pratique (étapes)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Entrée et tenue"),
              _BulletPoint(
                text:
                    "Se mettre au garde à vous, saluer, puis enlever la coiffure.",
              ),
              SizedBox(height: 10),
              _SubTitle("2) Présentation proprement dite"),
              _BulletPoint(
                text: "Énoncer : grade, nom, prénom, section ou peloton.",
              ),
              _BulletPoint(
                text:
                    "Adapter la formule à l’autorité rencontrée (voir encadré ci-dessous).",
              ),
              SizedBox(height: 10),
              _SubTitle("3) Suite de l’entretien"),
              _BulletPoint(
                text:
                    "Se mettre au repos (sur ordre), exposer les faits, puis attendre l’ordre de disposition.",
              ),
              SizedBox(height: 10),
              _SubTitle("4) Sortie"),
              _BulletPoint(
                text:
                    "Reprendre le garde à vous, se coiffer, saluer, puis sortir.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Formules (encadré propre)
          _ConditionCard(
            title: "Formules usuelles",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Formule « à vos ordres »"),
              _IntroBullet(
                text:
                    "Commandant, capitaine, lieutenant, major, brigadier-chef.",
              ),
              SizedBox(height: 12),
              _SubTitle("Formule « Mes respects »"),
              _IntroBullet(text: "M. ou Mme le directeur."),
              _IntroBullet(text: "M. ou Mme le commissaire divisionnaire."),
              _IntroBullet(text: "M. ou Mme le commissaire de police."),
            ],
          ),

          const SizedBox(height: 14),

          // Nota (exigence appellations)
          _ConditionCard(
            title: "Point d’attention",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Il est admis, dans la pratique, de s’adresser à un supérieur en disant « Mr le divisionnaire » au lieu de « Mr le commissaire divisionnaire ». "
                        "Toutefois, la hiérarchie peut exiger les appellations usuelles conformes au ",
                  ),
                  TextSpan(
                    text: "règlement général d’emploi de la Police nationale",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
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
