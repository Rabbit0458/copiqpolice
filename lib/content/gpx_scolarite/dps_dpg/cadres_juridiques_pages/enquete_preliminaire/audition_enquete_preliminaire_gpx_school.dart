import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AuditionEnquetePreliminaireGpxSchool extends StatelessWidget {
  const AuditionEnquetePreliminaireGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/enquete_preliminaire/actes/auditions';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBlue = isDark
        ? const Color(0xFF0D47A1).withValues(alpha: .22)
        : const Color(0xFFE3F2FD);
    final Color accentBlue = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);
    final Color titleBlue = isDark
        ? const Color(0xFFBBDEFB)
        : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
            "f00001",
            'Les auditions',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00002",
                  '2.3.7 - Les auditions',
                ),
                style: GoogleFonts.fustat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.1 - L’audition du témoin
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00003",
                  '2.3.7.1 - L’audition du témoin',
                ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00004",
                          'L’article 78 alinéa 1 du Code de procédure pénale pose le principe selon ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00005",
                          'lequel les personnes convoquées par un officier de police judiciaire pour ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00006",
                          'les nécessités de l’enquête sont tenues de comparaître. « L’officier de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00007",
                          'police judiciaire peut contraindre à comparaître par la force publique, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00008",
                          'avec l’autorisation préalable du procureur de la République, les personnes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00009",
                          'qui n’ont pas répondu à une convocation à comparaître ou dont on peut ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00010",
                          'craindre qu’elles ne répondent pas à une telle convocation ».',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00011",
                          'Ces dispositions de l’article 78 alinéa 1 du Code de procédure pénale ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00012",
                          'peuvent s’appliquer, quelle que soit l’infraction (crime, délit, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00013",
                          'contravention) aux personnes à l’encontre desquelles il existe une ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00014",
                          'plusieurs raisons plausibles de soupçonner qu’elles ont commis ou tenté ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00015",
                          'de commettre une infraction, mais également aux simples témoins.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00016",
                          'Le procureur de la République peut également autoriser la comparution par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00017",
                          'la force publique sans convocation préalable en cas de risque de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00018",
                          'modification des preuves ou indices matériels, de pressions sur les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00019",
                          'témoins ou les victimes ainsi que sur leur famille ou leurs proches, ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00020",
                          'de concertation entre les coauteurs ou complices de l’infraction.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00021",
                  'Arrêt de la Cour de cassation et limites à la contrainte au domicile',
                ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                            "f00022",
                            'Dans son arrêt n° 16-82.412 du 22 février 2017, la Cour de cassation ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                            "f00023",
                            'a affirmé que la pénétration de force dans un domicile pour exécuter ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                            "f00024",
                            'un ordre de comparution était exclue. ',
                          ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                            "f00025",
                            'Cette limitation vise le domicile de la personne nommément visée dans ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                            "f00026",
                            'l’ordre de comparution forcée mais également celui d’un tiers, et ce ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                            "f00027",
                            'quel que soit le moyen employé (recours à un serrurier ou utilisation ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                            "f00028",
                            'd’un bélier).',
                          ),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00029",
                          'Ces dispositions concernent les personnes mises en cause ainsi que les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00030",
                          'témoins dans le cadre de l’enquête de flagrance sur le fondement de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00031",
                          'l’article 61 du Code de procédure pénale.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00032",
                  'Pénétration au domicile : cas autorisés',
                ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00033",
                          'La pénétration dans le domicile d’une personne est toutefois autorisée en ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00034",
                          'matière :',
                        ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00035",
                      'd’exécution d’une peine d’emprisonnement ou de réclusion (article 716-5 du Code de procédure pénale) ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00036",
                      'd’exécution d’un mandat d’amener, d’arrêt ou de recherche ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00037",
                      'de demande d’extradition ou d’un mandat d’arrêt européen (article 134 du Code de procédure pénale).',
                    ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00038",
                          'L’article 78 du Code de procédure pénale permet seulement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00039",
                          'l’appréhension forcée sur la voie publique de la personne convoquée. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00040",
                          'Cette décision limite de façon explicite les pouvoirs contraignants des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00041",
                          'agents de la force publique dans le cadre de l’article 78 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00042",
                          'procédure pénale.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00043",
                  'Mandat de recherche et perquisition / visite domiciliaire sans assentiment',
                ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00044",
                          'Si la pénétration dans un domicile s’avère nécessaire à l’appréhension de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00045",
                          'la personne convoquée, le procureur de la République dispose de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00046",
                          'possibilité de délivrer un mandat de recherche (article 77-4 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00047",
                          'procédure pénale), à la condition préalable que la personne recherchée ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00048",
                          'soit soupçonnée d’avoir commis ou tenté de commettre un crime ou un délit ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00049",
                          'puni d’au moins trois ans d’emprisonnement. L’agent chargé de l’exécution ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00050",
                          'du mandat est autorisé à s’introduire dans le domicile entre 6 heures et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00051",
                          '21 heures.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00052",
                          'Conjointement à la réquisition délivrée par le magistrat du parquet ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00053",
                          'conformément à l’article 78 du Code de procédure pénale, une autorisation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00054",
                          'du juge des libertés et de la détention aux fins de perquisition ou de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00055",
                          'visite domiciliaire sans assentiment peut être sollicitée pour les crimes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00056",
                          'ou les délits punis d’une peine égale ou supérieure à 3 ans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00057",
                          'd’emprisonnement (article 76 du Code de procédure pénale).',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00058",
                          'Cette perquisition ne peut être autorisée par le juge des libertés et de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00059",
                          'la détention qu’aux fins de recueil de preuves ou de saisie de biens dont ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00060",
                          'la confiscation est prévue par l’article 131-21 du Code pénal. La preuve ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00061",
                          'recherchée peut toutefois résider dans la nécessité de procéder à une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00062",
                          'audition.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00063",
                          'En dehors de ces cas, l’entrée dans les lieux pour contraindre à comparaître ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00064",
                          'une personne n’est plus possible dans le cadre de l’article 78 du Code pénal.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00065",
                  'Durée de la retenue et principe de l’audition libre',
                ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00066",
                          'Les personnes à l’encontre desquelles il n’existe aucune raison plausible ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00067",
                          'de soupçonner qu’elles ont commis ou tenté de commettre une infraction ne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00068",
                          'peuvent être retenues que le temps strictement nécessaire à leur audition, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00069",
                          'sans que cette durée ne puisse excéder quatre heures.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00070",
                          'Plusieurs auditions d’une même personne, chacune d’une durée maximale de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00071",
                          'quatre heures, peuvent être réalisées si les nécessités de l’enquête ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00072",
                          'l’exigent et si la personne a quitté librement les locaux de police au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00073",
                          'terme de son audition. Une convocation pour une audition ultérieure doit ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00074",
                          'lui avoir été remise.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00075",
                          'Aucune sanction ne s’attache au fait, pour la personne retenue, de refuser ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00076",
                          'de déposer ; dans une telle hypothèse, il convient de faire mention de ce ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00077",
                          'refus dans la procédure et de ne pas retenir plus longtemps la personne, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00078",
                          'si aucune mesure de garde à vue n’est envisagée à son encontre.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00079",
                          'Conformément au principe général posé par l’article 75 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00080",
                          'procédure pénale, les agents de police judiciaire désignés à l’article 20 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00081",
                          'du Code de procédure pénale peuvent, sous le contrôle d’un officier de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00082",
                          'police judiciaire, procéder à l’audition des personnes convoquées.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00083",
                          'Le dernier alinéa de l’article 78 du Code de procédure pénale renvoie aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00084",
                          'articles 61 et 62-1 du Code de procédure pénale pour l’établissement des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00085",
                          'procès-verbaux.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00086",
                          'Les témoins pourront, sur autorisation du procureur de la République, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00087",
                          'déclarer comme domicile l’adresse du commissariat ou de la brigade de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00088",
                          'gendarmerie (article 706-57 du Code de procédure pénale). L’adresse ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00089",
                          'réelle de ces personnes est inscrite sur un registre ouvert à cet effet et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00090",
                          'tenu sous format papier ou numérique.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00091",
                          'Si la personne a été convoquée en raison de sa profession, l’adresse ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00092",
                          'déclarée peut être son adresse professionnelle. L’autorisation du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00093",
                          'procureur de la République n’est pas nécessaire lorsque le témoignage est ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00094",
                          'apporté par une personne dépositaire de l’autorité publique ou chargée ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00095",
                          'd’une mission de service public pour des faits qu’elle a connus en raison ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00096",
                          'de ses fonctions ou de sa mission et que l’adresse déclarée est son ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00097",
                          'adresse professionnelle.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00098",
                          'Les procès-verbaux d’audition doivent comporter les questions auxquelles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00099",
                          'il est répondu (article 429 du Code de procédure pénale).',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.2 - L’audition du témoin qui devient suspect
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00100",
                  '2.3.7.2 - L’audition du témoin qui devient suspect',
                ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00101",
                          'Au cours de l’audition, si l’enquêteur découvre des raisons plausibles de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00102",
                          'soupçonner que la personne entendue a commis ou tenté de commettre un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00103",
                          'crime ou un délit puni d’une peine d’emprisonnement, le statut de témoin ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00104",
                          'disparaît.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00105",
                      'L’enquêteur dispose alors de deux possibilités :',
                    ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00106",
                          'poursuivre l’audition en faisant immédiatement bénéficier la personne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00107",
                          'des droits de l’article 61-1 du Code de procédure pénale attachés au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00108",
                          'suspect entendu en audition libre ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00109",
                          'décider du placement en garde à vue si les conditions sont réunies et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00110",
                          'que ce placement est nécessaire pour la conduite des investigations.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00111",
                          'Lorsque la personne manifeste sa volonté de quitter les locaux de police ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00112",
                          'et de gendarmerie, elle ne peut être placée en garde à vue du seul fait ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00113",
                          'qu’elle ne souhaite plus répondre aux questions des enquêteurs. Le témoin ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00114",
                          'retenu sous contrainte devenant suspect ne peut être maintenu à la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00115",
                          'disposition des enquêteurs que sous le régime de la garde à vue.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.3 - Audition hors garde à vue
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                  "f00116",
                  '2.3.7.3 - L’audition hors garde à vue d’une personne suspecte',
                ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00117",
                          'L’article préliminaire du Code de procédure pénale dispose que si la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00118",
                          'personne suspectée ou poursuivie ne comprend pas la langue française, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00119",
                          'elle a droit, dans une langue qu’elle comprend et jusqu’au terme de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00120",
                          'procédure, à l’assistance d’un interprète, y compris pour les entretiens ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00121",
                          'avec son avocat ayant un lien direct avec tout interrogatoire.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00122",
                          'Les dispositions de l’audition libre s’appliquent à l’enquête ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00123",
                          'préliminaire, y compris pour les personnes convoquées en application de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00124",
                          'l’article 78 du Code de procédure pénale.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00125",
                          'Au début de l’audition, l’officier ou l’agent de police judiciaire doit ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00126",
                          'systématiquement demander à la personne de confirmer qu’elle a suivi de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00127",
                          'son plein gré les agents de la force publique et qu’elle n’a subi aucune ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00128",
                          'contrainte lors du transport.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00129",
                          'La personne suspectée doit ensuite être informée des droits suivants ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00130",
                          '(article 61-1 du Code de procédure pénale) :',
                        ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00131",
                          'le droit d’être informée de la qualification, de la date et du lieu ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00132",
                          'présumés de l’infraction qu’elle est soupçonnée d’avoir commise ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00133",
                          'tenté de commettre ;',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00134",
                      'le droit de quitter à tout moment les locaux où elle est entendue ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00135",
                      'le droit d’être assistée par un interprète, le cas échéant ;',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00136",
                          'le droit de faire des déclarations, de répondre aux questions qui lui ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00137",
                          'sont posées ou de se taire ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00138",
                          'le droit d’être assistée d’un avocat au cours de son audition ou de sa ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00139",
                          'confrontation, mais également lors des reconstitutions d’infraction et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00140",
                          'de la présentation pour identification à victime ou témoin, si ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00141",
                          'l’infraction est un crime ou un délit puni d’une peine ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00142",
                          'd’emprisonnement ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00143",
                          'la possibilité de bénéficier, le cas échéant gratuitement, de conseils ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00144",
                          'juridiques dans une structure d’accès au droit.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00145",
                          'Si la personne souhaite mettre un terme à l’audition et quitter les locaux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00146",
                          'de police ou de gendarmerie, un placement en garde à vue ne peut se ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00147",
                          'justifier sur le seul fait qu’elle refuse de répondre aux questions. Il ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00148",
                          'convient de laisser partir l’intéressé et de le convoquer pour une date ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00149",
                          'ultérieure.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00150",
                          'Toutefois, si l’un ou plusieurs des motifs prévus à l’article 62-2 du Code ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00151",
                          'de procédure pénale peuvent être retenus, le placement en garde à vue est ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00152",
                          'possible.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00153",
                          'Lorsqu’une personne auditionnée sous le statut de suspect libre est, dans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00154",
                          'le prolongement immédiat, placée en garde à vue, le décompte du délai de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00155",
                          'garde à vue commence à courir à partir de l’heure du début de l’audition ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00156",
                          'libre.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ////////////////////////////////////////////////////////////////
              /// 2.3.7.4 à 2.3.7.6
              ////////////////////////////////////////////////////////////////
              _ConditionCard(
                title:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00157",
                      '2.3.7.4 à 2.3.7.6 - Audition de la personne gardée à vue, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                      "f00158",
                      'enregistrement et auditions à l’étranger',
                    ),
                cardColor: cardBlue,
                accent: accentBlue,
                titleColor: titleBlue,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00159",
                          'La personne placée en garde à vue peut demander à être assistée de son ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00160",
                          'avocat lors des auditions et confrontations, mais également lors des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00161",
                          'reconstitutions d’infraction et de la présentation pour identification à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00162",
                          'victime ou témoin. L’audition se déroule alors en présence de l’avocat, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00163",
                          'l’enquêteur en conservant la direction exclusive. À l’issue de l’audition, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00164",
                          'l’avocat peut poser des questions directement à son client ; les questions ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00165",
                          'et les réponses sont inscrites au procès-verbal. L’avocat peut relire le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00166",
                          'procès-verbal d’audition, mais, contrairement à la personne gardée à vue, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00167",
                          'il n’a pas à le signer.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00168",
                          'L’enregistrement des auditions durant la garde à vue, en matière ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00169",
                          'criminelle, renvoie à la procédure de flagrant délit (article 64-1 du Code ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00170",
                          'de procédure pénale).',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00171",
                          'Enfin, l’article 18 alinéa 4 du Code de procédure pénale permet aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00172",
                          'officiers de police judiciaire de procéder à des auditions sur le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00173",
                          'territoire d’un État étranger, avec l’accord des autorités compétentes de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/audition_enquete_preliminaire_gpx_school.dart",
                          "f00174",
                          'l’État concerné et sur réquisitions du procureur de la République.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
