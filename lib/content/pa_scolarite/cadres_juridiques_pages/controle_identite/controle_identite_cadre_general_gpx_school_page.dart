import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaConntroleIdentiteCadreGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteCadreGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/cadre_general';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .72);

    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F5F5);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color articleColor = isDark
        ? const Color(0xFFFF8A80)
        : const Color(0xFFC62828);

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
            "f00002",
            'Cadre général du contrôle',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ===================== TITRE & INTRO RAPIDE ======================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
              "f00003",
              'Cadre général du contrôle d’identité',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00004",
                  'Personnes concernées, autorités habilitées, distinction entre les différents ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00005",
                  'cas dans lesquels le policier peut procéder à un contrôle d’identité en ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00006",
                  'matière de police judiciaire.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1.1 CADRE GÉNÉRAL DU CONTRÔLE =============
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
              "f00007",
              '1.1 – Cadre général du contrôle',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00008",
                  '1.1.1 – Les personnes concernées',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00009",
                        'Le contrôle d’identité vise toute personne qui se trouve sur le territoire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00010",
                        'national. Tel est le principe énoncé par l’article ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                    "f00011",
                    '78-1 du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00012",
                        '. L’identité d’un ressortissant étranger peut donc être contrôlée dans les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00013",
                        'mêmes conditions que celle d’un citoyen français.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00014",
                  '1.1.2 – Les autorités habilitées à procéder à un contrôle',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00015",
                        'Seuls les officiers de police judiciaire et, sur l’ordre et sous la responsabilité ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00016",
                        'de ceux-ci, les agents de police judiciaire et certains agents de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00017",
                        'judiciaire adjoints visés à l’article 21, 1° du ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                    "f00018",
                    'code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00019",
                        ', sont habilités à procéder à des contrôles d’identité. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00020",
                        'Sont donc exclus les volontaires servant en qualité de militaire dans la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00021",
                        'gendarmerie et les militaires servant au titre de la réserve opérationnelle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00022",
                        'de la gendarmerie, les agents de police municipale (article 21, 2°), les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00023",
                        'policiers adjoints et les membres de la réserve opérationnelle de la police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00024",
                        'nationale (article 21, 1° ter), ainsi que les fonctionnaires et agents chargés ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00025",
                        'de certaines fonctions de police judiciaire dans des domaines très ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00026",
                        'spécifiques : agents des eaux et forêts, gardes champêtres, gardes ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                        "f00027",
                        'particuliers, conformément aux articles 22 à 29 du ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                    "f00028",
                    'code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00029",
                      'L’exigence « sur l’ordre » énoncée à l’article 78-2 du code de procédure pénale ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00030",
                      'ne signifie pas que l’agent de police judiciaire ou l’agent de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00031",
                      'adjoint soit dans l’obligation de solliciter systématiquement une autorisation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00032",
                      'préalable d’un officier de police judiciaire. Cette formule rappelle leur mission : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00033",
                      'seconder les officiers de police judiciaire dans l’exercice de leurs fonctions et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00034",
                      'agir sous leurs ordres. En revanche, la mention « sur l’ordre et sous la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00035",
                      'responsabilité de l’officier de police judiciaire » doit obligatoirement figurer, à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00036",
                      'peine de nullité du contrôle, sur le rapport ou sur le procès-verbal établi.',
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                          "f00037",
                          'Pour les agents de police judiciaire adjoints, se reporter au chapitre 2 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                          "f00038",
                          'consacré au relevé d’identité.',
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2 CAS OÙ LE POLICIER PEUT CONTRÔLER =====
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
              "f00039",
              '1.2 – Cas dans lesquels le policier peut procéder à un contrôle d’identité',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00040",
                      'Selon les termes de l’article 78-2 du code de procédure pénale, il convient de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00041",
                      'distinguer les contrôles qui se pratiquent en matière de police judiciaire et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00042",
                      'ceux qui interviennent dans des situations de police administrative visant à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00043",
                      'prévenir les atteintes à la sécurité des personnes et des biens.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00044",
                  '1.2.1 – Les contrôles relevant de la police judiciaire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00045",
                      'Le premier alinéa de l’article 78-2 du code de procédure pénale fixe le régime ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00046",
                      'des contrôles effectués sur la seule initiative des policiers.',
                    ),
              ),
              SizedBox(height: 6),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00047",
                  '1.2.1.1 – Les contrôles de police judiciaire effectués à la seule initiative des policiers',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00048",
                      'Le contrôle d’identité d’une personne est possible lorsqu’il existe une ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00049",
                      'plusieurs raisons plausibles de soupçonner qu’elle se trouve dans l’un des cinq ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00050",
                      'cas expressément prévus. Ces raisons plausibles doivent être matérialisées par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00051",
                      'les agissements de l’intéressé, son comportement et sa façon d’être dans un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00052",
                      'certain contexte (fuite devant les policiers, passages répétés de nuit devant la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00053",
                      'vitrine d’une bijouterie, attitude laissant présumer l’usage de stupéfiants, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00054",
                      'dissimulation d’un sac à la vue des policiers, etc.).',
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00055",
                      'La personne a commis ou tenté de commettre une infraction (article 78-2 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00056",
                      'alinéa 2 du code de procédure pénale), qu’il s’agisse d’un crime, d’un délit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00057",
                      'ou d’une contravention.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00058",
                      'Elle se prépare à commettre un crime ou un délit (article 78-2 alinéa 3 du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00059",
                      'code de procédure pénale). Le contrôle est alors possible dès la phase des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00060",
                      'actes préparatoires, même si ceux-ci ne suffisent pas à caractériser une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00061",
                      'tentative punissable.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00062",
                      'Elle est susceptible de fournir des renseignements utiles à l’enquête en cas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00063",
                      'de crime ou de délit (article 78-2 alinéa 4 du code de procédure pénale).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00064",
                      'Elle a violé les obligations ou interdictions auxquelles elle est soumise dans ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00065",
                      'le cadre d’un contrôle judiciaire, d’une mesure d’assignation à résidence ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00066",
                      'avec surveillance électronique, d’une peine ou d’une mesure suivie par le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00067",
                      'juge de l’application des peines (article 78-2 alinéa 5 du code de procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00068",
                      'pénale).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00069",
                      'Elle fait l’objet de recherches ordonnées par une autorité judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00070",
                      '(article 78-2 alinéa 6 du code de procédure pénale), notamment sur la base ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00071",
                      'de mandats ou décisions émanant du parquet, d’une juridiction d’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00072",
                      'ou de jugement ou du juge des enfants.',
                    ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                          "f00073",
                          'Les contrôles d’identité peuvent également être mis en œuvre lorsque des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                          "f00074",
                          'recherches sont ordonnées par les officiers de police judiciaire au cours ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                          "f00075",
                          'de leurs enquêtes à l’égard de personnes soupçonnées d’infraction ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                          "f00076",
                          'susceptibles de fournir des renseignements utiles à l’enquête.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00077",
                  '1.2.1.2 – Les contrôles effectués sur réquisitions du procureur de la République',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                  "f00078",
                  'Pour réaliser ce type de contrôle, plusieurs conditions doivent être respectées.',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00079",
                      'Le procureur de la République doit donner des réquisitions écrites qui ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00080",
                      'précisent les infractions à rechercher, afin d’éviter que le contrôle ne soit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00081",
                      'déclenché de façon aléatoire.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00082",
                      'Les réquisitions sont en général prises à la suite de constatations ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00083",
                      'd’infractions répétées ou à partir de renseignements laissant supposer que ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00084",
                      'la commission de ces infractions est probable (trafic de stupéfiants, recel, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00085",
                      'proxénétisme, infractions à la législation sur l’entrée et le séjour des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00086",
                      'étrangers, etc.).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00087",
                      'Les contrôles doivent être effectués dans des lieux et sur une période de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00088",
                      'temps déterminés par le magistrat, ce qui implique un périmètre précis et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00089",
                      'des horaires de début et de fin de l’opération.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00090",
                      'Les contrôles s’appuient sur une concertation parquet-police : le procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00091",
                      'de la République décide de l’opportunité de l’opération, mais la définition ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00092",
                      'concrète des lieux, des périodes et des moyens se fait en lien étroit avec ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00093",
                      'les services de police.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00094",
                      'Les contrôles visent « toute personne » présente dans le périmètre et sur la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00095",
                      'durée fixés par les réquisitions. En pratique, le policier doit veiller à éviter ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00096",
                      'toute méthode de sélection pouvant apparaître comme discriminatoire et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/controle_identite/controle_identite_cadre_general_gpx_school_page.dart",
                      "f00097",
                      'adapter le contrôle aux infractions recherchées.',
                    ),
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
