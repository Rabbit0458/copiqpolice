import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfrontationGeneralitesPage extends StatelessWidget {
  const ConfrontationGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/confrontation/generalites';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardBefore = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDuring = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPV = isDark
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
          "Confrontation",
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
            "Généralités — La confrontation",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro
          _ConditionCard(
            title: "Définition (objectif)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Au cours d’une enquête, les déclarations peuvent être contradictoires "
                "(victime/suspect, divergences entre suspects, versions incompatibles d’un même fait). "
                "La confrontation consiste à mettre en présence les personnes dont les déclarations sont contradictoires, "
                "afin de clarifier les divergences point par point.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (articles cités dans ton texte)
          _ConditionCard(
            title: "Élément légal — assistance de l’avocat",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Lorsque l’infraction concernée est un crime ou un délit puni d’une peine d’emprisonnement, l’assistance de l’avocat peut s’appliquer. ",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Victime confrontée avec une personne gardée à vue : ",
                ),
                TextSpan(
                  text: "article 63-4-5 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Victime confrontée avec une personne soupçonnée entendue librement : ",
                ),
                TextSpan(
                  text: "article 61-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // AVANT
          _ConditionCard(
            title: "I — Avant la confrontation",
            cardColor: cardBefore,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Connaître l’affaire et les divergences"),
              _Paragraph(
                "La confrontation se prépare :\n"
                "• relever précisément les points litigieux,\n"
                "• répertorier les questions à poser,\n"
                "• prévoir l’ordre des thèmes pour éviter les échanges confus.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Conditions matérielles"),
              _Paragraph(
                "La confrontation doit se dérouler dans un local du service suffisamment grand "
                "pour accueillir toutes les personnes confrontées.\n"
                "Le responsable de l’opération (assisté d’un ou plusieurs collègues) rappelle les règles :",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Chacun doit garder son calme."),
              _BulletPoint(
                text: "Interdiction de prendre la parole sans y être invité.",
              ),
              _BulletPoint(
                text:
                    "Interdiction d’interrompre son contradicteur au cours de sa déposition.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // PENDANT
          _ConditionCard(
            title: "II — Pendant la confrontation",
            cardColor: cardDuring,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Assistance de l’avocat"),
              const _Paragraph(
                "➤ Pour la victime\n"
                "La victime peut être assistée d’un avocat lorsqu’elle est confrontée avec une personne gardée à vue "
                "ou une personne soupçonnée entendue librement. Elle doit être préalablement informée :\n"
                "• du choix d’un avocat ou de la désignation d’office,\n"
                "• des frais à sa charge (sauf conditions d’aide juridictionnelle).\n"
                "L’avocat peut consulter les procès-verbaux d’audition de la victime.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "➤ Pour le suspect\n"
                "La personne suspectée (gardée à vue ou entendue librement) peut également être assistée par un avocat lors de la confrontation.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les avocats peuvent prendre des notes, mais ne peuvent ni conseiller leur client, ni intervenir pendant la confrontation.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Déroulement"),
              const _Paragraph(
                "L’enquêteur met en présence les intéressés et donne lecture des déclarations respectives.\n"
                "Point par point, il demande à chacun s’il maintient ou non ses déclarations antérieures.\n"
                "Chaque contradiction est consignée et soulignée sur un seul et même procès-verbal.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’officier ou l’agent de police judiciaire conserve la direction de l’opération. "
                        "Il peut y mettre fin si le comportement d’une partie empêche le bon déroulement : une mention est portée au procès-verbal.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "À l’issue de la confrontation, l’avocat peut poser des questions au suspect et/ou à la victime. "
                "L’enquêteur peut s’opposer aux questions si elles risquent de nuire au bon déroulement de l’enquête.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // PV / Qualité rédactionnelle
          _ConditionCard(
            title: "Procès-verbal — exigences de rédaction",
            cardColor: cardPV,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le procès-verbal de confrontation obéit aux mêmes règles que les autres PV.\n"
                "Il doit refléter fidèlement le déroulement :\n"
                "• lecture des déclarations,\n"
                "• positions de chacun (maintien ou non),\n"
                "• contradictions relevées,\n"
                "• incidents éventuels et décisions (ex. fin de confrontation).\n"
                "Tout doit être clair, chronologique et factuel.",
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
