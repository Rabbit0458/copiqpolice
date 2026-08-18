import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
            "f00002",
            "Cadre juridique",
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00003",
              "Bracelet anti-rapprochement (BAR)\nViolation & intervention",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00004",
              "Mis à jour le 15/06/2025",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : const Color(0xFF616161),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal en haut (sources fournies)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00005",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                    "f00006",
                    "Loi du 28 décembre 2019",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                    "f00007",
                    " visant à agir contre les violences au sein de la famille.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                    "f00008",
                    "Décret du 23 septembre 2020",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                    "f00009",
                    " relatif à la mise en œuvre d’un dispositif électronique mobile anti-rapprochement.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00010",
                      "Cette mesure peut être ordonnée dans le cadre d’une procédure ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00011",
                      "pénale ou civile",
                    ),
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

          const SizedBox(height: 14),

          // Objectif
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00012",
              "II — L’objectif",
            ),
            cardColor: cardObj,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00013",
                      "Le BAR vise à contrôler, par un dispositif de surveillance électronique mobile, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00014",
                      "l’interdiction faite à une personne de se rapprocher d’une autre, afin d’éviter la commission ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00015",
                      "ou la réitération de violences conjugales.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Moyens
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00016",
              "III — Les moyens",
            ),
            cardColor: cardMeans,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00017",
                      "La personne protégée se voit attribuer un téléphone portable. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00018",
                      "L’auteur porte un bracelet électronique et dispose également d’un téléphone portable.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Qui fait quoi
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00019",
              "IV — Qui fait quoi ?",
            ),
            cardColor: cardRoles,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00020",
                  "Autorité judiciaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00021",
                      "Prononce l’interdiction de rapprochement et fixe une zone de protection autour de la victime, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00022",
                      "dans laquelle l’auteur ne peut se rendre.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00023",
                  "Administration pénitentiaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00024",
                  "Est chargée de la pose du bracelet.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00025",
                  "Société de téléassistance (Allianz)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00026",
                      "Assiste la personne protégée, surveille le porteur du BAR lorsqu’il pénètre dans la zone de pré-alerte ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00027",
                      "et lui ordonne d’en sortir. Elle avise les forces de l’ordre si le porteur entre dans la zone d’alerte ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00028",
                      "et prend attache avec la victime pour lui donner des conseils de mise en sûreté.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00029",
                  "Forces de l’ordre",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00030",
                  "Sont saisies lorsque le porteur du BAR pénètre dans la zone d’alerte.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Comment on fait
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00031",
              "V — Comment on fait ? (déclenchement & intervention)",
            ),
            cardColor: cardProcedure,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00032",
                  "1) Modalités",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00033",
                      "Lors d’une intrusion dans la zone d’alerte, le téléopérateur saisit le CIC en transmettant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00034",
                      "une demande d’intervention par le réseau RAMSES.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00035",
                  "2) Intervention",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00036",
                      "Pendant toute l’intervention, un téléopérateur reste en contact avec la personne à protéger ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00037",
                      "et le porteur du BAR.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00038",
                      "Un second reste en relation avec le CIC, annonce la géolocalisation de la victime et de l’auteur en temps réel ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00039",
                      "et transmet les informations opérationnelles complémentaires.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00040",
                  "3) Fin de mission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00041",
                  "La victime est considérée comme mise en sûreté dans les hypothèses suivantes :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00042",
                  "Le porteur du BAR a été interpellé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00043",
                  "Le porteur du BAR a quitté la zone d’alerte ou de pré-alerte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00044",
                  "La victime est conduite dans un lieu non connu de l’auteur (si nécessaire : proposition d’un hébergement d’urgence).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00045",
                      "Une enquête judiciaire est ouverte après l’intervention des forces de l’ordre.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Objectifs équipe intervenante + coercition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
              "f00046",
              "VI — Priorités opérationnelles & coercition",
            ),
            cardColor: cardObj,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00047",
                  "Deux objectifs pour l’équipe intervenante",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00048",
                  "Mission prioritaire : mise à l’abri de la personne à protéger.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00049",
                  "Mission secondaire : interpellation du porteur du BAR.",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "COERCITION",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00050",
                      "La coercition est possible dans le cadre de la ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00051",
                      "violation de la mesure d’interdiction de se rapprocher",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                      "f00052",
                      " de la personne protégée.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                  "f00053",
                  "À COMPLÉTER",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                          "f00054",
                          "Si tu me donnes l’article exact (CP/CPP/CSI) qui réprime la violation du BAR, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/autres/violation_bar_page.dart",
                          "f00055",
                          "je le mets ici en rouge, en tête de section, comme demandé.",
                        ),
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
