import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VictimeChargeeMissionPage extends StatelessWidget {
  const VictimeChargeeMissionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/victime_chargee_mission';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgTop = isDark
        ? const Color(0xFF0B1220)
        : const Color(0xFFEAF2FF);
    final Color bgBottom = isDark ? const Color(0xFF070B12) : Colors.white;

    final Color cardBlue = isDark
        ? const Color(0xFF0F1B2E)
        : const Color(0xFFF3F7FF);
    final Color cardAmber = isDark
        ? const Color(0xFF1B1610)
        : const Color(0xFFFFF7E6);
    final Color cardTeal = isDark
        ? const Color(0xFF0F1E1B)
        : const Color(0xFFF0FFFB);

    final Color accentBlue = const Color(0xFF1565C0);
    final Color accentAmber = const Color(0xFFF9A825);
    final Color accentTeal = const Color(0xFF00897B);

    final Color titleColor = isDark ? Colors.white : const Color(0xFF0B1B3A);

    const Color lawRed = Color(0xFFD32F2F);

    TextSpan law(String txt) => TextSpan(
      text: txt,
      style: const TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Victime chargée d'une mission de service public",
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.8,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Intro (sans répéter le titre dans le body)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(
                      .06,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withOpacity(
                        .08,
                      ),
                    ),
                  ),
                  child: _Paragraph.rich(const [
                    TextSpan(text: "« "),
                    TextSpan(
                      text:
                          "Sur un enseignant ou tout membre des personnels travaillant dans les établissements d'enseignement scolaire, sur un agent d'un exploitant de réseau de transport public de voyageurs ou toute autre personne chargée d'une mission de service public ainsi que sur un professionnel de santé, dans l'exercice de ses fonctions, lorsque la qualité de la victime est apparente ou connue de l'auteur.",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: " »"),
                  ]),
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: '1 : DÉFINITION',
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: const [
                    _Paragraph(
                      "Cette circonstance aggravante accroît la protection due aux personnes particulièrement exposées à diverses infractions en raison des missions qu'elles exercent.",
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Il s'agit d'une circonstance aggravante réelle. Ses effets s'étendent à tous les auteurs, coauteurs et complices de l'infraction.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: '2 : CONDITIONS',
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    const _SubTitle(
                      "2.1 - Les personnes chargées d'une mission de service public",
                    ),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "La circulaire générale d'application du code pénal du 14 mai 1993 estime que cette expression désigne : ",
                      ),
                      const TextSpan(text: "« "),
                      const TextSpan(
                        text:
                            "Les personnes privées ou publiques qui, sans être dépositaires d'une parcelle de l'autorité publique, accomplissent à titre temporaire ou permanent, volontairement ou sur réquisition des autorités, un service quelconque",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: " ». "),
                      const TextSpan(
                        text:
                            "Cette qualité ne peut pas se déduire de la seule appartenance à un établissement public sans caractériser les actes accomplis en matière de service public.",
                      ),
                    ]),
                    const SizedBox(height: 12),

                    const _SubTitle(
                      "2.1.1 - Enseignants et personnels des établissements d'enseignement scolaire",
                    ),
                    const _Paragraph(
                      "Il n'existe pas de distinction concernant les établissements d'enseignement scolaire. Il peut s'agir d'établissements publics ou privés qui regroupent les écoles (maternelles et primaires), collèges, lycées, université ou écoles supérieures.",
                    ),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Le législateur a souhaité protéger par cette circonstance aggravante l'ensemble du corps professoral mais également l'ensemble des personnels travaillant au sein de ces établissements : enseignants (maître des écoles, professeurs, maître de conférence...), personnels de direction, agents administratifs, personnels techniques (entretien et fonctionnement des infrastructures), etc.",
                    ),
                    const SizedBox(height: 12),

                    const _SubTitle(
                      "2.1.2 - Agents d'un exploitant de réseau de transport public de voyageurs",
                    ),
                    const _Paragraph(
                      "Cette expression vise des établissements tels que la RATP ou la SNCF mais également, par exemple, les compagnies chargées d'effectuer le ramassage scolaire.",
                    ),
                    const SizedBox(height: 10),
                    const _Paragraph(
                      "Le législateur a décidé d'étendre l'application de la qualité de personne chargée d'une mission de service public à tous les agents des exploitants, et non seulement aux agents en contact avec le public.",
                    ),
                    const SizedBox(height: 12),

                    const _SubTitle(
                      "2.1.3 - Autres personnes chargées d'une mission de service public",
                    ),
                    const _Paragraph(
                      "La jurisprudence alimente régulièrement cette catégorie de personnes. Sans être exhaustif, on peut citer : un parlementaire, un garde-chasse particulier, un préposé à la distribution du courrier, une gérante d'agence postale d'une commune, un expert nommé par décision judiciaire, un greffier, un gardien de scellés, un médecin requis par un O.P.J., etc.",
                    ),
                    const SizedBox(height: 12),

                    const _SubTitle("2.1.4 - Les professionnels de santé"),
                    const _Paragraph(
                      "Cette adjonction protège dorénavant médecin, infirmier, pharmacien, etc.",
                    ),
                    const SizedBox(height: 12),

                    const _SubTitle("2.1.5 - Les personnes assimilées"),
                    const _Paragraph(
                      "La loi n° 2006-1294 du 23 octobre 2006 assimile les arbitres et juges sportifs à des personnes chargées d'une mission de service public.",
                    ),
                    const SizedBox(height: 12),

                    const _SubTitle("2.2 - L'exercice des fonctions"),
                    const _Paragraph(
                      "La personne chargée d'une mission de service public doit avoir été victime des faits répréhensibles alors qu'elle était en service ou qu'elle procédait à un des actes entrant dans ses attributions (dans l'exercice de ses fonctions).",
                    ),
                    const SizedBox(height: 12),

                    const _SubTitle(
                      "2.3 - La qualité apparente ou connue de l'auteur",
                    ),
                    const _Paragraph(
                      "Il s'agit de la même condition que celle liée à la particulière vulnérabilité. Elle implique donc que l'auteur agit en raison de la qualité de la victime.",
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: "3 : CHAMP D'APPLICATION",
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      const TextSpan(text: "➤ LE MEURTRE (ARTICLE "),
                      law("221-4, 4° bis C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(text: "➤ L'EMPOISONNEMENT (ARTICLE "),
                      law("221-5 C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "➤ LES TORTURES OU ACTES DE BARBARIE (ARTICLE ",
                      ),
                      law("222-3, 4° bis C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text: "➤ LES VIOLENCES VOLONTAIRES (ARTICLES ",
                      ),
                      law("222-8"),
                      const TextSpan(text: ", "),
                      law("222-10"),
                      const TextSpan(text: ", "),
                      law("222-12*"),
                      const TextSpan(text: " ET "),
                      law("222-13*, 4° bis C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "➤ L'ADMINISTRATION DE SUBSTANCES NUISIBLES (ARTICLE ",
                      ),
                      law("222-15 C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      const TextSpan(
                        text:
                            "➤ LES DESTRUCTIONS, DÉGRADATIONS ET DÉTÉRIORATIONS (ARTICLE ",
                      ),
                      law("322-3, 3° C.P."),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 12),
                    _NotaBox(
                      title: 'NOTA',
                      bodySpans: [
                        const TextSpan(
                          text:
                              "Les violences volontaires avec ITT ≤ et > à 8 jours à l'encontre des élus locaux sont érigées en infraction autonome (art. ",
                        ),
                        law("222-14-5 du C.P."),
                        const TextSpan(text: ")."),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ IMPORTANT : tes widgets personnalisés (_ConditionCard, _SubTitle, _Paragraph, _IntroBullet,
// _BulletPoint, _NotaBox) sont déjà fournis : colle-les sous ce commentaire EXACTEMENT tels quels.

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
