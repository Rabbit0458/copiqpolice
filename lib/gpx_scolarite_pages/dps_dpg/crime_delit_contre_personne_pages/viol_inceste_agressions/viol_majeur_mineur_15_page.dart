import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViolMajeurMineur15Page extends StatelessWidget {
  const ViolMajeurMineur15Page({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/viol_majeur_mineur_15';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

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
          "Viol (majeur / mineur de 15 ans)",
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
                    lawRef("Article 222-23-1 du Code pénal"),
                    normal(
                      " : définit le viol commis par un majeur sur un mineur de 15 ans.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Répression spécifique : "),
                    lawRef("article 222-23-3 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("Conditions alternatives"),
                  const _BulletPoint(
                    text:
                        "Différence d’âge ≥ 5 ans entre le majeur et le mineur.",
                  ),
                  const _BulletPoint(
                    text:
                        "Ou, si l’écart d’âge est < 5 ans : faits commis en échange d’une rémunération (ou promesse) ou d’un avantage en nature (ou promesse).",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Hors champ",
                    bodySpans: [
                      normal(
                        "Hors le cas du viol par violence, contrainte, menace ou surprise prévu par ",
                      ),
                      lawRef("l’article 222-23 du C.P."),
                      normal("."),
                    ],
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
                    "Hors le cas du viol par violence, contrainte, menace ou surprise, tout acte de pénétration sexuelle, de quelque nature qu’il soit, "
                    "ou tout acte bucco-génital commis par un majeur sur un mineur de 15 ans (ou commis sur l’auteur par le mineur), "
                    "lorsque la différence d’âge est d’au moins 5 ans, constitue un viol.",
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    "La condition de différence d’âge ne s’applique pas si les faits sont commis en échange d’une rémunération (ou promesse) "
                    "ou d’un avantage en nature (ou promesse).",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "Infraction autonome : pas besoin de violence/menace/surprise pour la caractériser.",
                  ),
                  _IntroBullet(
                    text:
                        "Acte visé = pénétration sexuelle OU acte bucco-génital.",
                  ),
                  _IntroBullet(
                    text:
                        "Clause « Roméo et Juliette » : seuil des 5 ans, sauf contrepartie.",
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
                    lawRef("Article 222-23-1 du C.P."),
                    normal(
                      " : définit le viol commis par un majeur sur un mineur de 15 ans.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Réprimé par "),
                    lawRef("l’article 222-23-3 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("Conditions de qualification"),
                  const _BulletPoint(text: "Écart d’âge ≥ 5 ans."),
                  const _BulletPoint(
                    text:
                        "Ou écart d’âge < 5 ans si contrepartie (rémunération / promesse / avantage en nature / promesse).",
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
                  const _SubTitle("1) Un acte de pénétration sexuelle"),
                  _Paragraph.rich([
                    lawRef("Article 222-23-1 du C.P."),
                    normal(
                      " vise « tout acte de pénétration sexuelle, de quelque nature qu’il soit ».",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Relève de l’incrimination tout acte de pénétration dans le sexe ou par le sexe. "
                    "La nature de l’acte importe peu : rapports dits « normaux », sodomie, introduction d’un doigt ou de corps étrangers "
                    "dans le sexe ou l’anus de la victime.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Sodomie : "),
                      normal("Cass. crim., 3 juillet 1991"),
                      normal(". "),
                      normal("Doigt dans le vagin contre le gré : "),
                      normal("Cass. crim., 8 janvier 1991"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("2) Ou un acte bucco-génital"),
                  const _Paragraph(
                    "Le texte vise aussi « tout acte bucco-génital ». Un contact suffit : "
                    "cela inclut fellation et cunnilingus.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Fellation constitutive de viol en cas de pénétration de la verge dans la bouche : ",
                      ),
                      normal("Cass. crim., 22 février 1984"),
                      normal(". "),
                      normal("Fellations réciproques : "),
                      normal("Cass. crim., 28 novembre 2001"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("3) Commise sur la victime ou sur l’auteur"),
                  const _Paragraph(
                    "Le viol est caractérisé aussi bien lorsque l’auteur commet l’acte sur la victime, "
                    "que lorsque l’acte est réalisé sur la personne de l’auteur (par la victime).",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Viol retenu pour l’introduction avec violence (par une femme) d’un manche de pioche recouvert d’un préservatif "
                        "dans l’anus d’un homme : ",
                      ),
                      normal("Cass. crim., 6 décembre 1995"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("4) Auteur majeur"),
                  const _Paragraph(
                    "L’infraction n’est imputable qu’à un majeur : les actes accomplis entre mineurs sont exclus.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("5) Victime mineure de moins de 15 ans"),
                  const _SubTitle("• Victime vivante"),
                  _Paragraph.rich([
                    normal(
                      "Il ne peut y avoir viol sur un cadavre. L’atteinte au cadavre relève de ",
                    ),
                    lawRef("l’article 225-17 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("• Âge à retenir"),
                  _Paragraph.rich([
                    normal("Âge au moment des faits ("),
                    normal("Cass. crim., 21 mars 1957"),
                    normal("). Calcul d’heure à heure ("),
                    normal("Cass. crim., 3 septembre 1985"),
                    normal(")."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      "Preuve de l’âge par tout moyen à défaut d’acte probant (",
                    ),
                    normal("Cass. crim., 17 juillet 1991"),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Le texte n’exige pas que la minorité de 15 ans soit apparente ou connue : protection particulière.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "La question du consentement ne se pose pas : un mineur de 15 ans n’est pas apte à consentir à un acte sexuel avec un majeur. "
                    "Il n’est donc pas nécessaire de démontrer violence, contrainte, menace ou surprise.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    "6) Différence d’âge ≥ 5 ans… sauf contrepartie",
                  ),
                  const _SubTitle("• Clause « Roméo et Juliette »"),
                  const _Paragraph(
                    "Pour ne pas incriminer une relation amoureuse de proximité d’âge, l’infraction n’est constituée que si l’écart d’âge "
                    "entre le majeur et le mineur est égal ou supérieur à 5 ans.",
                  ),
                  const SizedBox(height: 10),
                  const _SubTitle("• Exception : rémunération / avantage"),
                  const _Paragraph(
                    "Si l’écart d’âge est inférieur à 5 ans, le viol peut tout de même être retenu si les faits sont commis en échange "
                    "d’une somme d’argent, d’un cadeau, d’un avantage (ou promesse). Cela vise notamment des relations prostitutionnelles.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        "Si l’écart d’âge est < 5 ans et qu’il n’y a aucune contrepartie, les faits peuvent relever de ",
                      ),
                      lawRef("l’article 227-25 du C.P."),
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
                  const _SubTitle("1) Volonté de commettre l’acte sexuel"),
                  const _Paragraph(
                    "L’intention se traduit par la volonté de commettre un acte de pénétration sexuelle ou un acte bucco-génital.",
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle(
                    "2) Connaissance de l’âge inférieur à 15 ans",
                  ),
                  _Paragraph.rich([
                    normal(
                      "L’erreur sur l’âge n’atténue pas la responsabilité. Toutefois, l’infraction peut ne pas être retenue s’il est acquis "
                      "que l’auteur ignorait l’âge réel, notamment si la victime avait un comportement et un développement physique d’adulte (",
                    ),
                    normal("Cass. crim., 4 janvier 1902"),
                    normal("). "),
                    normal("L’auteur doit justifier qu’il a été trompé ("),
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
                children: [
                  const _SubTitle("Premier degré d’aggravation"),
                  _Paragraph.rich([
                    lawRef("Article 222-25 du C.P."),
                    normal(
                      " : lorsque le viol a entraîné la mort de la victime.",
                    ),
                  ]),
                  const SizedBox(height: 12),
                  const _SubTitle("Deuxième degré d’aggravation"),
                  _Paragraph.rich([
                    lawRef("Article 222-26 du C.P."),
                    normal(
                      " : lorsqu’il est précédé, accompagné ou suivi de tortures ou d’actes de barbarie.",
                    ),
                  ]),
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
                    normal("Viol (majeur / mineur 15 ans) réprimé par "),
                    lawRef("l’article 222-23-3 du C.P."),
                    normal(" : "),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text: "Forme « simple » : 20 ans de réclusion criminelle.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Aggravé 1er degré : "),
                    lawRef("article 222-25 du C.P."),
                    normal(
                      " → 30 ans de réclusion criminelle + période de sûreté.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Aggravé 2e degré : "),
                    lawRef("article 222-26 du C.P."),
                    normal(
                      " → réclusion criminelle à perpétuité + période de sûreté.",
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _Paragraph.rich([
                    normal("Personnes morales : "),
                    lawRef("article 222-33-1 du C.P."),
                    normal(" (amende + peines complémentaires prévues à "),
                    lawRef("l’article 131-39 du C.P."),
                    normal(")."),
                  ]),
                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  const _BulletPoint(
                    text:
                        "Tentative : OUI (punissable comme toute tentative de crime).",
                  ),

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
