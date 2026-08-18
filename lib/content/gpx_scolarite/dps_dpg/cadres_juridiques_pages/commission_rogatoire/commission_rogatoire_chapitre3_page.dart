import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CommissionRogatoireChapitre3Page extends StatelessWidget {
  const CommissionRogatoireChapitre3Page({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/commission_rogatoire/chapitre3';

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
    const Color cardBlueAccent = Color(0xFF1565C0);

    final Color cardGreen = isDark
        ? const Color(0xFF0F2416)
        : const Color(0xFFE8F5E9);
    const Color cardGreenAccent = Color(0xFF2E7D32);

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
            "f00002",
            'Commission rogatoire — Chapitre 3',
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
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
              "f00003",
              'Chapitre 3\nLes actes procéduraux de l’enquête sur commission rogatoire',
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
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00004",
                  'Pouvoirs des officiers de police judiciaire agissant sur commission ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00005",
                  'rogatoire, contrôle du juge d’instruction et principaux actes ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00006",
                  'd’enquête : constatations, prélèvements, auditions des témoins, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00007",
                  'témoins assistés et parties.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 12),

          // ================================================================
          // INTRO : ARTICLE 152 CPP ET CONTROLE DU JUGE
          // ================================================================
          _ExempleBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
              "f00008",
              'Article 152 alinéa 1 du Code de procédure pénale',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00009",
                      'Les magistrats ou officiers de police judiciaire commis pour ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00010",
                      'l’exécution exercent, dans les limites de la commission ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00011",
                      'rogatoire, tous les pouvoirs du juge d’instruction.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00012",
                  'Les pouvoirs de l’officier de police judiciaire sont donc très larges, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00013",
                  'mais restent strictement cantonnés au cadre de la commission ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00014",
                  'rogatoire délivrée par le juge d’instruction.',
                ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                "f00015",
                'L’alinéa 2 de l’article 152 du Code de procédure pénale ',
              ),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00016",
                    'limite cependant ces pouvoirs, en particulier en matière ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00017",
                    'd’interrogatoire et de confrontation. Il est également évident que ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00018",
                    'l’officier de police judiciaire ne peut jamais se voir déléguer les ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00019",
                    'pouvoirs juridictionnels du juge d’instruction.',
                  ),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00020",
                    'Lorsque l’officier de police judiciaire est chargé, par son chef ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00021",
                    'hiérarchique, de l’exécution d’une commission rogatoire, ',
                  ),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00022",
                    'il doit, conformément à l’article D.33 alinéa 2 du Code de ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00023",
                    'procédure pénale, en rendre compte immédiatement au magistrat ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00024",
                    'mandant si celui-ci a prescrit cette diligence.',
                  ),
            ),
          ]),
          const SizedBox(height: 10),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                "f00025",
                'L’article 152 alinéa 3 du Code de procédure pénale ',
              ),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00026",
                    'renforce encore le contrôle du juge d’instruction sur les officiers ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00027",
                    'de police judiciaire : le juge peut se déplacer sur les lieux, sans ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00028",
                    'être assisté de son greffier, pour diriger et contrôler l’exécution ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00029",
                    'de la commission rogatoire, tant qu’il ne procède pas lui-même à ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00030",
                    'des actes d’instruction. Il appartient alors à l’officier de police ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                    "f00031",
                    'judiciaire de mentionner ce transport dans le corps de la procédure.',
                  ),
            ),
          ]),
          const SizedBox(height: 10),
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00032",
                      'si la commission rogatoire émane d’un juge d’instruction situé ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00033",
                      'hors du ressort habituel de compétence de l’officier de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00034",
                      'judiciaire, ce dernier informe en outre le ou les procureurs de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00035",
                      'République compétents en raison du lieu d’exécution des actes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00036",
                      'prescrits.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00037",
                  'En matière d’instruction, le procès-verbal de saisine matérialise, en ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00038",
                  'réalité, l’enregistrement par l’officier de police judiciaire des pouvoirs ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00039",
                  'qui lui sont délégués pour l’exécution de la commission rogatoire. ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00040",
                  'Dès qu’il est saisi, l’officier de police judiciaire doit retourner la ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00041",
                  'commission rogatoire, ainsi que les procès-verbaux d’exécution, dans le ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00042",
                  'délai fixé par le juge d’instruction. À défaut de délai fixé, la commission ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00043",
                  'rogatoire et les procès-verbaux sont transmis au plus tard dans les huit ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00044",
                  'jours suivant la fin des opérations (article 151 alinéa 4 du Code de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00045",
                  'procédure pénale).',
                ),
          ),
          const SizedBox(height: 20),

          // ================================================================
          // 3.1 — LES CONSTATATIONS
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
              "f00046",
              '3.1 — Les constatations',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00047",
                  '3.1.1 — Les constatations proprement dites',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00048",
                      'Les constatations sur commission rogatoire ne sont pas détaillées ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00049",
                      'comme telles dans le Code de procédure pénale, mais elles sont ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00050",
                      'impliquées par les articles 81 et 151 du Code de procédure pénale. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00051",
                      'Le juge d’instruction peut accomplir lui-même, ou faire accomplir ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00052",
                      'par commission rogatoire, tous les actes d’information qu’il juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00053",
                      'utiles à la manifestation de la vérité.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00054",
                      'L’officier de police judiciaire délégué peut ainsi procéder à toutes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00055",
                      'les constatations nécessaires : sur les lieux de l’infraction, sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00056",
                      'tout lieu, objet ou document utile aux investigations en cours, etc.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00057",
                      'Les règles à observer lors de ces constatations sont les mêmes que ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00058",
                      'celles applicables en matière d’enquête de flagrant délit. Dès lors ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00059",
                      'qu’il souhaite recueillir des explications des personnes présentes, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00060",
                      'l’officier de police judiciaire doit toutefois appliquer les règles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00061",
                      'propres aux auditions sur commission rogatoire, en fonction du statut ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00062",
                      'de la personne (témoin, témoin assisté, mis en examen, partie civile).',
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00063",
                      '3.1.2 — Les prélèvements externes et les relevés signalétiques ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00064",
                      '(article 154-1 Code de procédure pénale)',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00065",
                      'Pour les besoins de l’exécution de la commission rogatoire, l’officier ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00066",
                      'de police judiciaire peut faire procéder, sur tout témoin ou toute ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00067",
                      'personne mise en cause, aux prélèvements externes nécessaires à des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00068",
                      'examens techniques et scientifiques de comparaison avec les traces ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00069",
                      'et indices déjà relevés (article 55-1 alinéa 1 du Code de procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00070",
                      'pénale).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00071",
                      'L’officier de police judiciaire peut également procéder, ou faire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00072",
                      'procéder sous son contrôle :',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00073",
                      'aux opérations de relevés signalétiques (empreintes digitales, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00074",
                      'palmaires, photographies) nécessaires à l’alimentation et à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00075",
                      'consultation des fichiers de police, selon les règles propres à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00076",
                      'chacun de ces fichiers (article 55-1 alinéa 2 Code de procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00077",
                      'pénale) ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00078",
                      'aux opérations permettant l’enregistrement, la comparaison et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00079",
                      'l’identification des traces et indices ainsi que des résultats des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00080",
                      'relevés signalétiques dans les fichiers de police, toujours selon ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00081",
                      'les règles propres à chaque fichier (article 55-1 alinéa 3 Code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00082",
                      'procédure pénale).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00083",
                      'Le refus, par une personne à l’encontre de laquelle il existe une ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00084",
                      'plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00085",
                      'de commettre une infraction, de se soumettre à ces opérations de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00086",
                      'prélèvement ou de signalisation ordonnées par l’officier de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00087",
                      'judiciaire constitue un délit puni d’un an d’emprisonnement et de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00088",
                      '15 000 euros d’amende.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00089",
                      'Lorsque la prise d’empreintes digitales ou palmaires, ou la prise d’une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00090",
                      'photographie, constitue l’unique moyen d’identifier une personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00091",
                      'placée en garde à vue pour un crime ou un délit puni d’au moins trois ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00092",
                      'ans d’emprisonnement, et que cette personne refuse de justifier de son ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00093",
                      'identité ou fournit des éléments manifestement inexacts, l’opération ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00094",
                      'peut être réalisée sans son consentement, sur autorisation écrite du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00095",
                      'juge d’instruction (article 55-1 alinéa 5 Code de procédure pénale).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00096",
                      'Dans ce cas, si la personne a demandé l’assistance d’un avocat au cours ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00097",
                      'de la garde à vue, celui-ci est avisé par tout moyen et peut assister à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00098",
                      'l’opération. Celle-ci ne peut avoir lieu en son absence qu’après ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00099",
                      'l’expiration d’un délai de deux heures à compter de l’avis donné. Pour ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00100",
                      'les majeurs comme pour les mineurs, lorsque ces opérations sont ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00101",
                      'effectuées sans consentement, la présence d’un avocat ou d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00102",
                      'représentant légal, ou d’un adulte approprié, est requise et elles ne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00103",
                      'peuvent jamais intervenir dans le cadre d’une audition libre.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ================================================================
          // 3.2 — LES AUDITIONS
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
              "f00104",
              '3.2 — Les auditions',
            ),
            cardColor: cardGreen,
            accent: cardGreenAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00105",
                      'Les auditions réalisées sur commission rogatoire obéissent à des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00106",
                      'règles différentes selon le statut de la personne entendue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00107",
                      '(témoin, témoin assisté, personne mise en examen, partie civile).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00108",
                      'Tout procès-verbal d’audition doit mentionner les questions posées ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00109",
                      'et les réponses apportées (article 429 alinéa 2 Code de procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00110",
                      'pénale). Le Code de procédure pénale prévoit également le droit à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00111",
                      'l’interprète pour la personne qui ne comprend pas la langue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00112",
                      'française, depuis le début de la procédure jusqu’à son terme.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00113",
                  '3.2.1 — Les témoins',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00114",
                      'En pratique, le terme “témoin” désigne une personne qui n’est pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00115",
                      'suspectée d’avoir participé à l’infraction et qui peut apporter des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00116",
                      'informations utiles à l’enquête. Cependant, peut aussi être entendue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00117",
                      'comme témoin toute personne suspectée qui n’est ni mise en examen ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00118",
                      'ni titulaire du statut de témoin assisté, à condition qu’il n’existe ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00119",
                      'pas déjà à son encontre d’indices graves et concordants.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00120",
                      'À peine de nullité, ne peut être entendue comme simple témoin la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00121",
                      'personne nommément visée par un réquisitoire introductif ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00122",
                      'supplétif sans être mise en examen : dans ce cas, elle doit être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00123",
                      'entendue comme témoin assisté (article 113-1 Code de procédure pénale).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00124",
                      'L’audition des témoins par l’officier de police judiciaire exécutant une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00125",
                      'commission rogatoire est prévue par l’article 152 du Code de procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00126",
                      'pénale. L’article 153 soumet les témoins cités à trois obligations : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00127",
                      'obligation de comparaître, obligation de prêter serment, obligation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00128",
                      'de déposer.',
                    ),
              ),
              SizedBox(height: 12),

              // 3.2.1.1 Obligation de comparaître
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00129",
                  '3.2.1.1 — L’obligation de comparaître',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00130",
                      'Toute personne contre laquelle il n’existe aucune raison plausible ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00131",
                      'de soupçonner une infraction et qui est régulièrement convoquée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00132",
                      'comme témoin au cours d’une commission rogatoire est tenue de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00133",
                      'comparaître. Le juge ou l’officier de police judiciaire peut recourir, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00134",
                      'le cas échéant, aux dispositions relatives au témoin retenu sous ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00135",
                      'contrainte et au témoin forcé à comparaître, sous le contrôle du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00136",
                      'magistrat instructeur.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00137",
                      'La contrainte ne peut être appliquée que s’il est établi que la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00138",
                      'personne a eu connaissance effective de sa convocation (remise en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00139",
                      'main propre, récépissé, etc.). Une convocation uniquement verbale ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00140",
                      'ou téléphonique est insuffisante.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.2.1.2 Obligation de prêter serment
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00141",
                  '3.2.1.2 — L’obligation de prêter serment',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                        "f00142",
                        'Les témoins entendus sur commission rogatoire doivent prêter ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                        "f00143",
                        'serment de dire la vérité et décliner leur identité complète, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                        "f00144",
                        'leur état, profession, domicile, ainsi que leurs éventuels liens ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                        "f00145",
                        'avec les parties (article 103 Code de procédure pénale). ',
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00146",
                  'Sont dispensés de cette obligation de prêter serment :',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00147",
                      'les mineurs de moins de seize ans et les proches de la personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00148",
                      'mise en examen ou du témoin assisté (ascendants, descendants, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00149",
                      'frères et sœurs, alliés, conjoint, partenaire, etc.) ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00150",
                      'les personnes condamnées à l’interdiction de témoigner en justice ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00151",
                      'autrement que pour de simples déclarations ;',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00152",
                  'les personnes gardées à vue dans le cadre de l’information judiciaire.',
                ),
              ),
              SizedBox(height: 10),

              // 3.2.1.3 Obligation de déposer
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00153",
                  '3.2.1.3 — L’obligation de déposer',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00154",
                      'L’obligation de déposer, prévue par l’article 153 alinéa 1 du Code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00155",
                      'procédure pénale, ne concerne que les auditions réalisées dans le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00156",
                      'cadre d’une information judiciaire.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00157",
                      'Les personnes astreintes au secret professionnel doivent comparaître ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00158",
                      'et décliner leur identité avant d’invoquer le secret. Elles peuvent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00159",
                      'en être déliées dans les cas où la loi impose ou autorise la révélation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00160",
                      'du secret. Les journalistes professionnels peuvent, quant à eux, ne pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00161",
                      'révéler l’origine de leurs informations, sous conditions légales.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00162",
                      'La personne placée en garde à vue n’est pas tenue de déposer : après ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00163",
                      'avoir décliné son identité, elle peut se taire.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.2.1.4 Sanctions
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00164",
                  '3.2.1.4 — Sanctions pénales en cas de non-respect des obligations',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00165",
                      'Le témoin qui ne comparaît pas, refuse de prêter serment ou refuse de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00166",
                      'déposer sans excuse légitime encourt une amende prévue par le Code ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00167",
                      'pénal. Par ailleurs, le témoignage mensonger devant un officier de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00168",
                      'police judiciaire exécutant une commission rogatoire est réprimé par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00169",
                      'les dispositions relatives au faux témoignage.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.2.1.5 Enregistrement GAV
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00170",
                  '3.2.1.5 — Enregistrement audiovisuel des interrogatoires en garde à vue',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00171",
                      'L’article 64-1 du Code de procédure pénale prévoit que les auditions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00172",
                      'des personnes gardées à vue pour crime font l’objet d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00173",
                      'enregistrement audiovisuel. Il en va de même pour certains crimes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00174",
                      'particuliers (par exemple ceux mentionnés à l’article 706-73 du Code ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00175",
                      'de procédure pénale ou portant atteinte aux intérêts fondamentaux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00176",
                      'de la Nation).',
                    ),
              ),
              SizedBox(height: 12),

              // 3.2.1.6 Indices graves et concordants
              _SubTitle(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00177",
                      '3.2.1.6 — Apparition d’indices graves et concordants à l’encontre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00178",
                      'd’une personne jusque-là considérée comme simple témoin',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00179",
                      'Si, avant, pendant ou après l’audition d’une personne entendue comme ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00180",
                      'simple témoin, apparaissent des indices graves et concordants de sa ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00181",
                      'culpabilité, l’article 105 du Code de procédure pénale interdit de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00182",
                      'la maintenir dans ce statut : elle doit être entendue comme mise en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00183",
                      'examen ou témoin assisté, afin de garantir ses droits de défense.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00184",
                      'Si l’officier de police judiciaire persiste à l’entendre comme simple ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00185",
                      'témoin, il porte atteinte aux droits de la défense : l’audition est alors ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00186",
                      'nulle, ainsi que les actes d’enquête qui en découlent.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00187",
                  '3.2.1.6.1 — La notion d’indices graves et concordants',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00188",
                      'Les indices peuvent être matériels (pièces à conviction, traces, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00189",
                      'empreintes) ou immatériels (aveu, témoignage, etc.), mais doivent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00190",
                      'présenter un caractère apparent et objectif. Ils doivent cumuler :',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00191",
                      'la pluralité (plusieurs éléments concordants renforcent la force ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00192",
                      'probante) ;',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00193",
                  'la gravité ;',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00194",
                      'la concordance (les indices ne sont pas contradictoires et forment ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00195",
                      'un faisceau).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00196",
                      'Il n’y a, par exemple, pas d’indices graves et concordants lorsque les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00197",
                      'soupçons reposent uniquement sur les déclarations d’un tiers, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00198",
                      'lorsque la personne nie constamment les faits et dispose d’alibis, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00199",
                      'ou encore lorsque les aveux recueillis ne coïncident pas avec les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00200",
                      'résultats des investigations.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00201",
                  '3.2.1.6.2 — Conséquences pour l’officier de police judiciaire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00202",
                      'Dès qu’il estime que des indices graves et concordants existent à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00203",
                      'l’encontre d’une personne initialement entendue comme simple témoin, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00204",
                      'l’officier de police judiciaire doit immédiatement en informer le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00205",
                      'd’instruction.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00206",
                      'Si ces indices apparaissent pendant l’audition, l’officier doit, à peine ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00207",
                      'de nullité, y mettre fin et aviser sans délai le magistrat instructeur. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00208",
                      'S’ils apparaissent avant ou après l’audition, il ne peut plus procéder ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00209",
                      'à une audition comme simple témoin sans l’accord du juge.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00210",
                      'Le juge d’instruction décidera alors de placer la personne en examen, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00211",
                      'de lui conférer le statut de témoin assisté ou de la laisser simple ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00212",
                      'témoin si les indices ne sont finalement pas caractérisés.',
                    ),
              ),
              SizedBox(height: 12),

              // 3.2.1.7 Autres éléments permettant le statut de témoin assisté
              _SubTitle(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00213",
                      '3.2.1.7 — Apparition d’éléments, autres que des indices graves ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00214",
                      'et concordants, permettant à un simple témoin de bénéficier du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00215",
                      'statut de témoin assisté',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00216",
                      'Une plainte contre personne dénommée, une mise en cause par la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00217",
                      'victime ou par un autre témoin, ou des éléments nouveaux peuvent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00218",
                      'justifier, sans atteindre le seuil des indices graves et concordants, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00219",
                      'l’attribution du statut de témoin assisté par le juge d’instruction.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00220",
                      'La Chancellerie précise que l’attribution de ce statut relève de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00221",
                      'seule appréciation du magistrat instructeur. Tant que le seuil des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00222",
                      'indices graves et concordants n’est pas atteint, l’officier de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00223",
                      'judiciaire continue à entendre la personne comme simple témoin, sans ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00224",
                      'nullité, sous réserve d’informer le magistrat lorsque la personne est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00225",
                      'visée par une plainte avec constitution de partie civile ou mise en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00226",
                      'cause de manière précise.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.2.2 Témoins assistés
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00227",
                  '3.2.2 — Les témoins assistés',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00228",
                      'Le témoin assisté occupe une position intermédiaire entre le simple ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00229",
                      'témoin et la personne mise en examen. Il bénéficie notamment du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00230",
                      'droit d’être assisté d’un avocat lorsqu’il est entendu par le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00231",
                      'd’instruction. Son audition par l’officier de police judiciaire sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00232",
                      'commission rogatoire est prévue par l’article 152 du Code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00233",
                      'procédure pénale.',
                    ),
              ),
              SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                          "f00234",
                          'l’audition par l’officier de police judiciaire d’un témoin assisté ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                          "f00235",
                          'suppose que ce dernier ait lui-même demandé à être entendu. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                          "f00236",
                          'Cette circonstance doit être mentionnée au début du procès-',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                          "f00237",
                          'verbal.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00238",
                      'l’audition peut résulter d’une demande écrite adressée au juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00239",
                      'd’instruction, qui délivre alors une commission rogatoire en ce ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00240",
                      'sens ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00241",
                      'en cas d’urgence, les enquêteurs déjà saisis d’une commission ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00242",
                      'rogatoire peuvent, après accord du juge d’instruction, entendre un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00243",
                      'témoin assisté qui se présente spontanément.',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00244",
                      'le témoin assisté est entendu hors la présence de son avocat, qui ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00245",
                      'peut toutefois être admis si les enquêteurs acceptent sa présence ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00246",
                      'le témoin assisté ne prête pas serment, ne peut faire l’objet ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00247",
                      'd’aucune mesure de contrainte ni d’une garde à vue pour les faits ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00248",
                      'en cause, et peut mettre fin à tout moment à son audition ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00249",
                      'le témoin assisté peut, à tout moment, demander à être mis en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00250",
                      'examen ; il est alors considéré comme mis en examen à compter de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00251",
                      'sa demande.',
                    ),
              ),
              SizedBox(height: 10),

              // 3.2.3 Les parties
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00252",
                  '3.2.3 — Les parties',
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00253",
                  '3.2.3.1 — La personne mise en examen',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00254",
                      'Les officiers de police judiciaire ne peuvent pas procéder, sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00255",
                      'commission rogatoire, aux interrogatoires et confrontations de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00256",
                      'personne mise en examen : ces actes relèvent exclusivement du juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00257",
                      'd’instruction. La mise en examen résulte d’une notification faite par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00258",
                      'le juge, soit lors de l’interrogatoire de première comparution, soit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00259",
                      'par courrier dans les conditions prévues par le Code de procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00260",
                      'pénale.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00261",
                      'Le témoin assisté peut également, à tout moment, demander à être mis ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00262",
                      'en examen : il acquiert alors ce statut dès sa demande ou dès ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00263",
                      'l’envoi de la lettre recommandée adressée au juge. Il peut aussi, par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00264",
                      'la suite, solliciter la conversion de sa mise en examen en statut de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00265",
                      'témoin assisté, sous le contrôle du juge d’instruction.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                  "f00266",
                  '3.2.3.2 — La partie civile',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00267",
                      'La partie civile est la personne qui se constitue pour obtenir la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00268",
                      'réparation de son préjudice. Elle peut être entendue, interrogée ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00269",
                      'confrontée seulement en présence de son avocat, sauf renonciation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00270",
                      'expresse ou convocation de ce dernier (article 114 Code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00271",
                      'procédure pénale).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00272",
                      'Les officiers de police judiciaire ne peuvent entendre la partie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00273",
                      'civile que si celle-ci en fait la demande (article 152 alinéa 2 Code ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00274",
                      'de procédure pénale). Le procès-verbal doit mentionner que la partie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00275",
                      'civile a elle-même souhaité être entendue et qu’elle consent, le cas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00276",
                      'échéant, à déposer hors la présence de son avocat.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00277",
                      'Partie à l’information, la partie civile est entendue sans prêter ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00278",
                      'serment, comme la personne mise en examen, et elle n’est pas soumise ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre3_page.dart",
                      "f00279",
                      'au secret de l’instruction.',
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

/// =====================================================================
///  WIDGETS UTILISÉS (mêmes classes que dans les chapitres 1 et 2)
/// =====================================================================

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
/// TITRE DE SOUS-PARTIE
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

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
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
