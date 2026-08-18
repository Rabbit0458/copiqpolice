import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ContrainteAtteinteSexuelleTiersPage extends StatelessWidget {
  const ContrainteAtteinteSexuelleTiersPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

    // Palette par section (cohérente avec tes autres pages)
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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
            "f00001",
            "Contrainte en vue de subir une atteinte sexuelle (tiers)",
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
              // ✅ EXIGENCE : l’article qui définit l’élément légal en tout premier
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
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
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00003",
                        "Article 222-22-2 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00004",
                            " : prévoit et réprime le fait d’imposer à une personne, par violence, contrainte, menace ou surprise, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00005",
                            "de subir une atteinte sexuelle de la part d’un tiers ou de procéder sur elle-même à une telle atteinte.",
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                  "f00006",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00007",
                          "Le fait d’imposer à une personne, par violence, contrainte, menace ou surprise, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00008",
                          "de subir une atteinte sexuelle de la part d’un tiers ou de procéder sur elle-même à une telle atteinte ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00009",
                          "est une agression sexuelle et constitue une infraction.",
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00010",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00011",
                      "Infraction d’« agression sexuelle » : on impose à la victime de subir une atteinte sexuelle par un tiers (ou sur elle-même).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00012",
                      "Les moyens visés par le texte (violence, contrainte, menace, surprise) excluent un consentement libre.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // I — Élément légal
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                  "f00013",
                  "I — Élément légal",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00014",
                        "Article 222-22-2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00015",
                            " : incrimine le fait d’imposer, par violence, contrainte, menace ou surprise, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00016",
                            "à une personne de subir une atteinte sexuelle de la part d’un tiers ou de procéder sur elle-même à une telle atteinte.",
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // II — Élément matériel
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                  "f00017",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00018",
                          "Les agissements sont commis par une personne qui impose à la victime de subir des atteintes sexuelles. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00019",
                          "Ils supposent l’emploi de violence, contrainte, menace ou surprise.",
                        ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00020",
                      "1) Absence de consentement de la victime",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00021",
                        "L’auteur utilise certains moyens pour atteindre son but en dehors de la volonté de la victime (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00022",
                        "Cass. crim., 29 avril 1960",
                      ),
                    ),
                    normal("). "),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00023",
                        "Ces moyens sont fixés par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00024",
                        "l’article 222-22-2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00025",
                        " : violence, contrainte, menace ou surprise, exclusives de tout consentement libre.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00026",
                      "2) Les moyens : violence, contrainte/menace, surprise",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00027",
                      "• La violence",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00028",
                          "Il s’agit de violences physiques exercées directement sur la victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00029",
                          "Elles doivent être suffisantes pour paralyser sa résistance. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00030",
                          "Les juges apprécient concrètement la résistance de la victime (jurisprudence aujourd’hui moins exigeante qu’avant).",
                        ),
                  ),

                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00031",
                      "• La contrainte ou la menace",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00032",
                        "Ces moyens visent à supprimer le consentement de la victime ; ils peuvent relever de violences morales. ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00033",
                        "L’article 222-22-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00034",
                            " précise que la contrainte peut être physique ou morale. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00035",
                            "La menace ou la contrainte doivent inspirer une crainte sérieuse et immédiate, appréciée concrètement ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00036",
                            "selon la capacité de résistance de la victime (",
                          ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00037",
                        "Cass. crim., 8 juin 1994",
                      ),
                    ),
                    normal(")."),
                  ]),

                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00038",
                      "• La surprise",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00039",
                          "La surprise s’entend comme « surprendre le consentement », et non comme la surprise ressentie par la victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00040",
                          "Elle concerne notamment les victimes dont la maturité est insuffisante pour comprendre l’acte imposé, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00041",
                          "ou des personnes dont l’état (troubles mentaux/handicap) les rend incapables de consentir. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00042",
                          "Le juge apprécie l’impossibilité de consentir au moment des faits.",
                        ),
                  ),

                  const SizedBox(height: 12),

                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                              "f00043",
                              "L’imprégnation alcoolique ou la consommation de stupéfiants en toute connaissance de cause ne suffit pas, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                              "f00044",
                              "à elle seule, à caractériser un état de vulnérabilité pour certaines aggravations. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                              "f00045",
                              "En revanche, l’administration à l’insu de la victime d’une substance altérant le discernement est une ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                              "f00046",
                              "circonstance aggravante (loi n°2018-703 du 3 août 2018).",
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00047",
                      "3) Faits commis sur un mineur",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00048",
                          "La contrainte morale ou la surprise peuvent résulter d’une différence d’âge et/ou de l’autorité de droit ou de fait ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00049",
                          "exercée sur la victime. Une autorité de fait peut être caractérisée par une différence d’âge significative entre ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00050",
                          "une victime mineure et un auteur majeur. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00051",
                          "Pour un mineur de 15 ans, la contrainte morale ou la surprise peuvent être caractérisées par l’abus de vulnérabilité ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00052",
                          "lié à l’absence de discernement nécessaire.",
                        ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00053",
                      "4) Une atteinte sexuelle par un tiers… ou sur soi-même",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00054",
                          "L’incrimination vise celui qui contraint une personne à avoir des relations à caractère sexuel avec un tiers, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00055",
                          "même si ce tiers n’était pas informé de la contrainte. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00056",
                          "Elle vise aussi celui qui impose à la victime de procéder sur elle-même à une atteinte sexuelle.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00057",
                      "L’infraction est assimilée à un viol ou à une agression sexuelle selon la nature de l’atteinte subie.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00058",
                      "Repères : viol vs agression sexuelle",
                    ),
                  ),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00059",
                        "Article 222-23 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00060",
                            " (viol) : « tout acte de pénétration sexuelle, de quelque nature qu’il soit, ou tout acte bucco-génital » ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00061",
                            "commis sur autrui ou sur l’auteur. Cela inclut notamment pénétration dans le sexe ou par le sexe, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00062",
                            "ainsi que des actes bucco-génitaux (ex. fellation, cunnilingus).",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00063",
                      "L’agression sexuelle implique un contact physique entre l’agresseur et la victime, sans pénétration ni acte bucco-génital.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // III — Élément moral
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                  "f00064",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00065",
                      "Intention coupable",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00066",
                          "Comme pour tout crime ou délit, l’incrimination exige une intention coupable. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00067",
                          "L’auteur sait qu’il va faire subir à la victime, par un tiers ou par la victime elle-même, un acte à caractère sexuel contre son gré. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00068",
                          "Cette intention est le plus souvent indissociable de l’acte matériel.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // IV — Circonstances aggravantes
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                  "f00069",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00070",
                          "Les circonstances aggravantes applicables dépendent de la qualification finale (viol ou agression sexuelle) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                          "f00071",
                          "et renvoient aux fiches relatives à ces infractions.",
                        ),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00072",
                      "Circonstances aggravantes des viols : voir les fiches relatives aux viols.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00073",
                      "Circonstances aggravantes des agressions sexuelles : voir les fiches relatives aux agressions sexuelles.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // V — Répression / tentative / complicité
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                  "f00074",
                  "V — Répression, tentative et complicité",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00075",
                      "Peines encourues",
                    ),
                  ),
                  _Paragraph.rich([
                    normal("Selon "),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00076",
                        "l’article 222-22-2 alinéa 2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00077",
                            ", ces faits sont punis des peines prévues aux articles 222-23 à 222-30 du C.P., ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                            "f00078",
                            "selon la nature de l’atteinte subie et les circonstances mentionnées à ces mêmes articles.",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00079",
                        "Sont notamment visés les viols définis aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00080",
                        "articles 222-23, 222-23-1 et 222-23-2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00081",
                        ", ainsi que les agressions sexuelles définies aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00082",
                        "articles 222-27, 222-29, 222-29-1, 222-29-2 et 222-29-3 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00083",
                        ", avec leurs aggravations éventuelles.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00084",
                        "Responsabilité pénale des personnes morales : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00085",
                        "article 222-33-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00086",
                        " (amende + peines complémentaires prévues à ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00087",
                        "l’article 131-39 du C.P.",
                      ),
                    ),
                    normal(")."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00088",
                        "Tentative : OUI — spécialement prévue par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00089",
                        "l’article 222-22-2 alinéa 3 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00090",
                        ". Elle couvre notamment les situations où les pressions exercées sur la victime n’ont pas été suivies d’effet.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                      "f00091",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00092",
                        "Complicité : OUI — s’applique au fait principal punissable. Fondement : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00093",
                        "article 121-7 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers_page.dart",
                        "f00094",
                        ". Elle suppose un fait de complicité prévu par la loi : aide et assistance, provocation ou instructions données.",
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
