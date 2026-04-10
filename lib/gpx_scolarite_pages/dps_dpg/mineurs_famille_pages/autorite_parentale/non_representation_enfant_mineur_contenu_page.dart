import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NonRepresentationEnfantMineurPage extends StatelessWidget {
  const NonRepresentationEnfantMineurPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/autorite_parentale/non_representation_enfant_mineur';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
          "Autorité parentale",
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
            "La non-représentation d’enfant mineur",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait de refuser indûment de représenter un enfant mineur à la personne qui a le droit de le réclamer constitue une infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal (en haut)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime la non-représentation d’enfant mineur.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le délit consiste à refuser indûment de représenter un enfant mineur à une personne qui a le droit de le réclamer. "
                "Les faits s’inscrivent fréquemment dans un contexte de conflit parental à la suite d’une séparation.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Est mineure toute personne âgée de moins de 18 ans — ",
                ),
                TextSpan(
                  text: "article 388 du code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 14),

              const _SubTitle("A) Le droit de réclamer le mineur"),
              const _Paragraph(
                "Le droit de réclamer l’enfant provient le plus souvent d’une décision judiciaire : "
                "décision de justice, convention homologuée, ou convention de divorce.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La jurisprudence exige que la décision soit exécutoire et qu’elle ait été portée, dans les formes légales, à la connaissance de celui qui refuse de représenter l’enfant.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "Ce droit est aussi reconnu à toute personne investie de l’autorité parentale (père, mère, tuteur). "
                "En l’absence de décision délimitant les droits de chacun, le délit ne peut pas être constitué lorsque le conflit oppose deux personnes ayant des droits égaux sur le mineur (ex. parents séparés de fait).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Le refus de représenter le mineur"),
              const _Paragraph(
                "Le refus peut être commis :\n"
                "• par le parent qui a la garde, en empêchant l’autre d’exercer son droit de visite ;\n"
                "• ou par le parent bénéficiaire d’un hébergement, en ne remettant pas l’enfant à l’issue de la période autorisée.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Comportement actif (direct ou indirect)"),
              const _BulletPoint(
                text:
                    "Refus pur et simple de remettre l’enfant, dissimulation du mineur, absence du domicile lors de la présentation, etc.",
              ),
              const _BulletPoint(
                text:
                    "Comportement actif indirect : manipulation du mineur pour l’inciter à refuser la visite ou l’hébergement.",
              ),

              const SizedBox(height: 10),

              const _SubTitle("2) Comportement passif"),
              const _Paragraph(
                "Le refus peut aussi résulter d’une abstention : par exemple, lorsque le parent titulaire de la garde n’intervient pas alors que l’enfant refuse spontanément de se soumettre au droit de visite/hébergement.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La résistance du mineur ne constitue ni une excuse légale, ni un fait justificatif : le parent doit agir pour permettre l’exécution du droit.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "Conscience de faire échec aux droits de celui qui réclame l’enfant",
              ),
              const _Paragraph(
                "La non-représentation d’enfant est une infraction intentionnelle. "
                "Le terme « refus » implique une attitude consciente et volontaire, et l’adverbe « indûment » souligne la mauvaise foi.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’auteur doit agir en pleine connaissance de cause des droits qu’il empêche de s’exercer. "
                "Une décision préalable doit donc, en principe, lui avoir été signifiée ou portée à sa connaissance.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Élément intentionnel caractérisé par le refus délibéré de remettre l’enfant à la personne qui a le droit de le réclamer, quel que soit le mobile, en l’absence de tout danger actuel ou imminent — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 08 septembre 1999",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le mobile importe peu. La justification peut être admise si un danger actuel et imminent est démontré (faits justificatifs).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Si l’enfant mineur est retenu au-delà de cinq jours sans que ceux qui ont droit de le réclamer sachent où il se trouve.",
              ),
              const _BulletPoint(
                text:
                    "Si l’enfant mineur est retenu indûment hors du territoire de la République.",
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 227-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : si l’auteur a été déchu de l’autorité parentale ou fait l’objet d’une décision de retrait de l’exercice de cette autorité.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Qualification simple — "),
                TextSpan(
                  text: "article 227-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "1 an d’emprisonnement."),
              const _BulletPoint(text: "15 000 € d’amende."),

              const SizedBox(height: 12),

              const _SubTitle("Peines en cas d’aggravation"),
              _Paragraph.rich([
                const TextSpan(text: "Si une circonstance prévue par "),
                TextSpan(
                  text: "l’article 227-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ou "),
                TextSpan(
                  text: "l’article 227-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " est caractérisée :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "3 ans d’emprisonnement."),
              const _BulletPoint(text: "45 000 € d’amende."),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale possible via "),
                TextSpan(
                  text: "l’article 121-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (applicable depuis le 31 décembre 2005).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (aide et assistance, provocation, instructions).",
                ),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Complicité retenue du grand-père ayant encouragé son fils à ne pas rendre l’enfant et s’étant opposé à l’intervention d’un huissier, allant jusqu’à financer un départ à l’étranger — ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 19 février 1963",
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
