import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SansDangerDommageImportantPage extends StatelessWidget {
  const SansDangerDommageImportantPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations/sans_danger_dommage_important';

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
          "Destructions / Dégradations",
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
            "Destruction, dégradation et détérioration sans danger pour les personnes\net entraînant un dommage important",
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
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La destruction, la dégradation ou la détérioration d’un bien appartenant à autrui constitue une infraction, "
                "lorsqu’elle ne présente pas un danger pour les personnes et entraîne un dommage important.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigé)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-1 I du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : définit et réprime les destructions, dégradations ou détériorations ne présentant pas un danger pour les personnes et entraînant un dommage important.",
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
              const _SubTitle("A) Une atteinte matérielle"),
              const _Paragraph(
                "Le texte ne précise pas les moyens employés : en principe, n’importe quel moyen peut être utilisé. "
                "Sont toutefois exclus les modes faisant l’objet de textes particuliers (ex. incendie, substances explosives).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("B) Sur un bien appartenant à autrui"),
              const _Paragraph(
                "La notion de « bien appartenant à autrui » est entendue largement. Certains biens bénéficient néanmoins "
                "d’une protection spécifique (ex. sabotage, biens sous scellés, biens déposés dans un dépôt public, etc.).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("1) Les biens immobiliers"),
              const _Paragraph(
                "Sont notamment visées les constructions (bâtiments, maisons), quels que soient les matériaux et la valeur. "
                "Peu importe qu’elles soient en chantier, à condition que l’état d’avancement permette de distinguer une véritable construction.\n"
                "Exemples : ouvrages de transport d’énergie, mobilier urbain, routes/chaussées, station de métro, etc.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2) Les biens mobiliers"),
              const _Paragraph(
                "Sont concernés les objets utilisés dans la vie courante : meubles, vêtements, bijoux, documents utiles aux affaires, "
                "véhicules et moyens de transport.",
              ),

              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La loi n° 2015-177 du 16/02/2015 précise que les animaux sont des êtres vivants doués de sensibilité. ",
                  ),
                  TextSpan(
                    text: "(article 515-14 du Code civil)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " — ils ne sont donc plus assimilés à de simples objets.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("3) L’appartenance du bien"),
              const _Paragraph(
                "Le bien détruit, dégradé ou détérioré doit appartenir à une autre personne que l’auteur. "
                "La jurisprudence peut toutefois retenir l’infraction à l’encontre d’un propriétaire ne disposant pas de la pleine et entière propriété "
                "(ex. copropriétaire détruisant un élément commun).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("C) Entraînant un dommage important"),
              _Paragraph.rich([
                const TextSpan(text: "Le "),
                TextSpan(
                  text: "texte de l’article 322-1 I du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " vise trois résultats : destruction, dégradation, détérioration. Le dommage doit être suffisamment important, "
                      "appréciation laissée au juge.",
                ),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1) La destruction"),
              const _Paragraph(
                "Acte le plus grave : le bien est rendu impropre à l’usage attendu. La destruction peut être totale ou partielle, "
                "dès lors que le bien devient inapte à rendre les services attendus.",
              ),

              const SizedBox(height: 10),

              const _SubTitle("2) La dégradation"),
              const _Paragraph(
                "Le bien voit ses qualités diminuées sans devenir inutilisable (ex. crever des pneumatiques, briser un carreau, arracher des essuie-glaces).",
              ),

              const SizedBox(height: 10),

              const _SubTitle("3) La détérioration"),
              const _Paragraph(
                "Actes moins graves : le bien perd de la valeur mais, après réparation, reste apte à remplir son rôle (ex. pièce de machine réparable).",
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
                "L’intention simple suffit : l’auteur est punissable s’il a agi sciemment et volontairement, "
                "en sachant ne pas être propriétaire du bien et ne pas avoir de droit de disposition.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "Référence jurisprudentielle : "),
                  TextSpan(
                    text: "Cass. crim., 18 septembre 1991",
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
                "Aucun dol spécial n’est exigé : peu importe que l’auteur ait voulu nuire ou poursuivre un but particulier. "
                "Le mobile est indifférent (vengeance, vandalisme, etc.).",
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
                  text: "Article 322-2 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : lorsque le bien détruit/dégradé/détérioré est un registre, une minute ou un acte original de l’autorité publique.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Sont notamment visés : registres d’état civil, minutes d’actes notariés, originaux d’actes, constats et procès-verbaux "
                "dressés par des officiers publics/ministériels ou des fonctionnaires habilités. "
                "La destruction peut intervenir n’importe où (pas forcément dans les locaux de l’autorité).",
              ),

              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 322-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : circonstances aggravantes notamment lorsque :",
                ),
              ]),
              const SizedBox(height: 8),

              const _BulletPoint(
                text:
                    "L’infraction est commise par plusieurs personnes agissant en qualité d’auteur ou de complice.",
              ),
              const _BulletPoint(
                text:
                    "Elle est facilitée par la particulière vulnérabilité d’une personne (âge, maladie, infirmité, déficience physique/psychique, grossesse), apparente ou connue.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise au préjudice de personnes dépositaires de l’autorité publique ou chargées d’une mission de service public, pour influencer leur comportement.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise au préjudice du conjoint/ascendant/descendant (ou personne vivant habituellement au domicile) des personnes visées ci-dessus, en raison de leurs fonctions.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise au préjudice d’un témoin, d’une victime ou d’une partie civile, pour empêcher/faire cesser une dénonciation, plainte ou déposition, ou en raison de celles-ci.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise dans un local d’habitation ou un lieu d’entrepôt de fonds/valeurs/marchandises/matériels, avec ruse, effraction ou escalade.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise à l’encontre d’un lieu classifié au titre du secret de la défense nationale.",
              ),
              const _BulletPoint(
                text:
                    "L’auteur dissimule volontairement tout ou partie de son visage afin de ne pas être identifié.",
              ),
              const _BulletPoint(
                text:
                    "Le bien est destiné à l’utilité ou à la décoration publique et appartient à une personne publique ou chargée d’une mission de service public (ex. mobilier urbain, fontaines, conduites de gaz, lignes électriques, panneaux, bâtiments d’utilité publique).",
              ),
              const _BulletPoint(
                text:
                    "Elle porte sur du matériel destiné à prodiguer des soins de premiers secours.",
              ),
              const _BulletPoint(
                text:
                    "Le bien détruit/dégradé/détérioré est destiné à la vaccination.",
              ),
              const _BulletPoint(
                text:
                    "Elle est commise à l’encontre d’un établissement scolaire/éducatif/de loisirs ou d’un véhicule transportant des enfants.",
              ),
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
                const TextSpan(text: "Qualification simple : "),
                const TextSpan(
                  text: "2 ans d’emprisonnement et 30 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 322-1 I du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Aggravée (une circonstance) : "),
                const TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 322-2 du Code pénal",
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
                      "Aggravée (deux circonstances prévues au 1° et suivants) : ",
                ),
                const TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 322-3 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Aggravation maximale mentionnée : 7 ans d’emprisonnement et 100 000 € d’amende (selon les cas prévus par le texte).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Les personnes morales encourent les peines prévues par ",
                ),
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
                  text: "article 322-4 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (prévoit expressément la tentative punissable pour ces délits).",
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Complicité : OUI. La complicité est punissable pour l’infraction consommée comme pour l’infraction tentée, "
                "si l’un des faits constitutifs de complicité est caractérisé et si l’intention de s’associer à l’action de l’auteur principal est établie.",
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
