import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EscroqueriePage extends StatelessWidget {
  const EscroqueriePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/escroquerie';

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
            "L’escroquerie",
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
                "L’escroquerie est le fait, soit par l’usage d’un faux nom ou d’une fausse qualité, "
                "soit par l’abus d’une qualité vraie, soit par l’emploi de manœuvres frauduleuses, "
                "de tromper une personne physique ou morale et de la déterminer ainsi, à son préjudice "
                "ou au préjudice d’un tiers, à remettre des fonds, des valeurs ou un bien quelconque, "
                "à fournir un service ou à consentir un acte opérant obligation ou décharge.",
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
                  text: "Article 313-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : définit et réprime l’escroquerie."),
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
                "L’escroquerie se rapproche du vol en ce qu’elle tend à l’appropriation de la chose d’autrui. "
                "Mais, alors que le vol suppose une soustraction frauduleuse, l’escroquerie consiste à se faire remettre "
                "la chose par son propriétaire, en le trompant par des moyens frauduleux.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Un moyen de tromperie (déterminant)"),
              const _Paragraph(
                "Le texte ne vise que quatre formes de tromperie. L’usage d’un seul moyen suffit, mais plusieurs procédés "
                "sont souvent employés simultanément.\n"
                "Le moyen doit être déterminant (provoquer la remise) et résulter d’un comportement actif de l’auteur.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("1) L’usage d’un faux nom"),
              const _Paragraph(
                "Constitue un faux nom l’usage par une personne d’un nom patronymique qui n’est pas le sien, "
                "qu’il soit réel (nom d’un tiers) ou imaginaire. "
                "Sont assimilés : faux prénom ou faux pseudonyme s’ils entraînent confusion/homonymie.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("2) L’usage d’une fausse qualité"),
              const _Paragraph(
                "La loi ne définit pas la notion de « qualité ». "
                "Elle peut être comprise strictement (attribut juridique essentiel : âge, titre, profession, situation matrimoniale, nationalité) "
                "ou plus largement (toute particularité de nature à inspirer confiance, donner du crédit, fonder une prétention à un avantage).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Exemples de qualités retenues"),
              const _BulletPoint(
                text:
                    "État des personnes : âge, nationalité, situation matrimoniale, lien de parenté, domicile (lorsqu’il procure un avantage).",
              ),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Fausse qualité de national ou d’époux d’une Française (mariage simulé) ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 26 octobre 1994)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Titres : noblesse, universitaires, honorifiques, fonctions électives/religieuses…",
              ),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Porter indûment l’insigne d’officier de l’ordre du mérite pour se faire livrer des marchandises ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 4 décembre 1984)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 8),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text: "Se présenter comme prêtre sans avoir reçu l’ordre ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 2 février 2000)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Profession : toute profession (fonction publique, professions réglementées, etc.).",
              ),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Usage de la fausse qualité de policier pour obtenir une remise de fonds ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 26 juin 1984)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Mandataire : se présenter mensongèrement comme mandataire d’autrui.",
              ),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Se prétendre mandataire d’un créancier afin de déterminer une remise ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 juillet 1968)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Chômeur / salarié : fausse qualité retenue lorsque la qualité réelle ouvre droit à un avantage.",
              ),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Prestations chômage obtenues via fausses déclarations : escroquerie par fausse qualité ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 30 novembre 1981)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 8),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Se dire faussement salarié constitue une fausse qualité ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 10 avril 1997)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("3) L’abus d’une qualité vraie"),
              const _Paragraph(
                "Ici, l’auteur utilise une qualité qu’il possède réellement pour donner force et crédit à ses mensonges, "
                "grâce à la confiance inspirée.\n"
                "La jurisprudence l’a retenu pour des professions traditionnellement dignes de confiance "
                "(notaire, huissier, avocat, médecin, banquier…), mais aussi pour des activités moins « prestigieuses » "
                "(commerçant, gérant de société, naturopathe…).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Conservateur de musée donnant l’apparence d’authenticité à des objets dépourvus de valeur ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 2 avril 1998)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 8),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Courtier d’assurances insérant une clause non portée à la connaissance de la compagnie et percevant des surprimes ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 8 décembre 1965)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("4) L’emploi de manœuvres frauduleuses"),
              const _Paragraph(
                "Les simples mensonges sont insuffisants s’ils ne sont accompagnés d’aucun fait extérieur ou acte matériel "
                "destiné à conforter les allégations. "
                "Les manœuvres doivent venir corroborer les mensonges et viser à donner force et crédit à ceux-ci pour obtenir la remise.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudence (principe)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Mensonge seul insuffisant ; les menaces/pressions verbales ou le mensonge déterminant ne suffisent pas sans fait extérieur ",
                  ),
                  TextSpan(
                    text:
                        "(Cass. crim., 6 novembre 1991 ; Cass. crim., 25 septembre 1997)",
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
                title: "Jurisprudence (temporalité)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les manœuvres frauduleuses doivent être déterminantes de la remise et antérieures à celle-ci ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 8 mars 2023)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "Méthodes fréquemment retenues par la jurisprudence",
              ),
              const _BulletPoint(
                text:
                    "Production d’un document écrit (authentique, falsifié, forgé, émanant d’un tiers réel ou imaginaire).",
              ),
              const _BulletPoint(
                text:
                    "Mise en scène (décor, machination, manipulation, trucage) destinée à crédibiliser le mensonge.",
              ),
              const _BulletPoint(
                text:
                    "Intervention d’un tiers (réel ou imaginaire) corroborant les dires de l’auteur, de manière orale/écrite, ou par présence passive.",
              ),

              const SizedBox(height: 10),

              _NotaBox(
                title: "Jurisprudences (exemples)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Carte grise provisoire authentique remise par un garagiste (véhicule gagé) déterminant un paiement intégral ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 22 mars 1978)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ; chèques falsifiés "),
                  TextSpan(
                    text: "(C.A. Paris, 15 septembre 1981)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text: " ; simulation de vol / liste d’objets volés ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 23 janvier 1981)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("B) Une remise"),
              _Paragraph.rich([
                const TextSpan(
                  text: "La remise doit être un acte positif de la victime. ",
                ),
                TextSpan(
                  text: "L’article 313-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " distingue trois types :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Remise de fonds, valeurs ou d’un bien quelconque.",
              ),
              const _BulletPoint(
                text: "Fourniture d’un service (toute prestation).",
              ),
              const _BulletPoint(
                text: "Consentement à un acte opérant obligation ou décharge.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("C) Un préjudice"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le préjudice est indispensable : sans préjudice, un élément du délit fait défaut ",
                ),
                TextSpan(
                  text: "(Cass. crim., 3 avril 1991)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le préjudice peut être matériel. Il peut aussi être analysé comme moral (consentement vicié), "
                "mais ce n’est pas automatique selon les cas.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) Une victime"),
              const _Paragraph(
                "La victime peut être une personne physique ou une personne morale.",
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
              const _Paragraph(
                "L’escroquerie est une infraction intentionnelle : l’auteur doit avoir conscience d’utiliser des moyens frauduleux "
                "dans le but d’obtenir une remise. La simple imprudence ne suffit pas.\n"
                "La mauvaise foi se déduit souvent des moyens employés, et les juges apprécient au cas par cas.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le mobile est indifférent pour la qualification pénale (il peut seulement influencer la peine).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Même si l’auteur affirme des intentions désintéressées (ex. au profit d’une œuvre), cela n’écarte pas l’infraction ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 juillet 1975)",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 313-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : escroquerie aggravée, notamment lorsque :",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Commise par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public.",
              ),
              const _BulletPoint(
                text:
                    "Commis par une personne prenant indûment la qualité d’une personne dépositaire de l’autorité publique/mission de service public.",
              ),
              const _BulletPoint(
                text:
                    "Appel au public pour émission de titres ou collecte de fonds à des fins d’entraide humanitaire/sociale.",
              ),
              const _BulletPoint(
                text:
                    "Au préjudice d’une personne particulièrement vulnérable (âge, maladie, infirmité, déficience, grossesse).",
              ),
              _Paragraph.rich([
                const TextSpan(text: "État de sujétion au sens de "),
                TextSpan(
                  text: "l’article 223-15-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " connu de l’auteur."),
              ]),
              const _BulletPoint(
                text:
                    "Au préjudice d’une personne publique / organisme de protection sociale / organisme chargé d’une mission de service public (pour obtenir une allocation, prestation, paiement ou avantage indu).",
              ),
              const _BulletPoint(text: "Commise en bande organisée."),
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
                  text: "5 ans d’emprisonnement et 375 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 313-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (circonstances des al. 2 à 6) : ",
                ),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 750 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 313-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Bande organisée : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 1 000 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 313-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Peines prévues par "),
                TextSpan(
                  text: "l’article 313-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative, complicité & immunité familiale"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — prévue par "),
                TextSpan(
                  text: "l’article 313-3 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (toujours punissable, simple ou aggravée).",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Complicité : OUI (punissable pour l’infraction consommée comme tentée, personnes physiques ou morales).",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Immunité familiale : OUI — "),
                TextSpan(
                  text: "l’article 313-3 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " renvoie à "),
                TextSpan(
                  text: "l’article 311-12 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
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
