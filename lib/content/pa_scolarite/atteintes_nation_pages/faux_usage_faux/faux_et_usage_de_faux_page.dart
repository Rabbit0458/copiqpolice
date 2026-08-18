import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaFauxEtUsageDeFauxPage extends StatelessWidget {
  const PaFauxEtUsageDeFauxPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux';

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
    final Color cardRep = cardDef;

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
            "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
            "f00002",
            "Faux & usage de faux",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
              "f00003",
              "Le faux et l’usage de faux",
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
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00005",
                      "Le faux consiste en toute altération de la vérité de nature à causer un préjudice, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00006",
                      "accomplie par quelque moyen que ce soit, dans un écrit ou tout autre support d’expression ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00007",
                      "de la pensée, ayant pour objet ou pouvant avoir pour effet d’établir la preuve d’un droit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00008",
                      "ou d’un fait ayant des conséquences juridiques.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00010",
                    "Article 441-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00011",
                    " : définit et réprime l’infraction de faux ainsi que l’usage de faux.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00013",
                      "L’infraction est constituée par une altération préjudiciable de la vérité réalisée dans un document ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00014",
                      "avec la volonté de tromper.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00015",
                  "A) Établissement d’un support matériel du faux",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00016",
                  "• Le support du faux",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00017",
                      "Le support doit être un écrit ou tout autre support d’expression de la pensée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00018",
                      "Il doit avoir pour objet ou pour effet d’établir la preuve d’un droit ou d’un fait ayant des conséquences juridiques : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00019",
                      "cela implique une certaine valeur probatoire.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00020",
                  "✓ Un écrit",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00021",
                    "Le faux est principalement commis dans un écrit. Le texte vise tout écrit non couvert par un faux spécial ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00022",
                    "(articles 441-2 à 441-7 du Code pénal)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00023",
                    ". L’écrit correspond à « tout signe ou ensemble de signes matériels, visibles et permanents, servant à l’expression, la fixation et la transmission de la pensée ».",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00024",
                      "L’écriture peut être manuscrite, dactylographiée, gravée ou peinte. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00025",
                      "La langue et le langage utilisés sont indifférents.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00026",
                  "✓ Autres supports de la pensée",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00027",
                      "La formulation est volontairement très large : elle permet d’étendre l’infraction à de nouveaux supports ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00028",
                      "(ex. CD-ROM, DVD, disque dur, film, microfilm, clés USB, etc.). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00029",
                      "Elle permet aussi de sanctionner la falsification de documents informatiques en dehors de toute atteinte à un STAD.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00030",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00031",
                      "Saisies de remboursements indus + faux actes médicaux + faux décomptes : ces décomptes sont des documents faisant titre entrant dans les prévisions de ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00032",
                      "l’article 441-1 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: " "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00033",
                      "(Cass. crim., 24 janvier 2001)",
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
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00034",
                  "• Valeur probatoire du support",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00035",
                      "Sont visés :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00036",
                      "— les supports créés dès l’origine pour servir de preuve ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00037",
                      "— mais aussi ceux qui peuvent ensuite avoir cet effet (documents dits « de hasard »).",
                    ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00038",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00039",
                      "Falsification d’un constat amiable d’accident ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00040",
                      "(Cass. crim., 1er juin 1981)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00041",
                      "Correspondance privée falsifiée et produite en justice pour établir la preuve d’un fait ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00042",
                      "(Cass. crim., 16 février 1977)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00043",
                      "Falsification d’une lettre d’embauche ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00044",
                      "(Cass. crim., 16 novembre 1995)",
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
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                        "f00045",
                        "Les factures, simples déclarations unilatérales, n’ont pas en elles-mêmes de valeur probatoire. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                        "f00046",
                        "Elles peuvent toutefois en acquérir une lorsqu’elles sont passées en comptabilité : leur falsification tombe alors sous le coup de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00047",
                    "l’article 441-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00048",
                    "(Cass. crim., 05 avril 1993)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00049",
                  "Copie d’un document",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                          "f00050",
                          "La possibilité de réaliser un faux dépend de la valeur probatoire reconnue à la copie. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                          "f00051",
                          "La production en justice sous forme de photocopie d’un document contrefait constitue un faux ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00052",
                      "(Cass. crim., 16 novembre 1995)",
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
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00053",
                  "B) Une falsification",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00054",
                    "Article 441-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00055",
                    " : vise l’altération de la vérité accomplie par quelque moyen que ce soit.",
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00056",
                  "☑ Une falsification matérielle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00057",
                      "Le support (aspect physique) du document est falsifié. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00058",
                      "Deux formes principales :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00059",
                      "— altération d’un document authentique (suppression, modification, adjonction d’écritures) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00060",
                      "— procédés donnant l’apparence de l’authenticité à un document qui ne l’est pas (fabrication du document, imitation de signature…).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00061",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00062",
                      "Ticket d’autobus plastifié : procédé ayant pu empêcher l’impression, faire disparaître ou rendre effaçables des signes normalement indélébiles destinés à faire preuve ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00063",
                      "(Cass. crim., 19 décembre 1974)",
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

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00064",
                  "☑ Une falsification intellectuelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                        "f00065",
                        "Le faux intellectuel est un défaut de véracité : le mensonge atteint le contenu de l’écrit et non le support. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                        "f00066",
                        "Il doit porter sur l’altération des faits que le document avait pour objet de constater et sur une disposition substantielle ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00067",
                    "(Cass. crim., 29 avril 1971)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00068",
                  "C) Un préjudice",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00069",
                      "Le texte exige une altération de la vérité « de nature à causer un préjudice ». ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00070",
                      "Il n’est pas nécessaire que le préjudice se soit effectivement réalisé : il suffit qu’il soit possible.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00071",
                      "Le préjudice peut être :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00072",
                      "— matériel (atteinte aux intérêts patrimoniaux : privation d’un droit, création d’obligations indues…) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00073",
                      "— moral (honneur, considération, réputation…) ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00074",
                      "— social (atteinte à la confiance dans les actes publics/authentiques).",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00075",
                  "D) L’usage du faux",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00076",
                    "L’usage du faux est incriminé par l’alinéa 2 de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00077",
                    "l’article 441-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00078",
                    ". L’usage suppose l’existence préalable d’un faux.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00079",
                    "La jurisprudence retient qu’il suffit que le détenteur utilise la pièce, par un acte quelconque, en vue du résultat final qu’elle était destinée à produire ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00080",
                    "(Cass. crim., 25 janvier 1961 ; 8 octobre 1996)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00081",
                    ", ou par tout acte de nature à causer un préjudice.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00082",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00083",
                      "L’usage de faux nécessite un fait positif d’utilisation et ne peut résulter de la seule abstention (contrats de prêt falsifiés) ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00084",
                      "(Cass. crim., 4 novembre 2010)",
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
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00085",
                      "C’est une infraction instantanée : chaque acte d’usage constitue une nouvelle infraction. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00086",
                      "Le délai de prescription court à compter de chacun des actes d’utilisation (dernier acte en date).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Prescription",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00087",
                      "Le délai de prescription court, pour l’usage de faux, à partir de la date de chacun des actes par lesquels le prévenu se prévaut de la pièce fausse ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00088",
                      "(Cass. crim., 19 janvier 2000)",
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

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
              "f00089",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00090",
                  "A) Concernant l’infraction de faux",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00091",
                  "Volonté de réaliser la falsification.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00092",
                  "Conscience d’altérer la vérité dans des conditions de nature à causer un préjudice.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00093",
                      "Pour le faux matériel, l’acte révèle l’intention du fait même de sa réalisation (fabrication, fausse signature…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00094",
                      "Pour le faux intellectuel, l’intention peut être plus délicate à caractériser (l’auteur peut se croire sincère). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00095",
                      "Les mobiles sont indifférents.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00096",
                  "B) Concernant l’infraction d’usage de faux",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00097",
                  "Volonté d’user de la pièce fausse.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00098",
                  "Connaissance de la fausseté de la pièce.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
              "f00099",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00100",
                  "Aucune circonstance aggravante spécifique n’est prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
              "f00101",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00102",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00103",
                    "Faux et usage de faux : 3 ans d’emprisonnement et 45 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00104",
                    "article 441-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00105",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00106",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00107",
                    "l’article 441-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00108",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00109",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00110",
                    "article 441-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                    "f00111",
                    " (prévoit expressément la tentative des délits prévus à l’article 441-1).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                  "f00112",
                  "Complicité : OUI.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00113",
                      "Secrétaire de mairie faisant procéder par un employé subalterne à la falsification de registres ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00114",
                      "(Cass. crim., 18 octobre 2000)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ". "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00115",
                      "Ouverture de comptes bancaires pour encaisser des chèques en paiement de factures fictives ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_nation_pages/faux_usage_faux/faux_et_usage_de_faux_page.dart",
                      "f00116",
                      "(C.A. Paris, 23 juin 1988)",
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
