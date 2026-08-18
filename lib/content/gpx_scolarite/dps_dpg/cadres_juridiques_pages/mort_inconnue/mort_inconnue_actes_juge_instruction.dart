// lib/gpx_scolarite_pages/cadres_juridiques/mort_inconnue/mort_inconnue_actes_juge_instruction.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

const Color _lawColor = Color(0xFFE53935);

class MortInconnueActesJugeInstructionPage extends StatelessWidget {
  const MortInconnueActesJugeInstructionPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/mort_inconnue/actes_juge_instruction';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
            "f00001",
            'Retour',
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
            "f00002",
            'Mort de cause inconnue',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================================================================
          //                           TITRE PAGE
          // ================================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
              "f00003",
              'Les actes délégués par le juge d’instruction',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: textMain,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                "f00004",
                'Dans le cadre d’une information judiciaire ouverte pour recherche des causes de la mort, ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                "f00005",
                'l’article 80-4 du Code de procédure pénale',
              ),
              style: TextStyle(color: _lawColor, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00006",
                    ' permet au juge d’instruction, lorsqu’il est dans l’impossibilité de ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00007",
                    'procéder lui-même à tous les actes d’instruction, de déléguer par commission rogatoire ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00008",
                    'l’exécution de certains actes à un officier de police judiciaire.',
                  ),
            ),
          ]),
          const SizedBox(height: 18),

          // ================================================================
          //                 1. DÉLÉGATION PAR COMMISSION ROGATOIRE
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
              "f00009",
              '1. Délégation par commission rogatoire',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                      "f00010",
                      'Lorsque le juge d’instruction est saisi d’une information pour recherche des causes de la mort ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                      "f00011",
                      'et qu’il ne peut matériellement accomplir tous les actes lui-même, il peut donner commission ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                      "f00012",
                      'rogatoire à un officier de police judiciaire afin de réaliser les actes nécessaires à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                      "f00013",
                      'manifestation de la vérité.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00014",
                  'Dans ce cadre, l’officier de police judiciaire peut réaliser notamment :',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00015",
                  'Des constatations sur les lieux et sur le corps de la personne décédée.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00016",
                  'Des perquisitions dans les lieux utiles à la compréhension des circonstances de la mort.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00017",
                  'Des saisies et la mise sous scellés des objets, documents ou données informatiques utiles.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00018",
                  'Des réquisitions à des personnes qualifiées (médecins, experts techniques, etc.).',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00019",
                  'Des auditions des témoins et des personnes concernées.',
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00020",
                        'Sous l’autorité et le contrôle du juge d’instruction, des interceptions de correspondances ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00021",
                        'émises par la voie des communications électroniques peuvent également être réalisées, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00022",
                        'mais pour une durée maximale de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00023",
                    'deux mois renouvelable',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00024",
                    ', dans les limites posées par le Code de procédure pénale.',
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //      2. GARDE À VUE & OUVERTURE D’UNE INFORMATION « INFRACTION »
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
              "f00025",
              '2. Garde à vue et ouverture d’une information pour infraction',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00026",
                        'Dans le cadre d’une information pour recherche des causes de la mort, la garde à vue reste strictement encadrée. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00027",
                        'Selon la circulaire n° Crim-02-16-E8-08.11.02 du Ministère de la Justice :\n\n',
                      ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00028",
                        '« Le placement en garde à vue ne peut toutefois intervenir qu’à l’encontre des personnes ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00029",
                        'contre lesquelles il existe une ou plusieurs raisons plausibles de soupçonner qu’elles ont ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00030",
                        'commis une infraction, ce qui peut ensuite justifier la délivrance d’un réquisitoire introductif ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00031",
                        'ouvrant une information relative à l’infraction ainsi découverte et permettant alors dans le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00032",
                        'cadre de cette information, de procéder le cas échéant à des mises en examen et des placements ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00033",
                        'en détention provisoire. »',
                      ),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00034",
                  'La garde à vue n’est possible que si une infraction est suspectée à l’encontre d’une personne déterminée.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00035",
                  'Cette infraction donne alors lieu à un réquisitoire introductif spécifique, qui ouvre une nouvelle information pénale.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00036",
                  'Dans ce second cadre (information pour infraction), le juge d’instruction peut procéder à des mises en examen ou requérir la détention provisoire si les conditions sont réunies.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //               3. RÔLE DES AGENTS DE POLICE JUDICIAIRE
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
              "f00037",
              '3. Rôle des agents de police judiciaire et assistants d’enquête',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                      "f00038",
                      'Les agents de police judiciaire peuvent, sous le contrôle de l’officier de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                      "f00039",
                      'commis par le juge d’instruction, participer activement à certains actes techniques, en particulier ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                      "f00040",
                      'en matière informatique et de communications électroniques.',
                    ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00041",
                  'Accès aux données informatiques au cours d’une perquisition',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00042",
                    'Au cours d’une perquisition, les agents de police judiciaire peuvent, sous le contrôle de l’officier de police judiciaire, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00043",
                    'accéder à des données informatiques stockées sur des serveurs distants ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00044",
                    'conformément aux ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00045",
                    'articles 97-1 et 57-1 du Code de procédure pénale (alinéa 1)',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00046",
                        ', et requérir toute personne susceptible d’avoir connaissance des mesures de protection de ces données ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                        "f00047",
                        'ou de pouvoir fournir des informations permettant d’y accéder.',
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00048",
                  'Préservation du contenu des communications électroniques',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00049",
                    'Les agents de police judiciaire peuvent également, toujours sous le contrôle de l’officier de police judiciaire, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00050",
                    'requérir les opérateurs de télécommunications afin qu’ils prennent, sans délai, toutes mesures propres à assurer la préservation du contenu des informations consultées ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00051",
                    'par les utilisateurs de leurs services, conformément aux ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00052",
                    'articles 99-4 et 60-2, alinéa 2, du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                  "f00053",
                  'Interceptions et transcription des communications électroniques',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00054",
                    'Les agents de police judiciaire peuvent aussi, sous le contrôle de l’officier de police judiciaire commis par le juge d’instruction, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00055",
                    'procéder aux réquisitions nécessaires à l’installation d’un dispositif d’interception des communications électroniques ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00056",
                    'et à la transcription de la correspondance utile à la manifestation de la vérité, dans le respect des ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00057",
                    'articles 100-3 à 100-5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00058",
                    'Les assistants d’enquête peuvent, à la demande expresse et sous le contrôle de l’officier de police judiciaire commis par le juge d’instruction, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00059",
                    'participer à la transcription de la correspondance utile à la manifestation de la vérité ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00060",
                    ', conformément à l’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                    "f00061",
                    'article 100-5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                          "f00062",
                          'Tous ces actes demeurent strictement placés sous le contrôle du juge d’instruction et de l’officier de police judiciaire commis. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_juge_instruction.dart",
                          "f00063",
                          'Les agents de police judiciaire et assistants d’enquête interviennent uniquement sur délégation expresse et dans le respect du cadre légal.',
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

////////////////////////////////////////////////////////////////////////////////
//                        WIDGETS PERSONNALISÉS
////////////////////////////////////////////////////////////////////////////////

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
    return Container(
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
    final Color color = Theme.of(context).brightness == Brightness.dark
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

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w500,
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
