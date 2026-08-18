import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class BiensCulturelsPublicsClassesPage extends StatelessWidget {
  const BiensCulturelsPublicsClassesPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
            "f00002",
            "Destructions, dégradations",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
              "f00003",
              "Destructions, dégradations et détériorations sur biens culturels publics ou classés",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00005",
                      "Constitue une infraction la destruction, la dégradation ou la détérioration lorsqu’elle porte sur certains biens culturels ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00006",
                      "publics, classés, inscrits ou affectés au culte (protection renforcée du patrimoine national).",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00007",
                  "Immeuble / objet mobilier classé ou inscrit (code du patrimoine) ou archives privées classées.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00008",
                  "Patrimoine archéologique (au sens du code du patrimoine).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00009",
                  "Biens culturels du domaine public mobilier ou exposés / conservés / déposés (musées de France, bibliothèques, médiathèques, services d’archives, lieux dépendant d’une personne publique/mission d’intérêt général, édifices affectés au culte).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00010",
                  "Édifice affecté au culte.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
              "f00011",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00012",
                    "Article 322-3-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00013",
                    " : définit et réprime les destructions, dégradations ou détériorations portant sur des biens culturels publics ou classés.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
              "f00014",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00015",
                  "A) Une atteinte matérielle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00016",
                      "Le législateur ne précise pas les moyens : n’importe quel moyen peut être employé ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00017",
                      "(à l’exception de l’incendie et de l’usage de substances explosives, qui relèvent d’autres incriminations).",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00018",
                  "B) Sur un bien culturel public ou classé",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00019",
                      "Les biens faisant partie du patrimoine national font l’objet d’une protection particulière afin d’éviter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00020",
                      "la disparition d’objets liés à l’histoire et à l’identité du pays.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00021",
                      "La protection renforcée s’applique notamment aux biens suivants :",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00022",
                  "Immeuble ou objet mobilier classé ou inscrit (code du patrimoine) ou document d’archives privées classé.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00023",
                    "Patrimoine archéologique au sens de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00024",
                    "l’article L. 510-1 du code du patrimoine",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00025",
                  "Bien culturel du domaine public mobilier ou exposé / conservé / déposé (même temporairement) dans un musée de France, une bibliothèque, une médiathèque, un service d’archives, ou dans un lieu dépendant d’une personne publique/mission d’intérêt général, ou dans un édifice affecté au culte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00026",
                  "Édifice affecté au culte.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00027",
                  "C) Entraînant un dommage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00028",
                      "Les résultats visés sont identiques à ceux des destructions volontaires : destruction, dégradation, détérioration.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00029",
                      "Le dommage peut être léger ou important : il suffit que le bien endommagé fasse partie de ceux protégés ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00030",
                      "par l’article 322-3-1 du Code pénal.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
              "f00031",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00032",
                      "L’auteur doit avoir la volonté d’occasionner un dommage sur le bien, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00033",
                      "en sachant qu’il présente un intérêt pour la collectivité.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                      "f00034",
                      "L’infraction est constituée même si l’auteur est propriétaire du bien détruit, dégradé ou détérioré.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
              "f00035",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00036",
                    "Article 322-3, 1° du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00037",
                    " : circonstance aggravante lorsque l’infraction est commise ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00038",
                    "par plusieurs personnes agissant en qualité d’auteur ou de complice.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
              "f00039",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00040",
                  "Peines encourues — personnes physiques",
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00041",
                    "Qualification simple (délit) — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00042",
                    "article 322-3-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00043",
                  "7 ans d’emprisonnement et 100 000 € d’amende (ou 1/2 de la valeur du bien).",
                ),
              ),

              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00044",
                    "Qualification aggravée — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00045",
                    "article 322-3-1 alinéa 6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00046",
                    " (avec la circonstance du 1° de l’article 322-3) :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00047",
                  "10 ans d’emprisonnement et 150 000 € d’amende (ou 1/2 de la valeur du bien).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00048",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00049",
                    "Les personnes morales encourent les peines prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00050",
                    "l’article 322-17 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00051",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00052",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00053",
                    "article 322-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                    "f00054",
                    " (tentative punissable pour ces délits).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/destructions_degradations/biens_culturels_publics_classes_contenu_page.dart",
                  "f00055",
                  "Complicité : OUI (punissable pour l’infraction consommée comme pour l’infraction tentée, pour personnes physiques ou morales).",
                ),
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
