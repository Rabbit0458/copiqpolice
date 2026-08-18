import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ViolationProfanationTombeauxSepulturesUrnesMonumentsPage
    extends StatelessWidget {
  const ViolationProfanationTombeauxSepulturesUrnesMonumentsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
              "f00003",
              "Violation et profanation de tombeaux, sépultures, urnes cinéraires ou monuments à la mémoire des morts",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                      "f00005",
                      "La violation ou la profanation, par quelque moyen que ce soit, de tombeaux, de sépultures, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                      "f00006",
                      "d’urnes cinéraires ou de monuments édifiés à la mémoire des morts, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00008",
                    "Article 225-17 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                        "f00009",
                        " : prévoit et réprime la violation ou la profanation de tombeaux, sépultures, urnes cinéraires ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                        "f00010",
                        "ou monuments édifiés à la mémoire des morts.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00012",
                  "A) Les lieux et objets protégés",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00013",
                    "Sont protégés par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00014",
                    "l’article 225-17 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00015",
                  "Les tombeaux : monument élevé sur les restes d’un mort (tous actes portant atteinte sont punissables, sauf s’il n’a pas encore servi de sépulture à un être humain).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00016",
                  "Les sépultures : lieu où le défunt est enterré ; peut viser aussi le drap mortuaire ou le cercueil avant l’inhumation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00017",
                  "Les urnes cinéraires : vase fermé contenant les cendres après crémation, protégées au même titre que les sépultures (columbarium, caveaux d’urnes, monuments où elles sont scellées).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00018",
                  "Les monuments édifiés à la mémoire des morts : monuments collectifs, plaques commémoratives, stèles… même sans sépulture (ex. plaque sur un mur, lieu où un soldat/résistant a été tué).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00019",
                  "B) Un acte de violation ou de profanation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                      "f00020",
                      "L’acte doit être matérialisé par une action physique ou une voie de fait. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                      "f00021",
                      "Il peut s’agir de dégradations, d’atteintes, ou d’agissements portant atteinte au respect dû aux morts.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00022",
                  "Exemples d’actes (illustratifs)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00023",
                  "Briser une pierre tombale, inscrire des tags/dessins, dégrader une sépulture.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00024",
                  "Arracher des fleurs déposées/plantées par les proches du défunt.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00025",
                  "Ouvrir un caveau, retirer un cercueil, déplacer des éléments funéraires.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00026",
                  "Placarder un écrit injurieux/diffamatoire sur un tombeau.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00027",
                  "Briser un objet funéraire (ex. crucifix) déposé sur le corps d’un défunt.",
                ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                          "f00028",
                          "Ne sont pas punissables : l’exhumation réalisée dans les règles prescrites par la loi, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                          "f00029",
                          "ainsi que l’ouverture de sépultures très anciennes dans un intérêt historique.",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
              "f00030",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                      "f00031",
                      "L’auteur agit en toute connaissance de cause : il a pleinement conscience d’accomplir un acte ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                      "f00032",
                      "de nature à porter atteinte au respect dû aux morts. Le mobile est indifférent.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
              "f00033",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00034",
                    "Article 225-17 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00035",
                    " : l’infraction est aggravée lorsque la violation ou la profanation a été accompagnée d’une atteinte à l’intégrité du cadavre.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
              "f00036",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00037",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00038",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00039",
                    "1 an d’emprisonnement et 15 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00040",
                    "article 225-17 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00041",
                    "Qualification aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00042",
                    "2 ans d’emprisonnement et 30 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00043",
                    "article 225-17 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00044",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00045",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00046",
                    "l’article 225-18-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00047",
                    " ; amende selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00048",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00049",
                    " + peines des ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00050",
                    "articles 131-39 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00051",
                    " (dissolution, interdiction d’exercer, etc.).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00052",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                  "f00053",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00054",
                    "Complicité : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00055",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/violation_profanation_tombeaux_sepultures_urnes_monuments_page.dart",
                    "f00056",
                    " (aide/assistance, provocation, instructions).",
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
