import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaAbusDeConfiancePage extends StatelessWidget {
  const PaAbusDeConfiancePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_biens/voisines_du_vol/abus_de_confiance';

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
            "L’abus de confiance",
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
                "L’abus de confiance est le fait, par une personne, de détourner, au préjudice d’autrui, "
                "des fonds, des valeurs ou un bien quelconque qui lui ont été remis et qu’elle a acceptés "
                "à charge de les rendre, de les représenter ou d’en faire un usage déterminé.",
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
                  text: "Article 314-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : définit et réprime l’abus de confiance.",
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
              _Paragraph(
                "L’abus de confiance est une appropriation frauduleuse de la propriété d’autrui, "
                "caractérisée par un détournement. L’auteur a légitimement la chose entre les mains "
                "à titre précaire, après une remise librement consentie en vertu d’un accord.",
              ),
              SizedBox(height: 12),

              _SubTitle("A) Une remise préalable de la chose"),
              _Paragraph(
                "La remise est une condition préalable : elle intervient avant le détournement, dans un cadre précis. "
                "Elle ne confère qu’une détention précaire à celui qui reçoit.",
              ),
              SizedBox(height: 10),

              _SubTitle("1) Cadre juridique de la remise"),
              _Paragraph(
                "La remise peut s’opérer dans différents cadres :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Un cadre contractuel : tout contrat impliquant une remise à titre précaire (louage, crédit-bail, dépôt, gage, nantissement, société, etc.).",
              ),
              _BulletPoint(
                text: "Des dispositions légales ou réglementaires.",
              ),
              _BulletPoint(text: "Une décision de justice."),
              _BulletPoint(
                text:
                    "Une simple situation de fait : accord non contractuel (relations amicales), sans engagement juridique formel.",
              ),

              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’abus de confiance ne suppose pas nécessairement une remise en vertu d’un contrat. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 octobre 2000)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("2) Contenu de la remise"),
              _Paragraph("La remise peut porter sur :"),
              SizedBox(height: 8),
              _BulletPoint(text: "Des fonds : sommes d’argent."),
              _BulletPoint(
                text:
                    "Des valeurs : titres négociables (actions, obligations…) ou objets de valeur (bijoux, lingots, tableaux, pièces…).",
              ),
              _BulletPoint(
                text:
                    "Un bien quelconque : tout bien susceptible d’appropriation, mobilier ou immobilier, avec ou sans valeur économique.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le bien peut être incorporel s’il est exploitable matériellement (ex. fichier clientèle, scénario, numéro de carte bancaire, connexion internet, temps de travail…). ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 13 mars 2024, n° 22-83.689)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("3) Affectation de la remise"),
              _Paragraph(
                "La remise poursuit un but déterminé : le bénéficiaire accepte :\n"
                "• de rendre (restituer) la chose ;\n"
                "• de la représenter (la montrer) ;\n"
                "• ou d’en faire un usage déterminé (utilisation convenue).\n"
                "Il n’a donc pas la libre disposition : la détention est bien précaire.",
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un acte matériel de détournement"),
              _Paragraph(
                "Le détournement est caractérisé par la non-restitution de la chose remise à titre précaire.\n"
                "Il peut résulter :\n"
                "• d’une transgression de l’affectation ;\n"
                "• d’une aliénation ;\n"
                "• ou d’une disparition.\n"
                "Le délit est caractérisé par le seul détournement, sans qu’une mise en demeure de restituer soit nécessaire.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Aucune mise en demeure nécessaire. "),
                  TextSpan(
                    text: "(Cass. crim., 24 mars 1969)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("Repères pédagogiques (formes fréquentes)"),
              _BulletPoint(
                text:
                    "Usage abusif : en principe seulement civil, sauf abus manifeste directement contraire aux prévisions acceptées.",
              ),
              _BulletPoint(
                text:
                    "Retard de restitution : en principe inexécution contractuelle, sauf retard injustifié devenant frauduleux.",
              ),
              _BulletPoint(
                text:
                    "Refus de restituer : caractérise en principe le détournement, sauf droit de rétention/compensation légitime.",
              ),
              _BulletPoint(
                text:
                    "Impossibilité de restituer : si volontaire (hors force majeure/cas fortuit), manifeste la volonté de ne pas respecter la finalité.",
              ),

              SizedBox(height: 12),

              _SubTitle("C) Au préjudice d’autrui"),
              _Paragraph(
                "Le préjudice est un élément essentiel : il suffit que l’acte soit susceptible de priver "
                "le propriétaire/possesseur de ses droits. Il n’est pas nécessaire que l’auteur ait tiré profit "
                "ou que le bien soit entré dans son patrimoine.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le préjudice peut être réel ou éventuel ; il peut découler de la seule constatation du détournement. ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 3 décembre 2003)",
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
              _Paragraph(
                "L’abus de confiance est un délit intentionnel : aucune condamnation ne peut intervenir "
                "sans constater le caractère frauduleux des faits.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Le caractère frauduleux découle de la conscience : ",
                ),
                TextSpan(
                  text:
                      "1) de la précarité de la détention, et 2) de l’obligation de restitution / représentation / usage déterminé, ",
                ),
                TextSpan(text: "et de la volonté d’y contrevenir."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’intention frauduleuse peut se déduire des circonstances (présomptions de fraude). ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 30 juin 2010)",
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 314-1-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " : abus de confiance commis en bande organisée.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 314-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : circonstances aggravantes liées notamment à l’appel au public pour obtenir la remise, "
                      "à l’exercice habituel d’opérations portant sur les biens des tiers, "
                      "au préjudice d’une association faisant appel au public, "
                      "ou au préjudice d’une personne vulnérable (âge, maladie, infirmité, déficience, grossesse).",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 314-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : aggravation lorsque l’auteur est mandataire de justice ou officier public/ministériel, "
                      "dans l’exercice, à l’occasion, ou en raison de ses fonctions/qualité.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + immunité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 375 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 314-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Bande organisée : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 750 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 314-1-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravations spécifiques : "),
                TextSpan(
                  text: "7 ans d’emprisonnement et 750 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 314-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Officier public / mandataire de justice : ",
                ),
                TextSpan(
                  text: "10 ans d’emprisonnement et 1 500 000 € d’amende. — ",
                ),
                TextSpan(
                  text: "article 314-3 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale selon "),
                TextSpan(
                  text: "l’article 121-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", pour les infractions des "),
                TextSpan(
                  text: "articles 314-1 et 314-2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: ", et peines prévues par "),
                TextSpan(
                  text: "l’article 314-12 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(
                  text: "Tentative : OUI — prévue expressément par ",
                ),
                TextSpan(
                  text: "l’article 314-1-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " (toujours punissable)."),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    "Complicité : OUI (punissable pour l’infraction consommée ou tentée, personne physique ou morale).",
              ),

              SizedBox(height: 12),

              _SubTitle("Immunité familiale"),
              _Paragraph.rich([
                TextSpan(text: "Immunité familiale : OUI — "),
                TextSpan(
                  text: "article 314-4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " renvoyant aux dispositions de "),
                TextSpan(
                  text: "l’article 311-12 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
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
  const _NotaBox({required this.bodySpans});

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
