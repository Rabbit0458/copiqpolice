import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaClassificationInfractionsGPXSchoolPageLoiPenal extends StatelessWidget {
  const PaClassificationInfractionsGPXSchoolPageLoiPenal({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/loi_penale/classification_infractions/classification';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : Colors.white;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    // Couleur unique pour TOUS les articles de loi
    const Color lawRed = Color(0xFFE53935);

    // Couleurs cartes
    final Color card1 = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF7F7F7);
    final Color card2 = isDark
        ? const Color(0xFF2B2B2B)
        : const Color(0xFFF3F6FF);
    final Color card3 = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFFFF8E1);

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
            "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
            "f00002",
            "Classification des infractions",
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
              "f00003",
              "CHAPITRE 2 :\nCLASSIFICATION DES INFRACTIONS",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00004",
                  "Classification tripartite, classification fondée sur la nature de l’infraction ",
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00005",
                  "et classification fondée sur le mode de réalisation.",
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ====================== 2.1 ===========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
              "f00006",
              "2.1 — LA CLASSIFICATION TRIPARTITE",
            ),
            cardColor: card1,
            accent: const Color(0xFF1565C0),
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00007",
                  "2.1.1 — Le principe",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00008",
                    "Le Code pénal, dans son ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00009",
                    "article 111-1 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00010",
                        " dispose : « Les infractions pénales sont classées suivant leur gravité ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00011",
                        "en crimes, délits et contraventions. »",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00012",
                  "Il opte donc pour une classification fondée sur la gravité de l’infraction commise.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00013",
                        "Les infractions se divisent en crimes, délits et contraventions. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00014",
                        "La nomenclature des peines applicables est fixée par les ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00015",
                    "articles 131-1 à 131-18 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00016",
                    " (cf. tableau).",
                  ),
                ),
              ]),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00017",
                  "2.1.2 — Les intérêts de cette classification",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00018",
                  "2.1.2.1 — Pour les règles de fond",
                ),
              ),
              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00019",
                    "La tentative",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00020",
                        " : elle est toujours punissable pour les crimes, pour les délits lorsque le texte le prévoit, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00021",
                        "et jamais pour les contraventions.",
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00022",
                    "La complicité",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00023",
                        " : elle est toujours prévue pour les crimes et délits, mais ne l’est, pour les contraventions, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00024",
                        "que lorsque des dispositions réglementaires le prévoient expressément.",
                      ),
                ),
              ]),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00025",
                  "2.1.2.2 — Pour la prescription",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00026",
                  "2.1.2.2.1 — Prescription de l’action publique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00027",
                  "Elle correspond à la date au-delà de laquelle il n’est plus possible de poursuivre l’auteur d’une infraction.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00028",
                    "Le délai de prescription est de vingt ans pour les crimes, six ans pour les délits et un an pour les contraventions (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00029",
                    "articles 7, 8 et 9 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00030",
                  "Il existe cependant des délais exceptionnels pour certaines infractions particulières :",
                ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00031",
                    "Délai imprescriptible de l’action publique en cas de crime de génocide ou contre l’humanité (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00032",
                    "articles 211-1 à 212-3 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00033",
                    "30 ans en cas de crime lié à des actes de terrorisme et 20 ans pour les délits relatifs aux mêmes faits (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00034",
                    "article 706-16 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00035",
                    "30 ans en cas de crime de trafic de stupéfiants ainsi que les crimes de participation à une association de malfaiteurs prévus par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00036",
                    "l’article 450-1 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00037",
                    " lorsqu’ils ont pour objet de préparer une infraction de trafic de stupéfiants, et 20 ans s’il s’agit d’un délit (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00038",
                    "article 706-26 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00039",
                    "30 ans pour les crimes sur mineurs listés à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00040",
                    "l’article 706-47 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00041",
                    " (meurtre, tortures ou actes de barbarie, violences sur mineur de 15 ans ayant entraîné une mutilation ou une infirmité permanente, viol).",
                  ),
                ),
              ]),
              SizedBox(height: 6),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00042",
                      "✓ 20 ans pour les délits d’agressions sexuelles, atteintes sexuelles aggravées sur mineur de 15 ans, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00043",
                      "et violences volontaires aggravées ayant entraîné une incapacité totale de travail de plus de 8 jours commises sur un mineur.",
                    ),
              ),
              SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00044",
                    "10 ans pour les délits commis sur des mineurs mentionnés aux articles ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00045",
                    "223-15-2 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00046",
                    " (abus frauduleux de l’état d’ignorance ou de la situation de faiblesse d’un mineur), ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00047",
                    "223-15-3 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00048",
                    " (placement ou maintien dans un état de sujétion psychologique ou physique), ainsi que ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00049",
                    "706-47 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00050",
                    " à l’exception de ceux mentionnés aux articles ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00051",
                    "222-29-1 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00052",
                    "227-26 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00053",
                    " (agressions et atteintes sexuelles sur mineur de quinze ans).",
                  ),
                ),
              ]),

              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00054",
                    "1 an pour certains délits de presse à caractère discriminatoire (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00055",
                    "article 65-3 de la loi du 29 juillet 1881",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 6),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00056",
                  "✓ 20 ans en cas de délits de guerre.",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00057",
                  "✓ 30 ans en cas de crimes de guerre.",
                ),
              ),
              SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00058",
                    "3 mois pour les délits de presse tels que la diffamation (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00059",
                    "article 65 de la loi du 29 juillet 1881",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00060",
                  "2.1.2.2.2 — Prescription de la peine",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00061",
                  "C’est la date au-delà de laquelle une peine prononcée ne peut plus être appliquée.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00062",
                    "Elle est de 20 ans pour les crimes, 6 ans pour les délits et 3 ans pour les contraventions (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00063",
                    "articles 133-2 à 133-4 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(text: "✓ "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00064",
                    "Imprescriptibilité des crimes contre l’humanité (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00065",
                    "article 133-2 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00066",
                  "2.1.2.3 — Pour les règles de procédure",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00067",
                  "2.1.2.3.1 — Les juridictions compétentes",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00068",
                      "Les contraventions sont jugées par le tribunal de police, les délits par le tribunal correctionnel ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00069",
                      "et les crimes par la cour d’assises ou la cour criminelle départementale.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00070",
                  "2.1.2.3.2 — Le cadre d’enquête",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00071",
                      "Pour les crimes et délits, l’enquête de flagrance peut être utilisée ; pour les contraventions, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00072",
                      "seule l’enquête préliminaire est possible.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ====================== 2.2 ===========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
              "f00073",
              "2.2 — CLASSIFICATION FONDÉE SUR LA NATURE DE L’INFRACTION",
            ),
            cardColor: card2,
            accent: const Color(0xFF1E88E5),
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00074",
                      "Il existe, à côté des infractions de droit commun, des infractions spécifiques. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00075",
                      "Leur spécificité tient à la nature des intérêts lésés, qui sont souvent ceux de l’État.",
                    ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00076",
                  "2.2.1 — Infractions de droit commun et infractions politiques",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00077",
                      "Cette distinction existe de tout temps pour appliquer un régime juridique différent. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00078",
                      "À certains moments de l’histoire, les délinquants politiques ont été traités avec davantage de sévérité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00079",
                      "et à d’autres avec plus d’indulgence que les délinquants de droit commun. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00080",
                      "Le Code pénal de 1810 prévoyait l’application de peines spéciales comme la déportation ou le bannissement. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00081",
                      "Cependant, aucune définition de l’infraction politique n’a été donnée.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00082",
                  "2.2.1.1 — Critères de distinction de l’infraction politique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00083",
                      "En l’absence de définition légale, la doctrine et la jurisprudence ont tenté de déterminer les caractères distinctifs ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00084",
                      "de l’infraction politique. Le critère retenu est un critère objectif : est considérée comme politique toute infraction ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00085",
                      "portant atteinte à l’organisation et au fonctionnement des pouvoirs publics, à l’intérêt de l’État ou même à son existence. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00086",
                      "La jurisprudence prend donc en compte le seul objet de l’infraction, et non les mobiles de l’auteur : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00087",
                      "une infraction commise pour des mobiles politiques peut rester une infraction de droit commun.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00088",
                  "2.2.1.2 — Intérêts de la distinction",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00089",
                  "2.2.1.2.1 — Quant au régime applicable",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00090",
                  "✓ Application de peines spécifiques en matière criminelle : détention criminelle.",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00091",
                  "✓ Le régime d’exécution de la peine d’emprisonnement est moins sévère que le régime commun.",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00092",
                  "✓ Le condamné pourra bénéficier ultérieurement du sursis, et la condamnation ne peut pas révoquer un sursis antérieur.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00093",
                  "2.2.1.2.2 — Quant aux règles de forme",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00094",
                  "✓ Depuis la suppression des juridictions d’exception, les crimes politiques relèvent de la cour d’assises.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00095",
                    "— Exceptions : certains crimes (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00096",
                    "articles 411-1 à 411-11 et 413-1 à 413-12 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00097",
                    ") commis en temps de paix sont jugés par la cour d’assises sans jurés, par sept magistrats professionnels.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00098",
                  "✓ Les délits politiques sont jugés par les tribunaux correctionnels.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00099",
                      "— Exceptions : les délits contre les intérêts fondamentaux de la Nation relèvent de la compétence des juridictions des forces armées en temps de guerre. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00100",
                      "En temps de paix, certains délits contre les intérêts fondamentaux de la Nation relèvent du tribunal correctionnel spécialisé en matière militaire.",
                    ),
              ),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00101",
                  "2.2.2 — Infractions de droit commun et infractions terroristes",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00102",
                  "2.2.2.1 — Critères de distinction de l’infraction de terrorisme",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00103",
                    "Le Code pénal a consacré un titre entier aux infractions de terrorisme. Il a énoncé aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00104",
                    "articles 421-1 à 421-6 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00105",
                        " une liste d’infractions qui, commises dans certaines circonstances et pour certains motifs, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00106",
                        "sont qualifiées d’infractions de terrorisme.",
                      ),
                ),
              ]),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00107",
                  "2.2.2.2 — Intérêts de la distinction",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00108",
                  "Il existe des règles particulières de procédure (notamment en matière de perquisition et de garde à vue).",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00109",
                    "L’article 706-17 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00110",
                        " prévoit une possibilité de centralisation des procédures de terrorisme à Paris ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00111",
                        "(dessaisissement au profit de la juridiction parisienne).",
                      ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00112",
                    "Pour le jugement des infractions terroristes, la cour d’assises est composée uniquement de magistrats professionnels (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00113",
                    "articles 706-25 et 698-6 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00114",
                    "Les infractions de terrorisme exposent leur auteur à des peines aggravées (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00115",
                    "articles 421-3 à 421-6 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00116",
                  "2.2.3 — Infractions de droit commun et infractions militaires",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00117",
                  "2.2.3.1 — Définition de l’infraction militaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00118",
                      "Est une infraction militaire tout acte qui constitue un manquement à la discipline ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00119",
                      "(rébellion, refus d’obéissance) et aux obligations militaires (désertion, insoumission).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00120",
                    "Est également qualifiée d’infraction militaire l’infraction de droit commun commise par un militaire dans l’exercice de ses missions. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00121",
                    "L’article L. 2 du Code de justice militaire",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00122",
                        " précise qu’en temps de paix, les infractions commises par les membres des forces armées ou à l’encontre de celles-ci ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00123",
                        "relèvent des juridictions de droit commun spécialisées en matière militaire dans les cas prévus à l’article L. 111-1. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00124",
                        "Hors ces cas, elles relèvent des juridictions de droit commun.",
                      ),
                ),
              ]),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00125",
                  "2.2.3.2 — Conséquences de la distinction",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00126",
                  "2.2.3.2.1 — Quant aux règles de fond",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00127",
                  "✓ Il existe des peines spécifiques comme la destitution et la perte du grade.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00128",
                  "2.2.3.2.2 — Quant aux règles de forme",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00129",
                  "✓ En temps de guerre, ce sont les tribunaux territoriaux des forces armées (faits commis en France), ou les tribunaux militaires aux armées (faits commis à l’étranger).",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00130",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00131",
                    "article 699 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00132",
                  "✓ L’extradition n’est pas applicable sauf exception.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ====================== 2.3 ===========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
              "f00133",
              "2.3 — CLASSIFICATION FONDÉE SUR LE MODE DE RÉALISATION DE L’INFRACTION",
            ),
            cardColor: card3,
            accent: const Color(0xFFF9A825),
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00134",
                  "2.3.1 — Infractions de commission et infractions d’omission",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00135",
                  "2.3.1.1 — Infractions de commission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00136",
                  "Elles consistent en la réalisation d’un acte prohibé par la loi.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00137",
                  "2.3.1.2 — Infractions d’omission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00138",
                  "Elles supposent que l’omission est réprimée en tant que telle. Ces infractions sont aujourd’hui assez nombreuses.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00139",
                  "Exemples :",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00140",
                    "— omission de porter secours à personne en péril (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00141",
                    "article 223-6 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ") ;"),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00142",
                    "— omission de témoigner en faveur d’un innocent (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00143",
                    "article 434-11 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ") ;"),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00144",
                    "— délaissement d’une personne qui n’est pas en mesure de se protéger (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00145",
                    "article 223-3 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ") ;"),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00146",
                    "— privation d’aliments ou de soins à un mineur de 15 ans (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00147",
                    "article 227-15 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00148",
                  "2.3.1.3 — Infractions de commission par omission",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00149",
                      "Elles supposent que leur auteur soit volontairement resté passif, et qu’il en ait résulté un dommage. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00150",
                      "En d’autres termes : peut-on assimiler une abstention à une action ?",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00151",
                        "Exceptionnellement, l’omission est assimilée pénalement à la commission par le législateur. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                        "f00152",
                        "C’est le cas en matière d’homicide ou de blessures par imprudence (",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00153",
                    "articles 221-6 et 222-19 du Code pénal",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00154",
                  "2.3.2 — Infractions instantanées et infractions continues",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00155",
                  "2.3.2.1 — Définitions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00156",
                      "Les infractions instantanées sont constituées d’un acte qui se réalise en un instant. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00157",
                      "Si l’infraction se réalise en un trait de temps, elle est dite instantanée, peu importe que ses effets se prolongent ou non dans le temps.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00158",
                      "Exemple : la bigamie (contracter un second mariage alors que le premier n’est pas dissous) est un délit instantané, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00159",
                      "car réalisé en un instant, même si ses effets perdurent.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00160",
                  "L’infraction continue est celle dont l’exécution se prolonge dans le temps. Elle suppose une réitération de la volonté coupable de l’auteur.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00161",
                  "Exemples : non-représentation d’enfants, port illégal de décoration, recel de choses volées.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00162",
                  "2.3.2.2 — Intérêts de la distinction",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00163",
                  "2.3.2.2.1 — Quant à la prescription",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00164",
                  "✓ Pour le délit instantané : elle part du jour où l’acte délictueux a été accompli.",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00165",
                  "✓ Pour le délit continu : c’est le jour où l’acte délictueux a pris fin.",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00166",
                  "Exemples : le jour où le receleur n’aura plus l’objet volé ; le jour où une séquestration se termine.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00167",
                  "2.3.2.2.2 — Quant à l’application de la loi nouvelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00168",
                  "Le délit continu est régi par la loi nouvelle car, commencé sous la loi ancienne, il s’est prolongé sous l’empire de la loi nouvelle.",
                ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00169",
                  "2.3.2.2.3 — Quant à la compétence du tribunal",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00170",
                      "Le délit instantané est réalisé en un seul lieu, mais le délit continu peut avoir plusieurs lieux d’exécution : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00171",
                      "les tribunaux de ces différents lieux seront compétents.",
                    ),
              ),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00172",
                  "2.3.2.2.4 — Quant à l’amnistie",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00173",
                  "Le délit continu peut être réprimé malgré l’intervention d’une loi d’amnistie s’il se prolonge après celle-ci.",
                ),
              ),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00174",
                  "2.3.3 — Infractions simples, complexes et d’habitude",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00175",
                  "2.3.3.1 — Définitions",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00176",
                      "L’infraction simple consiste en la réalisation d’un acte unique.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00177",
                      "Exemple : le vol (soustraction frauduleuse de la chose d’autrui).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00178",
                      "L’infraction complexe suppose la réalisation de plusieurs actes matériels de type différent.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00179",
                      "Exemple : l’escroquerie (manœuvres frauduleuses + remise de la chose).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00180",
                      "L’infraction d’habitude est constituée par la réalisation de plusieurs actes semblables qui, pris isolément, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                      "f00181",
                      "ne constituent pas des infractions : c’est leur répétition qui va les ériger en infractions.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00182",
                    "Exemple : exercice illégal de la médecine. Un acte médical unique ne constitue pas un délit : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                    "f00183",
                    "article L. 4161-1 du Code de la santé publique",
                  ),
                  style: TextStyle(color: lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00184",
                  "2.3.3.2 — Intérêts de la distinction",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00185",
                  "2.3.3.2.1 — Prescription de l’action publique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00186",
                  "Pour le délit d’habitude, le point de départ du délai de prescription est le jour où a été accompli le dernier acte constitutif de l’habitude.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00187",
                  "2.3.3.2.2 — Application de la loi nouvelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/classification_infractions_page_loi_penal.dart",
                  "f00188",
                  "La loi nouvelle s’applique si le dernier acte constitutif de l’infraction d’habitude a été accompli sous l’empire de cette loi.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),
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
  final String title = 'NOTA';

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
