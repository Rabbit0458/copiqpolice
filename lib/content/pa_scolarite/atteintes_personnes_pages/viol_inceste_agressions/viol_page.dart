import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaViolPage extends StatelessWidget {
  const PaViolPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/viol';

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
          "Viol",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                  "f00001",
                  "Article de référence (élément légal)",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00002",
                        "Article 222-23 du Code pénal",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00003",
                        " : définit et réprime le viol commis par violence, contrainte, menace ou surprise.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                  "f00004",
                  "Définition",
                ),
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00005",
                          "Tout acte de pénétration sexuelle, de quelque nature qu’il soit, ou tout acte bucco-génital ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00006",
                          "commis sur la personne d’autrui ou sur la personne de l’auteur par violence, contrainte, menace ou surprise ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00007",
                          "est un viol et constitue une infraction.",
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00008",
                      "À retenir",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00009",
                      "Acte : pénétration sexuelle OU acte bucco-génital.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00010",
                      "Contexte : violence, contrainte, menace ou surprise.",
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00011",
                      "Peut viser la victime ou l’auteur (acte réalisé sur l’auteur).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                  "f00012",
                  "I — Élément légal",
                ),
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00013",
                        "Article 222-23 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00014",
                            " : le viol est constitué lorsqu’un acte de pénétration sexuelle ou un acte bucco-génital ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00015",
                            "est imposé par violence, contrainte, menace ou surprise.",
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                  "f00016",
                  "II — Élément matériel",
                ),
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00017",
                      "1) Un acte de pénétration sexuelle",
                    ),
                  ),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00018",
                        "Article 222-23 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00019",
                        " vise « tout acte de pénétration sexuelle, de quelque nature qu’il soit ».",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00020",
                          "Relève de l’incrimination tout acte de pénétration dans le sexe ou par le sexe. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00021",
                          "La nature de l’acte importe peu : rapports dits « normaux », sodomie, introduction d’un doigt ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00022",
                          "ou de corps étrangers dans le sexe ou l’anus de la victime.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00023",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00024",
                          "Sodomie : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00025",
                          "Cass. crim., 3 juillet 1991",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00026",
                      "2) Ou un acte bucco-génital",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00027",
                          "Le texte vise aussi « tout acte bucco-génital ». Un contact suffit : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00028",
                          "cela inclut fellation et cunnilingus.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00029",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00030",
                          "Fellation constitutive de viol en cas de pénétration : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00031",
                          "Cass. crim., 22 février 1984",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00032",
                          "Fellations réciproques : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00033",
                          "Cass. crim., 28 novembre 2001",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00034",
                      "3) Sur la victime ou sur l’auteur",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00035",
                          "Le viol est caractérisé aussi bien lorsque l’auteur commet l’acte sur la victime, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00036",
                          "que lorsque l’acte est réalisé sur la personne de l’auteur.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00037",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00038",
                          "Doigt introduit contre son gré dans le vagin : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00039",
                          "Cass. crim., 8 janvier 1991",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00040",
                          "Manche de pioche introduit dans l’anus : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00041",
                          "Cass. crim., 6 décembre 1995",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00042",
                      "4) Une victime",
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00043",
                      "• Victime vivante",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00044",
                        "Il ne peut y avoir viol sur un cadavre (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00045",
                        "Cass. crim., 30 août 1877",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00046",
                        "). L’atteinte au cadavre relève de ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00047",
                        "l’article 225-17 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00048",
                      "• Indifférence de la condition de la victime",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00049",
                          "La condition de la victime importe peu : prostituée, hôtesse de bar, relation antérieure consentie, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00050",
                          "ou relation conjugale… cela n’écarte pas la qualification si le rapport est imposé.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Le "),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00051",
                        "article 222-22 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00052",
                            " précise que les faits sont constitués quelle que soit la nature des relations entre l’agresseur et la victime, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00053",
                            "y compris s’ils sont unis par les liens du mariage.",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00054",
                          "Le viol commis par un majeur sur un mineur de 15 ans et le viol incestueux sont des infractions autonomes (fiches distinctes).",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00055",
                      "5) Absence de consentement : les 4 moyens",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00056",
                        "Le viol suppose que l’auteur utilise un moyen pour atteindre son but hors de la volonté de la victime (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00057",
                        "Cass. crim., 29 avril 1960",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00058",
                        "). Ces moyens sont fixés par ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00059",
                        "l’article 222-23 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00060",
                        " : violence, contrainte, menace ou surprise.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00061",
                      "• La violence",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00062",
                          "Violence physique exercée sur la victime. Les pressions doivent être suffisantes pour paralyser la résistance. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00063",
                          "Les juges apprécient concrètement la résistance ; la jurisprudence actuelle est moins exigeante et plus favorable à la victime.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00064",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00065",
                          "Conducteur imposant un rapport malgré supplications : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00066",
                          "Cass. crim., 10 juillet 1973",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00067",
                          "Rapport imposé à une hôtesse de bar malgré comportement équivoque : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00068",
                          "Cass. crim., 3 mai 1993",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00069",
                      "• La contrainte ou la menace",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00070",
                          "Ces moyens visent à supprimer le consentement : violences morales assimilées à des violences physiques. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00071",
                          "La crainte doit être sérieuse et immédiate, appréciée concrètement selon la capacité de résistance de la victime.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00072",
                        "La contrainte peut être physique ou morale : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00073",
                        "article 222-22-1 (alinéa 1) du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00074",
                        "Appréciation concrète (",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00075",
                        "Cass. crim., 8 juin 1994",
                      ),
                    ),
                    normal(")."),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00076",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00077",
                          "Vulnérabilité face au médecin abusant lors d’une consultation : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00078",
                          "Cass. crim., 25 octobre 1994",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00079",
                          "Crainte face à un directeur despotique : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00080",
                          "Cass. crim., 8 février 1995",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00081",
                          "Menace d’abandon en pleine nuit par froid/brouillard : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00082",
                          "Cass. crim., 11 février 1992",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00083",
                      "• La surprise",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00084",
                          "La surprise s’entend comme « surprendre le consentement », et non la surprise ressentie par la victime. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00085",
                          "Elle vise notamment les victimes dont la maturité est insuffisante, ou vulnérables (troubles mentaux, handicap), ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00086",
                          "ou trompées/perturbées au point de ne pouvoir consentir.",
                        ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00087",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00088",
                          "Victime de 16 ans, déficience intellectuelle profonde et surdité : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00089",
                          "Cass. crim., 6 novembre 1961",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00090",
                          "Adulte sous tutelle : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00091",
                          "Cass. crim., 30 juin 1993",
                        ),
                      ),
                      normal(". "),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00092",
                          "Viol commis en état d’hypnose : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00093",
                          "Cass. crim., 3 septembre 1991",
                        ),
                      ),
                      normal("."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00094",
                      "À distinguer",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                              "f00095",
                              "L’ivresse/stupéfiants consommés volontairement ne suffisent pas à caractériser une vulnérabilité ; ",
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                              "f00096",
                              "mais l’ivresse peut permettre de qualifier la surprise (",
                            ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00097",
                          "Cass. crim., 18 décembre 1991",
                        ),
                      ),
                      normal(")."),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00098",
                      "L’administration à l’insu d’une substance altérant le discernement ou le contrôle des actes est une circonstance aggravante.",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00099",
                        "Faits sur mineur : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00100",
                        "article 222-22-1 (alinéas 2 et 3) du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00101",
                            " : la contrainte morale ou la surprise peuvent résulter d’une différence d’âge significative et d’une autorité de droit ou de fait. ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00102",
                            "Si la victime a moins de 15 ans, elles peuvent résulter de l’abus de vulnérabilité (absence de discernement).",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00103",
                          "Dans certains cas prévus par la loi, violence/contrainte/menace/surprise n’ont pas à être démontrées (voir fiches dédiées).",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                  "f00104",
                  "III — Élément moral",
                ),
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00105",
                      "Intention coupable",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00106",
                          "Le viol requiert la conscience d’imposer à la victime des rapports sexuels non consentis. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00107",
                          "Le mobile importe peu (haine, vengeance, recherche de jouissance, etc.). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00108",
                          "La preuve est souvent facile en cas de violences/menaces explicites, plus délicate lorsque l’auteur invoque sa bonne foi ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00109",
                          "la jurisprudence tend à renforcer la protection des victimes.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                  "f00110",
                  "IV — Circonstances aggravantes",
                ),
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00111",
                      "1er degré d’aggravation",
                    ),
                  ),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00112",
                        "Article 222-24 du C.P.",
                      ),
                    ),
                    normal(" :"),
                  ]),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00113",
                      "Mutilation ou infirmité permanente.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00114",
                      "Victime mineure de quinze ans.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00115",
                      "Victime vulnérable (âge, maladie, infirmité, déficience, grossesse) apparente ou connue.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00116",
                      "Vulnérabilité/dépendance liée à la précarité économique et sociale apparente ou connue.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00117",
                      "Auteur : ascendant ou personne ayant autorité de droit ou de fait sur la victime.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00118",
                      "Abus d’autorité conférée par les fonctions.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00119",
                      "Plusieurs auteurs/complices (participation simultanée aux faits).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00120",
                      "Usage ou menace d’une arme.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00121",
                      "Mise en contact via réseau de communication électronique (messages à public non déterminé).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00122",
                      "Concours avec un ou plusieurs autres viols (série/ simultané).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00123",
                      "Conjoint/concubin/partenaire PACS de la victime.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00124",
                      "Auteur en état d’ivresse manifeste ou sous emprise manifeste de stupéfiants.",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00125",
                      "Dans l’exercice de l’activité, sur une personne se livrant à la prostitution (même occasionnelle).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00126",
                      "Présence d’un mineur au moment des faits (y assiste).",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00127",
                      "Substance administrée à l’insu pour altérer discernement/contrôle des actes.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00128",
                      "Jurisprudence",
                    ),
                    bodySpans: [
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00129",
                          "Vulnérabilité : l’âge seul (70 ans) ne suffit pas sans corrélation démontrée : ",
                        ),
                      ),
                      normal(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                          "f00130",
                          "Cass. crim., 8 juin 2010",
                        ),
                      ),
                      normal("."),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00131",
                      "2e degré d’aggravation",
                    ),
                  ),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00132",
                        "Article 222-25 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00133",
                        " : lorsqu’il a entraîné la mort de la victime.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00134",
                      "3e degré d’aggravation",
                    ),
                  ),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00135",
                        "Article 222-26 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00136",
                        " : lorsqu’il est précédé, accompagné ou suivi de tortures ou d’actes de barbarie.",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                  "f00137",
                  "V — Répression, tentative et complicité",
                ),
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00138",
                      "Peines encourues (personnes physiques)",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00139",
                        "Forme simple : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00140",
                        "article 222-23 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00141",
                        " → 15 ans de réclusion criminelle.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00142",
                        "Aggravé 1er degré : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00143",
                        "article 222-24 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00144",
                        " → 20 ans de réclusion criminelle.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00145",
                        "Aggravé 2e degré : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00146",
                        "article 222-25 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00147",
                        " → 30 ans de réclusion criminelle + période de sûreté.",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00148",
                        "Aggravé 3e degré : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00149",
                        "article 222-26 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00150",
                        " → réclusion à perpétuité + période de sûreté.",
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00151",
                      "Personnes morales",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00152",
                        "Responsabilité : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00153",
                        "article 222-33-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00154",
                        " + peines complémentaires : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00155",
                        "article 131-39 du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00156",
                      "Tentative : OUI (punissable comme la tentative de tout autre crime).",
                    ),
                  ),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00157",
                      "Complicité",
                    ),
                  ),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00158",
                        "Complicité : OUI — ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00159",
                        "articles 121-6 et 121-7 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00160",
                        " (aide/assistance, provocation, instructions).",
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    normal(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00161",
                        "La complicité est aussi une circonstance aggravante : ",
                      ),
                    ),
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00162",
                        "article 222-24 (6°) du C.P.",
                      ),
                    ),
                    normal("."),
                  ]),

                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00163",
                      "Provocation à commettre un viol (infraction distincte)",
                    ),
                  ),
                  _Paragraph.rich([
                    lawRef(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                        "f00164",
                        "Article 222-26-1 du C.P.",
                      ),
                    ),
                    normal(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00165",
                            " : incrimine l’« instigateur » (offres, promesses, dons, présents ou avantages) ",
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                            "f00166",
                            "afin qu’une personne commette un viol, y compris si le crime n’a été ni commis ni tenté.",
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00167",
                      "Peine : 10 ans d’emprisonnement et 150 000 € d’amende (si non suivi d’effet).",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/viol_inceste_agressions/viol_page.dart",
                      "f00168",
                      "Si la provocation est suivie d’un viol ou d’une tentative : application des règles de complicité (mêmes peines que l’auteur).",
                    ),
                  ),
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
