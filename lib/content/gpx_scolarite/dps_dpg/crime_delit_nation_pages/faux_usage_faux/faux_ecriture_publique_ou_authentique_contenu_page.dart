import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class FauxEcriturePubliqueOuAuthentiquePage extends StatelessWidget {
  const FauxEcriturePubliqueOuAuthentiquePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
              "f00003",
              "Le faux commis dans une écriture publique ou authentique",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00005",
                      "L’infraction consiste à commettre un faux dans une écriture publique ou authentique, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00006",
                      "ou dans un enregistrement ordonné par l’autorité publique. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00007",
                      "L’usage du faux est également réprimé.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00009",
                    "Article 441-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00010",
                    " : définit et réprime le faux commis dans une écriture publique ou authentique, ainsi que l’usage du faux.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00012",
                  "A) Établissement d’un faux document",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00013",
                    "Les faux visés par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00014",
                    "l’article 441-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00015",
                    " ne portent, à l’exception des enregistrements, que sur des documents écrits.",
                  ),
                ),
              ]),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00016",
                  "B) Écritures publiques : définition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00017",
                      "Les écritures publiques sont des écrits rédigés par un représentant quelconque de l’autorité publique, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00018",
                      "agissant en vertu des fonctions dont il est investi.",
                    ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00019",
                  "C) Écritures authentiques : définition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00020",
                      "Les écritures authentiques sont des écrits établis par un officier public habilité par la loi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00021",
                      "à établir certains actes ou à faire des constatations.",
                    ),
              ),

              const SizedBox(height: 12),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00022",
                  "Repères (catégories classiques)",
                ),
                cardColor: isDark
                    ? const Color(0xFF1E232A)
                    : const Color(0xFFF3F4F6),
                accent: accentGrey,
                titleColor: textMain,
                children: [
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00023",
                      "Actes politiques : écrits des autorités publiques législatives ou gouvernementales (lois, décrets, etc.).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00024",
                      "Actes judiciaires : décisions de justice, sentences arbitrales exécutoires, actes de procédure, procès-verbaux établis par des OPJ/APJ.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00025",
                      "Actes extrajudiciaires : écrits dressés par des officiers publics ou ministériels (notaires, greffiers, huissiers…).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00026",
                      "Actes administratifs : notamment écritures fiscales, écritures comptables d’une autorité publique… (hors documents délivrés pour constater un droit/qualité ou accorder une autorisation).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00027",
                  "D) Enregistrements ordonnés par l’autorité publique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00028",
                      "Il s’agit d’enregistrements sonores, visuels ou audiovisuels, quel qu’en soit le support. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00029",
                      "Exemples : enregistrements issus d’écoutes téléphoniques, enregistrements d’interrogatoires de mineurs, etc.",
                    ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00030",
                  "E) Préjudice : atteinte à la foi publique",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                        "f00031",
                        "En raison de sa nature, l’écrit public ou authentique a une valeur probatoire : sa falsification porte nécessairement atteinte à la foi publique, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                        "f00032",
                        "ce qui caractérise l’existence d’un préjudice éventuel ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00033",
                    "(Cass. crim., 24 mai 2000)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00034",
                  "F) L’usage du faux",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00035",
                    "L’usage du faux est incriminé par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00036",
                    "l’article 441-4 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ". "),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00037",
                      "Les actes de faux et d’usage peuvent être réalisés par des personnes différentes. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00038",
                      "L’infraction d’usage suppose l’existence préalable d’un faux.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00039",
                      "La jurisprudence retient qu’il suffit que le détenteur ait utilisé la pièce fausse par un acte quelconque en vue du résultat final qu’elle était destinée à produire ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00040",
                      "(Cass. crim., 25 janvier 1961 ; Cass. crim., 8 octobre 1996)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00041",
                      ", ou par tout autre acte dès lors qu’il est de nature à causer un préjudice.",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
              "f00042",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00043",
                  "A) Concernant le faux",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00044",
                      "L’auteur doit vouloir réaliser la falsification : l’acte matériel (fabriquer un acte, apposer une fausse signature, etc.) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00045",
                      "révèle l’intention par sa seule réalisation.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00046",
                      "Il doit avoir conscience d’altérer la vérité dans des conditions de nature à causer un préjudice. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00047",
                      "Les mobiles poursuivis sont indifférents.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00048",
                  "B) Concernant l’usage de faux",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00049",
                  "Volonté d’user de la pièce fausse.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00050",
                  "Connaissance de la fausseté de la pièce.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
              "f00051",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00052",
                    "Article 441-4 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                        "f00053",
                        " : lorsque le faux ou l’usage de faux est commis par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                        "f00054",
                        "agissant dans l’exercice de ses fonctions ou de sa mission.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
              "f00055",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00056",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00057",
                    "Faux (simple) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00058",
                    "10 ans d’emprisonnement. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00059",
                    "article 441-4 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00060",
                    "Usage de faux : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00061",
                    "même répression (selon le texte). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00062",
                    "article 441-4 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00063",
                    "Faux/usage aggravé (dépositaire / mission de service public) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00064",
                    "15 ans de réclusion criminelle. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00065",
                    "article 441-4 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00066",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00067",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00068",
                    "l’article 441-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00069",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00070",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00071",
                    "article 441-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00072",
                    " (prévoit expressément la tentative des délits visés, dont ceux de l’article 441-4).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                    "f00073",
                    "Complicité : OUI. ",
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                        "f00074",
                        "La jurisprudence peut considérer comme auteur du faux celui qui donne l’ordre de commettre, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                        "f00075",
                        "au même titre que celui qui l’a personnellement fabriqué. ",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00076",
                      "Jurisprudence : secrétaire de mairie faisant procéder par un employé subalterne à la falsification des registres ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                      "f00077",
                      "(Cass. crim., 18 octobre 2000)",
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
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_nation_pages/faux_usage_faux/faux_ecriture_publique_ou_authentique_contenu_page.dart",
                  "f00078",
                  "Dans les autres cas, les règles générales relatives à la complicité s’appliquent.",
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
