import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonneVulnerablePage extends StatelessWidget {
  const PersonneVulnerablePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/personne_vulnerable';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Agressions sexuelles sur personne vulnérable",
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
                    lawRef("Article 222-29 du Code pénal"),
                    normal(
                      " : prévoit et réprime les agressions sexuelles autres que le viol lorsqu’elles sont imposées à une personne vulnérable.",
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
                    "Les agressions sexuelles autres que le viol imposées à une personne dont la particulière vulnérabilité "
                    "(âge, maladie, infirmité, déficience physique ou psychique, grossesse) ou résultant de la précarité "
                    "économique ou sociale, lorsque cette vulnérabilité est apparente ou connue de l’auteur, constituent une infraction.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "Acte sexuel sans pénétration et sans acte bucco-génital (sinon : viol).",
                  ),
                  _IntroBullet(
                    text:
                        "Victime : vulnérabilité particulière préexistante, apparente ou connue.",
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
                    lawRef("Article 222-29 du C.P."),
                    normal(
                      " : réprime les agressions sexuelles autres que le viol imposées à une personne vulnérable.",
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
                    "L’agression sexuelle suppose un contact physique entre l’agresseur et sa victime. "
                    "Elle se définit comme tout acte impudique, autre qu’une pénétration ou qu’un acte bucco-génital, "
                    "directement exercé sur une personne.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Elle peut être le fait de l’auteur sur la victime, mais aussi celui effectué par la victime contrainte sur l’auteur.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Le plus grand nombre est constitué d’attouchements ou de caresses (sexe, fesses, cuisses, poitrine), "
                    "éventuellement accompagnés de baisers sur le corps ou sur la bouche.",
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

                  const _SubTitle("3) Acte commis sur la personne d’autrui"),
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

                  const _SubTitle(
                    "4) Victime particulièrement vulnérable (condition spécifique)",
                  ),
                  _Paragraph.rich([
                    normal("Au sens de "),
                    lawRef("l’article 222-29 du C.P."),
                    normal(
                      ", sont visées les victimes hors d’état de se protéger en raison d’un état de faiblesse. "
                      "Les causes de vulnérabilité doivent préexister aux faits (et ne pas être la conséquence des faits).",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("La vulnérabilité doit préexister aux faits : "),
                      normal("Cass. crim., 17 octobre 1984"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "La vulnérabilité doit être apparente ou connue : l’auteur agit en raison de cette vulnérabilité.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle(
                    "5) Les causes de vulnérabilité (pédagogique)",
                  ),
                  const _BulletPoint(
                    text:
                        "Âge : ne suffit pas à lui seul → il faut démontrer une vulnérabilité particulière.",
                  ),
                  const SizedBox(height: 6),
                  _NotaBox(
                    title: "Jurisprudence (âge)",
                    bodySpans: [
                      normal("Seul âge insuffisant : "),
                      normal("TGI Montpellier, 7 décembre 2000"),
                      normal(". "),
                      normal("Nécessité d’une vulnérabilité particulière : "),
                      normal("Cass. crim., 30 avril 1996"),
                      normal(". "),
                      normal(
                        "Âge seul ne suffit pas sans autres constatations : ",
                      ),
                      normal("Cass. crim., 23 juin 1999"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _BulletPoint(
                    text:
                        "Maladie / infirmité / déficience physique ou psychique : dysfonctionnements physiques ou mentaux (innés ou acquis).",
                  ),
                  const _BulletPoint(
                    text:
                        "Grossesse : peut entraîner une vulnérabilité pendant la grossesse et parfois après l’accouchement.",
                  ),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Précarité économique ou sociale : situation de dépendance, exposition à l’exploitation de la misère.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence (précarité)",
                    bodySpans: [
                      normal(
                        "Salariés en vulnérabilité sociale et économique : ",
                      ),
                      normal("Cass. crim., 4 mars 2003"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      TextSpan(
                        text:
                            "Des incriminations spécifiques visent les agressions sexuelles commises sur des mineurs de 15 ans "
                            "(voir fiche : agressions sexuelles imposées à un mineur de 15 ans par violence/contrainte/menace/surprise, "
                            "et fiche : agression sexuelle commise par un majeur sur un mineur de 15 ans).",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("6) Absence de consentement : 4 moyens"),
                  const _Paragraph(
                    "Comme pour le viol, ces agressions supposent l’usage de violence, contrainte, menace ou surprise. "
                    "En l’absence de précision exhaustive du texte, la jurisprudence aide à définir le contenu.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("• La violence"),
                  const _Paragraph(
                    "Violence physique exercée sur la victime. Les pressions doivent être suffisantes pour accomplir l’acte malgré le refus. "
                    "Il doit être établi que la victime n’a pas pu résister. L’appréciation appartient aux juges.",
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
                    "Violences morales supprimant le consentement. La crainte doit être sérieuse et immédiate, "
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
                    "Surprendre le consentement (et non la surprise ressentie). Elle peut accompagner la violence "
                    "(victime consciente mais ne peut s’opposer) ou résulter d’une tromperie / d’une impossibilité "
                    "de consentir pleinement (enfants, troubles mentaux, handicap, victime trompée…).",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Prétexte fallacieux de visite médicale : "),
                      normal("Cass. crim., 20 juin 2001"),
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
                children: const [
                  _SubTitle("Intention coupable"),
                  _Paragraph(
                    "L’auteur doit avoir conscience de commettre un acte immoral ou obscène contre le gré de la victime. "
                    "Cette intention est généralement inséparable de l’acte matériel. "
                    "Le mobile importe peu (vengeance, haine, lubricité, etc.).",
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
                    lawRef("Article 222-30 du C.P."),
                    normal(" : le délit est aggravé notamment lorsque :"),
                  ]),
                  const SizedBox(height: 10),
                  const _BulletPoint(
                    text: "Il a entraîné une blessure ou une lésion.",
                  ),
                  const _BulletPoint(
                    text:
                        "Il est commis par une personne abusant de l’autorité de ses fonctions.",
                  ),
                  const _BulletPoint(
                    text:
                        "Il est commis par un ascendant ou une personne ayant autorité de droit ou de fait.",
                  ),
                  const _BulletPoint(
                    text: "Il est commis avec usage ou menace d’une arme.",
                  ),
                  const _BulletPoint(
                    text: "Il est commis par plusieurs auteurs/complices.",
                  ),
                  const _BulletPoint(
                    text:
                        "Il est commis en état d’ivresse manifeste ou sous stupéfiants.",
                  ),
                  const _BulletPoint(
                    text:
                        "Une substance a été administrée à l’insu de la victime pour altérer son discernement.",
                  ),
                ],
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
                    normal("Agression sexuelle sur personne vulnérable ("),
                    lawRef("article 222-29 du C.P."),
                    normal(") : 7 ans d’emprisonnement et 100 000 € d’amende."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Forme aggravée ("),
                    lawRef("article 222-30 du C.P."),
                    normal(
                      ") : 10 ans d’emprisonnement et 150 000 € d’amende.",
                    ),
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
                      ", mais souvent difficile à distinguer car le commencement d’exécution peut déjà constituer une agression consommée.",
                    ),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal("Complicité : OUI — "),
                    lawRef("articles 121-6 et 121-7 du C.P."),
                    normal(
                      " (aide/assistance, provocation, instructions). Elle peut aussi constituer une circonstance aggravante (",
                    ),
                    lawRef("article 222-30 4° du C.P."),
                    normal(")."),
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
