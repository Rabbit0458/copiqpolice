import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PortOuUsageArmePage extends StatelessWidget {
  const PortOuUsageArmePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme';

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
            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
            "f00001",
            "Le port ou l’usage d'une arme",
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
                // Bandeau définition légale (sans répéter le titre)
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
                  child: _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00002",
                          "« Est une arme tout objet conçu pour tuer ou blesser.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00003",
                          "Tout autre objet susceptible de présenter un danger pour les personnes est assimilé à une arme dès lors qu'il est utilisé pour tuer, blesser ou menacer ou qu'il est destiné, par celui qui en est porteur, à tuer, blesser ou menacer.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00004",
                          "Est assimilé à une arme tout objet qui, présentant avec l'arme définie au premier alinéa une ressemblance de nature à créer une confusion, est utilisé pour menacer de tuer ou de blesser ou est destiné, par celui qui en est porteur, à menacer de tuer ou de blesser.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00005",
                          "L'utilisation d'un animal pour tuer, blesser ou menacer est assimilée à l'usage d'une arme. En cas de condamnation du propriétaire de l'animal ou si le propriétaire est inconnu, le tribunal peut décider de remettre l'animal à une œuvre de protection animale ou reconnue d'utilité publique ou déclarée, laquelle pourra librement en disposer. »",
                        ),
                  ),
                ),

                const SizedBox(height: 14),

                // 1 : Définition
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                    "f00006",
                    '1 : DÉFINITION',
                  ),
                  cardColor: cardBlue,
                  accent: accentBlue,
                  titleColor: titleColor,
                  children: [
                    _Paragraph.rich([
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00007",
                          "L’article 132-75 du C.P.",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                              "f00008",
                              " définit ce qu’est une arme. Le port ou l’usage d’une arme constitue une circonstance aggravante réelle. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                              "f00009",
                              "Ses effets s’étendent à tous les auteurs, coauteurs et complices de l’infraction.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00010",
                        "L’arme peut également être constitutive d’un des éléments matériels d’infractions autonomes, tel que le port illégal d’arme.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2 : Conditions
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                    "f00011",
                    '2 : CONDITIONS',
                  ),
                  cardColor: cardAmber,
                  accent: accentAmber,
                  titleColor: titleColor,
                  children: [
                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00012",
                        "2.1 - Une arme",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00013",
                          "Le premier alinéa de ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00014",
                          "l’article 132-75 du C.P.",
                        ),
                      ),
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                              "f00015",
                              " concerne les armes par nature tandis que les trois autres concernent des cas assimilés : ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                              "f00016",
                              "armes par destination, armes factices et animal.",
                            ),
                      ),
                    ]),
                    const SizedBox(height: 10),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00017",
                        "2.1.1 - Des armes par nature",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00018",
                            "L’alinéa 1 précise qu’« est une arme tout objet conçu pour tuer ou blesser ». ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00019",
                            "L’arme proprement dite est un objet qui n’a pas d’autre utilité que de donner la mort ou d’occasionner des blessures.",
                          ),
                    ),
                    const SizedBox(height: 8),

                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00020",
                        "Il s’agit notamment :",
                      ),
                    ),
                    const SizedBox(height: 6),
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00021",
                        "Des armes à feu (guerre, défense, chasse, collection), des engins explosifs ou incendiaires et des gaz toxiques.",
                      ),
                    ),
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00022",
                        "Exemples : fusils de chasse, fusils à canon scié, fusils à pompe, grenades, bombes, cocktails Molotov, bombes aérosol au gaz lacrymogène, etc.",
                      ),
                    ),
                    const SizedBox(height: 6),
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00023",
                        "Des armes blanches (tranchantes, perçantes ou contondantes).",
                      ),
                    ),
                    _IntroBullet(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00024",
                        "Exemples : baïonnettes, poignards, matraques, cannes à épée, arbalètes, coups-de-poing américains, lances-pierres de compétition, couteaux à cran d’arrêt, nerfs de bœuf, etc.",
                      ),
                    ),
                    const SizedBox(height: 8),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00025",
                            "Peut aussi constituer une arme un objet transformé pour en faire une : ",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00026",
                            "« un couteau dont les deux côtés de la lame avaient été rendus tranchants par meulage » (Cass. crim., n° 68-91.697 du 29 janvier 1969).",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00027",
                        "2.1.2 - Des cas assimilés",
                      ),
                    ),
                    _Paragraph.rich([
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00028",
                          "Les alinéas 2 à 4 de ",
                        ),
                      ),
                      law(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00029",
                          "l’article 132-75 du C.P.",
                        ),
                      ),
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                          "f00030",
                          " assimilent trois autres cas à l’arme :",
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00031",
                        "2.1.2.1 - Les armes par destination",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00032",
                            "Ce sont des objets susceptibles de présenter un danger pour les personnes. Il s’agit d’instruments, outils, appareils, engins de la vie courante. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00033",
                            "Bien qu’ils ne soient pas conçus pour servir d’arme, ils peuvent être utilisés pour tuer, blesser ou menacer.",
                          ),
                    ),
                    const SizedBox(height: 6),
                    _BulletPoint(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00034",
                        "Exemples : couteau de cuisine, marteau, véhicule automobile, batte de baseball, chaîne à vélo, barre de fer, bouteille, seringue, tabouret de bar, etc.",
                      ),
                    ),

                    const SizedBox(height: 10),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00035",
                        "2.1.2.2 - Les armes factices ou simulées",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00036",
                            "L’objet utilisé pour tromper une personne doit présenter une ressemblance suffisante avec l’arme qu’il imite. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00037",
                            "Son utilisation pour menacer de tuer ou de blesser traduit la volonté de faire croire que l’arme simulée est réelle.",
                          ),
                    ),
                    const SizedBox(height: 6),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00038",
                        "« Une arme factice peut être considérée comme une arme apparente ou cachée » (Cass. crim., n° 92-82.717 du 5 août 1992).",
                      ),
                    ),

                    const SizedBox(height: 10),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00039",
                        "2.1.2.3 - Les animaux",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00040",
                            "L’utilisation d’un animal pour tuer, blesser ou menacer est assimilée à l’usage d’une arme. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00041",
                            "Cet alinéa vise notamment l’utilisation de chiens comme arme.",
                          ),
                    ),

                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00042",
                        "2.2 - Son utilisation",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00043",
                        "L’arme peut constituer une circonstance aggravante lorsqu’elle a été utilisée ou portée.",
                      ),
                    ),
                    const SizedBox(height: 6),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00044",
                        "2.2.1 - L’usage et la menace d’une arme",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00045",
                        "Il ne suffit pas que l’auteur ait été porteur d’une arme : il faut qu’il l’ait utilisée pour tuer, blesser ou menacer.",
                      ),
                    ),
                    const SizedBox(height: 8),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00046",
                        "2.2.2 - Le port d’une arme",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00047",
                        "Dans ce cas, il suffit que l’auteur ait été porteur d’une arme apparente ou cachée au moment des faits.",
                      ),
                    ),

                    const SizedBox(height: 12),

                    _SubTitle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00048",
                        "2.3 - Le but poursuivi",
                      ),
                    ),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00049",
                        "L’arme peut, lorsque l’individu en a fait usage ou en a seulement été porteur, constituer une circonstance aggravante d’une infraction commise ou tentée pour laquelle la loi l’a prévu.",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3 : Champ d'application
                _ConditionCard(
                  title: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                    "f00050",
                    '3 : CHAMP D’APPLICATION',
                  ),
                  cardColor: cardTeal,
                  accent: accentTeal,
                  titleColor: titleColor,
                  children: [
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00051",
                        "Le code pénal prévoit que la circonstance d’usage ou menace d’une arme est susceptible d’aggraver les infractions suivantes :",
                      ),
                    ),
                    SizedBox(height: 10),

                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00052",
                            "Les tortures ou actes de barbarie (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00053",
                            "article 222-3 10° C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00054",
                            "Le viol (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00055",
                            "article 222-24 7° C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00056",
                            "Les agressions sexuelles (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00057",
                            "article 222-28 5° C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00058",
                            "Les agressions sexuelles sur mineur de 15 ans ou sur personne particulièrement vulnérable (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00059",
                            "article 222-30 al. 6 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00060",
                            "Les violences (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00061",
                            "articles 222-8, 222-10, 222-12, 222-13 10° et 222-14-5 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00062",
                            "L’évasion (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00063",
                            "article 434-30 al. 1 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00064",
                            "Le concours à une évasion (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00065",
                            "article 434-32 al. 3 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),

                    SizedBox(height: 12),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00066",
                        "Le code pénal prévoit que la circonstance de port d’arme est susceptible d’aggraver les infractions suivantes :",
                      ),
                    ),
                    SizedBox(height: 10),

                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00067",
                            "Le proxénétisme (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00068",
                            "article 225-7 al. 8 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00069",
                            "La participation à un attroupement (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00070",
                            "article 431-5 al. 1 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00071",
                            "La participation à une manifestation ou à une réunion publique (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00072",
                            "article 431-10 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00073",
                            "La rébellion (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00074",
                            "article 433-8 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),

                    SizedBox(height: 12),
                    _Paragraph(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                        "f00075",
                        "Le code pénal prévoit enfin que la circonstance d’usage, menace ou port d’une arme est susceptible d’aggraver les infractions suivantes :",
                      ),
                    ),
                    SizedBox(height: 10),

                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00076",
                            "Le vol (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00077",
                            "article 311-8 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00078",
                            "L’extorsion (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00079",
                            "article 312-5 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),
                    _LawBulletRow(
                      textSpans: [
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00080",
                            "L’extorsion en bande organisée (",
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                            "f00081",
                            "article 312-6 al. 3 C.P.",
                          ),
                          style: TextStyle(
                            color: lawRed,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(text: ")."),
                      ],
                    ),

                    SizedBox(height: 12),
                    _NotaBox(
                      bodySpans: [
                        TextSpan(
                          text:
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                                "f00082",
                                "Retenir la circonstance aggravante suppose de distinguer :\n",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                                "f00083",
                                "• l’arme par nature ;\n",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                                "f00084",
                                "• les cas assimilés (destination, factice/simulée, animal) ;\n",
                              ) +
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/dps_dpg/sanction_pages/causes_aggravation_sanction/port_ou_usage_arme_page.dart",
                                "f00085",
                                "• et le critère « usage/menace » versus « port » selon l’infraction visée.",
                              ),
                        ),
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

/// Ligne “bullet” compatible avec ton rendu, mais en RichText pour pouvoir mettre les articles en rouge.
class _LawBulletRow extends StatelessWidget {
  const _LawBulletRow({required this.textSpans});

  final List<TextSpan> textSpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: textColor,
                ),
                children: textSpans,
              ),
            ),
          ),
        ],
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
