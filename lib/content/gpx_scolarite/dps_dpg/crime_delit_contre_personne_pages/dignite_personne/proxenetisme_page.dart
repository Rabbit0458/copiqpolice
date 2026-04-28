import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProxenetismePage extends StatelessWidget {
  const ProxenetismePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/proxenetisme';

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
          "Atteintes à la dignité",
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
            "Le proxénétisme",
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
                "Constitue l’infraction de proxénétisme le fait, par quiconque, de quelque manière que ce soit :",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "1° D’aider, d’assister ou de protéger la prostitution d’autrui.",
              ),
              _IntroBullet(
                text:
                    "2° De tirer profit de la prostitution d’autrui, d’en partager les produits ou de recevoir des subsides d’une personne se livrant habituellement à la prostitution.",
              ),
              _IntroBullet(
                text:
                    "3° D’embaucher, d’entraîner ou de détourner une personne en vue de la prostitution, ou d’exercer sur elle une pression pour qu’elle se prostitue ou continue à le faire.",
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
                  text: "Article 225-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : définit et réprime le proxénétisme."),
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
              const _SubTitle("A) La notion de prostitution"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La Cour de cassation a défini la prostitution comme l’activité consistant, moyennant rémunération, "
                      "à se prêter à des contacts physiques (de quelque nature qu’ils soient) afin de satisfaire les besoins sexuels d’autrui ",
                ),
                TextSpan(
                  text: "(Cass. crim., 26 mars 1996)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le droit français n’incrimine pas la prostitution en elle-même, mais combat ceux qui la favorisent ou en tirent profit.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Les 3 situations visées par l’article 225-5"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " retient trois comportements :"),
              ]),
              const SizedBox(height: 10),

              const _SubTitle(
                "1) Aide, assistance ou protection de la prostitution d’autrui",
              ),
              const _Paragraph(
                "Les notions d’aide et d’assistance sont proches de la complicité, mais elles doivent être visées ici car la prostitution n’est pas répréhensible : "
                "il n’y a donc pas de « complicité de prostitution » possible.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La protection peut s’entendre comme une surveillance ou des interventions directes autour des lieux de prostitution. "
                "L’aide/assistance/protection doivent correspondre à une participation active, réelle, matérielle et personnelle.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La jurisprudence exige un acte positif (la simple tolérance ou abstention ne suffit pas). "
                "C’est un délit instantané : aucune habitude n’est requise.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Jurisprudences : "),
                  TextSpan(
                    text:
                        "conduire en voiture une femme sur les lieux de prostitution puis la ramener (C.A. Bordeaux, 18 nov. 1992 ; C.A. Aix-en-Provence, 25 mai 1998)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  TextSpan(
                    text:
                        "Mettre son véhicule à disposition pour que l’autre s’y livre à la prostitution (Cass. crim., 12 oct. 1994)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  TextSpan(
                    text:
                        "Publier des annonces racoleuses et laisser l’usage de lignes téléphoniques (C.A. Paris, 19 déc. 1990)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("2) Bénéficier de la prostitution d’autrui"),
              const _Paragraph(
                "La loi vise largement : quiconque connaît la provenance des fonds peut être mis en cause (conjoint, concubin, personne ayant sous sa coupe plusieurs personnes, etc.), "
                "à l’exception des enfants mineurs à charge de la personne se prostituant.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "C’est une infraction instantanée : un acte unique de profit/partage/acceptation de subsides suffit. "
                "Le terme « habituellement » concerne la prostitution (et non l’auteur du proxénétisme).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("a) Tirer profit"),
              const _Paragraph(
                "Permet notamment d’incriminer une communauté de vie lorsque le train de vie est rendu possible par la prostitution de l’autre.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("b) Partager les produits"),
              const _Paragraph(
                "Les « produits » couvrent tous avantages pécuniaires et biens/prestations acquis grâce aux gains (loyer, vêtements, dons en nature, etc.). "
                "Le proxénète doit savoir que ces avantages proviennent de la prostitution.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("c) Recevoir des subsides"),
              const _Paragraph(
                "Suppose la remise d’argent (main à main, bancaire, postal). "
                "Ici, la personne versant les subsides doit se livrer habituellement à la prostitution (à la différence du partage où une prostitution occasionnelle peut suffire).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("3) Incitation à la prostitution"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-5 3° du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : incrimine le fait d’embaucher, d’entraîner ou de détourner une personne en vue de la prostitution, ou d’exercer des pressions pour qu’elle se prostitue ou continue.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le texte est très large : il n’exige ni habitude, ni profit, ni même que la personne se soit effectivement prostituée.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("a) Embaucher"),
              const _Paragraph(
                "Engager une personne pour une activité qui la conduira à la prostitution. L’embauche suppose un accord ; à défaut, on se situe plutôt dans l’entraînement ou le détournement.",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Jurisprudence : "),
                  TextSpan(
                    text:
                        "recruter par annonces des jeunes femmes pour des actes à caractère sexuel (massages « spéciaux ») (Cass. crim., 15 avril 1975)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle("b) Entraîner"),
              const _Paragraph(
                "Emmener une personne et la conduire dans un lieu déterminé pour qu’elle se livre à la prostitution : cela peut résulter d’une série d’actes (séduction) ou d’un acte unique brutal (enlèvement).",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Jurisprudence : "),
                  TextSpan(
                    text:
                        "conduire une femme dans des foyers d’immigration en vue de la prostitution (C.A. Metz, 14 septembre 1989)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle("c) Détourner"),
              const _Paragraph(
                "Influencer psychologiquement une personne ayant une vie considérée comme normale, pour la convaincre de se prostituer.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("d) Exercer des pressions"),
              const _Paragraph(
                "Correspond aux menaces/pressions pour qu’une personne se prostitue ou continue.",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Jurisprudence : "),
                  TextSpan(
                    text:
                        "séquestrer une femme pour la convaincre d’accepter la prostitution (Cass. crim., 22 janvier 1963)",
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
            children: const [
              _Paragraph(
                "Le proxénétisme est une infraction intentionnelle : l’auteur agit en pleine connaissance de cause. "
                "Il sait qu’il favorise la prostitution d’autrui (aide/assistance/protection), qu’il profite ou partage des produits, "
                "ou qu’il reçoit des subsides provenant de la prostitution. Il a également conscience d’inciter ou de faire pression pour amener à la prostitution.",
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
                  text:
                      "Proxénétisme aggravé (délit) — article 225-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text: "Lorsqu’il est commis à l’égard d’un mineur.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis à l’égard d’une personne vulnérable (âge, maladie, infirmité, déficience physique/psychique, grossesse), vulnérabilité apparente ou connue.",
              ),
              const _BulletPoint(
                text: "Lorsqu’il est commis à l’égard de plusieurs personnes.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis à l’égard d’une personne incitée à se livrer à la prostitution hors du territoire ou à son arrivée sur le territoire.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis par un ascendant ou une personne ayant autorité sur la personne se prostituant, ou abusant de l’autorité que lui confèrent ses fonctions.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis par une personne participant, de par ses fonctions, à la lutte contre la prostitution, à la protection de la santé ou au maintien de l’ordre public.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis par une personne porteuse d’une arme.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis avec contrainte, violences ou manœuvres dolosives (agissements trompeurs).",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis par plusieurs auteurs/complices, sans constituer une bande organisée.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis via un réseau de communication électronique pour diffuser des messages à un public non déterminé.",
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Proxénétisme aggravé criminel — article 225-7-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsqu’il est commis à l’égard d’un mineur de quinze ans.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsque le proxénétisme aggravé (225-7) est commis en bande organisée.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsqu’il est commis en recourant à des tortures ou des actes de barbarie.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + exemption
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                const TextSpan(text: "Simple (délit) : "),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 150 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 225-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (1er degré) : "),
                const TextSpan(
                  text:
                      "10 ans d’emprisonnement et 1 500 000 € d’amende (+ période de sûreté) — ",
                ),
                TextSpan(
                  text: "article 225-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (2e degré) : "),
                const TextSpan(
                  text: "20 ans de réclusion et 3 000 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 225-7-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (3e degré) — bande organisée : ",
                ),
                const TextSpan(
                  text:
                      "20 ans de réclusion et 3 000 000 € d’amende (+ période de sûreté) — ",
                ),
                TextSpan(
                  text: "article 225-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text: "Aggravée (4e degré) — tortures/barbarie : ",
                ),
                const TextSpan(
                  text:
                      "réclusion criminelle à perpétuité et 4 500 000 € d’amende (+ période de sûreté) — ",
                ),
                TextSpan(
                  text: "article 225-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Nota",
                bodySpans: [
                  const TextSpan(
                    text:
                        "La loi française est applicable lorsque le proxénétisme à l’égard d’un mineur est commis à l’étranger par un Français ou une personne résidant habituellement en France — ",
                  ),
                  TextSpan(
                    text: "article 225-11-2 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 225-12 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ; amende selon "),
                TextSpan(
                  text: "l’article 131-38 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " + peines prévues par "),
                TextSpan(
                  text: "l’article 131-39 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ", ainsi que "),
                TextSpan(
                  text: "les articles 225-24 et 225-25 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (confiscations, dissolution, interdictions professionnelles, etc.).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                const TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 225-11 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI — "),
                TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " (aide/assistance, provocation, instructions).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Exemption & réduction de peine"),
              _Paragraph.rich([
                const TextSpan(text: "Exemption de peine : OUI — "),
                TextSpan(
                  text: "article 225-11-1 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (avertir l’autorité administrative ou judiciaire et permettre d’éviter la réalisation de l’infraction).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Réduction de peine : OUI — "),
                TextSpan(
                  text: "article 225-11-1 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (peine réduite des deux tiers si l’auteur/complice avertit l’autorité et permet de faire cesser l’infraction, d’éviter la mort/infirmité permanente, "
                      "ou d’identifier les autres auteurs/complices ; si la peine encourue est la perpétuité, elle est ramenée à 20 ans).",
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
