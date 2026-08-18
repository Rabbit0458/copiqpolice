import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaEnlevementSequestrationPage extends StatelessWidget {
  const PaEnlevementSequestrationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/enlevement_sequestration';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    // Palette cohérente
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

    // Helpers TextSpan (articles en rouge)
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
            "f00001",
            "Enlèvement & séquestration",
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
              // ✅ Exigence : élément légal en haut
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
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
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00003",
                        "Article 224-1 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00004",
                        " : prévoit et réprime les infractions d’arrestation, enlèvement, détention et séquestration.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                  "f00005",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00006",
                          "Le fait, sans ordre des autorités constituées et hors les cas prévus par la loi, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00007",
                          "d’arrêter, d’enlever, de détenir ou de séquestrer une personne constitue une infraction.",
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00008",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00009",
                      "4 verbes = 4 infractions autonomes (arrestation / enlèvement / détention / séquestration).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00010",
                      "Point commun : entraver la liberté d’aller et venir.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00011",
                      "Condition négative : absence d’ordre de la loi / de l’autorité légitime.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
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
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00013",
                        "Article 224-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00014",
                            " : incrimine l’arrestation, l’enlèvement, la détention ou la séquestration, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00015",
                            "sans ordre des autorités constituées et hors les cas prévus par la loi.",
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                  "f00016",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00017",
                      "1) La commission d’un acte (4 infractions autonomes)",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00018",
                      "• Arrestation",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00019",
                          "Appréhender physiquement une personne à l’endroit où elle se trouve, de manière à la priver ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00020",
                          "de sa liberté d’aller et venir.",
                        ),
                  ),
                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00021",
                      "• Enlèvement",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00022",
                          "Entraîner la victime de l’endroit où elle se trouve pour la déplacer vers un lieu différent. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00023",
                          "Durant ce déplacement, la victime est privée de sa liberté d’aller et venir.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00024",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                              "f00025",
                              "Victime maintenue à l’arrière d’un véhicule et transportée, sans possibilité de fuite, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                              "f00026",
                              "vers un lieu où elle ne voulait pas aller : ",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00027",
                          "Cass. crim., 23 février 2000",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00028",
                      "• Détention",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00029",
                          "La détention consiste à retenir une personne contre son gré, en la privant de sa liberté d’aller et venir. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00030",
                          "L’atteinte à la liberté de mouvement doit se prolonger.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00031",
                      "Exemple classique : des salariés grévistes retiennent des cadres/dirigeants jusqu’à acceptation de revendications.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00032",
                      "• Séquestration",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00033",
                          "La distinction détention / séquestration est délicate. Selon certains auteurs, la séquestration ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00034",
                          "serait une détention doublée d’inconfort (conditions plus contraignantes).",
                        ),
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00035",
                      "2) Absence d’élément justificatif (condition négative)",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00036",
                          "L’existence d’un ordre de la loi ou d’un commandement de l’autorité légitime empêche l’infraction ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00037",
                          "d’être constituée.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00038",
                        "Exemple : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00039",
                        "article 73 du Code de procédure pénale",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00040",
                        " — permet à toute personne d’appréhender l’auteur d’un crime ou d’un délit flagrant.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00041",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                              "f00042",
                              "Ne commet pas une arrestation/détention illégale la personne ayant appréhendé l’auteur d’un vol ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                              "f00043",
                              "et l’ayant retenu jusqu’à l’arrivée de l’OPJ : ",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00044",
                          "Cass. crim., 1er octobre 1979",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                  "f00045",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00046",
                      "Conscience d’entraver la liberté d’aller et venir",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00047",
                            "L’intention délictueuse est caractérisée par la volonté d’empêcher la victime d’aller et venir ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00048",
                            "librement pendant un temps plus ou moins long ou de l’isoler du monde extérieur. ",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00049",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00050",
                          "Définition de l’intention : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00051",
                          "T. corr. Caen, 24 novembre 1972",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                  "f00052",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00053",
                        "Article 224-2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00054",
                        " : deux degrés d’aggravation.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00055",
                      "• Premier degré (224-2 al. 1)",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00056",
                      "La victime a subi une mutilation ou une infirmité permanente (volontairement provoquée ou résultant des conditions de détention, d’une privation d’aliments ou de soins).",
                    ),
                  ),
                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00057",
                      "• Second degré (224-2 al. 2)",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00058",
                      "Infraction précédée ou accompagnée de tortures / actes de barbarie, ou suivie de la mort de la victime.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00059",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                              "f00060",
                              "La mort de la victime ne peut pas être retenue à la fois comme constitutive de l’assassinat et ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                              "f00061",
                              "comme circonstance aggravante de la séquestration : ",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00062",
                          "Cass. crim., 20 février 2002",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00063",
                        "Article 224-3 du C.P.",
                      ),
                    ),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00064",
                      "Infraction commise à l’égard de plusieurs personnes.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00065",
                        "Article 224-4 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00066",
                        " (prise d’otage) :",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00067",
                      "Pour préparer ou faciliter la commission d’un crime ou d’un délit.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00068",
                      "Pour favoriser la fuite ou assurer l’impunité de l’auteur/complice d’un crime ou délit.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00069",
                      "Pour obtenir l’exécution d’un ordre ou d’une condition (notamment versement d’une rançon).",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00070",
                      "La circonstance aggravante « prise d’otage » a un caractère réel : elle s’étend aux coauteurs et complices.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00071",
                        "Article 224-5 du C.P.",
                      ),
                    ),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00072",
                      "Victime mineure de 15 ans.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00073",
                        "Article 224-5-2 du C.P.",
                      ),
                    ),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00074",
                      "Enlèvement ou séquestration commis en bande organisée.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00075",
                          "Un 2ᵉ degré d’aggravation est prévu lorsque les infractions des articles 224-2 à 224-5 ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00076",
                          "sont commises en bande organisée.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                  "f00077",
                  "V — Répression, tentative, complicité, exemptions",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00078",
                      "Peines (vue d’ensemble)",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00079",
                        "Forme simple (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00080",
                        "article 224-1 al. 1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00081",
                        ") : 20 ans de réclusion criminelle (période de sûreté).",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00082",
                        "Aggravation 1ᵉʳ degré (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00083",
                        "article 224-2 al. 1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00084",
                        ") : 30 ans de réclusion criminelle (période de sûreté).",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00085",
                        "Aggravation 2ᵉ degré (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00086",
                        "article 224-2 al. 2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00087",
                        ") : réclusion criminelle à perpétuité (période de sûreté).",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00088",
                      "Personnes morales",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00089",
                        "Responsabilité pénale prévue par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00090",
                        "l’article 121-2 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00091",
                          "Tentative : OUI (toujours prévue pour les crimes). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00092",
                          "Attention : la question peut se poser si, par réduction de peine (224-1 al. 3), l’infraction devient un délit.",
                        ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00093",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00094",
                        "Complicité : OUI — punissable selon ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00095",
                        "les articles 121-6 et 121-7 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00096",
                      "Exemption ou réduction de peine : OUI",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00097",
                      "• Libération volontaire",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00098",
                          "Une diminution de peine est prévue lorsque la personne détenue/séquestrée est libérée volontairement ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00099",
                          "avant le 7ᵉ jour accompli depuis son appréhension. Cela peut changer la qualification : le crime devient délit.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00100",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00101",
                          "Le crime peut devenir un délit en cas de libération volontaire avant 7 jours : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00102",
                          "Cass. crim., 8 juin 2006",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00103",
                          "Cette réduction n’est pas mentionnée à l’article 224-5 (victime mineure de 15 ans) : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00104",
                          "elle n’est donc pas applicable dans cette hypothèse.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00105",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00106",
                          "La libération volontaire peut résulter d’une cessation de surveillance permettant à la victime de quitter les lieux : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                          "f00107",
                          "Cass. crim., 11 août 2021",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                      "f00108",
                      "• Dénonciation (224-5-1)",
                    ),
                  ),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00109",
                        "Article 224-5-1 al. 1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00110",
                            " : exemption de peine si l’auteur d’une tentative a averti l’autorité administrative/judiciaire et a permis ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00111",
                            "d’éviter la réalisation de l’infraction.",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                        "f00112",
                        "Article 224-5-1 al. 2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00113",
                            " : réduction de peine des deux tiers si, après avoir averti l’autorité, il a permis de faire cesser l’infraction, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00114",
                            "d’éviter mort/infirmité permanente, ou d’identifier d’autres auteurs/complices. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/enlevement_sequestration_page.dart",
                            "f00115",
                            "Si perpétuité encourue, elle est ramenée à 20 ans.",
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
