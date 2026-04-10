import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FauxEtUsageDeFauxPage extends StatelessWidget {
  const FauxEtUsageDeFauxPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux/faux_et_usage_de_faux';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
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
    final Color cardRep = cardDef;

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
          "Faux & usage de faux",
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
            "Le faux et l’usage de faux",
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
                "Le faux consiste en toute altération de la vérité de nature à causer un préjudice, "
                "accomplie par quelque moyen que ce soit, dans un écrit ou tout autre support d’expression "
                "de la pensée, ayant pour objet ou pouvant avoir pour effet d’établir la preuve d’un droit "
                "ou d’un fait ayant des conséquences juridiques.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 441-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime l’infraction de faux ainsi que l’usage de faux.",
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
                "L’infraction est constituée par une altération préjudiciable de la vérité réalisée dans un document "
                "avec la volonté de tromper.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Établissement d’un support matériel du faux"),
              const _SubTitle("• Le support du faux"),
              const _Paragraph(
                "Le support doit être un écrit ou tout autre support d’expression de la pensée. "
                "Il doit avoir pour objet ou pour effet d’établir la preuve d’un droit ou d’un fait ayant des conséquences juridiques : "
                "cela implique une certaine valeur probatoire.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("✓ Un écrit"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le faux est principalement commis dans un écrit. Le texte vise tout écrit non couvert par un faux spécial ",
                ),
                TextSpan(
                  text: "(articles 441-2 à 441-7 du Code pénal)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". L’écrit correspond à « tout signe ou ensemble de signes matériels, visibles et permanents, servant à l’expression, la fixation et la transmission de la pensée ».",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’écriture peut être manuscrite, dactylographiée, gravée ou peinte. "
                "La langue et le langage utilisés sont indifférents.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("✓ Autres supports de la pensée"),
              const _Paragraph(
                "La formulation est volontairement très large : elle permet d’étendre l’infraction à de nouveaux supports "
                "(ex. CD-ROM, DVD, disque dur, film, microfilm, clés USB, etc.). "
                "Elle permet aussi de sanctionner la falsification de documents informatiques en dehors de toute atteinte à un STAD.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Saisies de remboursements indus + faux actes médicaux + faux décomptes : ces décomptes sont des documents faisant titre entrant dans les prévisions de ",
                  ),
                  TextSpan(
                    text: "l’article 441-1 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: "(Cass. crim., 24 janvier 2001)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("• Valeur probatoire du support"),
              const _Paragraph(
                "Sont visés :\n"
                "— les supports créés dès l’origine pour servir de preuve ;\n"
                "— mais aussi ceux qui peuvent ensuite avoir cet effet (documents dits « de hasard »).",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text: "Falsification d’un constat amiable d’accident ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 1er juin 1981)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  const TextSpan(
                    text:
                        "Correspondance privée falsifiée et produite en justice pour établir la preuve d’un fait ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 16 février 1977)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  const TextSpan(
                    text: "Falsification d’une lettre d’embauche ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 16 novembre 1995)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les factures, simples déclarations unilatérales, n’ont pas en elles-mêmes de valeur probatoire. "
                      "Elles peuvent toutefois en acquérir une lorsqu’elles sont passées en comptabilité : leur falsification tombe alors sous le coup de ",
                ),
                TextSpan(
                  text: "l’article 441-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(
                  text: "(Cass. crim., 05 avril 1993)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Copie d’un document",
                bodySpans: [
                  const TextSpan(
                    text:
                        "La possibilité de réaliser un faux dépend de la valeur probatoire reconnue à la copie. "
                        "La production en justice sous forme de photocopie d’un document contrefait constitue un faux ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 16 novembre 1995)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Une falsification"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 441-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : vise l’altération de la vérité accomplie par quelque moyen que ce soit.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("☑ Une falsification matérielle"),
              const _Paragraph(
                "Le support (aspect physique) du document est falsifié. "
                "Deux formes principales :\n"
                "— altération d’un document authentique (suppression, modification, adjonction d’écritures) ;\n"
                "— procédés donnant l’apparence de l’authenticité à un document qui ne l’est pas (fabrication du document, imitation de signature…).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Ticket d’autobus plastifié : procédé ayant pu empêcher l’impression, faire disparaître ou rendre effaçables des signes normalement indélébiles destinés à faire preuve ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 19 décembre 1974)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("☑ Une falsification intellectuelle"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le faux intellectuel est un défaut de véracité : le mensonge atteint le contenu de l’écrit et non le support. "
                      "Il doit porter sur l’altération des faits que le document avait pour objet de constater et sur une disposition substantielle ",
                ),
                TextSpan(
                  text: "(Cass. crim., 29 avril 1971)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("C) Un préjudice"),
              const _Paragraph(
                "Le texte exige une altération de la vérité « de nature à causer un préjudice ». "
                "Il n’est pas nécessaire que le préjudice se soit effectivement réalisé : il suffit qu’il soit possible.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le préjudice peut être :\n"
                "— matériel (atteinte aux intérêts patrimoniaux : privation d’un droit, création d’obligations indues…) ;\n"
                "— moral (honneur, considération, réputation…) ;\n"
                "— social (atteinte à la confiance dans les actes publics/authentiques).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) L’usage du faux"),
              _Paragraph.rich([
                const TextSpan(
                  text: "L’usage du faux est incriminé par l’alinéa 2 de ",
                ),
                TextSpan(
                  text: "l’article 441-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: ". L’usage suppose l’existence préalable d’un faux.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La jurisprudence retient qu’il suffit que le détenteur utilise la pièce, par un acte quelconque, en vue du résultat final qu’elle était destinée à produire ",
                ),
                TextSpan(
                  text: "(Cass. crim., 25 janvier 1961 ; 8 octobre 1996)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: ", ou par tout acte de nature à causer un préjudice.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’usage de faux nécessite un fait positif d’utilisation et ne peut résulter de la seule abstention (contrats de prêt falsifiés) ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 4 novembre 2010)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),
              const _Paragraph(
                "C’est une infraction instantanée : chaque acte d’usage constitue une nouvelle infraction. "
                "Le délai de prescription court à compter de chacun des actes d’utilisation (dernier acte en date).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Prescription",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le délai de prescription court, pour l’usage de faux, à partir de la date de chacun des actes par lesquels le prévenu se prévaut de la pièce fausse ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 19 janvier 2000)",
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

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Concernant l’infraction de faux"),
              const _BulletPoint(text: "Volonté de réaliser la falsification."),
              const _BulletPoint(
                text:
                    "Conscience d’altérer la vérité dans des conditions de nature à causer un préjudice.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Pour le faux matériel, l’acte révèle l’intention du fait même de sa réalisation (fabrication, fausse signature…). "
                "Pour le faux intellectuel, l’intention peut être plus délicate à caractériser (l’auteur peut se croire sincère). "
                "Les mobiles sont indifférents.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Concernant l’infraction d’usage de faux"),
              const _BulletPoint(text: "Volonté d’user de la pièce fausse."),
              const _BulletPoint(
                text: "Connaissance de la fausseté de la pièce.",
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
            children: const [
              _Paragraph(
                "Aucune circonstance aggravante spécifique n’est prévue pour cette infraction.",
              ),
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
                const TextSpan(
                  text:
                      "Faux et usage de faux : 3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 441-1 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 441-12 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 441-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (prévoit expressément la tentative des délits prévus à l’article 441-1).",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Complicité : OUI."),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Secrétaire de mairie faisant procéder par un employé subalterne à la falsification de registres ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 octobre 2000)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  const TextSpan(
                    text:
                        "Ouverture de comptes bancaires pour encaisser des chèques en paiement de factures fictives ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 23 juin 1988)",
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
