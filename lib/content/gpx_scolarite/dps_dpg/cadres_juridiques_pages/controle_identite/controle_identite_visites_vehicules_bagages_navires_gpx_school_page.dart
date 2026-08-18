import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ConntroleIdentiteVisiteGpxSchool extends StatelessWidget {
  const ConntroleIdentiteVisiteGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/controle_identite/chapitre1/visites_vehicules_bagages_navires';

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
            "f00002",
            'Véhicules, bagages, navires',
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
          // ===================== TITRE & INTRO ============================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00003",
              'Visites de véhicules, bagages et navires',
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
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00004",
                  'Contrôles d’identité, visites de véhicules, inspection visuelle et fouille de bagages, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00005",
                  'visites de navires : régimes juridiques, infractions visées, autorités compétentes et ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00006",
                  'modalités pratiques.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.5 – GENERAL ==========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00007",
              '1.2.5 – Les visites de véhicules, l’inspection visuelle des bagages ou leur fouille, les visites de navires',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00008",
                        'Le régime spécifique des visites de véhicules, de l’inspection visuelle ou de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00009",
                        'fouille des bagages et des visites de navires est prévu par l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                    "f00010",
                    'article 78-2-2 du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                    "f00011",
                    '. Cet article distingue quatre volets autonomes :\n',
                  ),
                ),
              ]),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00012",
                  'les contrôles d’identité ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00013",
                  'les visites de véhicules ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00014",
                  'les inspections visuelles et les fouilles de bagages ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00015",
                  'les visites de navires.',
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00016",
                      'Ces opérations peuvent être réalisées indépendamment d’un contrôle préalable de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00017",
                      'l’identité du conducteur, du propriétaire des bagages ou des occupants du navire.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===================== 1.2.5.1 – RÉQUISITIONS PROCUREUR =========
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00018",
              '1.2.5.1 – Sur réquisitions écrites du procureur de la République',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                    "f00019",
                    'Les opérations prévues à l’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                    "f00020",
                    'article 78-2-2 du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00021",
                        ' peuvent être ordonnées sur réquisitions écrites du procureur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00022",
                        'de la République. Celui-ci détermine les lieux, la durée et la nature des opérations ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00023",
                        'à mener (contrôle d’identité, visites de véhicules, inspection ou fouille de bagages, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00024",
                        'visites de navires).',
                      ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // ========== 1.2.5.1.1 – INFRACTIONS VISÉES =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00025",
              '1.2.5.1.1 – Infractions visées',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00026",
                      'Les opérations peuvent être décidées aux fins de recherche et de poursuite des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00027",
                      'infractions suivantes :',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00028",
                  'actes de terrorisme prévus aux articles 421-1 à 421-6 du code pénal ;',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00029",
                      'infractions en matière de prolifération des armes de destruction massive et de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00030",
                      'leurs vecteurs, visées notamment aux articles L. 1333-9, L. 1333-11, L. 1333-13-3, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00031",
                      'L. 1333-13-4, L. 1333-13-5, L. 2339-14, L. 2339-15, L. 2341-1, L. 2341-2, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00032",
                      'L. 2341-4, L. 2342-59 et L. 2342-60 du code de la défense ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00033",
                      'infractions en matière d’armes, notamment l’article 222-54 du code pénal et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00034",
                      'l’article L. 317-8 du code de la sécurité intérieure ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00035",
                      'infractions en matière d’explosifs prévues par l’article 322-11-1 du code pénal ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00036",
                      'et l’article L. 2353-4 du code de la défense ;',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00037",
                  'infractions de vol prévues aux articles 311-3 à 311-11 du code pénal ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00038",
                  'infractions de recel, visées aux articles 321-1 et 321-2 du code pénal ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00039",
                  'faits de trafic de stupéfiants prévus aux articles 222-34 à 222-38 du code pénal.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ========== 1.2.5.1.2 – QUALITÉ DES PERSONNES ==================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00040",
              '1.2.5.1.2 – Qualité des personnes',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00041",
                      'Le législateur distingue les agents pouvant réaliser les différents types de mesures ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00042",
                      'prévues par les réquisitions :',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00043",
                      'les contrôles d’identité peuvent être réalisés par les officiers de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00044",
                      'et, sur leur ordre et sous leur responsabilité, par les agents de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00045",
                      'et les agents de police judiciaire adjoints mentionnés aux 1°, 1° bis et 1° ter de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00046",
                      'l’article 21 du code de procédure pénale ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00047",
                      'les visites de véhicules ou de navires ainsi que les inspections visuelles et fouilles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00048",
                      'de bagages doivent être effectuées par des officiers de police judiciaire ; la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00049",
                      'présence effective de l’officier de police judiciaire est donc indispensable.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ========== 1.2.5.1.3 – MODALITÉS ==============================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00050",
              '1.2.5.1.3 – Modalités',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00051",
                        'Les opérations ne peuvent avoir lieu que sur réquisitions écrites du procureur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00052",
                        'de la République, qui en fixe les lieux et la durée. Cette durée ne peut excéder ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                    "f00053",
                    'vingt-quatre heures consécutives',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00054",
                        ', renouvelables sur décision expresse et motivée du même magistrat. La Cour de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00055",
                        'cassation rappelle que plusieurs jours de contrôles ne peuvent être couverts par ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00056",
                        'une réquisition unique (Crim., 13 septembre 2017, n°17-83.986).',
                      ),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00057",
                  'La visite des véhicules',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00058",
                      'La visite des véhicules se déroule différemment selon que le véhicule est en circulation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00059",
                      'ou à l’arrêt :',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00060",
                      'véhicule en circulation : il ne peut être immobilisé que le temps strictement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00061",
                      'nécessaire au déroulement de la visite et en présence du conducteur ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00062",
                      'véhicule à l’arrêt ou en stationnement : la visite doit avoir lieu en présence du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00063",
                      'conducteur ou du propriétaire. À défaut, l’officier ou l’agent de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00064",
                      'requiert une personne extérieure ne relevant pas de son autorité administrative, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00065",
                      'sauf si la visite comporte des risques graves pour la sécurité des personnes et des biens.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00066",
                      'En cas de découverte d’une infraction, si le conducteur ou le propriétaire du véhicule ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00067",
                      'en fait la demande, ou si la visite a eu lieu en leur absence, un procès-verbal est établi. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00068",
                      'Il indique le lieu, les dates et heures de début et de fin des opérations. Un exemplaire est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00069",
                      'remis à l’intéressé, un autre est transmis sans délai au procureur de la République.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00070",
                      'La visite des véhicules spécialement aménagés à usage d’habitation et effectivement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00071",
                      'utilisés comme résidence ne peut être effectuée que selon les règles applicables aux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00072",
                      'perquisitions et visites domiciliaires.',
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00073",
                  'La visite des navires',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00074",
                      'Le navire ne peut être immobilisé que le temps strictement nécessaire à la visite, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00075",
                      'sans que celle-ci puisse excéder douze heures. Elle se déroule en présence du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00076",
                      'capitaine ou de son représentant et comprend l’inspection des extérieurs, des cales, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00077",
                      'des soutes et des locaux, à l’exception de ceux aménagés à un usage d’habitation.',
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                  "f00078",
                  'L’inspection visuelle des bagages ou leur fouille',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00079",
                      'Dans les mêmes conditions de réquisitions et pour les mêmes infractions, les officiers ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00080",
                      'de police judiciaire peuvent, assistés le cas échéant des agents de police judiciaire et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00081",
                      'des agents de police judiciaire adjoints (articles 21, 1°, 1° bis et 1° ter du code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00082",
                      'procédure pénale), procéder à l’inspection visuelle des bagages ou à leur fouille en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00083",
                      'tous lieux accessibles au public.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00084",
                      'Les propriétaires des bagages ne peuvent être retenus que le temps strictement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00085",
                      'nécessaire au déroulement de l’inspection ou de la fouille, et l’opération se déroule ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00086",
                      'en leur présence.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00087",
                      'En cas de découverte d’une infraction, si le propriétaire le demande, un procès-verbal ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00088",
                      'mentionnant le lieu, les dates et heures de début et de fin des opérations est rédigé. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00089",
                      'Un exemplaire est remis à l’intéressé, un autre transmis sans délai au procureur de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00090",
                      'République.',
                    ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00091",
                          'La loi n° 2025-379 du 28 avril 2025 relative au renforcement de la sûreté dans les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00092",
                          'transports permet désormais aux officiers de police judiciaire et, sous leur contrôle, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00093",
                          'aux agents de police judiciaire et agents de police judiciaire adjoints mentionnés aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00094",
                          '1°, 1° bis, 1° ter et 2° de l’article 21 du code de procédure pénale de procéder, de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00095",
                          'leur propre initiative, à l’inspection visuelle des bagages et, avec le consentement du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00096",
                          'propriétaire, à leur fouille :\n',
                        ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00097",
                          '• sur les lignes et dans les gares des réseaux ferroviaires et guidés (article L. 2241-1-2 du code des transports) ;\n',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00098",
                          '• dans les services de transport public routier de personnes réguliers ou à la demande, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00099",
                          'y compris dans les aménagements où ces services déposent et prennent en charge les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                          "f00100",
                          'passagers (article L. 3116-1 du code des transports).',
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.5.2 – CRIME OU DÉLIT FLAGRANT ==================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00101",
              '1.2.5.2 – En cas de crime ou de délit flagrant',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00102",
                      'Lorsqu’il existe à l’égard du conducteur ou d’un passager une ou plusieurs raisons ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00103",
                      'plausibles de soupçonner qu’il a commis, comme auteur ou complice, un crime ou un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00104",
                      'délit flagrant, les officiers de police judiciaire peuvent, assistés le cas échéant des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00105",
                      'agents de police judiciaire et des agents de police judiciaire adjoints (article 21, 1°, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00106",
                      '1° bis et 1° ter du code de procédure pénale), procéder à la visite des véhicules ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00107",
                      'circulant ou arrêtés sur la voie publique ou dans des lieux accessibles au public.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00108",
                      'Les modalités d’organisation du contrôle sont alors les mêmes que celles prévues à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00109",
                      'l’article 78-2-2 du code de procédure pénale.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.5.3 – PRÉVENIR UNE ATTEINTE GRAVE =============
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00110",
              '1.2.5.3 – Pour prévenir une atteinte grave à la sécurité des personnes et des biens',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00111",
                      'Pour prévenir une atteinte grave à la sécurité des personnes et des biens, les officiers ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00112",
                      'de police judiciaire et, sur leur ordre et sous leur responsabilité, les agents de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00113",
                      'judiciaire et agents de police judiciaire adjoints (article 21, 1°, 1° bis et 1° ter du code ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00114",
                      'de procédure pénale) peuvent :',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00115",
                      'procéder aux contrôles d’identité prévus à l’alinéa 8 de l’article 78-2 du code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00116",
                      'procédure pénale ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00117",
                      'mettre en œuvre, avec l’accord du conducteur ou, à défaut, sur instructions du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00118",
                      'procureur de la République communiquées par tout moyen, la visite des véhicules ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00119",
                      'circulant, arrêtés ou stationnant sur la voie publique ou dans des lieux accessibles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00120",
                      'au public, pour une durée maximale de trente minutes ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00121",
                      'procéder à l’inspection visuelle ou à la fouille des bagages, en présence du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00122",
                      'propriétaire, pour une durée qui ne peut excéder trente minutes.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00123",
                      'En cas de découverte d’une infraction, si le conducteur, le propriétaire du véhicule ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00124",
                      'du bagage le demande, ou si la visite a eu lieu hors leur présence, un procès-verbal ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00125",
                      'mentionnant le lieu et les dates et heures de début et de fin des opérations est établi. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00126",
                      'Un exemplaire est remis à l’intéressé, un autre transmis sans délai au procureur de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00127",
                      'République.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ========== 1.2.5.4 – MANIFESTATION ET PORT D’ARME ============
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
              "f00128",
              '1.2.5.4 – Recherche des auteurs d’une participation à une manifestation en étant porteur d’une arme',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                    "f00129",
                    'En application de l’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                    "f00130",
                    'article 78-2-5 du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: articleColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00131",
                        ', sur réquisitions écrites du procureur de la République, les officiers de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00132",
                        'judiciaire et, sous leur contrôle, les agents de police judiciaire et agents de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00133",
                        'judiciaire adjoints peuvent, sur les lieux d’une manifestation sur la voie publique ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                        "f00134",
                        'et à ses abords immédiats, procéder :',
                      ),
                ),
              ]),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00135",
                      'à l’inspection visuelle des bagages des personnes et à leur fouille, dans les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00136",
                      'conditions prévues au paragraphe III de l’article 78-2-2 ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00137",
                      'à la visite des véhicules circulant, arrêtés ou stationnant sur la voie publique ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00138",
                      'dans des lieux accessibles au public, dans les conditions prévues au paragraphe II ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00139",
                      'du même article.',
                    ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00140",
                      'Dans ce dispositif, les contrôles d’identité sont exclus : seules les mesures portant sur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00141",
                      'les bagages et les véhicules sont autorisées afin de rechercher les auteurs d’une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/controle_identite_visites_vehicules_bagages_navires_gpx_school_page.dart",
                      "f00142",
                      'participation à une manifestation en étant porteur d’une arme.',
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
