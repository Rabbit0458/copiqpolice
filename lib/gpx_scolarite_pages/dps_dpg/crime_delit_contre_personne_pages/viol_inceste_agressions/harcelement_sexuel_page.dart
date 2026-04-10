import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HarcelementSexuelPage extends StatelessWidget {
  const HarcelementSexuelPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/harcelement_sexuel';

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
          "Harcèlement sexuel",
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
                    normal("Le harcèlement sexuel est défini par "),
                    lawRef("l’article 222-33 du Code pénal"),
                    normal(" (I et II)."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("Double définition (à connaître)"),
                  const _BulletPoint(
                    text:
                        "Harcèlement « répété » : propos ou comportements imposés de façon répétée.",
                  ),
                  const _BulletPoint(
                    text:
                        "Acte unique « assimilé » : pression grave pour obtenir un acte de nature sexuelle.",
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
                    "Le fait d’imposer à une personne, de façon répétée, des propos ou comportements à connotation sexuelle ou sexiste "
                    "qui portent atteinte à sa dignité (caractère dégradant/humiliant) ou créent une situation intimidante, hostile ou "
                    "offensante caractérise le harcèlement sexuel.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("Également constitué lorsque…"),
                  _IntroBullet(
                    text:
                        "Plusieurs personnes imposent à la même victime des propos/comportements de manière concertée ou à l’instigation de l’une d’elles, même si chacune n’a pas agi de façon répétée.",
                  ),
                  _IntroBullet(
                    text:
                        "Plusieurs personnes imposent successivement à la même victime des propos/comportements en sachant que cela caractérise une répétition (même sans concertation).",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("Assimilé (acte unique)"),
                  _IntroBullet(
                    text:
                        "Toute pression grave, même non répétée, dans le but réel ou apparent d’obtenir un acte de nature sexuelle (au profit de l’auteur ou d’un tiers).",
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
                    lawRef("Article 222-33 du C.P."),
                    normal(
                      " : (I) faits répétés ; (II) acte unique assimilé (pression grave).",
                    ),
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
                    "A) Harcèlement sexuel exigeant des actes répétés",
                  ),
                  const _SubTitle("1) Propos ou comportements imposés"),
                  const _Paragraph(
                    "Il peut s’agir de propos, gestes, attitudes, envois/remises de courriers, d’objets, etc. "
                    "Cela inclut des propos sexistes, grivois, obscènes, des écrits répétés (provocations, injures, diffamations même non publiques) "
                    "commis en raison du sexe, de l’orientation sexuelle ou de l’identité sexuelle de la victime.",
                  ),
                  const SizedBox(height: 10),
                  const _SubTitle(
                    "2) Effet sur la victime (une des 2 options)",
                  ),
                  const _BulletPoint(
                    text:
                        "Atteinte à la dignité (caractère dégradant ou humiliant).",
                  ),
                  const _BulletPoint(
                    text:
                        "Ou création d’une situation intimidante, hostile ou offensante (conditions de vie, de travail ou d’hébergement rendues insupportables).",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Une personne importune quotidiennement un(e) collègue en lui adressant sans cesse des messages/objets à connotation sexuelle "
                        "malgré la demande de cesser (",
                      ),
                      normal("Cass. crim., 21 septembre 2010"),
                      normal(")."),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle("3) Connotation sexuelle ou sexiste"),
                  const _Paragraph(
                    "Les faits doivent présenter une connotation sexuelle ou sexiste. Un caractère explicitement et directement sexuel n’est pas exigé.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Deux SMS nostalgiques d’un supérieur hiérarchique (« temps où elle le rendait heureux ») après une liaison : "
                        "insuffisant pour présumer un harcèlement (",
                      ),
                      normal("C.A. Lyon, 8 novembre 2013"),
                      normal(")."),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Propos à connotation sexuelle et sexiste tenus devant des étudiants : possible pluralité de victimes car les propos "
                        "peuvent être imposés à chacune (",
                      ),
                      normal("Cass. crim., 12 mars 2025, n° 24-81.644"),
                      normal(")."),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle("4) Absence de consentement"),
                  const _Paragraph(
                    "Les actes sont imposés : la victime les subit et ne les désire pas. "
                    "L’absence de consentement peut être démontrée par un faisceau d’indices. "
                    "La victime n’a pas à exprimer un refus explicite et formel.",
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle("Exemples d’indices"),
                  const _BulletPoint(
                    text: "Silence permanent face aux agissements.",
                  ),
                  const _BulletPoint(
                    text:
                        "Signalement ou demande d’intervention à un supérieur hiérarchique.",
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle("5) Répétition"),
                  const _BulletPoint(
                    text:
                        "Un seul auteur : au moins 2 faits (pas de délai minimum, même sur un court laps de temps).",
                  ),
                  const SizedBox(height: 8),
                  const _SubTitle("Plusieurs auteurs (élargissement 2018)"),
                  const _Paragraph(
                    "La définition couvre les agissements sur une même victime par plusieurs personnes (ex. « raids numériques »), "
                    "sur internet ou au travail.",
                  ),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Concertation / instigation : même sans répétition individuelle.",
                  ),
                  const _BulletPoint(
                    text:
                        "Successifs sans concertation : chacun sait que l’ensemble caractérise une répétition.",
                  ),

                  const SizedBox(height: 16),

                  const _SubTitle(
                    "B) Harcèlement sexuel résultant d’un acte unique (assimilé)",
                  ),
                  const _SubTitle("1) Pression grave"),
                  const _Paragraph(
                    "Une personne tente d’imposer un acte de nature sexuelle à la victime en contrepartie d’un avantage "
                    "ou pour lui éviter une situation particulièrement dommageable. La gravité peut suffire à constituer l’infraction en un seul acte.",
                  ),
                  const SizedBox(height: 10),
                  const _SubTitle("Exemples typiques"),
                  const _BulletPoint(
                    text:
                        "Avantage recherché : emploi, augmentation, bail, réussite à un examen, logement…",
                  ),
                  const _BulletPoint(
                    text:
                        "Éviter un dommage : licenciement, mutation non désirée, redoublement, hausse de loyer…",
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle("2) Finalité de nature sexuelle"),
                  const _Paragraph(
                    "La pression est exercée dans le but réel ou apparent d’obtenir un acte de nature sexuelle "
                    "(au profit de l’auteur ou d’un tiers). Une relation sexuelle n’est pas nécessaire : des contacts physiques suffisent.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Même si l’auteur dit agir « pour jouer » ou pour humilier, il peut être sanctionné si les pressions donnaient l’impression "
                    "qu’un acte sexuel était recherché (aux yeux de la victime ou des tiers).",
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
                  _Paragraph.rich([
                    normal("Infraction volontaire : "),
                    lawRef("article 121-3 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle(
                    "1) Conscience de se livrer à un acte de harcèlement",
                  ),
                  const _Paragraph(
                    "Le texte ne détaille pas l’élément moral, mais l’infraction est volontaire : l’auteur a conscience de ses propos/comportements.",
                  ),
                  const SizedBox(height: 12),
                  const _SubTitle(
                    "2) Volonté d’obtenir un acte de nature sexuelle (acte unique)",
                  ),
                  const _Paragraph(
                    "Pour l’acte unique assimilé, la finalité pouvant être réelle ou apparente, il n’est pas exigé de démontrer un dol spécial "
                    "parfois difficile à caractériser.",
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
                  _Paragraph.rich([
                    normal(
                      "Le harcèlement sexuel est aggravé dans les cas listés par ",
                    ),
                    lawRef("l’article 222-33 III du C.P."),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 10),
                  const _BulletPoint(
                    text: "Abus d’autorité conférée par les fonctions.",
                  ),
                  const _BulletPoint(text: "Victime mineure de 15 ans."),
                  const _BulletPoint(
                    text:
                        "Victime particulièrement vulnérable (âge, maladie, infirmité, déficience physique/psychique, grossesse), vulnérabilité apparente ou connue.",
                  ),
                  const _BulletPoint(
                    text:
                        "Vulnérabilité/dépendance liée à la précarité économique ou sociale (apparente ou connue).",
                  ),
                  const _BulletPoint(
                    text:
                        "Plusieurs personnes agissant comme auteurs ou complices.",
                  ),
                  const _BulletPoint(
                    text:
                        "Utilisation d’un service de communication au public en ligne / support numérique.",
                  ),
                  const _BulletPoint(
                    text: "Présence d’un mineur qui assiste aux faits.",
                  ),
                  const _BulletPoint(
                    text:
                        "Ascendant ou personne ayant autorité de droit ou de fait sur la victime.",
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
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text:
                        "Forme simple : 2 ans d’emprisonnement + 30 000 € d’amende.",
                  ),
                  const _BulletPoint(
                    text:
                        "Forme aggravée : 3 ans d’emprisonnement + 45 000 € d’amende.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Aggravation : "),
                    lawRef("article 222-33 III (1° à 8°) du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 12),
                  _Paragraph.rich([
                    normal("Personnes morales : responsabilité prévue par "),
                    lawRef("l’article 121-2 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 12),
                  const _SubTitle("Tentative"),
                  const _BulletPoint(text: "Tentative : NON."),
                  const SizedBox(height: 12),
                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal("Complicité : OUI — punissable conformément aux "),
                    lawRef("articles 121-6 et 121-7 du C.P."),
                    normal("."),
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
