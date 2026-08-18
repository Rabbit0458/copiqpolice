import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaEmbuscadePage extends StatelessWidget {
  const PaEmbuscadePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/embuscade';

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
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
            "f00002",
            "Atteintes volontaires à l’intégrité",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
              "f00003",
              "L’embuscade",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00005",
                      "Le fait d’attendre, un certain temps et dans un lieu déterminé, un fonctionnaire de la police nationale, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00006",
                      "un militaire de la gendarmerie, un membre du personnel de l’administration pénitentiaire ou toute autre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00007",
                      "personne dépositaire de l’autorité publique, ainsi qu’un sapeur-pompier civil ou militaire ou un agent ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00008",
                      "d’un exploitant de réseau de transport public de voyageurs, dans le but (caractérisé par un ou plusieurs ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00009",
                      "faits matériels) de commettre à son encontre des violences avec usage ou menace d’une arme, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00010",
                      "constitue une embuscade.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00011",
                      "Constitue également une embuscade le fait d’attendre, dans les mêmes conditions, le conjoint, un ascendant, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00012",
                      "un descendant en ligne directe ou toute autre personne vivant habituellement au domicile de la personne protégée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00013",
                      "dans le but (caractérisé par des faits matériels) de commettre des violences avec usage ou menace d’une arme, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00014",
                      "en raison des fonctions exercées par cette dernière.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
              "f00015",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00016",
                    "Article 222-15-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00017",
                    " : prévoit et réprime le délit d’embuscade.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
              "f00018",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00019",
                  "A) Une infraction préparée",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00020",
                  "1) Mise en place d’un guet-apens",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00021",
                      "Le guet-apens se caractérise par le fait « d’attendre un certain temps et dans un lieu déterminé » la victime. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00022",
                      "L’auteur cherche à provoquer un effet de surprise empêchant la victime de préparer sa défense.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00023",
                  "2) En vue de violences avec usage ou menace d’une arme",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00024",
                      "L’auteur projette de commettre des violences à l’encontre de la victime par l’intermédiaire d’une arme, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00025",
                      "qu’il s’agisse d’une arme par nature ou par destination (arme à feu, couteau, bâton, chien, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00026",
                      "Est également visée la menace d’une arme : l’auteur cherche alors à provoquer un choc émotionnel ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00027",
                      "ou un trouble psychologique.",
                    ),
              ),
              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                          "f00028",
                          "Les violences n’ont pas besoin d’être réalisées : l’embuscade sanctionne la préparation et l’infraction ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                          "f00029",
                          "est constituée indépendamment de toute atteinte à la personne. Si l’auteur passe à l’action, il sera ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                          "f00030",
                          "poursuivi sur la base des textes réprimant les violences, notamment ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00031",
                      "l’article 222-14-3 du Code pénal",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00032",
                  "B) Une victime particulière",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00033",
                  "1) Une victime visée par la loi",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00034",
                      "Le texte vise notamment :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00035",
                      "• les agents de la force publique (police nationale, gendarmerie),\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00036",
                      "• un membre du personnel de l’administration pénitentiaire,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00037",
                      "• toute autre personne dépositaire de l’autorité publique,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00038",
                      "• un sapeur-pompier civil ou militaire,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00039",
                      "• un agent d’un exploitant de réseau de transport public de voyageurs,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00040",
                      "• ainsi que le conjoint, ascendant, descendant en ligne directe, ou toute personne vivant habituellement au domicile ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00041",
                      "de la personne protégée.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00042",
                  "2) Un contexte lié aux fonctions / à la qualité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00043",
                      "L’infraction doit être commise :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00044",
                      "• soit à l’occasion de l’exercice des fonctions ou de la mission,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00045",
                      "• soit en raison de la qualité de la victime (que l’auteur connaissait ou ne pouvait ignorer).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00046",
                      "La victime (ou son conjoint/ascendant/descendant/personne vivant au domicile) doit être visée :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00047",
                      "• soit parce qu’elle est en service / accomplit un acte entrant dans ses attributions,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00048",
                      "• soit parce que sa qualité motive l’acte de l’auteur.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
              "f00049",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00050",
                      "Le délit d’embuscade doit être caractérisé par un ou plusieurs faits matériels traduisant la détermination ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00051",
                      "de l’auteur à commettre des violences.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00052",
                      "La volonté d’agir peut notamment être établie par des actes préparatoires : surveillances, croquis retrouvés lors ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                      "f00053",
                      "d’une interpellation ou d’une perquisition, repérages, etc.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
              "f00054",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00055",
                    "Article 222-15-1 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00056",
                  "L’infraction est aggravée lorsqu’elle est commise en réunion.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
              "f00057",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00058",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00059",
                    "Simple — ",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00060",
                    "5 ans d’emprisonnement et 75 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00061",
                    "article 222-15-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00062",
                    "Aggravée (en réunion) — ",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: textMain,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00063",
                    "7 ans d’emprisonnement et 100 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00064",
                    "article 222-15-1 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00065",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00066",
                    "Responsabilité pénale possible conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00067",
                    "l’article 222-16-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00068",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00069",
                  "Tentative : NON.",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                          "f00070",
                          "La tentative du délit d’embuscade n’est pas punissable : la consommation de l’infraction se situe à un stade ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                          "f00071",
                          "du processus criminel antérieur à la tentative.",
                        ),
                  ),
                ],
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                  "f00072",
                  "Pourquoi ?",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00073",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00074",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_volontaires_integrite/embuscade_page.dart",
                    "f00075",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
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
