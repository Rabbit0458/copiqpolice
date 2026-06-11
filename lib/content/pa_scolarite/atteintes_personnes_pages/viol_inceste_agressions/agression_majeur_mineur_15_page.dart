import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAgressionMajeurMineur15Page extends StatelessWidget {
  const PaAgressionMajeurMineur15Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/agression_majeur_mineur_15';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    // Palette cohérente avec tes pages
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
          "Agression sexuelle (majeur / mineur de 15 ans)",
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
              // ✅ EXIGENCE : article légal tout en haut
              _ConditionCard(
                title: "Article de référence (élément légal)",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-29-2 du Code pénal"),
                    normal(
                      " : définit et réprime l’agression sexuelle commise par un majeur sur un mineur de 15 ans.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("Conditions alternatives"),
                  const _BulletPoint(
                    text:
                        "Différence d’âge d’au moins 5 ans entre le majeur et le mineur.",
                  ),
                  const _BulletPoint(
                    text:
                        "Ou, si l’écart d’âge est inférieur à 5 ans : faits commis en échange d’une rémunération (ou promesse), d’un avantage en nature (ou promesse).",
                  ),
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
                    "Hors le cas de l’agression imposée par violence, contrainte, menace ou surprise, "
                    "toute atteinte sexuelle autre qu’un viol commise par un majeur sur un mineur de 15 ans, "
                    "lorsque la différence d’âge est d’au moins 5 ans, constitue une agression sexuelle.",
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    "La condition de différence d’âge n’est pas exigée si les faits sont commis en échange d’une rémunération "
                    "(ou promesse), d’un avantage en nature (ou promesse).",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "Infraction autonome : pas besoin de violence/menace/surprise pour la caractériser.",
                  ),
                  _IntroBullet(
                    text:
                        "Le consentement d’un mineur de 15 ans n’est pas juridiquement recevable face à un majeur.",
                  ),
                  _IntroBullet(
                    text:
                        "Le critère des 5 ans (« Roméo et Juliette ») protège les relations de proximité d’âge, sauf contrepartie.",
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
                    lawRef("Article 222-29-2 du C.P."),
                    normal(" : prévoit deux voies de caractérisation :"),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Écart d’âge ≥ 5 ans entre l’auteur majeur et la victime mineure de 15 ans.",
                  ),
                  const _BulletPoint(
                    text:
                        "Ou écart d’âge < 5 ans si les faits sont commis avec contrepartie (rémunération / promesse / avantage en nature / promesse).",
                  ),
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
                    "L’atteinte sexuelle suppose un contact physique entre l’agresseur et sa victime. "
                    "Elle correspond à tout acte impudique autre qu’une pénétration ou un acte bucco-génital, "
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
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Exemples fréquents : attouchements/caresses (sexe, fesses, cuisses, poitrine) parfois accompagnés de baisers "
                        "(C.A. Paris, 19 juin 1985). "
                        "Le fait de caresser le dos de la victime en passant la main sous son pull-over (C.A. Agen, 27 octobre 1997).",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("2) Un auteur majeur"),
                  const _Paragraph(
                    "Le texte vise exclusivement un auteur majeur : les actes accomplis entre mineurs sont exclus de ce champ d’incrimination.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("3) Une victime mineure de moins de 15 ans"),
                  const _SubTitle("• Victime vivante"),
                  _Paragraph.rich([
                    normal(
                      "Il ne peut y avoir agression sexuelle sur un cadavre. Un comportement envers un cadavre relève notamment de ",
                    ),
                    lawRef("l’article 225-17 du C.P."),
                    normal(" (atteinte à l’intégrité du cadavre)."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle(
                    "• Âge : moins de 15 ans au moment des faits",
                  ),
                  _Paragraph.rich([
                    normal("C’est l’âge au moment des faits qui compte ("),
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
                    "Le texte n’exige pas que la minorité soit apparente ou connue : le mineur de 15 ans bénéficie d’une protection particulière.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "La question du consentement ne se pose pas : un mineur de 15 ans n’est pas juridiquement apte à consentir "
                    "à un acte sexuel avec un majeur. Il n’est donc pas nécessaire de prouver violence, contrainte, menace ou surprise.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    "4) Différence d’âge ≥ 5 ans… sauf contrepartie",
                  ),
                  const _SubTitle("• Clause « Roméo et Juliette »"),
                  const _Paragraph(
                    "Pour éviter d’incriminer une relation entre un jeune majeur et un mineur de 15 ans, l’infraction n’est constituée "
                    "que si l’écart d’âge est égal ou supérieur à 5 ans.",
                  ),
                  const SizedBox(height: 10),
                  const _SubTitle("• Exception : rémunération / avantage"),
                  const _Paragraph(
                    "Si l’écart d’âge est inférieur à 5 ans, l’incrimination peut tout de même s’appliquer si les faits sont commis "
                    "en échange d’une somme d’argent, d’un cadeau, d’un avantage (ou promesse) : cela vise notamment des relations prostitutionnelles.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        "Si l’écart d’âge est inférieur à 5 ans et qu’il n’y a aucune contrepartie, les faits peuvent relever de l’",
                      ),
                      lawRef("article 227-25 du C.P."),
                      normal(
                        " (atteinte sexuelle par un majeur sur un mineur de 15 ans).",
                      ),
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
                children: [
                  const _SubTitle(
                    "1) Conscience de commettre un acte immoral ou obscène",
                  ),
                  const _Paragraph(
                    "Comme pour tout crime ou délit, l’agression sexuelle exige une intention coupable : "
                    "l’auteur a conscience de commettre un acte immoral ou obscène. "
                    "Le mobile importe peu (vengeance, haine, lubricité, etc.).",
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle(
                    "2) Connaissance de l’âge inférieur à 15 ans",
                  ),
                  _Paragraph.rich([
                    normal(
                      "En principe, l’erreur sur l’âge n’atténue pas la responsabilité. "
                      "Toutefois, l’infraction peut ne pas être retenue s’il est établi que l’auteur ignorait l’âge réel, "
                      "notamment si la victime avait un comportement et un développement physique d’adulte (",
                    ),
                    normal("Cass. crim., 4 janvier 1902"),
                    normal("). "),
                    normal(
                      "Il appartient à l’auteur de justifier qu’il a été trompé sur l’âge (",
                    ),
                    normal("Cass. crim., 7 février 1957"),
                    normal(")."),
                  ]),
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
                    normal("Qualification : agression sexuelle — délit ("),
                    lawRef("article 222-29-2 du C.P."),
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
