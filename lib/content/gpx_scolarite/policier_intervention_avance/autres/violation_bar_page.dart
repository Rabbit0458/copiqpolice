import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViolationBarPage extends StatelessWidget {
  const ViolationBarPage({super.key});

  static const String routeName = '/gpx/intervention/autres/violation-bar';

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
    final Color cardObj = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMeans = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardRoles = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardProcedure = isDark
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
          "Cadre juridique",
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
            "Bracelet anti-rapprochement (BAR)\nViolation & intervention",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Mis à jour le 15/06/2025",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : const Color(0xFF616161),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal en haut (sources fournies)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Loi du 28 décembre 2019",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " visant à agir contre les violences au sein de la famille.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Décret du 23 septembre 2020",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " relatif à la mise en œuvre d’un dispositif électronique mobile anti-rapprochement.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Cette mesure peut être ordonnée dans le cadre d’une procédure ",
                  ),
                  TextSpan(
                    text: "pénale ou civile",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Objectif
          _ConditionCard(
            title: "II — L’objectif",
            cardColor: cardObj,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le BAR vise à contrôler, par un dispositif de surveillance électronique mobile, "
                "l’interdiction faite à une personne de se rapprocher d’une autre, afin d’éviter la commission "
                "ou la réitération de violences conjugales.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Moyens
          _ConditionCard(
            title: "III — Les moyens",
            cardColor: cardMeans,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La personne protégée se voit attribuer un téléphone portable. "
                "L’auteur porte un bracelet électronique et dispose également d’un téléphone portable.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Qui fait quoi
          _ConditionCard(
            title: "IV — Qui fait quoi ?",
            cardColor: cardRoles,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Autorité judiciaire"),
              _Paragraph(
                "Prononce l’interdiction de rapprochement et fixe une zone de protection autour de la victime, "
                "dans laquelle l’auteur ne peut se rendre.",
              ),
              SizedBox(height: 10),
              _SubTitle("Administration pénitentiaire"),
              _Paragraph("Est chargée de la pose du bracelet."),
              SizedBox(height: 10),
              _SubTitle("Société de téléassistance (Allianz)"),
              _Paragraph(
                "Assiste la personne protégée, surveille le porteur du BAR lorsqu’il pénètre dans la zone de pré-alerte "
                "et lui ordonne d’en sortir. Elle avise les forces de l’ordre si le porteur entre dans la zone d’alerte "
                "et prend attache avec la victime pour lui donner des conseils de mise en sûreté.",
              ),
              SizedBox(height: 10),
              _SubTitle("Forces de l’ordre"),
              _Paragraph(
                "Sont saisies lorsque le porteur du BAR pénètre dans la zone d’alerte.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Comment on fait
          _ConditionCard(
            title: "V — Comment on fait ? (déclenchement & intervention)",
            cardColor: cardProcedure,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Modalités"),
              _Paragraph(
                "Lors d’une intrusion dans la zone d’alerte, le téléopérateur saisit le CIC en transmettant "
                "une demande d’intervention par le réseau RAMSES.",
              ),
              SizedBox(height: 12),
              _SubTitle("2) Intervention"),
              _Paragraph(
                "Pendant toute l’intervention, un téléopérateur reste en contact avec la personne à protéger "
                "et le porteur du BAR.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "Un second reste en relation avec le CIC, annonce la géolocalisation de la victime et de l’auteur en temps réel "
                "et transmet les informations opérationnelles complémentaires.",
              ),
              SizedBox(height: 12),
              _SubTitle("3) Fin de mission"),
              _Paragraph(
                "La victime est considérée comme mise en sûreté dans les hypothèses suivantes :",
              ),
              SizedBox(height: 8),
              _BulletPoint(text: "Le porteur du BAR a été interpellé."),
              _BulletPoint(
                text:
                    "Le porteur du BAR a quitté la zone d’alerte ou de pré-alerte.",
              ),
              _BulletPoint(
                text:
                    "La victime est conduite dans un lieu non connu de l’auteur (si nécessaire : proposition d’un hébergement d’urgence).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Une enquête judiciaire est ouverte après l’intervention des forces de l’ordre.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Objectifs équipe intervenante + coercition
          _ConditionCard(
            title: "VI — Priorités opérationnelles & coercition",
            cardColor: cardObj,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Deux objectifs pour l’équipe intervenante"),
              const _BulletPoint(
                text:
                    "Mission prioritaire : mise à l’abri de la personne à protéger.",
              ),
              const _BulletPoint(
                text: "Mission secondaire : interpellation du porteur du BAR.",
              ),
              const SizedBox(height: 12),
              _NotaBox(
                title: "COERCITION",
                bodySpans: [
                  const TextSpan(
                    text: "La coercition est possible dans le cadre de la ",
                  ),
                  TextSpan(
                    text:
                        "violation de la mesure d’interdiction de se rapprocher",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " de la personne protégée."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "À COMPLÉTER",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si tu me donnes l’article exact (CP/CPP/CSI) qui réprime la violation du BAR, "
                        "je le mets ici en rouge, en tête de section, comme demandé.",
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
