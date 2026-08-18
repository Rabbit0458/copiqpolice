import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class BandeOrganiseePage extends StatelessWidget {
  const BandeOrganiseePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/bande_organisee';

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
            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
            "f00001",
            'La bande organisée',
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
                // Bandeau définition (comme sur la capture)
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00002",
                          'LA BANDE ORGANISÉE',
                        ),
                        style: GoogleFonts.fustat(
                          fontSize: 14.5,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Paragraph.rich([
                        TextSpan(
                          text:
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                                "f00003",
                                "« Constitue une bande organisée au sens de la loi tout groupement formé ou toute entente ",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                                "f00004",
                                "établie en vue de la préparation, caractérisée par un ou plusieurs faits matériels, d’une ou plusieurs infractions. »",
                              ),
                        ),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                    "f00005",
                    '1 : DÉFINITION',
                  ),
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00006",
                          "L’article 132-71 du du Code Pénal.",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00007",
                              " définit la bande organisée. Il s’agit d’une circonstance aggravante réelle. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00008",
                              "Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00009",
                          "La notion de bande organisée est proche de celle d’association de malfaiteurs définie par ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00010",
                          "l’article 450-1 du code pénal",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00011",
                              ". Elle diffère de l’association de malfaiteurs qui est une infraction autonome, caractérisée ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00012",
                              "alors même que les opérations projetées sont restées au stade des actes préparatoires. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00013",
                              "La question de la bande organisée quant à elle se pose après commission ou tentative de commission de certaines infractions.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                        "f00014",
                        "Il s’agit d’une forme particulière de préméditation.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                    "f00015",
                    '2 : CONDITIONS',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00016",
                              "« La bande organisée, suppose à la différence de la réunion, que les auteurs, coauteurs de l’infraction ont préparé, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00017",
                              "par des moyens matériels qui sous-entendent l’existence d’une certaine organisation, la commission du crime ou du délit. » ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00018",
                              "(Cass. crim., 14 mai 1993)\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00019",
                              "La réunion présente un caractère fortuit et occasionnel qui suppose une concertation simple sans préméditation.",
                            ),
                      ),
                    ]),
                    SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                        "f00020",
                        "2.1 - Une résolution d’agir en commun antérieure à l’action",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                        "f00021",
                        "Il faut, pour que cette condition soit réalisée, que plusieurs personnes se soient réunies et aient arrêté la résolution d’agir en commun.",
                      ),
                    ),
                    SizedBox(height: 10),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00022",
                              "La bande organisée implique donc la préméditation : « Elle suppose un plan concerté » ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00023",
                              "(Cass. crim., 30 novembre 2005).\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00024",
                              "Doit être établie l’existence de contacts préliminaires, voire d’une convention passée avant l’action.\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00025",
                              "Ainsi, dans le cadre d’un trafic de stupéfiants, la Cour de cassation a relevé que l’existence d’une bande organisée est établie : ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00026",
                              "par les contacts préliminaires pris par « B » avec les convoyeurs de drogue, les entretiens avec les protagonistes de ces transports ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00027",
                              "et sa participation à l’organisation des voyages (Cass. crim., 1er octobre 1998).",
                            ),
                      ),
                    ]),
                    SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                        "f00028",
                        "2.2 - La nécessité d’une organisation",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00029",
                              "La bande organisée suppose une certaine organisation comportant une direction, une hiérarchisation et une distribution des rôles ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00030",
                              "entre les participants : « Organisation structurée et hiérarchisée » (Cass. crim., 11 janvier 2017 ; 4 novembre 2004).\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00031",
                              "La bande organisée est une circonstance aggravante réelle qui ne nécessite pas de démontrer la participation continuelle à l’organisation ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00032",
                              "de l’opération (Cass. crim., 15 septembre 2004).\n\n",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00033",
                              "La jurisprudence ne se prononce pas sur le nombre de personnes nécessaire pour constituer une bande organisée. La notion de pluralité résulte ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                              "f00034",
                              "des termes « bande », « groupement » ou « entente ».",
                            ),
                      ),
                    ]),
                  ],
                ),

                const SizedBox(height: 14),

                // Bloc complément (convention ONU + jurisprudence) + 2.3
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                    "f00035",
                    '2 : CONDITIONS (suite)',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00036",
                            "Pour constituer une bande organisée, il est nécessaire d’être plus de deux. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00037",
                            "La Convention des Nations Unies contre la criminalité transnationale organisée la définit dans les termes suivants : ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00038",
                            "« groupe structuré de trois personnes ou plus existant depuis un certain temps et agissant de concert dans le but de commettre ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00039",
                            "une ou plusieurs infractions graves ou des infractions établies conformément à la présente Convention, pour en tirer directement ou indirectement ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00040",
                            "un avantage financier ou un autre avantage matériel ».",
                          ),
                    ),
                    SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                                "f00041",
                                "Jurisprudence : la seule constitution d’une équipe de plusieurs malfaiteurs ne peut suffire à qualifier la bande organisée, ",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                                "f00042",
                                "dès lors que cette équipe ne répond pas au critère supplémentaire de structure existant depuis un certain temps ",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                                "f00043",
                                "(Cass. crim., 8 juillet 2015).",
                              ),
                        ),
                      ],
                      title: "JURISPRUDENCE",
                    ),
                    SizedBox(height: 12),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                        "f00044",
                        "2.3 - Le but poursuivi",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00045",
                            "Les actes préparatoires peuvent être caractérisés par la conception d’un plan d’exécution de l’infraction, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00046",
                            "par l’acquisition de matériel, par le recrutement de personnel, etc.\n\n",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                            "f00047",
                            "Cette préparation peut ne viser qu’une seule infraction qu’elle ait été commise ou tentée.",
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3 : Champ d'application
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                    "f00048",
                    '3 : CHAMP D’APPLICATION',
                  ),
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                        "f00049",
                        "Le code pénal prévoit que la circonstance de commission en bande organisée est susceptible d’aggraver les infractions suivantes :",
                      ),
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00050",
                          "• Le meurtre (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00051",
                          "article 221-4 8° du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00052",
                          "• L’empoisonnement (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00053",
                          "article 221-5 al. 3 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00054",
                          "• Les tortures ou actes de barbarie (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00055",
                          "article 222-4 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00056",
                          "• Le trafic de stupéfiants (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00057",
                          "articles 222-35 al. 2 et 222-36 al. 2 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00058",
                          "• Le trafic d’armes (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00059",
                          "article 222-57 al. 2 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00060",
                          "• L’enlèvement et la séquestration (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00061",
                          "article 224-5-2 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00062",
                          "• La traite des êtres humains (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00063",
                          "article 225-4-3 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00064",
                          "• Le proxénétisme (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00065",
                          "article 225-8 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00066",
                          "• L’exploitation de la mendicité (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00067",
                          "article 225-12-7 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00068",
                          "• L’exploitation de la vente à la sauvette (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00069",
                          "article 225-12-10 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00070",
                          "• Inciter un mineur à commettre un acte sexuel par voie électronique (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00071",
                          "article 227-22-2 al. 2 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00072",
                          "• Favoriser la corruption de mineur (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00073",
                          "article 227-22 al. 3 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00074",
                          "• La représentation pornographique de mineurs (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00075",
                          "article 227-23 al. 5 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00076",
                          "• Solliciter auprès d’un mineur la diffusion ou la transmission d’images pornographiques de mineurs (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00077",
                          "article 227-23-1 al. 2 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00078",
                          "• Le vol (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00079",
                          "article 311-9 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00080",
                          "• L’extorsion (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00081",
                          "article 312-6 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00082",
                          "• L’escroquerie (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00083",
                          "article 313-2 al. 7 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00084",
                          "• L’abus de confiance (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00085",
                          "article 314-1-1 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00086",
                          "• Le recel (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00087",
                          "article 321-2 2° du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00088",
                          "• Les destructions, dégradations ou détériorations dangereuses pour les personnes (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00089",
                          "article 322-8 1° du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00090",
                          "• Le blanchiment (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00091",
                          "article 324-2 2° du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00092",
                          "• L’évasion (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00093",
                          "article 434-30 al. 2 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00094",
                          "• Le transport ou la mise en circulation de fausse monnaie (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00095",
                          "article 442-2 al. 2 du Code Pénal.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),

                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                        "f00096",
                        "Cette liste, non exhaustive, pourrait utilement être complétée par certaines infractions prévues par des lois particulières telles que :",
                      ),
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00097",
                          "• L’entrée et le séjour des étrangers (",
                        ),
                      ),
                      law("CESEDA"),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00098",
                          "• Les armes et munitions (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00099",
                          "Code de la défense",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00100",
                          "• Les contrefaçons (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00101",
                          "Code de la propriété intellectuelle",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00102",
                          "• Le non-respect des dispositions réglementaires relatives à la production, fabrication, transport, importation, exportation, détention, offre, cession, acquisition et emploi de plantes, de substances ou de préparations classées comme vénéneuses (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00103",
                          "article L. 5432-1 Code de la santé publique",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00104",
                          "• La contrefaçon, la falsification, l’usage, l’acceptation d’un chèque contrefaisant ou falsifié ou d’un autre instrument de paiement ainsi que la tentative de ces délits (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00105",
                          "article L. 163-4-2 Code monétaire et financier",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00106",
                          "• Atteintes à la législation sur les déchets (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                          "f00107",
                          "article L. 541-46 Code de l’environnement",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                                "f00108",
                                "Tous les renvois d’articles et de codes (du Code Pénal., CESEDA, Code de la santé publique, Code monétaire et financier, Code de l’environnement…) ",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/bande_organisee_page.dart",
                                "f00109",
                                "doivent être affichés en rouge pour ressortir immédiatement à la lecture.",
                              ),
                        ),
                      ],
                    ),
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
