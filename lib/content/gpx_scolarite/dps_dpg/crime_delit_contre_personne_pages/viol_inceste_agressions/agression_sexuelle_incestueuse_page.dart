import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AgressionSexuelleIncestueusePage extends StatelessWidget {
  const AgressionSexuelleIncestueusePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D1B2A);

    // Palette cohérente
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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
            "f00001",
            "Agression sexuelle incestueuse",
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
              // ✅ EXIGENCE : article légal en premier (et la référence 222-22-3 juste après)
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
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
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00003",
                        "Article 222-29-3 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00004",
                        " : définit et réprime l’agression sexuelle incestueuse.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00005",
                        "Article 222-22-3 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00006",
                        " : détermine la liste des personnes pouvant être auteurs d’agressions sexuelles incestueuses (lien de parenté + autorité).",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                  "f00007",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00008",
                          "Hors le cas prévu pour l’agression imposée à un mineur de 15 ans par violence, contrainte, menace ou surprise, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00009",
                          "toute atteinte sexuelle autre qu’un viol commise par un majeur sur la personne d’un mineur, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00010",
                          "lorsque le majeur est un ascendant ou une personne mentionnée par la loi et qu’il exerce sur le mineur ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00011",
                          "une autorité de droit ou de fait, constitue une agression sexuelle incestueuse.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00012",
                        "Exception rappelée : hors le cas visé par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00013",
                        "l’article 222-29-1 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00014",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00015",
                      "Acte sexuel sans pénétration ni acte bucco-génital (sinon on bascule vers le viol).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00016",
                      "Auteur majeur + victime mineure + lien de parenté listé par la loi + autorité de droit ou de fait.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00017",
                      "Le consentement du mineur ne se discute pas : pas besoin de violence/menace/surprise si les conditions incestueuses sont réunies.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // I — Élément légal
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
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
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00019",
                        "Article 222-29-3 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00020",
                        " : incrimine l’agression sexuelle incestueuse.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00021",
                        "La liste des auteurs possibles est fixée par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00022",
                        "l’article 222-22-3 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // II — Élément matériel
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                  "f00023",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00024",
                      "1) Un acte de nature sexuelle (autre qu’un viol)",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00025",
                          "L’atteinte sexuelle suppose un contact physique entre l’agresseur et la victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00026",
                          "Elle se définit comme tout acte impudique autre qu’une pénétration ou un acte bucco-génital, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00027",
                          "directement exercé sur une personne.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00028",
                        "Si l’auteur se livre à un acte immoral ou obscène sur lui-même en présence de témoins, il peut s’agir d’",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00029",
                        "exhibition sexuelle (art. 222-32 C.P.)",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00030",
                        " ou d’",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00031",
                        "incitation à la corruption de mineur (art. 227-22 C.P.)",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00032",
                          "L’atteinte sexuelle peut être commise par l’auteur sur la victime, ou correspondre à un acte effectué par la victime ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00033",
                          "sur l’auteur (victime contrainte).",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00034",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                              "f00035",
                              "Exemples fréquents : attouchements/caresses (sexe, fesses, cuisses, poitrine), éventuellement accompagnés de baisers ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                              "f00036",
                              "(C.A. Paris, 19 juin 1985). ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                              "f00037",
                              "Caresser le dos de la victime en passant la main sous son pull-over (C.A. Agen, 27 octobre 1997).",
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00038",
                      "2) Un auteur majeur",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00039",
                      "Le texte vise exclusivement un auteur majeur : les actes accomplis entre mineurs sont exclus de ce champ d’incrimination.",
                    ),
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00040",
                      "3) Une victime mineure",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00041",
                      "• Victime vivante",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00042",
                        "Il ne peut y avoir agression sexuelle sur un cadavre. Cela relève d’une infraction autonome : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00043",
                        "article 225-17 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00044",
                        " (atteinte à l’intégrité du cadavre).",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00045",
                      "• Mineur de moins de 18 ans",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00046",
                        "L’âge à retenir est celui au moment des faits (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00047",
                        "Cass. crim., 21 mars 1957",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00048",
                        "). L’âge se calcule d’heure à heure (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00049",
                        "Cass. crim., 3 septembre 1985",
                      ),
                    ),
                    normal(")."),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00050",
                        "À défaut d’acte probant, la preuve de l’âge peut se faire par tout moyen (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00051",
                        "Cass. crim., 17 juillet 1991",
                      ),
                    ),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00052",
                      "Le texte n’exige pas que la minorité soit apparente ou connue : le mineur bénéficie d’une protection particulière.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00053",
                          "La question du consentement ne se pose pas : un mineur n’est pas apte à consentir à un acte sexuel avec un majeur ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00054",
                          "lorsqu’il existe certains liens de parenté et un rapport d’autorité. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00055",
                          "Il n’est donc pas nécessaire de prouver violence, contrainte, menace ou surprise.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00056",
                          "Si la victime est majeure, l’incrimination d’agression sexuelle de ",
                        ),
                      ),
                      lawRef(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00057",
                          "l’article 222-27 du C.P.",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                              "f00058",
                              " peut être retenue en cas de violence, contrainte, menace ou surprise. ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                              "f00059",
                              "La « surqualification » incestueuse (",
                            ),
                      ),
                      lawRef(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00060",
                          "art. 222-22-3 C.P.",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00061",
                          ") pourra alors s’appliquer.",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00062",
                      "4) Lien de parenté direct ou indirect (liste exhaustive)",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00063",
                        "La liste des liens de parenté est fixée par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00064",
                        "l’article 222-22-3 du C.P.",
                      ),
                    ),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00065",
                      "Ascendants : père, mère, aïeuls (légitimes, naturels ou adoptifs).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00066",
                      "Frères et sœurs ; oncles et tantes ; grands-oncles et grands-tantes ; neveux et nièces.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00067",
                      "Conjoints et concubins de ces personnes, ou partenaires liés par un PACS.",
                    ),
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00068",
                      "5) Autorité de droit ou de fait sur la victime",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00069",
                          "Le seul lien de parenté ne suffit pas : il faut démontrer l’existence d’une autorité sur le mineur. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00070",
                          "Elle peut être de droit (ex. parents) ou de fait (permanente ou discontinue), établie par des circonstances particulières.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00071",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                              "f00072",
                              "Le partenaire lié à la tante de la victime par un PACS ne peut être qualifié d’auteur d’une agression incestueuse ",
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                              "f00073",
                              "si l’existence d’une autorité de droit ou de fait sur la victime n’est pas rapportée (",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00074",
                          "Cass. crim., 15 mars 2023, n° 21-87.389",
                        ),
                      ),
                      normal(")."),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // III — Élément moral
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                  "f00075",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00076",
                      "Conscience de commettre un acte immoral ou obscène",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00077",
                          "Comme pour tout crime ou délit, l’agression sexuelle incestueuse exige une intention coupable. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00078",
                          "L’auteur sait qu’il commet un acte immoral ou obscène. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00079",
                          "Cette intention est presque toujours indissociable de l’acte matériel. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                          "f00080",
                          "Le mobile importe peu (vengeance, haine, lubricité, etc.).",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // IV — Circonstances aggravantes
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                  "f00081",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00082",
                      "Aucune circonstance aggravante spécifique prévue par cette fiche.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // V — Répression / tentative / complicité
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                  "f00083",
                  "V — Répression, tentative et complicité",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00084",
                      "Peines encourues (personnes physiques)",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00085",
                        "Qualification : agression sexuelle incestueuse — délit (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00086",
                        "article 222-29-3 du C.P.",
                      ),
                    ),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00087",
                      "Peine principale : 10 ans d’emprisonnement.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00088",
                      "Amende : 150 000 €.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00089",
                        "Responsabilité pénale des personnes morales : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00090",
                        "article 222-33-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00091",
                        " (amende + peines complémentaires prévues à ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00092",
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
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00093",
                        "Tentative : OUI — prévue par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00094",
                        "l’article 222-31 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00095",
                        ". En pratique, la distinction est délicate : le commencement d’exécution correspond souvent à une agression déjà consommée.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                      "f00096",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00097",
                        "Complicité : OUI — punissable conformément aux ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00098",
                        "articles 121-6 et 121-7 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/viol_inceste_agressions/agression_sexuelle_incestueuse_page.dart",
                        "f00099",
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
