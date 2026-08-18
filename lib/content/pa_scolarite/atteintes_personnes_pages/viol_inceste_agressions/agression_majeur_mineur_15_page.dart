import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAgressionMajeurMineur15Page extends StatelessWidget {
  const PaAgressionMajeurMineur15Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/agression_majeur_mineur_15';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    // Palette cohérente avec tes pages
    final Color cIntro = isDark
        ? const Color(0xFF101A2B)
        : const Color(0xFFEAF2FF);
    final Color cIntroAccent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    final Color cLegal = isDark
        ? const Color(0xFF1B1420)
        : const Color(0xFFFFEBEE);
    final Color cLegalAccent = isDark
        ? const Color(0xFFE57373)
        : const Color(0xFFC62828);

    final Color cMat = isDark
        ? const Color(0xFF0F1E19)
        : const Color(0xFFE8F5E9);
    final Color cMatAccent = isDark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    final Color cMoral = isDark
        ? const Color(0xFF1A1A11)
        : const Color(0xFFFFF8E1);
    final Color cMoralAccent = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

    final Color cAggr = isDark
        ? const Color(0xFF1A1411)
        : const Color(0xFFFFF3E0);
    final Color cAggrAccent = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFEF6C00);

    final Color cRepr = isDark
        ? const Color(0xFF121821)
        : const Color(0xFFE8EAF6);
    final Color cReprAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF283593);

    // ✅ Articles en rouge
    TextSpan lawRef(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
    );
    TextSpan normal(String s) => TextSpan(text: s);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
            "f00001",
            "Agression sexuelle (majeur / mineur de 15 ans)",
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : const Color(0xFF0D1B2A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ EXIGENCE : article légal tout en haut
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                  "f00002",
                  "Article de référence (élément légal)",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00003",
                        "Article 222-29-2 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00004",
                        " : définit et réprime l’agression sexuelle commise par un majeur sur un mineur de 15 ans.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00005",
                      "Conditions alternatives",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00006",
                      "Différence d’âge d’au moins 5 ans entre le majeur et le mineur.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00007",
                      "Ou, si l’écart d’âge est inférieur à 5 ans : faits commis en échange d’une rémunération (ou promesse), d’un avantage en nature (ou promesse).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                  "f00008",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00009",
                          "Hors le cas de l’agression imposée par violence, contrainte, menace ou surprise, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00010",
                          "toute atteinte sexuelle autre qu’un viol commise par un majeur sur un mineur de 15 ans, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00011",
                          "lorsque la différence d’âge est d’au moins 5 ans, constitue une agression sexuelle.",
                        ),
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00012",
                          "La condition de différence d’âge n’est pas exigée si les faits sont commis en échange d’une rémunération ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00013",
                          "(ou promesse), d’un avantage en nature (ou promesse).",
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00014",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00015",
                      "Infraction autonome : pas besoin de violence/menace/surprise pour la caractériser.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00016",
                      "Le consentement d’un mineur de 15 ans n’est pas juridiquement recevable face à un majeur.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00017",
                      "Le critère des 5 ans (« Roméo et Juliette ») protège les relations de proximité d’âge, sauf contrepartie.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // I — Élément légal
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                  "f00018",
                  "I — Élément légal",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00019",
                        "Article 222-29-2 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00020",
                        " : prévoit deux voies de caractérisation :",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00021",
                      "Écart d’âge ≥ 5 ans entre l’auteur majeur et la victime mineure de 15 ans.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00022",
                      "Ou écart d’âge < 5 ans si les faits sont commis avec contrepartie (rémunération / promesse / avantage en nature / promesse).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // II — Élément matériel
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                  "f00023",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00024",
                      "1) Un acte de nature sexuelle (autre qu’un viol)",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00025",
                          "L’atteinte sexuelle suppose un contact physique entre l’agresseur et sa victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00026",
                          "Elle correspond à tout acte impudique autre qu’une pénétration ou un acte bucco-génital, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00027",
                          "directement exercé sur une personne.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00028",
                        "Si l’auteur se livre à un acte immoral ou obscène sur lui-même en présence de témoins, il peut s’agir d’",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00029",
                        "exhibition sexuelle (art. 222-32 C.P.)",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00030",
                        " ou d’",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00031",
                        "incitation à la corruption de mineur (art. 227-22 C.P.)",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00032",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                              "f00033",
                              "Exemples fréquents : attouchements/caresses (sexe, fesses, cuisses, poitrine) parfois accompagnés de baisers ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                              "f00034",
                              "(C.A. Paris, 19 juin 1985). ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                              "f00035",
                              "Le fait de caresser le dos de la victime en passant la main sous son pull-over (C.A. Agen, 27 octobre 1997).",
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00036",
                      "2) Un auteur majeur",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00037",
                      "Le texte vise exclusivement un auteur majeur : les actes accomplis entre mineurs sont exclus de ce champ d’incrimination.",
                    ),
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00038",
                      "3) Une victime mineure de moins de 15 ans",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00039",
                      "• Victime vivante",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00040",
                        "Il ne peut y avoir agression sexuelle sur un cadavre. Un comportement envers un cadavre relève notamment de ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00041",
                        "l’article 225-17 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00042",
                        " (atteinte à l’intégrité du cadavre).",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00043",
                      "• Âge : moins de 15 ans au moment des faits",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00044",
                        "C’est l’âge au moment des faits qui compte (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00045",
                        "Cass. crim., 21 mars 1957",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00046",
                        "). L’âge se calcule d’heure à heure (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00047",
                        "Cass. crim., 3 septembre 1985",
                      ),
                    ),
                    normal(")."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00048",
                        "À défaut d’acte probant, la preuve de l’âge peut se faire par tout moyen (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00049",
                        "Cass. crim., 17 juillet 1991",
                      ),
                    ),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00050",
                      "Le texte n’exige pas que la minorité soit apparente ou connue : le mineur de 15 ans bénéficie d’une protection particulière.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00051",
                          "La question du consentement ne se pose pas : un mineur de 15 ans n’est pas juridiquement apte à consentir ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00052",
                          "à un acte sexuel avec un majeur. Il n’est donc pas nécessaire de prouver violence, contrainte, menace ou surprise.",
                        ),
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00053",
                      "4) Différence d’âge ≥ 5 ans… sauf contrepartie",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00054",
                      "• Clause « Roméo et Juliette »",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00055",
                          "Pour éviter d’incriminer une relation entre un jeune majeur et un mineur de 15 ans, l’infraction n’est constituée ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00056",
                          "que si l’écart d’âge est égal ou supérieur à 5 ans.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00057",
                      "• Exception : rémunération / avantage",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00058",
                          "Si l’écart d’âge est inférieur à 5 ans, l’incrimination peut tout de même s’appliquer si les faits sont commis ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00059",
                          "en échange d’une somme d’argent, d’un cadeau, d’un avantage (ou promesse) : cela vise notamment des relations prostitutionnelles.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00060",
                          "Si l’écart d’âge est inférieur à 5 ans et qu’il n’y a aucune contrepartie, les faits peuvent relever de l’",
                        ),
                      ),
                      lawRef(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00061",
                          "article 227-25 du C.P.",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00062",
                          " (atteinte sexuelle par un majeur sur un mineur de 15 ans).",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // III — Élément moral
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                  "f00063",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00064",
                      "1) Conscience de commettre un acte immoral ou obscène",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00065",
                          "Comme pour tout crime ou délit, l’agression sexuelle exige une intention coupable : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00066",
                          "l’auteur a conscience de commettre un acte immoral ou obscène. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                          "f00067",
                          "Le mobile importe peu (vengeance, haine, lubricité, etc.).",
                        ),
                  ),
                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00068",
                      "2) Connaissance de l’âge inférieur à 15 ans",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                            "f00069",
                            "En principe, l’erreur sur l’âge n’atténue pas la responsabilité. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                            "f00070",
                            "Toutefois, l’infraction peut ne pas être retenue s’il est établi que l’auteur ignorait l’âge réel, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                            "f00071",
                            "notamment si la victime avait un comportement et un développement physique d’adulte (",
                          ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00072",
                        "Cass. crim., 4 janvier 1902",
                      ),
                    ),
                    normal("). "),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00073",
                        "Il appartient à l’auteur de justifier qu’il a été trompé sur l’âge (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00074",
                        "Cass. crim., 7 février 1957",
                      ),
                    ),
                    normal(")."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // IV — Circonstances aggravantes
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                  "f00075",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00076",
                      "Aucune circonstance aggravante spécifique prévue par cette fiche.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // V — Répression / tentative / complicité
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                  "f00077",
                  "V — Répression, tentative et complicité",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00078",
                      "Peines encourues (personnes physiques)",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00079",
                        "Qualification : agression sexuelle — délit (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00080",
                        "article 222-29-2 du C.P.",
                      ),
                    ),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00081",
                      "Peine principale : 10 ans d’emprisonnement.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00082",
                      "Amende : 150 000 €.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00083",
                        "Responsabilité pénale des personnes morales : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00084",
                        "article 222-33-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00085",
                        " (amende + peines complémentaires prévues à ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00086",
                        "l’article 131-39 du C.P.",
                      ),
                    ),
                    normal(")."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00087",
                        "Tentative : OUI — prévue par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00088",
                        "l’article 222-31 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00089",
                        ". En pratique, la distinction est délicate : le commencement d’exécution correspond souvent à une agression déjà consommée.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                      "f00090",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00091",
                        "Complicité : OUI — punissable conformément aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00092",
                        "articles 121-6 et 121-7 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/agression_majeur_mineur_15_page.dart",
                        "f00093",
                        ". Elle suppose un fait de complicité prévu par la loi : aide/assistance, provocation ou instructions données.",
                      ),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
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
