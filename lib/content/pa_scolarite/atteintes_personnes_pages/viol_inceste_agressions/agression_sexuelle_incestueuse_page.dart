import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAgressionSexuelleIncestueusePage extends StatelessWidget {
  const PaAgressionSexuelleIncestueusePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/agression_sexuelle_incestueuse';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

    // ✅ Articles en rouge
    TextSpan lawRef(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
    );
    TextSpan normal(String s) => TextSpan(text: s);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: Text(
          "Agression sexuelle incestueuse",
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
              // ✅ EXIGENCE : article légal en premier (et la référence 222-22-3 juste après)
              _ConditionCard(
                title: "Article de référence (élément légal)",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-29-3 du Code pénal"),
                    normal(
                      " : définit et réprime l’agression sexuelle incestueuse.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    lawRef("Article 222-22-3 du Code pénal"),
                    normal(
                      " : détermine la liste des personnes pouvant être auteurs d’agressions sexuelles incestueuses (lien de parenté + autorité).",
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
                children: [
                  const _Paragraph(
                    "Hors le cas prévu pour l’agression imposée à un mineur de 15 ans par violence, contrainte, menace ou surprise, "
                    "toute atteinte sexuelle autre qu’un viol commise par un majeur sur la personne d’un mineur, "
                    "lorsque le majeur est un ascendant ou une personne mentionnée par la loi et qu’il exerce sur le mineur "
                    "une autorité de droit ou de fait, constitue une agression sexuelle incestueuse.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Exception rappelée : hors le cas visé par "),
                    lawRef("l’article 222-29-1 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("À retenir"),
                  const _IntroBullet(
                    text:
                        "Acte sexuel sans pénétration ni acte bucco-génital (sinon on bascule vers le viol).",
                  ),
                  const _IntroBullet(
                    text:
                        "Auteur majeur + victime mineure + lien de parenté listé par la loi + autorité de droit ou de fait.",
                  ),
                  const _IntroBullet(
                    text:
                        "Le consentement du mineur ne se discute pas : pas besoin de violence/menace/surprise si les conditions incestueuses sont réunies.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // I — Élément légal
              _ConditionCard(
                title: "I — Élément légal",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-29-3 du C.P."),
                    normal(" : incrimine l’agression sexuelle incestueuse."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("La liste des auteurs possibles est fixée par "),
                    lawRef("l’article 222-22-3 du C.P."),
                    normal("."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // II — Élément matériel
              _ConditionCard(
                title: "II — Élément matériel",
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle(
                    "1) Un acte de nature sexuelle (autre qu’un viol)",
                  ),
                  const _Paragraph(
                    "L’atteinte sexuelle suppose un contact physique entre l’agresseur et la victime. "
                    "Elle se définit comme tout acte impudique autre qu’une pénétration ou un acte bucco-génital, "
                    "directement exercé sur une personne.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      "Si l’auteur se livre à un acte immoral ou obscène sur lui-même en présence de témoins, il peut s’agir d’",
                    ),
                    lawRef("exhibition sexuelle (art. 222-32 C.P.)"),
                    normal(" ou d’"),
                    lawRef(
                      "incitation à la corruption de mineur (art. 227-22 C.P.)",
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "L’atteinte sexuelle peut être commise par l’auteur sur la victime, ou correspondre à un acte effectué par la victime "
                    "sur l’auteur (victime contrainte).",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Exemples fréquents : attouchements/caresses (sexe, fesses, cuisses, poitrine), éventuellement accompagnés de baisers "
                        "(C.A. Paris, 19 juin 1985). "
                        "Caresser le dos de la victime en passant la main sous son pull-over (C.A. Agen, 27 octobre 1997).",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("2) Un auteur majeur"),
                  const _Paragraph(
                    "Le texte vise exclusivement un auteur majeur : les actes accomplis entre mineurs sont exclus de ce champ d’incrimination.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("3) Une victime mineure"),
                  const _SubTitle("• Victime vivante"),
                  _Paragraph.rich([
                    normal(
                      "Il ne peut y avoir agression sexuelle sur un cadavre. Cela relève d’une infraction autonome : ",
                    ),
                    lawRef("article 225-17 du C.P."),
                    normal(" (atteinte à l’intégrité du cadavre)."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("• Mineur de moins de 18 ans"),
                  _Paragraph.rich([
                    normal("L’âge à retenir est celui au moment des faits ("),
                    normal("Cass. crim., 21 mars 1957"),
                    normal("). L’âge se calcule d’heure à heure ("),
                    normal("Cass. crim., 3 septembre 1985"),
                    normal(")."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      "À défaut d’acte probant, la preuve de l’âge peut se faire par tout moyen (",
                    ),
                    normal("Cass. crim., 17 juillet 1991"),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Le texte n’exige pas que la minorité soit apparente ou connue : le mineur bénéficie d’une protection particulière.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "La question du consentement ne se pose pas : un mineur n’est pas apte à consentir à un acte sexuel avec un majeur "
                    "lorsqu’il existe certains liens de parenté et un rapport d’autorité. "
                    "Il n’est donc pas nécessaire de prouver violence, contrainte, menace ou surprise.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        "Si la victime est majeure, l’incrimination d’agression sexuelle de ",
                      ),
                      lawRef("l’article 222-27 du C.P."),
                      normal(
                        " peut être retenue en cas de violence, contrainte, menace ou surprise. "
                        "La « surqualification » incestueuse (",
                      ),
                      lawRef("art. 222-22-3 C.P."),
                      normal(") pourra alors s’appliquer."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    "4) Lien de parenté direct ou indirect (liste exhaustive)",
                  ),
                  _Paragraph.rich([
                    normal("La liste des liens de parenté est fixée par "),
                    lawRef("l’article 222-22-3 du C.P."),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Ascendants : père, mère, aïeuls (légitimes, naturels ou adoptifs).",
                  ),
                  const _BulletPoint(
                    text:
                        "Frères et sœurs ; oncles et tantes ; grands-oncles et grands-tantes ; neveux et nièces.",
                  ),
                  const _BulletPoint(
                    text:
                        "Conjoints et concubins de ces personnes, ou partenaires liés par un PACS.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    "5) Autorité de droit ou de fait sur la victime",
                  ),
                  const _Paragraph(
                    "Le seul lien de parenté ne suffit pas : il faut démontrer l’existence d’une autorité sur le mineur. "
                    "Elle peut être de droit (ex. parents) ou de fait (permanente ou discontinue), établie par des circonstances particulières.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Le partenaire lié à la tante de la victime par un PACS ne peut être qualifié d’auteur d’une agression incestueuse "
                        "si l’existence d’une autorité de droit ou de fait sur la victime n’est pas rapportée (",
                      ),
                      normal("Cass. crim., 15 mars 2023, n° 21-87.389"),
                      normal(")."),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // III — Élément moral
              _ConditionCard(
                title: "III — Élément moral",
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: const [
                  _SubTitle(
                    "Conscience de commettre un acte immoral ou obscène",
                  ),
                  _Paragraph(
                    "Comme pour tout crime ou délit, l’agression sexuelle incestueuse exige une intention coupable. "
                    "L’auteur sait qu’il commet un acte immoral ou obscène. "
                    "Cette intention est presque toujours indissociable de l’acte matériel. "
                    "Le mobile importe peu (vengeance, haine, lubricité, etc.).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // IV — Circonstances aggravantes
              _ConditionCard(
                title: "IV — Circonstances aggravantes",
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    "Aucune circonstance aggravante spécifique prévue par cette fiche.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // V — Répression / tentative / complicité
              _ConditionCard(
                title: "V — Répression, tentative et complicité",
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle("Peines encourues (personnes physiques)"),
                  _Paragraph.rich([
                    normal(
                      "Qualification : agression sexuelle incestueuse — délit (",
                    ),
                    lawRef("article 222-29-3 du C.P."),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  const _BulletPoint(
                    text: "Peine principale : 10 ans d’emprisonnement.",
                  ),
                  const _BulletPoint(text: "Amende : 150 000 €."),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    normal("Responsabilité pénale des personnes morales : "),
                    lawRef("article 222-33-1 du C.P."),
                    normal(" (amende + peines complémentaires prévues à "),
                    lawRef("l’article 131-39 du C.P."),
                    normal(")."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _Paragraph.rich([
                    normal("Tentative : OUI — prévue par "),
                    lawRef("l’article 222-31 du C.P."),
                    normal(
                      ". En pratique, la distinction est délicate : le commencement d’exécution correspond souvent à une agression déjà consommée.",
                    ),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal("Complicité : OUI — punissable conformément aux "),
                    lawRef("articles 121-6 et 121-7 du C.P."),
                    normal(
                      ". Elle suppose un fait de complicité prévu par la loi : aide/assistance, provocation ou instructions données.",
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
