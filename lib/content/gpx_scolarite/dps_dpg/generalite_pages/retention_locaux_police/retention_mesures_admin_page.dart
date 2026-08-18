import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — RÉTENTION DANS LES LOCAUX DE POLICE
///
///  Mesures à caractère administratif
///   - Droit au séjour
///   - Hébergement avant reconduite
///   - Chambre de sûreté (ivresse)
///   - Recueil malades mentaux
///   - Mineurs en fugue
///   - Vérification de situation (terrorisme)
/// ===================================================================
class RetentionMesuresAdminPage extends StatelessWidget {
  const RetentionMesuresAdminPage({super.key});

  static const String routeName =
      '/gpx/generalites/retention_locaux_police/mesures_admin';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : Colors.white;
    final Color card = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);
    final Color accent = isDark
        ? const Color(0xFF80CBC4)
        : const Color(0xFF00897B);
    final Color redAccent = isDark
        ? const Color(0xFFFF8A80)
        : const Color(0xFFD32F2F);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
            "f00001",
            'Mesures à caractère administratif',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00002",
              'II. Mesures à caractère administratif',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                  "f00003",
                  'Ces rétentions ne s’inscrivent pas directement dans une poursuite pénale. ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                  "f00004",
                  'Elles répondent à des objectifs d’ordre public, de sûreté ou de protection des personnes. ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                  "f00005",
                  'Elles restent toutefois encadrées par la loi, avec des durées maximales et des formalités précises.',
                ),
          ),
          const SizedBox(height: 10),
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00006",
              'Réflexe général',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00007",
                      'Même en matière administrative, la rétention porte atteinte à la liberté d’aller et venir. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00008",
                      'Elle doit donc toujours rester justifiée, nécessaire, proportionnée et limitée dans le temps.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 1 — DROIT AU SÉJOUR
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00009",
              '1. Retenue pour vérification du droit au séjour',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00010",
                      'Il s’agit d’une mesure de rétention visant à vérifier le droit de circulation ou de séjour ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00011",
                      'd’une personne de nationalité étrangère sur le territoire français.',
                    ),
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00012",
                    'Décision par un O.P.J.',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00013",
                    ' dans le cadre d’une procédure administrative (droit des étrangers).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00014",
                    'Finalité : vérification du droit au séjour ou à la circulation d’un étranger (titre, visa, situation).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00015",
                    'Durée maximale : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00016",
                    '24 heures',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00017",
                    ', à compter du début de la retenue. Au-delà, une autre mesure doit être prise (ex. placement en rétention administrative, liberté…).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00018",
                        'Mesure placée sous le contrôle du parquet et/ou du juge compétent, avec respect des droits fondamentaux ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00019",
                        '(interprète, information sur la mesure, assistance d’un conseil selon la procédure mise en œuvre, etc.).',
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 2 — HÉBERGEMENT AVANT RECONDUITE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00020",
              '2. Hébergement des étrangers avant une reconduite à la frontière',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00021",
                      'Avant la mise à exécution d’une mesure d’éloignement, certains étrangers peuvent être hébergés ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00022",
                      'temporairement dans des locaux surveillés.',
                    ),
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00023",
                    'La surveillance est assurée par les fonctionnaires de police (policiers de la paix).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00024",
                        'La rétention dure uniquement jusqu’à ce que les conditions matérielles du transport soient réunies ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00025",
                        '(convocation du vol, escorte, documents de voyage…).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00026",
                    'Principe directeur : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00027",
                    'durée strictement limitée au temps nécessaire à l’exécution de la mesure d’éloignement (OQTF, reconduite, expulsion administrative…).',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                  "f00028",
                  'Dignité',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00029",
                          'Les conditions matérielles de séjour (alimentation, hygiène, repos) doivent rester compatibles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00030",
                          'avec le respect de la dignité humaine, même en l’absence de procédure pénale.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 3 — CHAMBRE DE SÛRETÉ (IVRESSE)
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00031",
              '3. Placement en chambre de sûreté (ivresse)',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00032",
                      'La chambre de sûreté vise les personnes en état d’ivresse présentant un danger pour elles-mêmes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00033",
                      'ou pour l’ordre public.',
                    ),
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00034",
                        'Personnes concernées : ivresse publique et manifeste (IPM), conducteurs en état d’ivresse, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00035",
                        'ou auteurs d’un autre délit commis en état d’ivresse.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00036",
                    'Finalité principale : protéger la personne et la collectivité (prévention des accidents, des violences, des troubles).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00037",
                    'Durée : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00038",
                    'jusqu’au complet dégrisement',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00039",
                    ', apprécié médicalement et/ou au vu du comportement. La mesure ne doit pas se prolonger plus que nécessaire.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00040",
                        'Les infractions commises pendant la rétention (dégradations, violences, outrages…) ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00041",
                        'restent pénalement poursuivables.',
                      ),
                ),
              ]),

              const SizedBox(height: 8),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00042",
                          'Un individu en état d’ivresse publique est trouvé couché sur la chaussée. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00043",
                          'Il est conduit en chambre de sûreté pour sa protection. Il est laissé libre après complet dégrisement et vérifications d’identité.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 4 — RECUEIL MALADES MENTAUX
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00044",
              '4. Recueil temporaire des malades mentaux',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00045",
                      'Il s’agit d’une mesure exceptionnelle concernant une personne présentant des troubles mentaux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                      "f00046",
                      'et un danger grave pour elle-même ou pour autrui.',
                    ),
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00047",
                    'Caractère temporaire et exceptionnel : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00048",
                    'le placement en locaux de police ne doit durer que le temps d’organiser la prise en charge médicale.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00049",
                        'La mesure doit aboutir immédiatement au transfert médical dans un établissement spécialisé ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00050",
                        '(hospitalisation à la demande d’un tiers, sur décision préfectorale, etc.).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00051",
                    'Travail en lien étroit avec les secours, le médecin régulateur SAMU / SMUR et éventuellement le maire ou le préfet.',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                  "f00052",
                  'Respect de la dignité',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00053",
                          'Même en cas de crise aiguë, la personne doit être traitée avec humanité. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00054",
                          'L’usage de la force (menottage, contention) doit rester strictement nécessaire et proportionné au danger.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 5 — MINEURS EN FUGUE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00055",
              '5. Garde des mineurs en fugue',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                  "f00056",
                  'Lorsqu’un mineur en fugue est retrouvé, il peut être retenu temporairement dans les locaux de police.',
                ),
              ),
              SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00057",
                    'Finalité : permettre aux personnes qui en ont la garde (parents, tuteurs, ASE…) de le retrouver.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00058",
                    'Durée : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00059",
                        'strictement limitée au temps nécessaire pour contacter la famille, les services sociaux ou le parquet des mineurs, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00060",
                        'et organiser la remise du mineur.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00061",
                        'Les conditions matérielles doivent être adaptées à l’âge et à la vulnérabilité de l’enfant ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00062",
                        '(surveillance, isolement des majeurs, prise en charge bienveillante).',
                      ),
                ),
              ]),
              SizedBox(height: 8),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00063",
                          'Une adolescente en fugue est découverte dans un hall d’immeuble. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00064",
                          'Elle est conduite au commissariat, prise en charge dans un espace séparé, puis remise à ses parents ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00065",
                          'sur instruction du parquet des mineurs.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 6 — VÉRIFICATION DE SITUATION (TERRORISME)
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00066",
              '6. Retenue pour vérification de situation – Terrorisme',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00067",
                    'Cette mesure vise une personne à l’encontre de laquelle il existe des ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00068",
                    'raisons sérieuses de penser',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00069",
                    ' que son comportement peut être lié à des activités à caractère terroriste.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00070",
                    'La personne peut être retenue pour vérification de sa situation même si elle présente un document d’identité valable.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00071",
                    'Durée maximale : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00072",
                    '4 heures',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00073",
                    ', à compter du début du contrôle.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00074",
                        'Mesure particulièrement sensible : elle nécessite une traçabilité complète, une information rapide du parquet ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                        "f00075",
                        'et un contrôle strict de la proportionnalité des moyens employés.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                  "f00076",
                  'Traçabilité renforcée',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00077",
                          'Horaires de début et de fin, motifs précis, éléments factuels justifiant les “raisons sérieuses de penser” ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                          "f00078",
                          'doivent être consignés avec soin dans les procédures.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // SYNTHÈSE / POINT DE VIGILANCE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
              "f00079",
              'Point de vigilance – Ne pas contourner le cadre judiciaire',
            ),
            cardColor: card,
            accent: redAccent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00080",
                    'Les mesures administratives ne doivent jamais servir à contourner le cadre de la ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00081",
                    'garde à vue',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00082",
                    ' ou des autres procédures judiciaires. Un usage abusif peut entraîner la nullité de la procédure et engager la responsabilité de l’État.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00083",
                    'Toujours pouvoir expliquer : le fondement légal, la durée, la finalité de la rétention et les garanties offertes à la personne.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/retention_locaux_police/retention_mesures_admin_page.dart",
                    "f00084",
                    'En cas d’hésitation entre un cadre administratif et judiciaire, réflexe : appel au gradé, au parquet ou au COG.',
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

//
//  ===================================================================
//  WIDGETS TEMPLATE (identiques à LdPersonnesPage / mesures judiciaires)
//  ===================================================================

class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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

class _BulletPoint extends StatelessWidget {
  final List<InlineSpan> spans;

  const _BulletPoint.rich(this.spans);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
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
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

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
          children: [
            TextSpan(
              text: '$title : ',
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
