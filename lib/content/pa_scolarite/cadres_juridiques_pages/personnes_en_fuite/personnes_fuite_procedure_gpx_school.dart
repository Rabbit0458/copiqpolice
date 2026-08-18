import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPersonnesFuiteProcedureGpxSchool extends StatelessWidget {
  const PaPersonnesFuiteProcedureGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/chapitre2';

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
            "f00001",
            'Art. 74-2 – Procédure',
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
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                      "f00002",
                      'Chapitre 2 : La procédure de l’Article 74-2 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                      "f00003",
                      'du Code de procédure pénale',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                      "f00004",
                      'Ce chapitre présente les autorités compétentes et les principaux actes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                      "f00005",
                      'd’enquête pouvant être mis en œuvre dans le cadre de la recherche des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                      "f00006",
                      'personnes en fuite prévue par l’Article 74-2 du Code de procédure pénale.',
                    ),
              ),
              const SizedBox(height: 20),

              // 2.1 – LES AUTORITÉS HABILITÉES
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                  "f00007",
                  '2.1 – Les autorités habilitées',
                ),
              ),
              const SizedBox(height: 8),

              // 2.1.1 Les magistrats – Procureur
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                  "f00008",
                  '2.1.1 – Les magistrats\n2.1.1.1 – Le procureur de la République',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00009",
                        'Aux termes de l’Article 74-2 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00010",
                            '(alinéa 1), le cadre d’enquête visant à rechercher et découvrir ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00011",
                            'une personne en fuite ne peut être mis en œuvre que sur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00012",
                            'instructions du procureur de la République.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                      "f00013",
                      'Le procureur de la République peut notamment :',
                    ),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00014",
                          'demander aux officiers de police judiciaire d’user des moyens ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00015",
                          'd’investigation de l’enquête de flagrance prévus aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00016",
                          'Articles 56 à 62 du Code de procédure pénale ;',
                        ),
                  ),
                  _BulletPoint.rich(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00017",
                          'demander au juge des libertés et de la détention l’autorisation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00018",
                          'de procéder à l’interception, l’enregistrement et la transcription ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00019",
                          'des correspondances émises par la voie des télécommunications, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00020",
                          'selon les modalités prévues par les ',
                        ),
                    articleSpan: TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00021",
                        'Articles 100, 100-1 et 100-3 à 100-7 du Code de procédure pénale',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    endText: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                      "f00022",
                      ' (référence à l’Article 74-2, alinéa 8).',
                    ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00023",
                            'Dans le cadre des opérations d’interception, les attributions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00024",
                            'habituellement confiées au juge d’instruction par les ',
                          ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00025",
                        'Articles 100-3 à 100-5 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00026",
                            'sont, dans ce dispositif, exercées par le procureur de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00027",
                            'République (ou par l’officier de police judiciaire requis par lui).',
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),

              // 2.1.1.2 Juge des libertés et de la détention
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                  "f00028",
                  '2.1.1.2 – Le juge des libertés et de la détention',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00029",
                        'L’Article 74-2 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00030",
                            '(alinéa 8) prévoit que les écoutes téléphoniques sont autorisées, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00031",
                            'en raison des nécessités de l’enquête, par le juge des libertés et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00032",
                            'de la détention du tribunal judiciaire, à la demande du procureur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00033",
                            'de la République.',
                          ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00034",
                          'L’autorisation du magistrat doit respecter les modalités prévues par les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00035",
                          'Articles 100, 100-1 et 100-3 à 100-7 du Code de procédure pénale.',
                        ),
                  ),
                  SizedBox(height: 10),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00036",
                          'L’interception téléphonique est possible en matière criminelle et en ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00037",
                          'matière correctionnelle lorsque la peine encourue est égale ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00038",
                          'supérieure à trois ans ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00039",
                          'la décision d’interception est écrite, n’est susceptible d’aucun ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00040",
                          'recours et doit être motivée par référence aux éléments de fait et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00041",
                          'de droit justifiant que ces opérations sont nécessaires. Elle doit ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00042",
                          'comporter tous les éléments d’identification de la liaison à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00043",
                          'intercepter, l’infraction qui motive le recours à l’interception ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00044",
                          'ainsi que la durée de celle-ci ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00045",
                          'aucune interception ne peut porter sur une ligne dépendant du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00046",
                          'cabinet d’un avocat ou de son domicile, sauf s’il existe des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00047",
                          'raisons plausibles de le soupçonner d’avoir commis ou tenté de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00048",
                          'commettre, en tant qu’auteur ou complice, l’infraction objet de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00049",
                          'procédure ou une infraction connexe ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00050",
                          'à peine de nullité, les lignes dépendant du cabinet ou du domicile ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00051",
                          'd’un député, sénateur, avocat ou magistrat ne peuvent être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00052",
                          'interceptées qu’après avis à leur autorité supérieure.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00053",
                          'Le juge des libertés et de la détention doit être informé sans délai de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00054",
                          'tous les actes accomplis, depuis la mise en place de l’interception ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00055",
                          'jusqu’à la transcription des correspondances.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // 2.1.2 OPJ
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                  "f00056",
                  '2.1.2 – L’officier de police judiciaire',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00057",
                          'Un officier de police judiciaire peut se voir déléguer les pouvoirs ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00058",
                          'visant à rechercher une personne en fuite. Cette délégation émane du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00059",
                          'procureur de la République, qui adresse ses instructions aux seuls ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00060",
                          'officiers de police judiciaire. Ceux-ci peuvent se faire assister des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00061",
                          'agents de police judiciaire, mais seuls les officiers de police ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00062",
                          'judiciaire sont habilités à rédiger les actes de procédure.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // 2.2 – ACTES DE L’ENQUÊTE
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                  "f00063",
                  '2.2 – Les actes de l’enquête',
                ),
              ),
              const SizedBox(height: 8),

              // 2.2.1 actes délégués
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                  "f00064",
                  '2.2.1 – Les actes délégués par le procureur de la République',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00065",
                            'L’officier de police judiciaire, assisté le cas échéant par des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00066",
                            'agents de police judiciaire, peut accomplir les actes prévus par ',
                          ) +
                          'les ',
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00067",
                        'Articles 56 à 62 du Code de procédure pénale ',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00068",
                            'aux fins de rechercher une personne en fuite (référence à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00069",
                            'l’Article 74-2, alinéa 1 du Code de procédure pénale).',
                          ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00070",
                          'L’officier de police judiciaire peut ainsi procéder à tous les actes de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00071",
                          'l’enquête de flagrant délit : auditions, perquisitions, réquisitions, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00072",
                          'examens techniques et scientifiques.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00073",
                          'Dans ce cadre spécifique de la recherche des personnes en fuite, il ne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00074",
                          'peut toutefois pas prendre de mesure de garde à vue.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // 2.2.2 Interceptions téléphoniques
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                  "f00075",
                  '2.2.2 – Les interceptions téléphoniques',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00076",
                          'Le procureur de la République, préalablement autorisé à procéder à des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00077",
                          'interceptions téléphoniques par le juge des libertés et de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00078",
                          'détention, délègue habituellement à l’officier de police judiciaire le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00079",
                          'soin de mettre en place les opérations d’interception.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00080",
                        'Ces interceptions sont réalisées en application des ',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00081",
                        'Articles 100, 100-1 et 100-3 à 100-7 du Code de procédure pénale',
                      ),
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00082",
                            ' (référence à l’Article 74-2, alinéa 8 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00083",
                            'pénale).',
                          ),
                    ),
                  ]),
                  SizedBox(height: 10),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00084",
                          'l’autorisation est délivrée pour une durée de deux mois, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00085",
                          'renouvelable dans les mêmes conditions de forme et de durée ; ce ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00086",
                          'renouvellement est limité à six mois en matière correctionnelle, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00087",
                          'mais n’est pas limité en matière criminelle ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00088",
                          'l’officier de police judiciaire peut requérir tout agent qualifié du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00089",
                          'ministère des télécommunications, d’un exploitant de réseau ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00090",
                          'd’un fournisseur de services de télécommunications afin de procéder ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00091",
                          'à l’installation du dispositif d’interception ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00092",
                          'l’officier de police judiciaire rédige un procès-verbal relatant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00093",
                          'précisément les opérations d’interception et d’enregistrement ; les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00094",
                          'enregistrements sont placés sous scellés fermés ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00095",
                          'il transcrit sur procès-verbal les correspondances utiles à la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00096",
                          'manifestation de la vérité. Un interprète doit être requis pour les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00097",
                          'correspondances en langue étrangère.',
                        ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00098",
                          'À peine de nullité, les correspondances échangées avec un avocat ne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00099",
                          'peuvent être transcrites lorsqu’elles relèvent de l’exercice des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00100",
                          'droits de la défense et sont couvertes par le secret professionnel de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00101",
                          'la défense et du conseil, sauf dans les cas limitativement prévus par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                          "f00102",
                          'les textes relatifs aux perquisitions chez l’avocat.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00103",
                            'Il appartient à l’officier de police judiciaire d’informer ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00104",
                            'régulièrement le procureur de la République, afin que ce dernier ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00105",
                            'puisse informer sans délai le juge des libertés et de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                            "f00106",
                            'détention, conformément aux dispositions du dernier alinéa de ',
                          ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/personnes_en_fuite/personnes_fuite_procedure_gpx_school.dart",
                        "f00107",
                        'l’Article 74-2 du Code de procédure pénale.',
                      ),
                      style: TextStyle(color: Colors.red),
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

/// Petit helper pour avoir un bullet avec un morceau d’article en rouge
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text}) : articleSpan = null, endText = null;

  const _BulletPoint.rich({
    required this.text,
    required this.articleSpan,
    required this.endText,
  });

  final String text;
  final TextSpan? articleSpan;
  final String? endText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (articleSpan == null) {
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
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1F1F1F).withValues(alpha: .92),
                ),
                children: [
                  TextSpan(text: text),
                  articleSpan!,
                  if (endText != null) TextSpan(text: endText),
                ],
              ),
            ),
          ),
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
