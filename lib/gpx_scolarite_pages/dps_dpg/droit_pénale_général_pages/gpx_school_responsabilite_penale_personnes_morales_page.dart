import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GPXSchoolResponsabilitePenalePersonnesMoralesPage
    extends StatelessWidget {
  const GPXSchoolResponsabilitePenalePersonnesMoralesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/droit_pénale_général_pages/responsabilite_penale/personnes_morales';

  // ===================== Helpers (articles en rouge) =====================
  TextSpan _red(String s) => TextSpan(
    text: s,
    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
  );

  TextSpan _t(String s) => TextSpan(text: s);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF0B0B0B);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF0B0B0B).withOpacity(.72);

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
          'Responsabilité pénale des personnes morales',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.2,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
        children: [
          // ========================= HEADER =========================
          Text(
            'La responsabilité pénale des personnes morales',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.05,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personnes concernées, conditions de mise en œuvre, peines applicables et points '
            'procéduraux essentiels.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========================= INTRO (principe) =========================
          _ConditionCard(
            title: 'Principe',
            cardColor: isDark
                ? const Color(0xFF1A2430)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                _t(
                  "Le principe de la responsabilité pénale des personnes morales est prévu par ",
                ),
                _red("l’article 121-2 du Code pénal"),
                _t("."),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Il convient de préciser : (I) les personnes morales concernées, (II) les conditions "
                "de mise en œuvre, (III) les peines applicables, et (IV) certaines particularités "
                "procédurales.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 1 =========================
          _ConditionCard(
            title: 'Chapitre 1 — Les personnes morales concernées',
            cardColor: isDark
                ? const Color(0xFF20302E)
                : const Color(0xFFE0F2F1),
            accent: const Color(0xFF00897B),
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: const [
              _Paragraph(
                "À une exception près, toutes les personnes morales, qu’elles soient de droit public "
                "ou de droit privé, sont concernées.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 1.1 Droit public
          _ConditionCard(
            title: '1.1 — Personnes morales de droit public',
            cardColor: isDark
                ? const Color(0xFF1E2D2D)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00838F),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              const _BulletPoint(
                text: "Seul l’État n’est pas pénalement responsable.",
              ),
              const _BulletPoint(
                text:
                    "Toutes les autres personnes morales de droit public sont pénalement responsables : "
                    "établissements publics, groupements d’intérêt public, personnes morales de droit mixte "
                    "(sociétés d’économie mixte, entreprises nationalisées, ordres professionnels…).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _t(
                  "Toutefois, les collectivités territoriales (régions, départements, communes) et leurs "
                  "groupements ont une responsabilité pénale limitée par ",
                ),
                _red("l’article 121-2, alinéa 2, du Code pénal"),
                _t(
                  " aux seules infractions commises dans l’exercice d’activités pouvant faire l’objet d’une "
                  "convention de délégation de service public (ex. cantine scolaire, distribution d’eau…).",
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Définition',
                bodySpans: [
                  TextSpan(
                    text:
                        "Une convention de délégation de service public est un contrat par lequel une personne "
                        "morale de droit public confie la gestion d’un service public dont elle a la responsabilité "
                        "à un délégataire public ou privé.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Certaines sanctions sont écartées pour les personnes morales de droit public (voir Chapitre 3).",
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 1.2 Droit privé
          _ConditionCard(
            title: '1.2 — Personnes morales de droit privé',
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: const [
              _BulletPoint(
                text:
                    "Est une personne morale de droit privé tout groupement de personnes physiques ou morales, "
                    "spontané ou d’origine légale, auquel les textes attribuent la personnalité morale "
                    "(déclaration, immatriculation…).",
              ),
              _BulletPoint(
                text:
                    "Sont concernées toutes les personnes morales de droit privé, à but lucratif (société civile, "
                    "société commerciale, GIE…) ou non lucratif (association, congrégation, syndicat de copropriété, "
                    "parti politique, syndicat, comité d’entreprise…).",
              ),
              _BulletPoint(
                text:
                    "La loi écarte, pour certaines d’entre elles, l’application de quelques peines prévues pour les "
                    "personnes morales (voir Chapitre 3).",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 2 =========================
          _ConditionCard(
            title: 'Chapitre 2 — Conditions de mise en œuvre',
            cardColor: isDark
                ? const Color(0xFF2A1A1A)
                : const Color(0xFFFFEBEE),
            accent: const Color(0xFFC62828),
            titleColor: isDark ? Colors.white : const Color(0xFFB71C1C),
            children: const [
              _Paragraph(
                "Deux conditions cumulatives doivent être réunies :\n"
                "• infraction commise par les organes ou représentants ;\n"
                "• infraction commise pour le compte de la personne morale.",
              ),
              SizedBox(height: 8),
              _Paragraph(
                "La personne morale peut être auteur ou complice. Cette responsabilité pénale n’exclut pas celle "
                "des personnes physiques auteurs ou complices des mêmes faits.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.1 — Portée générale de la responsabilité',
            cardColor: isDark
                ? const Color(0xFF1B263B)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF303F9F),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _Paragraph.rich([
                _t(
                  "La responsabilité pénale des personnes morales est une règle de portée générale (",
                ),
                _red("article 121-2 du Code pénal"),
                _t("), à l’exception :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Des délits en matière de presse (article 43-1 de la loi sur la presse).",
              ),
              const _BulletPoint(
                text: "De certains délits de communication audiovisuelle.",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Elle peut concerner un crime, un délit ou une contravention. L’infraction peut résulter "
                "d’un acte délibéré, d’une négligence ou d’une imprudence fautive. La tentative punissable "
                "engage également la personne morale.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.2 — Infraction commise par ses organes ou représentants',
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00ACC1),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: const [
              _Paragraph(
                "Il s’agit des institutions (individuelles ou collégiales) auxquelles la réglementation ou les statuts "
                "confèrent des pouvoirs décisionnels, directionnels ou de représentation.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        "Commune : conseil municipal, maire.\n"
                        "Société anonyme : conseil d’administration, président, assemblée générale.\n"
                        "Association : président, bureau, assemblée générale.",
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "L’infraction commise de son propre chef par un salarié sans mandat de représentation n’engage "
                    "pas, en principe, la personne morale.",
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title:
                '2.3 — Infraction commise pour le compte de la personne morale',
            cardColor: isDark
                ? const Color(0xFF2A1E12)
                : const Color(0xFFFFF3E0),
            accent: const Color(0xFFEF6C00),
            titleColor: isDark ? Colors.white : const Color(0xFFE65100),
            children: const [
              _BulletPoint(
                text:
                    "L’organe ou le représentant a agi au nom de la personne morale.",
              ),
              _BulletPoint(
                text:
                    "La notion « pour le compte » se matérialise souvent par un intérêt : profit ou économie. "
                    "Elle peut aussi viser un acte commis pour assurer l’organisation, le fonctionnement ou l’objet "
                    "de la personne morale.",
              ),
              _BulletPoint(
                text:
                    "L’infraction commise au seul profit personnel de l’organe ou du dirigeant n’engage pas la personne morale.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        "Si un gérant achète des marchandises volées et les entrepose dans les locaux :\n"
                        "• achat pour son compte personnel : la société n’est pas responsable ;\n"
                        "• achat pour le compte de la société (commercialisation au profit de la société) : la société "
                        "peut être pénalement responsable du recel.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.4 — Auteur ou complice',
            cardColor: isDark
                ? const Color(0xFF1A2333)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF3F51B5),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _red("l’article 121-2, alinéa 1, du Code pénal"),
                _t(
                  ", les personnes morales sont responsables pénalement selon les distinctions des ",
                ),
                _red("articles 121-4 à 121-7 du Code pénal"),
                _t(" (auteur / complice)."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text:
                        "• Président d’association qui obtient des subventions indues : le président est auteur, l’association est aussi auteur.\n"
                        "• Gérant qui charge un tiers de voler un secret de fabrication : le gérant et la société peuvent être complices du vol.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '2.5 — Cumul avec la responsabilité des personnes physiques',
            cardColor: isDark
                ? const Color(0xFF2B2B1A)
                : const Color(0xFFFFF8E1),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: [
              _Paragraph.rich([
                _t(
                  "La responsabilité de la personne morale n’exclut pas celle des personnes physiques (",
                ),
                _red("article 121-2, alinéa 3, du Code pénal"),
                _t("), sous réserve des dispositions du "),
                _red("4ᵉ alinéa de l’article 121-3 du Code pénal"),
                _t("."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Dans certains cas, lorsque l’organe/représentant n’a commis qu’une faute simple, la responsabilité "
                "pénale de la personne morale peut être engagée sans poursuite de la personne physique. "
                "Dans les autres cas, il peut y avoir cumul et poursuites conjointes.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Point clé',
                bodySpans: [
                  TextSpan(
                    text:
                        "Une personne morale pourrait être poursuivie seule :\n"
                        "• opportunité des poursuites (Parquet),\n"
                        "• impossibilité d’identifier le dirigeant responsable (négligence collective, décision à vote secret…).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 3 =========================
          _ConditionCard(
            title: 'Chapitre 3 — Peines applicables',
            cardColor: isDark
                ? const Color(0xFF1A1F2A)
                : const Color(0xFFE8EAF6),
            accent: const Color(0xFF3949AB),
            titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
            children: [
              _Paragraph.rich([
                _t(
                  "Les peines criminelles et correctionnelles applicables sont prévues par ",
                ),
                _red("les articles 131-37 à 131-39-2 du Code pénal"),
                _t("."),
              ]),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.1 — Peines criminelles et correctionnelles',
            cardColor: isDark
                ? const Color(0xFF1E2D2D)
                : const Color(0xFFE0F7FA),
            accent: const Color(0xFF00838F),
            titleColor: isDark ? Colors.white : const Color(0xFF006064),
            children: [
              const _SubTitle('3.1.1 — Amende'),
              const _BulletPoint(
                text:
                    "Amende : quintuple de celle prévue pour les personnes physiques.",
              ),
              const _BulletPoint(
                text:
                    "Pour un crime sans amende prévue pour les personnes physiques : amende encourue de 1 000 000 €.",
              ),
              const SizedBox(height: 10),
              const _SubTitle(
                '3.1.2 — Peines de l’article 131-39 et de l’article 131-39-2',
              ),
              _Paragraph.rich([
                _t(
                  "Les peines complémentaires et principales possibles sont détaillées par ",
                ),
                _red("l’article 131-39 du Code pénal"),
                _t(" (et la peine prévue par "),
                _red("l’article 131-39-2 du Code pénal"),
                _t(")."),
              ]),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: 'Article 131-39 du Code pénal — Liste (synthèse)',
            cardColor: isDark
                ? const Color(0xFF2A1E12)
                : const Color(0xFFFFF3E0),
            accent: const Color(0xFFEF6C00),
            titleColor: isDark ? Colors.white : const Color(0xFFE65100),
            children: [
              const _BulletPoint(
                text: "1° Dissolution (conditions prévues par le texte).",
              ),
              const _BulletPoint(
                text:
                    "2° Interdiction d’exercer une ou plusieurs activités (5 ans max ou définitive).",
              ),
              const _BulletPoint(
                text: "3° Placement sous surveillance judiciaire (5 ans max).",
              ),
              const _BulletPoint(
                text: "4° Fermeture d’établissement (5 ans max ou définitive).",
              ),
              const _BulletPoint(
                text:
                    "5° Exclusion des marchés publics (5 ans max ou définitive).",
              ),
              const _BulletPoint(
                text:
                    "6° Interdiction d’offre au public de titres / admission sur marché réglementé (5 ans max ou définitive).",
              ),
              const _BulletPoint(
                text:
                    "7° Interdiction d’émettre des chèques / utiliser cartes de paiement (5 ans max ou définitive).",
              ),
              _BulletPoint(
                text:
                    "8° Confiscation (dans les conditions de l’article 131-21 du Code pénal).",
              ),
              const _BulletPoint(
                text: "9° Affichage ou diffusion de la décision.",
              ),
              const _BulletPoint(
                text: "10° Confiscation de l’animal utilisé / visé.",
              ),
              const _BulletPoint(
                text:
                    "11° Interdiction de détenir un animal (5 ans max ou définitive).",
              ),
              const _BulletPoint(
                text:
                    "12° Interdiction de percevoir des aides publiques (5 ans max).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: 'Limites',
                bodySpans: [
                  _t("Les peines "),
                  _t("1° (dissolution) et 3° (surveillance judiciaire) "),
                  _t(
                    "ne sont pas applicables aux personnes morales de droit public. ",
                  ),
                  _t(
                    "Elles ne s’appliquent pas non plus aux partis/groupements politiques ni aux syndicats professionnels. ",
                  ),
                  _t(
                    "La dissolution n’est pas applicable aux institutions représentatives du personnel.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ConditionCard(
            title: '3.1.3 — Sanction-réparation (matière correctionnelle)',
            cardColor: isDark
                ? const Color(0xFF221C2A)
                : const Color(0xFFF3E5F5),
            accent: const Color(0xFF7B1FA2),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _Paragraph.rich([
                _t("La sanction-réparation est prévue par "),
                _red("l’article 131-39-1 du Code pénal"),
                _t(
                  ". Elle consiste à indemniser la victime selon un délai et des modalités fixés par la juridiction.",
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                "Elle peut être prononcée à la place ou en même temps que l’amende (plafond : 75 000 € "
                "ou l’amende encourue pour le délit). En cas de non-respect, le juge de l’application des peines "
                "peut ordonner l’exécution de tout ou partie de l’amende.",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3.2 Contraventions
          _ConditionCard(
            title: '3.2 — Peines contraventionnelles',
            cardColor: isDark
                ? const Color(0xFF1A2430)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                _t(
                  "Les peines contraventionnelles applicables aux personnes morales sont prévues par ",
                ),
                _red("les articles 131-40 à 131-44-1 du Code pénal"),
                _t("."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle('3.2.1 — Peines principales'),
              const _BulletPoint(
                text:
                    "Amende : quintuple de celle prévue pour les personnes physiques.",
              ),
              const _BulletPoint(text: "Sanction-réparation."),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _t(
                  "La sanction-réparation peut être prononcée en même temps que l’amende pour les contraventions "
                  "de 5ᵉ classe (",
                ),
                _red("article 131-44-1 du Code pénal"),
                _t(")."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle(
                '3.2.2 — Peines alternatives (5ᵉ classe uniquement)',
              ),
              const _BulletPoint(
                text:
                    "Interdiction d’émettre des chèques (retrait/certifiés) ou d’utiliser des cartes de paiement (1 an max).",
              ),
              const _BulletPoint(
                text:
                    "Confiscation de la chose ayant servi / destinée / produit.",
              ),
              const _BulletPoint(text: "Sanction-réparation."),
              const SizedBox(height: 10),
              const _SubTitle('3.2.3 — Peines complémentaires'),
              const _BulletPoint(
                text:
                    "Pour toutes les contraventions : confiscation de la chose / confiscation de l’animal / interdiction de détenir un animal (3 ans max).",
              ),
              const _BulletPoint(
                text:
                    "Uniquement 5ᵉ classe : interdiction d’émettre des chèques (3 ans max).",
              ),
            ],
          ),

          const SizedBox(height: 10),
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
