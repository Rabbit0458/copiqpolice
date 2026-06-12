import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaViolencesConjugalesPage extends StatelessWidget {
  const PaViolencesConjugalesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/domicile/violences-conjugales';

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
            "Violences conjugales — conduites à tenir",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / philosophie d’intervention
          _ConditionCard(
            title: "Principe",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Toute sollicitation pour des faits relatifs à des violences conjugales ou intrafamiliales "
                "doit conduire à une intervention dans les meilleurs délais.\n\n"
                "Les primo-intervenants adoptent une posture de prudence : la nature exacte des faits "
                "n’est pas toujours connue, ni les moyens utilisés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut : (texte fourni ne cite pas d’articles précis -> on garde un cadre légal “propre” sans inventer)
          _ConditionCard(
            title: "I — Élément légal (cadre)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Cette fiche présente une conduite opérationnelle applicable lors des interventions au domicile "
                "pour violences conjugales/intrafamiliales.\n\n"
                "Le cadre juridique précis dépendra de la qualification retenue (violences, menaces, harcèlement, "
                "infractions connexes) et de la situation procédurale (flagrance, enquête…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3 éléments (pédagogique) : on l’adapte à la situation “violences”
          _ConditionCard(
            title: "II — 3 éléments (qualification pénale : violences)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Élément légal"),
              _Paragraph(
                "Les violences au sein du couple relèvent du domaine délictuel. "
                "La qualification exacte dépend des constatations (violences physiques/psychologiques, menaces, armes, ITT, etc.).",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Élément matériel"),
              _Paragraph(
                "Ce sont les faits observables/constatables :\n"
                "• blessures, douleurs, traces de coups\n"
                "• traces de lutte, désordre, dégâts matériels\n"
                "• déclarations croisées (victime, auteur, enfants, témoins)\n"
                "• contexte : séparation, alcool/stupéfiants, présence d’armes, répétition.",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Élément moral"),
              _Paragraph(
                "Apprécier l’intention et la dangerosité : attitude de l’auteur (déni, minimisation, agressivité), "
                "craintes exprimées, emprise, menaces, contrôle…",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intervention à domicile — 2 cas (violences constatées / pas de violences apparentes)
          _ConditionCard(
            title: "III — À domicile : conduite immédiate",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Violences constatées"),
              _BulletPoint(
                text:
                    "Procéder à l’interpellation de l’auteur en cas de violences constatées.",
              ),
              _BulletPoint(
                text: "Mettre en sécurité la victime et ses enfants.",
              ),
              _BulletPoint(text: "Préserver les traces et indices."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "L’interpellation intervient même si la victime s’y oppose ou refuse de déposer plainte.",
                  ),
                ],
              ),
              SizedBox(height: 14),
              _SubTitle("B) Absence de violences apparentes"),
              _BulletPoint(
                text:
                    "Recueillir isolément la version des faits auprès de chaque personne présente (victime, enfants, témoins, auteur).",
              ),
              _BulletPoint(
                text:
                    "En cas de doute sur la conduite à tenir, rendre compte immédiatement à l’OPJ de permanence.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Relever l’identité de l’ensemble des personnes présentes (dans tous les cas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MCI / main courante exhaustive
          _ConditionCard(
            title: "IV — Si la victime refuse audition / plainte",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En cas de refus d’être entendue au service (plainte, audition), l’équipage intervenant :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Rédige une main courante exhaustive (selon le modèle).",
              ),
              _BulletPoint(
                text:
                    "Remet discrètement à la victime un document d’information au format « carte de visite » (numéros utiles).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La rédaction MCI intervient y compris si les policiers n’ont pas pu pénétrer au domicile "
                        "(carence requérant, pas d’ouverture…) ou si la victime nie les violences.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contenu “MCI exhaustive” — rendu très visuel
          _ConditionCard(
            title: "V — MCI exhaustive : mentions à intégrer",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Outre les mentions habituelles (identité de la victime + téléphone, identité/coordonnées du requérant…), "
                "les renseignements suivants doivent être enregistrés :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Motif de l’intervention (dispute, violences, tapage…).",
              ),
              _BulletPoint(
                text: "Identité des enfants éventuels (âge, école).",
              ),
              _BulletPoint(
                text: "Identité et coordonnées des témoins éventuels.",
              ),
              _BulletPoint(
                text:
                    "État psychologique de la victime et des enfants (peur, soumission, pleurs).",
              ),
              _BulletPoint(
                text:
                    "Comportement de l’auteur (agressif, sur la défensive, déni, minimisation…).",
              ),
              _BulletPoint(
                text:
                    "Constatations / éléments d’observation (désordre, dégâts matériels, traces de lutte, traces de coups…).",
              ),
              _BulletPoint(
                text:
                    "Nombre d’interventions déjà réalisées au domicile (si connu).",
              ),
              SizedBox(height: 12),
              _SubTitle("Facteurs aggravants à signaler"),
              _BulletPoint(text: "Arme à feu."),
              _BulletPoint(text: "Alcool / stupéfiants."),
              _BulletPoint(text: "Séparation."),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité (sans inventer d’articles)
          _ConditionCard(
            title: "VI — Tentative & complicité (repères)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("Tentative"),
              _Paragraph(
                "À apprécier selon l’infraction retenue et les circonstances. "
                "En pratique, en intervention : sécuriser, constater, préserver les indices et qualifier précisément.",
              ),
              SizedBox(height: 12),
              _SubTitle("Complicité"),
              _Paragraph(
                "Peut être envisagée si un tiers a facilité l’infraction (aide/assistance, fourniture de moyens, incitation, etc.), "
                "selon les critères légaux applicables à l’infraction retenue.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse opérationnelle finale
          _ConditionCard(
            title: "VII — Synthèse opérationnelle",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _IntroBullet(text: "Intervenir rapidement + posture prudente."),
              _IntroBullet(
                text:
                    "Si violences constatées : interpellation + mise en sécurité + préservation traces/indices.",
              ),
              _IntroBullet(
                text:
                    "Sinon : auditions isolées + compte rendu OPJ si doute + identités relevées.",
              ),
              _IntroBullet(
                text:
                    "Si refus plainte/audition : MCI exhaustive + remise discrète des numéros utiles.",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
