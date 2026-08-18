import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPersonneVulnerablePage extends StatelessWidget {
  const PaPersonneVulnerablePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/personne_vulnerable';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

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

    // Helpers TextSpan
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
            "f00001",
            "Agressions sexuelles sur personne vulnérable",
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
              // ✅ EXIGENCE : l’élément légal tout en haut
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
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
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00003",
                        "Article 222-22 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00004",
                        " : définit les agressions sexuelles commises avec violence, contrainte, menace ou surprise.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00005",
                        "Article 222-29 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00006",
                        " : prévoit et réprime les agressions sexuelles autres que le viol lorsqu’elles sont imposées à une personne vulnérable.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                  "f00007",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00008",
                          "Les agressions sexuelles autres que le viol imposées à une personne dont la particulière vulnérabilité ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00009",
                          "(âge, maladie, infirmité, déficience physique ou psychique, grossesse) ou résultant de la précarité ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00010",
                          "économique ou sociale, lorsque cette vulnérabilité est apparente ou connue de l’auteur, constituent une infraction.",
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00011",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00012",
                      "Acte sexuel sans pénétration et sans acte bucco-génital (sinon : viol).",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00013",
                      "Victime : vulnérabilité particulière préexistante, apparente ou connue.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00014",
                      "Absence de consentement : violence / contrainte / menace / surprise.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                  "f00015",
                  "I — Élément légal",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00016",
                        "Article 222-22 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00017",
                        " : agressions sexuelles commises avec violence, contrainte, menace ou surprise.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00018",
                        "Article 222-29 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00019",
                        " : réprime les agressions sexuelles autres que le viol imposées à une personne vulnérable.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                  "f00020",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00021",
                      "1) Un acte de nature sexuelle autre qu’une pénétration ou un acte bucco-génital",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00022",
                          "L’agression sexuelle suppose un contact physique entre l’agresseur et sa victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00023",
                          "Elle se définit comme tout acte impudique, autre qu’une pénétration ou qu’un acte bucco-génital, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00024",
                          "directement exercé sur une personne.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00025",
                      "Elle peut être le fait de l’auteur sur la victime, mais aussi celui effectué par la victime contrainte sur l’auteur.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00026",
                          "Le plus grand nombre est constitué d’attouchements ou de caresses (sexe, fesses, cuisses, poitrine), ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00027",
                          "éventuellement accompagnés de baisers sur le corps ou sur la bouche.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00028",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00029",
                          "Attouchements / caresses : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00030",
                          "C.A. Paris, 19 juin 1985",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00031",
                          "Main passée sous le pull-over pour caresser le dos : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00032",
                          "C.A. Agen, 27 octobre 1997",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00033",
                      "2) Cas à ne pas confondre",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00034",
                        "Exhibition sexuelle : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00035",
                        "article 222-32 du C.P.",
                      ),
                    ),
                    normal(". "),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00036",
                        "Incitation à la corruption de mineur : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00037",
                        "article 227-22 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00038",
                      "3) Acte commis sur la personne d’autrui",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00039",
                          "Une victime vivante : il ne peut y avoir agression sexuelle sur un cadavre. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00040",
                          "L’infraction suppose l’absence de consentement, or un mort ne peut consentir.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00041",
                        "Article 225-17 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00042",
                        " : réprime l’atteinte à l’intégrité du cadavre (infraction autonome).",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00043",
                      "4) Victime particulièrement vulnérable (condition spécifique)",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00044",
                        "Au sens de ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00045",
                        "l’article 222-29 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                            "f00046",
                            ", sont visées les victimes hors d’état de se protéger en raison d’un état de faiblesse. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                            "f00047",
                            "Les causes de vulnérabilité doivent préexister aux faits (et ne pas être la conséquence des faits).",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00048",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00049",
                          "La vulnérabilité doit préexister aux faits : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00050",
                          "Cass. crim., 17 octobre 1984",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00051",
                      "La vulnérabilité doit être apparente ou connue : l’auteur agit en raison de cette vulnérabilité.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00052",
                      "5) Les causes de vulnérabilité (pédagogique)",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00053",
                      "Âge : ne suffit pas à lui seul → il faut démontrer une vulnérabilité particulière.",
                    ),
                  ),
                  const SizedBox(height: 6),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00054",
                      "Jurisprudence (âge)",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00055",
                          "Seul âge insuffisant : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00056",
                          "TGI Montpellier, 7 décembre 2000",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00057",
                          "Nécessité d’une vulnérabilité particulière : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00058",
                          "Cass. crim., 30 avril 1996",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00059",
                          "Âge seul ne suffit pas sans autres constatations : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00060",
                          "Cass. crim., 23 juin 1999",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00061",
                      "Maladie / infirmité / déficience physique ou psychique : dysfonctionnements physiques ou mentaux (innés ou acquis).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00062",
                      "Grossesse : peut entraîner une vulnérabilité pendant la grossesse et parfois après l’accouchement.",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00063",
                      "Précarité économique ou sociale : situation de dépendance, exposition à l’exploitation de la misère.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00064",
                      "Jurisprudence (précarité)",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00065",
                          "Salariés en vulnérabilité sociale et économique : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00066",
                          "Cass. crim., 4 mars 2003",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                              "f00067",
                              "Des incriminations spécifiques visent les agressions sexuelles commises sur des mineurs de 15 ans ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                              "f00068",
                              "(voir fiche : agressions sexuelles imposées à un mineur de 15 ans par violence/contrainte/menace/surprise, ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                              "f00069",
                              "et fiche : agression sexuelle commise par un majeur sur un mineur de 15 ans).",
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00070",
                      "6) Absence de consentement : 4 moyens",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00071",
                          "Comme pour le viol, ces agressions supposent l’usage de violence, contrainte, menace ou surprise. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00072",
                          "En l’absence de précision exhaustive du texte, la jurisprudence aide à définir le contenu.",
                        ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00073",
                      "• La violence",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00074",
                          "Violence physique exercée sur la victime. Les pressions doivent être suffisantes pour accomplir l’acte malgré le refus. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00075",
                          "Il doit être établi que la victime n’a pas pu résister. L’appréciation appartient aux juges.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00076",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00077",
                          "Pincer les fesses + faire pénétrer de force dans un véhicule : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00078",
                          "Cass. crim., 15 avril 1992",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00079",
                      "• La contrainte ou la menace",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00080",
                          "Violences morales supprimant le consentement. La crainte doit être sérieuse et immédiate, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00081",
                          "appréciée concrètement selon la capacité de résistance.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00082",
                        "Appréciation : ",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00083",
                        "Cass. crim., 8 juin 1994",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00084",
                        "Article 222-22-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00085",
                        " : la contrainte prévue par l’article 222-22 peut être physique ou morale.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00086",
                      "• La surprise",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00087",
                          "Surprendre le consentement (et non la surprise ressentie). Elle peut accompagner la violence ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00088",
                          "(victime consciente mais ne peut s’opposer) ou résulter d’une tromperie / d’une impossibilité ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00089",
                          "de consentir pleinement (enfants, troubles mentaux, handicap, victime trompée…).",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00090",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00091",
                          "Prétexte fallacieux de visite médicale : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00092",
                          "Cass. crim., 20 juin 2001",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                  "f00093",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00094",
                      "Intention coupable",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00095",
                          "L’auteur doit avoir conscience de commettre un acte immoral ou obscène contre le gré de la victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00096",
                          "Cette intention est généralement inséparable de l’acte matériel. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                          "f00097",
                          "Le mobile importe peu (vengeance, haine, lubricité, etc.).",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                  "f00098",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00099",
                        "Article 222-30 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00100",
                        " : le délit est aggravé notamment lorsque :",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00101",
                      "Il a entraîné une blessure ou une lésion.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00102",
                      "Il est commis par une personne abusant de l’autorité de ses fonctions.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00103",
                      "Il est commis par un ascendant ou une personne ayant autorité de droit ou de fait.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00104",
                      "Il est commis avec usage ou menace d’une arme.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00105",
                      "Il est commis par plusieurs auteurs/complices.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00106",
                      "Il est commis en état d’ivresse manifeste ou sous stupéfiants.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00107",
                      "Une substance a été administrée à l’insu de la victime pour altérer son discernement.",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                  "f00108",
                  "V — Répression, tentative et complicité",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00109",
                      "Peines encourues (personnes physiques)",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00110",
                        "Agression sexuelle sur personne vulnérable (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00111",
                        "article 222-29 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00112",
                        ") : 7 ans d’emprisonnement et 100 000 € d’amende.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00113",
                        "Forme aggravée (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00114",
                        "article 222-30 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00115",
                        ") : 10 ans d’emprisonnement et 150 000 € d’amende.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00116",
                      "Personnes morales",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00117",
                        "Responsabilité : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00118",
                        "article 222-33-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00119",
                        " + peines complémentaires : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00120",
                        "article 131-39 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00121",
                        "Tentative : OUI — spécialement prévue par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00122",
                        "l’article 222-31 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00123",
                        ", mais souvent difficile à distinguer car le commencement d’exécution peut déjà constituer une agression consommée.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                      "f00124",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00125",
                        "Complicité : OUI — ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00126",
                        "articles 121-6 et 121-7 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00127",
                        " (aide/assistance, provocation, instructions). Elle peut aussi constituer une circonstance aggravante (",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/personne_vulnerable_page.dart",
                        "f00128",
                        "article 222-30 4° du C.P.",
                      ),
                    ),
                    normal(")."),
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
