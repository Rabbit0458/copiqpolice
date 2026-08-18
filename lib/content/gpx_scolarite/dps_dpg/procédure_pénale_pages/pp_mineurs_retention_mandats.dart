import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// Texte rouge pour les articles de loi / références légales
TextSpan _lawRef(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700),
  );
}

class PPMineursRetentionMandatsPage extends StatelessWidget {
  const PPMineursRetentionMandatsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_mineurs_retention_mandats';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF10141A) : const Color(0xFFFFFFFF);

    final textMain = GoogleFonts.fustat(
      fontSize: 15.5,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : const Color(0xFF0D47A1),
    );

    final textSoft = GoogleFonts.fustat(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : const Color(0xFF424242),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
            "f00002",
            'Rétention & mandats — mineurs',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================= EN-TÊTE CHAPITRE =======================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF0D47A1), const Color(0xFF002171)]
                        : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00003",
                        'CHAPITRE 3 : RÉTENTION DANS LE CADRE DES MANDATS',
                      ),
                      style: textMain,
                    ),
                    const SizedBox(height: 8),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00004",
                          'Un mineur peut être placé en rétention dans le cadre d’un mandat d’amener ou d’arrêt, en application de ',
                        ),
                      ),
                      _lawRef(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00005",
                          'l’article 133-1 du Code de procédure pénale',
                        ),
                      ),
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00006",
                          ', ou lorsqu’il est appréhendé en exécution d’un mandat d’arrêt européen, en application des ',
                        ),
                      ),
                      _lawRef(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00007",
                          'articles 695-26 et suivants du Code de procédure pénale',
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ]),
                  ],
                ),
              ),

              ////////////////////////////////////////////////////////////////
              /// 3.1 — DILIGENCES SPÉCIFIQUES
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                  "f00008",
                  '3.1 — Diligences spécifiques',
                ),
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00009",
                        'L’',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00010",
                        'article L. 332-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00011",
                        ' prévoit que les dispositions des ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00012",
                        'articles L. 413-1 à L. 413-15 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00013",
                            ' (retenue et garde à vue) relatives à l’assistance par un avocat, à l’examen médical et à l’enregistrement audiovisuel des auditions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00014",
                            'sont applicables au mineur placé en rétention dans le cadre des mandats.',
                          ),
                    ),
                  ]),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00015",
                      '3.1.1 — Avis obligatoire aux représentants légaux',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00016",
                          'L’officier de police judiciaire doit, dès le début de la rétention, informer les représentants légaux, la personne ou le service auquel le mineur est confié ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00017",
                          'ou, dans les cas prévus, un autre adulte approprié.',
                        ),
                  ),
                  const SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                              "f00018",
                              'L’obligation d’informer les représentants légaux se cumule avec le droit, pour le mineur, de faire prévenir un tiers (et, le cas échéant, son employeur et les autorités consulaires), ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                              "f00019",
                              'prévu par ',
                            ),
                      ),
                      _lawRef(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00020",
                          'l’article 63-2 du Code de procédure pénale',
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00021",
                      '3.1.1.1 — Mineur de moins de 13 ans',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00022",
                        'Conformément à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00023",
                        'l’article L. 413-3 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00024",
                            ', les représentants légaux sont informés du fait que le mineur doit être assisté par un avocat et qu’ils peuvent en désigner un ou demander ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00025",
                            'qu’il en soit commis un d’office.',
                          ),
                    ),
                  ]),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00026",
                      '3.1.1.2 — Mineur de plus de 13 ans',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00027",
                        'En application des ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00028",
                        'articles L. 413-7 et L. 413-9 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00029",
                            ', les représentants légaux sont également informés du droit du mineur à être assisté par un avocat. Lorsque le mineur n’a pas sollicité ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00030",
                            'l’assistance d’un avocat, ses représentants légaux sont avisés de leur droit d’en faire la demande.',
                          ),
                    ),
                  ]),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00031",
                      '3.1.2 — Examen médical',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00032",
                        'Les modalités de l’examen médical sont prévues par les ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00033",
                        'articles L. 413-4 et L. 413-8 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00034",
                      '3.1.2.1 — Mineur de moins de 16 ans',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00035",
                        'Dès le début de la rétention, le procureur de la République ou le juge d’instruction désigne un médecin qui examine le mineur, dans les conditions prévues à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00036",
                        'l’article 63-3 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00037",
                      '3.1.2.2 — Mineur de plus de 16 ans',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00038",
                        'Le mineur âgé de plus de 16 ans doit être informé de son droit de demander à être examiné par un médecin au début de la mesure, conformément à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00039",
                        'l’article 63-3 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00040",
                      'Les représentants légaux du mineur sont avisés de leur droit de demander un examen médical lorsqu’ils sont informés de la rétention.',
                    ),
                  ),
                  const SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00041",
                      'Le tiers éventuellement prévenu de la mesure, ainsi que l’avocat du mineur, peuvent également demander que celui-ci fasse l’objet d’un examen médical.',
                    ),
                  ),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00042",
                      '3.1.3 — Assistance par un avocat',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00043",
                        'Le mineur placé en rétention est assisté d’un avocat, dans les conditions prévues aux ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00044",
                        'articles 63-3-1 à 63-4-4 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00045",
                            'Lorsque le mineur ou ses représentants légaux n’ont pas désigné d’avocat, le procureur de la République, le juge d’instruction ou l’officier de police judiciaire demande au bâtonnier, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                            "f00046",
                            'par tout moyen, dès le début de la rétention, qu’il en soit commis un d’office, conformément aux ',
                          ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00047",
                        'articles L. 413-5 et L. 413-9 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00048",
                      '3.1.4 — Enregistrement audiovisuel des auditions',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00049",
                        'L’',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00050",
                        'article L. 332-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00051",
                        ' renvoie aux dispositions relatives à l’enregistrement audiovisuel des auditions des mineurs placés en retenue ou en garde à vue (',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00052",
                        'articles L. 413-12 à L. 413-15 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00053",
                        '), rendant ainsi obligatoire l’enregistrement des auditions des mineurs placés en rétention dans le cadre des mandats.',
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 3.2 — DROIT À L’INFORMATION ET À L’ACCOMPAGNEMENT
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                  "f00054",
                  '3.2 — Droit à l’information et à l’accompagnement',
                ),
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00055",
                      '3.2.1 — Information du mineur',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00056",
                        'La notification des droits d’un mineur doit être réalisée dans des termes simples et accessibles, conformément à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00057",
                        'l’article D. 12-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00058",
                      '3.2.1.1 — Mandats d’amener et d’arrêt',
                    ),
                  ),
                  _Paragraph.rich([
                    const TextSpan(text: 'Selon '),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00059",
                        'l’article R. 332-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00060",
                        ', outre les droits prévus à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00061",
                        'l’article 133-1 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00062",
                        ' (droit de faire prévenir un tiers, d’être examiné par un médecin et d’être assisté d’un avocat), il est également notifié au mineur les droits suivants :',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00063",
                      'droit à ce que ses représentants légaux, ou l’adulte approprié mentionné à ',
                    ),
                  ),
                  _Paragraph.rich([
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00064",
                        'l’article L. 311-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00065",
                        ', soient informés et à être accompagné par ceux-ci lors de ses auditions ou interrogatoires, dans les conditions prévues par ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00066",
                        'l’article L. 311-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00067",
                        ', sauf circonstances particulières énoncées au deuxième alinéa de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00068",
                        'l’article L. 413-3 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00069",
                        ' et au deuxième alinéa de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00070",
                        'l’article L. 413-7 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00071",
                        ' (report de l’information des représentants légaux ordonné par le magistrat) ;',
                      ),
                    ),
                  ]),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00072",
                          'droit à la protection de sa vie privée, garanti par l’interdiction de diffuser les enregistrements de ses auditions, par la tenue des audiences en publicité restreinte ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00073",
                          'et par l’interdiction de publier le compte rendu des débats ou tout élément permettant son identification ;',
                        ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00074",
                      'droit d’être détenu séparément des personnes majeures détenues ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00075",
                      'droit à la préservation de sa santé et au respect de sa liberté de religion ou de conviction.',
                    ),
                  ),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00076",
                      '3.2.1.2 — Mandat d’arrêt européen',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00077",
                        'En matière de mandat d’arrêt européen, en plus des droits prévus à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00078",
                        'l’article 695-27 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00079",
                        ' (information sur l’existence et le contenu du mandat, droit d’être assisté d’un avocat, possibilité de consentir ou de s’opposer à la remise, droit de recevoir copie d’une éventuelle décision de condamnation), sont également notifiés au mineur les droits suivants, en application de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00080",
                        'l’article R. 332-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ' :'),
                  ]),
                  const SizedBox(height: 6),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00081",
                      'droit à ce que ses représentants légaux ou l’adulte approprié mentionné à l’',
                    ),
                  ),
                  _Paragraph.rich([
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00082",
                        'article L. 311-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00083",
                        ' soient informés et à être accompagné par ceux-ci lors de ses auditions ou interrogatoires, dans les conditions prévues par ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00084",
                        'l’article L. 311-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00085",
                        ', sauf circonstances particulières prévues au deuxième alinéa de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00086",
                        'l’article L. 413-3 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00087",
                        ' et au deuxième alinéa de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00088",
                        'l’article L. 413-7 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ' ;'),
                  ]),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00089",
                      'droit à la protection de sa vie privée (mêmes garanties que ci-dessus) ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00090",
                      'droit d’assister aux audiences ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00091",
                      'droit d’être accompagné par ses représentants légaux ou par l’adulte approprié mentionné à ',
                    ),
                  ),
                  _Paragraph.rich([
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00092",
                        'l’article L. 311-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00093",
                        ' au cours des audiences ;',
                      ),
                    ),
                  ]),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00094",
                      'droit à une évaluation éducative personnalisée ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00095",
                      'droit de bénéficier de l’aide juridictionnelle dans les conditions fixées par la ',
                    ),
                  ),
                  _Paragraph.rich([
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00096",
                        'loi n° 91-647 du 10 juillet 1991 relative à l’aide juridique',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 16),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00097",
                      '3.2.2 — Information des responsables légaux',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00098",
                        'Il s’agit de l’un des principes généraux de la procédure pénale applicable aux mineurs, énoncé à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00099",
                        'l’article L. 12-5 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00100",
                        ' : « les responsables légaux reçoivent les mêmes informations que celles qui doivent être communiquées au mineur au cours de la procédure. Le mineur en est informé ». ',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00101",
                        'L’',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00102",
                        'article D. 311-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00103",
                        ' précise que « chaque fois qu’une information est donnée au mineur, elle est également donnée, par tout moyen et dans les meilleurs délais, aux représentants légaux ou à l’adulte approprié ». ',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00104",
                      'En cas de rétention dans le cadre d’un mandat, les représentants légaux doivent être informés :',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00105",
                      'de la mesure à laquelle le mineur est soumis ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00106",
                      'de l’ensemble des droits dont bénéficie le mineur dans le cadre de cette mesure ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00107",
                      'des droits qu’ils peuvent eux-mêmes exercer, à savoir notamment :',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00108",
                      'le droit de désigner un avocat ou de demander qu’il en soit commis un d’office ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00109",
                      'le droit de demander un examen médical pour le mineur âgé d’au moins 16 ans placé en rétention ou en garde à vue (pour un mineur de moins de 16 ans, cet examen est obligatoire).',
                    ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00110",
                      'Dans certains cas, les représentants légaux sont empêchés d’exercer leurs droits d’être informés et d’accompagner le mineur. Ces droits sont alors exercés par un adulte approprié (voir ci-après : « Accompagnement du mineur »).',
                    ),
                  ),

                  const SizedBox(height: 16),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00111",
                      '3.2.3 — Accompagnement du mineur',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00112",
                        'Le régime de l’accompagnement est défini aux ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00113",
                        'articles L. 311-1 à L. 311-4 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00114",
                      '3.2.3.1 — Principe',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00115",
                        'Le mineur a le droit d’être accompagné par ses représentants légaux lors de ses auditions ou interrogatoires si l’autorité qui procède à l’acte estime que cela est conforme à son intérêt supérieur et que la présence de ces personnes ne portera pas préjudice à la procédure (',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00116",
                        'article L. 311-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00117",
                      'Les représentants légaux sont convoqués, si nécessaire, lors des auditions. L’audition peut débuter en leur absence à l’issue d’un délai de deux heures à compter du moment où ils ont été avisés.',
                    ),
                  ),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00118",
                      '3.2.3.2 — Exceptions',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00119",
                      'L’information n’est pas délivrée aux titulaires de l’autorité parentale et le mineur n’est pas accompagné par ceux-ci lorsque :',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00120",
                      'cela serait contraire à l’intérêt supérieur du mineur (par exemple : incarcération ou éloignement parental, rupture prolongée des liens familiaux) ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00121",
                      'cela n’est pas possible, parce qu’aucun titulaire de l’autorité parentale ne peut être joint malgré des démarches raisonnables, ou que leur identité est inconnue (ces démarches doivent être retracées en procédure) ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00122",
                      'ou encore, lorsque leur présence pourrait, sur la base d’éléments objectifs et factuels, compromettre de manière significative la procédure pénale (par exemple, parents impliqués dans l’infraction reprochée au mineur).',
                    ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00123",
                        'Au cours de l’enquête, cette appréciation relève de l’officier ou de l’agent de police judiciaire, sous réserve des instructions éventuelles du magistrat. Les représentants légaux recouvrent leur droit d’être informés et d’accompagner le mineur lorsque les conditions ayant justifié l’empêchement ne sont plus réunies (',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00124",
                        'article L. 311-4 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00125",
                      '3.2.3.3 — Désignation d’un adulte approprié',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00126",
                      'Lorsque l’une ou plusieurs des conditions d’empêchement sont réunies, un adulte approprié doit être désigné pour recevoir les informations et assurer l’accompagnement du mineur à la place des représentants légaux.',
                    ),
                  ),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00127",
                      '3.2.3.3.1 — Désignation par le mineur',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00128",
                          'Le mineur peut désigner un adulte approprié, qui doit être accepté en tant que tel par l’autorité compétente, pour recevoir les mêmes informations que lui et l’accompagner au cours de la procédure. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00129",
                          'Il peut choisir toute personne majeure, qu’elle soit ou non un membre de sa famille.',
                        ),
                  ),
                  const SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00130",
                      'L’enquêteur peut refuser cette désignation si l’intervention de cette personne semble contraire aux intérêts du mineur ou de nature à compromettre le déroulement de la procédure. En cas de doute, l’officier de police judiciaire peut en référer au magistrat compétent.',
                    ),
                  ),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00131",
                      '3.2.3.3.2 — Désignation par le magistrat',
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00132",
                      '3.2.3.3.2.1 — Parmi les proches du mineur',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00133",
                          'Lorsque le mineur n’a désigné aucun adulte ou que l’adulte désigné n’est pas jugé approprié, le procureur de la République, le juge des enfants ou le juge d’instruction désigne, en tenant compte de l’intérêt supérieur de l’enfant, une autre personne pour recevoir les informations et accompagner le mineur. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00134",
                          'Cette désignation relève de la seule compétence du magistrat, qui privilégie en principe un proche du mineur.',
                        ),
                  ),

                  const SizedBox(height: 6),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00135",
                      '3.2.3.3.2.2 — L’administrateur ad hoc',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00136",
                        'Si aucun autre adulte ne peut être désigné, le procureur de la République, le juge des enfants ou le juge d’instruction choisit un administrateur ad hoc, sur la liste prévue par les ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00137",
                        'articles 706-51, R. 53 et R. 53-6 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00138",
                        ', en application de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00139",
                        'l’article D. 311-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00140",
                      '3.2.3.3.3 — Rôle de l’adulte approprié',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00141",
                        'Le rôle de l’adulte approprié, y compris lorsqu’il s’agit d’un administrateur ad hoc, est défini par ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                        "f00142",
                        'l’article L. 311-3 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00143",
                      'L’adulte approprié ne dispose pas de l’ensemble des droits reconnus aux titulaires de l’autorité parentale. Il ne peut notamment pas demander que le mineur soit assisté par un avocat qu’il aurait lui-même choisi.',
                    ),
                  ),
                  const SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00144",
                          'En revanche, il est informé des droits notifiés au mineur et doit être convoqué aux auditions si cela apparaît nécessaire. En son absence, les auditions peuvent se dérouler à l’issue d’un délai de deux heures à compter de l’avis. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                          "f00145",
                          'S’il ne répond pas aux convocations, les auditions peuvent valablement se poursuivre en son absence, après mention en procédure.',
                        ),
                  ),
                  const SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mineurs_retention_mandats.dart",
                      "f00146",
                      'S’il assiste à des auditions, l’adulte approprié ne peut intervenir pendant leur déroulement. Il peut cependant demander un examen médical du mineur placé en rétention (en pratique, cette faculté concerne surtout les mineurs de 16 à 18 ans).',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
