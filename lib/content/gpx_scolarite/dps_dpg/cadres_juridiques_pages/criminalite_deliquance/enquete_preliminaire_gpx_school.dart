import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EnquetePreliminaireGpxSchool extends StatelessWidget {
  const EnquetePreliminaireGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/criminalite_organisee/enquete_preliminaire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF111218)
        : const Color(0xFFFDFDFE);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
            "f00001",
            'Enquête préliminaire – criminalité organisée',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w700,
            fontSize: 16.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                  "f00002",
                  '2.2 – L’enquête préliminaire relative à la criminalité organisée',
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00003",
                      'L’enquête préliminaire en matière de criminalité et de délinquance ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00004",
                      'organisées obéit à des règles de durée et de procédure spécifiques, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00005",
                      'plus strictes que le droit commun, en raison de la gravité des faits ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00006",
                      'et des moyens d’investigation mis en œuvre.',
                    ),
              ),

              const SizedBox(height: 20),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                  "f00007",
                  '2.2.1 – La durée de l’enquête',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00008",
                          'Lorsque l’enquête porte sur des infractions relevant de la criminalité ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00009",
                          'et de la délinquance organisées, sa durée ne peut excéder trois ans à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00010",
                          'compter du premier acte d’audition libre, de garde à vue ou de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00011",
                          'perquisition d’une personne, y compris si cet acte est intervenu dans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00012",
                          'le cadre d’une enquête de flagrance.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00013",
                          'Ce délai peut être renouvelé une fois pour deux ans, sur autorisation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00014",
                          'écrite et motivée du procureur de la République.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00015",
                          'Tout acte d’enquête concernant la personne ayant fait l’objet d’une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00016",
                          'audition libre, d’une garde à vue ou d’une perquisition, intervenant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00017",
                          'après l’expiration de ces délais, est nul.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00018",
                            'Le choix de la qualification pénale est donc déterminant pour le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00019",
                            'délai butoir de l’enquête. Il convient d’y apporter une attention ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00020",
                            'particulière pour chaque mis en cause dès le début de l’enquête. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00021",
                            'Ce choix appartient au procureur de la République, qui doit ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00022",
                            'vérifier que les infractions entrent dans le champ d’application ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00023",
                            'des articles 706-73 et 706-73-1 du Code de procédure pénale.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                  "f00024",
                  '2.2.2 – Dispositions communes',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00025",
                          'Dans le domaine de la criminalité organisée, un certain nombre ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00026",
                          'd’instruments procéduraux spécifiques sont communs à l’enquête de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00027",
                          'flagrance et à l’enquête préliminaire.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00028",
                      'Il en est ainsi, notamment, des dispositions relatives :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00029",
                      'à la surveillance ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00030",
                      'aux opérations d’infiltration ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00031",
                      'à la garde à vue ;',
                    ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00032",
                          'aux perquisitions en matière de trafic de stupéfiants et de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00033",
                          'proxénétisme ;',
                        ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00034",
                      'aux modalités de mise en œuvre des interceptions de correspondances.',
                    ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00035",
                            'Les perquisitions en matière de trafic de stupéfiants reposent sur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00036",
                            'l’article 706-28 du Code de procédure pénale et celles en matière ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00037",
                            'de proxénétisme sur l’article 706-35 du Code de procédure pénale.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00038",
                            'Conformément à l’article 706-95-11 du Code de procédure pénale, un ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00039",
                            'cadre commun a été créé pour trois techniques d’enquête : ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00040",
                            'l’IMSI-catcher, la sonorisation et la fixation d’images, ainsi que ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00041",
                            'la captation de données informatiques. Ces dispositions sont ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00042",
                            'applicables lors de l’enquête de flagrance, de l’enquête ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00043",
                            'préliminaire ou de l’information judiciaire pour les infractions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00044",
                            'mentionnées aux articles 706-73 et 706-73-1 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00045",
                            'pénale.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                  "f00046",
                  '2.2.3 – Les perquisitions',
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00047",
                      'En matière d’enquête préliminaire, les perquisitions obéissent à des règles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00048",
                      'dérogatoires lorsque les faits relèvent de la criminalité organisée.',
                    ),
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                  "f00049",
                  '2.2.3.1 – Les perquisitions de nuit en dehors des locaux d’habitation',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00050",
                            'L’article 706-90, alinéa 1, du Code de procédure pénale dispose : ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00051",
                            '« Si les nécessités de l’enquête préliminaire relative à l’une des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00052",
                            'infractions entrant dans le champ d’application des articles ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00053",
                            '706-73 et 706-73-1 l’exigent, le juge des libertés et de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00054",
                            'détention du tribunal judiciaire peut, à la requête du procureur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00055",
                            'de la République, décider que les perquisitions, visites ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00056",
                            'domiciliaires et saisies de pièces à conviction pourront être ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00057",
                            'effectuées en dehors des heures prévues à l’article 59, lorsque ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00058",
                            'ces opérations ne concernent pas des locaux d’habitation. »',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00059",
                          'Le régime dérogatoire est uniquement applicable aux infractions ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00060",
                          'entrant dans le champ d’application des articles 706-73 et 706-73-1 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00061",
                          'du Code de procédure pénale, si les nécessités de l’enquête ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00062",
                          'l’exigent.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00063",
                            'L’article 706-90 du Code de procédure pénale permet donc de procéder à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00064",
                            'des perquisitions de nuit lorsqu’elles ne concernent pas des locaux ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00065",
                            'd’habitation. Des dispositions spécifiques sont prévues en matière ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00066",
                            'de terrorisme.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00067",
                            'L’officier de police judiciaire ne peut procéder à une perquisition ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00068",
                            'de nuit sans qu’une ordonnance préalable du juge des libertés et de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00069",
                            'la détention ne l’y autorise expressément. Cette ordonnance est mise ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00070",
                            'en œuvre selon les modalités de l’article 706-92 du Code de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00071",
                            'procédure pénale, décrites dans la procédure de flagrant délit.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00072",
                            'L’article 706-93 du Code de procédure pénale précise que les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00073",
                            'perquisitions menées en dehors des heures légales, conformément à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00074",
                            'l’article 706-90 du Code de procédure pénale, ne peuvent avoir ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00075",
                            'd’autre objet que la recherche et la constatation des infractions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00076",
                            'visées dans la décision du juge des libertés et de la détention. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00077",
                            'Le fait que les perquisitions révèlent des infractions autres que ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00078",
                            'celles visées dans cette décision ne constitue pas une cause de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00079",
                            'nullité des procédures incidentes.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                  "f00080",
                  '2.2.3.2 – Les perquisitions sans l’assentiment de la personne',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00081",
                            'L’article 76, alinéa 4, du Code de procédure pénale dispose que les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00082",
                            'perquisitions et saisies de pièces à conviction peuvent être ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00083",
                            'effectuées sans l’assentiment de la personne chez qui elles ont ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00084",
                            'lieu si les nécessités de l’enquête, relative à un crime ou à un ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00085",
                            'délit puni d’une peine d’emprisonnement d’une durée égale ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00086",
                            'supérieure à trois ans, l’exigent.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00087",
                            'En matière de criminalité organisée, l’application combinée des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00088",
                            'articles 76, alinéa 4, et 706-90 du Code de procédure pénale permet ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00089",
                            'à l’officier de police judiciaire de procéder à des perquisitions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00090",
                            'sans l’assentiment de la personne concernée, y compris de nuit, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00091",
                            'pour l’une des infractions entrant dans le champ des articles ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00092",
                            '706-73 et 706-73-1, dès lors qu’il ne s’agit pas de locaux ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00093",
                            'd’habitation. Ces opérations sont autorisées par décision écrite et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00094",
                            'motivée du juge des libertés et de la détention, à la requête du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00095",
                            'procureur de la République.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                  "f00096",
                  '2.2.3.3 – Les perquisitions en l’absence de la personne gardée à vue ou détenue',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00097",
                            'Les dispositions de l’article 706-94, alinéa 2, du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00098",
                            'pénale permettent à l’officier de police judiciaire, dans le cadre ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00099",
                            'de l’une des infractions visées aux articles 706-73 et 706-73-1 du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00100",
                            'Code de procédure pénale, de perquisitionner au domicile d’une ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00101",
                            'personne gardée à vue ou détenue, en dehors de sa présence, lorsque ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00102",
                            'la perquisition est réalisée sans l’assentiment de la personne dans ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00103",
                            'les conditions prévues aux articles 76 et 706-90 du Code de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                            "f00104",
                            'procédure pénale.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                      "f00105",
                      'Cette perquisition doit respecter les éléments suivants :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00106",
                          'le transport sur place de l’intéressé doit être évité en raison de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00107",
                          'risques graves (troubles à l’ordre public, risque d’évasion, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00108",
                          'disparition possible des preuves pendant le temps nécessaire au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00109",
                          'transport) ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00110",
                          'l’officier de police judiciaire doit bénéficier de l’accord préalable ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00111",
                          'du juge des libertés et de la détention, l’autorisation écrite du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00112",
                          'magistrat étant jointe à la procédure ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00113",
                          'le respect des droits de la défense doit être assuré par la présence, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00114",
                          'lors des opérations de perquisition, soit de deux témoins requis par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00115",
                          'l’officier de police judiciaire dans les conditions de l’article 57 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00116",
                          'du Code de procédure pénale, soit d’un représentant désigné par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00117",
                          'celui dont le domicile est en cause.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                              "f00118",
                              'Les régimes spécifiques de perquisitions en matière de trafic de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                              "f00119",
                              'stupéfiants et de proxénétisme (article 706-35 du Code de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                              "f00120",
                              'procédure pénale) s’appliquent de la même façon qu’en flagrant ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                              "f00121",
                              'délit.',
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 26),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00122",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours vérifier ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00123",
                          'la qualification exacte des faits et la base légale (articles 706-73 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00124",
                          'et suivants du Code de procédure pénale) avant de déterminer le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/enquete_preliminaire_gpx_school.dart",
                          "f00125",
                          'régime applicable à l’enquête préliminaire.',
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
