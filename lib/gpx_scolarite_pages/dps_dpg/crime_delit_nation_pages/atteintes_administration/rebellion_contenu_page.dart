import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RebellionPage extends StatelessWidget {
  const RebellionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_administration/rebellion';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
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
          "Atteintes à l’administration",
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
            "La rébellion",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait d’opposer une résistance violente à une personne dépositaire de l’autorité publique "
                "ou chargée d’une mission de service public agissant, dans l’exercice de ses fonctions, "
                "pour l’exécution des lois, des ordres de l’autorité publique, des décisions ou mandats de justice, "
                "est une rébellion et constitue une infraction.",
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
                  text: "Article 433-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : définit la rébellion. "),
                TextSpan(
                  text: "Article 433-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : la réprime."),
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
              const _SubTitle("A) Une victime particulière"),
              const _Paragraph(
                "La rébellion vise la résistance violente contre :\n"
                "• une personne dépositaire de l’autorité publique ;\n"
                "• ou une personne chargée d’une mission de service public.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Dépositaire de l’autorité publique"),
              const _Paragraph(
                "Est dépositaire de l’autorité publique celui qui dispose d’un pouvoir de décision fondé sur la parcelle "
                "d’autorité publique que lui confèrent ses fonctions (fonctionnaire, militaire, magistrat, officier public, etc.).",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Sont notamment concernés : policiers, gendarmes, douaniers, huissiers de justice, commissaires-priseurs, "
                "fonctionnaires des eaux et forêts, responsables d’exécutifs locaux (maires, présidents d’EPCI, conseils départementaux/régionaux), "
                "ainsi que les adjoints au maire et conseillers municipaux délégués.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Chargé d’une mission de service public"),
              const _Paragraph(
                "Est chargé d’une mission de service public celui qui accomplit, à titre temporaire ou permanent, volontairement "
                "ou sur réquisition des autorités, un service public quelconque. Il participe à une mission d’intérêt général "
                "sans pouvoir de décision/commandement.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Exemple : un serrurier requis par l’O.P.J. Les élus locaux sans délégation de prérogatives de puissance publique "
                "(comme les parlementaires) relèvent de cette catégorie.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Agissant dans l’exercice de ses fonctions"),
              const _Paragraph(
                "Il n’y a rébellion que si la résistance se manifeste alors que l’agent agit dans le cadre de ses fonctions.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Article 113-3 du règlement général d’emploi de la Police nationale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : les fonctionnaires actifs sont tenus, même hors service, d’intervenir (assistance à personne en danger, "
                      "prévenir/réprimer un trouble à l’ordre public, protéger les personnes et les biens).",
                ),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Tout fonctionnaire de police est considéré comme étant en service et agissant dans l’exercice de ses fonctions "
                        "lorsqu’il intervient dans sa circonscription, de sa propre initiative ou sur réquisition, pour prévenir et réprimer "
                        "tout acte troublant la sécurité et l’ordre publics ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 15 décembre 2015)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Pour l’exécution des lois / ordres / décisions ou mandats de justice",
              ),
              const _Paragraph(
                "Il n’y a rébellion que si la résistance intervient alors que l’agent opère :\n"
                "• en police judiciaire (flagrant délit, enquête préliminaire, commission rogatoire, mandat, jugement, etc.) ;\n"
                "• ou en police administrative (maintien/rétablissement de l’ordre public, etc.).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Après un vol avec port d’arme, l’individu résiste violemment aux gendarmes en tenue qui tentent de procéder à son arrestation : "
                        "ils agissent nécessairement pour l’exécution des lois ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 24 octobre 1984)",
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
                "L’ordre peut être implicite (ex. contrôle d’identité par un A.P.J. « sur ordre et sous la responsabilité d’un O.P.J. ») "
                "ou nécessiter une autorisation/réquisition préalable (commission rogatoire, mandats…).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’illégalité supposée de l’acte accompli par l’agent dans l’exercice de ses fonctions est sans incidence sur la procédure "
                        "pour rébellion (et outrage) ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 1er septembre 2004)",
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
                "En revanche, si l’agent commet un acte sans lien avec sa mission (litige d’ordre privé), la résistance ne constitue pas une rébellion.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Un acte de résistance violente"),
              const _Paragraph(
                "Sont exclus : la simple désobéissance ou l’obstacle passif à l’accomplissement de la mission.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un sexagénaire frêle qui refuse de suivre les gendarmes en s’accrochant au volant de son véhicule : obstacle passif, "
                        "pas de rébellion ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 1er mars 2006)",
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
                "La rébellion est retenue dès lors qu’il y a violence et initiative de confrontation. "
                "La résistance doit être violente, sans exiger nécessairement une agression caractérisée ni un préjudice pour l’agent.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  const TextSpan(text: "Agent frappé (poings/pieds) "),
                  TextSpan(
                    text: "(Cass. crim., 06 novembre 2001)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  const TextSpan(
                    text:
                        "Chute de deux gardiens de la paix provoquée dans un escalier mécanique ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 23 septembre 1982)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  const TextSpan(
                    text:
                        "Coup de pied lors d’une fouille de sécurité après énervement/insultes ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 23 mai 2006)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Journaliste qui se débat au moment de son interpellation et réussit à prendre la fuite, sans frapper les policiers : "
                        "résistance active suffisante ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 07 novembre 2006)",
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
                "Distinction avec les violences volontaires :\n"
                "• violences aggravées si l’agent public n’exerce pas de prérogative à l’égard de l’individu violent ;\n"
                "• rébellion si l’agent exerce ses fonctions à l’égard de l’individu qui répond par un acte violent.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Rébellion retenue lorsque les violences ne sont pas distinctes de la résistance violente constitutive de la rébellion ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 21 février 2006)",
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
              const _SubTitle(
                "A) Connaissance de la qualité de l’agent public",
              ),
              const _Paragraph(
                "En général, cette connaissance résulte du fait que l’agent est en uniforme ou présente des signes distinctifs "
                "(brassard, carte professionnelle, etc.) et précise l’objet de son intervention.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Volonté de résister à l’agent public"),
              const _Paragraph(
                "Le mobile est indifférent. L’infraction est intentionnelle : l’auteur agit volontairement en ayant conscience "
                "d’exercer des violences ou voies de fait.",
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
                  text: "Article 433-7 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : rébellion commise en réunion."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : rébellion commise par une personne porteuse d’une arme (apparente ou cachée). "
                      "Un degré d’aggravation supplémentaire est prévu si la rébellion armée est commise en réunion.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Suspect irascible en garde à vue, menace l’enquêteur de le frapper avec une chaise, nécessite une maîtrise par la force ",
                  ),
                  TextSpan(
                    text: "(C.A. Amiens, 19 décembre 2007)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 433-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : lorsque l’auteur de la rébellion est détenu.",
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
                const TextSpan(text: "Simple : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 433-7 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (en réunion) : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 433-7 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (arme) : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 433-8 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (arme + réunion) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 150 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 433-8 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Auteur détenu : "),
                const TextSpan(
                  text:
                      "cumul des peines de la rébellion et de l’infraction pour laquelle l’auteur est détenu. — ",
                ),
                TextSpan(
                  text: "article 433-9 du Code pénal",
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
                  text: "l’article 121-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’assistance apportée à l’auteur principal peut constituer une complicité de rébellion : "
                        "jeter des graviers et débris de verre en direction d’un policier en sommant de relâcher un camarade interpellé ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 8 décembre 2009)",
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
