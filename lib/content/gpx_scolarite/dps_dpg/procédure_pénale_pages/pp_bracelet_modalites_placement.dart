import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PpBraceletModalitesPlacementPage extends StatelessWidget {
  const PpBraceletModalitesPlacementPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_bracelet_modalites_placement';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF4F6FB);
    const Color articleRed = Color(0xFFD32F2F);

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
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
            "f00002",
            'Surveillance électronique — Modalités',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
              "f00003",
              'CHAPITRE 2\nMODALITÉS DU PLACEMENT SOUS SURVEILLANCE ÉLECTRONIQUE',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              letterSpacing: .3,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00004",
                  'Ce chapitre présente les conditions concrètes de mise en œuvre de la surveillance électronique, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00005",
                  'qu’il s’agisse d’un dispositif fixe lié à une assignation à résidence ou d’un dispositif mobile utilisé ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00006",
                  'dans des hypothèses particulières (infractions graves, violences intrafamiliales, coopération pénale internationale).',
                ),
          ),

          const SizedBox(height: 16),

          // ====================== 2.1 PRINCIPE ==============================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
              "f00007",
              '2.1 — Principe de la surveillance électronique',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00008",
                    'La surveillance électronique s’exerce conformément aux dispositions de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00009",
                    'l’Article 723-8 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                        "f00010",
                        ', qui prévoient la mise en place d’un procédé permettant de détecter à distance la présence ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                        "f00011",
                        'ou l’absence de la personne à son domicile ou dans le lieu d’assignation fixé par le juge.',
                      ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00012",
                      'Concrètement, la personne porte un bracelet ou un autre dispositif électronique relié à un système de contrôle, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00013",
                      'qui vérifie le respect des horaires et des lieux imposés par la décision judiciaire. Toute sortie non autorisée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00014",
                      'ou non-respect des plages horaires peut être immédiatement signalé à l’autorité judiciaire.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========== 2.2 ARSE AVEC SURVEILLANCE MOBILE ===================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
              "f00015",
              '2.2 — Assignation à résidence avec mise sous surveillance électronique mobile',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00016",
                      'Dans certains cas prévus par la loi, il peut être recouru à une surveillance électronique « mobile », ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00017",
                      'permettant de suivre les déplacements de la personne au-delà de son domicile. Ce dispositif renforce le contrôle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00018",
                      'exercé sur les personnes particulièrement dangereuses ou impliquées dans des procédures sensibles.',
                    ),
              ),

              SizedBox(height: 12),

              // ---------- 2.2.1 INFRACTIONS PUNIES DE +7 ANS ----------------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00019",
                  '2.2.1 — Infraction punie de plus de 7 ans et suivi socio-judiciaire',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                        "f00020",
                        'Lorsque l’infraction ayant motivé la mise en examen est punie de plus de sept ans d’emprisonnement et que le suivi ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                        "f00021",
                        'socio-judiciaire est encouru, il peut être fait recours au procédé de surveillance mobile prévu par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00022",
                    'l’Article 763-12 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                        "f00023",
                        '. Dans cette hypothèse, le juge d’instruction exerce les prérogatives habituellement dévolues au juge de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                        "f00024",
                        'l’application des peines pour ce qui concerne la mise en œuvre du dispositif.',
                      ),
                ),
              ]),

              SizedBox(height: 12),

              // ---------- 2.2.2 VIOLENCES / MENACES INTRAFAMILIALES ----------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00025",
                  '2.2.2 — Violences ou menaces au sein du couple ou de la famille',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00026",
                      'L’assignation à résidence avec surveillance électronique mobile peut également être mise en œuvre lorsque la personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00027",
                      'est mise en examen pour certaines violences ou menaces graves commises dans le cadre familial.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00028",
                  'Les faits doivent être punis d’au moins cinq ans d’emprisonnement et être commis :',
                ),
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00029",
                  'contre son conjoint ou son concubin ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00030",
                  'contre son partenaire lié par un pacte civil de solidarité (PACS) ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00031",
                  'contre ses enfants ou ceux de son conjoint, de son concubin ou de son partenaire.',
                ),
              ),
              SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00032",
                    'Ce dispositif spécifique est prévu par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00033",
                    'l’Article 142-12-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00034",
                    ' et s’inscrit dans le renforcement de la lutte contre les violences intrafamiliales.',
                  ),
                ),
              ]),

              SizedBox(height: 12),

              // ---------- 2.2.3 COOPÉRATION PÉNALE INTERNATIONALE ----------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00035",
                  '2.2.3 — Demandes d’extradition et coopérations pénales internationales',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00036",
                      'La surveillance électronique mobile peut enfin être utilisée lorsque la personne fait l’objet d’une procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00037",
                      'de remise ou de coopération pénale internationale. Elle permet alors de garantir la disponibilité de l’intéressé ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                      "f00038",
                      'sans recourir systématiquement à la détention provisoire.',
                    ),
              ),
              SizedBox(height: 8),

              // Demande d'extradition
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00039",
                  'dans le cadre d’une demande d’extradition ;',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00040",
                    'Le fondement juridique est alors donné par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00041",
                    'l’Article 696-11 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),

              // Mandat d'arrêt européen
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00042",
                  'pour l’exécution d’un mandat d’arrêt européen ;',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00043",
                    'La mesure est prévue par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00044",
                    'l’Article 695-28 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),

              // Demande CPI
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00045",
                  'lorsqu’il existe une demande d’arrestation provisoire aux fins de remise à la Cour pénale internationale ;',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00046",
                    'Ce cas de figure est visé par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00047",
                    'l’Article 627-5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 6),

              // Demande d'arrestation provisoire d'un État étranger
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                  "f00048",
                  'ou encore dans le cadre d’une demande d’arrestation provisoire présentée par un État étranger ;',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00049",
                    'dans ce cas, le texte applicable est ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                    "f00050",
                    'l’Article 696-23 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: articleRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                          "f00051",
                          'La surveillance électronique mobile demeure une mesure fortement attentatoire à la liberté d’aller et venir. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                          "f00052",
                          'Elle ne doit être mise en œuvre que lorsque les nécessités de la procédure et la gravité des faits le justifient, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_bracelet_modalites_placement.dart",
                          "f00053",
                          'et lorsqu’aucune autre mesure moins restrictive (contrôle judiciaire simple, ARSE fixe) n’apparaît suffisante.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),
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
