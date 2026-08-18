import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class StupefiantsProvocationMajeurPage extends StatelessWidget {
  const StupefiantsProvocationMajeurPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/stupéfiants_pages/provocation_majeur';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );
  }

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
        ? const Color(0xFF20242A)
        : const Color(0xFFF3F6FA);

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
            "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
            "f00002",
            "Stupéfiants",
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
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
              "f00003",
              "La provocation d’un majeur\nà l’usage ou au trafic de stupéfiants",
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
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00005",
                      "Constitue une infraction :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00006",
                      "➤ La provocation au délit d’usage ou aux infractions de trafic de stupéfiants, même si elle n’est pas suivie d’effet, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00007",
                      "ou le fait de présenter ces infractions sous un jour favorable.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00008",
                      "➤ La provocation, même non suivie d’effet, à l’usage de substances présentées comme ayant les effets de stupéfiants.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00010",
                    "Article L.3421-4 alinéas 1 et 2 du Code de la santé publique",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00011",
                    " : définit et réprime la provocation à l’usage ou au trafic de stupéfiants.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00013",
                  "A) Un acte de provocation ou de publicité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00014",
                      "La loi vise un acte de provocation (qu’elle soit ou non suivie d’effet) ou un acte de publicité présentant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00015",
                      "l’usage/le trafic sous un jour favorable.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00016",
                  "1) La provocation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00017",
                      "Il peut s’agir :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00018",
                      "✓ d’agissements directs ou indirects encourageant/incitant la commission d’infractions d’usage ou de trafic ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00019",
                      "(ex. supports ou objets faisant l’éloge du cannabis, slogans, visuels, etc.).\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00020",
                      "✓ d’agissements consistant à proposer de vendre comme « stupéfiants » des substances/produits non toxiques ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00021",
                      "(ex. buvard décoré vendu comme LSD, cigarettes vendues comme haschich, etc.).",
                    ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00022",
                  "2) La présentation sous un jour favorable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00023",
                      "Il s’agit de valoriser la commission d’infractions en matière d’usage ou de trafic de stupéfiants ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00024",
                      "(ex. apologie lors d’une manifestation, affiche présentant la consommation comme conviviale ou thérapeutique).",
                    ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00025",
                  "3) La provocation à l’usage de substances « présentées comme » stupéfiantes",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00026",
                      "La provocation peut être retenue même si elle n’est pas suivie d’effet, dès lors que la substance est présentée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00027",
                      "comme ayant les effets de substances ou plantes classées comme stupéfiants.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00028",
                  "B) Infractions visées",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00029",
                    "Sont visées :\n• Le délit d’usage prévu par ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00030",
                    "l’article L.3421-1 du Code de la santé publique",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00031",
                    "\n• Les infractions de trafic prévues par ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00032",
                    "les articles 222-34 à 222-39 du Code pénal",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                        "f00033",
                        " (direction/organisation de groupement, production/fabrication, import/export, transport, détention, offre, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                        "f00034",
                        "cession, acquisition, emploi illicite de stupéfiants, etc.).",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
              "f00035",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00036",
                  "A) Pour l’alinéa 1",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00037",
                      "L’auteur doit agir en connaissance de cause :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00038",
                      "• soit en provoquant l’usage/le trafic,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00039",
                      "• soit en présentant ces infractions sous un jour favorable.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00040",
                      "Même si le texte manque de précision, la volonté d’agir « en connaissance de cause » doit en principe être démontrée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00041",
                      "Selon les circonstances, certains comportements proches de la négligence peuvent toutefois être sanctionnés.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00042",
                  "B) Pour l’alinéa 2",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00043",
                      "L’intention coupable est évidente : elle découle de la matérialité des faits dès lors que l’auteur provoque ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00044",
                      "en connaissance de cause l’usage de substances présentées comme ayant les effets de stupéfiants.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
              "f00045",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00046",
                    "Article L.3421-4 alinéa 3 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00047",
                      "Lorsque la provocation est directe et commise dans les établissements d’enseignement/éducation, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00048",
                      "dans les locaux de l’administration, lors des entrées/sorties des élèves ou du public, ou dans un temps très voisin ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00049",
                      "et aux abords de ces établissements/locaux.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00050",
                    "Article L.3421-4 alinéa 4 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00051",
                      "Lorsque l’infraction est commise par voie de presse écrite ou audiovisuelle : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00052",
                      "les lois particulières régissant la presse s’appliquent pour déterminer les personnes responsables.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
              "f00053",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00054",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00055",
                    "Qualification simple (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00056",
                    "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00057",
                    "article L.3421-4 alinéa 1 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00058",
                    "Qualification simple (délit) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00059",
                    "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00060",
                    "article L.3421-4 alinéa 2 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00061",
                    "Aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00062",
                    "7 ans d’emprisonnement et 100 000 € d’amende. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00063",
                    "article L.3421-4 alinéa 3 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                          "f00064",
                          "Lorsque l’infraction est commise par voie de presse, les dispositions particulières régissant la presse ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                          "f00065",
                          "s’appliquent pour la détermination des personnes responsables (",
                        ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                      "f00066",
                      "article L.3421-4 alinéa 4 du Code de la santé publique",
                    ),
                  ),
                  const TextSpan(text: ")."),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00067",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                  "f00068",
                  "Tentative : NON (non prévue).",
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00069",
                    "Complicité : OUI — conformément aux ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00070",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/provocation_majeur_contenu_page.dart",
                    "f00071",
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
