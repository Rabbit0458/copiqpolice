import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaRequisitionsPage extends StatelessWidget {
  const PaRequisitionsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/commission_rogatoire/requisitions';

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

    final Color cardIndigo = isDark
        ? const Color(0xFF1A1533)
        : const Color(0xFFEDE7F6);
    const cardIndigoAccent = Color(0xFF4527A0);

    final Color cardTeal = isDark
        ? const Color(0xFF00363A)
        : const Color(0xFFE0F2F1);
    const cardTealAccent = Color(0xFF00695C);

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
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
            "f00002",
            'Réquisitions',
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
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
              "f00003",
              '3.8 — Les réquisitions',
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
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00004",
                  'Réquisitions sur commission rogatoire : réquisitions d’ordre général, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00005",
                  'réquisitions informatiques et téléphoniques, géolocalisation en temps réel ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00006",
                  'et interceptions de correspondances par la voie des communications ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00007",
                  'électroniques.',
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
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00008",
                  'Sur commission rogatoire, les réquisitions se font toujours sous le contrôle ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00009",
                  'du juge d’instruction et dans le respect des règles de fond et de forme ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00010",
                  'propres à l’information judiciaire.',
                ),
          ),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00011",
                  'Dès qu’une question d’ordre technique se pose, le juge d’instruction peut ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00012",
                  'ordonner une expertise et non de simples réquisitions techniques.',
                ),
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.8 — PRINCIPE GÉNÉRAL + 3.8.1 / 3.8.2
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
              "f00013",
              '3.8 — Principe général et réquisitions d’ordre général / informatiques',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00014",
                        'Sur commission rogatoire, les officiers de police judiciaire, les agents ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00015",
                        'de police judiciaire et les assistants d’enquête ne peuvent pas adresser ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00016",
                        'de réquisitions aux fins de constatations ou d’examens techniques ou ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00017",
                        'scientifiques telles qu’elles sont prévues en flagrant délit ou en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00018",
                        'enquête préliminaire par les ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00019",
                    'articles 60 et 77-1 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00020",
                        '. Lorsque se pose une question d’ordre technique, le juge ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00021",
                        'd’instruction ordonne une expertise, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00022",
                    'l’article 156 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00023",
                  '3.8.1 — Les réquisitions d’ordre général',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00024",
                        'Sur commission rogatoire générale ou spéciale, l’officier de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00025",
                        'judiciaire peut, par tout moyen, requérir de toute personne, de tout ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00026",
                        'établissement ou organisme privé ou public ou de toute administration ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00027",
                        'publique qui sont susceptibles de détenir des documents intéressant ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00028",
                        'l’instruction, y compris, sous réserve des limites imposées par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00029",
                    'l’article 60-1-2 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00030",
                        ', ceux issus d’un système informatique ou d’un traitement de données ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00031",
                        'nominatives, afin qu’il lui soit remis ces documents, notamment sous ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00032",
                        'forme numérique, sans qu’il puisse lui être opposé, sans motif légitime, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00033",
                        'le secret professionnel.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00034",
                    'Ces réquisitions d’ordre général sont prévues par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00035",
                    'l’article 99-3 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00036",
                        '. Pour ces réquisitions « générales », l’officier de police judiciaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00037",
                        'commis par le juge d’instruction dispose des mêmes prérogatives que ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00038",
                        'celles définies par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00039",
                    'l’article 60-1 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00040",
                    ' en matière de flagrant délit.',
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00041",
                  '3.8.2 — Les réquisitions informatiques et téléphoniques',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00042",
                        'Sur commission rogatoire, l’officier de police judiciaire peut procéder ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00043",
                        'aux réquisitions prévues par le premier alinéa de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00044",
                    'l’article 60-2 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00045",
                        ' : les organismes publics ou les personnes morales de droit privé, à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00046",
                        'l’exception de certains organismes spécialement protégés par le droit ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00047",
                        'européen et la loi Informatique et libertés, doivent mettre à la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00048",
                        'disposition de l’enquête les informations utiles à la manifestation de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00049",
                        'la vérité, à l’exception de celles protégées par un secret prévu par la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00050",
                        'loi, sous réserve des limites fixées par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00051",
                    'l’article 60-1-2 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00052",
                        ', contenues dans les systèmes informatiques ou traitements de données ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00053",
                        'nominatives qu’ils administrent.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00054",
                        'Avec l’autorisation expresse du juge d’instruction, l’officier de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00055",
                        'judiciaire ou, sous son contrôle, l’agent de police judiciaire peut aussi ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00056",
                        'mettre en œuvre les réquisitions prévues par le deuxième alinéa de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00057",
                    'l’article 60-2 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00058",
                        ', en requérant les opérateurs de télécommunications, notamment ceux ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00059",
                        'mentionnés par la loi du 21 juin 2004 pour la confiance dans ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00060",
                        'l’économie numérique, afin de prendre toutes mesures propres à assurer, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00061",
                        'sans délai, la préservation pour une durée maximale d’un an du contenu ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00062",
                        'des informations consultées par les utilisateurs.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00063",
                        'Avec la même autorisation expresse du juge d’instruction, l’officier de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00064",
                        'police judiciaire ou, sous son contrôle, l’agent de police judiciaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00065",
                        'ou l’assistant d’enquête peut procéder aux réquisitions prévues par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00066",
                    'l’article 60-3 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00067",
                        '. Il peut alors requérir toute personne qualifiée inscrite sur l’une ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00068",
                        'des listes d’experts prévues à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00069",
                    'l’article 157 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00070",
                    ' ou ayant prêté serment conformément à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00071",
                    'l’article 60 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00072",
                        ' pour ouvrir des scellés supportant des données informatiques, en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00073",
                        'réaliser des copies ou effectuer les opérations techniques nécessaires ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00074",
                        'pour les mettre à disposition de l’enquête sans en altérer l’intégrité.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00075",
                        'Ces opérations peuvent également être réalisées par les services ou ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00076",
                        'organismes de police technique et scientifique de la police nationale ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00077",
                        'ou de la gendarmerie nationale, sans qu’il soit nécessaire d’établir ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00078",
                        'une réquisition ni qu’ils prêtent serment. Les opérations réalisées ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00079",
                        'font l’objet d’un rapport établi conformément aux ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00080",
                    'articles 163 et 166 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.8.3 — GÉOLOCALISATION
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
              "f00081",
              '3.8.3 — La géolocalisation en temps réel',
            ),
            cardColor: cardIndigo,
            accent: cardIndigoAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF311B92),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00082",
                        'Des réquisitions peuvent viser à suivre en temps réel, et à l’insu de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00083",
                        'la personne, les déplacements d’une personne, d’un véhicule ou d’un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00084",
                        'objet (suivi d’un terminal de télécommunication ou utilisation d’une ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00085",
                        'balise de géolocalisation). Ces techniques sont encadrées par les ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00086",
                    'articles 230-32 à 230-44 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00087",
                        ', dans les mêmes conditions qu’en enquête de flagrance ou préliminaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00088",
                        'pour les crimes et délits punis d’au moins trois ans d’emprisonnement.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00089",
                      'Le recours à cette technique n’est pas limité à la personne soupçonnée : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00090",
                      'il peut également viser l’entourage familial ou amical du suspect, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00091",
                      'lorsque les nécessités de l’enquête l’exigent.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00092",
                        'La géolocalisation en temps réel peut aussi être utilisée dans le cadre ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00093",
                        'd’une information ouverte pour rechercher les causes de la mort ou de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00094",
                        'la disparition, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00095",
                    'l’article 80-4 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00096",
                        'Le juge d’instruction autorise les opérations pour une durée ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00097",
                        'maximale de quatre mois, renouvelable. La durée totale ne peut dépasser ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00098",
                        'un an pour les infractions de droit commun et deux ans pour les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00099",
                        'infractions relevant de la criminalité ou de la délinquance organisée ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00100",
                        'mentionnées aux ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00101",
                    'articles 706-73 et 706-73-1 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00102",
                  'Introduction dans des lieux privés ou des véhicules',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00103",
                      'Pour mettre en place ou retirer le moyen technique de géolocalisation, le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00104",
                      'juge d’instruction peut autoriser l’introduction dans des lieux privés ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00105",
                      'dans des véhicules, y compris en dehors des heures légales, dans des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00106",
                      'conditions strictement encadrées.',
                    ),
              ),
              const SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00107",
                      'Lieux d’entrepôt de véhicules, fonds, valeurs, marchandises ou matériel : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00108",
                      'autorisation du juge d’instruction (crimes, délits punis d’au moins ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00109",
                      'trois ans, enquête décès ou disparition).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00110",
                      'Véhicules situés sur la voie publique ou dans de tels lieux : même ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00111",
                      'magistrat compétent et mêmes conditions d’application.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00112",
                      'Autres lieux privés (banque, administration, entreprise, etc.) : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00113",
                      'autorisation du juge d’instruction pour les crimes, les délits punis ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00114",
                      'd’au moins cinq ans, les enquêtes décès et les disparitions.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00115",
                      'Lieux d’habitation : autorisation du juge d’instruction entre 6h00 et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00116",
                      '21h00, et du juge des libertés et de la détention entre 21h00 et 6h00.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00117",
                      'Lieux protégés (cabinet ou domicile d’un avocat, locaux ou véhicules de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00118",
                      'presse, cabinet d’un médecin, notaire ou commissaire de justice, lieux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00119",
                      'couverts par le secret de la défense, cabinet ou domicile d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00120",
                      'magistrat, bureau ou domicile d’un député, d’un sénateur ou d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00121",
                      'parlementaire européen) : introduction strictement encadrée et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00122",
                      'réservée au juge d’instruction ou au juge des libertés et de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00123",
                      'détention selon les cas.',
                    ),
              ),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00124",
                  'Activation à distance d’un appareil électronique',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00125",
                        'Lorsque l’enquête porte sur un crime ou un délit puni d’au moins cinq ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00126",
                        'ans d’emprisonnement, le juge d’instruction peut autoriser, à l’insu ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00127",
                        'ou sans le consentement du propriétaire ou du possesseur, l’activation ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00128",
                        'à distance d’un appareil électronique (téléphone portable, tablette, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00129",
                        'ordinateur, système GPS autonome ou intégré, montre connectée, etc.) ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00130",
                        'afin de procéder à sa géolocalisation en temps réel, dans les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00131",
                        'conditions prévues par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00132",
                    'l’article 230-34-1 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00133",
                        'Cette activation ne peut pas concerner un appareil utilisé par un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00134",
                        'médecin, un notaire, un commissaire de justice, un député, un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00135",
                        'sénateur, un avocat, un magistrat ou un journaliste. Les députés, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00136",
                        'sénateurs et parlementaires européens élus en France sont protégés par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00137",
                    'l’article 230-34-1 et l’article 803-10 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00138",
                        'Le juge d’instruction peut désigner une personne physique ou morale ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00139",
                        'habilitée inscrite sur les listes prévues à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00140",
                    'l’article 157 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00141",
                        ', ou prescrire le recours aux moyens de l’État soumis au secret de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00142",
                        'défense nationale, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00143",
                    'l’article 230-36 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00144",
                        'Ces dispositions ne s’appliquent pas lorsque la géolocalisation porte ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00145",
                        'sur un équipement, un véhicule ou un objet appartenant à la victime et ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00146",
                        'que les opérations ont pour objet de retrouver la victime ou le bien ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00147",
                        'dérobé : dans ce cas, la géolocalisation en temps réel relève des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00148",
                        'réquisitions prévues par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00149",
                    'les articles 99-3 ou 99-4 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.8.4 — INTERCEPTIONS
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
              "f00150",
              '3.8.4 — Interceptions de correspondances par voie de communications électroniques',
            ),
            cardColor: cardTeal,
            accent: cardTealAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00151",
                  '3.8.4.1 — Le magistrat compétent',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00152",
                    'Aux termes de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00153",
                    'l’article 100 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00154",
                        ', le juge d’instruction peut, lorsque les nécessités de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00155",
                        'l’information l’exigent, prescrire l’interception, l’enregistrement et ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00156",
                        'la transcription de correspondances émises par la voie des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00157",
                        'communications électroniques.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00158",
                  '3.8.4.2 — Nature des infractions',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00159",
                        'L’interception n’est possible qu’en matière criminelle ou en matière ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00160",
                        'correctionnelle lorsque la peine encourue est au moins égale à trois ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00161",
                        'ans d’emprisonnement, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00162",
                    'l’article 100 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00163",
                      'Ce seuil de trois ans n’est pas exigé lorsqu’il s’agit d’un délit puni ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00164",
                      'd’emprisonnement commis par la voie des communications électroniques sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00165",
                      'la ligne de la victime, et que l’interception intervient sur cette ligne à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00166",
                      'la demande de la victime (par exemple en cas d’appels téléphoniques ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00167",
                      'malveillants).',
                    ),
              ),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00168",
                  '3.8.4.3 — Personnes susceptibles d’être écoutées',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00169",
                      'L’interception peut viser les personnes mises en examen, celles paraissant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00170",
                      'avoir participé aux faits ou toute personne susceptible de détenir des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00171",
                      'renseignements utiles à la manifestation de la vérité.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00172",
                    'Le dernier alinéa de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00173",
                    'l’article 100 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00174",
                        ' renforce les garanties lorsque la ligne interceptée dépend du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00175",
                        'cabinet ou du domicile d’un avocat. Aucune interception ne peut porter ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00176",
                        'sur une telle ligne, sauf s’il existe des raisons plausibles de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00177",
                        'soupçonner l’avocat d’avoir commis ou tenté de commettre, comme auteur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00178",
                        'ou complice, l’infraction objet de la procédure ou une infraction ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00179",
                        'connexe, et si la mesure est proportionnée à la gravité des faits.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00180",
                        'Dans ce cas, la décision est prise par le juge des libertés et de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00181",
                        'détention, saisi par ordonnance motivée du juge d’instruction, après ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00182",
                        'avis du procureur de la République, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00183",
                    'l’article 100-5 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00184",
                        'Le même article prévoit que ne peuvent être transcrites, à peine de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00185",
                        'nullité, les correspondances avec un avocat dans l’exercice des droits ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00186",
                        'de la défense, protégées par la loi du 31 décembre 1971, ni les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00187",
                        'correspondances avec un journaliste permettant d’identifier une ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00188",
                        'source, en application de la loi du 29 juillet 1881 sur la liberté de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00189",
                        'la presse, sauf exception prévue à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00190",
                    'l’article 56-1-2 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00191",
                  '3.8.4.4 — Conditions de forme',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00192",
                        'La décision d’interception doit être écrite, motivée en fait et en droit ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00193",
                        'et n’est susceptible d’aucun recours. Elle doit comporter tous les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00194",
                        'éléments d’identification de la liaison à intercepter, l’infraction ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00195",
                        'justifiant l’interception ainsi que la durée de la mesure, conformément ',
                      ) +
                      'à ',
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00196",
                    'l’article 100-1 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00197",
                      'La décision est prise pour une durée maximale de quatre mois, renouvelable ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00198",
                      'dans les mêmes conditions de forme et de durée, sans que la durée totale ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00199",
                      'ne puisse excéder un an (sauf dispositions spécifiques pour la criminalité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00200",
                      'organisée). Aucune disposition n’impose que la commission rogatoire figure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00201",
                      'au dossier pendant toute la durée de l’exécution.',
                    ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00202",
                          'La décision peut revêtir la forme d’une ordonnance ou celle d’une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00203",
                          'commission rogatoire, selon que le juge exerce directement ou non ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00204",
                          'le pouvoir que la loi lui confère.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                  "f00205",
                  '3.8.4.5 — Mise en œuvre de l’interception judiciaire',
                ),
              ),
              _Paragraph.rich([
                const TextSpan(text: 'Selon '),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00206",
                    'l’article 100-3 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00207",
                        ', le juge d’instruction ou l’officier de police judiciaire commis par ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00208",
                        'lui peut requérir, sous son contrôle, un agent qualifié d’un service ou ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00209",
                        'organisme placé sous l’autorité du ministre chargé des communications ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00210",
                        'électroniques ou d’un exploitant de réseau ou fournisseur de services ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00211",
                        'de communications électroniques autorisé, afin d’installer le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00212",
                        'dispositif d’interception.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00213",
                    'Les agents requis sont astreints au secret de l’instruction (',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00214",
                    'article 11 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00215",
                        ') et au secret des correspondances (code des postes et des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00216",
                        'communications électroniques). Ils ne peuvent ni révéler l’existence ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00217",
                        'des interceptions, ni prendre connaissance du contenu intercepté, ni ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00218",
                        'le divulguer.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00219",
                        'Chaque opération d’interception et d’enregistrement fait l’objet d’un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00220",
                        'procès-verbal mentionnant la date et l’heure de début et de fin de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00221",
                        'l’opération. Les enregistrements sont placés sous scellés fermés, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00222",
                        'conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00223",
                    'l’article 100-4 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00224",
                        'Seules les correspondances utiles à la manifestation de la vérité sont ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00225",
                        'transcrites par le juge d’instruction, l’officier de police judiciaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00226",
                        'commis ou l’agent de police judiciaire. À peine de nullité, ne peuvent ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00227",
                        'être transcrites les correspondances avec un avocat ou avec un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00228",
                        'journaliste permettant d’identifier une source, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00229",
                    'l’article 100-5 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00230",
                        'À l’expiration du délai de prescription de l’action publique (six ans en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00231",
                        'matière correctionnelle, vingt ans en matière criminelle), les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00232",
                        'enregistrements sont détruits à la diligence du procureur de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00233",
                        'République ou du procureur général. Cette destruction donne lieu à un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                        "f00234",
                        'procès-verbal conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                    "f00235",
                    'l’article 100-6 du Code de procédure pénale',
                  ),
                  style: lawStyle,
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00236",
                          'La violation du secret des correspondances émises par voie de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00237",
                          'télécommunications est réprimée par ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00238",
                      'l’article 226-15 alinéa 2 du Code pénal',
                    ),
                    style: lawStyle,
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00239",
                          '. La fabrication, l’importation, la détention, l’exposition, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00240",
                          'l’offre, la location ou la vente, sans autorisation ministérielle, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00241",
                          'd’appareils destinés à intercepter de telles correspondances sont ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00242",
                          'sanctionnées par ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00243",
                      'l’article 226-3 alinéa 1 du Code pénal',
                    ),
                    style: lawStyle,
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00244",
                          '. La publicité en faveur de ces appareils peut également être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                          "f00245",
                          'réprimée par ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/commission_rogatoire/requisitions_page.dart",
                      "f00246",
                      'l’article 226-3 alinéa 2 du Code pénal',
                    ),
                    style: lawStyle,
                  ),
                  const TextSpan(text: '.'),
                ],
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
