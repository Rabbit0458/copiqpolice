import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class GardeAVuePageGpxSchool extends StatelessWidget {
  const GardeAVuePageGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/criminalite_organisee/garde_a_vue';

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
            "f00001",
            'Garde à vue – criminalité organisée',
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
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00002",
                  '2.1.4 - La garde à vue',
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00003",
                      'Dans le cadre de la criminalité et de la délinquance organisées, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00004",
                      'le législateur a prévu des règles spécifiques en matière de garde à vue.',
                    ),
              ),

              const SizedBox(height: 20),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00005",
                  '2.1.4.1 - Les dispositions applicables aux majeurs',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00006",
                  'Principe et cadre légal – article 706-88',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00007",
                        'L\'article 706-88 du Code de procédure pénale dispose :',
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
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00008",
                          '« Pour l’application des articles 63, 77 et 154, si les nécessités de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00009",
                          'l’enquête ou de l’instruction relatives à l’une des infractions entrant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00010",
                          'dans le champ d’application de l’article 706-73 l’exigent, la garde à vue ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00011",
                          'd’une personne peut, à titre exceptionnel, faire l’objet de deux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00012",
                          'prolongations supplémentaires de vingt-quatre heures chacune. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00013",
                          'Ces prolongations sont autorisées, par décision écrite et motivée, soit, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00014",
                          'à la requête du procureur de la République, par le juge des libertés et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00015",
                          'de la détention, soit par le juge d’instruction. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00016",
                          'La personne gardée à vue doit être présentée au magistrat qui statue ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00017",
                          'sur la prolongation préalablement à cette décision. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00018",
                          'La seconde prolongation peut toutefois, à titre exceptionnel, être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00019",
                          'autorisée sans présentation préalable de la personne en raison des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00020",
                          'nécessités des investigations en cours ou à effectuer. »',
                        ),
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00021",
                          'Lorsque la première prolongation est décidée, la personne gardée à vue ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00022",
                          'est examinée par un médecin désigné par le procureur de la République, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00023",
                          'le juge d’instruction ou l’officier de police judiciaire. Le médecin ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00024",
                          'délivre un certificat médical par lequel il doit notamment se prononcer ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00025",
                          'sur l’aptitude au maintien en garde à vue, certificat qui est versé au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00026",
                          'dossier. La personne est avisée par l’officier de police judiciaire de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00027",
                          'son droit de demander un nouvel examen médical. Ces examens médicaux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00028",
                          'sont de droit. Mention de cet avis est portée au procès-verbal et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00029",
                          'émargée par la personne intéressée ; en cas de refus d’émargement, il en ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00030",
                          'est fait mention.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00031",
                          'Par dérogation aux dispositions du premier alinéa, si la durée prévisible ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00032",
                          'des investigations restant à réaliser à l’issue des premières quarante-huit ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00033",
                          'heures de garde à vue le justifie, le juge des libertés et de la détention ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00034",
                          'ou le juge d’instruction peuvent décider, selon les modalités prévues au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00035",
                          'deuxième alinéa, que la garde à vue fera l’objet d’une seule prolongation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00036",
                          'supplémentaire de quarante-huit heures.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00037",
                          'Par dérogation aux dispositions des articles 63-4 à 63-4-2, lorsque la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00038",
                          'personne est gardée à vue pour une infraction entrant dans le champ ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00039",
                          'd’application de l’article 706-73, l’intervention de l’avocat peut être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00040",
                          'différée, en considération de raisons impérieuses tenant aux circonstances ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00041",
                          'particulières de l’enquête ou de l’instruction, soit pour permettre le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00042",
                          'recueil ou la conservation des preuves, soit pour prévenir une atteinte ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00043",
                          'grave à la vie, à la liberté ou à l’intégrité physique d’une personne, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00044",
                          'pendant une durée maximale de quarante-huit heures ou, s’il s’agit d’une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00045",
                          'infraction mentionnée aux 3° ou 11° du même article 706-73, pendant une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00046",
                          'durée maximale de soixante-douze heures.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00047",
                          'Le report de l’intervention de l’avocat jusqu’à la fin de la vingt-quatrième ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00048",
                          'heure est décidé par le procureur de la République, d’office ou à la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00049",
                          'demande de l’officier de police judiciaire. Le report de l’intervention de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00050",
                          'l’avocat au-delà de la vingt-quatrième heure est décidé, dans les limites ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00051",
                          'fixées au sixième alinéa, par le juge des libertés et de la détention ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00052",
                          'statuant à la requête du procureur de la République. Lorsque la garde à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00053",
                          'vue intervient au cours d’une commission rogatoire, le report est décidé ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00054",
                          'par le juge d’instruction. Dans tous les cas, la décision du magistrat, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00055",
                          'écrite et motivée, précise la durée pour laquelle l’intervention de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00056",
                          'l’avocat est différée.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00057",
                          'Lorsqu’il est fait application des sixième et septième alinéas de cet ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00058",
                          'article, l’avocat dispose, à partir du moment où il est autorisé à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00059",
                          'intervenir en garde à vue, des droits prévus aux articles 63-4 et 63-4-1, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00060",
                          'au premier alinéa de l’article 63-4-2 et à l’article 63-4-3. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00061",
                          'Cet article n’est pas applicable aux délits prévus au 21° de l’article ',
                        ) +
                        '706-73.',
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00062",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00063",
                  '2.1.4.1.1 - Les différents cas de prolongations supplémentaires de la durée de la garde à vue',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00064",
                  'Au-delà de la durée de droit commun (48 heures)',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00065",
                          'Au-delà de la durée de droit commun (48 heures), la garde à vue peut, à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00066",
                          'titre exceptionnel, faire l’objet de deux types de prolongations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00067",
                          'supplémentaires :',
                        ),
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00068",
                          'Soit deux prolongations supplémentaires de 24 heures chacune, portant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00069",
                          'la durée totale de la mesure à 96 heures. À l’issue de la première ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00070",
                          'prolongation supplémentaire de 24 heures, le magistrat peut accorder ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00071",
                          'une nouvelle prolongation de 24 heures.',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00072",
                          'Soit une seule prolongation supplémentaire de 48 heures, lorsque la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00073",
                          'durée des investigations restant à réaliser le justifie.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00074",
                          'La prolongation supplémentaire de la durée de garde à vue est applicable, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00075",
                          'quel que soit le cadre d’enquête, aux seules infractions listées à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00076",
                          'l’article 706-73 du Code de procédure pénale, à l’exception des délits ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00077",
                          'douaniers prévus au 21°.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00078",
                          'Pour les infractions listées aux articles 706-73-1 et 706-74 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00079",
                          'procédure pénale, la garde à vue est identique à celle de droit commun.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00080",
                            'Dès le début de la mesure, lors de l’information du placement en garde à vue, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00081",
                            'l’officier de police judiciaire est tenu d’aviser le procureur de la République ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00082",
                            'de la qualification des faits qu’il a notifiée à la personne (article 63 alinéa 2 ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00083",
                            'du Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00084",
                          'Le procureur de la République peut modifier cette qualification, qui sera ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00085",
                          'notifiée à la personne gardée à vue.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00086",
                          'La mise en œuvre de ces prolongations suppose que les nécessités de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00087",
                          'l’enquête ou de l’instruction l’exigent et que l’utilisation de cette ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00088",
                          'possibilité reste exceptionnelle.',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00089",
                          'La ou les prolongations supplémentaires doivent être autorisées par une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00090",
                          'décision écrite et motivée.',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00091",
                          'Si la garde à vue a été prescrite sur commission rogatoire, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00092",
                          'prolongation est autorisée par le juge d’instruction.',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00093",
                          'Si la garde à vue a été prescrite dans le cadre d’une enquête de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00094",
                          'flagrance ou préliminaire, la prolongation est autorisée par le juge ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00095",
                          'des libertés et de la détention, à la requête du procureur de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00096",
                          'République.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00097",
                          'La présentation préalable de la personne gardée à vue au magistrat est ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00098",
                          'obligatoire pour obtenir l’autorisation de prolongation supplémentaire. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00099",
                          'À titre exceptionnel, la seconde prolongation supplémentaire peut être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00100",
                          'autorisée sans présentation préalable de la personne en raison des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00101",
                          'nécessités des investigations en cours ou à effectuer.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00102",
                  'Régimes dérogatoires : terrorisme et « mules »',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00103",
                      'En matière de terrorisme',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00104",
                        'En matière de terrorisme, l’article 706-88-1 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00105",
                            'prévoit que la durée totale de la garde à vue peut, à titre ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00106",
                            'exceptionnel, atteindre six jours (144 heures).',
                          ),
                    ),
                  ]),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00107",
                          'La mesure peut faire l’objet d’une prolongation supplémentaire de 24 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00108",
                          'heures, renouvelable une fois, portant la durée maximale de quatre à six ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00109",
                          'jours. Cette durée ne s’applique qu’aux infractions expressément visées ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00110",
                          'par l’article 706-73, 11°, c’est-à-dire les crimes et délits constituant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00111",
                          'des actes de terrorisme prévus par les articles 421-1 à 421-6 du code ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00112",
                          'pénal.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00113",
                          'Ce dispositif doit rester exceptionnel et ne peut être mis en œuvre ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00114",
                          'que s’il existe un risque sérieux d’imminence d’une action terroriste ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00115",
                          'en France ou à l’étranger,',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00116",
                          'ou si les nécessités de la coopération internationale le requièrent ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00117",
                          'impérativement.',
                        ),
                  ),
                  SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00118",
                          'Les prolongations supplémentaires ne peuvent être autorisées que par une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00119",
                          'décision écrite et motivée du juge des libertés et de la détention, soit à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00120",
                          'la requête du procureur de la République, soit à celle du juge ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00121",
                          'd’instruction. La présentation préalable de la personne gardée à vue au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00122",
                          'juge des libertés et de la détention doit intervenir lors de chaque ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00123",
                          'demande de prolongation.',
                        ),
                  ),
                  SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00124",
                      'Pour les passeurs de produits stupéfiants in corpore',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00125",
                            'Pour les passeurs de produits stupéfiants in corpore, l’article 706-88-2 du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00126",
                            'Code de procédure pénale ',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00127",
                            'prévoit que, dans le cadre des crimes et délits de trafic de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00128",
                            'stupéfiants visés au 3° de l’article 706-73 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00129",
                            'pénale, la garde à vue d’une personne dont il apparaît qu’elle a ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00130",
                            'ingéré des produits stupéfiants aux fins d’assurer leur transport ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00131",
                            '(« mule »), peut faire l’objet d’une prolongation exceptionnelle de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00132",
                            '24 heures, portant la durée maximale de quatre à cinq jours ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00133",
                            '(24 + 24 + [24 + 24] + 24 = 120 heures).',
                          ),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00134",
                          'Si une prolongation supplémentaire de la garde à vue est envisagée, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00135",
                          'personne doit être examinée par un médecin avant l’expiration du délai ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00136",
                          'de 96 heures. Le praticien établit alors un certificat indiquant la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00137",
                          'présence ou l’absence de substances stupéfiantes dans le corps de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00138",
                          'personne et se prononce sur l’aptitude au maintien en garde à vue. Ce ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00139",
                          'certificat est versé au dossier.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00140",
                          'Cette prolongation ne peut être autorisée que par une décision écrite et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00141",
                          'motivée du juge des libertés et de la détention, soit à la requête du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00142",
                          'procureur de la République, soit à celle du juge d’instruction. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00143",
                          'L’article 706-88-2 du Code de procédure pénale ne prévoit pas de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00144",
                          'présentation préalable de la personne.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00145",
                  '2.1.4.1.2 - Le droit à un examen médical',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00146",
                  'Examens médicaux pendant la garde à vue',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00147",
                            'Durant les premières 48 heures, le droit commun s’applique conformément à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00148",
                            'l’article 63-3 du Code de procédure pénale :',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00149",
                          'la personne gardée à vue peut solliciter un examen médical au début de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00150",
                          'mesure, puis un second examen lors de la prolongation.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00151",
                          'Lors de la première prolongation supplémentaire (au début de la 49ème ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00152",
                          'heure), le procureur de la République, le juge d’instruction ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00153",
                          'l’officier de police judiciaire désigne un médecin pour examiner la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00154",
                          'personne. Le médecin délivre un certificat médical par lequel il se ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00155",
                          'prononce sur l’aptitude au maintien en garde à vue du mis en cause. Le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00156",
                          'certificat est joint à la procédure.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00157",
                            'L’officier de police judiciaire avise également l’intéressé de son droit à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00158",
                            'solliciter un nouvel examen médical et lui fait émarger le procès-verbal ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00159",
                            'comportant cet avis (article 706-88 alinéa 4 du Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00160",
                          'Le texte ne prévoit rien à l’issue de la 72ème heure. Toutefois, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00161",
                          'circulaire CRIM 04-13 du 02/09/2004 précise qu’il est évident, bien que ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00162",
                          'la loi ne le mentionne pas expressément pour les prolongations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00163",
                          'supplémentaires, que le magistrat chargé du contrôle de la mesure ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00164",
                          'l’officier de police judiciaire peut ordonner un nouvel examen médical ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00165",
                          'à tout moment si cela apparaît nécessaire, notamment en cas de garde à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00166",
                          'vue longue concernant des personnes malades ou toxicomanes.',
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00167",
                      'En matière de terrorisme',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00168",
                          'En matière de terrorisme, un examen médical est obligatoire au début de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00169",
                          'chacune des deux prolongations supplémentaires (début de la 97ème et de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00170",
                          'la 121ème heure). Lors de chacune de ces prolongations, la personne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00171",
                          'gardée à vue est avisée de son droit de solliciter un nouvel examen ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00172",
                          'médical. Le médecin désigné se prononce sur la compatibilité de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00173",
                          'prolongation de la mesure avec l’état de santé de l’intéressé (article ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00174",
                          '706-88-1 alinéa 3 du Code de procédure pénale).',
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00175",
                      'Pour le cas du passeur de produits stupéfiants in corpore',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00176",
                          'Outre l’examen obligatoire préalable à l’autorisation du juge des libertés ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00177",
                          'et de la détention, la personne dont la prolongation de la garde à vue a ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00178",
                          'été décidée est avisée de son droit de demander un nouvel examen médical ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00179",
                          '(article 706-88-2 alinéa 4 du Code de procédure pénale).',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00180",
                  '2.1.4.1.3 - Le droit à l’assistance d’un avocat',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00181",
                  'Principe général',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00182",
                            'L’article 63-3-1 du Code de procédure pénale dispose que, dès le début de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00183",
                            'la garde à vue et à tout moment au cours de celle-ci, la personne peut ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00184",
                            'demander à être assistée d’un avocat.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00185",
                      'la possibilité de s’entretenir avec lui ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00186",
                      'la possibilité de consulter certaines pièces de la procédure ;',
                    ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00187",
                          'la possibilité pour l’avocat d’assister aux auditions et confrontations, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00188",
                          'ainsi qu’aux opérations de reconstitution d’infraction et de présentation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00189",
                          'pour identification à victime ou témoin.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00190",
                  '2.1.4.1.3.1 - Un entretien confidentiel',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00191",
                          'En matière de criminalité organisée, les dispositions relatives à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00192",
                          'l’entretien avec l’avocat sont prévues par les articles 706-88 (alinéas 6 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00193",
                          'à 8) et 63-4 du Code de procédure pénale.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00194",
                        'L’article 63-4 du Code de procédure pénale précise que : ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00195",
                            '« Lorsque la garde à vue fait l’objet de prolongations, la personne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00196",
                            'peut demander à s’entretenir avec un avocat dès le début de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00197",
                            'prolongation. »',
                          ),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00198",
                          'La personne peut s’entretenir avec son avocat une fois par tranche de 24 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00199",
                          'heures. La circulaire (CRIM. 00-13 F1) du 4 décembre 2000 du ministère ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00200",
                          'de la Justice précise que, dès la notification de ses droits, la personne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00201",
                          'gardée à vue doit être avisée de ce droit à entretien, aux différentes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00202",
                          'échéances prévues, et doit demander à en bénéficier. Ces demandes sont ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00203",
                          'mentionnées dans le procès-verbal de notification.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00204",
                          'Lors des notifications des différentes prolongations, la personne gardée à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00205",
                          'vue est à nouveau informée de son droit à être assistée par un avocat.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00206",
                          'Dans le cadre des infractions visées aux articles 706-73-1 et 706-74 du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00207",
                          'Code de procédure pénale, ainsi que pour les délits douaniers commis en ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00208",
                          'bande organisée visés au 21° de l’article 706-73, la garde à vue peut ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00209",
                          'durer 48 heures. Le régime est alors identique au droit commun : deux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00210",
                          'entretiens avec l’avocat, l’un dès le début de la garde à vue, l’autre ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00211",
                          'dès le début de la prolongation.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00212",
                          'L’avocat désigné peut s’entretenir avec la personne gardée à vue pendant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00213",
                          'une durée de trente minutes dès le début de la mesure. Cet entretien ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00214",
                          'permet notamment à la personne gardée à vue de préparer ses auditions, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00215",
                          'auxquelles l’avocat peut assister.',
                        ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00216",
                      'En matière de terrorisme et pour les « mules »',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00217",
                          'En matière de terrorisme, la personne peut également demander à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00218",
                          's’entretenir avec un avocat à l’expiration de la 96ème heure et de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00219",
                          '120ème heure (article 706-88-1 alinéa 2 du Code de procédure pénale).',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00220",
                          'Les passeurs de produits stupéfiants in corpore (« mules ») peuvent aussi ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00221",
                          'solliciter un entretien à l’expiration de la 96ème heure lorsque leur ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00222",
                          'garde à vue est prolongée dans ce cadre (article 706-88-2 alinéa 3 du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00223",
                          'Code de procédure pénale).',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00224",
                  '2.1.4.1.3.2 - Consultation de certaines pièces de procédure',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00225",
                            'L’avocat peut consulter certaines pièces de procédure limitativement ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00226",
                            'énumérées à l’article 63-4-1 du Code de procédure pénale :',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00227",
                      'le procès-verbal de placement en garde à vue et des droits ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00228",
                      'le certificat médical établi en application de l’article 63-3 ;',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00229",
                          'les procès-verbaux d’auditions et de confrontations de la personne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00230",
                          'qu’il assiste, y compris celles réalisées en son absence et celles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00231",
                          'antérieures à la garde à vue en cours, lorsqu’elles concernent les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00232",
                          'mêmes faits.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00233",
                          'L’avocat décide s’il souhaite prendre connaissance de ces pièces avant ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00234",
                          'après l’entretien confidentiel. Il ne peut en demander ou en réaliser une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00235",
                          'copie, mais peut prendre des notes. Il ne peut conserver ces documents ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00236",
                          'lors de l’entretien.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00237",
                  '2.1.4.1.3.3 - Présence de l’avocat lors de certains actes de la procédure',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                      "f00238",
                      'À l’exclusion de tout autre acte de procédure, l’avocat peut assister :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00239",
                          'aux auditions et confrontations de la personne gardée à vue ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00240",
                          '(article 63-4-2 du Code de procédure pénale) ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00241",
                          'aux opérations de reconstitution d’infraction auxquelles elle participe ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00242",
                          '(article 61-3 alinéa 2 du Code de procédure pénale) ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00243",
                          'aux séances d’identification de suspects dont elle fait partie ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00244",
                          '(article 61-3 alinéa 3 du Code de procédure pénale).',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00245",
                          'Si la personne gardée à vue a demandé l’assistance d’un avocat pour ses ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00246",
                          'auditions et confrontations, elle ne peut être entendue sur les faits sans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00247",
                          'la présence de l’avocat choisi ou commis d’office, sauf renonciation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00248",
                          'expresse de sa part mentionnée au procès-verbal.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00249",
                          'Si l’avocat désigné ne peut être contacté ou déclare ne pas pouvoir se ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00250",
                          'présenter dans un délai de deux heures à compter de l’avis qui lui a été ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00251",
                          'adressé, ou s’il ne se présente pas dans ce délai, l’officier de police ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00252",
                          'judiciaire, ou sous son contrôle l’agent de police judiciaire ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00253",
                          'l’assistant d’enquête, saisit sans délai le bâtonnier aux fins de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00254",
                          'désignation d’un avocat commis d’office, et en informe la personne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00255",
                          'gardée à vue.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00256",
                          'L’officier de police judiciaire conserve la direction exclusive de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00257",
                          'l’audition. L’avocat peut prendre des notes mais ne peut pas intervenir ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00258",
                          'au cours de l’audition ni conseiller son client pendant celle-ci. À ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00259",
                          'l’issue de l’audition, l’avocat peut poser des questions directement à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00260",
                          'son client ; les questions et réponses sont consignées au procès-verbal. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00261",
                          'L’enquêteur peut s’opposer à une question si elle nuit au bon déroulement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00262",
                          'de l’enquête, ce refus étant acté au procès-verbal.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00263",
                          'L’avocat peut relire le procès-verbal d’audition et de confrontation, mais ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00264",
                          'il ne le signe pas. Il peut formuler des observations écrites qui seront ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00265",
                          'annexées à la procédure.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00266",
                            'En cas de transport de la personne gardée à vue pour les nécessités de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00267",
                            'l’enquête, son avocat en est informé sans délai. L’article 63-4-3-1 du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00268",
                            'Code de procédure pénale ',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00269",
                            'prévoit que cet avis doit se limiter aux déplacements donnant lieu à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00270",
                            'une audition, une opération de reconstitution ou une séance ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00271",
                            'd’identification des suspects à laquelle participe la personne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00272",
                            'gardée à vue. Cette information ne concerne pas les transports liés ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00273",
                            'à une hospitalisation, à un examen médical ou à une présentation ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00274",
                            'devant un magistrat.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00275",
                        'L’article D. 15-5-6 du Code de procédure pénale précise que ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00276",
                            'la personne placée en garde à vue ayant sollicité l’assistance d’un ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00277",
                            'avocat ne peut faire l’objet d’une audition dans un autre lieu que ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00278",
                            'celui du service enquêteur si son avocat n’a pas été avisé de ce ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00279",
                            'déplacement.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00280",
                          'En pratique, l’information est le plus souvent donnée lors d’une audition ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00281",
                          'préalable en présence de l’avocat. Si l’avocat n’est pas présent au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00282",
                          'moment où le transport est décidé, il doit en être informé par tout ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00283",
                          'moyen, sans que les enquêteurs aient toutefois l’obligation matérielle ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00284",
                          'd’emmener l’avocat sur les lieux.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00285",
                          'L’avocat n’a pas à assister aux perquisitions. Les objets saisis peuvent ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00286",
                          'être présentés à la personne gardée à vue ; cette présentation doit se ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00287",
                          'limiter à une interpellation simple sans entraîner d’explications longues ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00288",
                          'et détaillées. À son retour au service, l’officier de police judiciaire ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00289",
                          'peut entendre la personne en présence de l’avocat afin de faire confirmer ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00290",
                          'les déclarations faites au cours de la perquisition.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00291",
                            'À l’issue de chacune des opérations auxquelles il assiste, l’avocat peut ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00292",
                            'présenter des observations écrites qui sont jointes à la procédure. Il ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00293",
                            'peut également les adresser directement au procureur de la République ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00294",
                            '(article 63-4-3 du Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00295",
                  '2.1.4.1.3.4 - Autorisation d’audition immédiate',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00296",
                        'L’article 63-4-2-1 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00297",
                            'prévoit qu’à la demande de l’officier de police judiciaire, le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00298",
                            'procureur de la République peut décider de faire procéder ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00299",
                            'immédiatement à l’audition de la personne gardée à vue ou à des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00300",
                            'confrontations.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00301",
                          'Cette décision doit être écrite, motivée et indispensable pour éviter ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00302",
                          'une situation susceptible de compromettre sérieusement une procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00303",
                          'pénale,',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00304",
                          'ou pour prévenir une atteinte grave à la vie, à la liberté ou à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00305",
                          'l’intégrité physique d’une personne.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00306",
                          'L’audition ou la confrontation peut alors débuter sans l’assistance de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00307",
                          'l’avocat. Dès son arrivée, la personne gardée à vue est immédiatement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00308",
                          'informée de cette décision. L’audition est interrompue à sa demande afin ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00309",
                          'de lui permettre de s’entretenir avec son avocat dans les conditions de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00310",
                          'l’article 63-4 et pour que celui-ci prenne connaissance des documents ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00311",
                          'mentionnés à l’article 63-4-1. Si la personne ne demande pas cet ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00312",
                          'entretien, l’avocat peut néanmoins assister à l’audition ou à la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00313",
                          'confrontation dès son arrivée dans les locaux de police judiciaire.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00314",
                  '2.1.4.1.3.5 - Report de l’intervention de l’avocat',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00315",
                        'L’article 706-88 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00316",
                            'permet que l’intervention de l’avocat soit différée, en considération ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00317",
                            'de raisons impérieuses tenant aux circonstances particulières de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00318",
                            'l’enquête ou de l’instruction : pour permettre le recueil ou la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00319",
                            'conservation des preuves, ou pour prévenir une atteinte grave à la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00320",
                            'vie, à la liberté ou à l’intégrité physique d’une personne.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00321",
                          'Ce report peut atteindre une durée maximale de 48 heures, voire de 72 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00322",
                          'heures lorsqu’il s’agit d’une infraction mentionnée aux 3° ou 11° de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00323",
                          'l’article 706-73 (stupéfiants ou terrorisme). Ces durées s’apprécient ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00324",
                          'à compter du début de la mesure de garde à vue.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00325",
                          'Le report fait l’objet d’une décision écrite et motivée qui en précise la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00326",
                          'durée :',
                        ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00327",
                          'jusqu’à la 24ème heure : par le procureur de la République, d’office ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00328",
                          'ou sur demande de l’officier de police judiciaire ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00329",
                          'au-delà de la 24ème heure : par le juge des libertés et de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00330",
                          'détention, à la requête du procureur de la République.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00331",
                          'Pendant la durée du report, l’avocat ne peut ni s’entretenir avec la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00332",
                          'personne gardée à vue, ni consulter les documents, ni assister aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00333",
                          'auditions et confrontations. L’avis à avocat est donc retardé, et le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00334",
                          'gardé à vue est informé que l’avocat ne se présentera qu’à l’issue du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00335",
                          'délai de report accordé.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00336",
                  '2.1.4.1.4 - Droit de faire prévenir, défèrement et remise en liberté',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00337",
                  '2.1.4.1.4 - Droit de faire prévenir un proche',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00338",
                          'En matière de terrorisme ou pour les « mules », si la demande de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00339",
                          'personne gardée à vue de faire prévenir une personne avec laquelle elle ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00340",
                          'vit habituellement, l’un de ses parents en ligne directe, l’un de ses ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00341",
                          'frères et sœurs ou son employeur n’a pas été satisfaite, elle peut ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00342",
                          'réitérer cette demande à compter de la 96ème heure de garde à vue, dans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00343",
                          'les conditions prévues aux articles 63-1 et 63-2 du Code de procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00344",
                          'pénale (article 706-88-1 alinéa 4 et article 706-88-2 alinéa 5 du Code ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00345",
                          'de procédure pénale).',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00346",
                          'Le report de l’avis aux autorités consulaires est impossible au-delà de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00347",
                          'la 48ème heure.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00348",
                  '2.1.4.1.4.1 - Le défèrement',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00349",
                        'Les dispositions des articles 803-2 et 803-3 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00350",
                            's’appliquent de la même façon qu’en droit commun, à une exception ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00351",
                            'près : la personne ayant fait l’objet d’une garde à vue d’une durée ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00352",
                            'supérieure à 72 heures, en application des articles 706-88 ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00353",
                            '706-88-1 du Code de procédure pénale, doit comparaître devant le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00354",
                            'magistrat le jour même de la levée de la garde à vue.',
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00355",
                  '2.1.4.1.4.2 - La remise en liberté',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00356",
                            'En matière de criminalité organisée, l’article 706-105 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00357",
                            'pénale ',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00358",
                            'se substitue à l’article 77-2 du Code de procédure pénale applicable en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00359",
                            'droit commun. Il permet à une personne placée en garde à vue et à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00360",
                            'l’égard de laquelle il a été fait usage des dispositions des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00361",
                            'articles 706-80 à 706-95 du Code de procédure pénale (surveillance, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00362",
                            'infiltration, garde à vue, perquisitions, interception de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00363",
                            'correspondances) d’interroger le procureur de la République dans le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00364",
                            'ressort duquel la garde à vue s’est déroulée, six mois après le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00365",
                            'placement, sur les suites données à l’affaire.',
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00366",
                  '2.1.4.2 - Les dispositions applicables aux mineurs',
                ),
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00367",
                  '2.1.4.2.1 - Le principe',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                        "f00368",
                        'L’article L. 413-11 du code de la justice pénale des mineurs ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00369",
                            'dispose que le régime de garde à vue des majeurs en matière de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00370",
                            'criminalité organisée (article 706-88 du Code de procédure pénale) ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00371",
                            's’applique aux mineurs âgés de plus de 16 ans si deux conditions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                            "f00372",
                            'sont cumulativement remplies :',
                          ),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00373",
                          'il existe une ou plusieurs raisons plausibles de soupçonner le mineur ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00374",
                          'd’avoir commis l’une des infractions de l’article 706-73 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00375",
                          'procédure pénale (sauf le 21°) ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00376",
                          'une ou plusieurs personnes majeures ont participé, comme auteurs ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00377",
                          'complices, à la commission de cette infraction.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                  "f00378",
                  '2.1.4.2.2 - Les limites',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00379",
                          'La garde à vue des mineurs de moins de 16 ans ne peut être prolongée ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00380",
                          'au-delà de 48 heures.',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00381",
                          'Les dispositions relatives au report de l’assistance de l’avocat dans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00382",
                          'le cadre de la criminalité organisée (sixième à huitième alinéas de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00383",
                          'l’article 706-88 du Code de procédure pénale) ne sont pas applicables ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00384",
                          'aux mineurs.',
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
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00385",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00386",
                          'Cette fiche est destinée à un usage pédagogique interne et doit être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00387",
                          'mise à jour en cas de réforme du Code de procédure pénale ou du code ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/garde_a_vue_page.dart",
                          "f00388",
                          'de la justice pénale des mineurs.',
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
