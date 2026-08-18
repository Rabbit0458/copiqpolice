import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ViolencesConjugalesPage extends StatelessWidget {
  const ViolencesConjugalesPage({super.key});

  static const String routeName =
      '/gpx/intervention/domicile/violences-conjugales';

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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
            "f00001",
            'Retour',
          ),
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00002",
              "Violences conjugales — conduites à tenir",
            ),
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
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00003",
                      "Toute sollicitation pour des faits relatifs à des violences conjugales ou intrafamiliales ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00004",
                      "doit conduire à une intervention dans les meilleurs délais.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00005",
                      "Les primo-intervenants adoptent une posture de prudence : la nature exacte des faits ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00006",
                      "n’est pas toujours connue, ni les moyens utilisés.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut : (texte fourni ne cite pas d’articles précis -> on garde un cadre légal “propre” sans inventer)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00007",
              "I — Élément légal (cadre)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00008",
                      "Cette fiche présente une conduite opérationnelle applicable lors des interventions au domicile ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00009",
                      "pour violences conjugales/intrafamiliales.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00010",
                      "Le cadre juridique précis dépendra de la qualification retenue (violences, menaces, harcèlement, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00011",
                      "infractions connexes) et de la situation procédurale (flagrance, enquête…).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3 éléments (pédagogique) : on l’adapte à la situation “violences”
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00012",
              "II — 3 éléments (qualification pénale : violences)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00013",
                  "A) Élément légal",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00014",
                      "Les violences au sein du couple relèvent du domaine délictuel. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00015",
                      "La qualification exacte dépend des constatations (violences physiques/psychologiques, menaces, armes, ITT, etc.).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00016",
                  "B) Élément matériel",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00017",
                      "Ce sont les faits observables/constatables :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00018",
                      "• blessures, douleurs, traces de coups\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00019",
                      "• traces de lutte, désordre, dégâts matériels\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00020",
                      "• déclarations croisées (victime, auteur, enfants, témoins)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00021",
                      "• contexte : séparation, alcool/stupéfiants, présence d’armes, répétition.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00022",
                  "C) Élément moral",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00023",
                      "Apprécier l’intention et la dangerosité : attitude de l’auteur (déni, minimisation, agressivité), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00024",
                      "craintes exprimées, emprise, menaces, contrôle…",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intervention à domicile — 2 cas (violences constatées / pas de violences apparentes)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00025",
              "III — À domicile : conduite immédiate",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00026",
                  "A) Violences constatées",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00027",
                  "Procéder à l’interpellation de l’auteur en cas de violences constatées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00028",
                  "Mettre en sécurité la victime et ses enfants.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00029",
                  "Préserver les traces et indices.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00030",
                      "L’interpellation intervient même si la victime s’y oppose ou refuse de déposer plainte.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00031",
                  "B) Absence de violences apparentes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00032",
                  "Recueillir isolément la version des faits auprès de chaque personne présente (victime, enfants, témoins, auteur).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00033",
                  "En cas de doute sur la conduite à tenir, rendre compte immédiatement à l’OPJ de permanence.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00034",
                  "Relever l’identité de l’ensemble des personnes présentes (dans tous les cas).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MCI / main courante exhaustive
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00035",
              "IV — Si la victime refuse audition / plainte",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00036",
                  "En cas de refus d’être entendue au service (plainte, audition), l’équipage intervenant :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00037",
                  "Rédige une main courante exhaustive (selon le modèle).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00038",
                  "Remet discrètement à la victime un document d’information au format « carte de visite » (numéros utiles).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                          "f00039",
                          "La rédaction MCI intervient y compris si les policiers n’ont pas pu pénétrer au domicile ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                          "f00040",
                          "(carence requérant, pas d’ouverture…) ou si la victime nie les violences.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contenu “MCI exhaustive” — rendu très visuel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00041",
              "V — MCI exhaustive : mentions à intégrer",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00042",
                      "Outre les mentions habituelles (identité de la victime + téléphone, identité/coordonnées du requérant…), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00043",
                      "les renseignements suivants doivent être enregistrés :",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00044",
                  "Motif de l’intervention (dispute, violences, tapage…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00045",
                  "Identité des enfants éventuels (âge, école).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00046",
                  "Identité et coordonnées des témoins éventuels.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00047",
                  "État psychologique de la victime et des enfants (peur, soumission, pleurs).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00048",
                  "Comportement de l’auteur (agressif, sur la défensive, déni, minimisation…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00049",
                  "Constatations / éléments d’observation (désordre, dégâts matériels, traces de lutte, traces de coups…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00050",
                  "Nombre d’interventions déjà réalisées au domicile (si connu).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00051",
                  "Facteurs aggravants à signaler",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00052",
                  "Arme à feu.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00053",
                  "Alcool / stupéfiants.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00054",
                  "Séparation.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité (sans inventer d’articles)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00055",
              "VI — Tentative & complicité (repères)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle("Tentative"),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00056",
                      "À apprécier selon l’infraction retenue et les circonstances. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00057",
                      "En pratique, en intervention : sécuriser, constater, préserver les indices et qualifier précisément.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00058",
                  "Complicité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00059",
                      "Peut être envisagée si un tiers a facilité l’infraction (aide/assistance, fourniture de moyens, incitation, etc.), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                      "f00060",
                      "selon les critères légaux applicables à l’infraction retenue.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse opérationnelle finale
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
              "f00061",
              "VII — Synthèse opérationnelle",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00062",
                  "Intervenir rapidement + posture prudente.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00063",
                  "Si violences constatées : interpellation + mise en sécurité + préservation traces/indices.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00064",
                  "Sinon : auditions isolées + compte rendu OPJ si doute + identités relevées.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/domicile/violences_conjugales_page.dart",
                  "f00065",
                  "Si refus plainte/audition : MCI exhaustive + remise discrète des numéros utiles.",
                ),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

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
          children: [...bodySpans],
        ),
      ),
    );
  }
}
