import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ReglesDerogatoiresCriminaliteOrganiseePage extends StatelessWidget {
  const ReglesDerogatoiresCriminaliteOrganiseePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/criminalite_organisee/regles_derogatoires';

  TextSpan _lawArticle(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
            "f00001",
            'Règles procédurales dérogatoires',
          ),
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
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                  "f00002",
                  'Les règles procédurales dérogatoires au droit commun',
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00003",
                      'Le champ d\'application de la criminalité organisée étant clairement défini, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00004",
                      'la mise en œuvre d\'instruments procéduraux spécifiques doit renforcer l\'efficacité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00005",
                      'de la lutte contre cette forme particulière de délinquance. Nous examinerons les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00006",
                      'aspects procéduraux spécifiques applicables à chacun des trois cadres juridiques ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00007",
                      'd\'enquêtes.',
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00008",
                          'Certaines des techniques spéciales d\'enquête applicables à la criminalité organisée ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00009",
                          'peuvent également être mises en œuvre, sous conditions, dans le cadre de la procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00010",
                          'de l\'article ',
                        ),
                  ),
                  _lawArticle('74-2'),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00011",
                      ' du Code de procédure pénale (voir « La recherche des personnes en fuite »).',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2.1 – Procédure de flagrant délit
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                  "f00012",
                  '2.1 – La procédure de flagrant délit relative à la criminalité organisée',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  // 2.1.1
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00013",
                      '2.1.1 – La géolocalisation en temps réel',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00014",
                        'La géolocalisation en temps réel est encadrée par les articles ',
                      ),
                    ),
                    _lawArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00015",
                        '230-32 à 230-44',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00016",
                            ' du Code de procédure pénale. Comme en matière de droit commun, des réquisitions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00017",
                            'peuvent être établies dans le but de suivre à tout moment et à son insu les déplacements ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00018",
                            'd\'une personne, d\'un véhicule ou d\'un objet qu\'elle détient. Il peut s\'agir du suivi ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00019",
                            'dynamique d\'un terminal de télécommunication ou de l\'utilisation d\'un dispositif dédié ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00020",
                            'de géolocalisation (balise).',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00021",
                            'Des dispositions spécifiques sont applicables lorsque l\'enquête porte sur une infraction ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00022",
                            'mentionnée aux articles ',
                          ),
                    ),
                    _lawArticle('706-73'),
                    const TextSpan(text: ' ou '),
                    _lawArticle('706-73-1'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00023",
                        ' du Code de procédure pénale :',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00024",
                          'L’autorisation initiale est délivrée par le procureur de la République pour une durée ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00025",
                          'maximale de quinze jours consécutifs ;',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00026",
                      'La durée totale de la géolocalisation peut aller jusqu’à deux ans.',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2.1.2
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00027",
                      '2.1.2 – La surveillance',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00028",
                          'Le dispositif de surveillance vise à concilier la célérité dans la prise de décision des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00029",
                          'enquêteurs en matière d\'investigation, tout en maintenant les prérogatives de direction de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00030",
                          'police judiciaire reconnues au procureur de la République.',
                        ),
                  ),
                  const SizedBox(height: 10),

                  // 2.1.2.1
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00031",
                      '2.1.2.1 – Le champ d’application',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00032",
                        'L’article ',
                      ),
                    ),
                    _lawArticle('706-80'),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00033",
                            ' du Code de procédure pénale prévoit que les officiers de police judiciaire et, sous leur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00034",
                            'autorité, les agents de police judiciaire, peuvent étendre à l\'ensemble du territoire national ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00035",
                            'la surveillance :',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00036",
                          'Des personnes, lorsqu’il existe une ou plusieurs raisons plausibles de soupçonner qu’elles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00037",
                          'ont commis l’un des crimes ou délits relevant de la criminalité organisée entrant dans le champ ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00038",
                          'd’application des articles 706-73, 706-73-1 ou 706-74 du Code de procédure pénale ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00039",
                          'De l’acheminement ou du transport des objets, biens ou produits tirés de la commission de ces ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00040",
                          'infractions ou servant à les commettre.',
                        ),
                  ),
                  const SizedBox(height: 12),

                  // 2.1.2.2
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00041",
                      '2.1.2.2 – Les modalités de mise en œuvre des opérations de surveillance',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00042",
                          'Les enquêteurs peuvent étendre leurs opérations de surveillance à l’ensemble du territoire national. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00043",
                          'Préalablement à cette éventuelle extension de compétence, le procureur de la République saisi des faits ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00044",
                          'doit en être informé, tout comme le procureur de la République près le tribunal judiciaire dans le ressort ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00045",
                          'duquel les opérations de surveillance sont susceptibles de débuter. Cette information doit être donnée ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00046",
                          '« par tout moyen ». Le procureur de la République peut s’opposer à l’extension de l’opération de surveillance.',
                        ),
                  ),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00047",
                            'Dans le cadre de ces opérations de surveillance, lorsque les nécessités de l’enquête l’exigent, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00048",
                            'les officiers de police judiciaire et, sous leur autorité, les agents de police judiciaire chargés des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00049",
                            'investigations peuvent demander à tout fonctionnaire ou agent public de ne pas procéder au contrôle, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00050",
                            'à l’interpellation de ces personnes, ni à la saisie de ces objets, biens ou produits, afin de ne pas ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00051",
                            'compromettre la poursuite des investigations. Cette demande ne peut toutefois intervenir qu’avec ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00052",
                            'l’autorisation du procureur de la République chargé de l’enquête (article ',
                          ),
                    ),
                    _lawArticle('706-80-1'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00053",
                        ' du Code de procédure pénale).',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00054",
                            'Dans les mêmes conditions, les officiers de police judiciaire et, sous leur autorité, les agents de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00055",
                            'police judiciaire peuvent également livrer ou délivrer, à la place des prestataires de services postaux ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00056",
                            'et des opérateurs de fret, ces objets, biens ou produits, sans être pénalement responsables. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00057",
                            'L’autorisation du procureur de la République doit alors être écrite et motivée (article ',
                          ),
                    ),
                    _lawArticle('706-80-2'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00058",
                        ' du Code de procédure pénale).',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00059",
                          'La poursuite des opérations de surveillance dans un État étranger peut être autorisée en application de l’article ',
                        ),
                      ),
                      _lawArticle('694-6'),
                      TextSpan(
                        text: ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00060",
                          ' du Code de procédure pénale.',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2.1.3
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00061",
                      '2.1.3 – L’infiltration',
                    ),
                  ),

                  // 2.1.3.1 – Principe
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00062",
                      '2.1.3.1 – Le principe',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00063",
                            'L’officier de police judiciaire (ou un agent de police judiciaire) surveille les personnes suspectées ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00064",
                            'de commettre un crime ou un délit en se faisant passer, auprès de ces personnes, pour l’un de leurs ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00065",
                            'coauteurs, complices ou receleurs, ou comme une victime, un tiers mandaté par cette dernière, ou toute ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00066",
                            'personne intéressée à la commission de l’infraction (article ',
                          ),
                    ),
                    _lawArticle('706-81'),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00067",
                            ' du Code de procédure pénale). L’objectif poursuivi est de révéler une infraction liée à la criminalité ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00068",
                            'organisée et d’en identifier les membres.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00069",
                            'L’infiltration ne peut être mise en œuvre que dans le cadre d’une enquête portant sur l’un des crimes ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00070",
                            'délits prévus par les articles ',
                          ),
                    ),
                    _lawArticle('706-73'),
                    const TextSpan(text: ' et '),
                    _lawArticle('706-73-1'),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00071",
                            ' du Code de procédure pénale. Un officier de police judiciaire coordonne l’opération d’infiltration ; ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00072",
                            'les agents infiltrés opèrent sous sa responsabilité.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00073",
                          'À peine de nullité, les actes réalisés par l’agent durant sa mission d’infiltration ne peuvent constituer une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00074",
                          'incitation ayant déterminé la commission d’infractions. À l’exception du cas où l’agent infiltré dépose sous ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00075",
                          'sa véritable identité, aucune condamnation ne peut être prononcée sur le seul fondement des déclarations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00076",
                          'faites par l’officier de police judiciaire ou l’agent de police judiciaire ayant procédé à une opération ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00077",
                          'd’infiltration.',
                        ),
                  ),

                  const SizedBox(height: 14),

                  // 2.1.3.2 – Modalités de mise en œuvre
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00078",
                      '2.1.3.2 – Les modalités de mise en œuvre',
                    ),
                  ),

                  // 2.1.3.2.1
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00079",
                      '2.1.3.2.1 – L’autorisation préalable du magistrat',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00080",
                            'À peine de nullité, l’opération d’infiltration doit être autorisée par le procureur de la République. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00081",
                            'Elle doit être justifiée par les nécessités de l’enquête (ou de l’instruction). Cette autorisation est ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00082",
                            'délivrée par écrit et doit être spécialement motivée. Cette décision doit mentionner la ou les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00083",
                            'infractions qui justifient le recours à cette procédure et l’identité de l’officier de police judiciaire ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00084",
                            'sous la responsabilité duquel se déroule l’opération (articles ',
                          ),
                    ),
                    _lawArticle('706-81'),
                    const TextSpan(text: ' et '),
                    _lawArticle('706-83'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00085",
                        ' du Code de procédure pénale).',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00086",
                          'Elle fixe la durée de l’infiltration, qui ne peut excéder quatre mois, renouvelable dans les mêmes conditions ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00087",
                          'de forme et de durée. Le magistrat peut, à tout moment, ordonner l’interruption de l’infiltration, avant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00088",
                          'l’expiration de la durée fixée. L’autorisation est versée au dossier de la procédure après l’achèvement de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00089",
                          'l’opération d’infiltration.',
                        ),
                  ),

                  const SizedBox(height: 12),

                  // 2.1.3.2.2 – Actes d’infiltration
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00090",
                      '2.1.3.2.2 – Les actes d’infiltration',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00091",
                          'L’opération d’infiltration est réalisée par un officier de police judiciaire ou un agent de police judiciaire ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00092",
                          'spécialement habilité par le procureur général près la cour d’appel de Paris dans les conditions prévues ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00093",
                          'par le décret n° 2004-1026 du 29 septembre 2004. Il agit sous la responsabilité d’un officier de police ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00094",
                          'judiciaire chargé de coordonner l’opération.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00095",
                            'Les officiers ou agents de police judiciaire autorisés à procéder à une opération d’infiltration peuvent, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00096",
                            'sans être pénalement responsables, sur l’ensemble du territoire national (article ',
                          ),
                    ),
                    _lawArticle('706-82'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00097",
                        ' du Code de procédure pénale) :',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00098",
                          'Acquérir, détenir, transporter, livrer ou délivrer des substances, biens, produits, documents ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00099",
                          'informations tirés de la commission des infractions ou servant à la commission de ces infractions ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00100",
                          'Utiliser ou mettre à disposition des personnes se livrant à ces infractions des moyens de caractère ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00101",
                          'juridique ou financier ainsi que des moyens de transport, de dépôt, d’hébergement, de conservation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00102",
                          'et de télécommunications.',
                        ),
                  ),

                  const SizedBox(height: 14),

                  // 2.1.3.2.3 – Protection des agents infiltrés
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00103",
                      '2.1.3.2.3 – La protection des agents infiltrés',
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00104",
                      '2.1.3.2.3.1 – La protection personnelle de l’agent infiltré',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00105",
                          'L’officier de police judiciaire (ou l’agent de police judiciaire) est autorisé à faire usage d’une identité ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00106",
                          'd’emprunt, y compris en utilisant un dispositif permettant d’altérer ou de transformer sa voix ou son ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                          "f00107",
                          'apparence physique. L’identité réelle des enquêteurs infiltrés ne doit apparaître à aucun stade de la procédure.',
                        ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00108",
                            'La révélation de cette identité d’emprunt est érigée en infraction pénale (cinq ans d’emprisonnement ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00109",
                            'et 75 000 € d’amende). Les peines sont aggravées lorsque la révélation a entraîné des violences, coups ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00110",
                            'et blessures à l’encontre de l’agent infiltré, de ses conjoints, enfants ou ascendants directs, ou leur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00111",
                            'mort (article ',
                          ),
                    ),
                    _lawArticle('706-84'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00112",
                        ' du Code de procédure pénale).',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00113",
                            'L’enquêteur infiltré est exonéré de toute responsabilité pénale lorsqu’il accomplit les actes de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00114",
                            'l’opération d’infiltration. Cette exonération bénéficie également à toute personne requise par l’agent ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00115",
                            'infiltré pour la réalisation de sa mission (article ',
                          ),
                    ),
                    _lawArticle('706-82'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00116",
                        ' du Code de procédure pénale).',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00117",
                            'Lorsque l’opération d’infiltration est terminée (décision d’interruption ou terme du délai fixé), ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00118",
                            'l’agent infiltré a la possibilité de continuer ses activités, sans être pénalement responsable, pendant ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00119",
                            'le temps strictement nécessaire pour assurer sa sortie du réseau criminel en toute sécurité. Le délai ne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00120",
                            'peut excéder quatre mois. Le magistrat ayant autorisé l’infiltration en est informé dans les meilleurs ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00121",
                            'délais. Si ce délai n’est pas suffisant, sur autorisation expresse du magistrat, l’agent peut prolonger ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00122",
                            'ses activités pour une durée qui ne peut excéder quatre mois supplémentaires (article ',
                          ),
                    ),
                    _lawArticle('706-85'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00123",
                        ' du Code de procédure pénale).',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 12),

                  // 2.1.3.2.3.2 – Protection procédurale
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                      "f00124",
                      '2.1.3.2.3.2 – La protection procédurale de l’agent infiltré',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00125",
                            'L’officier de police judiciaire coordonnateur, sous la responsabilité duquel se déroule l’opération, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00126",
                            'rédige le rapport qui comprend les éléments strictement nécessaires à la constatation des infractions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00127",
                            'et ne mettant pas en danger la sécurité de l’agent infiltré ou des personnes requises pour l’assister ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00128",
                            '(article ',
                          ),
                    ),
                    _lawArticle('706-81'),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                        "f00129",
                        ' du Code de procédure pénale).',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00130",
                            'En principe, seul l’officier de police judiciaire ayant coordonné l’enquête peut être entendu en qualité ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00131",
                            'de témoin sur l’opération. Toutefois, en cas de mise en cause fondée directement sur les constatations ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00132",
                            'de l’agent infiltré, la personne comparaissant devant la juridiction de jugement (ou mise en examen) peut ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00133",
                            'demander à être confrontée avec l’agent. Les questions posées durant la confrontation ne doivent en aucun ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00134",
                            'cas remettre en cause l’anonymat de l’agent. La confrontation doit se dérouler dans les conditions prévues ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00135",
                            'par l’article ',
                          ),
                    ),
                    _lawArticle('706-61'),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00136",
                            ' du Code de procédure pénale : l’anonymat de l’agent est préservé par tout moyen (audition à distance, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00137",
                            'utilisation de dispositifs techniques permettant l’altération ou la transformation de sa voix ou de son ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/criminalite_deliquance/regles_derogatoires_criminalite_organisee_page.dart",
                            "f00138",
                            'apparence physique).',
                          ),
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
