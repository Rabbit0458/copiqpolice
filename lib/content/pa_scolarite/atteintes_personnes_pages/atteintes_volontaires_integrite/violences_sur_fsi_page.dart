import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaViolencesSurFsiPage extends StatelessWidget {
  const PaViolencesSurFsiPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/violences_sur_fsi';

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
          "Atteintes volontaires à l’intégrité",
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
            "Les violences sur les forces de sécurité intérieure\nou sur les élus locaux",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (propre + pédagogique)
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Constituent des infractions les violences commises dans un cadre professionnel/fonctionnel "
                "sur certaines catégories de personnes (forces de sécurité intérieure, personnels concourant à leurs missions, "
                "élus locaux), ainsi que, dans certains cas, sur leurs proches.",
              ),
              SizedBox(height: 10),
              _SubTitle("Sont visées (en résumé) :"),
              _IntroBullet(
                text:
                    "Les forces de sécurité intérieure et assimilés (police, gendarmerie, douanes, pénitentiaire, pompiers, etc.).",
              ),
              _IntroBullet(
                text:
                    "Les militaires déployés sur le territoire national dans le cadre des réquisitions prévues à "
                    "l’article L. 1321-1 du code de la défense.",
              ),
              _IntroBullet(
                text:
                    "Les élus locaux (et, jusqu’à 6 ans après la fin du mandat, l’ancien titulaire d’un mandat électif public).",
              ),
              _IntroBullet(
                text:
                    "Les proches (conjoint, ascendants/descendants, personne vivant habituellement au domicile) lorsque les violences sont commises en raison des fonctions.",
              ),
              _IntroBullet(
                text:
                    "Les personnels concourant aux missions (réservistes, contractuels, administratifs, service civique…) agissant sous l’autorité des personnes visées.",
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
                  text: "Article 222-14-5 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " : définit et réprime les violences commises sur ces personnes (et, selon les cas, sur leurs proches).",
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
              _SubTitle("A) Un acte positif"),
              _Paragraph(
                "Les violences supposent une action : elles impliquent un comportement positif. "
                "La simple abstention ne peut constituer une violence.",
              ),
              SizedBox(height: 12),

              _SubTitle("1) Un contact physique (direct ou indirect)"),
              _Paragraph(
                "Sont compris tous les comportements impliquant un contact physique (coups, gifles, morsures, etc.). "
                "Le contact peut être indirect : la violence peut être réalisée au moyen d’une arme, d’un objet quelconque, "
                "ou d’une morsure par un animal excité par l’auteur.",
              ),

              SizedBox(height: 12),

              _SubTitle(
                "2) Une atteinte psychique (violences psychologiques)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les violences peuvent être matérialisées par une agression psychique : des agissements de nature à impressionner vivement la victime "
                      "et à lui causer un choc émotif, voire un trouble psychologique ",
                ),
                TextSpan(
                  text: "(Cass. crim., 18 mars 2008, n° 07-86.075)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Cette solution est codifiée par "),
                TextSpan(
                  text: "l’article 222-14-3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " : les violences au sens des articles 222-7 et suivants sont constituées quelle que soit leur nature, "
                      "y compris lorsqu’il s’agit de violences psychologiques.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Jurisprudence : individu descendant de sa voiture avec une barre de fer et frappant l’arrière du véhicule de la victime ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 18 mars 2008)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Une victime particulière (liste + logique)"),
              _Paragraph("Le texte vise une liste exhaustive :"),
              SizedBox(height: 8),

              _SubTitle("1) Membres des forces de sécurité intérieure"),
              _BulletPoint(
                text: "Militaire de la gendarmerie nationale.",
              ),
              _BulletPoint(
                text:
                    "Militaire déployé sur le territoire national dans le cadre des opérations intérieures (ex. Sentinelle).",
              ),
              _BulletPoint(text: "Fonctionnaire de la police nationale."),
              _BulletPoint(text: "Agent de police municipale."),
              _BulletPoint(text: "Garde champêtre."),
              _BulletPoint(text: "Agent des douanes."),
              _BulletPoint(
                text: "Sapeur-pompier professionnel ou volontaire.",
              ),
              _BulletPoint(
                text: "Agent de l’administration pénitentiaire.",
              ),

              SizedBox(height: 12),

              _SubTitle("2) Élus locaux (et anciens élus récents)"),
              _Paragraph(
                "Sont également visées les personnes titulaires d’un mandat électif public, "
                "ou qui l’étaient au cours des six années précédant les faits (députés, sénateurs, maires, présidents d’exécutifs locaux, "
                "adjoints, conseillers municipaux, etc.).",
              ),

              SizedBox(height: 12),

              _SubTitle(
                "3) Leurs proches (si le mobile est lié aux fonctions)",
              ),
              _Paragraph("Peuvent être victimes :"),
              SizedBox(height: 6),
              _BulletPoint(text: "Le conjoint."),
              _BulletPoint(
                text: "Les ascendants ou descendants en ligne directe.",
              ),
              _BulletPoint(
                text: "Toute autre personne vivant habituellement au domicile.",
              ),

              SizedBox(height: 12),

              _SubTitle("4) Personnels concourant aux missions"),
              _Paragraph(
                "Sont visées les personnes affectées dans les services (police/gendarmerie/police municipale/pénitentiaire) "
                "qui agissent sous l’autorité des personnes mentionnées : réservistes, contractuels, personnels administratifs, "
                "service civique, etc. (qualité apparente ou connue de l’auteur).",
              ),

              SizedBox(height: 14),

              _SubTitle("C) Un contexte imposé par le texte"),
              _Paragraph(
                "Les violences doivent être commises :\n"
                "• soit dans l’exercice des fonctions (victime en service / accomplissant un acte entrant dans ses attributions) ;\n"
                "• soit du fait des fonctions actuelles ou passées (en raison d’un acte déterminé de la fonction).\n"
                "La qualité de la victime doit être apparente ou connue de l’auteur.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Pour les proches : les violences doivent être commises en raison des fonctions exercées par la personne visée "
                "(cela implique que l’auteur connaissait la qualité de ce proche).",
              ),

              SizedBox(height: 14),

              _SubTitle("D) Un résultat dommageable"),
              _Paragraph(
                "Les violences supposent une atteinte à l’intégrité physique et/ou psychique. "
                "La réalité de l’atteinte doit être établie (notamment par certificat médical).",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "L’"),
                TextSpan(
                  text: "article 222-14-5 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " distingue deux hypothèses selon le préjudice :\n"
                      "• I.T.T. > 8 jours ;\n"
                      "• I.T.T. ≤ 8 jours, ou absence d’incapacité de travail.",
                ),
              ]),
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
                "L’auteur doit avoir conscience de commettre un acte de violence qui va affecter l’intégrité physique et/ou psychique d’autrui. "
                "Il doit également vouloir commettre des violences sur une personne dont la qualité (protégée) est déterminée "
                "(qualité apparente ou connue).",
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
                "Le régime d’aggravation varie selon la gravité (I.T.T. ≤ 8 jours / aucune I.T.T. ou I.T.T. > 8 jours).",
              ),
              SizedBox(height: 10),

              _SubTitle("A) Si aucune I.T.T. ou I.T.T. ≤ 8 jours"),
              _Paragraph.rich([
                TextSpan(
                  text: "Le texte renvoie à des circonstances listées aux ",
                ),
                TextSpan(
                  text: "8° à 15° de l’article 222-12 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Par plusieurs personnes agissant en qualité d’auteur ou de complice.",
              ),
              _BulletPoint(
                text: "Avec préméditation ou avec guet-apens.",
              ),
              _BulletPoint(text: "Avec usage ou menace d’une arme."),
              _BulletPoint(
                text:
                    "Dans un établissement d’enseignement/éducation ou dans des locaux de l’administration (ou aux abords, lors des entrées/sorties du public).",
              ),
              _BulletPoint(
                text:
                    "Par un majeur agissant avec l’aide ou l’assistance d’un mineur.",
              ),
              _BulletPoint(
                text:
                    "Dans un moyen de transport collectif de voyageurs, ou à l’accès à un tel moyen/lieu.",
              ),
              _BulletPoint(
                text:
                    "Par une personne en état d’ivresse manifeste ou sous l’emprise manifeste de stupéfiants.",
              ),
              _BulletPoint(
                text:
                    "Par une personne dissimulant volontairement tout ou partie de son visage pour ne pas être identifiée.",
              ),

              SizedBox(height: 10),
              _SubTitle(
                "Degrés d’aggravation (I.T.T. ≤ 8 / aucune I.T.T.)",
              ),
              _BulletPoint(
                text: "1er degré : présence d’une de ces circonstances.",
              ),
              _BulletPoint(
                text:
                    "2e degré : présence d’au moins deux de ces circonstances.",
              ),

              SizedBox(height: 14),

              _SubTitle("B) Si I.T.T. > 8 jours"),
              _Paragraph(
                "Un degré d’aggravation est prévu lorsque les faits sont accompagnés d’une de ces circonstances aggravantes.",
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
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),

              // ITT <= 8 / aucune ITT
              _Paragraph.rich([
                TextSpan(text: "Aucune I.T.T. ou I.T.T. ≤ 8 jours : "),
                TextSpan(
                  text: "5 ans d’emprisonnement et 75 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-14-5 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Aggravation (1 circonstance des 8° à 15° de l’art. 222-12) : ",
                ),
                TextSpan(
                  text: "7 ans d’emprisonnement et 100 000 € d’amende — ",
                ),
                TextSpan(
                  text: "article 222-14-5 alinéa 4 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Aggravation (au moins 2 circonstances des 8° à 15° de l’art. 222-12) : ",
                ),
                TextSpan(
                  text:
                      "10 ans d’emprisonnement et 150 000 € d’amende (période de sûreté) — ",
                ),
                TextSpan(
                  text: "article 222-14-5 alinéa 5 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              // ITT > 8
              _Paragraph.rich([
                TextSpan(text: "I.T.T. > 8 jours : "),
                TextSpan(
                  text:
                      "10 ans d’emprisonnement et 150 000 € d’amende (période de sûreté) — ",
                ),
                TextSpan(
                  text: "article 222-14-5 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Si les faits sont accompagnés d’une circonstance des 8° à 15° de l’art. 222-12 : ",
                ),
                TextSpan(text: "aggravation prévue par "),
                TextSpan(
                  text: "l’article 222-14-5 alinéa 4 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les personnes morales peuvent être déclarées pénalement responsables et encourent les peines prévues par ",
                ),
                TextSpan(
                  text: "l’article 222-16-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(
                text:
                    "Tentative : NON (les textes relatifs aux violences délictuelles ne visent pas la tentative).",
              ),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
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
