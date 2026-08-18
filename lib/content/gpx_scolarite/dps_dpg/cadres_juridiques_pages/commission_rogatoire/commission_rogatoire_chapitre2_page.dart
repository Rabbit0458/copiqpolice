// lib/gpx_scolarite_pages/cadres_juridiques/commission_rogatoire_chapitre2_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CommissionRogatoireChapitre2Page extends StatelessWidget {
  const CommissionRogatoireChapitre2Page({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/commission_rogatoire/chapitre2';

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

    final Color cardPurple = isDark
        ? const Color(0xFF1B1530)
        : const Color(0xFFEDE7F6);
    const Color cardPurpleAccent = Color(0xFF5E35B1);

    final Color cardTeal = isDark
        ? const Color(0xFF00363A)
        : const Color(0xFFE0F2F1);
    const Color cardTealAccent = Color(0xFF00695C);

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
            "f00002",
            'Commission rogatoire — Chapitre 2',
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
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
              "f00003",
              'Chapitre 2\nLe formalisme de la commission rogatoire',
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
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00004",
                  'Mentions obligatoires, forme écrite, diffusion et principales distinctions ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00005",
                  'entre commissions rogatoires générales, spéciales, contre une personne ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00006",
                  'dénom­mée, contre X et internationales.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 12),

          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00007",
                  'Toute commission rogatoire doit être écrite, datée, signée par le magistrat ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00008",
                  'qui la délivre et indiquer la nature de l’infraction et l’objet des poursuites.',
                ),
          ),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00009",
                  'Le formalisme de la commission rogatoire garantit la traçabilité des actes ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00010",
                  'délégués et la protection des droits des personnes mises en cause.',
                ),
          ),
          const SizedBox(height: 14),

          // ================================================================
          // ARTICLE 151 AL. 2 CPP & RAPPEL DE LA FORME ÉCRITE
          // ================================================================
          _ExempleBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
              "f00011",
              'Article 151 alinéa 2 du Code de procédure pénale',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00012",
                      'La commission rogatoire indique la nature de l’infraction et l’objet des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00013",
                      'poursuites. Elle est datée et signée par le magistrat qui la délivre et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00014",
                      'revêtue de son sceau.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00015",
                  'La commission rogatoire doit donc obligatoirement revêtir une forme écrite. ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00016",
                  'En pratique, l’officier de police judiciaire conserve et peut exhiber la ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00017",
                  'commission rogatoire au cours de ses opérations, même si aucun texte n’impose ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00018",
                  'expressément cette présentation matérielle.',
                ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                "f00019",
                'Lorsque la commission rogatoire prescrit des opérations simultanées ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                "f00020",
                'en plusieurs lieux du territoire, ',
              ),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                    "f00021",
                    'le juge d’instruction peut en ordonner la diffusion, par tout moyen adapté, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                    "f00022",
                    'aux autres juges d’instruction ou aux officiers de police judiciaire ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                    "f00023",
                    'chargés de son exécution, conformément à l’article D.35 du Code de ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                    "f00024",
                    'procédure pénale.',
                  ),
            ),
          ]),
          const SizedBox(height: 18),

          // ================================================================
          // 2.1 — COMMISSION ROGATOIRE GÉNÉRALE / SPÉCIALE
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
              "f00025",
              '2.1 — Commission rogatoire générale, commission rogatoire spéciale',
            ),
            cardColor: cardBlue,
            accent: cardBlueAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00026",
                  '2.1.1 — La commission rogatoire générale',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00027",
                      'La commission rogatoire dite « générale » peut être large quant aux actes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00028",
                      'd’enquête et d’instruction qu’elle autorise. Le magistrat instructeur ne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00029",
                      'détaille pas nécessairement chaque acte, mais confère à l’officier de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00030",
                      'police judiciaire une certaine latitude pour accomplir tous les actes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00031",
                      'nécessaires à la manifestation de la vérité.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00032",
                      'En revanche, la commission rogatoire ne peut jamais être générale quant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00033",
                      'aux infractions : elle doit viser une ou plusieurs infractions déterminées, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00034",
                      'correspondant précisément à l’objet des poursuites.',
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00035",
                  '2.1.2 — La commission rogatoire spéciale',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00036",
                      'Par opposition à la commission rogatoire générale, la commission rogatoire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00037",
                      'dite « spéciale » délègue une mission précisément définie à l’officier de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00038",
                      'police judiciaire. Elle mentionne un ou plusieurs actes limitativement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00039",
                      'énumérés par le magistrat.',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00040",
                      'Exemples : entendre un témoin déterminé, saisir un dossier ou un support ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00041",
                      'informatique identifié, procéder à une perquisition dans un lieu donné, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00042",
                      'exploiter une vidéoprotection, etc.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ================================================================
          // 2.2 — COMMISSION ROGATOIRE CONTRE PERSONNE DÉNOMMÉE / CONTRE X
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
              "f00043",
              '2.2 — Commission rogatoire contre personne dénommée, ou contre X',
            ),
            cardColor: cardPurple,
            accent: cardPurpleAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF4527A0),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00044",
                  '2.2.1 — La commission rogatoire délivrée contre une personne dénommée',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00045",
                      'Lorsque le juge d’instruction estime qu’il existe, à l’encontre d’une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00046",
                      'personne déterminée, des indices suffisants de participation à une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00047",
                      'infraction, il peut envisager sa mise en examen et délivrer une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00048",
                      'commission rogatoire afin de préciser certains points encore obscurs.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00049",
                      'Dans ce cas, la commission rogatoire mentionne expressément dans son ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00050",
                      'libellé l’identité de la personne mise en examen et la désignation de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00051",
                      'l’infraction qui lui est reprochée.',
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00052",
                  '2.2.2 — La commission rogatoire délivrée contre X',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00053",
                      'La commission rogatoire peut également être délivrée « contre X », lorsque ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00054",
                      'les auteurs de l’infraction ne sont pas encore identifiés ou lorsque des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00055",
                      'vérifications supplémentaires sont nécessaires avant toute mise en examen.',
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00056",
                      'Premier cas : l’infraction est connue, une information judiciaire est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00057",
                      'ouverte, mais l’enquête n’a pas encore permis, au moment de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00058",
                      'délivrance de la commission rogatoire, d’identifier les véritables ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00059",
                      'auteurs. La commission rogatoire décrira alors l’infraction et les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00060",
                      'circonstances, sans pouvoir désigner les personnes mises en cause.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00061",
                      'Deuxième cas : une information est ouverte et des indices apparaissent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00062",
                      'contre une ou plusieurs personnes déterminées. Il appartient alors au ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00063",
                      'juge d’instruction d’apprécier si ces personnes peuvent ou non être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00064",
                      'mises en examen.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00065",
                      'La mise en examen ne peut intervenir qu’après que le juge d’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00066",
                      's’est assuré que la personne a, au vu des éléments recueillis, pu ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00067",
                      'prendre part à l’acte reproché dans des conditions de nature à engager ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00068",
                      'sa responsabilité pénale.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00069",
                      'Dans cette perspective, une commission rogatoire délivrée contre X peut ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00070",
                      'permettre au juge d’instruction de recueillir toutes les informations ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00071",
                      'complémentaires nécessaires avant de prendre une décision de mise en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00072",
                      'examen nommément désignée.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ================================================================
          // 2.3 — COMMISSIONS ROGATOIRES INTERNATIONALES
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
              "f00073",
              '2.3 — Les commissions rogatoires internationales',
            ),
            cardColor: cardTeal,
            accent: cardTealAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF004D40),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00074",
                      'Des commissions rogatoires internationales peuvent être adressées à des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00075",
                      'autorités étrangères pour exécution ou, inversement, être reçues de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00076",
                      'l’étranger par les autorités françaises. Le plus souvent, ces mécanismes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00077",
                      's’inscrivent dans le cadre de conventions internationales bilatérales ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00078",
                      'multilatérales conclues entre États.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00079",
                  '2.3.1 — Forme',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00080",
                      'Les commissions rogatoires internationales revêtent en principe une forme ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00081",
                      'comparable, quel que soit l’État destinataire. L’autorité qui émet la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00082",
                      'demande doit être clairement identifiée dans le document.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00083",
                      'La commission rogatoire internationale doit exposer de la manière la plus ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00084",
                      'précise possible les faits reprochés, indiquer les qualifications pénales ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00085",
                      'retenues ainsi que la référence des textes applicables et préciser ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00086",
                      'exactement l’objet de la mission confiée à l’État requis.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00087",
                      'Elle est, en pratique, souvent accompagnée d’une traduction dans la langue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00088",
                      'de l’État requis et porte le sceau de l’autorité qui la délivre.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00089",
                  '2.3.2 — Mission',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00090",
                      'Les commissions rogatoires internationales ont pour objet principal ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00091",
                      'l’accomplissement d’actes d’instruction ou la communication de pièces ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00092",
                      'à conviction.',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00093",
                      'Les missions portent le plus souvent sur l’audition de témoins, les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00094",
                      'vérifications bancaires ou la réalisation de perquisitions à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00095",
                      'l’étranger.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00096",
                  '2.3.3 — Exécution',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                    "f00097",
                    'L’article 694-5 du Code de procédure pénale ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                        "f00098",
                        'prévoit que les interrogatoires, auditions ou confrontations ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                        "f00099",
                        'réalisés à l’étranger à la demande des autorités judiciaires ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                        "f00100",
                        'françaises sont exécutés conformément aux dispositions du Code de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                        "f00101",
                        'procédure pénale français, sauf si une convention internationale ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                        "f00102",
                        'prévoit des modalités différentes.',
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00103",
                      'L’article 4 de la convention relative à l’entraide judiciaire en matière ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00104",
                      'pénale entre les États membres de l’Union européenne du 29 mai 2000 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00105",
                      'dispose que l’État requis respecte, en principe, les formalités de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00106",
                      'procédure expressément indiquées par l’État requérant. Il peut toutefois ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00107",
                      'écarter les formalités ou procédures qui seraient contraires aux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00108",
                      'principes fondamentaux de son propre système juridique.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ================================================================
          // NOTA / JURISPRUDENCE
          // ================================================================
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00109",
                      'la jurisprudence rappelle que le magistrat instructeur français n’a pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00110",
                      'compétence pour apprécier la régularité d’un acte au regard de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00111",
                      'législation étrangère. La ',
                    ),
              ),
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                  "f00112",
                  'lex fori ',
                ),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00113",
                      's’applique en effet aux conditions de fond comme de forme des actes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00114",
                      'd’instruction réalisés en France. (Chambre criminelle de la Cour de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/commission_rogatoire/commission_rogatoire_chapitre2_page.dart",
                      "f00115",
                      'cassation, décision n°16-87114 du 7 juin 2017).',
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

/// =====================================================================
///  WIDGETS UTILISÉS (mêmes classes que pour le chapitre 1)
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
