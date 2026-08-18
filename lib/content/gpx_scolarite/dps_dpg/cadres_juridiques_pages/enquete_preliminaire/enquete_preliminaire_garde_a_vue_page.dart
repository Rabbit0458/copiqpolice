import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EnquetePrelimGardeAVuePage extends StatelessWidget {
  const EnquetePrelimGardeAVuePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/enquete_preliminaire/actes/garde_a_vue';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .90);
    final Color accent = isDark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    // Couleur spécifique pour les articles de loi
    final Color lawColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
            "f00002",
            'La garde à vue',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------- TITRE GLOBAL ----------------
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
              "f00003",
              'La garde à vue en enquête préliminaire',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // ---------------- INTRO -----------------------
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                "f00004",
                'L’',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                "f00005",
                'article 77 du Code de procédure pénale',
              ),
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00006",
                    ' se rapporte à la garde à vue au cours de l’enquête préliminaire. ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00007",
                    'Il précise que les dispositions relatives à la garde à vue prévues aux ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                "f00008",
                'articles 62-2 à 64-1 du Code de procédure pénale',
              ),
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                "f00009",
                ' sont applicables à la phase d’enquête préliminaire.',
              ),
            ),
          ]),
          const SizedBox(height: 10),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00010",
                  'Une personne peut être placée en garde à vue lorsqu’il existe à son encontre ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00011",
                  'une ou plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00012",
                  'de commettre un crime ou un délit puni d’une peine d’emprisonnement, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00013",
                  'et uniquement si cette mesure constitue le seul moyen de parvenir à l’un ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00014",
                  'des six objectifs légaux de la garde à vue.',
                ),
          ),
          const SizedBox(height: 6),

          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                "f00015",
                'Ces objectifs sont définis par l’',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                "f00016",
                'article 62-2 du Code de procédure pénale',
              ),
              style: TextStyle(color: lawColor, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00017",
                    ' (préservation des preuves, prévention des pressions sur les témoins, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00018",
                    'empêchement d’une concertation frauduleuse, protection de la personne, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00019",
                    'garantie de sa présentation devant le magistrat, etc.).',
                  ),
            ),
          ]),

          const SizedBox(height: 22),

          // =====================================================
          // A. CONDITIONS DE PLACEMENT EN GARDE À VUE
          // =====================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
              "f00020",
              'A. Conditions de placement en garde à vue',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00021",
                  'Le placement en garde à vue en enquête préliminaire suppose donc :',
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00022",
                      'Des raisons plausibles de soupçonner la commission ou la tentative ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00023",
                      'de commission d’un crime ou d’un délit puni d’emprisonnement ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00024",
                      'La nécessité de la mesure pour atteindre l’un des objectifs fixés ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00025",
                      'par la loi (notamment la poursuite des investigations, la garantie de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00026",
                      'la présentation de la personne devant le magistrat, la prévention ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00027",
                      'des pressions ou concertations).',
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00028",
                          'En enquête préliminaire, la garde à vue conserve la même nature ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00029",
                          'coercitive qu’en enquête de flagrance. Elle doit toujours demeurer ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00030",
                          'strictement nécessaire et proportionnée à l’objectif recherché.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // B. LES DIFFÉRENTES HYPOTHÈSES DE MISE EN GARDE À VUE
          // =====================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
              "f00031",
              'B. Les hypothèses de mise en garde à vue',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00032",
                  '1. Présentation volontaire au service de police ou de gendarmerie',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00033",
                      'La personne peut se présenter librement (spontanément ou sur convocation) ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00034",
                      'dans un service de police ou de gendarmerie. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00035",
                      'Si, au cours de son audition, apparaissent une ou plusieurs raisons ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00036",
                      'plausibles de soupçonner qu’elle a commis ou tenté de commettre un crime ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00037",
                      'ou un délit puni d’emprisonnement, l’officier de police judiciaire peut ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00038",
                      'décider de son placement en garde à vue, à condition que cette mesure soit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00039",
                      'le seul moyen de parvenir à l’un des objectifs de l’article 62-2 du Code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00040",
                      'procédure pénale. Le point de départ du délai maximal de 24 heures est alors ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00041",
                      'l’heure du début de l’audition.',
                    ),
              ),

              const SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00042",
                  '2. Conduite sous l’effet d’un titre de contrainte ou d’une vérification d’identité',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00043",
                      'La personne peut également être conduite dans les locaux de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00044",
                      'en vertu d’un titre de contrainte (ordre de comparution délivré par le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00045",
                      'procureur de la République) ou à l’issue d’une rétention pour vérification ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00046",
                      'd’identité.',
                    ),
              ),
              const SizedBox(height: 8),

              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00047",
                  'Titre de contrainte sans raison plausible initiale de soupçon :',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00048",
                        'Lorsque la personne est contrainte à comparaître par la force publique, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00049",
                        'sans qu’il n’existe initialement de raison plausible de la soupçonner, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00050",
                        'et que, au cours de son audition, apparaissent une ou plusieurs raisons ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00051",
                        'plausibles de soupçonner qu’elle a commis ou tenté de commettre une infraction, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00052",
                        'le placement en garde à vue devient possible. La notification de la mesure ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00053",
                        'doit alors intervenir immédiatement, le point de départ du délai de garde à vue ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00054",
                        'étant fixé au début de la contrainte. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00055",
                    'Voir notamment l’article 78, alinéa 1 du Code de procédure pénale.',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00056",
                  'Titre de contrainte sur une personne déjà soupçonnée :',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00057",
                      'Lorsque des raisons plausibles de soupçonner la personne existent déjà au moment ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00058",
                      'où elle est contrainte à comparaître, elle est placée en garde à vue dès son arrivée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00059",
                      'dans le service si l’officier de police judiciaire souhaite la maintenir à sa disposition ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00060",
                      'et que l’un des six objectifs légaux est retenu.',
                    ),
              ),
              const SizedBox(height: 10),

              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00061",
                  'Rétention pour vérification d’identité :',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00062",
                        'Si la personne a été retenue pour vérification d’identité et qu’à l’issue de cette ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00063",
                        'vérification il apparaît qu’une garde à vue doit être décidée, la durée de la rétention ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00064",
                        'aux fins de vérification d’identité s’impute sur la durée totale de la garde à vue. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00065",
                    'Cette règle résulte de l’article 78-4 du Code de procédure pénale.',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]),

              const SizedBox(height: 16),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                  "f00066",
                  '3. Découverte d’indices au cours d’une perquisition',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00067",
                        'Lors d’une perquisition, une ou plusieurs raisons plausibles de soupçonner ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00068",
                        'qu’une personne a commis ou tenté de commettre une infraction peuvent apparaître ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00069",
                        'à l’égard d’une personne présente sur les lieux. Si les conditions prévues par l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00070",
                    'article 62-2 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00071",
                        ' sont réunies, cette personne peut alors être placée en garde à vue dans le cadre ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00072",
                        'de la procédure initiale ou d’une procédure incidente, y compris en enquête ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00073",
                        'préliminaire.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00074",
                        'Lorsque la personne présente lors de la perquisition est un témoin retenu sur le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00075",
                        'fondement de l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00076",
                    'article 76, alinéa 3 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00077",
                    ' (renvoyant à l’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00078",
                    'article 56, alinéa 11 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00079",
                        '), des règles particulières s’appliquent : si une garde à vue devient nécessaire, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00080",
                        'le temps de rétention lors de la perquisition est déduit de la durée de la garde à vue.',
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // C. DURÉE, PROLONGATION ET COMPÉTENCE
          // =====================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
              "f00081",
              'C. Durée, prolongation et compétence du parquet',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00082",
                    'L’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00083",
                    'article 63 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00084",
                        ' fixe les conditions et la durée de la garde à vue. En enquête préliminaire, comme ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00085",
                        'en flagrance, la durée initiale maximale est de 24 heures, renouvelable une fois ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00086",
                        'pour 24 heures supplémentaires, sur décision du procureur de la République.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00087",
                      'La prolongation doit intervenir avant l’expiration du premier délai de 24 heures. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00088",
                      'Il appartient aux magistrats d’apprécier, en fonction des circonstances de l’espèce, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00089",
                      's’il est opportun de présenter la personne avant de décider de la prolongation. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00090",
                      'Cette présentation peut, le cas échéant, être réalisée par visioconférence conformément ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00091",
                      'à l’article 706-71 du Code de procédure pénale. La décision de prolongation n’a pas à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00092",
                      'être spécialement motivée.',
                    ),
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00093",
                        'En cas d’extension de compétence, le procureur de la République du lieu ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00094",
                        'd’exécution de la mesure peut ordonner la prolongation de la garde à vue en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00095",
                        'application de l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00096",
                    'article 63-9 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00097",
                        '. Toutefois, l’officier de police judiciaire doit préalablement référer au ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00098",
                        'procureur de la République directeur d’enquête pour justifier la nécessité de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00099",
                        'prolonger la mesure.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00100",
                      'À l’issue de la garde à vue, en enquête préliminaire comme en enquête de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00101",
                      'flagrance, lorsque des éléments suffisants existent à l’encontre des personnes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00102",
                      'gardées à vue pour envisager des poursuites, celles-ci sont soit remises en liberté, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00103",
                      'éventuellement avec une convocation ultérieure, soit déférées devant le procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00104",
                      'de la République.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // D. DROITS DE LA PERSONNE GARDÉE À VUE
          // =====================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
              "f00105",
              'D. Droits de la personne gardée à vue',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00106",
                    'L’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                    "f00107",
                    'article 77 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00108",
                        ' renvoie expressément aux droits de la personne gardée à vue prévus ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                        "f00109",
                        'par plusieurs dispositions spécifiques du Code de procédure pénale :',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00110",
                      'Droit d’être immédiatement informée de la nature de l’infraction et de ses droits ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00111",
                      '(information prévue par l’',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00112",
                      'article 63-1 du Code de procédure pénale',
                    ) +
                    ').',
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00113",
                      'Droits prévus à l’',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00114",
                      'article 63-2 du Code de procédure pénale',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00115",
                      ' : faire prévenir une personne avec laquelle elle vit habituellement, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00116",
                      'un parent en ligne directe, un frère ou une sœur ou toute autre personne qu’elle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00117",
                      'désigne, ainsi que son employeur et, le cas échéant, les autorités consulaires de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00118",
                      'son pays ; droit également de communiquer avec l’une de ces personnes.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00119",
                      'Droit à un examen médical, prévu à l’',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00120",
                      'article 63-3 du Code de procédure pénale',
                    ) +
                    '.',
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00121",
                      'Droit à l’assistance d’un avocat, en application de l’',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00122",
                      'article 63-3-1 du Code de procédure pénale',
                    ) +
                    '.',
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00123",
                      'Respect des formalités prévues par l’',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00124",
                      'article 64 du Code de procédure pénale',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00125",
                      ' (procès-verbal de garde à vue) et par l’',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00126",
                      'article 64-1 du Code de procédure pénale',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00127",
                      ' (enregistrement audiovisuel des auditions en matière criminelle).',
                    ),
              ),

              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00128",
                          'En matière de criminalité organisée, les régimes dérogatoires de garde à vue ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00129",
                          'prévus aux ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                      "f00130",
                      'articles 706-88 et suivants du Code de procédure pénale',
                    ),
                    style: TextStyle(
                      color: lawColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00131",
                          ' sont étudiés dans la partie consacrée à la délinquance et à la criminalité ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00132",
                          'organisées. Les dispositions spécifiques applicables aux mineurs (garde à vue, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00133",
                          'retenue, défèrement) s’appliquent en enquête préliminaire dans les mêmes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_garde_a_vue_page.dart",
                          "f00134",
                          'conditions qu’en cas de flagrant délit.',
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
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
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
