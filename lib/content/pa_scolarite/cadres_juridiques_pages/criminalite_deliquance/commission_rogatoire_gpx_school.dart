import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaCommissionRogatoireGpxSchool extends StatelessWidget {
  const PaCommissionRogatoireGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/commission_rogatoire';

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
        centerTitle: true,
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
            "f00001",
            'Commission rogatoire – criminalité organisée',
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                  "f00002",
                  '2.3 – La procédure de commission rogatoire relative à la criminalité organisée',
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00003",
                      'Un certain nombre de dispositions procédurales relatives à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00004",
                      'criminalité et à la délinquance organisées sont communes à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00005",
                      'l’enquête de flagrance et à l’exécution d’une commission rogatoire.',
                    ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00006",
                      'La différence principale tient à l’autorité judiciaire compétente : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00007",
                      'dans le cadre d’une commission rogatoire, l’autorité délégante est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00008",
                      'le juge d’instruction, qui se substitue au procureur de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00009",
                      'République ou au juge des libertés et de la détention.',
                    ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00010",
                      'Des spécificités demeurent toutefois propres à l’information ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00011",
                      'judiciaire, notamment en matière d’infiltration, de perquisitions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00012",
                      'et de techniques spéciales d’enquête.',
                    ),
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                  "f00013",
                  '2.3.1 – L’infiltration',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00014",
                          'Les opérations d’infiltration peuvent également être mises en œuvre ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00015",
                          'dans le cadre d’une information judiciaire ouverte pour des faits ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00016",
                          'relevant de la criminalité organisée.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00017",
                            'En matière d’infiltration, l’autorisation préalable du juge ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00018",
                            'd’instruction aux opérations d’infiltration est soumise pour avis ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00019",
                            '(non suspensif) au procureur de la République (Article 706-81 du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00020",
                            'Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                  "f00021",
                  '2.3.2 – Les perquisitions',
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00022",
                      'Sous commission rogatoire, les perquisitions obéissent à un régime ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00023",
                      'proche de celui de la flagrance, mais adapté à l’information ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00024",
                      'judiciaire et placé sous le contrôle du juge d’instruction.',
                    ),
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                  "f00025",
                  '2.3.2.1 – La perquisition de nuit',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00026",
                      '2.3.2.1.1 – Le principe',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00027",
                            'L’Article 706-91 du Code de procédure pénale dispose : « Si les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00028",
                            'nécessités de l’information relative à l’une des infractions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00029",
                            'entrant dans le champ d’application des articles 706-73 et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00030",
                            '706-73-1 l’exigent, le juge d’instruction peut autoriser les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00031",
                            'officiers de police judiciaire agissant sur commission rogatoire ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00032",
                            'à procéder à des perquisitions, visites domiciliaires et saisies ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00033",
                            'de pièces à conviction en dehors des heures prévues à l’article ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00034",
                            '59, lorsque ces opérations ne concernent pas des locaux ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00035",
                            'd’habitation. En cas d’urgence, le juge d’instruction peut ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00036",
                            'également autoriser les officiers de police judiciaire à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00037",
                            'procéder à ces opérations dans les locaux d’habitation : 1°) ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00038",
                            'lorsqu’il s’agit d’un crime ou d’un délit flagrant ; 2°) lorsqu’il ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00039",
                            'existe un risque immédiat de disparition des preuves ou des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00040",
                            'indices matériels ; 3°) lorsqu’il existe une ou plusieurs raisons ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00041",
                            'plausibles de soupçonner qu’une ou plusieurs personnes se ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00042",
                            'trouvant dans les locaux où la perquisition doit avoir lieu sont ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00043",
                            'en train de commettre des crimes ou des délits entrant dans le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00044",
                            'champ d’application des articles 706-73 et 706-73-1 ; 4°) lorsque ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00045",
                            'leur réalisation, dans le cadre d’une information relative à une ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00046",
                            'ou plusieurs infractions mentionnées au 11° de l’article 706-73, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00047",
                            'est nécessaire afin de prévenir un risque d’atteinte à la vie ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00048",
                            'à l’intégrité physique. »',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00049",
                          'Les officiers de police judiciaire peuvent donc procéder à des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00050",
                          'perquisitions de nuit, en dehors des locaux d’habitation, avec ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00051",
                          'l’autorisation préalable du juge d’instruction.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00052",
                          'En cas d’urgence, avec l’autorisation du juge d’instruction, les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00053",
                          'officiers de police judiciaire peuvent également perquisitionner de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00054",
                          'nuit dans les locaux d’habitation.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00055",
                          'Les perquisitions de nuit prévues par l’Article 706-91 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00056",
                          'procédure pénale ne peuvent intervenir que dans les cas limitativement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00057",
                          'énumérés suivants :',
                        ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00058",
                      'lorsqu’il s’agit d’un crime ou d’un délit flagrant ;',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00059",
                          'lorsqu’il existe un risque immédiat de disparition de preuves ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00060",
                          'd’indices matériels ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00061",
                          'lorsqu’il existe une ou plusieurs raisons plausibles de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00062",
                          'soupçonner qu’une ou plusieurs personnes présentes dans les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00063",
                          'locaux sont en train de commettre des crimes ou délits relevant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00064",
                          'des articles 706-73 et 706-73-1 du Code de procédure pénale ;',
                        ),
                  ),
                  SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00065",
                              'Exemple : risque immédiat de disparition de preuves ou de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00066",
                              'documents si les auteurs présumés ont été alertés de la ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00067",
                              'localisation des enquêteurs et peuvent profiter de la nuit pour ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00068",
                              'détruire les éléments matériels de l’infraction.',
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00069",
                      '2.3.2.1.2 – Les conditions de mise en œuvre',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00070",
                          'L’officier de police judiciaire ne peut réaliser une perquisition hors ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00071",
                          'des heures légales sans autorisation préalable du juge d’instruction. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00072",
                          'Cette autorisation prend la forme d’une ordonnance écrite et motivée.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00073",
                            'Comme en enquête de flagrance, l’Article 706-92 du Code de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00074",
                            'procédure pénale précise les modalités de mise en œuvre de cette ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00075",
                            'ordonnance (références aux mentions obligatoires, contrôle du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00076",
                            'magistrat, etc.).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00077",
                      '2.3.2.1.3 – Les limites',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00078",
                            'L’Article 706-93 du Code de procédure pénale précise que les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00079",
                            'perquisitions prévues par l’Article 706-91 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00080",
                            'pénale ne peuvent avoir d’autre objet que la recherche et la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00081",
                            'constatation des infractions visées dans la décision du juge ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00082",
                            'd’instruction. Le fait que les perquisitions révèlent des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00083",
                            'infractions autres que celles visées dans cette décision ne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00084",
                            'constitue pas une cause de nullité des procédures incidentes.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 20),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                  "f00085",
                  '2.3.2.2 – Les perquisitions en l’absence de la personne gardée à vue ou détenue',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00086",
                          'Sous commission rogatoire, l’officier de police judiciaire peut, dans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00087",
                          'certains cas, perquisitionner au domicile d’une personne gardée à vue ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00088",
                          'ou détenue en l’absence de cette dernière.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00089",
                            'L’officier de police judiciaire a la possibilité de perquisitionner ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00090",
                            'au domicile d’une personne gardée à vue ou détenue, en dehors de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00091",
                            'sa présence, dans les conditions prévues par l’Article 706-94, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00092",
                            'alinéa 1, du Code de procédure pénale et selon les mêmes modalités ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00093",
                            'que dans le cadre de l’enquête de flagrance.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00094",
                              'Les régimes spécifiques de perquisitions en matière de trafic de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00095",
                              'stupéfiants (Article 706-28 du Code de procédure pénale) et de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00096",
                              'proxénétisme (Article 706-35 du Code de procédure pénale) ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00097",
                              's’appliquent aussi au stade de l’instruction. Ils sont détaillés ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00098",
                              'dans la partie relative à l’enquête de flagrance en matière de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                              "f00099",
                              'criminalité organisée.',
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                  "f00100",
                  '2.3.3 – Les techniques spéciales d’enquête',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00101",
                          'Les trois techniques spéciales d’enquête prévues par la section ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00102",
                          'spéciale du Code de procédure pénale sont également utilisables dans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00103",
                          'le cadre de l’information judiciaire :',
                        ),
                  ),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00104",
                      'recours à un dispositif de type IMSI-catcher ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00105",
                      'sonorisation et fixation d’images ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                      "f00106",
                      'captation de données informatiques.',
                    ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00107",
                            'Ces techniques d’enquête, prévues aux articles 706-95-11 à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00108",
                            '706-102-5 du Code de procédure pénale, peuvent être mises en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00109",
                            'œuvre si les nécessités de l’information judiciaire relative à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00110",
                            'l’une des infractions entrant dans le champ d’application des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00111",
                            'articles 706-73 et 706-73-1 l’exigent.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00112",
                          'Elles sont autorisées par le juge d’instruction, après avis du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00113",
                          'procureur de la République.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00114",
                            'En cas d’urgence résultant d’un risque imminent de dépérissement ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00115",
                            'des preuves ou d’atteinte grave aux personnes ou aux biens, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00116",
                            'l’autorisation du juge d’instruction peut être délivrée sans avis ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00117",
                            'préalable du procureur de la République (Article 706-95-13 du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00118",
                            'Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00119",
                            'Cette autorisation est délivrée pour une durée de quatre mois, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00120",
                            'renouvelable dans les mêmes conditions de forme et de durée, sans ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00121",
                            'que la durée totale des opérations ne puisse excéder deux ans ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                            "f00122",
                            '(Article 706-95-16 du Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 26),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00123",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours vérifier ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00124",
                          'la base légale exacte (articles 706-73 et suivants du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00125",
                          'procédure pénale) avant de mettre en œuvre une commission rogatoire ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/commission_rogatoire_gpx_school.dart",
                          "f00126",
                          'en matière de criminalité organisée.',
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
