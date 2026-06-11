import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaViolPage extends StatelessWidget {
  const PaViolPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/viol';

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
          "Viol",
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
                    lawRef("Article 222-23 du Code pénal"),
                    normal(
                      " : définit et réprime le viol commis par violence, contrainte, menace ou surprise.",
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
                    "Tout acte de pénétration sexuelle, de quelque nature qu’il soit, ou tout acte bucco-génital "
                    "commis sur la personne d’autrui ou sur la personne de l’auteur par violence, contrainte, menace ou surprise "
                    "est un viol et constitue une infraction.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text: "Acte : pénétration sexuelle OU acte bucco-génital.",
                  ),
                  _IntroBullet(
                    text:
                        "Contexte : violence, contrainte, menace ou surprise.",
                  ),
                  _IntroBullet(
                    text:
                        "Peut viser la victime ou l’auteur (acte réalisé sur l’auteur).",
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
                    lawRef("Article 222-23 du C.P."),
                    normal(
                      " : le viol est constitué lorsqu’un acte de pénétration sexuelle ou un acte bucco-génital "
                      "est imposé par violence, contrainte, menace ou surprise.",
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
                  const _SubTitle("1) Un acte de pénétration sexuelle"),
                  _Paragraph.rich([
                    lawRef("Article 222-23 du C.P."),
                    normal(
                      " vise « tout acte de pénétration sexuelle, de quelque nature qu’il soit ».",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "Relève de l’incrimination tout acte de pénétration dans le sexe ou par le sexe. "
                    "La nature de l’acte importe peu : rapports dits « normaux », sodomie, introduction d’un doigt "
                    "ou de corps étrangers dans le sexe ou l’anus de la victime.",
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
                        "Fellation constitutive de viol en cas de pénétration : ",
                      ),
                      normal("Cass. crim., 22 février 1984"),
                      normal(". "),
                      normal("Fellations réciproques : "),
                      normal("Cass. crim., 28 novembre 2001"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("3) Sur la victime ou sur l’auteur"),
                  const _Paragraph(
                    "Le viol est caractérisé aussi bien lorsque l’auteur commet l’acte sur la victime, "
                    "que lorsque l’acte est réalisé sur la personne de l’auteur.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal("Doigt introduit contre son gré dans le vagin : "),
                      normal("Cass. crim., 8 janvier 1991"),
                      normal(". "),
                      normal("Manche de pioche introduit dans l’anus : "),
                      normal("Cass. crim., 6 décembre 1995"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("4) Une victime"),
                  const _SubTitle("• Victime vivante"),
                  _Paragraph.rich([
                    normal("Il ne peut y avoir viol sur un cadavre ("),
                    normal("Cass. crim., 30 août 1877"),
                    normal("). L’atteinte au cadavre relève de "),
                    lawRef("l’article 225-17 du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 12),

                  const _SubTitle(
                    "• Indifférence de la condition de la victime",
                  ),
                  const _Paragraph(
                    "La condition de la victime importe peu : prostituée, hôtesse de bar, relation antérieure consentie, "
                    "ou relation conjugale… cela n’écarte pas la qualification si le rapport est imposé.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Le "),
                    lawRef("article 222-22 du C.P."),
                    normal(
                      " précise que les faits sont constitués quelle que soit la nature des relations entre l’agresseur et la victime, "
                      "y compris s’ils sont unis par les liens du mariage.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      TextSpan(
                        text:
                            "Le viol commis par un majeur sur un mineur de 15 ans et le viol incestueux sont des infractions autonomes (fiches distinctes).",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("5) Absence de consentement : les 4 moyens"),
                  _Paragraph.rich([
                    normal(
                      "Le viol suppose que l’auteur utilise un moyen pour atteindre son but hors de la volonté de la victime (",
                    ),
                    normal("Cass. crim., 29 avril 1960"),
                    normal("). Ces moyens sont fixés par "),
                    lawRef("l’article 222-23 du C.P."),
                    normal(" : violence, contrainte, menace ou surprise."),
                  ]),
                  const SizedBox(height: 12),

                  const _SubTitle("• La violence"),
                  const _Paragraph(
                    "Violence physique exercée sur la victime. Les pressions doivent être suffisantes pour paralyser la résistance. "
                    "Les juges apprécient concrètement la résistance ; la jurisprudence actuelle est moins exigeante et plus favorable à la victime.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Conducteur imposant un rapport malgré supplications : ",
                      ),
                      normal("Cass. crim., 10 juillet 1973"),
                      normal(". "),
                      normal(
                        "Rapport imposé à une hôtesse de bar malgré comportement équivoque : ",
                      ),
                      normal("Cass. crim., 3 mai 1993"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("• La contrainte ou la menace"),
                  const _Paragraph(
                    "Ces moyens visent à supprimer le consentement : violences morales assimilées à des violences physiques. "
                    "La crainte doit être sérieuse et immédiate, appréciée concrètement selon la capacité de résistance de la victime.",
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("La contrainte peut être physique ou morale : "),
                    lawRef("article 222-22-1 (alinéa 1) du C.P."),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Appréciation concrète ("),
                    normal("Cass. crim., 8 juin 1994"),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Vulnérabilité face au médecin abusant lors d’une consultation : ",
                      ),
                      normal("Cass. crim., 25 octobre 1994"),
                      normal(". "),
                      normal("Crainte face à un directeur despotique : "),
                      normal("Cass. crim., 8 février 1995"),
                      normal(". "),
                      normal(
                        "Menace d’abandon en pleine nuit par froid/brouillard : ",
                      ),
                      normal("Cass. crim., 11 février 1992"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("• La surprise"),
                  const _Paragraph(
                    "La surprise s’entend comme « surprendre le consentement », et non la surprise ressentie par la victime. "
                    "Elle vise notamment les victimes dont la maturité est insuffisante, ou vulnérables (troubles mentaux, handicap), "
                    "ou trompées/perturbées au point de ne pouvoir consentir.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Victime de 16 ans, déficience intellectuelle profonde et surdité : ",
                      ),
                      normal("Cass. crim., 6 novembre 1961"),
                      normal(". "),
                      normal("Adulte sous tutelle : "),
                      normal("Cass. crim., 30 juin 1993"),
                      normal(". "),
                      normal("Viol commis en état d’hypnose : "),
                      normal("Cass. crim., 3 septembre 1991"),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "À distinguer",
                    bodySpans: [
                      normal(
                        "L’ivresse/stupéfiants consommés volontairement ne suffisent pas à caractériser une vulnérabilité ; "
                        "mais l’ivresse peut permettre de qualifier la surprise (",
                      ),
                      normal("Cass. crim., 18 décembre 1991"),
                      normal(")."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "L’administration à l’insu d’une substance altérant le discernement ou le contrôle des actes est une circonstance aggravante.",
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    normal("Faits sur mineur : "),
                    lawRef("article 222-22-1 (alinéas 2 et 3) du C.P."),
                    normal(
                      " : la contrainte morale ou la surprise peuvent résulter d’une différence d’âge significative et d’une autorité de droit ou de fait. "
                      "Si la victime a moins de 15 ans, elles peuvent résulter de l’abus de vulnérabilité (absence de discernement).",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      TextSpan(
                        text:
                            "Dans certains cas prévus par la loi, violence/contrainte/menace/surprise n’ont pas à être démontrées (voir fiches dédiées).",
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
                children: const [
                  _SubTitle("Intention coupable"),
                  _Paragraph(
                    "Le viol requiert la conscience d’imposer à la victime des rapports sexuels non consentis. "
                    "Le mobile importe peu (haine, vengeance, recherche de jouissance, etc.). "
                    "La preuve est souvent facile en cas de violences/menaces explicites, plus délicate lorsque l’auteur invoque sa bonne foi ; "
                    "la jurisprudence tend à renforcer la protection des victimes.",
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
                  const _SubTitle("1er degré d’aggravation"),
                  _Paragraph.rich([
                    lawRef("Article 222-24 du C.P."),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text: "Mutilation ou infirmité permanente.",
                  ),
                  const _BulletPoint(text: "Victime mineure de quinze ans."),
                  const _BulletPoint(
                    text:
                        "Victime vulnérable (âge, maladie, infirmité, déficience, grossesse) apparente ou connue.",
                  ),
                  const _BulletPoint(
                    text:
                        "Vulnérabilité/dépendance liée à la précarité économique et sociale apparente ou connue.",
                  ),
                  const _BulletPoint(
                    text:
                        "Auteur : ascendant ou personne ayant autorité de droit ou de fait sur la victime.",
                  ),
                  const _BulletPoint(
                    text: "Abus d’autorité conférée par les fonctions.",
                  ),
                  const _BulletPoint(
                    text:
                        "Plusieurs auteurs/complices (participation simultanée aux faits).",
                  ),
                  const _BulletPoint(text: "Usage ou menace d’une arme."),
                  const _BulletPoint(
                    text:
                        "Mise en contact via réseau de communication électronique (messages à public non déterminé).",
                  ),
                  const _BulletPoint(
                    text:
                        "Concours avec un ou plusieurs autres viols (série/ simultané).",
                  ),
                  const _BulletPoint(
                    text: "Conjoint/concubin/partenaire PACS de la victime.",
                  ),
                  const _BulletPoint(
                    text:
                        "Auteur en état d’ivresse manifeste ou sous emprise manifeste de stupéfiants.",
                  ),
                  const _BulletPoint(
                    text:
                        "Dans l’exercice de l’activité, sur une personne se livrant à la prostitution (même occasionnelle).",
                  ),
                  const _BulletPoint(
                    text:
                        "Présence d’un mineur au moment des faits (y assiste).",
                  ),
                  const _BulletPoint(
                    text:
                        "Substance administrée à l’insu pour altérer discernement/contrôle des actes.",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "Jurisprudence",
                    bodySpans: [
                      normal(
                        "Vulnérabilité : l’âge seul (70 ans) ne suffit pas sans corrélation démontrée : ",
                      ),
                      normal("Cass. crim., 8 juin 2010"),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const _SubTitle("2e degré d’aggravation"),
                  _Paragraph.rich([
                    lawRef("Article 222-25 du C.P."),
                    normal(" : lorsqu’il a entraîné la mort de la victime."),
                  ]),

                  const SizedBox(height: 14),

                  const _SubTitle("3e degré d’aggravation"),
                  _Paragraph.rich([
                    lawRef("Article 222-26 du C.P."),
                    normal(
                      " : lorsqu’il est précédé, accompagné ou suivi de tortures ou d’actes de barbarie.",
                    ),
                  ]),
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
                    normal("Forme simple : "),
                    lawRef("article 222-23 du C.P."),
                    normal(" → 15 ans de réclusion criminelle."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Aggravé 1er degré : "),
                    lawRef("article 222-24 du C.P."),
                    normal(" → 20 ans de réclusion criminelle."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Aggravé 2e degré : "),
                    lawRef("article 222-25 du C.P."),
                    normal(
                      " → 30 ans de réclusion criminelle + période de sûreté.",
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal("Aggravé 3e degré : "),
                    lawRef("article 222-26 du C.P."),
                    normal(" → réclusion à perpétuité + période de sûreté."),
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
                  const _BulletPoint(
                    text:
                        "Tentative : OUI (punissable comme la tentative de tout autre crime).",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal("Complicité : OUI — "),
                    lawRef("articles 121-6 et 121-7 du C.P."),
                    normal(" (aide/assistance, provocation, instructions)."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      "La complicité est aussi une circonstance aggravante : ",
                    ),
                    lawRef("article 222-24 (6°) du C.P."),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle(
                    "Provocation à commettre un viol (infraction distincte)",
                  ),
                  _Paragraph.rich([
                    lawRef("Article 222-26-1 du C.P."),
                    normal(
                      " : incrimine l’« instigateur » (offres, promesses, dons, présents ou avantages) "
                      "afin qu’une personne commette un viol, y compris si le crime n’a été ni commis ni tenté.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _BulletPoint(
                    text:
                        "Peine : 10 ans d’emprisonnement et 150 000 € d’amende (si non suivi d’effet).",
                  ),
                  const SizedBox(height: 8),
                  const _BulletPoint(
                    text:
                        "Si la provocation est suivie d’un viol ou d’une tentative : application des règles de complicité (mêmes peines que l’auteur).",
                  ),
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
