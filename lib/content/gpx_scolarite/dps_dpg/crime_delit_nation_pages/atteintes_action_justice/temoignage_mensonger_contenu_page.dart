import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class TemoignageMensongerContenuPage extends StatelessWidget {
  const TemoignageMensongerContenuPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
            "f00002",
            "Atteintes à l’action de la justice",
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
              "f00003",
              "Le témoignage mensonger",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00005",
                      "L’infraction consiste en un témoignage mensonger fait sous serment devant toute juridiction ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00006",
                      "ou devant un officier de police judiciaire agissant en exécution d’une commission rogatoire.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Élément légal (en haut)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00008",
                    "Article 434-13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00009",
                    " : définit et réprime le témoignage mensonger.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // II — Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
              "f00010",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00011",
                  "A) Un témoignage devant une juridiction ou un O.P.J.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00012",
                      "Le témoignage est le récit fait oralement par une personne de ce qu’elle a vu ou entendu. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00013",
                      "Le faux témoignage n’est punissable que s’il est fait en justice : devant une juridiction quelconque, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00014",
                      "ou devant un O.P.J. lorsqu’il agit en exécution d’une commission rogatoire.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00015",
                      "Le terme « juridiction » est général : pénale, civile, administrative ou financière. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00016",
                      "Sont notamment visées les juridictions de jugement, d’instruction, ainsi que les O.P.J. dans le cadre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00017",
                      "d’une commission rogatoire.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00018",
                      "Ne sont pas punissables les déclarations mensongères faites au cours d’une enquête préliminaire ou de flagrance.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00019",
                  "B) Un témoignage fait sous serment",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00020",
                      "Le faux témoignage suppose une déclaration faite sous la foi du serment : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00021",
                      "le mensonge seul ne suffit pas. Le témoin prête serment « de dire la vérité, toute la vérité ».",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00022",
                  "Attention",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                          "f00023",
                          "L’infraction ne peut pas être retenue notamment contre les mineurs de moins de 16 ans (absence d’exigence du serment), ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                          "f00024",
                          "ou contre certaines personnes dont le statut fait obstacle au serment.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                          "f00025",
                          "La personne entendue par l’O.P.J. sous commission rogatoire en garde à vue n’est pas tenue de prêter serment : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                          "f00026",
                          "elle bénéficie du droit de ne pas contribuer à sa propre incrimination.",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00027",
                  "C) Un témoignage mensonger (altération volontaire de la vérité)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00028",
                      "Toute altération faite sciemment de la vérité est incriminée, quelle qu’en soit la forme, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00029",
                      "dès lors qu’elle a pu influencer la décision du juge. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00030",
                      "Le faux témoignage est une infraction de commission : il requiert un acte positif (un mensonge), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00031",
                      "le refus de comparaître ou de déposer n’est pas assimilé à un faux témoignage.",
                    ),
              ),
              SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00032",
                      "Le mensonge peut consister :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00033",
                      "• en l’affirmation d’un fait inexact ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00034",
                      "• en la négation d’un fait véritable (déclarer ne pas savoir alors qu’on sait) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00035",
                      "• ou encore en une omission (silence sur un point déterminé / réponse partielle) si la présentation incomplète dénature la réalité.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00036",
                      "Exemple : un témoin relate une scène mais omet un élément clé, rendant l’ensemble trompeur.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00037",
                  "D) Un témoignage « déterminant »",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00038",
                      "Le faux témoignage est punissable s’il porte sur des circonstances essentielles du litige : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00039",
                      "des éléments susceptibles d’emporter la conviction du juge. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00040",
                      "La jurisprudence exige que l’altération de la vérité présente un intérêt dans l’affaire.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00041",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00042",
                      "C.A. Paris, 27 février 1996",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00043",
                      " : altération volontaire de la vérité portant sur les circonstances essentielles.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00044",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00045",
                      "Cass. crim., 27 janvier 1960",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00046",
                      " : punissable dès lors que l’altération porte sur une circonstance présentant un intérêt dans l’affaire.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
              "f00047",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00048",
                  "A) Conscience de mentir et de trahir le serment",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00049",
                      "L’infraction est intentionnelle : l’auteur doit avoir la volonté délibérée de tromper. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00050",
                      "Le mensonge ne peut être que volontaire et de mauvaise foi.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00051",
                  "B) Dessein conscient de tromper la justice",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00052",
                      "Le délit ne peut résulter d’une imprudence ou d’une inattention. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00053",
                      "La loi ne punit pas celui qui se trompe, mais celui qui ment sciemment. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00054",
                      "Le mobile importe peu.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
              "f00055",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00056",
                    "Article 434-14 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00057",
                    " : témoignage provoqué par la remise d’un don ou d’une récompense quelconque.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00058",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00059",
                      "La sauvegarde de l’emploi peut constituer une contrepartie : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00060",
                      "C.A. Douai, 22 mai 1996",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00061",
                    "Article 434-14 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00062",
                    " : lorsque la personne contre laquelle ou en faveur de laquelle le faux témoignage est commis est passible d’une peine criminelle.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // V — Répression
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
              "f00063",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00064",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00065",
                    "Infraction simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00066",
                    "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00067",
                    "article 434-13 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00068",
                    "Aggravée (don/récompense) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00069",
                    "7 ans d’emprisonnement et 100 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00070",
                    "article 434-14 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00071",
                    "Aggravée (peine criminelle encourue) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00072",
                    "7 ans d’emprisonnement et 100 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00073",
                    "article 434-14 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00074",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00075",
                    "Responsabilité pénale possible (droit commun) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00076",
                    "article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00077",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00078",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00079",
                    "Complicité : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00080",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00081",
                    ". Elle peut se confondre avec la subornation de témoin (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00082",
                    "article 434-15 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00083",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00084",
                      "Complicité retenue lorsque la personne incite l’auteur principal à répéter de fausses informations : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00085",
                      "C.A. Toulouse, 09 février 2006",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00086",
                  "Rétractation : réduction ou exemption de peine",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00087",
                    "Article 434-13 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                    "f00088",
                    " : le faux témoin est exempt de peine s’il rétracte spontanément son témoignage avant la décision mettant fin à la procédure.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00089",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00090",
                      "Rétractation spontanée deux jours après un faux témoignage sous commission rogatoire : exemption appliquée — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00091",
                      "C.A. Paris, 04 juin 2007",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                  "f00092",
                  "Point clé",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/atteintes_action_justice/temoignage_mensonger_contenu_page.dart",
                      "f00093",
                      "La rétractation doit être spontanée et intervenir avant qu’elle ne soit considérée comme tardive (en pratique : avant la clôture des débats).",
                    ),
                  ),
                ],
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
