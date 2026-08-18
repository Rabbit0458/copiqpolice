import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaVictimeDepositaireAutoritePage extends StatelessWidget {
  const PaVictimeDepositaireAutoritePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/causes_aggravation_sanction/victime_depositaire_autorite';

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

    const accentBlue = Color(0xFF1565C0);
    const accentAmber = Color(0xFFF9A825);
    const accentTeal = Color(0xFF00897B);

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
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
            "f00001",
            "Victime dépositaire de l'autorité publique",
          ),
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
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: .06,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: .08,
                      ),
                    ),
                  ),
                  child: _Paragraph.rich([
                    TextSpan(text: "« "),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00002",
                        "Sur un magistrat, un juré, un avocat, un officier public ou ministériel, un membre ou un agent de la Cour pénale internationale, un militaire de la gendarmerie nationale, un fonctionnaire de la police nationale, des douanes, de l'administration pénitentiaire ou toute autre personne dépositaire de l'autorité publique, un sapeur-pompier ou un marin-pompier, un gardien assermenté d'immeubles ou de groupes d'immeubles ou un agent exerçant pour le compte d'un bailleur des fonctions de gardiennage ou de surveillance des immeubles à usage d'habitation en application de l'article L. 271-1 du Code de la sécurité intérieure, dans l'exercice ou du fait de ses fonctions, lorsque la qualité de la victime est apparente ou connue de l'auteur.",
                      ),
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: " »"),
                  ]),
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                    "f00003",
                    '1 : DÉFINITION',
                  ),
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00004",
                        "Cette circonstance aggravante accroît la protection due aux personnes particulièrement exposées à diverses infractions en raison des fonctions qu'elles exercent. Non seulement la personne est protégée mais aussi, à travers elle, sa fonction.",
                      ),
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00005",
                        "L'infraction doit être en rapport direct avec la fonction pour que la circonstance aggravante puisse être retenue.",
                      ),
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00006",
                        "Il s'agit d'une circonstance aggravante réelle. Ses effets s'étendent à tous les auteurs, coauteurs et complices de l'infraction.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                    "f00007",
                    '2 : CONDITIONS',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00008",
                        "2.1 - La qualité de dépositaire de l'autorité publique",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00009",
                          "Est dépositaire de l'autorité publique celui qui a ",
                        ),
                      ),
                      TextSpan(
                        text: "« ",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00010",
                          "un pouvoir de décision fondé sur la parcelle de l'autorité publique que lui confèrent ses fonctions, qu'il soit fonctionnaire au sens strict, militaire, magistrat, officier public ou ministériel",
                        ),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: " »."),
                    ]),
                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00011",
                        "2.1.1 - Les personnes énumérées par le C.P.",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00012",
                        "Les magistrats, les jurés, les avocats, les officiers publics ou ministériels, les membres ou agents de la Cour pénale internationale, les militaires de la gendarmerie nationale, les fonctionnaires de la police nationale, des douanes, de l'administration pénitentiaire.",
                      ),
                    ),
                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00013",
                        "2.1.2 - Les autres personnes dépositaires de l'autorité publique",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00014",
                        "Toutes les personnes entrant dans le champ d'application des textes prévus. Il s'agit par exemple du président de la République, des ministres, des secrétaires d'État, des maires et adjoints, des notaires, des huissiers, des commissaires-priseurs, des inspecteurs des finances publiques, des agents assermentés de la S.N.C.F., des gardes-chasse, etc.",
                      ),
                    ),
                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00015",
                        "2.1.3 - Les personnes assimilées n'exerçant pas des fonctions d'autorité",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00016",
                          "Il s'agit des sapeurs-pompiers ou marins-pompiers, des gardiens d'immeubles ou de groupes d'immeubles ou des agents exerçant pour le compte d'un bailleur des fonctions de gardiennage ou de surveillance des immeubles à usage d'habitation en application de l'article ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00017",
                          "L. 271-1 du code de la sécurité intérieure",
                        ),
                      ),
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00018",
                          " (dispositions tendant à limiter les atteintes aux biens et à prévenir les troubles de voisinage en imposant à certains bailleurs le gardiennage et la surveillance de leurs bâtiments).",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00019",
                        "2.2 - L'exercice ou le fait des fonctions",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00020",
                        "La personne doit avoir été victime des faits répréhensibles alors qu'elle était en service ou qu'elle procédait à un des actes entrant dans ses attributions (dans l'exercice de ses fonctions) ou en raison des fonctions exercées ou d'un acte antérieurement accompli (du fait de ses fonctions, expression remplaçant « à l'occasion de ses fonctions »).",
                      ),
                    ),
                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00021",
                        "2.3 - La qualité apparente ou connue de l'auteur",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                        "f00022",
                        "Il s'agit de la même condition que celle liée à la particulière vulnérabilité. Elle implique donc que l'auteur agit en raison de la qualité de la victime.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                    "f00023",
                    "3 : CHAMP D'APPLICATION",
                  ),
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00024",
                          "➤ LE MEURTRE (ARTICLE ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00025",
                          "221-4, 4° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00026",
                          "➤ L'EMPOISONNEMENT (ARTICLE ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00027",
                          "221-5 al. 3 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00028",
                          "➤ LES TORTURES OU ACTES DE BARBARIE (ARTICLE ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00029",
                          "222-3, 4° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00030",
                          "➤ LES VIOLENCES VOLONTAIRES (ARTICLES ",
                        ),
                      ),
                      law("222-8"),
                      const TextSpan(text: ", "),
                      law("222-10"),
                      const TextSpan(text: ", "),
                      law("222-12*"),
                      const TextSpan(text: " ET "),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00031",
                          "222-13*, 4° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00032",
                          "➤ L'ADMINISTRATION DE SUBSTANCES NUISIBLES (ARTICLE ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00033",
                          "222-15 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00034",
                          "➤ LES DESTRUCTIONS, DÉGRADATIONS ET DÉTÉRIORATIONS (ARTICLE ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00035",
                          "322-3, 3° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00036",
                          "➤ LES DESTRUCTIONS, DÉGRADATIONS OU DÉTÉRIORATIONS DANGEREUSES POUR LES PERSONNES (ARTICLE ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                          "f00037",
                          "322-8, 3° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")"),
                    ]),
                    const SizedBox(height: 12),
                    _NotaBox(
                      title: 'NOTA',
                      bodySpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                            "f00038",
                            "Les violences volontaires avec ITT ≤ et > à 8 jours à l'encontre des forces de sécurité intérieure ou des élus locaux sont érigées en infraction autonome (art. ",
                          ),
                        ),
                        law(
                          ScolariteText.value(
                            "lib/content/pa_scolarite/sanction_pages/causes_aggravation_sanction/victime_depositaire_autorite_page.dart",
                            "f00039",
                            "222-14-5 du C.P.",
                          ),
                        ),
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
