import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvisFamillePage extends StatelessWidget {
  const AvisFamillePage({super.key});

  static const String routeName =
      '/gpx/intervention/accident-circulation/avis-famille';

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
    final Color cardWhy = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCases = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardHow = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPrec = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
          "Accident circulation",
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
            "L’avis à famille",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Élément légal (cadre général)",
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
                      " : fixe le cadre des missions des gardiens de la paix (recherche et constatation des infractions dans les conditions prévues).",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Dans le cadre d’une mission de secours et d’intervention, le fonctionnaire peut être amené à informer la famille d’une personne secourue ou impliquée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Pourquoi c’est important",
            cardColor: cardWhy,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’avis à famille fait partie intégrante de la mission de service public. "
                "Il doit être réalisé avec tact, psychologie et professionnalisme.\n\n"
                "Objectif : transmettre une information sensible de façon humaine, maîtrisée "
                "et sécurisée, tout en évitant d’aggraver la détresse des proches.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "I — Cas nécessitant l’avis à famille",
            cardColor: cardCases,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Un avis doit toujours être donné à la famille d’une personne lorsque l’intervention "
                "de police a été requise.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Décès survenu à l’occasion de faits ayant entraîné l’intervention de la Police.",
              ),
              _BulletPoint(
                text:
                    "Admission à l’hôpital pour blessures ou malaise, sauf refus exprimé par une personne majeure.",
              ),
              _BulletPoint(text: "Avis obligatoire pour un mineur."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette mission incombe en premier lieu au chef d’intervention / chef de poste, "
                        "mais elle relève de toute la chaîne hiérarchique. L’OPJ est systématiquement avisé "
                        "et décide des modalités de l’avis à famille.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Réalisation de l’avis",
            cardColor: cardHow,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Appel téléphonique"),
              _Paragraph(
                "L’appel téléphonique concerne exclusivement les blessures dont l’issue n’est pas mortelle.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Déplacement au domicile"),
              _Paragraph(
                "Le déplacement au domicile s’effectue systématiquement en cas de décès. "
                "Il est également opportun en cas de blessures graves, notamment lorsqu’il s’agit d’un enfant.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Précautions essentielles",
            cardColor: cardPrec,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’avis doit être donné avec tous les ménagements qu’imposent les circonstances. "
                "Pour être exécutée dans les meilleures conditions d’humanité, cette mission délicate "
                "doit être confiée à des fonctionnaires expérimentés et respecter une procédure adaptée :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "S’assurer de l’identification de la victime.",
              ),
              _BulletPoint(
                text:
                    "Recueillir un maximum d’éléments sur les circonstances (sans forcément les évoquer lors de l’annonce).",
              ),
              _BulletPoint(
                text:
                    "Ne pas intervenir seul : être au moins deux et se répartir les rôles.",
              ),
              _BulletPoint(
                text:
                    "Entrer si possible au domicile ; à défaut, se placer hors de la vue du public.",
              ),
              _BulletPoint(
                text:
                    "S’assurer de la présence d’un tiers pouvant accompagner/soutenir la famille (proche, voisin, etc.).",
              ),
              _BulletPoint(
                text:
                    "Anticiper les réactions : envisager un soutien médical si nécessaire.",
              ),
              _BulletPoint(
                text:
                    "Annoncer les faits avec pondération, progressivement, avec un langage clair et simple.",
              ),
              _BulletPoint(
                text:
                    "Rester un moment pour prévenir/encadrer les réactions (évanouissement, crise de nerfs, agitation…).",
              ),
              _BulletPoint(
                text:
                    "Ne jamais quitter les lieux en laissant la personne seule : s’assurer qu’un tiers est présent.",
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "Objectif",
                bodySpans: [
                  TextSpan(
                    text:
                        "Transmettre l’information de manière humaine, maîtrisée et sécurisée, "
                        "en garantissant un accompagnement minimal immédiat.",
                  ),
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
