import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPersonnesFuiteIntroGpxSchool extends StatelessWidget {
  const PaPersonnesFuiteIntroGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/intro';

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
            "f00001",
            'Recherche des personnes en fuite',
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
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                  "f00002",
                  'La recherche des personnes en fuite\n(Article 74-2 du Code de procédure pénale)',
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                      "f00003",
                      'Créé par la loi n°2004-204 du 9 mars 2004 portant adaptation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                      "f00004",
                      'aux évolutions de la criminalité, le dispositif de recherche des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                      "f00005",
                      'personnes en fuite permet de poursuivre efficacement une personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                      "f00006",
                      'qui tente d’échapper à l’exécution d’une décision judiciaire.',
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                    "f00007",
                    'L’Article 74-2 du Code de procédure pénale est ainsi rédigé : ',
                  ),
                  style: TextStyle(color: Colors.red),
                ),
              ]),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                  "f00008",
                  '1 – Les hypothèses dans lesquelles la personne est dite « en fuite »',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00009",
                          'Les officiers de police judiciaire, assistés le cas échéant des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00010",
                          'agents de police judiciaire, peuvent, sur instructions du procureur ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00011",
                          'de la République, procéder aux actes prévus par les articles 56 à 62 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00012",
                          'afin de rechercher et de découvrir une personne en fuite dans les cas ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00013",
                          'suivants :',
                        ),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00014",
                          '1° Personne faisant l’objet d’un mandat d’arrêt délivré par le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00015",
                          'juge d’instruction, le juge des libertés et de la détention, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00016",
                          'chambre de l’instruction ou son président, ou le président de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00017",
                          'cour d’assises, alors qu’elle est renvoyée devant une juridiction ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00018",
                          'de jugement ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00019",
                          '2° Personne faisant l’objet d’un mandat d’arrêt délivré par une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00020",
                          'juridiction de jugement ou par le juge de l’application des peines ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00021",
                          '3° Personne condamnée à une peine privative de liberté sans sursis ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00022",
                          'supérieure ou égale à un an, ou à une peine privative de liberté ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00023",
                          'supérieure ou égale à un an résultant de la révocation d’un sursis ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00024",
                          'assorti ou non d’une probation, lorsque cette condamnation est ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00025",
                          'exécutoire ou passée en force de chose jugée ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00026",
                          '4° Personne inscrite au fichier judiciaire national automatisé des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00027",
                          'auteurs d’infractions terroristes ayant manqué aux obligations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00028",
                          'prévues à l’Article 706-25-7 du Code de procédure pénale ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00029",
                          '5° Personne inscrite au fichier judiciaire national automatisé des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00030",
                          'auteurs d’infractions sexuelles ou violentes ayant manqué aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00031",
                          'obligations prévues à l’Article 706-53-5 du Code de procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00032",
                          'pénale ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00033",
                          '6° Personne ayant fait l’objet d’une décision de retrait ou de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00034",
                          'révocation d’un aménagement de peine ou d’une libération sous ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00035",
                          'contrainte, ou d’une décision de mise à exécution de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00036",
                          'l’emprisonnement prévu par la juridiction de jugement en cas de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00037",
                          'violation des obligations ou interdictions résultant d’une peine, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00038",
                          'lorsque cette décision a pour conséquence la mise à exécution ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00039",
                          'd’un quantum ou d’un reliquat de peine d’emprisonnement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00040",
                          'supérieur à un an.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                  "f00041",
                  '2 – Interceptions de télécommunications pour retrouver la personne en fuite',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00042",
                            'Lorsque les nécessités de l’enquête pour rechercher la personne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00043",
                            'en fuite l’exigent, le juge des libertés et de la détention du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00044",
                            'tribunal de grande instance peut, à la requête du procureur de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00045",
                            'République, autoriser l’interception, l’enregistrement et la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00046",
                            'transcription de correspondances émises par la voie des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00047",
                            'télécommunications, selon les modalités prévues par les Articles ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00048",
                            '100, 100-1 et 100-3 à 100-7 du Code de procédure pénale, pour ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00049",
                            'une durée maximale de deux mois, renouvelable dans les mêmes ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00050",
                            'conditions de forme et de durée, dans la limite de six mois en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00051",
                            'matière correctionnelle. Ces opérations sont réalisées sous ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00052",
                            'l’autorité et le contrôle du juge des libertés et de la détention.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                      "f00053",
                      'Concrètement :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00054",
                          'le procureur de la République saisit le juge des libertés et de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00055",
                          'détention pour mettre en place les écoutes nécessaires à la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00056",
                          'localisation de la personne en fuite ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00057",
                          'les interceptions sont strictement limitées dans le temps et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00058",
                          'renouvelables seulement dans les conditions prévues par la loi ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00059",
                          'toute la mesure reste sous le contrôle du juge des libertés et de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00060",
                          'la détention, qui vérifie la légalité des actes.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                  "f00061",
                  '3 – Rôle du procureur de la République et de l’officier de police judiciaire',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00062",
                            'Pour l’application des dispositions des Articles 100-3 à 100-5 du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00063",
                            'Code de procédure pénale, les attributions normalement confiées ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00064",
                            'au juge d’instruction ou à l’officier de police judiciaire, commis ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00065",
                            'par lui, sont exercées par le procureur de la République ou par ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00066",
                            'l’officier de police judiciaire requis par ce magistrat. Le juge des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00067",
                            'libertés et de la détention est informé sans délai des actes ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00068",
                            'accomplis en application de ces dispositions.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                      "f00069",
                      'En pratique :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00070",
                          'le procureur de la République dirige les opérations de recherche ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00071",
                          'de la personne en fuite ;',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00072",
                          'l’officier de police judiciaire exécute les actes d’enquête (perquisitions, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00073",
                          'interceptions, surveillances) sur instructions du procureur ;',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00074",
                          'le juge des libertés et de la détention reste le garant du respect ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00075",
                          'des libertés individuelles.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                  "f00076",
                  '4 – Techniques spéciales d’enquête mobilisables',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00077",
                            'Si les nécessités de l’enquête pour rechercher la personne en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00078",
                            'fuite l’exigent, les sections 1, 2 et 4 à 6 du chapitre II du titre ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00079",
                            'XXV du livre IV du Code de procédure pénale sont applicables ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00080",
                            'lorsque la personne concernée a fait l’objet de l’une des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00081",
                            'décisions mentionnées aux 1° à 3° et 6° du présent article pour ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00082",
                            'l’une des infractions mentionnées aux Articles 706-73 et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00083",
                            '706-73-1 du Code de procédure pénale.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00084",
                          'Autrement dit, lorsque la personne en fuite est impliquée dans des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00085",
                          'faits de criminalité organisée, les techniques spéciales d’enquête ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00086",
                          '(interceptions, sonorisations, IMSI-catcher, etc.) peuvent être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00087",
                          'mobilisées pour la localiser et l’interpeller, sous contrôle du juge ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00088",
                          'des libertés et de la détention.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                  "f00089",
                  '5 – Portée du dispositif',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00090",
                            'L’Article 74-2 du Code de procédure pénale crée ainsi un cadre ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00091",
                            'juridique spécifique permettant de rechercher de manière ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00092",
                            'effective une personne faisant l’objet d’un mandat d’arrêt après ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                            "f00093",
                            'la clôture de l’information.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00094",
                          'Ce cadre permet de prolonger l’action de la justice au-delà de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00095",
                          'phase d’instruction, lorsque la personne tente d’échapper à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00096",
                          'l’exécution des décisions la concernant.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00097",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00098",
                          'vérifier les références actualisées du Code de procédure pénale ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00099",
                          '(Article 74-2 et Articles 706-73 et 706-73-1 notamment) avant de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_intro_gpx_school.dart",
                          "f00100",
                          'mettre en œuvre une procédure de recherche de personne en fuite.',
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
