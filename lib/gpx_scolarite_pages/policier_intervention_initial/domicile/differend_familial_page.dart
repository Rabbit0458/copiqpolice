import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DifferendFamilialPage extends StatelessWidget {
  const DifferendFamilialPage({super.key});

  static const String routeName =
      '/gpx/intervention/domicile/differend-familial';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Domicile",
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
            "Le différend familial",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition + objectif de l’intervention
          _ConditionCard(
            title: "Définition & objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le différend familial correspond à une querelle, une dispute ou une altercation violente "
                "entre personnes d’une même cellule familiale (mariés, concubins, partenaires PACS, "
                "ascendants/descendants…).\n\n"
                "L’intervention des policiers doit être conduite avec tact et discernement : "
                "ramener le calme, protéger les victimes, et prévenir la répétition des violences.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (bases juridiques citées dans ton texte)
          _ConditionCard(
            title: "I — Élément légal (bases citées)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 59 alinéa 1 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : permet l’introduction dans un domicile en cas de réclamation faite de l’intérieur "
                      "(appels au secours / sollicitation d’entrer), dès lors que la gravité est établie.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 223-6 alinéa 2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réprime le manquement volontaire à l’obligation de porter assistance à une personne en péril.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 10-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : impose l’information des victimes (dont violences au sein du couple / mariage forcé) "
                      "sur leurs droits, notamment la possibilité de demander une ordonnance de protection.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 220-1 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : prévoit pour une victime mariée la possibilité d’obtenir l’expulsion du domicile conjugal "
                      "pour le conjoint violent (juge aux affaires familiales).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 311-12 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : immunité du vol entre époux, qui ne s’applique pas lorsque le vol porte sur des objets/documents indispensables "
                      "(papiers d’identité, moyens de paiement, titres de séjour/résidence, moyen de télécommunication…).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le différend familial n’est pas une infraction unique : il s’agit d’une situation opérationnelle. "
                        "La qualification dépend de ce qui est constaté (absence d’atteinte / violences / menaces / infractions connexes).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3 éléments (version “pédagogique” adaptée à une situation type : violences)
          _ConditionCard(
            title: "II — 3 éléments (qualification pénale : violences)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Élément légal"),
              _Paragraph(
                "Les violences (notamment au sein du couple ou du foyer) relèvent du domaine délictuel. "
                "La qualification exacte dépend des constatations (nature des violences, contexte familial, vulnérabilité, ITT, usage d’arme…).",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Élément matériel"),
              _Paragraph(
                "Les violences peuvent prendre différentes formes :\n"
                "• Contact direct (gifle, coup, bousculade…)\n"
                "• Contact via une arme ou un animal lancé volontairement\n"
                "• Actes sans contact mais provoquant un choc émotionnel ou un trouble psychologique "
                "(ex. tirer dans la direction d’une personne pour l’effrayer sans la toucher).",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Élément moral"),
              _Paragraph(
                "L’auteur agit volontairement : il doit avoir conscience de ses actes. "
                "En intervention, la prise en compte de la dangerosité, des menaces, de l’alcoolisation, "
                "d’éventuels antécédents et de la répétition est essentielle.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes (pédagogique : couple / mineur / vulnérabilité)
          _ConditionCard(
            title: "III — Circonstances aggravantes (repères)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Certaines situations aggravent fortement les suites pénales lorsqu’il s’agit de violences :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Violences au sein du couple : toujours délictuelles, quelle que soit la durée de l’ITT.",
              ),
              _BulletPoint(
                text:
                    "Violences sur mineur de 15 ans : relèvent toujours du domaine délictuel, indépendamment de l’ITT.",
              ),
              _BulletPoint(
                text:
                    "Violences sur ascendant : relèvent toujours du domaine délictuel, indépendamment de l’ITT.",
              ),
              _BulletPoint(
                text:
                    "Victime vulnérable (âge, maladie, infirmité, déficience physique/psychique…) : relèvent toujours du domaine délictuel, indépendamment de l’ITT.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Le document rappelle aussi que des sanctions sont aggravées dans le couple pour certaines infractions "
                "(tortures/barbarie, violences ayant entraîné la mort sans intention de la donner, meurtre, viol, agression sexuelle, etc.).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité (rendu clean, sans inventer d’articles)
          _ConditionCard(
            title: "IV — Tentative & complicité (repères)",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Tentative"),
              _Paragraph(
                "À apprécier selon l’infraction finalement retenue (contravention / délit / crime) et selon les textes applicables. "
                "En intervention, l’essentiel est de sécuriser, constater et qualifier précisément les faits.",
              ),
              SizedBox(height: 12),
              _SubTitle("Complicité"),
              _Paragraph(
                "Peut être retenue lorsque des personnes ont aidé/assisté l’auteur (ou facilité l’infraction), "
                "selon les conditions légales propres à l’infraction visée.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intervention - MRO + tactique
          _ConditionCard(
            title: "V — Conduite de l’intervention (MRO)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Tout policier intervenant sur un différend familial doit appliquer la Méthode de Raisonnement Opérationnel (MRO) :\n"
                "• Analyse de la situation\n"
                "• Cadre juridique\n"
                "• Tactique d’action",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Vigilance maximale : ne pas se positionner face à la porte.",
              ),
              _BulletPoint(
                text:
                    "Si la porte s’ouvre : expliquer le motif, demander l’autorisation d’entrer.",
              ),
              _BulletPoint(
                text:
                    "À l’intérieur : observer, sécuriser (écarter objets dangereux), séparer les protagonistes, entendre séparément si possible.",
              ),
              _BulletPoint(
                text:
                    "Si règlement impossible : inviter à venir au service, proposer des orientations et organismes d’assistance.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En cas de prise d’otages ou menace de suicide : différer l’intervention, sécuriser les abords, empêcher le public d’approcher, faciliter l’arrivée des renforts et personnels spécialisés.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Recueil d’infos (avant départ)
          _ConditionCard(
            title: "VI — Recueil d’informations (avant l’arrivée)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le service qui reçoit l’appel doit recueillir un maximum d’informations :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Adresse précise (code d’accès, numéro, étage).",
              ),
              _BulletPoint(
                text: "Personnes impliquées (nombre, présence d’enfants).",
              ),
              _BulletPoint(text: "Configuration du logement."),
              _BulletPoint(text: "Degré de gravité / urgence."),
              _BulletPoint(
                text: "Danger immédiat (arme, surexcitation, chien…).",
              ),
              _BulletPoint(text: "Alcool / toxicomanie."),
              _BulletPoint(text: "Éventuels précédents."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le requérant ne doit pas être conduit sur les lieux, ni être vu par les protagonistes.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre juridique + suites
          _ConditionCard(
            title: "VII — Cadre juridique & suites",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "La majorité des interventions de différends familiaux s’effectuent dans le cadre du flagrant délit.\n\n"
                "Priorité : protéger la victime et les enfants, empêcher de nouveaux actes, puis apprécier les suites pénales "
                "(interpellation en flagrance si violences caractérisées, avis OPJ immédiat).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "En cas de plainte : "),
                  TextSpan(
                    text: "article 10-2 du Code de procédure pénale",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " : information des victimes sur leurs droits (dont ordonnance de protection) et sur les peines encourues.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "La victime peut quitter le domicile conjugal (les violences justifient le départ). "
                "Pour préserver ses droits, elle peut déposer une main courante. "
                "Elle peut aussi demander une domiciliation au service enquêteur (adresse non communiquée).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Victime mariée : possibilité d’expulsion du conjoint violent — ",
                ),
                TextSpan(
                  text: "article 220-1 du Code civil",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "En cas de retrait de plainte : seul le procureur de la République décide de poursuivre ou non.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Devoirs comportementaux
          _ConditionCard(
            title: "VIII — Devoirs comportementaux des policiers",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Neutralité & absence de jugement"),
              _Paragraph(
                "Faire preuve d’impartialité, éviter tout parti pris et ne pas générer de tensions supplémentaires. "
                "La prise en compte de la victime doit être professionnelle : une victime peut être vulnérable, dépendante financièrement "
                "et connaître des revirements.",
              ),
              SizedBox(height: 12),
              _SubTitle("Information à délivrer à la victime"),
              _BulletPoint(
                text:
                    "Un dépôt de plainte n’entraîne pas automatiquement l’incarcération : d’autres mesures peuvent être décidées par l’autorité judiciaire.",
              ),
              _BulletPoint(
                text:
                    "Le mis en cause peut être poursuivi même sans plainte ou en cas de retrait de plainte.",
              ),
              _BulletPoint(
                text:
                    "Le dépôt de plainte n’entraîne pas automatiquement le placement des enfants.",
              ),
              _BulletPoint(
                text:
                    "Le conjoint violent peut être évincé du domicile sur décision du juge aux affaires familiales.",
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
