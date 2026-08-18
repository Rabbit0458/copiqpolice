import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class StupefiantsProductionFabricationPage extends StatelessWidget {
  const StupefiantsProductionFabricationPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/stupéfiants_pages/production_fabrication';

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
            "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
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
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
              "f00003",
              "La production ou la fabrication\nillicites de stupéfiants",
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
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00005",
                  "Le fait de produire ou fabriquer de manière illicite des stupéfiants constitue une infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
              "f00006",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00007",
                    "Article 222-35 alinéa 1 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00008",
                    " : réprime la production ou la fabrication illicites de stupéfiants.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
              "f00009",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00010",
                  "A) La production ou la fabrication illicites",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00011",
                  "Ces deux notions ont un point commun : elles donnent naissance à une substance classée comme stupéfiant.",
                ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00012",
                  "1) La production",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00013",
                      "La production vise les opérations consistant à recueillir, par exemple, l’opium, la feuille de coca, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00014",
                      "le cannabis ou la résine de cannabis des plantes qui les produisent.",
                    ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00015",
                  "2) La fabrication",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00016",
                      "La fabrication recouvre les opérations autres que la production permettant d’obtenir des stupéfiants. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00017",
                      "Elle comprend notamment la purification, ainsi que la transformation de stupéfiants en d’autres stupéfiants.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00018",
                  "B) Un produit stupéfiant",
                ),
              ),
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00019",
                    "Article 222-41 du Code pénal",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00020",
                        " : « constituent des stupéfiants, des substances ou plantes classées comme stupéfiants ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00021",
                        "en application de ",
                      ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00022",
                    "l’article L.5132-7 du Code de la santé publique",
                  ),
                ),
                const TextSpan(text: " ».\n\n"),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00023",
                    "Article L.5132-7 du Code de la santé publique",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00024",
                        " : une substance est classée comme stupéfiant par décision du directeur général ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00025",
                        "de l’Agence nationale de sécurité du médicament et des produits de santé.\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00026",
                        "Ainsi, bien que d’autres substances puissent avoir des effets toxicomanogènes, seules doivent être retenues ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00027",
                        "celles figurant sur les listes arrêtées par voie réglementaire.\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00028",
                        "La liste exhaustive et évolutive des substances classées comme stupéfiants figure en annexes de ",
                      ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00029",
                    "l’arrêté du 22 février 1990",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00030",
                        " : l’infraction ne s’applique donc qu’à une substance figurant sur cette liste, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                        "f00031",
                        "désignée avec suffisamment de précision.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
              "f00032",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00033",
                      "L’intention coupable est requise : produire ou fabriquer doit être réalisé en connaissance de cause. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00034",
                      "Elle peut être mise en évidence par les actes matériels eux-mêmes, mais aussi par le profit tiré de ces actes.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
              "f00035",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00036",
                    "Article 222-35 alinéa 2 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00037",
                    " : lorsque les faits sont commis en bande organisée.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00038",
                    "Article 222-37-1 alinéa 1 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00039",
                    " : lorsque l’infraction est commise par un majeur agissant avec l’aide ou l’assistance, directe ou indirecte, d’un mineur.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00040",
                  "Le mineur est utilisé pour le transport, la détention, l’offre, la cession, l’acquisition ou la vente de stupéfiants.",
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00041",
                  "L’aide/assistance peut être caractérisée par tout acte de sollicitation, d’incitation ou d’organisation intégrant un mineur dans un réseau (participation volontaire ou contrainte).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + réduction/exemption
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
              "f00042",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00043",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00044",
                    "Qualification simple (crime) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00045",
                    "20 ans de réclusion criminelle et 7 500 000 € d’amende, période de sûreté. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00046",
                    "article 222-35 alinéa 1 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00047",
                    "Aggravée (bande organisée) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00048",
                    "30 ans de réclusion criminelle et 7 500 000 € d’amende, période de sûreté. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00049",
                    "article 222-35 alinéa 2 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00050",
                    "Aggravée (majeur + aide/assistance d’un mineur) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00051",
                    "30 ans de réclusion criminelle et 7 500 000 € d’amende, période de sûreté. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00052",
                    "article 222-37-1 2° du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00053",
                    "Aggravée (cumul des circonstances) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00054",
                    "réclusion criminelle à perpétuité et 7 500 000 € d’amende, période de sûreté. — ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00055",
                    "article 222-37-1 3° du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00056",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00057",
                    "Les personnes morales encourent les peines prévues par ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00058",
                    "l’article 222-42 du Code pénal",
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00059",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00060",
                  "Tentative : OUI (toujours punissable en matière de crime).",
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00061",
                    "Complicité : OUI — conformément aux ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00062",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                    "f00063",
                    " (aide et assistance, provocation, instructions données).",
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                  "f00064",
                  "Exemption & réduction de peine",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00065",
                      "Réduction de peine : prévue par ",
                    ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00066",
                      "l’article 222-43 du Code pénal",
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                          "f00067",
                          " (réduction des deux tiers si avertissement des autorités permettant de faire cesser les agissements ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                          "f00068",
                          "ou d’identifier les autres coupables ; cas particulier de l’article 222-34 : perpétuité ramenée à 20 ans).",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00069",
                      "Exemption de peine : prévue par ",
                    ),
                  ),
                  _law(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                      "f00070",
                      "l’article 222-43-1 du Code pénal",
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                          "f00071",
                          " (exemption si avertissement de l’autorité administrative/judiciaire permettant d’éviter la réalisation ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/stupéfiants_pages/production_fabrication_contenu_page.dart",
                          "f00072",
                          "de l’infraction et d’identifier les auteurs/complices).",
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
