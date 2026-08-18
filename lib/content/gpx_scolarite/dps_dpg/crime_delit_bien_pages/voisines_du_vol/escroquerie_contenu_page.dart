import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EscroqueriePage extends StatelessWidget {
  const EscroqueriePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_bien_pages/voisines_du_vol/escroquerie';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
            "f00002",
            "Voisines du vol",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
              "f00003",
              "L’escroquerie",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.12,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00005",
                      "L’escroquerie est le fait, soit par l’usage d’un faux nom ou d’une fausse qualité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00006",
                      "soit par l’abus d’une qualité vraie, soit par l’emploi de manœuvres frauduleuses, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00007",
                      "de tromper une personne physique ou morale et de la déterminer ainsi, à son préjudice ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00008",
                      "ou au préjudice d’un tiers, à remettre des fonds, des valeurs ou un bien quelconque, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00009",
                      "à fournir un service ou à consentir un acte opérant obligation ou décharge.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00011",
                    "Article 313-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00012",
                    " : définit et réprime l’escroquerie.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00014",
                      "L’escroquerie se rapproche du vol en ce qu’elle tend à l’appropriation de la chose d’autrui. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00015",
                      "Mais, alors que le vol suppose une soustraction frauduleuse, l’escroquerie consiste à se faire remettre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00016",
                      "la chose par son propriétaire, en le trompant par des moyens frauduleux.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00017",
                  "A) Un moyen de tromperie (déterminant)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00018",
                      "Le texte ne vise que quatre formes de tromperie. L’usage d’un seul moyen suffit, mais plusieurs procédés ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00019",
                      "sont souvent employés simultanément.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00020",
                      "Le moyen doit être déterminant (provoquer la remise) et résulter d’un comportement actif de l’auteur.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00021",
                  "1) L’usage d’un faux nom",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00022",
                      "Constitue un faux nom l’usage par une personne d’un nom patronymique qui n’est pas le sien, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00023",
                      "qu’il soit réel (nom d’un tiers) ou imaginaire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00024",
                      "Sont assimilés : faux prénom ou faux pseudonyme s’ils entraînent confusion/homonymie.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00025",
                  "2) L’usage d’une fausse qualité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00026",
                      "La loi ne définit pas la notion de « qualité ». ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00027",
                      "Elle peut être comprise strictement (attribut juridique essentiel : âge, titre, profession, situation matrimoniale, nationalité) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00028",
                      "ou plus largement (toute particularité de nature à inspirer confiance, donner du crédit, fonder une prétention à un avantage).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00029",
                  "Exemples de qualités retenues",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00030",
                  "État des personnes : âge, nationalité, situation matrimoniale, lien de parenté, domicile (lorsqu’il procure un avantage).",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00031",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00032",
                      "Fausse qualité de national ou d’époux d’une Française (mariage simulé) ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00033",
                      "(Cass. crim., 26 octobre 1994)",
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

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00034",
                  "Titres : noblesse, universitaires, honorifiques, fonctions électives/religieuses…",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00035",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00036",
                      "Porter indûment l’insigne d’officier de l’ordre du mérite pour se faire livrer des marchandises ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00037",
                      "(C.A. Paris, 4 décembre 1984)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00038",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00039",
                      "Se présenter comme prêtre sans avoir reçu l’ordre ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00040",
                      "(Cass. crim., 2 février 2000)",
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

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00041",
                  "Profession : toute profession (fonction publique, professions réglementées, etc.).",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00042",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00043",
                      "Usage de la fausse qualité de policier pour obtenir une remise de fonds ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00044",
                      "(C.A. Paris, 26 juin 1984)",
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

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00045",
                  "Mandataire : se présenter mensongèrement comme mandataire d’autrui.",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00046",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00047",
                      "Se prétendre mandataire d’un créancier afin de déterminer une remise ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00048",
                      "(Cass. crim., 18 juillet 1968)",
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

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00049",
                  "Chômeur / salarié : fausse qualité retenue lorsque la qualité réelle ouvre droit à un avantage.",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00050",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00051",
                      "Prestations chômage obtenues via fausses déclarations : escroquerie par fausse qualité ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00052",
                      "(Cass. crim., 30 novembre 1981)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00053",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00054",
                      "Se dire faussement salarié constitue une fausse qualité ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00055",
                      "(Cass. crim., 10 avril 1997)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00056",
                  "3) L’abus d’une qualité vraie",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00057",
                      "Ici, l’auteur utilise une qualité qu’il possède réellement pour donner force et crédit à ses mensonges, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00058",
                      "grâce à la confiance inspirée.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00059",
                      "La jurisprudence l’a retenu pour des professions traditionnellement dignes de confiance ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00060",
                      "(notaire, huissier, avocat, médecin, banquier…), mais aussi pour des activités moins « prestigieuses » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00061",
                      "(commerçant, gérant de société, naturopathe…).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00062",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00063",
                      "Conservateur de musée donnant l’apparence d’authenticité à des objets dépourvus de valeur ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00064",
                      "(Cass. crim., 2 avril 1998)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00065",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00066",
                      "Courtier d’assurances insérant une clause non portée à la connaissance de la compagnie et percevant des surprimes ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00067",
                      "(Cass. crim., 8 décembre 1965)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00068",
                  "4) L’emploi de manœuvres frauduleuses",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00069",
                      "Les simples mensonges sont insuffisants s’ils ne sont accompagnés d’aucun fait extérieur ou acte matériel ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00070",
                      "destiné à conforter les allégations. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00071",
                      "Les manœuvres doivent venir corroborer les mensonges et viser à donner force et crédit à ceux-ci pour obtenir la remise.",
                    ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00072",
                  "Jurisprudence (principe)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00073",
                      "Mensonge seul insuffisant ; les menaces/pressions verbales ou le mensonge déterminant ne suffisent pas sans fait extérieur ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00074",
                      "(Cass. crim., 6 novembre 1991 ; Cass. crim., 25 septembre 1997)",
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

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00075",
                  "Jurisprudence (temporalité)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00076",
                      "Les manœuvres frauduleuses doivent être déterminantes de la remise et antérieures à celle-ci ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00077",
                      "(Cass. crim., 8 mars 2023)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00078",
                  "Méthodes fréquemment retenues par la jurisprudence",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00079",
                  "Production d’un document écrit (authentique, falsifié, forgé, émanant d’un tiers réel ou imaginaire).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00080",
                  "Mise en scène (décor, machination, manipulation, trucage) destinée à crédibiliser le mensonge.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00081",
                  "Intervention d’un tiers (réel ou imaginaire) corroborant les dires de l’auteur, de manière orale/écrite, ou par présence passive.",
                ),
              ),

              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00082",
                  "Jurisprudences (exemples)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00083",
                      "Carte grise provisoire authentique remise par un garagiste (véhicule gagé) déterminant un paiement intégral ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00084",
                      "(Cass. crim., 22 mars 1978)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00085",
                      " ; chèques falsifiés ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00086",
                      "(C.A. Paris, 15 septembre 1981)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00087",
                      " ; simulation de vol / liste d’objets volés ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00088",
                      "(C.A. Paris, 23 janvier 1981)",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00089",
                  "B) Une remise",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00090",
                    "La remise doit être un acte positif de la victime. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00091",
                    "L’article 313-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00092",
                    " distingue trois types :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00093",
                  "Remise de fonds, valeurs ou d’un bien quelconque.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00094",
                  "Fourniture d’un service (toute prestation).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00095",
                  "Consentement à un acte opérant obligation ou décharge.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00096",
                  "C) Un préjudice",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00097",
                    "Le préjudice est indispensable : sans préjudice, un élément du délit fait défaut ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00098",
                    "(Cass. crim., 3 avril 1991)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00099",
                      "Le préjudice peut être matériel. Il peut aussi être analysé comme moral (consentement vicié), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00100",
                      "mais ce n’est pas automatique selon les cas.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00101",
                  "D) Une victime",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00102",
                  "La victime peut être une personne physique ou une personne morale.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
              "f00103",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00104",
                      "L’escroquerie est une infraction intentionnelle : l’auteur doit avoir conscience d’utiliser des moyens frauduleux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00105",
                      "dans le but d’obtenir une remise. La simple imprudence ne suffit pas.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00106",
                      "La mauvaise foi se déduit souvent des moyens employés, et les juges apprécient au cas par cas.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00107",
                  "Le mobile est indifférent pour la qualification pénale (il peut seulement influencer la peine).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00108",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00109",
                      "Même si l’auteur affirme des intentions désintéressées (ex. au profit d’une œuvre), cela n’écarte pas l’infraction ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                      "f00110",
                      "(Cass. crim., 18 juillet 1975)",
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

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
              "f00111",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00112",
                    "Article 313-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00113",
                    " : escroquerie aggravée, notamment lorsque :",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00114",
                  "Commise par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00115",
                  "Commis par une personne prenant indûment la qualité d’une personne dépositaire de l’autorité publique/mission de service public.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00116",
                  "Appel au public pour émission de titres ou collecte de fonds à des fins d’entraide humanitaire/sociale.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00117",
                  "Au préjudice d’une personne particulièrement vulnérable (âge, maladie, infirmité, déficience, grossesse).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00118",
                    "État de sujétion au sens de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00119",
                    "l’article 223-15-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00120",
                    " connu de l’auteur.",
                  ),
                ),
              ]),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00121",
                  "Au préjudice d’une personne publique / organisme de protection sociale / organisme chargé d’une mission de service public (pour obtenir une allocation, prestation, paiement ou avantage indu).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00122",
                  "Commise en bande organisée.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
              "f00123",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00124",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00125",
                    "Simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00126",
                    "5 ans d’emprisonnement et 375 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00127",
                    "article 313-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00128",
                    "Aggravée (circonstances des al. 2 à 6) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00129",
                    "7 ans d’emprisonnement et 750 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00130",
                    "article 313-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00131",
                    "Bande organisée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00132",
                    "10 ans d’emprisonnement et 1 000 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00133",
                    "article 313-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00134",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00135",
                    "Peines prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00136",
                    "l’article 313-9 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00137",
                  "Tentative, complicité & immunité familiale",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00138",
                    "Tentative : OUI — prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00139",
                    "l’article 313-3 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00140",
                    " (toujours punissable, simple ou aggravée).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                  "f00141",
                  "Complicité : OUI (punissable pour l’infraction consommée comme tentée, personnes physiques ou morales).",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00142",
                    "Immunité familiale : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00143",
                    "l’article 313-3 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00144",
                    " renvoie à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_bien_pages/voisines_du_vol/escroquerie_contenu_page.dart",
                    "f00145",
                    "l’article 311-12 du Code pénal",
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
