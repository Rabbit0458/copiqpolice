import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaMineur15ViolencesContrainteMenaceSurprisePage extends StatelessWidget {
  const PaMineur15ViolencesContrainteMenaceSurprisePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/mineur_15_violences_contrainte_menace_surprise';

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

    // Helpers TextSpan
    TextSpan lawRef(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
    );
    TextSpan normal(String s) => TextSpan(text: s);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: Text(
          "Agressions sexuelles sur mineur de 15 ans",
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
              // ✅ EXIGENCE : l’élément légal tout en haut
              _ConditionCard(
                title: "Article de référence (élément légal)",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-22 du Code pénal"),
                    normal(
                      " : définit les agressions sexuelles commises avec violence, contrainte, menace ou surprise.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    lawRef("Article 222-29-1 du Code pénal"),
                    normal(
                      " : prévoit et réprime les agressions sexuelles autres que le viol lorsqu’elles sont imposées à un mineur de 15 ans.",
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
                    "Les agressions sexuelles autres que le viol imposées à un mineur de quinze ans "
                    "par violence, contrainte, menace ou surprise constituent des infractions.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "Acte sexuel sans pénétration et sans acte bucco-génital (sinon : viol).",
                  ),
                  _IntroBullet(
                    text:
                        "Victime : mineur de moins de 15 ans (âge au moment des faits).",
                  ),
                  _IntroBullet(
                    text:
                        "Absence de consentement : violence / contrainte / menace / surprise.",
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
                    lawRef("Article 222-22 du C.P."),
                    normal(
                      " : agressions sexuelles commises avec violence, contrainte, menace ou surprise.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    lawRef("Article 222-29-1 du C.P."),
                    normal(
                      " : répression des agressions sexuelles autres que le viol lorsqu’elles sont imposées à un mineur de 15 ans.",
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
                    "1) Un acte de nature sexuelle autre qu’une pénétration ou un acte bucco-génital",
                  ),
                  const _Paragraph(
                    "L’agression sexuelle suppose un contact physique entre l’agresseur et la victime. "
                    "Elle se définit comme tout acte impudique, autre qu’une pénétration ou qu’un acte bucco-génital, "
                    "directement exercé sur une personne.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Elle peut être le fait de l’auteur sur la victime, mais aussi celui effectué par la victime contrainte sur l’auteur.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Le plus grand nombre est constitué d’attouchements ou de caresses du sexe, des fesses, "
                    "des cuisses, de la poitrine, éventuellement accompagnés de baisers sur le corps ou sur la bouche.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Attouchements / caresses : "),
                      normal("C.A. Paris, 19 juin 1985"),
                      normal(". "),
                      normal(
                        "Main passée sous le pull-over pour caresser le dos : ",
                      ),
                      normal("C.A. Agen, 27 octobre 1997"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("2) Cas à ne pas confondre"),
                  _Paragraph.rich([
                    normal("Exhibition sexuelle : "),
                    lawRef("article 222-32 du C.P."),
                    normal(". "),
                    normal("Incitation à la corruption de mineur : "),
                    lawRef("article 227-22 du C.P."),
                    normal("."),
                  ]),

                  const SizedBox(height: 14),

                  const _SubTitle("3) Victime mineure de moins de 15 ans"),
                  const _Paragraph(
                    "Une victime vivante : il ne peut y avoir agression sexuelle sur un cadavre. "
                    "L’infraction suppose l’absence de consentement, or un mort ne peut consentir.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    lawRef("Article 225-17 du C.P."),
                    normal(
                      " : réprime l’atteinte à l’intégrité du cadavre (infraction autonome).",
                    ),
                  ]),

                  const SizedBox(height: 14),

                  const _SubTitle("4) Preuve de l’âge (< 15 ans)"),
                  const _Paragraph(
                    "C’est l’âge de la victime au moment des faits qui est retenu.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Âge au moment des faits : "),
                      normal("Cass. crim., 21 mars 1957"),
                      normal(". "),
                      normal("Âge calculé d’heure à heure : "),
                      normal("Cass. crim., 3 septembre 1985"),
                      normal(". "),
                      normal(
                        "Preuve par tout moyen à défaut d’acte probant : ",
                      ),
                      normal("Cass. crim., 17 juillet 1991"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Le texte ne précise pas que la minorité de 15 ans doit être apparente ou connue de l’auteur : "
                    "le mineur de quinze ans bénéficie d’une protection particulière.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("5) Absence de consentement : 4 moyens"),
                  const _Paragraph(
                    "Ces agressions sexuelles supposent l’usage de violence, contrainte, menace ou surprise.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("• La violence"),
                  const _Paragraph(
                    "Violence physique exercée sur la victime. Les pressions doivent être suffisantes pour accomplir "
                    "l’agression sexuelle malgré le refus. Il doit être établi que la victime n’a pas pu résister. "
                    "L’appréciation du caractère contraignant appartient aux juges.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Pincer les fesses + faire pénétrer de force dans un véhicule : ",
                      ),
                      normal("Cass. crim., 15 avril 1992"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("• La contrainte ou la menace"),
                  const _Paragraph(
                    "Visent à supprimer le consentement : violences morales assimilées à des violences physiques. "
                    "La menace/contrainte doit inspirer une crainte sérieuse et immédiate (pour la victime ou un proche), "
                    "appréciée concrètement selon la capacité de résistance.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Appréciation : "),
                    normal("Cass. crim., 8 juin 1994"),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    lawRef("Article 222-22-1 du C.P."),
                    normal(
                      " : la contrainte prévue par l’article 222-22 peut être physique ou morale.",
                    ),
                  ]),

                  const SizedBox(height: 14),

                  const _SubTitle("• La surprise"),
                  const _Paragraph(
                    "La surprise = surprendre le consentement (et non la surprise ressentie). "
                    "Elle peut accompagner une violence (victime consciente mais ne peut s’opposer) "
                    "ou consister à accomplir un acte sans consentement éclairé (victime ne se rend pas compte des actes). "
                    "Cela peut concerner des enfants dont la maturité est insuffisante pour comprendre l’acte imposé.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      "Concernant les mineurs de 15 ans, la contrainte morale ou la surprise peuvent être caractérisées par ",
                    ),
                    normal("l’abus de vulnérabilité"),
                    normal(
                      " de la victime ne disposant pas du discernement nécessaire (",
                    ),
                    lawRef("article 222-22-1 du C.P."),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  const _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      TextSpan(
                        text:
                            "Dans certains cas prévus par la loi, la violence, la contrainte, la menace ou la surprise n’ont pas à être démontrées "
                            "(voir fiches : agression sexuelle commise par un majeur sur un mineur de 15 ans ; agression sexuelle incestueuse).",
                      ),
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
                  const _SubTitle("Intention coupable"),
                  const _Paragraph(
                    "L’auteur doit avoir conscience de commettre un acte immoral ou obscène contre le gré de la victime. "
                    "Cette intention est généralement inséparable de l’acte matériel. "
                    "Le mobile importe peu (vengeance, haine, lubricité, etc.).",
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle("Connaissance de l’âge (< 15 ans)"),
                  const _Paragraph(
                    "L’erreur sur l’âge n’atténue pas la responsabilité pénale. Toutefois, dans certaines hypothèses, "
                    "l’infraction peut être écartée s’il est acquis que l’auteur ignorait l’âge réel, "
                    "notamment si la victime avait un comportement et un développement physique d’adulte.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Ignorance de l’âge réel (hypothèse) : "),
                      normal("Cass. crim., 4 janvier 1902"),
                      normal(". "),
                      normal(
                        "Il appartient à l’auteur de justifier avoir été trompé : ",
                      ),
                      normal("Cass. crim., 7 février 1957"),
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
                children: const [_Paragraph("Aucune.")],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "V — Répression, tentative et complicité",
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle("Peines encourues (personnes physiques)"),
                  _Paragraph.rich([
                    normal("Qualification : délit — "),
                    lawRef("article 222-29-1 du C.P."),
                    normal(" → 10 ans d’emprisonnement et 150 000 € d’amende."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Personnes morales"),
                  _Paragraph.rich([
                    normal("Responsabilité : "),
                    lawRef("article 222-33-1 du C.P."),
                    normal(" + peines complémentaires : "),
                    lawRef("article 131-39 du C.P."),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _Paragraph.rich([
                    normal("Tentative : OUI — spécialement prévue par "),
                    lawRef("l’article 222-31 du C.P."),
                    normal(
                      ", mais difficile à distinguer car le commencement d’exécution est souvent une agression consommée.",
                    ),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal("Complicité : OUI — "),
                    lawRef("articles 121-6 et 121-7 du C.P."),
                    normal(" (aide/assistance, provocation, instructions)."),
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
