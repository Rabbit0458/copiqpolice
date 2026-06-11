import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaChantagePage extends StatelessWidget {
  const PaChantagePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/voisines_du_vol/chantage';

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
          "Voisines du vol",
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
            "Le chantage",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.12,
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
                "Le chantage est le fait d’obtenir, en menaçant de révéler ou d’imputer des faits de nature à porter atteinte "
                "à l’honneur ou à la considération, soit une signature, un engagement ou une renonciation, soit la révélation "
                "d’un secret, soit la remise de fonds, de valeurs ou d’un bien quelconque.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (obligatoire)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-10 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : définit et réprime le chantage."),
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
              _Paragraph(
                "C’est la nature de la menace qui distingue le chantage de l’extorsion : "
                "il ne s’agit pas de menaces de violences ou de contrainte morale, mais de menace de diffamation. "
                "En revanche, le but recherché est identique à celui de l’extorsion.",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "A) Menace de révélations ou d’imputations diffamatoires",
              ),
              _Paragraph(
                "Le chantage repose sur une menace à caractère diffamatoire : menace de révéler ou d’imputer un fait "
                "de nature à porter atteinte à l’honneur ou à la considération.",
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(text: "La diffamation est définie par "),
                  TextSpan(
                    text: "l’article 29 de la loi du 29 juillet 1881",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " : « toute allégation ou imputation d’un fait portant atteinte à l’honneur ou à la considération… ».",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le chantage consiste à menacer quelqu’un de faire connaître à des tiers des faits portant atteinte à l’honneur ou à la considération ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 24 mars 1953)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "La menace de révélation d’une relation adultère en demandant de l’argent pour le prix du silence est de nature à porter atteinte à la considération de la victime ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 28 janvier 2015)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("B) Révélation vs imputation"),
              _Paragraph(
                "La révélation consiste à reprendre / répéter / reproduire des propos ou écrits attribués à des tiers. "
                "L’imputation renvoie plutôt à l’affirmation personnelle d’un fait dont l’auteur assume la responsabilité.",
              ),

              SizedBox(height: 12),

              _SubTitle(
                "C) Menace visant une personne physique ou morale",
              ),
              _Paragraph(
                "L’atteinte diffamatoire doit être dirigée contre une personne physique ou une personne morale "
                "(les deux peuvent être atteintes dans leur honneur ou leur considération). "
                "Le chantage peut donc viser une société.",
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Menace proférée par l’employé d’une banque de saisir la Commission des opérations de bourse d’un dossier compromettant sur des pratiques de ladite banque ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 12 octobre 1995)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _Paragraph(
                "La personne sous la menace peut ne pas être la victime directe : le délit existe dès lors que la menace "
                "porte sur un fait pouvant atteindre l’honneur/la considération d’un tiers, si cette menace permet d’obtenir "
                "une remise (fonds, valeurs, etc.).",
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Un proche parent peut exercer une contrainte morale sur la personne menacée afin d’obtenir une remise d’argent ou de valeurs ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 15 avril 1896)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                "D) Menace visant un fait déterminé (vrai ou faux)",
              ),
              _Paragraph(
                "La menace doit se référer à un fait précis, déterminant pour amener la victime à céder. "
                "Peu importe que le fait soit vrai ou faux : l’« imputation » peut porter sur des faits imaginaires, "
                "la « révélation » suppose plutôt la véracité.",
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Menace de dévoiler à la famille et aux proches les liaisons vraies ou supposées de la victime ",
                  ),
                  TextSpan(
                    text: "(C.A. Aix-en-Provence, 7 juin 1993)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Menace de divulguer à la presse et à l’opinion publique des agissements prétendus frauduleux ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 8 mars 1989)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("E) Expression de la menace"),
              _BulletPoint(
                text: "Menace écrite ou verbale : aucune distinction en droit.",
              ),
              _Paragraph.rich([
                TextSpan(text: "La forme est indifférente au regard de "),
                TextSpan(
                  text: "l’article 312-10 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "La menace peut être implicite (termes voilés, sous-entendus) dès lors qu’elle est facilement compréhensible "
                "et qu’elle exerce une pression conduisant à la remise demandée.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Même commis par voie de presse, le chantage reste traité comme un délit de droit commun (règles spécifiques de la loi de 1881 écartées).",
              ),

              SizedBox(height: 14),

              _SubTitle("F) Objet de la menace (ce qui est exigé)"),
              _Paragraph(
                "L’objet est le même que pour l’extorsion : obtenir quelque chose sous la pression de la menace. "
                "Il faut que l’exigence résulte directement des menaces.",
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Point-clé",
                bodySpans: [
                  TextSpan(
                    text:
                        "Pas de chantage si l’exigence n’est pas clairement établie ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 25 mai 1999)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("G) Exemples d’objets visés par la loi"),
              _BulletPoint(
                text: "Une signature (même sur une feuille blanche).",
              ),
              _BulletPoint(
                text:
                    "Un engagement ou une renonciation (contrats, quittances, reçus, démission, mainlevées…).",
              ),
              _BulletPoint(
                text:
                    "La révélation d’un secret (personnel, professionnel, correspondance, affaires…).",
              ),
              _BulletPoint(
                text:
                    "La remise de fonds, valeurs ou d’un bien quelconque (mobiliers/immobiliers, corporel ou non).",
              ),

              SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Exigence par un salarié d’une promotion professionnelle et d’une lettre de recommandation ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 12 octobre 1995)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Pression exercée pour obtenir une somme correspondant à une partie d’héritage avant détermination notariale ",
                  ),
                  TextSpan(
                    text: "(C.A. Orléans, 9 janvier 1995)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
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
            children: const [
              _Paragraph(
                "L’élément intentionnel réside dans la volonté de contraindre autrui afin d’obtenir ce qui n’aurait "
                "pas pu être obtenu par un accord librement consenti (le mobile est indifférent).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Définition (Cour de cassation)",
                bodySpans: [
                  TextSpan(
                    text:
                        "« Le dessein de contraindre autrui à souscrire des engagements ou à remettre des fonds » ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 25 octobre 1973)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Cette définition permet de réprimer aussi bien le maître chanteur agissant par vengeance, intérêt personnel, "
                "ou même en se croyant « justicier ».",
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-10 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : lorsque le chantage est exercé par un service de communication au public en ligne :",
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Au moyen d’images ou de vidéos à caractère sexuel.",
              ),
              _BulletPoint(
                text:
                    "En vue d’obtenir des images ou des vidéos à caractère sexuel.",
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-11 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : lorsque l’auteur a mis sa menace à exécution.",
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
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Simple : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 312-10 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (en ligne, al. 3) : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 312-10 alinéa 3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (menace exécutée) : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 312-11 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Peines prévues par "),
                TextSpan(
                  text: "l’article 312-15 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : OUI, réprimée par "),
                TextSpan(
                  text: "l’article 312-12 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " (même peine que l’infraction consommée).",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " (aide/assistance, provocation, instructions).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Immunité familiale"),
              _Paragraph.rich([
                TextSpan(text: "OUI : "),
                TextSpan(
                  text: "l’article 312-12 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " renvoie à l’immunité familiale de "),
                TextSpan(
                  text: "l’article 311-12 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
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
