import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaDiscriminationsAbusAutoritePage extends StatelessWidget {
  const PaDiscriminationsAbusAutoritePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/abus_autorite_particuliers/discriminations';

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
          "Abus d’autorité",
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
            "Les discriminations",
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
                "La discrimination définie aux articles 225-1 et 225-1-1, commise par une personne dépositaire de "
                "l’autorité publique ou chargée d’une mission de service public, dans l’exercice ou à l’occasion de "
                "l’exercice de ses fonctions ou de sa mission, consiste :\n"
                "1° À refuser le bénéfice d’un droit accordé par la loi ;\n"
                "2° À entraver l’exercice normal d’une activité économique quelconque.",
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
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 432-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : prévoit et réprime l’infraction."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Définition de la discrimination : "),
                TextSpan(
                  text: "articles 225-1 et 225-1-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
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
            children: const [
              _SubTitle("A) Une discrimination"),
              _Paragraph(
                "Il s’agit d’une distinction opérée entre les personnes sur des critères prohibés, notamment : origine, sexe, "
                "situation de famille, grossesse, apparence physique, particulière vulnérabilité économique (apparente ou connue), "
                "patronyme, lieu de résidence, état de santé, perte d’autonomie, handicap, caractéristiques génétiques, mœurs, "
                "orientation sexuelle, identité de genre, âge, opinions politiques, activités syndicales, qualité de lanceur d’alerte "
                "(ou personne en lien), capacité à s’exprimer dans une autre langue que le français, appartenance ou non-appartenance "
                "(vraie ou supposée) à une ethnie, une Nation, une prétendue race ou une religion déterminée.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Est aussi visée la distinction opérée parce qu’une personne a subi ou refusé de subir des faits de harcèlement sexuel, "
                      "ou a témoigné de tels faits, au sens de ",
                ),
                TextSpan(
                  text: "l’article 222-33 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                "B) Commise par une personne exerçant une fonction publique",
              ),
              _SubTitle("1) Dépositaire de l’autorité publique"),
              _Paragraph(
                "Est dépositaire de l’autorité publique celui qui dispose d’un pouvoir de décision fondé sur une parcelle "
                "d’autorité publique conférée par ses fonctions (fonctionnaire, militaire, magistrat, officier public ou "
                "ministériel, etc.).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Sont notamment concernés : policiers, gendarmes, douaniers, huissiers de justice, commissaires-priseurs, "
                "fonctionnaires des eaux et forêts. Certains exécutifs locaux et élus (maires, présidents d’intercommunalités, "
                "conseils départementaux et régionaux, adjoints/élus délégués selon leurs attributions) peuvent également être concernés.",
              ),

              SizedBox(height: 14),

              _SubTitle("2) Chargé d’une mission de service public"),
              _Paragraph(
                "Est chargé d’une mission de service public celui qui accomplit, à titre temporaire ou permanent, volontairement "
                "ou sur réquisition, un service public quelconque. Il réalise ou participe à une mission d’intérêt général sans "
                "pouvoir de décision ou de commandement.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Les élus locaux qui ne se voient confier par délégation aucune prérogative de puissance publique, ainsi que les "
                "parlementaires, peuvent relever de cette catégorie.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "C) Dans l’exercice ou à l’occasion des fonctions / mission",
              ),
              _Paragraph(
                "L’auteur doit agir dans le cadre de ses attributions : l’incrimination vise l’abus lié à la fonction. "
                "Un agent agissant totalement en dehors de sa mission n’entre pas dans le champ de cette qualification.",
              ),

              SizedBox(height: 14),

              _SubTitle("D) L’objet de la discrimination (2 formes)"),

              _SubTitle(
                "1) Refuser le bénéfice d’un droit accordé par la loi",
              ),
              _Paragraph(
                "Le terme « loi » s’entend largement : toute règle de portée générale et impersonnelle. "
                "Le droit doit être prévu par un texte (libertés publiques, prestation sociale, document administratif, "
                "bien/service, inscription à un concours, mutation, congé, etc.).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Ne constitue pas un « droit » la simple liberté d’appréciation laissée à la discrétion d’un fonctionnaire "
                "(ex. attribution d’une distinction).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : l’exercice d’un droit de préemption, même abusif, ne constitue pas un refus du bénéfice d’un droit accordé par la loi "
                        "au sens de la discrimination commise par une personne dépositaire de l’autorité publique. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 17 juin 2008)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                "2) Entraver l’exercice d’une activité économique",
              ),
              _Paragraph(
                "L’entrave consiste à rendre plus difficile l’exercice d’une activité économique quelconque. "
                "Peuvent notamment constituer une entrave : tracasseries administratives, dénigrement, pressions auprès des fournisseurs, etc.",
              ),

              SizedBox(height: 14),

              _SubTitle("E) Une victime"),
              _Paragraph(
                "Les agissements discriminatoires sont répréhensibles qu’ils soient commis au détriment d’une personne physique "
                "ou des membres d’une personne morale.",
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
            children: const [
              _SubTitle("Existence d’une volonté discriminatoire"),
              _Paragraph(
                "Elle se caractérise par la conscience de se livrer à des agissements discriminatoires : "
                "l’auteur sait qu’il opère une distinction prohibée et qu’il refuse un droit / entrave une activité pour ce motif.",
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
              _Paragraph("Aucune circonstance aggravante n’est prévue."),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Délit — "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 432-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La répression est écartée lorsqu’un texte autorise certains agissements. Exemple : la loi du 7 juin 1977 prévoit que le délit de discrimination "
                        "n’est pas constitué lorsque les agissements sont conformes aux directives prises par le gouvernement dans sa politique économique ou commerciale "
                        "ou en application de ses engagements internationaux.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph(
                "La responsabilité pénale des personnes morales peut être retenue (selon les règles générales).",
              ),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text:
                    "Tentative : NON (non incriminée en matière de discrimination).",
              ),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " (aide/assistance, provocation, instructions données).",
                ),
              ]),
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
  const _NotaBox({required this.bodySpans});

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
