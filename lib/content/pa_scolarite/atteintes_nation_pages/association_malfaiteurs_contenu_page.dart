import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAssociationMalfaiteursPage extends StatelessWidget {
  const PaAssociationMalfaiteursPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/association_malfaiteurs';

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
    final Color cardBonus = isDark
        ? const Color(0xFF1F1F1F)
        : const Color(0xFFF5F5FF);

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
    final Color accentIndigo = isDark
        ? const Color(0xFF9FA8DA)
        : const Color(0xFF303F9F);
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
          "Crime & délit — Nation",
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
            "La participation à une association de malfaiteurs",
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
                "Constitue une association de malfaiteurs tout groupement formé ou entente établie "
                "en vue de la préparation, caractérisée par un ou plusieurs faits matériels, "
                "d’un ou plusieurs crimes ou d’un ou plusieurs délits punis d’au moins cinq ans d’emprisonnement.",
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
                  text: "Article 450-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime l’association de malfaiteurs. "
                      "C’est une infraction formelle, indépendante des crimes/délits préparés ou commis.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Elle est retenue au stade des actes préparatoires : la « préparation » suffit, dès lors "
                "qu’elle est caractérisée par un ou plusieurs faits matériels.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’association de malfaiteurs est un délit autonome : elle se cumule avec l’infraction projetée/commise. "
                        "Cependant, les mêmes faits peuvent aussi caractériser une bande organisée. Dans ce cas, l’incrimination "
                        "d’association de malfaiteurs peut disparaître si la bande organisée est expressément prévue pour l’infraction poursuivie "
                        "(principe non bis in idem).",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("Jurisprudences"),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Cumul possible si faits distincts entre l’association de malfaiteurs et la bande organisée : ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 19 janvier 2010)",
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
                bodySpans: [
                  TextSpan(
                    text:
                        "Association distincte de la bande organisée si elle visait d’autres infractions que celles finalement tentées/commises : ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 9 mai 2019)",
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

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Une résolution d’agir en commun"),
              _Paragraph(
                "Le texte exige que les participants passent du stade purement intellectuel aux actes préparatoires : "
                "il ne suffit pas d’un échange d’opinions. L’entente est souvent tacite et se déduit des faits.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Passage aux actes préparatoires exigé : ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 29 janvier 1991)",
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
                "La jurisprudence retient l’entente au regard notamment :\n"
                "• des prises de contact, réunions, habitudes\n"
                "• de l’usage commun de véhicules\n"
                "• de la persistance de rassemblements\n"
                "• d’éléments issus de filatures ou d’écoutes\n"
                "• et surtout des actes préparatoires réalisés.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Réunions et prises de contact : "),
                  TextSpan(
                    text: "(Cass. crim., 4 mars 1992)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Débits de boissons fréquentés : "),
                  TextSpan(
                    text: "(Cass. crim., 30 mai 1988)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Filatures : "),
                  TextSpan(
                    text: "(Cass. crim., 6 septembre 1990)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(text: "Écoutes téléphoniques : "),
                  TextSpan(
                    text: "(Cass. crim., 20 février 1990)",
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
                "B) « Caractérisée par un ou plusieurs faits matériels »",
              ),
              _Paragraph(
                "Le législateur a voulu exclure le simple projet : sont visés les faits concrets "
                "(réunions où des renseignements s’échangent, plans élaborés, moyens d’action rassemblés).",
              ),

              SizedBox(height: 14),

              _SubTitle("C) Nombre de participants"),
              _Paragraph(
                "Peu importe le nombre : deux personnes suffisent. Peu importe aussi la durée de l’entente "
                "et le fait que certains membres ne soient pas identifiés.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Deux personnes organisant de concert une livraison d’héroïne (contacts fournisseur, véhicules, somme importante) : "
                        "faits matériels caractérisant l’association de malfaiteurs ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 3 juin 2004)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("D) La nécessité d’une organisation"),
              _Paragraph(
                "La preuve d’une organisation (direction, hiérarchie, répartition des rôles) aide à établir "
                "l’existence du groupement ou de l’entente.",
              ),

              SizedBox(height: 14),

              _SubTitle("E) Le but poursuivi"),
              _Paragraph(
                "L’entente est punissable si elle vise la préparation :\n"
                "• d’un ou plusieurs crimes, ou\n"
                "• d’un ou plusieurs délits punis d’au moins 5 ans d’emprisonnement.\n\n"
                "Les infractions projetées n’ont pas besoin d’être déjà déterminées avec précision.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Infractions pas nécessairement déterminées : ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 15 décembre 1993)",
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
              _SubTitle(
                "A) Intégration au groupement en connaissance de cause",
              ),
              _Paragraph(
                "Chaque participant doit s’être intégré à un groupement délictueux en connaissant ses buts "
                "et son caractère répréhensible.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Connaissance des buts et du caractère répréhensible : ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 28 février 2001)",
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
                "B) Volonté d’apporter un concours au groupement",
              ),
              _Paragraph(
                "La responsabilité est retenue si la personne agit avec la volonté d’apporter un concours efficace "
                "à la préparation du crime/délit projeté (ex. fournir des moyens matériels : armes, explosifs, etc.).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Concours matériel au groupement (armes/explosifs) : ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 2 juillet 1991)",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Aucune circonstance aggravante spécifique indiquée ici.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 450-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " : peines selon l’objet de l’entente."),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                "1) Lorsque l’entente vise un ou plusieurs délits (≥ 5 ans)",
              ),
              _BulletPoint(text: "5 ans d’emprisonnement."),
              _BulletPoint(text: "75 000 € d’amende."),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "article 450-1 (alinéa relatif au délit) du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                "2) Lorsque l’entente vise un ou plusieurs crimes",
              ),
              _BulletPoint(text: "10 ans d’emprisonnement."),
              _BulletPoint(text: "150 000 € d’amende."),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "article 450-1 (alinéa relatif au crime) du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("3) Hypothèse la plus grave (réclusion)"),
              _BulletPoint(text: "15 ans de réclusion."),
              _BulletPoint(text: "225 000 € d’amende."),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Fondement : "),
                TextSpan(
                  text: "article 450-1 (alinéa réclusion) du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 450-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : prévoit la responsabilité pénale des personnes morales.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les peines applicables aux personnes morales suivent les règles du Code pénal "
                        "(notamment amende et peines complémentaires selon les textes généraux).",
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text:
                    "Tentative : NON (la consommation intervient à un stade antérieur à la tentative ; aucun texte spécial ne la prévoit).",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Lecture pratique",
                bodySpans: [
                  TextSpan(
                    text:
                        "Il faut distinguer :\n"
                        "• la complicité de l’association de malfaiteurs (aider le groupement à naître / s’étendre / maintenir des contacts),\n"
                        "• et la complicité des infractions ensuite commises/tentées (si l’aide a servi à réaliser l’infraction décidée).\n\n"
                        "Chaque cas se traite en évitant le cumul interdit par le principe non bis in idem.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Exemption & réduction de peine
          _ConditionCard(
            title: "VI — Exemption & réduction de peine",
            cardColor: cardBonus,
            accent: accentIndigo,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 450-2 alinéa 1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : exemption de peine si la personne révèle le groupement/entente avant toute poursuite "
                      "et permet l’identification des autres participants.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Condition clé : agir avant toute poursuite. La dénonciation doit être faite aux autorités compétentes "
                        "(judiciaires ou administratives) et permettre l’identification des autres participants.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 450-2 alinéa 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : réduction des deux tiers de la peine si, en avertissant l’autorité, la personne a permis "
                      "de faire cesser l’infraction, d’éviter la commission d’une infraction préparée, ou d’identifier d’autres auteurs/complices.",
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
