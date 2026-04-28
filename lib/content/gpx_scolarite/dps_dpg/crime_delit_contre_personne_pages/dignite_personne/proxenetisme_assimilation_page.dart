import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProxenetismeAssimilationPage extends StatelessWidget {
  const ProxenetismeAssimilationPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/proxenetisme_assimilation';

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
            "Le proxénétisme par assimilation",
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
                "Est assimilé au proxénétisme et constitue une infraction le fait, par quiconque, de quelque manière que ce soit :",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "1° De faire office d’intermédiaire entre deux personnes dont l’une se livre à la prostitution et l’autre exploite ou rémunère la prostitution d’autrui.",
              ),
              _IntroBullet(
                text:
                    "2° De faciliter à un proxénète la justification de ressources fictives.",
              ),
              _IntroBullet(
                text:
                    "3° De ne pouvoir justifier de ressources correspondant à son train de vie tout en vivant avec une personne se livrant habituellement à la prostitution, ou en étant en relations habituelles avec une ou plusieurs personnes se livrant à la prostitution.",
              ),
              _IntroBullet(
                text:
                    "4° D’entraver l’action de prévention, de contrôle, d’assistance ou de rééducation entreprise par les organismes qualifiés à l’égard de personnes en danger de prostitution ou se livrant à la prostitution.",
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
                  text: "Article 225-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : définit le proxénétisme par assimilation.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 225-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réprime le proxénétisme (dont le proxénétisme par assimilation).",
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
              _Paragraph.rich([
                TextSpan(
                  text: "L’article 225-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " incrimine quatre comportements au titre du proxénétisme par assimilation.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("A) 1° — Faire office d’intermédiaire"),
              const _Paragraph(
                "Le délit est constitué lorsque l’agent s’interpose, de manière suffisamment caractérisée, pour susciter ou favoriser l’activité prostitutionnelle. "
                "Il peut s’agir d’une aide à la prostitution, d’une aide au proxénète, ou des deux selon le type d’entremise.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Condition : la personne se livrant à la prostitution doit déjà exercer cette activité au moment de l’entremise ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 22 septembre 1999)",
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
                        "Ce cas ne suppose pas l’habitude : un acte unique peut suffire ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 24 mai 1946)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle("Exemples jurisprudentiels"),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Sous couvert d’une agence matrimoniale, présenter des clients à des femmes avec lesquelles ils n’entretiennent que des relations passagères ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 20 novembre 1953)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Directeur de publication d’une revue / réseau télématique ayant diffusé des annonces publicitaires pour des activités prostitutionnelles ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 09 octobre 1996)",
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
                bodySpans: [
                  const TextSpan(
                    text:
                        "Tenancière servant d’intermédiaire entre clients et personnes se prostituant moyennant rémunération, condamnée sans preuve de rétribution personnelle ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 04 décembre 1958)",
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
                "B) 2° — Faciliter la justification de ressources fictives",
              ),
              const _Paragraph(
                "Il s’agit d’une forme particulière de complicité assimilée au proxénétisme : fournir des documents falsifiés, attestations de complaisance, "
                "faux témoignages, voire des emplois fictifs, afin de permettre au proxénète de justifier son train de vie.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Lorsque l’aide vise à soutenir un proxénète poursuivi, c’est cette incrimination spécifique qui doit s’appliquer plutôt que le faux « général » ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 19 juin 1960)",
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
                "C) 3° — Non-justification de ressources (train de vie)",
              ),
              const _Paragraph(
                "La loi présume que l’agent tire profit de la prostitution d’autrui lorsqu’il ne peut justifier des ressources correspondant à son train de vie. "
                "Deux conditions doivent être réunies.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("1) Cohabitation ou relations habituelles"),
              const _Paragraph(
                "La vie commune ne suppose pas le mariage : une simple cohabitation peut suffire. "
                "Mais la cohabitation seule ne caractérise pas l’infraction : c’est l’absence de justification du train de vie qui déclenche la présomption.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Les « relations habituelles » permettent de poursuivre des proxénètes qui ne cohabitent pas : rencontres, visites, entrevues… "
                "À condition qu’elles soient régulières et établies.",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : délit retenu pour un individu conduisant sa maîtresse sur les lieux de son activité ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 01 avril 1992)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle("2) Impossibilité de justifier son train de vie"),
              const _Paragraph(
                "L’auteur doit être dans l’impossibilité de démontrer des ressources personnelles correspondant à son train de vie. "
                "La preuve doit être complète et porter sur l’ensemble des dépenses (hôtel, restaurant, véhicule, vêtements, logement, jeux, courses, casinos, etc.).",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "D) 4° — Entraver l’action de prévention/assistance/rééducation",
              ),
              const _Paragraph(
                "Cette incrimination permet de combattre les interventions des proxénètes visant à empêcher les actions de reclassement, "
                "de prévention ou de réadaptation (pressions, menaces, manœuvres, etc.).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "L’expression « de quelque manière que ce soit » n’est pas limitative. Sont visées des personnes physiques rattachées à des organismes ou services sociaux, "
                "ainsi que des anciennes prostituées ou des personnes en danger de prostitution.",
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
                "L’intention coupable est exigée : l’auteur agit en connaissance de cause. "
                "Il sait qu’il fait office d’intermédiaire, qu’il facilite des ressources fictives, "
                "qu’il profite du produit de la prostitution d’autrui (train de vie injustifié), "
                "ou qu’il entrave une action de prévention / réadaptation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes (liste pédagogique + degrés)
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Proxénétisme par assimilation aggravé (délit) — article 225-7 du Code pénal",
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
                    "Lorsqu’il est commis à l’égard d’une personne dont la particulière vulnérabilité (âge, maladie, infirmité, déficience physique/psychique, grossesse) est apparente ou connue de l’auteur.",
              ),
              const _BulletPoint(
                text: "Lorsqu’il est commis à l’égard de plusieurs personnes.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis à l’égard d’une personne incitée à se livrer à la prostitution hors du territoire de la République ou à son arrivée sur le territoire.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis par un ascendant (légitime/naturel/adoptif) ou par une personne ayant autorité sur la personne se prostituant, ou abusant de l’autorité que lui confèrent ses fonctions.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis par une personne appelée, de par ses fonctions, à participer à la lutte contre la prostitution, à la protection de la santé ou au maintien de l’ordre public.",
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
                    "Lorsqu’il est commis par plusieurs personnes agissant en qualité d’auteur ou de complice, sans constituer une bande organisée.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il est commis grâce à l’utilisation d’un réseau de communication électronique pour diffuser des messages à destination d’un public non déterminé.",
              ),
              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text:
                      "Proxénétisme par assimilation aggravé criminel — article 225-7-1 du Code pénal",
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
                  text: "article 225-6 du Code pénal",
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
                      " (peine réduite des deux tiers si l’auteur/complice avertit l’autorité et permet de faire cesser l’infraction, d’éviter un dommage irréversible "
                      "ou d’identifier les autres auteurs/complices ; si la peine encourue est la perpétuité, elle est ramenée à 20 ans).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "À retenir",
                bodySpans: const [
                  TextSpan(
                    text:
                        "La loi distingue :\n"
                        "• l’exemption : dénonciation au stade de la tentative + action permettant d’éviter l’infraction.\n"
                        "• la réduction : dénonciation après commission pour faire cesser les faits / éviter un dommage irréversible / identifier les auteurs ou complices.",
                  ),
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
