// lib/pa/dps_dpg/cadres_juridiques/mort_inconnue/mort_inconnue_procedure.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

// Couleur dédiée pour les articles de loi
const Color _lawColor = Color(0xFFE53935);

class PaMortInconnueProcedurePage extends StatelessWidget {
  const PaMortInconnueProcedurePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/mort_inconnue/chapitre2';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);
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
            "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
            "f00001",
            'Retour',
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ====================== EN-TÊTE CHAPITRE =========================
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                  "f00003",
                  'Chapitre 2\nProcédure des articles 74 et 80-4\n',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                  "f00004",
                  'du Code de procédure pénale',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00005",
                    'Ce chapitre présente les autorités habilitées à intervenir lorsqu’une ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00006",
                    'personne est découverte décédée dans des circonstances inconnues ou ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00007",
                    'suspectes. Il précise le rôle du procureur de la République, du juge ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00008",
                    'd’instruction et des enquêteurs dans la mise en œuvre des dispositions ',
                  ) +
                  'des ',
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                "f00009",
                'articles 74 et 80-4 du Code de procédure pénale',
              ),
              style: TextStyle(color: _lawColor, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00010",
                    ', ainsi que l’articulation entre enquête dirigée par le parquet et ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00011",
                    'information judiciaire pour recherche des causes de la mort.',
                  ),
            ),
          ]),
          const SizedBox(height: 18),

          // ====================== CARTE 1 : LES AUTORITÉS HABILITÉES =======
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
              "f00012",
              '2.1 — Les autorités habilitées',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00013",
                      'Plusieurs intervenants peuvent être compétents dans le cadre de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00014",
                      'recherche des causes de la mort : les magistrats (procureur de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00015",
                      'République et juge d’instruction) et les officiers ou agents de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00016",
                      'judiciaire qui agissent, selon les cas, par délégation du parquet ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00017",
                      'sur commission rogatoire.',
                    ),
              ),
              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                  "f00018",
                  '2.1.1 — Les magistrats',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 2 : PROCUREUR ======================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
              "f00019",
              '2.1.1.1 — Le procureur de la République',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00020",
                        'En application du deuxième alinéa de l’article 74 du Code de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00021",
                        'procédure pénale, le procureur de la République, avisé ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00022",
                        'immédiatement par l’officier de police judiciaire ou, sous son ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00023",
                        'contrôle, par l’agent de police judiciaire d’une mort suspecte, ',
                      ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00024",
                        '« se rend sur place s’il le juge nécessaire et se fait assister ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00025",
                        'de personnes capables d’apprécier la nature des circonstances du décès. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00026",
                        'Il peut toutefois déléguer aux mêmes fins un officier de police judiciaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00027",
                        'de son choix »',
                      ),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: textSoft,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00028",
                      'Informé sans délai de toute découverte de cadavre dans un contexte ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00029",
                      'douteux, le procureur de la République dispose de plusieurs options :',
                    ),
              ),
              const SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00030",
                      'instrumenter lui-même en se rendant sur place et en dirigeant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00031",
                      'directement les opérations ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00032",
                      'ordonner à l’officier ou à l’agent de police judiciaire premier saisi ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00033",
                      'de poursuivre les investigations dans le cadre de l’article 74 du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00034",
                      'Code de procédure pénale ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00035",
                      'dessaisir le service initialement saisi pour confier l’enquête à un autre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00036",
                      'officier ou agent de police judiciaire de son choix ;',
                    ),
              ),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00037",
                        'requérir l’ouverture d’une information judiciaire pour recherche des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00038",
                        'causes de la mort : dans ce cas, ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00039",
                    'le juge d’instruction',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00040",
                        ' reçoit compétence pour agir sur le fondement de l’article 80-4 du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00041",
                        'Code de procédure pénale.',
                      ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 3 : JUGE D’INSTRUCTION =============
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
              "f00042",
              '2.1.1.2 — Le juge d’instruction',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00043",
                        'L’ouverture d’une information judiciaire spécifique pour recherche ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00044",
                        'des causes de la mort est prévue par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00045",
                    'l’article 74 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00046",
                        ', qui précise que le procureur de la République peut requérir ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00047",
                        'une telle information. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00048",
                    'L’article 80-4 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00049",
                        ' organise ensuite les pouvoirs du juge d’instruction dans ce cadre ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00050",
                        'particulier.',
                      ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00051",
                        'Le deuxième alinéa de l’article 80-4 prévoit que les membres de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00052",
                        'famille ou les proches de la personne décédée peuvent se constituer ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00053",
                        'partie civile à titre incident. En revanche, ils ',
                      ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00054",
                        'ne peuvent pas provoquer directement l’ouverture d’une information pour ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00055",
                        'recherche des causes de la mort',
                      ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00056",
                        ', cette prérogative demeurant réservée au procureur de la République. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00057",
                        'En cas d’inaction du parquet, la famille conserve toutefois la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00058",
                        'possibilité de déposer plainte avec constitution de partie civile en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00059",
                        'invoquant la commission d’une infraction déterminée.',
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00060",
                        'L’information ouverte sur le fondement des articles 74 et 80-4 du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00061",
                        'Code de procédure pénale présente un caractère particulier : ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00062",
                    'elle est exorbitante du droit commun',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00063",
                        ' car elle a pour seul but la recherche des causes de la mort et ne ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00064",
                        'saisit pas le juge de l’ensemble des faits. Elle ne met pas, à ce ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00065",
                        'stade, en mouvement l’action publique.',
                      ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00066",
                        'Le juge d’instruction dispose, dans ce cadre, de tous les pouvoirs ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00067",
                        'propres à l’instruction préparatoire ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00068",
                    '(article 80-4 du Code de procédure pénale)',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00069",
                        ', sous une réserve importante : la durée des interceptions de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00070",
                        'correspondances émises par la voie des communications électroniques ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00071",
                        'est limitée à deux mois renouvelables.',
                      ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00072",
                        'Le juge d’instruction conserve par ailleurs la faculté de déléguer, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00073",
                        'par commission rogatoire, à un officier de police judiciaire les actes ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00074",
                        'nécessaires à la recherche des causes de la mort. Dans ce cas, les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00075",
                        'enquêteurs agissent dans le cadre de la commission rogatoire, sous le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00076",
                        'contrôle du magistrat instructeur.',
                      ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== CARTE 4 : OPJ / APJ ======================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
              "f00077",
              '2.1.2 — L’officier ou l’agent de police judiciaire',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00078",
                      'L’officier de police judiciaire, ou l’agent de police judiciaire agissant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00079",
                      'sous son contrôle, peut se voir déléguer les pouvoirs du procureur de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00080",
                      'République pour déterminer les causes de la mort. Il conduit alors les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00081",
                      'investigations de terrain (constatations, auditions, réquisitions, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00082",
                      'examens techniques) dans le cadre fixé par le parquet.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00083",
                        'Lorsque le juge d’instruction est saisi d’une information pour ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00084",
                        'recherche des causes de la mort, l’officier de police judiciaire peut ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00085",
                        'également être commis par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                    "f00086",
                    'commission rogatoire',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00087",
                        '. Il agit alors au nom du juge d’instruction, dans les limites de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00088",
                        'mission définie par la commission, et doit lui rendre compte des actes ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                        "f00089",
                        'effectués et des résultats obtenus.',
                      ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== NOTA FINAL ===============================
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00090",
                      'La bonne compréhension de la répartition des rôles entre procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00091",
                      'de la République, juge d’instruction et enquêteurs est essentielle. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00092",
                      'Elle conditionne la régularité des actes accomplis et la validité des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00093",
                      'éléments recueillis en vue, le cas échéant, de l’ouverture ultérieure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00094",
                      'd’une véritable procédure pénale pour homicide ou violences ayant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/mort_inconnue/mort_inconnue_procedure.dart",
                      "f00095",
                      'entraîné la mort.',
                    ),
              ),
            ],
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

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text}) : rich = null;

  const _BulletPoint.rich(this.rich) : text = null;

  final String? text;
  final List<TextSpan>? rich;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    Widget child;

    if (rich != null) {
      child = RichText(
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.35,
            color: textColor,
          ),
          children: rich!,
        ),
      );
    } else {
      child = Text(
        text ?? '',
        style: GoogleFonts.fustat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.35,
          color: textColor,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Expanded(child: child),
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
