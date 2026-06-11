import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaViolationDomicileParticulierPage extends StatelessWidget {
  const PaViolationDomicileParticulierPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/violation_domicile_particulier';

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
          "Atteintes à la personnalité",
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
            "La violation de domicile commise par un particulier",
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
                "L’introduction dans le domicile d’autrui à l’aide de manœuvres, menaces, voies de fait ou contrainte, "
                "hors les cas où la loi le permet, constitue une infraction.\n"
                "Le maintien dans le domicile d’autrui à l’issue de cette introduction illégitime constitue également une infraction.",
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
                  text: "Article 226-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : définit et réprime la violation de domicile commise par un particulier "
                      "(introduction ou maintien illicites).",
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
            children: const [
              _SubTitle("A) Un domicile"),
              _Paragraph(
                "Le domicile s’entend largement : tout local d’habitation contenant des biens meubles appartenant à une personne, "
                "qu’elle y habite ou non, résidence principale ou secondaire.\n"
                "La condition essentielle est que le lieu protège l’intimité.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La notion peut inclure des logements inoccupés contenant des meubles caractérisant une occupation effective "
                "(table, chaises, lit, canapé, électroménager…). À l’inverse, quelques objets isolés (ex. bicyclette, carton de livres) "
                "ne suffisent pas à caractériser un domicile.",
              ),
              SizedBox(height: 10),

              _SubTitle("Exemples retenus comme domiciles"),
              _BulletPoint(
                text:
                    "Appartement loué, maison de campagne/vacances, même inoccupés temporairement.",
              ),
              _BulletPoint(
                text:
                    "Dépendances proches constituant le prolongement : débarras, garage, balcon, terrasse… "
                    "(ex. Cass. crim., 8 février 1994, n° 92-83.151).",
              ),
              _BulletPoint(
                text: "Logement occupé sans titre mais pacifiquement.",
              ),
              _BulletPoint(text: "Chambre d’hôtel."),
              _BulletPoint(
                text:
                    "Bureau / locaux professionnels (sauf zones ouvertes au public pendant les heures d’ouverture).",
              ),
              _BulletPoint(
                text:
                    "Véhicule aménagé pour l’habitation, caravane, roulotte, tente.",
              ),
              _BulletPoint(
                text:
                    "Navire habitable : yacht de plaisance, voilier, péniche.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Assimilations jurisprudentielles : box fermé non attenant (",
                  ),
                  TextSpan(
                    text: "Cass. crim., 29 mars 1994",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        "), garage en parking souterrain annexe au domicile (",
                  ),
                  TextSpan(
                    text: "Cass. crim., 23 janvier 2013",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle("Ne sont pas considérés comme domiciles"),
              _BulletPoint(
                text: "Logement vide de meubles entre deux locations.",
              ),
              _BulletPoint(text: "Immeuble en construction."),
              _BulletPoint(
                text: "Appartement partiellement détruit / inhabitable.",
              ),
              _BulletPoint(text: "Cour d’immeuble non close."),
              _BulletPoint(
                text: "Local réservé à la vente (zone commerciale ouverte).",
              ),
              _BulletPoint(text: "Hutte de chasse sans aménagement."),
              _BulletPoint(text: "Casier de consigne en gare."),
              _BulletPoint(
                text:
                    "Véhicule automobile non aménagé pour l’habitation (hors notion de domicile).",
              ),
              _BulletPoint(text: "Bateau sans aménagement intérieur."),
              SizedBox(height: 12),

              _SubTitle(
                "B) Une introduction par manœuvres, menaces, voies de fait ou contrainte",
              ),
              _Paragraph(
                "L’entrée doit être non désirée (peu importe la présence de l’occupant). "
                "Il ne s’agit pas d’une personne initialement invitée à entrer ou à séjourner.",
              ),
              SizedBox(height: 10),

              _SubTitle("• Manœuvres"),
              _Paragraph(
                "Procédé astucieux ou ruse mis en œuvre pour favoriser l’introduction illicite.",
              ),
              _SubTitle("• Menaces"),
              _Paragraph(
                "Paroles ou comportements intimidants d’une personne prête à accomplir des violences.",
              ),
              _SubTitle("• Voies de fait"),
              _Paragraph(
                "Violences contre les biens ou les personnes (défoncer une porte, briser une vitre, forcer une serrure, "
                "escalader, passer par une fenêtre ouverte, enlever une partie de toiture, etc.).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Exemple : la violence contre les choses peut consister en un forçage de serrure, un bris de vitre, "
                        "ou un descellement de barreaux. Attention : certaines décisions ont écarté l’introduction illicite lorsque "
                        "la porte du local n’était pas fermée à clé (appréciation au cas par cas).",
                  ),
                ],
                title: "POINT PRATIQUE",
              ),
              SizedBox(height: 10),

              _SubTitle("• Contrainte"),
              _Paragraph(
                "Toute situation où le consentement de l’occupant n’est pas libre.",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "C) Le maintien à l’issue d’une entrée illégitime",
              ),
              _Paragraph(
                "Le maintien vise la durée : l’occupation se prolonge au-delà du moment de l’entrée. "
                "Peuvent aussi être poursuivies des personnes arrivées ensuite et demeurant sur place en connaissance de cause.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La violation de domicile est une infraction continue : tant que perdure l’occupation illicite, "
                "l’enquête de flagrance peut être possible, sans devoir établir de nouvelles manœuvres/menaces/voies de fait/contrainte.",
              ),

              SizedBox(height: 14),

              _SubTitle("D) Hors les cas où la loi le permet"),
              _Paragraph(
                "Certaines introductions sont légitimes par ordre de la loi, notamment :\n"
                "• appels au secours depuis l’intérieur (même si l’appel est fantaisiste)\n"
                "• incendie ou inondation menaçant le domicile\n"
                "• assistance à personne en péril (indices sérieux : odeur suspecte, absence anormale, appel sans réponse, etc.)",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Les logements vacants non meublés, ainsi que les logements proposés à la location (meublés ou non), "
                        "ne sont pas des domiciles au sens de ",
                  ),
                  TextSpan(
                    text: "l’article 226-4 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        ". L’occupation frauduleuse de tels locaux relève des infractions prévues aux ",
                  ),
                  TextSpan(
                    text: "articles 315-1 et 315-2 du Code pénal",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "NOTA",
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
              _BulletPoint(
                text:
                    "Volonté de s’introduire ou de se maintenir dans le domicile d’autrui à son insu ou contre son gré.",
              ),
              _BulletPoint(
                text: "Conscience d’agir en dehors des cas prévus par la loi.",
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
                "Aucune circonstance aggravante prévue pour cette infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + infraction distincte
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Délit : "),
                TextSpan(
                  text: "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 226-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : OUI, prévue par "),
                TextSpan(
                  text: "l’article 226-5 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Complicité : OUI (règles générales applicables).",
              ),

              SizedBox(height: 14),

              _SubTitle(
                "Infraction distincte : propagande / publicité en faveur du squat",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 226-4-2-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : incrimine la propagande ou publicité (quel qu’en soit le mode) en faveur de méthodes "
                      "visant à faciliter ou inciter la commission du délit de violation de domicile et/ou l’occupation frauduleuse.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Ce délit vise notamment les contenus diffusés en ligne assimilables à des « modes d’emploi du squat » "
                "(techniques pour forcer une serrure, conseils pour faciliter l’installation ou la pérennisation d’un squat).",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Peine : 3 750 € d’amende."),
              SizedBox(height: 10),
              _NotaBox(
                title: "PRESSE",
                bodySpans: [
                  TextSpan(
                    text:
                        "Lorsque l’infraction est commise par voie de presse écrite ou audiovisuelle, "
                        "les règles spéciales de ces matières s’appliquent (responsabilités : éditeur, auteur, imprimeur…).",
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
