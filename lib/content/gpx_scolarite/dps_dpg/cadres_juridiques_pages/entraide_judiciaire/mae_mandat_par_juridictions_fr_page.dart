import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class MaeMandatParJuridictionsFrPage extends StatelessWidget {
  const MaeMandatParJuridictionsFrPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire/mae_mandat_par_juridictions_fr';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    Color lawRed() => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
            "f00001",
            'Retour',
          ),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
            "f00002",
            'MAE — Émission par les juridictions françaises',
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
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===============================================================
          // EN-TÊTE GÉNÉRAL
          // ===============================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00003",
              'Le mandat d’arrêt européen',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00004",
              '2.3 — Émission d’un mandat d’arrêt européen par les juridictions françaises',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00005",
                  'L’émission d’un mandat d’arrêt européen par les juridictions françaises obéit à un ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00006",
                  'cadre strict : détermination de l’autorité compétente, existence d’un titre ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00007",
                  'exécutoire, modalités de diffusion et de transmission du mandat, puis gestion de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00008",
                  'la situation une fois la personne arrêtée et remise aux autorités françaises.',
                ),
          ),
          const SizedBox(height: 16),

          // ===============================================================
          // 2.3.1  AUTORITÉ COMPÉTENTE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00009",
              '2.3.1 — Autorité compétente',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00010",
              'Qui peut émettre un mandat d’arrêt européen ?',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                const TextSpan(text: 'Selon '),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                    "f00011",
                    'l’article 695-16 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                        "f00012",
                        ', l’autorité compétente pour émettre un mandat d’arrêt européen est le ministère public ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                        "f00013",
                        'près la juridiction d’instruction, de jugement ou d’application des peines qui a délivré ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                        "f00014",
                        'le titre exécutoire.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00015",
                  'Le ministère public peut émettre un mandat d’arrêt européen :',
                ),
              ),
              const SizedBox(height: 6),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00016",
                  'soit à la demande de la juridiction concernée ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00017",
                  'soit d’office, lorsqu’il l’estime nécessaire à l’exécution de la décision.',
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00018",
                      'Il peut également, afin d’assurer l’exécution d’une peine privative de liberté ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00019",
                      'd’une durée supérieure ou égale à quatre ans, décider l’émission d’un mandat ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00020",
                      'd’arrêt européen.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.3.2  TITRE POUVANT FAIRE L’OBJET D’UN MAE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00021",
              '2.3.2 — Titre pouvant faire l’objet d’un mandat d’arrêt',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00022",
              'Exigence d’un titre exécutoire préalable',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00023",
                      'Le ministère public ne peut émettre un mandat d’arrêt européen que sur la base ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00024",
                      'd’un titre exécutoire préexistant. Il peut s’agir notamment :',
                    ),
              ),
              const SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00025",
                  'd’un mandat d’arrêt déjà décerné par la juridiction compétente ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00026",
                  'd’une décision de condamnation devenue exécutoire (peine privative de liberté ou mesure de sûreté).',
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                        "f00027",
                        'Un formulaire-type de mandat d’arrêt européen a été imposé à l’ensemble des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                        "f00028",
                        'autorités judiciaires de l’Union européenne par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                    "f00029",
                    'l’article 695-13 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                        "f00030",
                        ', afin de standardiser le contenu et de faciliter la compréhension et l’exécution ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                        "f00031",
                        'dans chaque État membre.',
                      ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.3.3  DIFFUSION ET TRANSMISSION DU MANDAT
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00032",
              '2.3.3 — Diffusion et transmission du mandat',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00033",
              'Acheminement du mandat d’arrêt européen',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00034",
                      'Une fois le mandat d’arrêt européen émis, sa diffusion et sa transmission ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00035",
                      'dépendent de la localisation de la personne recherchée :',
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00036",
                      'Lorsque la personne recherchée se trouve, à un lieu connu, sur le territoire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00037",
                      'd’un autre État membre, le mandat d’arrêt peut être adressé directement à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00038",
                      'l’autorité judiciaire d’exécution, sous réserve que cet État accepte cette ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00039",
                      'transmission directe.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00040",
                      'La transmission du mandat est alors assurée par le parquet émetteur, dans les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00041",
                      'délais impartis et selon les formes requises par l’autorité judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00042",
                      'compétente du lieu d’arrestation (courrier sécurisé, télécopie, messagerie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00043",
                      'électronique, etc.).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00044",
                      'Lorsque la personne recherchée n’est pas localisée, son signalement est diffusé ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00045",
                      'dans le Système d’information Schengen (S.I.S.) et via INTERPOL pour les autres services.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00046",
                      'Le mandat d’arrêt européen peut, de manière générale, être transmis par tout moyen ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00047",
                      'laissant une trace écrite et permettant à l’autorité judiciaire d’exécution ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00048",
                      'd’en vérifier l’authenticité.',
                    ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00049",
                      'Version au 01/07/2025 — SDCP, tous droits réservés.',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.3.4  LORSQUE LA PERSONNE A ÉTÉ ARRÊTÉE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00050",
              '2.3.4 — Lorsque la personne a été arrêtée',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00051",
              'Conséquences de l’arrestation dans l’État d’exécution',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                    "f00052",
                    'Les suites à donner à l’arrestation de la personne recherchée sont prévues par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                    "f00053",
                    'les articles 695-17 et 695-17-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00054",
                      'Dès que le ministère public est informé de l’arrestation de la personne recherchée, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00055",
                      'il adresse sans délai au ministre de la Justice une copie du mandat d’arrêt transmis ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00056",
                      'à l’autorité judiciaire de l’État membre d’exécution ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00057",
                      'Lorsque la personne arrêtée est recherchée pour l’exécution d’une peine ou d’une mesure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00058",
                      'de sûreté privative de liberté et qu’elle a été condamnée en son absence, si elle demande ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00059",
                      'la communication de la décision de condamnation, le ministère public transmet à l’autorité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00060",
                      'judiciaire de l’État membre d’exécution une copie de cette décision pour remise à l’intéressé ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00061",
                      'Si le ministère public est informé par l’autorité judiciaire d’exécution d’une demande ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00062",
                      'de la personne arrêtée tendant à la désignation d’un avocat en France, il lui adresse les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00063",
                      'informations nécessaires pour choisir un avocat ou, à sa demande, fait procéder à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00064",
                      'désignation d’office d’un avocat par le bâtonnier compétent.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.3.5  REMISE AUX AUTORITÉS FRANÇAISES
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00065",
              '2.3.5 — Remise de l’intéressé aux autorités françaises',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
              "f00066",
              'Organisation de la remise et suites procédurales',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00067",
                      'Lorsque l’autorité judiciaire étrangère a rendu une décision définitive autorisant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00068",
                      'la remise, celle-ci doit intervenir dans un délai de dix jours à compter de cette décision. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00069",
                      'Si ce délai n’est pas respecté, la personne réclamée peut être remise en liberté dans l’État ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00070",
                      'd’exécution.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00071",
                      'Si les autorités de l’État d’exécution entendent différer la remise parce que la personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00072",
                      'fait l’objet de poursuites ou doit exécuter une peine sur leur territoire, les autorités ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00073",
                      'françaises peuvent solliciter :',
                    ),
              ),
              SizedBox(height: 6),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00074",
                  'soit la remise temporaire de l’intéressé ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                  "f00075",
                  'soit son audition sur commission rogatoire internationale.',
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00076",
                      'Lors de la remise effective de la personne aux autorités françaises, le signalement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00077",
                      'doit être retiré des fichiers nationaux (Fichier des personnes recherchées — F.P.R.) et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00078",
                      'des systèmes internationaux (notamment INTERPOL), afin d’éviter tout maintien injustifié ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/mae_mandat_par_juridictions_fr_page.dart",
                      "f00079",
                      'du statut de personne recherchée.',
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
