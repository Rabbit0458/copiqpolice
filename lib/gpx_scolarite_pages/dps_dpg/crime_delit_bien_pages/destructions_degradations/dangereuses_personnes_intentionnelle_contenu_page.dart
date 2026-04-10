import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DestructionsDangereusesPersonnesIntentionnellePage
    extends StatelessWidget {
  const DestructionsDangereusesPersonnesIntentionnellePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations/dangereuses_personnes_intentionnelle';

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
          "Destructions, dégradations",
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
            "Les destructions, dégradations et détériorations dangereuses pour les personnes (infraction intentionnelle)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
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
                "La destruction, la dégradation ou la détérioration d’un bien appartenant à autrui "
                "par l’effet d’une substance explosive, d’un incendie ou de tout autre moyen "
                "de nature à créer un danger pour les personnes, constitue une infraction.",
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
                  text: "Article 322-6 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime les destructions, dégradations ou détériorations volontaires et dangereuses pour les personnes.",
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
              const _SubTitle(
                "A) Une atteinte matérielle de nature à créer un danger pour les personnes",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Les moyens employés sont précisés par "),
                TextSpan(
                  text: "l’article 322-6 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      ". Ils doivent être de nature à créer un danger pour les personnes.\n"
                      "Il suffit que l’intégrité physique des personnes ait été mise en danger (danger potentiel).",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Les moyens visés"),
              _NotaBox(
                title: "Idée clé",
                bodySpans: const [
                  TextSpan(
                    text:
                        "On recherche un moyen dangereux (explosion, incendie, ou tout autre procédé) + un bien atteint (détruit/dégradé/détérioré) + une mise en danger des personnes.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("1) L’effet d’une substance explosive"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " vise une substance explosive utilisée du fait de l’homme (pas un phénomène naturel). "
                      "Sont concernés les explosifs de toute nature (déflagration/détonation), de confection artisanale ou industrielle. "
                      "La présentation (cocktail Molotov, dynamite…) et le mode d’action importent peu.",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("2) L’incendie"),
              const _Paragraph(
                "L’incendie consiste à allumer un feu : provoquer une combustion rapide et brutale. "
                "Le commencement d’exécution recouvre la période allant des premiers actes accomplis sur place révélant l’intention coupable "
                "jusqu’au moment de l’embrasement du bien visé.\n"
                "L’incendie se distingue du simple feu par ses conséquences : il se propage, n’est pas maîtrisé et représente un danger pour les personnes. "
                "Pour cette raison, la qualification de l’article 322-6 est retenue plutôt que celle de 322-1.",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "3) Tout autre moyen de nature à créer un danger",
              ),
              const _Paragraph(
                "La formule doit s’entendre largement : dès lors que la sécurité des personnes est gravement mise en danger "
                "(ex. dérèglement volontaire du freinage d’un autocar, création d’une voie d’eau dans la coque d’un bateau, "
                "ou favorisation d’un phénomène type avalanche/éboulement…).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Sur un bien appartenant à autrui"),
              const _Paragraph(
                "La notion de « bien » est large : immeubles, véhicules, meubles, documents, forêts, bois… "
                "Le bien endommagé ou détruit doit appartenir à une autre personne que l’auteur.\n"
                "La jurisprudence peut retenir l’infraction même lorsque l’auteur a un droit limité sur le bien (ex. copropriétaire).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Entraînant un dommage"),
              const _Paragraph(
                "Le texte vise 3 résultats possibles : destruction, dégradation, détérioration.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Destruction : atteinte la plus grave, le bien devient impropre à l’usage (totale ou partielle).",
              ),
              const _BulletPoint(
                text:
                    "Dégradation : diminution des qualités du bien, sans le rendre inutilisable.",
              ),
              const _BulletPoint(
                text:
                    "Détérioration : atteinte moins grave, perte de valeur mais bien réparable et encore apte à son rôle.",
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
                "Agir en connaissant l’efficacité du moyen et le danger pour les personnes",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "La Cour de cassation considère que l’emploi d’une substance explosive ou de l’incendie caractérise suffisamment l’intention, "
                      "en raison du danger grave inhérent à ces moyens, dont chacun est censé connaître l’efficacité. ",
                ),
                TextSpan(
                  text: "(Cass. crim., 24 juin 1998)",
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-6 alinéa 2 du Code pénal",
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
                    "Incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui, dans des conditions exposant les personnes à un dommage corporel ou créant un dommage irréversible à l’environnement.",
              ),
              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Lorsqu’elle a entraîné pour autrui une ITT ≤ 8 jours.",
              ),
              const _BulletPoint(
                text:
                    "Lorsqu’il s’agit de l’incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui.",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-8 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Commission en bande organisée."),
              const _BulletPoint(text: "ITT > 8 jours."),
              const _BulletPoint(
                text:
                    "Commission en raison de la qualité (magistrat, militaire gendarmerie, fonctionnaire police nationale, douanes, administration pénitentiaire, dépositaire de l’autorité publique/mission de service public, sapeur-pompier/marin-pompier) du propriétaire ou utilisateur du bien.",
              ),
              const _BulletPoint(
                text:
                    "Incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui.",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-9 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Mutilation ou infirmité permanente."),
              const _BulletPoint(
                text:
                    "Incendie de bois, forêts, landes, maquis, plantations ou reboisements d’autrui.",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-10 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Mort d’autrui."),
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
                const TextSpan(text: "Infraction de base (délit) : "),
                const TextSpan(
                  text: "10 ans d’emprisonnement et 150 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 322-6 alinéa 1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les circonstances aggravantes (322-6 al.2, 322-7, 322-8, 322-9, 322-10) font basculer vers des peines criminelles "
                        "(réclusion 15 ans, 20 ans, 30 ans, voire perpétuité) selon le résultat (ITT, infirmité, décès) et le contexte (bande organisée, incendies de forêts…).",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Peines prévues par "),
                TextSpan(
                  text: "l’article 322-17 du Code pénal",
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
                  text: "article 322-11 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " prévoit la tentative punissable pour le délit de l’article 322-6.",
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Complicité : OUI. Elle est punissable au regard de l’infraction consommée comme tentée, "
                "si un fait de complicité est caractérisé et si l’intention de s’associer à l’action de l’auteur principal est démontrée.",
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
