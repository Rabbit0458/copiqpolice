import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaSoumissionConditionsTravailHebergementIncompatiblesDignitePage
    extends StatelessWidget {
  const PaSoumissionConditionsTravailHebergementIncompatiblesDignitePage({
    super.key,
  });

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
            "f00002",
            "Atteintes à la dignité",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
              "f00003",
              "La soumission d’une personne vulnérable ou dépendante à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00005",
                      "Le fait de soumettre une personne, dont la vulnérabilité ou l’état de dépendance sont apparents ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00006",
                      "ou connus de l’auteur, à des conditions de travail ou d’hébergement incompatibles avec la dignité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00007",
                      "humaine constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00009",
                    "Article 225-14 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00010",
                    " : définit et réprime la soumission d’une personne vulnérable ou dépendante à des conditions de travail ou d’hébergement incompatibles avec la dignité humaine.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00012",
                  "A) Conditions de travail ou d’hébergement incompatibles avec la dignité humaine",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00013",
                  "Notion d’atteinte à la dignité humaine",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00014",
                      "La dignité humaine est proclamée par de nombreux textes internationaux (Déclaration des Droits de l’Homme, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00015",
                      "Convention européenne de sauvegarde des droits de l’Homme…).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00016",
                      "En 1994, le Conseil constitutionnel affirme que la sauvegarde de la dignité de la personne humaine contre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00017",
                      "toute forme d’asservissement et de dégradation est un principe à valeur constitutionnelle.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00018",
                  "Référence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00019",
                      "Décision du Conseil constitutionnel ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00020",
                      "(27 juillet 1994)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00021",
                      " : principe à valeur constitutionnelle.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00022",
                      "Le Code pénal ne définit pas précisément la dignité humaine : il appartient aux juges du fond d’en fixer ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00023",
                      "les contours.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00024",
                      "Est généralement incompatible avec la dignité humaine ce qui abaisse ou avilit l’être humain en bafouant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00025",
                      "ses droits essentiels. C’est une notion évolutive, dépendante des idées morales communément admises.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00026",
                  "B) Conditions de travail incompatibles avec la dignité humaine",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00027",
                    "À la différence de l’infraction prévue à l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00028",
                    "article 225-13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                        "f00029",
                        ", l’article 225-14 n’exige pas l’absence ou l’insuffisance de rémunération : ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                        "f00030",
                        "le délit peut être constitué dès lors que les conditions de travail sont incompatibles avec la dignité humaine.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00031",
                      "L’atteinte peut résulter :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00032",
                      "• de la nature des locaux (insalubrité, manque d’aération…)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00033",
                      "• de cadences intolérables ou d’une durée excessive de travail\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00034",
                      "• des relations de travail (insultes, brimades, comportements vexatoires), assimilables à des violences morales.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00035",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00036",
                          "Infraction retenue contre un directeur d’atelier interdisant de parler/lever la tête/sourire, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00037",
                          "criant et insultant en public, privant de pauses, imposant des humiliations (toilettes souillées…) ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00038",
                      "(Cass. crim., 04 mars 2003)",
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
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00039",
                      "L’atteinte peut aussi résulter du travail lui-même, lorsqu’il est intrinsèquement incompatible avec la dignité humaine ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00040",
                      "(ex. certaines situations du monde du spectacle).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00041",
                  "Travail forcé",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00042",
                          "Le travail forcé étant incompatible avec la dignité humaine, le délit est constitué si les circonstances factuelles ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00043",
                          "permettent d’établir l’existence d’un travail forcé ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00044",
                      "(Cass. crim., 13 janvier 2009)",
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
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00045",
                    "Définition OIT (Convention du 28 juin 1930) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00046",
                    "« tout travail ou service exigé d’un individu sous la menace d’une peine quelconque et pour lequel ledit individu ne s’est pas offert de plein gré »",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00047",
                  "C) Conditions d’hébergement incompatibles avec la dignité humaine",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00048",
                      "La notion d’hébergement au sens de l’article 225-14 suppose :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00049",
                      "• une contrepartie (loyer ou avantages en nature : travail, mise en valeur des lieux…)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00050",
                      "• une durée : l’hébergement doit viser à fournir un logement pour y vivre.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00051",
                      "L’incompatibilité avec la dignité humaine peut résulter :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00052",
                      "• de l’absence de conditions d’hygiène minimales\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00053",
                      "• de l’absence de chauffage/éclairage\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00054",
                      "• d’une inadéquation du logement au nombre d’occupants (sur-occupation).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00055",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00056",
                          "Délit constitué : location à une famille de 3 personnes (enfant en bas âge + femme enceinte) d’un logement de 20 m², ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00057",
                          "humidité, chauffage mettant en péril la santé ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00058",
                      "(C.A. Paris, 26 juin 1996)",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00059",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00060",
                          "Infraction retenue : hébergement d’une gardienne (60 ans) et de sa fille dans une loge servant aussi de lieu de travail ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00061",
                          "(réception/tri courrier), sans chauffage, installation électrique dangereuse, fenêtre bloquée, traces d’écoulement, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00062",
                          "cuisine délabrée, WC à la turque servant aussi de douche ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00063",
                      "(Cass. crim., 23 avril 2003)",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00064",
                  "D) Une victime vulnérable ou en état de dépendance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00065",
                      "La vulnérabilité ou la dépendance doivent être entendues largement, et doivent être apparentes ou connues de l’auteur.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00066",
                      "• Vulnérabilité : état physique/mental (grossesse, âge, maladie, handicap…), ou environnement économique/social/culturel ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00067",
                      "(personnes immigrées, chômeurs, sans-abri…).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00068",
                      "• Dépendance : économique (précarité) ou morale (ascendant : maître/domestique, parents/enfants…).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00069",
                      "L’une ou l’autre doit exister (elles peuvent se confondre).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00070",
                    "Présomption : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00071",
                    "article 225-15-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00072",
                    " : présomption de vulnérabilité/dépendance concernant les mineurs et certaines victimes à leur arrivée sur le territoire français.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00073",
                          "Les deux délits visés par l’article 225-14 (travail et hébergement) peuvent être caractérisés simultanément, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                          "f00074",
                          "et peuvent aussi se cumuler avec d’autres infractions (ex. exploitation de travailleurs étrangers en situation irrégulière).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
              "f00075",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00076",
                  "A) Conscience de la vulnérabilité / dépendance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00077",
                      "L’auteur doit mesurer la vulnérabilité ou l’état de dépendance de la victime. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00078",
                      "Cet état doit être apparent ou connu.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00079",
                  "B) Conscience de l’incompatibilité avec la dignité humaine",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00080",
                      "L’auteur a pleinement conscience du caractère incompatible avec la dignité humaine des conditions ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                      "f00081",
                      "de travail ou d’hébergement auxquelles il soumet la personne.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
              "f00082",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00083",
                  "Premier degré d’aggravation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00084",
                    "Article 225-15 I 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00085",
                    " : lorsqu’elle est commise à l’égard de plusieurs personnes.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00086",
                    "Article 225-15 II 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00087",
                    " : lorsqu’elle est commise à l’égard d’un mineur.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00088",
                  "Second degré d’aggravation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00089",
                    "Article 225-15 III 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00090",
                    " : lorsqu’elle est commise à l’égard de plusieurs personnes parmi lesquelles figurent un ou plusieurs mineurs.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
              "f00091",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00092",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00093",
                    "Qualification simple (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00094",
                    "7 ans d’emprisonnement et 200 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00095",
                    "article 225-14 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00096",
                    "Aggravée (1er degré) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00097",
                    "10 ans d’emprisonnement et 300 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00098",
                    "articles 225-15 I 2° et 225-15 II 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00099",
                    "Aggravée (2nd degré — crime) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00100",
                    "15 ans de réclusion criminelle et 400 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00101",
                    "article 225-15 III 2° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00102",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00103",
                    "Responsabilité expressément prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00104",
                    "l’article 225-16 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00105",
                    ". Peine d’amende selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00106",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00107",
                    " + peines complémentaires ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00108",
                    "article 131-39 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00109",
                    " (dissolution, interdictions, confiscations…), notamment la confiscation du fonds de commerce ayant servi à commettre l’infraction.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00110",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                  "f00111",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00112",
                    "Complicité : OUI, conformément aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00113",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/dignite_personne/soumission_conditions_travail_hebergement_incompatibles_dignite_page.dart",
                    "f00114",
                    " (aide/assistance, provocation, instructions données).",
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
