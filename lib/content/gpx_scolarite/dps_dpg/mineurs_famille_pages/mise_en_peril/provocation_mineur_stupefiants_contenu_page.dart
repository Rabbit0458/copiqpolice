import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ProvocationMineurStupefiantsPage extends StatelessWidget {
  const ProvocationMineurStupefiantsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
            "f00002",
            "Mise en péril",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
              "f00003",
              "La provocation d’un mineur à l’usage ou au trafic de stupéfiants",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00005",
                      "Constituent des infractions :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00006",
                      "• le fait de provoquer directement un mineur à faire un usage illicite de stupéfiants ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00007",
                      "• le fait de provoquer directement un mineur à transporter, détenir, offrir ou céder des stupéfiants, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00008",
                      "ou à se rendre complice de tels actes.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (2 fondements)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00010",
                    "Article 227-18 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00011",
                    " : définit et réprime la provocation d’un mineur à l’usage de stupéfiants.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00012",
                    "Article 227-18-1 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                        "f00013",
                        " : définit et réprime la provocation d’un mineur au transport, à la détention, à l’offre, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                        "f00014",
                        "à la cession de stupéfiants, ou à se rendre complice de tels actes.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00015",
                  "Précision",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00016",
                      "Les faits de production, fabrication, importation, exportation et acquisition (mentionnés au Code de la santé publique) ne sont pas cités dans ces textes.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
              "f00017",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00018",
                  "A) Un acte de provocation directe",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00019",
                      "Il s’agit d’agissements directs encourageant ou incitant un mineur à commettre une infraction ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00020",
                      "en matière d’usage ou de trafic de stupéfiants.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00021",
                    "Il faut un lien direct entre la provocation et les faits : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00022",
                    "« relation précise et incontestable »",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00023",
                    "« lien étroit »",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00024",
                      "Concrètement, la provocation directe implique que l’auteur s’adresse à un mineur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00025",
                      "(par exemple : parole, téléphone, SMS, message électronique…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00026",
                      "La force de persuasion doit être de nature à inciter le mineur : une simple suggestion ou un simple conseil ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00027",
                      "peut être insuffisant, surtout en l’absence d’ascendant sur le mineur.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Distinction",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                          "f00028",
                          "La provocation directe s’oppose à l’apologie, la propagande ou la simple publicité. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                          "f00029",
                          "Dans cette hypothèse, les faits peuvent relever de ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00030",
                      "l’article L. 3421-4 du Code de la santé publique",
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
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00031",
                  "B) À commettre (ou à se rendre complice) d’une infraction en matière de stupéfiants",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00032",
                    "Sont visées les infractions d’",
                  ),
                ),
                TextSpan(
                  text: "usage",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " ("),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00033",
                    "article 227-18 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00034",
                    ") et de ",
                  ),
                ),
                TextSpan(
                  text: "trafic",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00035",
                    " : transport, détention, offre, cession illicites (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00036",
                    "article 227-18-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00037",
                  "Ces infractions visent notamment l’utilisation de mineurs dans la revente de rue.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00038",
                  "Complicité (dans l’élément matériel)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                          "f00039",
                          "Le texte vise aussi la provocation à se rendre complice : cela permet de réprimer ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                          "f00040",
                          "les incitations à devenir « guetteur » ou à en recruter (aide/assistance, provocation, instructions).",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                          "f00041",
                          "La provocation d’un mineur est aggravée par rapport au régime général. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                          "f00042",
                          "Elle coexiste avec l’incrimination de ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00043",
                      "l’article L. 3421-4 du Code de la santé publique",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00044",
                      " (provocation à l’usage ou au trafic / présentation sous un jour favorable).",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                        "f00045",
                        "À noter : offrir à un mineur des stupéfiants pour sa consommation personnelle ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                        "f00046",
                        "peut relever d’un texte spécifique plus sévère : ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00047",
                    "article 222-39 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00048",
                    " (10 ans d’emprisonnement et 75 000 € d’amende).",
                  ),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00049",
                  "C) Adressée à un mineur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00050",
                      "La provocation doit viser un mineur quel que soit son âge. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00051",
                      "Lorsqu’elle s’adresse à un mineur de 15 ans, elle constitue une circonstance aggravante.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
              "f00052",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00053",
                      "Il faut démontrer que l’auteur agit en connaissance de cause : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00054",
                      "il a conscience que ses agissements sont de nature à inciter un ou plusieurs mineurs ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00055",
                      "à user de stupéfiants ou à participer à un trafic (ou à s’en rendre complice).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
              "f00056",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00057",
                    "Articles 227-18 alinéa 2 et 227-18-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00058",
                  "Lorsqu’il s’agit d’un mineur de quinze ans.",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00059",
                      "Lorsque les faits sont commis dans des établissements d’enseignement ou d’éducation, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                      "f00060",
                      "ou dans les locaux de l’administration, ainsi que lors des entrées/sorties ou à proximité immédiate.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
              "f00061",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00062",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00063",
                    "Provocation à l’usage (simple) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00064",
                    "5 ans d’emprisonnement et 100 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00065",
                    "article 227-18 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00066",
                    "Provocation au trafic / complicité de trafic (simple) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00067",
                    "7 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00068",
                    "article 227-18-1 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00069",
                  "Formes aggravées",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00070",
                    "Usage (aggravée) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00071",
                    "7 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00072",
                    "article 227-18 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00073",
                    "Trafic / complicité de trafic (aggravée) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00074",
                    "10 ans d’emprisonnement et 300 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00075",
                    "article 227-18-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00076",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00077",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00078",
                    "l’article 227-28-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00079",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                  "f00080",
                  "Tentative : NON (non prévue).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00081",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00082",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00083",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/provocation_mineur_stupefiants_contenu_page.dart",
                    "f00084",
                    " (aide et assistance, provocation, instructions données).",
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
