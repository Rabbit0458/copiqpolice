import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class QualiteConjointConcubinPartenairePage extends StatelessWidget {
  const QualiteConjointConcubinPartenairePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire';

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

    const Color accentBlue = Color(0xFF1565C0);
    const Color accentAmber = Color(0xFFF9A825);
    const Color accentTeal = Color(0xFF00897B);

    final Color titleColor = isDark ? Colors.white : const Color(0xFF0B1B3A);

    const lawRed = Color(0xFFD32F2F);

    TextSpan law(String text) => TextSpan(
      text: text,
      style: const TextStyle(color: lawRed, fontWeight: FontWeight.w900),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
            "f00001",
            'Qualité de conjoint / concubin / partenaire (PACS)',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
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
                // Bandeau (citation longue)
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
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00002",
                            "« Dans les cas respectivement prévus par la loi ou le règlement, les peines encourues pour un crime, un délit ou une contravention ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00003",
                            "sont aggravées lorsque l’infraction est commise par le conjoint, le concubin ou le partenaire lié à la victime par un pacte civil de solidarité, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00004",
                            "y compris lorsqu’ils ne cohabitent pas.\n\n",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00005",
                            "La circonstance aggravante prévue au premier alinéa est également constituée lorsque les faits sont commis par l’ancien conjoint, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00006",
                            "l’ancien concubin ou l’ancien partenaire lié à la victime par un pacte civil de solidarité. Les dispositions du présent alinéa sont applicables ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00007",
                            "dès lors que l’infraction est commise en raison des relations ayant existé entre l’auteur des faits et la victime. »",
                          ),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                    "f00008",
                    '1 : DÉFINITION',
                  ),
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00009",
                          "L’article 132-80 du C.P.",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00010",
                              " définit la qualité de conjoint, de concubin et de partenaire lié à la victime par un pacte civil de solidarité. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00011",
                              "Il s’agit d’une circonstance aggravante personnelle. Ses effets ne s’étendent pas aux coauteurs de l’infraction.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00012",
                            "Cette circonstance a pour but de réprimer plus sévèrement les infractions commises au sein du couple, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00013",
                            "donc les auteurs d’infractions dites « conjugales ».",
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                    "f00014",
                    '2 : CONDITIONS',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                        "f00015",
                        "2.1 - Une « union » entre l’auteur et la victime",
                      ),
                    ),
                    _Paragraph.rich([
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00016",
                          "L’article 132-80",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00017",
                              " vise trois types d’union entre l’auteur et la victime et ce, quel que soit le sexe de l’un et de l’autre, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00018",
                              "et même s’ils ne cohabitent pas.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                        "f00019",
                        "2.1.1 - Le mariage",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00020",
                            "La circonstance aggravante est constituée dès lors que l’auteur de l’infraction est uni à la victime par les liens du mariage, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00021",
                            "même s’il n’existe pas de communauté de vie entre époux (cas de la victime en instance de divorce avec résidence séparée).",
                          ),
                    ),

                    const SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                        "f00022",
                        "2.1.2 - Le concubinage",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00023",
                          "Il s’agit, selon ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00024",
                          "l’article 515-8 du code civil",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00025",
                              " : « d’une union de fait, caractérisée par une vie commune présentant un caractère de stabilité et de continuité, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00026",
                              "entre deux personnes, de sexe différent ou de même sexe, qui vivent en couple ».\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00027",
                              "L’existence d’un état de concubinage est établie dès lors qu’il est prouvé qu’il y a communauté de vie.",
                            ),
                      ),
                    ]),

                    const SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                        "f00028",
                        "2.1.3 - Le pacte civil de solidarité",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00029",
                          "D’après ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00030",
                          "l’article 515-1 du code civil",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00031",
                              " : « Est un contrat conclu par deux personnes physiques majeures, de sexe différent ou de même sexe, pour organiser leur vie commune ».\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00032",
                              "La circonstance peut être retenue dès lors que le pacte civil de solidarité a uni l’auteur à la victime et ce, jusqu’à ce qu’il soit rompu.",
                            ),
                      ),
                    ]),

                    const SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                        "f00033",
                        "2.1.4 - Le cas du lien rompu",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00034",
                              "Lorsque le lien qui unissait l’auteur à la victime a été rompu, la circonstance peut être cependant retenue, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00035",
                              "à condition que l’infraction soit commise selon des dispositions du second alinéa de ",
                            ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00036",
                          "l’article 132-80",
                        ),
                      ),
                      TextSpan(
                        text:
                            ".\n\n" +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00037",
                              "C’est-à-dire que l’ancien conjoint, l’ancien concubin ou l’ancien partenaire lié à la victime par un pacte civil de solidarité ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00038",
                              "doit avoir agi en raison des relations ayant existé entre lui et la victime. C’est donc le mobile de l’infraction qui permet de retenir ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00039",
                              "la circonstance aggravante.\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                              "f00040",
                              "Il est alors nécessaire de prouver que la commission de l’infraction est en rapport avec le lien qui les unissait avant qu’ils ne soient séparés.",
                            ),
                      ),
                    ]),

                    const SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                        "f00041",
                        "2.2 - But poursuivi",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00042",
                            "Cette circonstance permet de reconnaître la particulière gravité de certaines infractions commises ou tentées ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00043",
                            "par le conjoint, le concubin ou le partenaire de la victime, pour laquelle la loi l’a prévu.",
                          ),
                    ),

                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                                "f00044",
                                "Attention : c’est une circonstance aggravante personnelle (elle ne s’étend pas aux coauteurs). ",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                                "f00045",
                                "En cas de lien rompu, il faut prouver que l’infraction est commise en raison des relations passées (mobile).",
                              ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3 : Champ d'application (tel que ton texte)
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                    "f00046",
                    '3 : CHAMP D’APPLICATION',
                  ),
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _IntroBullet(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00047",
                            "Le code pénal prévoit que la circonstance de commission par le conjoint, le concubin ou le partenaire lié par un PACS ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                            "f00048",
                            "est susceptible d’aggraver notamment :",
                          ),
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00049",
                          "• Le meurtre (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00050",
                          "article 221-4, 9° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00051",
                          "• L’empoisonnement (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00052",
                          "article 221-5 al. 3 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00053",
                          "• Les tortures ou actes de barbarie (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00054",
                          "article 222-3, 6° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00055",
                          "• Les violences ayant entraîné la mort sans intention de la donner (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00056",
                          "article 222-8, 6° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00057",
                          "• Les violences ayant entraîné une mutilation ou une infirmité permanente (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00058",
                          "article 222-10, 6° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00059",
                          "• Les violences ayant entraîné une incapacité totale de travail pendant plus de 8 jours (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00060",
                          "article 222-12, 6° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00061",
                          "• Les violences ayant entraîné une incapacité totale de travail inférieure ou égale à 8 jours ou n’ayant pas entraîné une incapacité de travail (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00062",
                          "article 222-13, 6° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00063",
                          "• Les appels téléphoniques et les envois de messages malveillants, ou agressions sonores (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00064",
                          "article 222-16 al. 2 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00065",
                          "• Les menaces prévues aux ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00066",
                          "articles 222-17 et 222-18 du C.P.",
                        ),
                      ),
                      const TextSpan(text: " ("),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00067",
                          "article 222-18-3 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00068",
                          "• Le viol (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00069",
                          "article 222-24, 11° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00070",
                          "• Les autres agressions sexuelles (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/qualite_conjoint_concubin_partenaire_page.dart",
                          "f00071",
                          "article 222-28, 7° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ IMPORTANT : Tes widgets personnalisés (_ConditionCard, _SubTitle, _Paragraph, etc.)
// sont déjà fournis : colle-les ici EXACTEMENT tels quels, sans modification.

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
