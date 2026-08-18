import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAdministrationSubstancesNuisiblesPage extends StatelessWidget {
  const PaAdministrationSubstancesNuisiblesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/administration_substances_nuisibles';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

    // ✅ Articles en rouge
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
            "f00001",
            "Administration de substances nuisibles",
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
              // ✅ EXIGENCE : l’article de l’élément légal en tout premier
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
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
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00003",
                        "Article 222-15 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00004",
                        " : définit l’administration de substances nuisibles.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00005",
                        "L’infraction est punie des peines mentionnées aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00006",
                        "articles 222-7 à 222-14-1 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00007",
                        ", suivant les distinctions prévues par ces articles (régime des violences volontaires).",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                  "f00008",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00009",
                          "L’administration de substances nuisibles ayant porté atteinte à l’intégrité physique ou psychique d’autrui ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00010",
                          "constitue une infraction.",
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00011",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00012",
                      "La substance doit être « nuisible » : elle est de nature à provoquer une atteinte physique ou psychique.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00013",
                      "L’infraction exige un résultat : une atteinte à la santé (altération physique et/ou psychique).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00014",
                      "La répression renvoie aux peines des violences volontaires (222-7 à 222-14-1 C.P.).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // I — Élément légal
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                  "f00015",
                  "I — Élément légal",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00016",
                        "Article 222-15 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00017",
                        " : incrimine l’administration de substances nuisibles.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00018",
                        "Peines applicables : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00019",
                        "articles 222-7 à 222-14-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00020",
                        " (violences volontaires), selon les distinctions prévues par ces textes.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // II — Élément matériel
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                  "f00021",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00022",
                      "1) Administration de substances",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00023",
                      "• Nature de la substance",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00024",
                          "La nature exacte importe peu dès lors que la substance est de nature à provoquer une atteinte physique ou psychique. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00025",
                          "Aucune liste exhaustive n’est possible : la nocivité est une question de fait, appréciée par les juges du fond.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00026",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00027",
                          "Le virus du sida a été considéré comme une substance nuisible (",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00028",
                          "Cass. crim., 10 janvier 2006",
                        ),
                      ),
                      normal(")."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00029",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                              "f00030",
                              "Constitue le délit d’administration de substances nuisibles ayant entraîné une infirmité permanente : ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                              "f00031",
                              "l’individu porteur du virus du SIDA, ayant des relations sexuelles non protégées en toute connaissance de cause, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                              "f00032",
                              "contaminant la victime (",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00033",
                          "Cass. crim., 5 octobre 2010",
                        ),
                      ),
                      normal(")."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00034",
                      "• Mode d’administration",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00035",
                          "Le mode d’administration varie selon la substance : ingestion, inhalation, injection, exposition ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00036",
                          "(solide, liquide, gaz ou rayonnement).",
                        ),
                  ),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00037",
                      "Le comportement incriminé est proche de celui de l’empoisonnement et s’interprète de manière comparable.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00038",
                      "Formes possibles",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00039",
                      "Administration directe : l’auteur administre lui-même la substance.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00040",
                      "Mise à disposition : la victime s’administre elle-même le produit.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00041",
                      "Administration indirecte : recours à un tiers (de bonne foi) qui remet la substance à la victime.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00042",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                              "f00043",
                              "Dirigeant d’un club de football ayant dilué du Valium dans des bouteilles d’eau minérale mises à disposition ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                              "f00044",
                              "des adversaires (",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00045",
                          "Cass. crim., 14 juin 1995",
                        ),
                      ),
                      normal(")."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00046",
                      "2) Une atteinte à la personne (résultat dommageable)",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00047",
                          "L’administration doit avoir entraîné un résultat dommageable pour la santé : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00048",
                          "altération des capacités physiques et/ou psychiques de la victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00049",
                          "Il s’agit d’une infraction matérielle : sans résultat, pas d’infraction.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // III — Élément moral
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                  "f00050",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00051",
                      "1) Connaissance du caractère nuisible",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00052",
                      "L’auteur doit avoir conscience du caractère nuisible de la substance administrée.",
                    ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00053",
                      "2) Intention de nuire à la santé physique ou psychique",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00054",
                          "L’élément moral se traduit par une volonté délibérée et réfléchie de porter atteinte à la personne ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00055",
                          "en altérant directement sa santé physique ou psychique.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // IV — Circonstances aggravantes
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                  "f00056",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00057",
                        "Les circonstances aggravantes prévues aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00058",
                        "articles 222-7 à 222-14-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                            "f00059",
                            " (violences volontaires) sont applicables à l’administration de substances nuisibles, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                            "f00060",
                            "selon les distinctions prévues par ces articles.",
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // V — Répression + tentative + complicité
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                  "f00061",
                  "V — Répression, tentative et complicité",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00062",
                      "Peines encourues",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00063",
                        "Répression : peines prévues aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00064",
                        "articles 222-7 à 222-14-1 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00065",
                        " (violences volontaires), selon les distinctions prévues par ces textes.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00066",
                        "Responsabilité des personnes morales : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00067",
                        "article 222-16-1 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00068",
                      "Tentative : NON (absence de disposition expresse en matière correctionnelle).",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00069",
                          "L’infraction nécessite un résultat dommageable pour la santé : sans résultat, l’infraction n’est pas constituée. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00070",
                          "La tentative n’est donc pas concevable.",
                        ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                      "f00071",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00072",
                        "Complicité : OUI — punissable conformément aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                        "f00073",
                        "articles 121-6 et 121-7 du Code pénal",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00074",
                          "La complicité par aide ou assistance peut notamment être retenue contre celui qui procure à l’auteur ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/administration_substances_nuisibles_page.dart",
                          "f00075",
                          "des substances nuisibles.",
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
