import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEnlevementSequestrationPage extends StatelessWidget {
  const PaEnlevementSequestrationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/enlevement_sequestration';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    // Palette cohérente
    final Color cIntro = isDark
        ? const Color(0xFF101A2B)
        : const Color(0xFFEAF2FF);
    final Color cIntroAccent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    final Color cLegal = isDark
        ? const Color(0xFF1B1420)
        : const Color(0xFFFFEBEE);
    final Color cLegalAccent = isDark
        ? const Color(0xFFE57373)
        : const Color(0xFFC62828);

    final Color cMat = isDark
        ? const Color(0xFF0F1E19)
        : const Color(0xFFE8F5E9);
    final Color cMatAccent = isDark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    final Color cMoral = isDark
        ? const Color(0xFF1A1A11)
        : const Color(0xFFFFF8E1);
    final Color cMoralAccent = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

    final Color cAggr = isDark
        ? const Color(0xFF1A1411)
        : const Color(0xFFFFF3E0);
    final Color cAggrAccent = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFEF6C00);

    final Color cRepr = isDark
        ? const Color(0xFF121821)
        : const Color(0xFFE8EAF6);
    final Color cReprAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF283593);

    // Helpers TextSpan (articles en rouge)
    TextSpan lawRef(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
    );
    TextSpan normal(String s) => TextSpan(text: s);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: Text(
          "Enlèvement & séquestration",
          style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : const Color(0xFF0D1B2A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Exigence : élément légal en haut
              _ConditionCard(
                title: "Article de référence (élément légal)",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 224-1 du Code pénal"),
                    normal(
                      " : prévoit et réprime les infractions d’arrestation, enlèvement, détention et séquestration.",
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "Définition",
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    "Le fait, sans ordre des autorités constituées et hors les cas prévus par la loi, "
                    "d’arrêter, d’enlever, de détenir ou de séquestrer une personne constitue une infraction.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "4 verbes = 4 infractions autonomes (arrestation / enlèvement / détention / séquestration).",
                  ),
                  _IntroBullet(
                    text:
                        "Point commun : entraver la liberté d’aller et venir.",
                  ),
                  _IntroBullet(
                    text:
                        "Condition négative : absence d’ordre de la loi / de l’autorité légitime.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "I — Élément légal",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 224-1 du C.P."),
                    normal(
                      " : incrimine l’arrestation, l’enlèvement, la détention ou la séquestration, "
                      "sans ordre des autorités constituées et hors les cas prévus par la loi.",
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "II — Élément matériel",
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle(
                    "1) La commission d’un acte (4 infractions autonomes)",
                  ),
                  const _SubTitle("• Arrestation"),
                  const _Paragraph(
                    "Appréhender physiquement une personne à l’endroit où elle se trouve, de manière à la priver "
                    "de sa liberté d’aller et venir.",
                  ),
                  const SizedBox(height: 10),

                  const _SubTitle("• Enlèvement"),
                  const _Paragraph(
                    "Entraîner la victime de l’endroit où elle se trouve pour la déplacer vers un lieu différent. "
                    "Durant ce déplacement, la victime est privée de sa liberté d’aller et venir.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Victime maintenue à l’arrière d’un véhicule et transportée, sans possibilité de fuite, "
                        "vers un lieu où elle ne voulait pas aller : ",
                      ),
                      normal("Cass. crim., 23 février 2000"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("• Détention"),
                  const _Paragraph(
                    "La détention consiste à retenir une personne contre son gré, en la privant de sa liberté d’aller et venir. "
                    "L’atteinte à la liberté de mouvement doit se prolonger.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Exemple classique : des salariés grévistes retiennent des cadres/dirigeants jusqu’à acceptation de revendications.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("• Séquestration"),
                  const _Paragraph(
                    "La distinction détention / séquestration est délicate. Selon certains auteurs, la séquestration "
                    "serait une détention doublée d’inconfort (conditions plus contraignantes).",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    "2) Absence d’élément justificatif (condition négative)",
                  ),
                  const _Paragraph(
                    "L’existence d’un ordre de la loi ou d’un commandement de l’autorité légitime empêche l’infraction "
                    "d’être constituée.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Exemple : "),
                    lawRef("article 73 du Code de procédure pénale"),
                    normal(
                      " — permet à toute personne d’appréhender l’auteur d’un crime ou d’un délit flagrant.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Ne commet pas une arrestation/détention illégale la personne ayant appréhendé l’auteur d’un vol "
                        "et l’ayant retenu jusqu’à l’arrivée de l’OPJ : ",
                      ),
                      normal("Cass. crim., 1er octobre 1979"),
                      normal("."),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "III — Élément moral",
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle(
                    "Conscience d’entraver la liberté d’aller et venir",
                  ),
                  _Paragraph.rich([
                    normal(
                      "L’intention délictueuse est caractérisée par la volonté d’empêcher la victime d’aller et venir "
                      "librement pendant un temps plus ou moins long ou de l’isoler du monde extérieur. ",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Définition de l’intention : "),
                      normal("T. corr. Caen, 24 novembre 1972"),
                      normal("."),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "IV — Circonstances aggravantes",
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 224-2 du C.P."),
                    normal(" : deux degrés d’aggravation."),
                  ]),
                  const SizedBox(height: 10),

                  const _SubTitle("• Premier degré (224-2 al. 1)"),
                  const _BulletPoint(
                    text:
                        "La victime a subi une mutilation ou une infirmité permanente (volontairement provoquée ou résultant des conditions de détention, d’une privation d’aliments ou de soins).",
                  ),
                  const SizedBox(height: 10),

                  const _SubTitle("• Second degré (224-2 al. 2)"),
                  const _BulletPoint(
                    text:
                        "Infraction précédée ou accompagnée de tortures / actes de barbarie, ou suivie de la mort de la victime.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "La mort de la victime ne peut pas être retenue à la fois comme constitutive de l’assassinat et "
                        "comme circonstance aggravante de la séquestration : ",
                      ),
                      normal("Cass. crim., 20 février 2002"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _Paragraph.rich([
                    lawRef("Article 224-3 du C.P."),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Infraction commise à l’égard de plusieurs personnes.",
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    lawRef("Article 224-4 du C.P."),
                    normal(" (prise d’otage) :"),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Pour préparer ou faciliter la commission d’un crime ou d’un délit.",
                  ),
                  const _BulletPoint(
                    text:
                        "Pour favoriser la fuite ou assurer l’impunité de l’auteur/complice d’un crime ou délit.",
                  ),
                  const _BulletPoint(
                    text:
                        "Pour obtenir l’exécution d’un ordre ou d’une condition (notamment versement d’une rançon).",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "La circonstance aggravante « prise d’otage » a un caractère réel : elle s’étend aux coauteurs et complices.",
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    lawRef("Article 224-5 du C.P."),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(text: "Victime mineure de 15 ans."),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    lawRef("Article 224-5-2 du C.P."),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Enlèvement ou séquestration commis en bande organisée.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Un 2ᵉ degré d’aggravation est prévu lorsque les infractions des articles 224-2 à 224-5 "
                    "sont commises en bande organisée.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "V — Répression, tentative, complicité, exemptions",
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle("Peines (vue d’ensemble)"),
                  _Paragraph.rich([
                    normal("Forme simple ("),
                    lawRef("article 224-1 al. 1 du C.P."),
                    normal(
                      ") : 20 ans de réclusion criminelle (période de sûreté).",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Aggravation 1ᵉʳ degré ("),
                    lawRef("article 224-2 al. 1 du C.P."),
                    normal(
                      ") : 30 ans de réclusion criminelle (période de sûreté).",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Aggravation 2ᵉ degré ("),
                    lawRef("article 224-2 al. 2 du C.P."),
                    normal(
                      ") : réclusion criminelle à perpétuité (période de sûreté).",
                    ),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Personnes morales"),
                  _Paragraph.rich([
                    normal("Responsabilité pénale prévue par "),
                    lawRef("l’article 121-2 du C.P."),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  const _Paragraph(
                    "Tentative : OUI (toujours prévue pour les crimes). "
                    "Attention : la question peut se poser si, par réduction de peine (224-1 al. 3), l’infraction devient un délit.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal("Complicité : OUI — punissable selon "),
                    lawRef("les articles 121-6 et 121-7 du C.P."),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Exemption ou réduction de peine : OUI"),
                  const _SubTitle("• Libération volontaire"),
                  const _Paragraph(
                    "Une diminution de peine est prévue lorsque la personne détenue/séquestrée est libérée volontairement "
                    "avant le 7ᵉ jour accompli depuis son appréhension. Cela peut changer la qualification : le crime devient délit.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Le crime peut devenir un délit en cas de libération volontaire avant 7 jours : ",
                      ),
                      normal("Cass. crim., 8 juin 2006"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Cette réduction n’est pas mentionnée à l’article 224-5 (victime mineure de 15 ans) : "
                    "elle n’est donc pas applicable dans cette hypothèse.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "La libération volontaire peut résulter d’une cessation de surveillance permettant à la victime de quitter les lieux : ",
                      ),
                      normal("Cass. crim., 11 août 2021"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("• Dénonciation (224-5-1)"),
                  _Paragraph.rich([
                    lawRef("Article 224-5-1 al. 1 du C.P."),
                    normal(
                      " : exemption de peine si l’auteur d’une tentative a averti l’autorité administrative/judiciaire et a permis "
                      "d’éviter la réalisation de l’infraction.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    lawRef("Article 224-5-1 al. 2 du C.P."),
                    normal(
                      " : réduction de peine des deux tiers si, après avoir averti l’autorité, il a permis de faire cesser l’infraction, "
                      "d’éviter mort/infirmité permanente, ou d’identifier d’autres auteurs/complices. "
                      "Si perpétuité encourue, elle est ramenée à 20 ans.",
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
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
