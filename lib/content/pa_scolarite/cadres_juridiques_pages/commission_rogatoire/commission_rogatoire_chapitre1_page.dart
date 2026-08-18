// lib/pa/dps_dpg/cadres_juridiques/commission_rogatoire_chapitre1_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaCommissionRogatoireChapitre1Page extends StatelessWidget {
  const PaCommissionRogatoireChapitre1Page({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/chapitre1';

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

    final Color cardGreen = isDark
        ? const Color(0xFF0F2416)
        : const Color(0xFFE8F5E9);
    const cardGreenAccent = Color(0xFF2E7D32);

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
            "f00002",
            'Commission rogatoire — Chapitre 1',
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
          // ==================================================================
          // TITRE PRINCIPAL
          // ==================================================================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00003",
              'Chapitre 1\nLes autorités délégantes et les autorités délégataires',
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
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00004",
                  'Origine de la commission rogatoire, juridictions habilitées à la délivrer ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00005",
                  'et services de police ou de gendarmerie chargés de son exécution.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 14),

          // ==================================================================
          // PETIT RÉSUMÉ SOUS FORME DE PUCE D'INTRO
          // ==================================================================
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00006",
              'Les juridictions d’instruction et de jugement peuvent délivrer une commission rogatoire.',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00007",
              'En pratique, la plupart des commissions rogatoires émanent du juge d’instruction.',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00008",
              'L’exécution revient aux officiers de police judiciaire, dans les limites de leurs compétences matérielle et territoriale.',
            ),
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // 1.1 — LES AUTORITÉS DÉLÉGANTES
          // ==================================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00009",
              '1.1 — Les autorités délégantes',
            ),
          ),
          const SizedBox(height: 4),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00010",
                  'Toute juridiction d’instruction ou de jugement dispose du pouvoir de délivrer ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00011",
                  'une commission rogatoire. Il s’agit notamment : du juge d’instruction ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00012",
                  '(article 81 du Code de procédure pénale — CPP), de la chambre de ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00013",
                  'l’instruction (article 205 CPP), du tribunal de police (article 538 CPP), ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00014",
                  'du tribunal correctionnel (article 463 CPP), du président de la cour ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00015",
                  'd’assises (article 283 CPP) et du président de la cour criminelle ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00016",
                  'départementale (article 380-19 CPP).',
                ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00017",
                  'En pratique, la situation la plus courante demeure celle où la commission ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00018",
                  'rogatoire émane du juge d’instruction, dans le cadre d’une information ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00019",
                  'judiciaire qu’il dirige.',
                ),
          ),
          const SizedBox(height: 10),

          // EXEMPLE / CITATION ARTICLE 81 AL. 4 CPP
          _ExempleBox(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00020",
              'Article 81 alinéa 4 du Code de procédure pénale',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00021",
                      'Lorsque le juge d’instruction ne peut pas accomplir lui-même tous les actes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00022",
                      'nécessaires à l’information, il peut donner commission rogatoire aux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00023",
                      'officiers de police judiciaire afin qu’ils exécutent, pour son compte, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00024",
                      'les actes d’information nécessaires dans les conditions et sous les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00025",
                      'réserves prévues aux articles 151 et 152 du Code de procédure pénale.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // CIRCULAIRE 1er MARS 1993 -> EXEMPLE
          _ExempleBox(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00026",
              'Circulaire du 1er mars 1993 (extrait)',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00027",
                      'La circulaire précise que la possibilité de délivrer une commission ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00028",
                      'rogatoire est réservée aux situations où il est réellement impossible ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00029",
                      'pour le juge d’instruction d’agir lui-même. Il peut s’agir, par exemple, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00030",
                      'd’opérations qui, en pratique, sont réalisées par les officiers de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00031",
                      'police judiciaire (missions de surveillance, de recherche, filatures) ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00032",
                      'ou d’actes nécessitant des moyens matériels dont le magistrat ne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00033",
                      'dispose pas.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // 1.2 — LES AUTORITÉS DÉLÉGATAIRES
          // ==================================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00034",
              '1.2 — Les autorités délégataires',
            ),
          ),
          const SizedBox(height: 4),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                "f00035",
                'L’article 151 alinéa 1 du Code de procédure pénale ',
              ),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                    "f00036",
                    'prévoit que le juge d’instruction peut, par commission rogatoire, requérir ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                    "f00037",
                    'tout juge de son tribunal, tout autre juge d’instruction ou tout officier ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                    "f00038",
                    'de police judiciaire, lequel en informe alors le procureur de la République, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                    "f00039",
                    'afin de procéder aux actes d’information nécessaires dans les lieux où ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                    "f00040",
                    'chacun d’eux est territorialement compétent.',
                  ),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00041",
                  'En pratique policière, on retient surtout que tous les officiers de police ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00042",
                  'judiciaire du ressort d’un même tribunal ont vocation à exécuter les ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00043",
                  'commissions rogatoires, sous réserve du respect de leurs compétences ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00044",
                  'territoriales et des instructions données par le magistrat.',
                ),
          ),
          const SizedBox(height: 10),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00045",
                  'Le juge d’instruction dispose d’une liberté de choix quant à la formation ou au ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00046",
                  'service chargé d’exécuter la commission rogatoire (article D.2 alinéa 3 CPP). ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00047",
                  'Il doit toutefois tenir compte de la spécialisation de certains services ou ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00048",
                  'directions (par exemple, la direction nationale de la police judiciaire, la ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00049",
                  'direction nationale de la police aux frontières – article D.4 CPP). Le choix du ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00050",
                  'service exécutant dépend donc des circonstances de l’affaire.',
                ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00051",
                  'En raison de la hiérarchisation des services de police et de gendarmerie, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00052",
                  'l’article D.33 du Code de procédure pénale précise que lorsque le juge ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00053",
                  'd’instruction adresse une commission rogatoire à un officier de police ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00054",
                  'judiciaire chef de service ou de détachement, celui-ci peut en confier ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00055",
                  'l’exécution à un autre officier de police judiciaire placé sous son autorité, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00056",
                  'à condition que ce dernier agisse dans les limites de sa compétence territoriale.',
                ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00057",
                  'La circulaire du 1er mars 1993 admet que, pour une même affaire, le juge ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00058",
                  'd’instruction puisse délivrer plusieurs commissions rogatoires à différents ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00059",
                  'services de police ou de gendarmerie, lorsque des vérifications distinctes ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00060",
                  'doivent être menées dans des lieux différents et selon des diligences bien ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00061",
                  'séparées.',
                ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00062",
                  'Seuls les officiers de police judiciaire peuvent recevoir directement une ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00063",
                  'commission rogatoire. Cependant, les agents de police judiciaire et les ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00064",
                  'assistants d’enquête peuvent, sous certaines conditions, être chargés par les ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00065",
                  'officiers de police judiciaire d’exécuter certains actes dans le cadre de cette ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                  "f00066",
                  'délégation.',
                ),
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // BLOC 1.2.1 — COMPÉTENCE MATÉRIELLE (ConditionCard + BulletPoint)
          // ==================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00067",
              '1.2.1 — Compétence matérielle des officiers de police judiciaire',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                    "f00068",
                    'Base légale : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                        "f00069",
                        'article 151 du Code de procédure pénale. L’officier de police judiciaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                        "f00070",
                        'exécute, sur commission rogatoire, les actes d’information nécessaires ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                        "f00071",
                        'qui lui sont délégués par le juge d’instruction.',
                      ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00072",
                      'Les actes d’instruction réalisés doivent être directement liés à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00073",
                      'répression de l’infraction visée par les poursuites (article 151 alinéa 3 CPP).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00074",
                      'L’officier de police judiciaire ne peut pas interroger ni confronter une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00075",
                      'personne mise en examen. Il ne peut entendre les parties civiles ni les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00076",
                      'témoins assistés que si ces derniers en font eux-mêmes la demande ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00077",
                      '(article 152 alinéa 2 CPP).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00078",
                      'L’officier de police judiciaire ne peut ni ordonner une expertise, ni ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00079",
                      'délivrer des mandats : ces prérogatives demeurent réservées au magistrat.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // BLOC 1.2.2 — COMPÉTENCE TERRITORIALE (ConditionCard + IntroBullet)
          // ==================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
              "f00080",
              '1.2.2 — Compétence territoriale des officiers de police judiciaire',
            ),
            cardColor: cardGreen,
            accent: cardGreenAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                    "f00081",
                    'Article 18 alinéa 1 du Code de procédure pénale : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                        "f00082",
                        'les officiers de police judiciaire sont compétents dans les limites ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                        "f00083",
                        'territoriales où ils exercent habituellement leurs fonctions.',
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00084",
                      'L’article 18 alinéa 3 étend la compétence territoriale d’un officier de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00085",
                      'police judiciaire à l’ensemble du territoire national, à condition qu’il ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00086",
                      'en informe au préalable le juge d’instruction en charge de l’enquête. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00087",
                      'Cette information peut être donnée par tout moyen et doit être mentionnée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00088",
                      'dans un procès-verbal.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00089",
                      'Le juge peut exiger que les enquêteurs soient assistés par un officier de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00090",
                      'police judiciaire territorialement compétent. À défaut d’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00091",
                      'expresse, il appartient aux enquêteurs d’apprécier si cette assistance ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00092",
                      'est nécessaire.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00093",
                      'Aucune information préalable n’est requise lorsque le déplacement a lieu ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00094",
                      'dans un ressort limitrophe de celui où l’officier exerce ses fonctions. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00095",
                      'Paris et les départements des Hauts-de-Seine, de Seine-Saint-Denis et du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00096",
                      'Val-de-Marne sont, à ce titre, considérés comme un seul et même ressort.',
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00097",
                      'L’article 18 alinéa 4 permet en outre aux officiers de police judiciaire, sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00098",
                      'commission rogatoire expresse du juge d’instruction et avec l’accord des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00099",
                      'autorités compétentes, de procéder à des auditions sur le territoire d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00100",
                      'État étranger. Dans ce cas, leur compétence est limitée à l’infraction pour ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00101",
                      'laquelle ils ont été initialement saisis.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00102",
                      'Le procureur de la République territorialement compétent doit être informé de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00103",
                      'ces opérations internationales. En pratique, cette information est souvent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00104",
                      'transmise par l’officier de police judiciaire lui-même, même si elle émane ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00105",
                      'à l’origine du magistrat ayant prescrit l’acte.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ==================================================================
          // NOTA / INFO FINALE (APJ, APJ adjoints, assistants d'enquête)
          // ==================================================================
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00106",
                      'seuls les officiers de police judiciaire sont compétents pour mettre en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00107",
                      'œuvre une commission rogatoire. Cependant, les agents de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00108",
                      'judiciaire et les agents de police judiciaire adjoints peuvent les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00109",
                      'assister dans les limites territoriales où les officiers exercent leurs ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00110",
                      'attributions (article 21-1 CPP). Les assistants d’enquête peuvent eux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00111",
                      'aussi être chargés, par les officiers de police judiciaire, de certaines ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00112",
                      'tâches matérielles ou techniques dans le cadre de l’exécution de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre1_page.dart",
                      "f00113",
                      'commission rogatoire (article 21-3 CPP).',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// ======================================================================
///  WIDGETS UTILISÉS DANS LA PAGE
/// ======================================================================

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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (1., 2., 3. …)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE D’INTRO
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

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

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
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
