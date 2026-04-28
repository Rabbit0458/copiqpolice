import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecelPage extends StatelessWidget {
  const RecelPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/recel_non_justification/recel';

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
          "Crimes & délits contre les biens",
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
            "Le recel",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ================= Définition =================
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le recel est le fait de dissimuler, de détenir ou de transmettre une chose, "
                "ou de faire office d’intermédiaire afin de la transmettre, en sachant que cette chose "
                "provient d’un crime ou d’un délit.\n\n"
                "Constitue également un recel le fait, en connaissance de cause, de bénéficier, par tout moyen, "
                "du produit d’un crime ou d’un délit.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ================= I — Élément légal (en haut) =================
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 321-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : définit et réprime le recel."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NOTA — Recels particuliers",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Des textes spécifiques répriment certains recels :\n",
                  ),
                  const TextSpan(text: "• Recel de déserteur : "),
                  TextSpan(
                    text: "article L. 321-19 du code de justice militaire",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Recel de criminel : "),
                  TextSpan(
                    text: "article 434-6 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Recel de cadavre : "),
                  TextSpan(
                    text: "article 434-7 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text:
                        "• Recel facilitant la découverte d’un crime/délit : ",
                  ),
                  TextSpan(
                    text: "article 434-4 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text: "• Recel de produit de délit de chasse : ",
                  ),
                  TextSpan(
                    text:
                        "articles L. 428-4 à L. 428-5-1 du code de l’environnement",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Recel d’infraction douanière : "),
                  TextSpan(
                    text: "articles 399 et 400 du code des douanes",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Recel d’épave maritime : "),
                  TextSpan(
                    text: "article L. 5142-8 du code des transports",
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

          // ================= II — Élément matériel =================
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Un acte matériel"),
              const _Paragraph(
                "Le recel peut résulter :\n"
                "• de la dissimulation, détention ou transmission d’un bien ;\n"
                "• du fait de servir d’intermédiaire pour le transmettre ;\n"
                "• ou du fait de bénéficier, par tout moyen, du produit d’un crime ou d’un délit (recel d’usage).",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "1) Dissimuler, détenir, transmettre, servir d’intermédiaire",
              ),
              const _Paragraph(
                "Les agissements de dissimulation sont répréhensibles quel que soit leur résultat "
                "(peu importe que le bien soit retrouvé ou non). La forme de la dissimulation est indifférente.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : mise à disposition d’un local pour entreposer des objets volés ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 30 mars 1999)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : dissimulation via de fausses mentions en comptabilité concernant des choses d’origine frauduleuse ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 12 juillet 1985)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "La dissimulation peut révéler la connaissance de l’origine frauduleuse : plaques volées cachées sous la garniture d’une aile de véhicule ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 22 mai 1997)",
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
                "La détention consiste à avoir la chose à sa disposition, sans se prétendre forcément propriétaire. "
                "Le recel est un délit continu : la détention suffit à le caractériser. "
                "La durée, le moyen, l’usage du bien ou le profit réalisé importent peu.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : voitures volées passant dans un garage en vue de transformation, sans profit personnel ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 25 janvier 1994)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : utilisation d’un véhicule volé comme passager puis comme conducteur ",
                  ),
                  TextSpan(
                    text: "(C.A. Nancy, 9 décembre 1992)",
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
                "La transmission consiste à céder/remettre/faire parvenir une chose transmissible. "
                "Servir d’intermédiaire ne suppose ni habitude ni profession : un acte isolé suffit, même sans but lucratif.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : recel de vol avec effraction retenu pour un rôle limité à la négociation de bons du Trésor volés ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 30 novembre 1999)",
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
                "2) Bénéficier par tout moyen du produit d’un crime/délit (recel d’usage)",
              ),
              const _Paragraph(
                "Cette forme sanctionne le fait d’utiliser ou de profiter d’un bien (ou d’un avantage) "
                "en connaissant son origine frauduleuse. La formule « par tout moyen » permet d’englober des avantages variés.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : passager dans un véhicule dont il connaissait l’origine frauduleuse ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 09 juillet 1970)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : profiter du train de vie de son épouse reconnue coupable de détournement au préjudice de l’employeur ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 09 mai 1974)",
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
                title: "Exemples d’extension par la jurisprudence",
                bodySpans: [
                  const TextSpan(text: "• Repas/services : "),
                  TextSpan(
                    text: "(Cass. crim., 07 mai 2002)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Rémunérations/salaires fictifs : "),
                  TextSpan(
                    text: "(Cass. crim., 30 mai 2001)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(text: "• Travaux/fournitures/crédits : "),
                  TextSpan(
                    text: "(Cass. crim., 14 mai 2003)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ".\n"),
                  const TextSpan(
                    text:
                        "• Bénéfice tiré de l’exploitation d’informations privilégiées : ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 26 octobre 1995)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) L’objet de l’acte"),
              const _Paragraph(
                "• Nature de la chose : tout ce qui est matière à vol peut faire l’objet d’un recel "
                "(meubles, bijoux, argent, énergie, secrets de fabrication, photocopies violant le secret fiscal…).\n"
                "• Le recel vise aussi le produit de la chose en cas de subrogation dans le patrimoine.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : fonds reçus utilisés pour l’achat d’un bien ou un investissement ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 22 juin 1972)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              const _SubTitle(
                "C) Une chose provenant d’un crime ou d’un délit",
              ),
              const _Paragraph(
                "La chose doit provenir d’une infraction qualifiée crime ou délit (les contraventions sont exclues). "
                "Le juge doit préciser la nature de l’infraction d’origine : la simple mention « origine frauduleuse » ne suffit pas.\n\n"
                "Il n’y a pas recel si l’on a cru (à tort) que le bien provenait d’un crime/délit, ou si les éléments de l’infraction d’origine ne sont pas réunis. "
                "Si l’incrimination de l’infraction d’origine est abrogée, le recel disparaît juridiquement.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : banqueroute simple fondée sur un texte abrogé → absence d’infraction originaire, recel non constitué ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 17 mai 1989)",
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
                "D) Une infraction d’origine commise par un tiers",
              ),
              const _Paragraph(
                "L’auteur de l’infraction principale ne peut pas être poursuivi pour recel : l’infraction d’origine doit provenir d’un tiers. "
                "En revanche, un complice de l’auteur de l’infraction d’origine peut être poursuivi comme receleur (délit distinct).\n\n"
                "Si l’auteur de l’infraction d’origine échappe aux poursuites pour des raisons procédurales "
                "(immunité familiale, non identification, prescription), le recel peut néanmoins être poursuivi.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ================= III — Élément moral =================
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("Connaissance de l’origine frauduleuse"),
              const _Paragraph(
                "Le recel n’est punissable que si le receleur sait que la chose provient d’un crime ou d’un délit. "
                "Cette connaissance peut être déduite d’indices : dissimulation, achat à bas prix, absence de facture, "
                "objets de valeur proposés par des non-professionnels, etc.\n\n"
                "Il n’est pas nécessaire de connaître la nature exacte de l’infraction d’origine ni les circonstances précises. "
                "Le recel peut être constitué même si l’auteur de l’infraction d’origine est inconnu, décédé ou en fuite.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le recel peut être retenu même si l’auteur de l’infraction d’origine est demeuré inconnu ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 24 novembre 1964)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: " ou en fuite/décédé "),
                  TextSpan(
                    text: "(Cass. crim., 07 mai 1942)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Bonne foi appréciée au moment de la réception/transmission/profit. Pas de recel à conserver après avoir appris la provenance si la bonne foi existait lors de l’acquisition ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 24 novembre 1977 — arrêt Pelegrin)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Mauvaise foi caractérisée par l’expérience professionnelle d’un acheteur-revendeur d’occasion ayant omis d’inscrire des bijoux volés au registre de police ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 13 janvier 2016)",
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

          // ================= IV — Circonstances aggravantes =================
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 321-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : recel aggravé :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis de façon habituelle ou en utilisant les facilités que procure l’exercice d’une activité professionnelle.",
              ),
              const _BulletPoint(
                text: "Lorsqu’il est commis en bande organisée.",
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 321-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : si l’infraction d’origine est punie d’une peine privative de liberté supérieure à celle encourue au titre du recel (321-1/321-2), "
                      "le receleur encourt les peines attachées à l’infraction d’origine (et, si aggravations, celles dont il avait connaissance).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ================= V — Répression =================
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Recel simple : "),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 375 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 321-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Recel aggravé : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 750 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 321-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Article 321-3 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " : l’amende prévue aux articles 321-1 et 321-2 peut être élevée au-delà de 375 000 € jusqu’à la moitié de la valeur des biens recelés.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Article 321-4 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " : lorsque la peine de l’infraction d’origine est supérieure, les peines encourues sont celles attachées à l’infraction d’origine (et aggravations connues).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 321-12 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : responsabilité pénale possible. Peine d’amende et peines complémentaires (article 131-39 : dissolution, interdiction d’activité, fermeture d’établissement…).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(
                text:
                    "Tentative : OUI uniquement pour le recel aggravé qualifié crime.",
              ),
              const _Paragraph(
                "La tentative de recel simple n’est pas punissable (non prévue). En revanche, la tentative de recel criminel est punissable.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI — "),
                TextSpan(
                  text: "article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
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
