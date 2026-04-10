import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExtorsionPage extends StatelessWidget {
  const ExtorsionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/extorsion';

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
          "Infractions voisines du vol",
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
            "L’extorsion",
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
                "L’extorsion est le fait d’obtenir, par violence, menace de violences ou contrainte, "
                "soit une signature, un engagement ou une renonciation, soit la révélation d’un secret, "
                "soit la remise de fonds, de valeurs ou d’un bien quelconque.",
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
                  text: "Article 312-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : définit et réprime l’extorsion."),
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
              const _SubTitle(
                "A) Des moyens mis en œuvre (violence, menace ou contrainte)",
              ),
              const _Paragraph(
                "Il n’y a extorsion que si le comportement de la victime a été obtenu par violence, "
                "menace de violences ou contrainte. Si la remise résulte seulement de promesses fallacieuses, "
                "l’infraction n’est pas constituée.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : remise d’un véhicule de location et d’une carte bancaire après promesse de travail (pas d’extorsion). ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 27 juin 1997)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("1) Des violences"),
              const _Paragraph(
                "Sont visés tous procédés de contrainte physique privant la victime de sa liberté d’action "
                "et l’amenant à se dépouiller : coups et blessures, séquestration, brimades physiques, "
                "privation de soins ou de nourriture, etc.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : victime maintenue dans un état quasi grabataire et de dénuement. ",
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

              const SizedBox(height: 12),

              const _SubTitle("2) Des menaces de violences"),
              const _Paragraph(
                "Il s’agit de toute menace de violences, quelle qu’en soit la forme, dès lors qu’elle a "
                "permis la remise. Les menaces n’ont pas à être exécutées : leur formulation peut suffire.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Exemples jurisprudentiels : "),
                  TextSpan(
                    text:
                        "menaces d’égorger (C.A. Paris, 04 mai 1987) ; "
                        "pression sur un gérant pour reversement d’un pourcentage (Cass. crim., 4 novembre 1997) ; "
                        "menace avec matraque pour obtenir une somme supérieure à la dette (C.A. Grenoble, 24 mai 1996)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) Une contrainte morale"),
              const _Paragraph(
                "La contrainte est une force d’origine externe qui domine la volonté de la victime, "
                "ou suffisamment puissante pour lui enlever sa liberté d’esprit. Elle permet notamment de "
                "sanctionner les extorsions par menaces visant la situation matérielle de la victime ou d’un tiers.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les juges apprécient souverainement la contrainte (force de l’expression, crainte inspirée, vulnérabilité…). ",
                ),
                TextSpan(
                  text: "(Cass. crim., 03 octobre 1991)",
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
                  const TextSpan(
                    text:
                        "Exemples : menace faite à une mineure de mettre le feu au restaurant de ses parents ; intimidation par un acolyte impressionnant. ",
                  ),
                  TextSpan(
                    text:
                        "(C.A. Paris, 25 mai 1988 ; Cass. crim., 11 avril 1988)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Une remise par la victime"),
              const _Paragraph(
                "La remise est involontaire mais consciente : la victime joue un rôle actif en remettant la chose, "
                "même si elle y est contrainte. Sa collaboration résulte de la pression exercée.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Victime personne physique : pour l’extorsion de signature, la victime est le titulaire de la signature.",
              ),
              const _BulletPoint(
                text:
                    "Victime personne morale : une personne morale peut être victime d’extorsion ; elle peut aussi engager sa responsabilité pénale.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text: "Responsabilité pénale des personnes morales : ",
                ),
                TextSpan(
                  text: "article 121-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: ". Peines applicables : "),
                TextSpan(
                  text: "article 312-15 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("C) L’objet de la remise"),
              const _Paragraph(
                "L’extorsion peut porter sur : une signature, un engagement ou une renonciation, la révélation d’un secret, "
                "ou la remise de fonds/valeurs/bien quelconque.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Une signature"),
              const _BulletPoint(
                text:
                    "L’infraction est constituée par le seul fait de contraindre une personne à signer (même une feuille blanche).",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : pressions d’un supérieur hiérarchique pour obtenir la signature d’une subordonnée. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 16 octobre 2002)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Un engagement ou une renonciation"),
              const _Paragraph(
                "Sont visés les actes écrits (contrats, quittances, reçus, démissions, mainlevées…) "
                "ou des engagements non écrits, y compris non patrimoniaux.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudences : séquestrer un inspecteur du travail pour obtenir l’engagement écrit de ne pas dresser PV ; "
                        "renoncer à dénoncer des surfacturations illicites. ",
                  ),
                  TextSpan(
                    text:
                        "(Cass. crim., 09 janvier 1991 ; Cass. crim., 28 novembre 2001)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) La révélation d’un secret"),
              const _Paragraph(
                "Le secret s’entend largement : secrets de la vie privée, secrets professionnels, "
                "secrets de correspondance ou secrets des affaires. Il peut s’agir du secret personnel ou d’autrui.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("4) Fonds, valeurs ou bien quelconque"),
              const _Paragraph(
                "Les « fonds et valeurs » comprennent valeurs mobilières, effets de commerce et instruments de paiement "
                "(billets, chèques, carte bancaire ou code, mandats…). Le « bien quelconque » vise tout bien susceptible "
                "d’appropriation (mobilier/immobilier), avec ou sans valeur économique, y compris des biens incorporels exploitables.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : remise sous la violence d’une carte de crédit avec le code. ",
                  ),
                  TextSpan(
                    text: "(C.A. Bordeaux, 18 octobre 1989)",
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
                        "L’objet doit être suffisamment déterminé : exiger un « dédommagement » trop imprécis ne suffit pas. ",
                  ),
                  TextSpan(
                    text: "(C.A. Paris, 16 avril 1993)",
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
              const _Paragraph(
                "L’extorsion est une infraction intentionnelle : l’auteur doit vouloir obtenir ce qui ne peut "
                "être librement consenti en usant de procédés contraignants.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Définition jurisprudentielle : "),
                TextSpan(
                  text:
                      "« conscience d’obtenir par la force, la violence ou la contrainte ce qui n’aurait pu être obtenu par un accord librement consenti »",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: _lawRed,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(
                  text: "(Cass. crim., 09 janvier 1991)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les mobiles sont indifférents (même pour obtenir ce qui serait dû). ",
                ),
                TextSpan(
                  text: "(Cass. crim., 23 mars 2016)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
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
              const _SubTitle("A) Extorsion aggravée délictuelle"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Violences sur autrui (précédée, accompagnée ou suivie) ayant entraîné une I.T.T. ≤ 8 jours.",
              ),
              const _BulletPoint(
                text:
                    "Au préjudice d’une personne vulnérable (âge, maladie, infirmité, déficience physique/psychique, grossesse), vulnérabilité apparente ou connue.",
              ),
              const _BulletPoint(
                text:
                    "Auteur dissimulant volontairement tout ou partie du visage pour ne pas être identifié.",
              ),
              const _BulletPoint(
                text:
                    "Dans un établissement d’enseignement/éducation ou aux abords immédiats lors des entrées/sorties des élèves.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Extorsion aggravée criminelle"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : violences avec I.T.T. > 8 jours."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : violences avec mutilation ou infirmité permanente.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-5 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : usage ou menace d’une arme, ou auteur porteur d’une arme soumise à autorisation / port prohibé.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : bande organisée (et variantes avec violences graves / arme).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : violences ayant entraîné la mort ou tortures/actes de barbarie.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si les violences sont commises pour favoriser la fuite ou assurer l’impunité : extorsion suivie de violences. ",
                  ),
                  TextSpan(
                    text: "(article 312-8 du Code pénal)",
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

          // Répression + tentative/complicité + immunité + exemption/réduction
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — aperçu"),
              _Paragraph.rich([
                const TextSpan(text: "Extorsion simple (délit) : "),
                const TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 312-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Extorsion aggravée délictuelle : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 150 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 312-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Extorsion aggravée criminelle : peines de réclusion (15 ans, 20 ans, 30 ans, perpétuité) selon la circonstance. — ",
                ),
                TextSpan(
                  text: "articles 312-3 à 312-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Peines applicables aux personnes morales : ",
                ),
                TextSpan(
                  text: "article 312-15 du Code pénal",
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
                  text: "article 312-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (commencement d’exécution + absence de consommation pour circonstances indépendantes).",
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Jurisprudence : la fixation d’un rendez-vous peut constituer un début d’exécution. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 17 février 1998)",
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
                const TextSpan(text: "Complicité : OUI — "),
                TextSpan(
                  text: "article 121-7 du Code pénal",
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

              const _SubTitle("Immunité familiale"),
              _Paragraph.rich([
                const TextSpan(text: "Immunité familiale : OUI — "),
                TextSpan(
                  text: "article 312-9 du Code pénal",
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
                const TextSpan(
                  text: " (ascendants/descendants ; conjoint sauf séparation).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Exception",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’immunité n’est pas retenue si l’extorsion porte sur des objets/documents indispensables à la vie quotidienne (documents d’identité, titre de séjour, moyens de paiement, télécommunication) ou si l’auteur est tuteur/curateur/mandataire de protection. ",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "Exemption & réduction de peine (bande organisée)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-6-1 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : exemption de peine si l’auteur avertit l’autorité et permet d’éviter la réalisation de l’infraction.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 312-6-1 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réduction des deux tiers si l’avertissement permet de faire cesser l’infraction/éviter mort ou infirmité/permettre d’identifier les autres auteurs ou complices (perpétuité ramenée à 20 ans).",
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
