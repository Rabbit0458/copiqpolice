import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TableauRecapitulatifEpreuvesGPXPage extends StatelessWidget {
  const TableauRecapitulatifEpreuvesGPXPage({super.key});

  static const String routeName = '/gpx_exam/concours/epreuves_gpx/tableau';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardAccess = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardEcrits = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardSportOral = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRemarques = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

    // Table styles
    final Color tableBorder = isDark
        ? Colors.white.withOpacity(.10)
        : Colors.black.withOpacity(.10);

    final Color tableHeaderBg = isDark
        ? Colors.white.withOpacity(.06)
        : Colors.black.withOpacity(.04);

    final Color tableText = isDark ? Colors.white70 : Colors.black87;

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
          "Concours GPX",
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
            "Tableau récapitulatif des épreuves",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // INTRO
          _ConditionCard(
            title: "Ce que tu dois retenir",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Depuis la modification entrée en vigueur à compter de la seconde session 2024 "
                "(écrits du 24 septembre 2024), le concours de gardien de la paix fonctionne avec "
                "une phase unique d’admission : épreuves écrites + épreuves sportives + épreuve orale.\n\n"
                "Les tests psychotechniques sont obligatoires mais non notés : ils servent d’aide à la décision "
                "pour le jury lors de l’entretien.",
              ),
              SizedBox(height: 10),
              _IntroBullet(text: "Écrits : 4 épreuves (dont psycho non noté)."),
              _IntroBullet(
                text: "Sport : PHM + TECR (note éliminatoire : < 7/20).",
              ),
              _IntroBullet(
                text: "Oral : entretien 25 min (note éliminatoire : < 5/20).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // CONDITIONS D’ACCÈS
          _ConditionCard(
            title: "Conditions d’accès (synthèse officielle)",
            cardColor: cardAccess,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Accessible aux candidats titulaires du baccalauréat (ou équivalent / niveau 4), "
                      "âgés de ",
                ),
                TextSpan(
                  text: "17 ans à moins de 45 ans",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " au 1er janvier de l’année du concours (sauf dérogations).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Pour s’inscrire, le candidat doit :"),
              const _BulletPoint(
                text:
                    "Être titulaire du baccalauréat ou équivalent (ou diplôme de niveau 4).",
              ),
              const _BulletPoint(
                text:
                    "Avoir entre 17 ans et moins de 45 ans au 1er janvier de l’année du concours.",
              ),
              const _BulletPoint(text: "Être de nationalité française."),
              const _BulletPoint(
                text:
                    "Être de bonne moralité : le bulletin n°2 du casier judiciaire ne doit comporter aucune mention incompatible avec l’exercice des fonctions.",
              ),
              const _BulletPoint(
                text:
                    "Répondre aux aptitudes physiques requises lors de la visite médicale (référence : arrêté du 25 novembre 2022 sur les conditions de santé particulières exigées).",
              ),
              const _BulletPoint(
                text:
                    "Être en règle avec les obligations de service national (JDC).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "JDC : pour les moins de 25 ans n’ayant pas encore accompli la JDC, "
                        "une attestation provisoire de participation délivrée par le centre du service national "
                        "doit être fournie. Les personnes de plus de 25 ans sont dispensées et aucun justificatif "
                        "n’est demandé.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ÉCRITS
          _ConditionCard(
            title: "Épreuves écrites (4 épreuves)",
            cardColor: cardEcrits,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Les écrits comportent : un cas pratique, deux QCM simultanés (culture générale + langue), "
                "et des tests psychotechniques (obligatoires, non notés).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("Tableau — Récapitulatif"),
              const SizedBox(height: 8),
              _ExamTable(
                borderColor: tableBorder,
                headerBg: tableHeaderBg,
                textColor: tableText,
                rows: const [
                  _ExamRow(
                    epreuve: "Cas pratique",
                    objectif:
                        "Évaluer les capacités rédactionnelles, la compréhension d’une situation professionnelle, l’analyse et la synthèse, ainsi que la projection dans les futures missions.",
                    duree: "2 h",
                    coef: "4",
                    eliminatoire: "Oui : < 5/20",
                    note: "Dossier ≤ 15 pages, mises en situation + questions.",
                  ),
                  _ExamRow(
                    epreuve: "QCM culture générale",
                    objectif:
                        "Actualité France/monde, cadre institutionnel et politique français/européen, valeurs et symboles républicains, grandes périodes de l’histoire de France.",
                    duree: "1 h (avec langue)",
                    coef: "2",
                    eliminatoire: "—",
                    note: "Se déroule simultanément avec le QCM de langue.",
                  ),
                  _ExamRow(
                    epreuve: "QCM langue étrangère",
                    objectif:
                        "Évaluer les compétences linguistiques (anglais, espagnol ou allemand).",
                    duree: "1 h (avec CG)",
                    coef: "1",
                    eliminatoire: "—",
                    note:
                        "Langue choisie à l’inscription, non modifiable après clôture.",
                  ),
                  _ExamRow(
                    epreuve: "Tests psychotechniques",
                    objectif:
                        "Mesurer les aptitudes intellectuelles et le profil psychologique (stabilité émotionnelle, rapport à l’autorité, etc.).",
                    duree: "2 h",
                    coef: "—",
                    eliminatoire: "Non noté",
                    note:
                        "Obligatoires. Résultats communiqués au jury d’entretien (aide à la décision).",
                  ),
                ],
              ),

              const SizedBox(height: 12),
              _NotaBox(
                title: "Méthodo (cas pratique)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Garde à l’esprit que les réponses se trouvent dans le dossier documentaire : "
                        "pas besoin de « connaissances policières ». Lis attentivement, analyse avec discernement, "
                        "et justifie toujours les actions : ",
                  ),
                  const TextSpan(
                    text:
                        "pourquoi je fais cela et ai-je le droit de le faire ?",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // SPORT + ORAL
          _ConditionCard(
            title: "Épreuves sportives & orale",
            cardColor: cardSportOral,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Sport — PHM + TECR"),
              const _Paragraph(
                "Le candidat passe :\n"
                "• Un Parcours d’habileté motrice (PHM)\n"
                "• Un Test d’endurance cardio-respiratoire (TECR)\n\n"
                "Les modalités et le barème sont fixés par arrêté du ministre de l’Intérieur et des Outre-mer.",
              ),
              const SizedBox(height: 10),
              _ExamTable(
                borderColor: tableBorder,
                headerBg: tableHeaderBg,
                textColor: tableText,
                rows: const [
                  _ExamRow(
                    epreuve: "Sport (PHM + TECR)",
                    objectif:
                        "Évaluer la condition physique, l’endurance et l’aptitude à l’effort (deux épreuves).",
                    duree: "Variable",
                    coef: "4",
                    eliminatoire: "Oui : < 7/20",
                    note:
                        "Note éliminatoire si < 7/20 à l’une ou l’autre des 2 épreuves.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Certificat médical",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Le candidat doit être en possession d’un certificat médical d’aptitude "
                        "(datant de moins de 3 mois) délivré par un médecin de son choix.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Conséquence directe",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Les candidats éliminés aux épreuves sportives ne sont pas convoqués à l’épreuve orale.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("B) Oral — Entretien de recrutement"),
              const _Paragraph(
                "L’entretien de recrutement permet d’évaluer l’aptitude et la motivation du candidat à occuper "
                "les fonctions de gardien de la paix, d’apprécier sa personnalité, ses qualités de réflexion "
                "ainsi que ses connaissances.",
              ),
              const SizedBox(height: 10),
              _ExamTable(
                borderColor: tableBorder,
                headerBg: tableHeaderBg,
                textColor: tableText,
                rows: const [
                  _ExamRow(
                    epreuve: "Entretien avec le jury",
                    objectif:
                        "Aptitude, motivation, personnalité, réflexion, connaissances, posture et communication.",
                    duree: "25 min",
                    coef: "5",
                    eliminatoire: "Oui : < 5/20",
                    note: "Dont 5 minutes de présentation.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Aide à la décision du jury",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Le jury dispose notamment :\n"
                        "• des résultats des tests psychotechniques (interprétés par le psychologue)\n"
                        "• d’un curriculum vitae détaillé remis le jour même au service organisateur\n\n"
                        "Le CV doit présenter les compétences acquises (scolaire et extrascolaire) "
                        "et développer clairement les raisons du choix professionnel.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // REMARQUES IMPORTANTES (affectations / engagement)
          _ConditionCard(
            title: "Remarques importantes (affectation & engagement)",
            cardColor: cardRemarques,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Concours à affectation nationale"),
              _Paragraph(
                "Les candidats choisissant le concours à affectation nationale sont recrutés pour une durée de "
                "5 ans à compter de leur nomination en tant que stagiaire. "
                "L’affectation nationale comprend tout le territoire, y compris l’Île-de-France.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Concours à affectation régionale en Île-de-France"),
              _Paragraph(
                "Les candidats choisissant le concours à affectation régionale en Île-de-France sont recrutés pour "
                "une durée de 8 ans à compter de leur nomination en tant que stagiaire. "
                "La fidélisation en Île-de-France est accompagnée de mesures indemnitaires et sociales.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------
/// TABLE WIDGET (ultra clean + lisible)
/// ------------------------------
class _ExamRow {
  const _ExamRow({
    required this.epreuve,
    required this.objectif,
    required this.duree,
    required this.coef,
    required this.eliminatoire,
    required this.note,
  });

  final String epreuve;
  final String objectif;
  final String duree;
  final String coef;
  final String eliminatoire;
  final String note;
}

class _ExamTable extends StatelessWidget {
  const _ExamTable({
    required this.rows,
    required this.borderColor,
    required this.headerBg,
    required this.textColor,
  });

  final List<_ExamRow> rows;
  final Color borderColor;
  final Color headerBg;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        // 🔥 breakpoint : en dessous -> cartes (lisible), au dessus -> tableau
        final bool compact = c.maxWidth < 620;

        if (compact) {
          return Column(
            children: [
              for (int i = 0; i < rows.length; i++) ...[
                _ExamRowCard(
                  row: rows[i],
                  borderColor: borderColor,
                  textColor: textColor,
                ),
                if (i != rows.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }

        // ✅ Mode tableau (écran large)
        return _WideExamTable(
          rows: rows,
          borderColor: borderColor,
          headerBg: headerBg,
          textColor: textColor,
        );
      },
    );
  }
}

class _WideExamTable extends StatelessWidget {
  const _WideExamTable({
    required this.rows,
    required this.borderColor,
    required this.headerBg,
    required this.textColor,
  });

  final List<_ExamRow> rows;
  final Color borderColor;
  final Color headerBg;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    Widget headerCell(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.fustat(
            fontSize: 13.2,
            height: 1.2,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
      );
    }

    Widget cell(String text, {TextAlign align = TextAlign.left}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          text,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontSize: 13.0,
            height: 1.25,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 900),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            columnWidths: const {
              0: FixedColumnWidth(170), // Épreuve
              1: FixedColumnWidth(340), // Objectif
              2: FixedColumnWidth(90), // Durée
              3: FixedColumnWidth(80), // Coef.
              4: FixedColumnWidth(130), // Élim.
              5: FixedColumnWidth(260), // Notes
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: headerBg),
                children: [
                  headerCell("Épreuve"),
                  headerCell("Objectif"),
                  headerCell("Durée"),
                  headerCell("Coef."),
                  headerCell("Élim."),
                  headerCell("Notes"),
                ],
              ),
              ...rows.map(
                (r) => TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  children: [
                    cell(r.epreuve),
                    cell(r.objectif),
                    cell(r.duree, align: TextAlign.center),
                    cell(r.coef, align: TextAlign.center),
                    cell(r.eliminatoire, align: TextAlign.center),
                    cell(r.note),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamRowCard extends StatelessWidget {
  const _ExamRowCard({
    required this.row,
    required this.borderColor,
    required this.textColor,
  });

  final _ExamRow row;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark
        ? Colors.white.withOpacity(.06)
        : Colors.black.withOpacity(.03);

    Widget line(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.fustat(
              fontSize: 13.5,
              height: 1.25,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            children: [
              TextSpan(
                text: "$label : ",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.epreuve,
            style: GoogleFonts.fustat(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          line("Objectif", row.objectif),
          Row(
            children: [
              Expanded(child: line("Durée", row.duree)),
              const SizedBox(width: 10),
              Expanded(child: line("Coef.", row.coef)),
            ],
          ),
          line("Éliminatoire", row.eliminatoire),
          line("Notes", row.note),
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
