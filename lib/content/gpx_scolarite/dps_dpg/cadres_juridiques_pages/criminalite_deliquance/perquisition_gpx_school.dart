import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PerquisitionGpxSchool extends StatelessWidget {
  const PerquisitionGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/criminalite_organisee/perquisitions';

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
            "f00001",
            'Perquisitions – criminalité organisée',
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 17),
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
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00002",
                  '2.1.5 - Les perquisitions',
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00003",
                      'Dans le cadre de la criminalité et de la délinquance organisées, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00004",
                      'les perquisitions font l’objet de régimes dérogatoires précis, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00005",
                      'notamment pour les perquisitions de nuit, le trafic de stupéfiants, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00006",
                      'le proxénétisme et les perquisitions au domicile d’une personne gardée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00007",
                      'à vue ou détenue.',
                    ),
              ),

              const SizedBox(height: 20),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00008",
                  '2.1.5.1 - La perquisition de nuit dans les locaux d’habitation',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00009",
                  '2.1.5.1.1 - Le principe',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                        "f00010",
                        'L’article 706-89 du Code de procédure pénale dispose : ',
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00011",
                            '« Si les nécessités de l’enquête de flagrance relative à l’une des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00012",
                            'infractions entrant dans le champ d’application des articles ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00013",
                            '706-73 et 706-73-1 du Code de procédure pénale l’exigent, le juge des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00014",
                            'libertés et de la détention du tribunal judiciaire peut, à la requête ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00015",
                            'du procureur de la République, autoriser que les perquisitions, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00016",
                            'visites domiciliaires et saisies de pièces à conviction soient ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00017",
                            'opérées en dehors des heures prévues à l’article 59. »',
                          ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00018",
                          'Le régime dérogatoire est uniquement applicable aux infractions entrant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00019",
                          'dans le champ des articles 706-73 et 706-73-1 du Code de procédure pénale, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00020",
                          'lorsque les nécessités de l’enquête l’exigent.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00021",
                  '2.1.5.1.2 - Les conditions de mise en œuvre',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00022",
                            'L’article 706-92 du Code de procédure pénale précise les modalités qui ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00023",
                            'doivent être respectées, à peine de nullité :',
                          ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00024",
                          'La perquisition doit être déterminée : l’autorisation à perquisitionner ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00025",
                          'ne doit pas être de portée générale. L’ordonnance doit être précise, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00026",
                          'notamment sur le lieu et le moment de l’intervention.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00027",
                          'La perquisition doit faire l’objet d’une autorisation écrite du juge des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00028",
                          'libertés et de la détention, à la requête du procureur de la République. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00029",
                          'Cette autorisation prend la forme d’une ordonnance :',
                        ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00030",
                      'précisant la qualification de l’infraction dont la preuve est recherchée ;',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00031",
                          'précisant l’adresse des lieux concernés par les visites, perquisitions ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00032",
                          'et saisies ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00033",
                          'motivée au regard des éléments de droit et de fait justifiant que la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00034",
                          'perquisition est nécessaire et qu’elle ne peut être réalisée pendant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00035",
                          'les heures légales (risque de déperdition des preuves, urgence, etc.).',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00036",
                          'L’autorisation est sollicitée par le procureur de la République qui dirige ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00037",
                          'l’enquête auprès du juge des libertés et de la détention compétent sur le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00038",
                          'même tribunal judiciaire, quelle que soit la juridiction dans le ressort ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00039",
                          'de laquelle la perquisition doit avoir lieu. Le procureur de la République ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00040",
                          'peut également saisir le juge des libertés et de la détention du tribunal ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00041",
                          'judiciaire dans le ressort duquel la perquisition doit se dérouler, par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00042",
                          'l’intermédiaire du procureur de la République de cette juridiction.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00043",
                          'Les opérations sont réalisées sous le contrôle du magistrat qui les a ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00044",
                          'autorisées. Pour veiller au respect des dispositions légales, ce magistrat ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00045",
                          'peut se déplacer sur les lieux, quelle que soit leur localisation sur ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00046",
                          'l’ensemble du territoire national.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00047",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00048",
                  '2.1.5.1.3 - L’objet de la perquisition en matière de criminalité organisée',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00049",
                            'L’article 706-93 du Code de procédure pénale précise que les perquisitions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00050",
                            'prévues par les articles 706-89 à 706-91 du Code de procédure pénale ne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00051",
                            'peuvent avoir pour objet que la recherche et la constatation des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00052",
                            'infractions visées dans la décision du juge des libertés et de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00053",
                            'détention ou du juge d’instruction.',
                          ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00054",
                          'Le fait que les perquisitions révèlent des infractions autres que celles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00055",
                          'visées dans la décision du juge des libertés et de la détention (ou du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00056",
                          'juge d’instruction en commission rogatoire) ne constitue pas, en soi, une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00057",
                          'cause de nullité des procédures incidentes.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00058",
                  '2.1.5.2 - Le maintien de deux régimes spécifiques',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00059",
                  '2.1.5.2.1 - Perquisitions en matière de trafic de stupéfiants',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                        "f00060",
                        'L’article 706-28 du Code de procédure pénale dispose : ',
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00061",
                            '« Pour la recherche et la constatation des infractions visées à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00062",
                            'l’article 706-26, les visites, perquisitions et saisies prévues par ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00063",
                            'l’article 59 peuvent être opérées en dehors des heures prévues par ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00064",
                            'cet article à l’intérieur des locaux où l’on use en société de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00065",
                            'stupéfiants ou dans lesquels sont fabriqués, transformés ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00066",
                            'entreposés illicitement des stupéfiants, lorsqu’il ne s’agit pas de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00067",
                            'locaux d’habitation. Les actes prévus au présent article ne peuvent, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00068",
                            'à peine de nullité, avoir un autre objet que la recherche et la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00069",
                            'constatation des infractions visées à l’article 706-26. »',
                          ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00070",
                          'La possibilité pour l’officier de police judiciaire de s’affranchir du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00071",
                          'respect des heures légales tient à la nature des locaux dans lesquels les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00072",
                          'visites, perquisitions ou saisies peuvent être opérées. Il s’agit soit de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00073",
                          'locaux « où l’on use en société de stupéfiants », soit de locaux servant à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00074",
                          'la fabrication, la transformation ou l’entrepôt illicite de stupéfiants.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00075",
                          'L’officier de police judiciaire n’a pas à solliciter l’autorisation écrite ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00076",
                          'du juge des libertés et de la détention, à la demande du procureur de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00077",
                          'République (ou du juge d’instruction en commission rogatoire).',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00078",
                          'Cependant, l’article 706-28 du Code de procédure pénale exclut la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00079",
                          'réalisation de perquisitions de ce type dans une maison d’habitation ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00080",
                          'un appartement. Si l’officier de police judiciaire doit intervenir dans des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00081",
                          'locaux d’habitation en dehors des heures légales, il doit recourir aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00082",
                          'dispositions générales de l’article 706-89 du Code de procédure pénale.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00083",
                            'Le recours à l’article 706-28 du Code de procédure pénale est ouvert pour la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00084",
                            'recherche et la constatation des infractions visées aux articles ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00085",
                            '222-34 à 222-40 du code pénal, ainsi que du délit de participation à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00086",
                            'une association de malfaiteurs prévu par l’article 450-1 du code pénal ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00087",
                            'lorsqu’il a pour objet de préparer l’une des infractions des articles ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00088",
                            '222-34 à 222-40 du code pénal.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00089",
                            'Tout procès-verbal de visite, perquisition et saisies effectués en application ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00090",
                            'de l’article 706-28 du Code de procédure pénale pour la recherche ou la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00091",
                            'constatation d’infractions autres que celles visées est frappé de nullité.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00092",
                  '2.1.5.2.2 - Perquisitions en matière de proxénétisme (article 706-35 du Code de procédure pénale)',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                        "f00093",
                        'L’article 706-35 du Code de procédure pénale dispose : ',
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00094",
                            '« Pour la recherche et la constatation des infractions visées à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00095",
                            'l’article 706-34, les visites, perquisitions et saisies prévues par ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00096",
                            'l’article 59 peuvent être opérées à toute heure du jour et de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00097",
                            'nuit, à l’intérieur de tout hôtel, maison meublée, pension, débit de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00098",
                            'boissons, club, cercle, dancing, lieu de spectacle et leurs annexes ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00099",
                            'et en tout autre lieu ouvert au public ou utilisé par le public ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00100",
                            'lorsqu’il est constaté que des personnes se livrant à la prostitution ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00101",
                            'y sont reçues habituellement. Les actes prévus au présent article ne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00102",
                            'peuvent, à peine de nullité, être effectués pour un autre objet que ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00103",
                            'la recherche et la constatation des infractions visées à l’article ',
                          ) +
                          '706-34. »',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00104",
                      'Deux conditions de fond doivent être cumulativement remplies :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00105",
                          'il doit s’agir, d’abord, de certains lieux publics, mixtes ou privés ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00106",
                          'limitativement désignés, et plus généralement de tout autre lieu ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00107",
                          'ouvert au public ou utilisé par le public ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00108",
                          'il importe, par ailleurs, qu’il soit constaté la réception habituelle ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00109",
                          'en ces lieux de personnes se livrant à la prostitution.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00110",
                            'Le recours à l’article 706-35 du Code de procédure pénale est ouvert, à peine ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00111",
                            'de nullité, exclusivement pour la recherche et la constatation des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00112",
                            'infractions visées aux articles 225-5 à 225-12-4 du code pénal, ainsi ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00113",
                            'que du délit de participation à une association de malfaiteurs prévu ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00114",
                            'par l’article 450-1 du code pénal lorsqu’il a pour objet de préparer ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00115",
                            'l’une de ces infractions.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                              "f00116",
                              'Seuls les crimes et délits de proxénétisme aggravé prévus par les ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                              "f00117",
                              'articles 225-7 à 225-12 du code pénal relèvent de la criminalité ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                              "f00118",
                              'organisée. Le champ d’application de l’article 706-35 du Code de ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                              "f00119",
                              'procédure pénale est donc plus large que celui de la criminalité ',
                            ) +
                            ScolariteText.value(
                              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                              "f00120",
                              'organisée stricto sensu.',
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00121",
                  '2.1.5.3 - La perquisition au domicile d’une personne gardée à vue ou détenue',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                  "f00122",
                  'Perquisition au domicile d’une personne gardée à vue ou détenue',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00123",
                            'Les dispositions de l’article 706-94 du Code de procédure pénale permettent à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00124",
                            'l’officier de police judiciaire, dans le cadre de l’une des infractions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00125",
                            'prévues aux articles 706-73 et 706-73-1 du Code de procédure pénale, de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00126",
                            'perquisitionner au domicile d’une personne gardée à vue ou détenue, en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                            "f00127",
                            'dehors de sa présence, dans les conditions suivantes :',
                          ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00128",
                          'Le transport sur place de l’intéressé doit être évité en raison de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00129",
                          'risques graves :',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00130",
                      'troubles à l’ordre public ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00131",
                      'risque d’évasion ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00132",
                      'risque de disparition des preuves pendant le temps nécessaire au transport.',
                    ),
                  ),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00133",
                          'L’officier de police judiciaire doit recueillir l’accord préalable du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00134",
                          'procureur de la République (ou du juge d’instruction en commission ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00135",
                          'rogatoire). L’autorisation écrite du magistrat doit être jointe à la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00136",
                          'procédure.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00137",
                          'Le respect des droits de la défense doit être assuré par la présence, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00138",
                          'lors des opérations de perquisition :',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00139",
                          'soit de deux témoins requis par l’officier de police judiciaire dans les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00140",
                          'conditions de l’article 57 du Code de procédure pénale ;',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                      "f00141",
                      'soit d’un représentant désigné par la personne dont le domicile est en cause.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00142",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00143",
                          'Veiller à vérifier régulièrement les éventuelles réformes du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00144",
                          'procédure pénale ou du code pénal impactant ces régimes de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/perquisition_gpx_school.dart",
                          "f00145",
                          'perquisition.',
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
