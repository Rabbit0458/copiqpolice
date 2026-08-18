import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// Texte rouge pour les articles de loi
TextSpan _lawRef(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700),
  );
}

class PaPPMineursPrincipesGenerauxPage extends StatelessWidget {
  const PaPPMineursPrincipesGenerauxPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_mineurs_principes_generaux';

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
            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
            "f00002",
            'Principe généraux — mineurs',
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
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00003",
                        'CHAPITRE 1 : PRINCIPES GÉNÉRAUX DE LA JUSTICE PÉNALE DES MINEURS',
                      ),
                      style: textMain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00004",
                        'Le Code de la justice pénale des mineurs (C.J.P.M.) fixe trois principes fondamentaux :',
                      ),
                      style: textSoft,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 8),
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00005",
                        'l’atténuation de la responsabilité pénale du mineur ;',
                      ),
                    ),
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00006",
                        'la primauté de la réponse éducative sur la réponse répressive ;',
                      ),
                    ),
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00007",
                        'le jugement par une juridiction spécialisée.',
                      ),
                    ),
                    const SizedBox(height: 8),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                              "f00008",
                              'Le C.J.P.M. ajoute en liminaire que l’intérêt supérieur de l’enfant doit être pris en compte. ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                              "f00009",
                              'Cette notion, consacrée à ',
                            ),
                      ),
                      _lawRef(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00010",
                          'l’article 3 de la Convention internationale des droits de l’enfant',
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                              "f00011",
                              ' adoptée par les Nations unies le 20 novembre 1989, est érigée en principe directeur de l’ensemble ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                              "f00012",
                              'de la procédure pénale applicable aux mineurs.',
                            ),
                      ),
                    ]),
                  ],
                ),
              ),

              ////////////////////////////////////////////////////////////////
              /// 1.1 — PRÉSOMPTION DE DISCERNEMENT
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                  "f00013",
                  '1.1 — Présomption de discernement (art. L. 11-1 du C.J.P.M.)',
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
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00014",
                        'Le C.J.P.M. reprend le principe énoncé à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00015",
                        'l’article 122-8 du Code pénal',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00016",
                            '. Les mineurs capables de discernement sont pénalement responsables des faits (crimes, délits, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00017",
                            'contraventions) dont ils sont reconnus coupables, leur responsabilité pénale étant subordonnée à leur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00018",
                            'capacité de discernement.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00019",
                      'Le seuil de capacité de discernement et, par voie de conséquence, de responsabilité pénale est fixé à l’âge de 13 ans.',
                    ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00020",
                      'Ainsi sont établies deux présomptions :',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00021",
                      'présomption de non discernement pour les mineurs âgés de moins de treize ans ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00022",
                      'présomption de discernement pour les mineurs âgés de treize ans et plus.',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00023",
                            'Ces présomptions peuvent être renversées. La capacité de discernement ou l’absence de discernement du mineur peut être établie ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00024",
                            'par les éléments issus de la procédure (',
                          ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00025",
                        'article R. 11-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ') :'),
                  ]),
                  const SizedBox(height: 6),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00026",
                      'déclarations du mineur, de son entourage familial et scolaire ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00027",
                      'éléments de l’enquête ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00028",
                      'circonstances dans lesquelles les faits ont été commis ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00029",
                      'antécédents éventuels du mineur ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00030",
                      'expertise ou examen psychiatrique ou psychologique.',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00031",
                      'Cette capacité de discernement se définit comme étant le fait, pour le mineur :',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00032",
                      'de comprendre et vouloir l’acte reproché ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00033",
                      'et d’être apte à comprendre le sens de la procédure pénale dont il fait l’objet.',
                    ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00034",
                      'Elle relève de l’appréciation souveraine du magistrat.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 1.2 — LES GRANDS PRINCIPES
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                  "f00035",
                  '1.2 — Les grands principes',
                ),
                cardColor: isDark
                    ? const Color(0xFF10141A)
                    : const Color(0xFFF5F7FB),
                accent: isDark
                    ? const Color(0xFF64B5F6)
                    : const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  // 1.2.1 Primauté de l’éducatif / atténuation
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00036",
                      '1.2.1 — Primauté de l’éducatif et atténuation de la responsabilité pénale',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00037",
                        'Le C.J.P.M. consacre ces principes aux ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00038",
                        'articles L. 11-2, L. 11-3, L. 11-4 et L. 11-5 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00039",
                            '. La réponse éducative doit être privilégiée, les peines n’intervenant qu’à titre subsidiaire et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00040",
                            'toujours en tenant compte de l’âge, de la personnalité et de la situation du mineur.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00041",
                      '1.2.1.1 — Mineur de moins de 13 ans',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00042",
                          'Les seuils de capacité de discernement et de responsabilité pénale étant fixés à l’âge de 13 ans, aucune peine ne peut être encourue ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00043",
                          'en dessous de cet âge. Des mesures éducatives peuvent toutefois être prononcées si, et seulement si, il est établi que le mineur était ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00044",
                          'capable de discernement au moment des faits.',
                        ),
                  ),
                  const SizedBox(height: 8),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00045",
                      '1.2.1.2 — Mineur âgé d’au moins 13 ans',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00046",
                          'À compter de 13 ans, des mesures éducatives et/ou des peines peuvent être prononcées à l’encontre du mineur. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00047",
                          'L’atténuation de la responsabilité pénale implique cependant que la nature et le quantum des peines soient adaptés à son âge et à sa ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00048",
                          'personnalité, en tenant compte de son évolution.',
                        ),
                  ),

                  const SizedBox(height: 14),

                  // 1.2.2 Spécialisation des acteurs
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00049",
                      '1.2.2 — La spécialisation des acteurs (art. L. 12-1 et suivants du C.J.P.M.)',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00050",
                            'Les crimes, délits et contraventions de la cinquième classe reprochés à un mineur sont instruits et jugés par des juridictions et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00051",
                            'chambres spécialement compétentes, conformément aux ',
                          ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00052",
                        'articles L. 12-1 et suivants du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ' :'),
                  ]),
                  const SizedBox(height: 6),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00053",
                      'le juge des enfants ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00054",
                      'le tribunal pour enfants ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00055",
                      'le juge d’instruction chargé spécialement des affaires concernant les mineurs ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00056",
                      'le juge des libertés et de la détention chargé spécialement des affaires concernant les mineurs ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00057",
                      'la cour d’assises des mineurs (les assesseurs sont juges des enfants) ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00058",
                      'la chambre spéciale des mineurs ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00059",
                      'la chambre de l’instruction spécialement composée.',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00060",
                            'Les fonctions du ministère public, pour les crimes, délits et contraventions de cinquième classe, sont exercées par le procureur général ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00061",
                            'ou par un magistrat du ministère public spécialement chargé des affaires de mineurs (',
                          ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00062",
                        'article L. 12-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00063",
                        'En cas d’urgence ou d’empêchement, tout magistrat du parquet peut exercer ces fonctions, conformément à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00064",
                        'l’article L. 211-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00065",
                            'La mise en œuvre des décisions prises en application du C.J.P.M. est confiée aux services et établissements de la protection judiciaire ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                            "f00066",
                            'de la jeunesse (PJJ) et, dans les cas expressément prévus, au secteur associatif habilité (',
                          ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00067",
                        'article L. 241-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 14),

                  // 1.2.3 Droits spécifiques des mineurs
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00068",
                      '1.2.3 — Les droits spécifiques des mineurs (art. L. 12-4 et L. 12-5 du C.J.P.M.)',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00069",
                          'Aux différentes phases de la procédure, certaines garanties revêtent un caractère constant et sont érigées en principes généraux applicables ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                          "f00070",
                          'à tout mineur mis en cause.',
                        ),
                  ),

                  const SizedBox(height: 10),

                  // 1.2.3.1 Assistance par un avocat
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00071",
                      '1.2.3.1 — Assistance du mineur par un avocat (art. L. 12-4 du C.J.P.M.)',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00072",
                        'Le mineur est assisté par un avocat à tous les stades de la procédure, en application de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00073",
                        'l’article L. 12-4 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00074",
                        '. Dans la mesure du possible, le même avocat doit poursuivre son intervention à chaque étape, notamment lorsqu’il est désigné d’office.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00075",
                        'Le mineur doit recevoir notification de ses droits dans des termes simples et accessibles (',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00076",
                        'article D. 12-2 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00077",
                        '). Lorsqu’une décision prise à son égard est susceptible de recours, il en est informé ainsi que ses représentants légaux (',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00078",
                        'article D. 12-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 10),

                  // 1.2.3.3 Information des représentants légaux
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00079",
                      '1.2.3.3 — Information des représentants légaux et accompagnement du mineur (art. L. 12-5 du C.J.P.M.)',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00080",
                        'Les représentants légaux, ou à défaut un adulte approprié, reçoivent les mêmes informations que celles communiquées au mineur, en vertu de ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00081",
                        'l’article L. 12-5 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00082",
                        '. Le mineur a le droit d’être accompagné par ses représentants légaux ou, à défaut, par un adulte approprié tout au long de la procédure.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 10),

                  // 1.2.3.4 Publicité restreinte
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                      "f00083",
                      '1.2.3.4 — Publicité restreinte (art. L. 13-3 du C.J.P.M.)',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00084",
                        'L’identité ou l’image d’un mineur mis en cause ne peut, en aucune circonstance, être directement ou indirectement rendue publique, conformément à ',
                      ),
                    ),
                    _lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00085",
                        'l’article L. 13-3 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_mineurs_principes_generaux.dart",
                        "f00086",
                        '. Cette règle protège le mineur contre toute stigmatisation et garantit la confidentialité des procédures le concernant.',
                      ),
                    ),
                  ]),
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
