import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaOutrageSexistePage extends StatelessWidget {
  const PaOutrageSexistePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/outrage_sexiste';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

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
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
            "f00002",
            "Atteintes volontaires à l'intégrité",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00003",
              "L'outrage sexiste et sexuel",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00005",
                      "L'outrage sexiste et sexuel est constitué par tout propos ou comportement à connotation sexuelle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00006",
                      "ou sexiste portant atteinte à la dignité d'une personne en raison de leur caractère dégradant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00007",
                      "ou humiliant, ou créant à son encontre une situation intimidante, hostile ou offensante.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00008",
                          "L'outrage sexiste a été créé par la loi n° 2018-703 du 3 août 2018 renforçant la lutte ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00009",
                          "contre les violences sexuelles et sexistes, dite « loi Schiappa ».",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément légal
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00010",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                    "f00011",
                    "Article 621-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                        "f00012",
                        " : prévoit et réprime l'outrage sexiste et sexuel. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                        "f00013",
                        "Il s'agit d'une contravention, non d'un délit.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00014",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00015",
                  "A) Des propos ou des comportements",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00016",
                      "L'outrage peut résulter :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00017",
                      "• de propos (verbaux, écrits, images, gestes à caractère sonore),\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00018",
                      "• de comportements (attitudes, gestes physiques).",
                    ),
              ),
              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00019",
                  "B) À connotation sexuelle ou sexiste",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00020",
                      "Les propos ou comportements doivent avoir une connotation :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00021",
                      "• sexuelle (relatifs au sexe, à la sexualité),\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00022",
                      "• ou sexiste (fondés sur le genre, discriminatoires à l'égard du sexe de la victime).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00023",
                          "Un commentaire sur le physique d'une femme dans la rue, des sifflements ou des propositions ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00024",
                          "à caractère sexuel non sollicités peuvent constituer des actes d'outrage sexiste.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00025",
                  "C) Portant atteinte à la dignité de la personne",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00026",
                  "L'atteinte à la dignité est caractérisée par l'une ou l'autre des deux conditions alternatives :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00027",
                      "Caractère dégradant ou humiliant : les propos/comportements abaissent, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00028",
                      "méprisent ou rabaissent la victime.",
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00029",
                      "Situation intimidante, hostile ou offensante : les propos/comportements ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00030",
                      "créent un environnement agressif, menaçant ou blessant pour la victime.",
                    ),
              ),
              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00031",
                  "D) Dirigés contre une personne déterminée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00032",
                      "L'outrage doit être adressé à une ou plusieurs personnes identifiées. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00033",
                      "Il ne peut s'agir de propos généraux sans destinataire précis.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00034",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00035",
                      "L'auteur doit agir délibérément, en ayant conscience du caractère sexiste ou sexuel de ses propos ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00036",
                      "ou comportements et de l'atteinte portée à la dignité de la victime.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00037",
                          "L'outrage sexiste est une infraction intentionnelle : une erreur sur la portée des propos ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00038",
                          "ou une simple maladresse peut être invoquée pour écarter l'élément moral.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00039",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00040",
                  "La forme aggravée est constituée lorsque l'outrage sexiste est commis dans l'une des circonstances suivantes :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00041",
                  "Par plusieurs personnes agissant en qualité d'auteur ou de complice.",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00042",
                      "Dans un véhicule affecté au transport collectif de voyageurs ou dans un lieu ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00043",
                      "destiné à l'accès à un moyen de transport collectif.",
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00044",
                  "Par une personne en état d'ivresse manifeste ou sous l'emprise de produits stupéfiants.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00045",
                  "Sur une personne mineure.",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00046",
                      "Sur une personne dont la particulière vulnérabilité due à son âge, à une maladie, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00047",
                      "à une infirmité, à une déficience physique ou psychique ou à un état de grossesse est apparente ou connue de l'auteur.",
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00048",
                  "Par une personne qui abuse de l'autorité que lui confèrent ses fonctions.",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00049",
                      "Sur une personne dont l'appartenance ou la non-appartenance, vraie ou supposée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00050",
                      "à une nation, une ethnie, une race ou une religion est l'un des motifs de l'outrage.",
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00051",
                      "Sur une personne dont l'orientation sexuelle ou l'identité de genre, vraie ou supposée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00052",
                      "est l'un des motifs de l'outrage.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00053",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00054",
                  "Forme simple — Contravention de 4e classe",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                    "f00055",
                    "750 € d'amende",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                    "f00056",
                    " (3 000 € pour les personnes morales).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00057",
                          "La récidive est punie de la même amende portée au double, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00058",
                          "soit 1 500 € (6 000 € pour les personnes morales).",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00059",
                  "Forme aggravée — Contravention de 5e classe",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                    "f00060",
                    "1 500 € d'amende",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                    "f00061",
                    " (7 500 € pour les personnes morales).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00062",
                          "La récidive de la forme aggravée est punie de 3 000 € d'amende ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00063",
                          "(15 000 € pour les personnes morales).",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00064",
                  "Peines complémentaires",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00065",
                  "Stage de citoyenneté (à titre de peine principale ou complémentaire).",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00066",
                      "Stage de responsabilisation pour la prévention et la lutte contre les ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00067",
                      "violences au sein du couple et sexistes.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00068",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00069",
                  "Tentative : NON (contravention).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                    "f00070",
                    "Complicité : OUI, conformément aux principes généraux du droit contraventionnel.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Distinction avec harcèlement sexuel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
              "f00071",
              "VI — Distinction avec le harcèlement sexuel",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                  "f00072",
                  "L'outrage sexiste se distingue du harcèlement sexuel :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00073",
                      "Harcèlement sexuel (art. 222-33 Cp) : délit — implique des propos ou comportements ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00074",
                      "répétés (ou acte unique grave), et vise à obtenir des faveurs à caractère sexuel ou ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00075",
                      "à créer une situation humiliante durable.",
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00076",
                      "Outrage sexiste (art. 621-1 Cp) : contravention — peut résulter d'un acte unique, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                      "f00077",
                      "sans nécessité de répétition ni de but de sollicitation sexuelle.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00078",
                          "Un même comportement peut, selon sa gravité et sa répétition, être qualifié ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/outrage_sexiste_page.dart",
                          "f00079",
                          "d'outrage sexiste (contravention) ou de harcèlement sexuel (délit).",
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
///                         WIDGETS PERSONNALISÉS                          ///
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (spans == null) {
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
          children: bodySpans,
        ),
      ),
    );
  }
}
