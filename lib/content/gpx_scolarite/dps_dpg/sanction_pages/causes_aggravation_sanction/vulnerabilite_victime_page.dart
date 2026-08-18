import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class VulnerabiliteVictimePage extends StatelessWidget {
  const VulnerabiliteVictimePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime';

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
            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
            "f00001",
            'Vulnérabilité particulière de la victime',
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
                // Bandeau (citation)
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
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00002",
                            "« Sur une personne dont la particulière vulnérabilité due à son âge, à une maladie, à une infirmité, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00003",
                            "à une déficience physique ou psychique ou à un état de grossesse ou résultant de la précarité de sa ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00004",
                            "situation économique ou sociale est apparente ou connue de son auteur. »",
                          ),
                    ),
                  ]),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                    "f00005",
                    '1 : DÉFINITION',
                  ),
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                              "f00006",
                              "Cette circonstance aggravante vise à protéger les victimes hors d’état de le faire vu leur état de faiblesse. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                              "f00007",
                              "Les causes de cette faiblesse sont limitatives et doivent résulter d’un état préexistant aux faits constitutifs ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                              "f00008",
                              "de l’infraction et non être de la conséquence de ces faits eux-mêmes (",
                            ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00009",
                          "Cass. crim., n° 83-94.450 du 17 octobre 1984",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00010",
                        "Il s’agit d’une circonstance aggravante réelle. Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                    "f00011",
                    '2 : CONDITIONS',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00012",
                            "Ces causes de vulnérabilité sont limitées au nombre de sept. Pour être retenue, cette faiblesse particulière ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00013",
                            "doit être apparente ou connue de l’auteur de l’infraction.",
                          ),
                    ),
                    SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00014",
                        "2.1 - Les causes de vulnérabilité",
                      ),
                    ),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00015",
                        "2.1.1 - L’âge",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00016",
                            "Il n’est pas déterminé précisément. La minorité de 15 ans ne rentre pas dans le champ de cette circonstance aggravante ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00017",
                            "puisqu’elle fait l’objet d’une aggravation spécifique. L’aggravation pourra toutefois être retenue lorsque la victime est un mineur ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00018",
                            "de plus de quinze ans.",
                          ),
                    ),
                    SizedBox(height: 10),
                    _Paragraph.rich([
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                              "f00019",
                              "Cette notion ne se suffit pas à elle-même car l’état de faiblesse ne peut résulter du seul âge de la victime ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                              "f00020",
                              "(TGI Montpellier, 7 décembre 2000). Il doit s’y ajouter la preuve d’une vulnérabilité particulière ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                              "f00021",
                              "(Cass. crim., n° 96-80.068 du 30 avril 1996). L’âge plus ou moins avancé de la victime ne suffit pas, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                              "f00022",
                              "à défaut d’autres constatations, à caractériser sa particulière vulnérabilité (Cass. crim., n° 98-84.158 du 23 juin 1999).",
                            ),
                      ),
                    ]),
                    SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00023",
                        "2.1.2 - La maladie, l’infirmité, la déficience physique ou psychique",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00024",
                            "La jurisprudence semble assimiler ces notions vu leur proximité. Il s’agit de dysfonctionnements corporels, physiques ou mentaux, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00025",
                            "innés ou acquis, naturels ou provoqués, organiques ou fonctionnels.\n\n",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00026",
                            "De plus, elles servent parfois à prouver la particulière vulnérabilité due au grand âge.",
                          ),
                    ),
                    SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00027",
                        "2.1.3 - L’état de grossesse",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00028",
                            "Cet état est susceptible d’entraîner une vulnérabilité particulière pendant la grossesse mais aussi après l’accouchement. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00029",
                            "En effet, les observations des autorités médicales mettent en exergue l’état dépressif qu’une grossesse ou qu’un accouchement peut provoquer.",
                          ),
                    ),
                    SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00030",
                        "2.1.4 - La précarité économique ou sociale",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00031",
                            "Elle peut se définir comme « l’absence d’une ou plusieurs des sécurités, notamment celle de l’emploi, permettant aux personnes et familles ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00032",
                            "d’assumer leurs obligations professionnelles, familiales et sociales, et de jouir de leurs droits fondamentaux. »\n\n",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00033",
                            "Il s’agit de personnes vulnérables aux atteintes résultant de l’exploitation de la misère. Leur statut social, marqué par la précarité économique, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00034",
                            "est susceptible de les placer dans une situation de dépendance.",
                          ),
                    ),
                    SizedBox(height: 10),
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00035",
                        "2.2 - L’état apparent ou connu de l’auteur",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00036",
                            "La cause de vulnérabilité doit être soit visible, soit révélée. L’auteur agit donc en raison de la particulière vulnérabilité de la victime. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00037",
                            "La partie poursuivante doit établir que cette condition était apparente ou connue de l’auteur.",
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3 : Champ d'application
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                    "f00038",
                    '3 : CHAMP D’APPLICATION',
                  ),
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                        "f00039",
                        "Cette circonstance aggravante peut notamment s’appliquer aux infractions suivantes :",
                      ),
                    ),
                    const SizedBox(height: 10),

                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00040",
                          "• Le meurtre (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00041",
                          "article 221-4, 3° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00042",
                          "• L’empoisonnement (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00043",
                          "article 221-5 al. 3 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00044",
                          "• Les tortures ou actes de barbarie (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00045",
                          "article 222-3, 2° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00046",
                          "• Les violences volontaires (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00047",
                          "articles 222-8, 222-10, 222-12 et 222-13, 2° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00048",
                          "• L’administration de substances nuisibles (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00049",
                          "article 222-15 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00050",
                          "• Le viol (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00051",
                          "article 222-24, 3° et 3° bis C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00052",
                          "• Les agressions sexuelles (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00053",
                          "article 222-29 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00054",
                          "• Le harcèlement sexuel (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00055",
                          "article 222-33 III, 3° et 4° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00056",
                          "• Le harcèlement moral (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00057",
                          "article 222-33-2-2, 3° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00058",
                          "• La traite des êtres humains (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00059",
                          "article 225-4-1 I C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00060",
                          "• Le proxénétisme (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00061",
                          "article 225-7, 2° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00062",
                          "• Le recours à la prostitution (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00063",
                          "article 225-12-1 al. 2 C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00064",
                          "• Le vol (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00065",
                          "article 311-5, 2° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00066",
                          "• L’extorsion (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00067",
                          "article 312-2, 2° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00068",
                          "• L’escroquerie (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00069",
                          "article 313-2, 4° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00070",
                          "• L’abus de confiance (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00071",
                          "article 314-2, 6° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),
                    const SizedBox(height: 6),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00072",
                          "• Les destructions, dégradations et détériorations (",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                          "f00073",
                          "article 322-3, 2° C.P.",
                        ),
                      ),
                      const TextSpan(text: ")."),
                    ]),

                    const SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/vulnerabilite_victime_page.dart",
                            "f00074",
                            "Pour être retenue, la vulnérabilité doit correspondre à une des causes prévues (liste limitative) et être apparente ou connue de l’auteur.",
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
