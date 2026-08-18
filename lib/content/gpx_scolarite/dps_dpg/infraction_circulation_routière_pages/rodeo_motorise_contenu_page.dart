import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class RodeoMotorisePage extends StatelessWidget {
  const RodeoMotorisePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/infraction_circulation_routière_pages/rodeo_motorise';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
            "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
            "f00002",
            "Infraction circulation routière",
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
              "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
              "f00003",
              "Le rodéo motorisé",
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
              "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00005",
                      "Le rodéo motorisé consiste, au moyen d’un véhicule terrestre à moteur, à adopter une conduite ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00006",
                      "répétant de façon intentionnelle des manœuvres constituant des violations d’obligations ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00007",
                      "particulières de sécurité ou de prudence prévues par le code de la route, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00008",
                      "dans des conditions qui compromettent la sécurité des usagers de la route ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00009",
                      "ou qui troublent la tranquillité publique.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00011",
                    "Article L. 236-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00012",
                    " : définit et réprime le rodéo motorisé.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00014",
                  "A) Conduite d’un véhicule terrestre à moteur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00015",
                  "Tous les véhicules terrestres à moteur sont concernés, qu’ils soient ou non soumis à réception.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00016",
                  "B) Des manœuvres répétées constituant des violations d’obligations de sécurité ou de prudence",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00017",
                      "Les violations doivent résulter d’obligations particulières de sécurité ou de prudence prévues ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00018",
                      "par des dispositions législatives ou réglementaires du code de la route.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00019",
                      "Les faits peuvent être commis dans tous les lieux où le code de la route s’applique : voies ouvertes ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00020",
                      "à la circulation publique, mais aussi certaines voies privées dès lors que l’accès est libre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00021",
                      "(aires de stationnement à usage public, voies privées desservant un lotissement, sortie d’un parking privé à usage public, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00022",
                      "cour d’une gare, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00023",
                      "Une manœuvre dangereuse unique ne suffit pas : les violations doivent être répétées.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00024",
                  "Exemples (illustrations)",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00025",
                  "Ne pas respecter l’arrêt imposé par plusieurs feux rouges fixes successifs.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00026",
                  "Circuler à plusieurs reprises sur la voie opposée au sens de circulation malgré une ligne blanche continue.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00027",
                      "Ces violations, ainsi que leur caractère répété, doivent être relevés et décrits précisément ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00028",
                      "pour caractériser l’infraction.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00029",
                  "C) Un danger pour la sécurité des usagers OU un trouble à la tranquillité publique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00030",
                      "Il n’est pas exigé que le comportement ait causé un risque immédiat de mort ou de blessure grave. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00031",
                      "Il suffit de caractériser la compromission de la sécurité des autres usagers.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle("Exemples"),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00032",
                  "Véhicules arrivant en sens inverse, piétons à proximité immédiate.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00033",
                      "Les usagers concernés peuvent être des tiers (piétons, conducteurs extérieurs) mais aussi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00034",
                      "d’autres conducteurs participant eux-mêmes au rodéo motorisé.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00035",
                      "Le trouble à la tranquillité publique peut résulter de la nature des comportements relevés ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00036",
                      "(nuisances sonores excessives, blocage de la circulation, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                          "f00037",
                          "L’exploitation a posteriori d’images de vidéoprotection peut permettre de caractériser ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                          "f00038",
                          "les éléments constitutifs de l’infraction.",
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
              "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
              "f00039",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00040",
                  "Violation manifestement délibérée et répétée d’obligations de sécurité/prudence",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00041",
                      "L’auteur doit agir intentionnellement : il adopte volontairement une conduite répétant des manœuvres ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00042",
                      "prohibées par le code de la route.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00043",
                  "Conscience de compromettre la sécurité OU de troubler la tranquillité publique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00044",
                      "L’auteur a conscience que ses manœuvres compromettent la sécurité des usagers de la route ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00045",
                      "ou troublent la tranquillité publique.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
              "f00046",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00047",
                    "Article L. 236-1 II du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00048",
                    " (1er degré) :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00049",
                  "Lorsque les faits sont commis en réunion.",
                ),
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00050",
                    "Article L. 236-1 III du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00051",
                    " (2e degré) :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00052",
                  "Usage de stupéfiants établi (analyse sanguine/salivaire) ou refus de se soumettre aux vérifications destinées à l’établir.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00053",
                  "État alcoolique caractérisé (taux légal sang/air expiré) ou refus de se soumettre aux vérifications destinées à l’établir.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00054",
                  "Absence du permis exigé, ou permis annulé / invalidé / suspendu / retenu.",
                ),
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00055",
                    "Article L. 236-1 IV du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00056",
                    " (3e degré) :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00057",
                  "Cumul d’au moins deux des circonstances aggravantes prévues au III.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
              "f00058",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00059",
                  "Peines encourues (personnes physiques)",
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00060",
                    "Rodéo simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00061",
                    "1 an d’emprisonnement et 15 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00062",
                    "article L. 236-1 I du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00063",
                    "Aggravé (réunion) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00064",
                    "2 ans d’emprisonnement et 30 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00065",
                    "article L. 236-1 II du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00066",
                    "Aggravé (une circonstance du III) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00067",
                    "3 ans d’emprisonnement et 45 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00068",
                    "article L. 236-1 III du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00069",
                    "Aggravé (au moins deux circonstances du III) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00070",
                    "5 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00071",
                    "article L. 236-1 IV du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00072",
                  "Mesures sur le véhicule",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00073",
                    "Confiscation obligatoire du véhicule : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00074",
                    "article L. 236-3 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00075",
                    " (si la juridiction ne la prononce pas, elle doit motiver sa décision).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00076",
                    "Immobilisation administrative et mise en fourrière : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00077",
                    "article L. 325-1-2 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00078",
                    " (sans autorisation préalable du procureur, qui doit néanmoins être informé immédiatement par tout moyen).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00079",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                  "f00080",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00081",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00082",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                    "f00083",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00084",
                      "Infraction autonome : le fait d’inciter à participer à un rodéo, de l’organiser ou d’en faire la promotion est réprimé par ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/infraction_circulation_routière_pages/rodeo_motorise_contenu_page.dart",
                      "f00085",
                      "l’article L. 236-2 du Code de la route",
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
