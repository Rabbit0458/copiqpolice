import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaViolIncestueuxPage extends StatelessWidget {
  const PaViolIncestueuxPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/viol_incestueux';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    // Palette cohérente (même style que tes autres pages)
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
          "Viol incestueux",
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
              // ✅ EXIGENCE : l’élément légal doit être en haut
              _ConditionCard(
                title: "Article de référence (élément légal)",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-23-2 du Code pénal"),
                    normal(" : définit le viol incestueux."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Auteurs concernés (liste) : "),
                    lawRef("article 222-22-3 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Répression : "),
                    lawRef("article 222-23-3 du C.P."),
                    normal("."),
                  ]),
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
                    "ou tout acte bucco-génital commis par un majeur sur la personne d’un mineur (ou commis sur l’auteur par le mineur), "
                    "lorsque le majeur est un ascendant ou toute autre personne visée par la loi et exerçant une autorité de droit ou de fait sur le mineur, "
                    "constitue un viol incestueux.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "Acte visé : pénétration sexuelle OU acte bucco-génital.",
                  ),
                  _IntroBullet(text: "Victime : mineur (moins de 18 ans)."),
                  _IntroBullet(
                    text:
                        "Auteur : majeur + lien de parenté visé + autorité de droit ou de fait.",
                  ),
                  _IntroBullet(
                    text:
                        "Pas besoin de violence/menace/surprise pour qualifier l’infraction autonome.",
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
                    lawRef("Article 222-23-2 du C.P."),
                    normal(" : définition du viol incestueux."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Liste des auteurs possibles : "),
                    lawRef("article 222-22-3 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Réprimé par : "),
                    lawRef("article 222-23-3 du C.P."),
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
                  const _SubTitle("1) Un acte de pénétration sexuelle"),
                  _Paragraph.rich([
                    lawRef("Article 222-23-2 du C.P."),
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
                      normal("Doigt introduit contre son gré dans le vagin : "),
                      normal("Cass. crim., 8 janvier 1991"),
                      normal(". "),
                      normal(
                        "Manche de pioche introduit dans l’anus d’un homme : ",
                      ),
                      normal("Cass. crim., 6 décembre 1995"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("4) Auteur majeur"),
                  const _Paragraph(
                    "L’infraction n’est imputable qu’à un majeur : les actes entre mineurs sont exclus.",
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("5) Victime mineure"),
                  const _SubTitle("• Victime vivante"),
                  _Paragraph.rich([
                    normal(
                      "Il ne peut y avoir viol sur un cadavre. L’atteinte au cadavre relève de ",
                    ),
                    lawRef("l’article 225-17 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("• Âge retenu"),
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
                    "Le texte n’exige pas que la minorité soit apparente ou connue : protection particulière.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "La question du consentement ne se pose pas : un mineur n’est pas apte à consentir à un acte sexuel avec un majeur "
                    "lorsqu’existent certains liens de parenté et un rapport d’autorité. Il n’est donc pas nécessaire de démontrer violence, "
                    "contrainte, menace ou surprise.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        "Si la victime est majeure, l’incrimination de viol de ",
                      ),
                      lawRef("l’article 222-23 du C.P."),
                      normal(
                        " peut être retenue si violence/contrainte/menace/surprise ; la surqualification « incestueux » liée à ",
                      ),
                      lawRef("l’article 222-22-3 du C.P."),
                      normal(
                        " pourra alors s’appliquer (sans véritable conséquence juridique).",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle(
                    "6) Lien de parenté + autorité (conditions cumulatives)",
                  ),
                  const _SubTitle("• Lien de parenté (liste exhaustive)"),
                  _Paragraph.rich([
                    lawRef("Article 222-22-3 du C.P."),
                    normal(
                      " : ascendants (père, mère, aïeuls légitimes/naturels/adoptifs), frères, sœurs, oncles, tantes, grand-oncles, grand-tantes, "
                      "neveux, nièces, ainsi que les conjoints/concubins/partenaires PACS de ces personnes.",
                    ),
                  ]),
                  const SizedBox(height: 12),
                  const _SubTitle(
                    "• Autorité de droit ou de fait sur la victime",
                  ),
                  const _Paragraph(
                    "Le seul lien de parenté ne suffit pas : il faut démontrer un rapport d’autorité "
                    "de droit (parents) ou de fait (permanente ou discontinue, établie par des circonstances particulières).",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Une agression sexuelle commise par le partenaire PACS de la tante ne peut être qualifiée d’incestueuse "
                        "si l’autorité de droit ou de fait n’est pas rapportée (",
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
                  _SubTitle("Intention"),
                  _Paragraph(
                    "L’élément moral réside dans la volonté de commettre un acte de pénétration sexuelle ou un acte bucco-génital.",
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
                    normal("Répression du viol incestueux : "),
                    lawRef("article 222-23-3 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
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
