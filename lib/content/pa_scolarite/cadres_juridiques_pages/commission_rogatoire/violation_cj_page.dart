import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaViolationControleJudiciairePage extends StatelessWidget {
  const PaViolationControleJudiciairePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/violation_cj';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);

    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);

    final lawStyle = TextStyle(
      color: Colors.red.shade700,
      fontWeight: FontWeight.w700,
    );

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
            "f00002",
            'Violation du contrôle judiciaire',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ================================================================
          // TITRE PRINCIPAL
          // ================================================================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
              "f00003",
              '3.9 — Violation des obligations du contrôle judiciaire',
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
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00004",
                  'Retenue d’une personne placée sous contrôle judiciaire (ou sous assignation ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00005",
                  'à résidence avec surveillance électronique) en cas de suspicion de ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00006",
                  'violation de ses obligations, et droits reconnus durant cette mesure.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 10),

          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00007",
                  'La retenue pour violation des obligations du contrôle judiciaire est une ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00008",
                  'mesure spécifique, distincte de la garde à vue, mais qui reprend une ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00009",
                  'grande partie des droits reconnus au gardé à vue.',
                ),
          ),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00010",
                  'La mesure est décidée et contrôlée par le juge d’instruction, qui est ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00011",
                  'immédiatement informé par l’officier de police judiciaire.',
                ),
          ),
          const SizedBox(height: 20),

          // ================================================================
          // CARTE PRINCIPALE
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
              "f00012",
              '3.9 — Retenue pour violation du contrôle judiciaire',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00013",
                    'Dans le cadre du contrôle judiciaire, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00014",
                    'l’article 141-4 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                        "f00015",
                        ' prévoit que les services de police et les unités de gendarmerie ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                        "f00016",
                        'peuvent, d’office ou sur instruction du juge d’instruction, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                        "f00017",
                        'appréhender toute personne placée sous contrôle judiciaire à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                        "f00018",
                        'l’encontre de laquelle il existe une ou plusieurs raisons plausibles ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                        "f00019",
                        'de soupçonner qu’elle a manqué à certaines obligations prévues à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00020",
                    'l’article 138 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00021",
                    ' (notamment les 1°, 2°, 3°, 8°, 9°, 14°, 17° et 17° bis).',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00022",
                      'Sur décision d’un officier de police judiciaire, cette personne peut alors ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00023",
                      'être retenue pour une durée maximale de vingt-quatre heures dans un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00024",
                      'local de police ou de gendarmerie afin que sa situation soit vérifiée et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00025",
                      'qu’elle soit entendue sur la violation de ses obligations.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00026",
                      'Dès le début de la mesure, l’officier de police judiciaire informe sans ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00027",
                      'délai le juge d’instruction.',
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00028",
                  'Information immédiate de la personne retenue',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00029",
                      'La personne retenue est immédiatement informée, par l’officier de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00030",
                      'judiciaire ou, sous son contrôle, par un agent de police judiciaire, dans ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00031",
                      'une langue qu’elle comprend, de la durée maximale de la mesure, de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00032",
                      'nature des obligations qu’elle est soupçonnée d’avoir violées, ainsi que ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00033",
                      'des droits dont elle bénéficie.',
                    ),
              ),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00034",
                  'Droits reconnus pendant la retenue',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00035",
                      'Droit de faire prévenir un proche et son employeur ainsi que, si elle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00036",
                      'est de nationalité étrangère, les autorités consulaires de l’État dont ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00037",
                      'elle est ressortissante, conformément à ',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00038",
                    'l’article 63-2 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                          "f00039",
                          'Par le renvoi à l’article 63-2 du Code de procédure pénale, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                          "f00040",
                          'personne retenue peut demander à faire prévenir, par téléphone, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                          "f00041",
                          'personne avec laquelle elle vit habituellement ou l’un de ses ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                          "f00042",
                          'parents en ligne directe, ou l’un de ses frères et sœurs, ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                          "f00043",
                          'toute autre personne qu’elle désigne, ainsi que son employeur et, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                          "f00044",
                          'le cas échéant, les autorités consulaires de son pays.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00045",
                      'Droit d’être examinée par un médecin, conformément à l’article 63-3 du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00046",
                      'Code de procédure pénale.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00047",
                    'Article 63-3 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00048",
                      'Droit d’être assistée par un avocat, conformément aux articles 63-3-1 à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00049",
                      '63-4-3 du Code de procédure pénale (droit à l’entretien confidentiel, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00050",
                      'présence lors des auditions, etc.).',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00051",
                    'Articles 63-3-1 à 63-4-3 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00052",
                      'Droit d’être assistée par un interprète, s’il y a lieu (langue qu’elle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00053",
                      'comprend).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00054",
                      'Droit, lors des auditions, après avoir décliné son identité, de faire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00055",
                      'des déclarations, de répondre aux questions qui lui sont posées ou de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00056",
                      'se taire.',
                    ),
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00057",
                    'Les pouvoirs habituellement conférés au procureur de la République par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00058",
                    'les articles 63-2 et 63-3 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                        "f00059",
                        ' sont exercés, dans le cadre de cette retenue, par le juge ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                        "f00060",
                        'd’instruction.',
                      ),
                ),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00061",
                  'Conditions d’exécution de la retenue',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00062",
                      'La retenue doit s’exécuter dans des conditions assurant le respect de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00063",
                      'dignité de la personne. Seules peuvent être imposées les mesures de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00064",
                      'sécurité strictement nécessaires.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00065",
                      'La personne retenue ne peut pas faire l’objet d’investigations corporelles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00066",
                      'internes au cours de la retenue par le service de police ou par l’unité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00067",
                      'de gendarmerie.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00068",
                    'Un procès-verbal récapitulatif de la mesure est dressé conformément à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                    "f00069",
                    'l’article 64 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                  "f00070",
                  'Issue de la mesure',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00071",
                      'À l’issue de la retenue, le juge d’instruction peut ordonner que la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00072",
                      'personne soit conduite devant lui, notamment pour envisager la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00073",
                      'révocation du contrôle judiciaire, le cas échéant en saisissant le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00074",
                      'des libertés et de la détention.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00075",
                      'Le juge d’instruction peut également demander à un officier ou à un agent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00076",
                      'de police judiciaire d’aviser la personne qu’elle est convoquée devant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00077",
                      'lui à une date ultérieure.',
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00078",
                      'Les dispositions de cet article sont également applicables aux personnes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/violation_cj_page.dart",
                      "f00079",
                      'placées sous assignation à résidence avec surveillance électronique.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TES WIDGETS PERSONNALISÉS EXACTS                     ///
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
        text ?? '',
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
