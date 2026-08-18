import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaSaisiesScellesPage extends StatelessWidget {
  const PaSaisiesScellesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/saisies_scelles';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);

    final Color cardIndigo = isDark
        ? const Color(0xFF1A1533)
        : const Color(0xFFEDE7F6);
    const cardIndigoAccent = Color(0xFF4527A0);

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
            "f00002",
            'Saisies et scellés',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
              "f00003",
              '3.4 — Les saisies et scellés',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          // Texte d’intro avec les articles en rouge
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w500,
                fontSize: 13.5,
                height: 1.35,
                color: textSoft,
              ),
              children: [
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00004",
                    'Cadre légal des saisies et de la mise sous scellés en information judiciaire (',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00005",
                    'articles 97 et 98 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00006",
                    '), ainsi que saisie pénale des comptes bancaires et actifs numériques.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00007",
                  'Les saisies sur commission rogatoire se font sous le contrôle ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00008",
                  'du juge d’instruction et dans le respect du secret ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00009",
                  'professionnel et des droits de la défense.',
                ),
          ),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00010",
                  'Les scellés garantissent l’intégrité des objets, documents et ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00011",
                  'données informatiques saisis jusqu’à leur ouverture en présence ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00012",
                  'des parties.',
                ),
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.4 — LES SAISIES ET SCELLÉS
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
              "f00013",
              '3.4 — Les saisies et scellés',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              // L’article 97 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00014",
                    'L’article 97 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00015",
                    ' fixe les règles à respecter par le juge d’instruction, ou par l’officier de police judiciaire délégué, pour assurer la légalité des saisies réalisées au cours de l’information judiciaire.',
                  ),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00016",
                      'Lorsque, au cours de l’information, il y a lieu de rechercher ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00017",
                      'des documents ou des données informatiques, le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00018",
                      'd’instruction ou l’officier de police judiciaire commis par lui ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00019",
                      'est seul habilité, sous réserve des nécessités de l’information ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00020",
                      'et du respect du secret professionnel et des droits de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00021",
                      'défense, à en prendre connaissance avant de procéder à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00022",
                      'saisie.',
                    ),
              ),
              SizedBox(height: 10),

              // L’article 98 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00023",
                    'L’article 98 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00024",
                    ' incrimine, sous réserve des nécessités de l’information judiciaire, toute communication ou divulgation, sans autorisation, du contenu d’un document saisi (par exemple lors d’une perquisition) à une personne qui n’est pas légalement qualifiée pour en prendre connaissance.',
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00025",
                      'L’appréciation des nécessités de l’information relève du juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00026",
                      'd’instruction. En pratique, l’officier de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00027",
                      'sollicite donc son autorisation si la présence d’un tiers sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00028",
                      'les lieux de la perquisition, ou la communication d’un document ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00029",
                      'saisi, apparaît nécessaire à la conduite de l’enquête.',
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00030",
                  'Inventaire et mise sous scellés',
                ),
              ),

              // article 97 al. 2 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00031",
                    'Les objets, documents ou données informatiques saisis sont inventoriés immédiatement et placés sous scellés (',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00032",
                    'article 97 alinéa 2 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              SizedBox(height: 6),

              // article 56 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00033",
                    'Lorsque l’inventaire sur place présente des difficultés, l’officier de police judiciaire peut constituer des scellés fermés provisoires, conformément au renvoi à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00034",
                    'l’article 56',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00035",
                    ' : l’inventaire détaillé et la mise sous scellés définitifs interviennent ultérieurement, en présence des personnes qui ont participé à la perquisition.',
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                  "f00036",
                  'Saisie des données informatiques',
                ),
              ),

              // article 97 al. 3 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00037",
                    'La saisie des données informatiques nécessaires à la manifestation de la vérité peut être réalisée en plaçant sous main de justice soit le support physique contenant ces données, soit une copie effectuée en présence des personnes assistant à la perquisition (',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00038",
                    'article 97 alinéa 3 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              SizedBox(height: 6),

              // article 97 al. 4 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00039",
                    'Si une copie est réalisée, le juge d’instruction peut ordonner l’effacement définitif, sur le support resté hors de la main de justice, des données dont la détention ou l’usage est illégal ou dangereux pour la sécurité des personnes ou des biens (',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00040",
                    'article 97 alinéa 4 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              SizedBox(height: 10),

              // article 131-21 + 97 al. 5 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00041",
                    'Avec l’accord du juge d’instruction, seules sont maintenues par l’officier de police judiciaire la saisie des objets, documents et données informatiques utiles à la manifestation de la vérité ainsi que des biens dont la confiscation est prévue à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00042",
                    'l’article 131-21 du Code pénal',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' ('),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00043",
                    'article 97 alinéa 5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              SizedBox(height: 10),

              // article 97 al. 6 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00044",
                    'Les scellés fermés ne peuvent être ouverts, et les documents qu’ils contiennent ne peuvent être dépouillés, qu’en présence de la personne mise en examen assistée de son avocat, ou après que ceux-ci ont été dûment appelés (',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00045",
                    'article 97 alinéa 6 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              SizedBox(height: 14),

              _NotaBox(
                title: 'NOTA',
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00046",
                      'La violation du secret de l’information (divulgation d’un document saisi sans autorisation) expose son auteur à des poursuites délictuelles sur le fondement de ',
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00047",
                      'l’article 98 du Code de procédure pénale.',
                    ),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.5 — SAISIE PÉNALE DES COMPTES BANCAIRES
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
              "f00048",
              '3.5 — La saisie pénale des comptes bancaires',
            ),
            cardColor: cardIndigo,
            accent: cardIndigoAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF311B92),
            children: [
              // article L. 54-10-1 en rouge
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00049",
                    'Dans le cadre d’une procédure de confiscation portant sur des biens ou droits mobiliers incorporels, lorsque la peine de confiscation est prévue par les textes, ou dans le cadre de crimes et délits punis d’une peine d’emprisonnement supérieure à un an, l’officier de police judiciaire peut procéder à la saisie des sommes inscrites sur un compte bancaire, ainsi que des actifs numériques (jetons, crypto-actifs) mentionnés à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                    "f00050",
                    'l’article L. 54-10-1 du Code monétaire et financier.',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00051",
                      'Cette saisie est réalisée sur la base d’une autorisation donnée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00052",
                      'par tout moyen par le juge d’instruction. L’officier de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00053",
                      'judiciaire agit donc toujours dans le cadre strict fixé par le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00054",
                      'magistrat instructeur.',
                    ),
              ),
              SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00055",
                      'Le juge des libertés et de la détention, saisi par le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00056",
                      'd’instruction, se prononce par ordonnance motivée sur le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00057",
                      'maintien ou la mainlevée de la saisie dans un délai de dix jours ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/saisies_scelles.dart",
                      "f00058",
                      'à compter de sa réalisation.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

/// =====================================================================
///  WIDGETS UTILISÉS (identiques à tes autres pages)
/// =====================================================================

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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE D’INTRO
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans});

  final String title = 'NOTA';
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
