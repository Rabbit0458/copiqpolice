import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DenonciationCalomnieusePage extends StatelessWidget {
  const DenonciationCalomnieusePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
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
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
            "f00002",
            "Atteintes à la personnalité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
              "f00003",
              "La dénonciation calomnieuse",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00005",
                      "La dénonciation, effectuée par tout moyen et dirigée contre une personne déterminée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00006",
                      "d’un fait de nature à entraîner des sanctions judiciaires, administratives ou disciplinaires, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00007",
                      "et que l’on sait totalement ou partiellement inexact, lorsqu’elle est adressée à une autorité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00008",
                      "ou à des supérieurs/à l’employeur pouvant y donner suite, constitue une infraction.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00009",
                      "La fausseté du fait dénoncé résulte nécessairement d’une décision devenue définitive ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00010",
                      "(acquittement, relaxe ou non-lieu) déclarant que le fait n’a pas été commis ou qu’il n’est pas imputable ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00011",
                      "à la personne dénoncée.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00012",
                      "Dans les autres cas, le tribunal saisi des poursuites contre le dénonciateur apprécie la pertinence ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00013",
                      "des accusations portées.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
              "f00014",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00015",
                    "Article 226-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00016",
                    " : définit et réprime la dénonciation calomnieuse.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
              "f00017",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00018",
                  "A) Une dénonciation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00019",
                    "Article 226-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00020",
                    " : la dénonciation peut être faite « par tout moyen ». ",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00021",
                  "Elle peut donc être écrite ou orale.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00022",
                  "1) Forme de la dénonciation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00023",
                      "• Écrite : lettre (signée ou anonyme), pétition, plainte (avec ou sans constitution de partie civile), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00024",
                      "plainte déposée auprès de la police ou de la gendarmerie.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00025",
                      "• Orale : de vive voix ou par téléphone (elle doit pouvoir être prouvée).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00026",
                  "2) Auteur de la dénonciation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00027",
                      "L’auteur est celui qui dénonce ou fait dénoncer par une tierce personne. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00028",
                      "L’auteur moral est assimilé à l’auteur juridique.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00029",
                      "Si la dénonciation est faite sur instructions hiérarchiques, l’exécutant ne peut être poursuivi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00030",
                      "que s’il y a pris part personnellement (et pas s’il n’a eu qu’un rôle strictement matériel).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00031",
                  "En cas de dénonciation anonyme, l’auteur doit pouvoir être identifié.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00032",
                  "3) Victime : une personne déterminée",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00033",
                    "Article 226-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00034",
                    " : la dénonciation doit viser une personne déterminée (physique ou morale), identifiable.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00035",
                      "L’identification est simple si la personne est nommée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00036",
                      "À défaut, elle peut résulter de détails rendant inévitable la désignation d’une personne précise.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00037",
                  "4) Destinataire : autorité compétente",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00038",
                      "Il suffit que la dénonciation soit adressée à l’autorité (pas besoin de remise en main propre). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00039",
                      "La jurisprudence retient que l’infraction est consommée le jour de la réception ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00040",
                      "(début du délai de prescription).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00041",
                      "Le destinataire doit être une autorité investie d’un pouvoir de sanction, ou capable de saisir l’autorité compétente : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00042",
                      "magistrats, officiers/autorités administratives ou judiciaires (maires/adjoints, policiers, gendarmes, préfets, etc.), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00043",
                      "mais aussi supérieurs hiérarchiques, employeurs, ou personnes pouvant saisir l’autorité (médecin, assistante sociale, etc.).",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00044",
                  "B) Une dénonciation spontanée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00045",
                      "La jurisprudence exige un caractère spontané : est coupable celui qui prend l’initiative de révéler des faits inexacts. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00046",
                      "Il n’y a pas dénonciation calomnieuse si l’on répond à une interpellation de l’autorité ou des supérieurs.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                          "f00047",
                          "Les dénonciations provoquées perdent leur caractère spontané : rapports demandés par un supérieur, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                          "f00048",
                          "dénonciation d’un subordonné tenu d’informer, réponses aux questions d’un magistrat instructeur, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                          "f00049",
                          "ou dénonciation rattachée étroitement à la défense.",
                        ),
                  ),
                  TextSpan(text: " "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00050",
                      "(Cass. crim., 16 juin 1988 ; Cass. crim., 03 mai 2000)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00051",
                  "C) Une dénonciation préjudiciable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00052",
                      "Le fait dénoncé doit être de nature à entraîner des sanctions judiciaires, administratives ou disciplinaires. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00053",
                      "Peu importe qu’une sanction ait effectivement été prononcée : il suffit que le fait soit de nature à en entraîner.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00054",
                      "Différence avec la diffamation : la dénonciation calomnieuse porte atteinte à l’honneur, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00055",
                      "mais elle vise en plus à exposer la personne à une sanction par une autorité.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00056",
                  "D) L’inexactitude des faits dénoncés",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00057",
                    "Depuis la modification issue de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00058",
                    "l’article 16 de la loi n° 2010-769 du 9 juillet 2010",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                        "f00059",
                        ", la fausseté résulte nécessairement d’une décision définitive d’acquittement, relaxe ou non-lieu ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                        "f00060",
                        "déclarant expressément que le fait n’a pas été commis ou n’est pas imputable à la personne dénoncée.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00061",
                      "Dans les autres hypothèses (par ex. relaxe/non-lieu pour insuffisance de charges), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00062",
                      "le tribunal appréciera la pertinence des accusations.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
              "f00063",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00064",
                  "Conscience de dénoncer des faits inexacts",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00065",
                      "L’auteur doit connaître l’inexactitude des faits au moment où il les dénonce. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00066",
                      "Il exprime ainsi une volonté de nuire à la personne visée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                          "f00067",
                          "Si l’auteur découvre son erreur après coup, l’infraction n’est pas constituée. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                          "f00068",
                          "En revanche, il peut être poursuivi pour omission de témoigner en faveur d’un innocent — ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                      "f00069",
                      "article 434-11 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
              "f00070",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00071",
                  "Aucune circonstance aggravante prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
              "f00072",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00073",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00074",
                    "Délit : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00075",
                    "5 ans d’emprisonnement et 45 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00076",
                    "article 226-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00077",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00078",
                    "Responsabilité prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00079",
                    "l’article 226-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                        "f00080",
                        " : amende (selon les modalités de l’article 131-38), affichage/diffusion de la décision (article 131-35), ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                        "f00081",
                        "et interdiction définitive ou temporaire d’exercer une activité professionnelle.",
                      ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00082",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                  "f00083",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00084",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00085",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00086",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/denonciation_calomnieuse_contenu_page.dart",
                    "f00087",
                    " (aide et assistance, provocation ou instructions données).",
                  ),
                ),
              ]),
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
