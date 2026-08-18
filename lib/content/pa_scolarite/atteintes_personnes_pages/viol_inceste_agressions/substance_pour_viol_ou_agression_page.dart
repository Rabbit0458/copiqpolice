import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaSubstancePourViolOuAgressionPage extends StatelessWidget {
  const PaSubstancePourViolOuAgressionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/substance_pour_viol_ou_agression';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    // Palette cohérente (comme tes autres pages)
    final Color cIntro = isDark
        ? const Color(0xFF101A2B)
        : const Color(0xFFEAF2FF);
    final Color cIntroAccent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    final Color cLegal = isDark
        ? const Color(0xFF1B1420)
        : const Color(0xFFFFEBEE);
    final Color cLegalAccent = isDark
        ? const Color(0xFFE57373)
        : const Color(0xFFC62828);

    final Color cMat = isDark
        ? const Color(0xFF0F1E19)
        : const Color(0xFFE8F5E9);
    final Color cMatAccent = isDark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    final Color cMoral = isDark
        ? const Color(0xFF1A1A11)
        : const Color(0xFFFFF8E1);
    final Color cMoralAccent = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

    final Color cAggr = isDark
        ? const Color(0xFF1A1411)
        : const Color(0xFFFFF3E0);
    final Color cAggrAccent = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFEF6C00);

    final Color cRepr = isDark
        ? const Color(0xFF121821)
        : const Color(0xFFE8EAF6);
    final Color cReprAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF283593);

    // ✅ Articles en rouge (CP/CPP/CSI/etc.)
    TextSpan lawRef(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
    );
    TextSpan normal(String s) => TextSpan(text: s);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
            "f00001",
            "Substance pour commettre un viol ou une agression sexuelle",
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : const Color(0xFF0D1B2A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ EXIGENCE : article légal tout en haut
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00002",
                  "Article de référence (élément légal)",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00003",
                        "Article 222-30-1 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00004",
                        " : définit et réprime l’administration d’une substance afin de commettre un viol ou une agression sexuelle.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00005",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00006",
                          "Le fait d’administrer à une personne, à son insu, une substance de nature à altérer son discernement ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00007",
                          "ou le contrôle de ses actes afin de commettre à son égard un viol ou une agression sexuelle constitue une infraction.",
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00008",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00009",
                      "L’administration doit être faite à l’insu de la victime (elle ne se doute de rien).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00010",
                      "La substance doit altérer le discernement ou le contrôle des actes (soumission chimique).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00011",
                      "L’administration doit être réalisée dans un but sexuel : commettre un viol ou une agression sexuelle.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // I — Élément légal
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00012",
                  "I — Élément légal",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00013",
                        "Article 222-30-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00014",
                        " : incrimine et réprime cette infraction.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // II — Élément matériel
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00015",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00016",
                      "1) Administration d’une substance",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00017",
                      "• Nature de la substance",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00018",
                          "La nature exacte de la substance importe peu dès lors qu’elle est de nature à altérer le discernement ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00019",
                          "ou le contrôle des actes de la victime.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00020",
                      "• Mode d’administration",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00021",
                          "Le mode d’administration varie selon la substance : ingestion, inhalation, injection ou exposition ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00022",
                          "(solide, liquide, gaz ou rayonnement).",
                        ),
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00023",
                      "2) À l’insu de la victime",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00024",
                      "La victime ne se doute pas qu’on lui administre une substance : l’action échappe à son attention.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                              "f00025",
                              "La consommation par la victime d’alcool ou de stupéfiants en toute connaissance de cause ne suffit pas à caractériser ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                              "f00026",
                              "cette infraction. En revanche, l’état d’ivresse peut permettre de qualifier un viol par surprise (",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00027",
                          "Cass. crim., 18 décembre 1991",
                        ),
                      ),
                      normal(")."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00028",
                      "3) Substance de nature à altérer le discernement / le contrôle des actes",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00029",
                          "Il s’agit de substances provoquant des effets comparables à l’ivresse (ex. G.H.B.). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00030",
                          "Elles diminuent la résistance physique et psychique : la victime se trouve dans un état second, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00031",
                          "sans contrôle de sa volonté ni de sa conscience. On parle de « soumission chimique ». ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00032",
                          "Certaines substances ont un effet sédatif et amnésiant, pouvant effacer le souvenir des faits.",
                        ),
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00033",
                      "4) Dans le but de commettre un viol ou une agression sexuelle",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00034",
                          "La substance est administrée en vue de commettre un viol ou une agression sexuelle : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00035",
                          "le but sexuel est un élément déterminant de l’infraction.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // III — Élément moral
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00036",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00037",
                      "1) Connaissance du caractère sédatif / amnésiant",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00038",
                      "L’auteur a conscience du caractère sédatif et/ou amnésiant de la substance administrée.",
                    ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00039",
                      "2) Volonté de profiter de la soumission chimique",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00040",
                          "L’élément moral se traduit par une volonté délibérée et réfléchie de profiter de la soumission chimique ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                          "f00041",
                          "pour commettre un viol ou une agression sexuelle.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // IV — Circonstances aggravantes
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00042",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00043",
                        "Article 222-30-1 alinéa 2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00044",
                        " : l’infraction est aggravée notamment :",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00045",
                      "Lorsque les faits sont commis sur un mineur de 15 ans.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00046",
                      "Lorsque les faits sont commis sur une personne particulièrement vulnérable.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // V — Répression + tentative + complicité
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00047",
                  "V — Répression, tentative et complicité",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00048",
                      "Peines encourues (personnes physiques)",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00049",
                      "L’infraction est un délit. Les peines varient selon qu’il s’agit de la forme simple ou aggravée.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _RepressionTableSubstance(isDark: isDark),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00050",
                        "Responsabilité pénale des personnes morales : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00051",
                        "article 222-33-1 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00052",
                      "Tentative : OUI.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00053",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00054",
                        "Complicité : OUI — punissable conformément aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                        "f00055",
                        "articles 121-6 et 121-7 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                      "f00056",
                      "La complicité par aide ou assistance peut notamment être retenue contre celui qui procure à l’auteur la substance.",
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

class _RepressionTableSubstance extends StatelessWidget {
  const _RepressionTableSubstance({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color head = isDark ? Colors.white : const Color(0xFF0D1B2A);

    Widget cell(String s, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        s,
        style: GoogleFonts.fustat(
          fontSize: 13.5,
          height: 1.2,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
          color: bold ? head : text,
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(14),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(color: border),
          verticalInside: BorderSide(color: border),
        ),
        columnWidths: const {
          0: FlexColumnWidth(1.0),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.6),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.05,
              ),
            ),
            children: [
              cell("Qualification", bold: true),
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00057",
                  "Base légale",
                ),
                bold: true,
              ),
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00058",
                  "Peines principales",
                ),
                bold: true,
              ),
            ],
          ),
          TableRow(
            children: [
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00059",
                  "Délit\n(simple)",
                ),
              ),
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00060",
                  "Art. 222-30-1 (C.P.)",
                ),
              ),
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00061",
                  "5 ans d'emprisonnement\n75 000 € d'amende",
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00062",
                  "Délit\n(aggravé)",
                ),
              ),
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00063",
                  "Art. 222-30-1 al. 2 (C.P.)",
                ),
              ),
              cell(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/substance_pour_viol_ou_agression_page.dart",
                  "f00064",
                  "7 ans d'emprisonnement\n100 000 € d'amende",
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
