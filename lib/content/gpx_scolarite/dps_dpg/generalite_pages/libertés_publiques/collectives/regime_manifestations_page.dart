import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — LE RÉGIME DES MANIFESTATIONS
///
///  - Définition et principe général
///  - Chapitre 1 : La réglementation de la manifestation
///       1.1 Déclaration préalable
///       1.2 Interdiction d’une manifestation
///  - Chapitre 2 : Les sanctions applicables
///       2.1 Non-respect de la déclaration ou de l’interdiction
///       2.2 Infractions commises lors d’une manifestation
///       2.3 Peines complémentaires
///       2.4 Mesures préventives
///  - Chapitre 3 : Réparation des dommages causés
/// ===================================================================
class RegimeManifestationsPage extends StatelessWidget {
  const RegimeManifestationsPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/collectives/regime_manifestations';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);
    final Color accentColor = isDark
        ? const Color(0xFF1976D2)
        : const Color(0xFF1565C0);
    final Color referenceColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
            "f00001",
            'Le régime des manifestations',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00002",
                  'Le régime juridique des manifestations\n',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00003",
                  '(articles L.211-1 et s. du Code de la sécurité intérieure)',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00004",
                    'La manifestation est un mode collectif d’exercice de la liberté d’expression. ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00005",
                    'Il n’existe pas de définition unique dans les textes, mais on désigne généralement ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00006",
                    'par manifestation toute occupation momentanée de la voie publique par un rassemblement ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00007",
                    'statique ou mobile (cortège), à caractère revendicatif, festif ou protestataire. ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                "f00008",
                'Cette liberté est reconnue comme principe à valeur constitutionnelle, mais elle doit se concilier avec la sauvegarde de l’ordre public.',
              ),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00009",
                  'Dans un régime démocratique, le droit de manifester est admis, mais encadré : ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00010",
                  'déclaration préalable, pouvoir d’interdiction en cas de risque grave pour l’ordre public, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00011",
                  'responsabilité pénale des organisateurs et des participants en cas d’infractions.',
                ),
          ),
          const SizedBox(height: 16),
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00012",
              'Référence centrale',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00013",
                      'Le régime des manifestations sur la voie publique est organisé principalement par les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00014",
                      'articles L.211-1 à L.211-10 du Code de la sécurité intérieure (C.S.I.), complétés par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00015",
                      'de nombreuses dispositions du Code pénal et du Code de procédure pénale.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — RÉGLEMENTATION
          // =====================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00016",
              'Chapitre 1 — La réglementation de la manifestation',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 14),

          // ------------------ 1.1 DÉCLARATION ------------------
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00017",
              '1.1  La déclaration préalable',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00018",
                        'L’article L.211-1 du C.S.I. pose le principe : « Sont soumis à l’obligation d’une déclaration préalable ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00019",
                        'tous cortèges, défilés et rassemblements de personnes sur la voie publique », ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00020",
                    'à l’exception notamment des manifestations traditionnelles à caractère folklorique ou religieux.',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00021",
                      'La déclaration permet à l’autorité de police d’évaluer le risque de troubles à l’ordre public et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00022",
                      'd’adapter le dispositif (itinéraire, forces engagées, restrictions éventuelles).',
                    ),
              ),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00023",
                  '→ Lieu de la déclaration',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00024",
                    'À Paris : la déclaration est déposée à la préfecture de police.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00025",
                    'Dans les villes où la police est étatisée : la déclaration est faite à la préfecture ou à la sous-préfecture.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00026",
                        'Dans les autres communes : la déclaration est déposée à la mairie. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00027",
                        'Si la manifestation traverse plusieurs communes, chacune des mairies concernées doit être saisie.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00028",
                  '→ Délai à respecter',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00029",
                    'La déclaration doit parvenir au moins trois jours francs avant la manifestation et au plus quinze jours francs avant la date prévue.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00030",
                  '→ Contenu de la déclaration',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00031",
                    'Identité des organisateurs (noms, prénoms, domiciles) avec au minimum un signataire.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00032",
                    'Objet de la manifestation (revendications, thème, nature).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00033",
                    'Lieu du rassemblement, date, heure de départ, durée approximative et, le cas échéant, itinéraire détaillé.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00034",
                    'Signature des organisateurs ; un récépissé de déclaration doit être délivré immédiatement.',
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00035",
                  'Rigueur accrue en période exceptionnelle',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00036",
                          'En cas d’état de siège, d’état d’urgence ou de mise en œuvre de l’article 16 de la Constitution, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00037",
                          'les pouvoirs de police peuvent être très largement renforcés : interdictions générales, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00038",
                          'couvre-feux, restrictions de circulation, etc.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 1.2 INTERDICTION ------------------
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00039",
              '1.2  L’interdiction d’une manifestation',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00040",
                        'L’article L.211-4 du C.S.I. permet à l’autorité investie des pouvoirs de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00041",
                        '(préfet, ou maire dans certaines communes) d’interdire une manifestation déclarée ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00042",
                    'lorsqu’elle est de nature à troubler gravement l’ordre public et qu’aucune autre mesure moins restrictive ne permet d’éviter le trouble.',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00043",
                      'L’interdiction prend la forme d’un arrêté motivé, notifié aux organisateurs par un officier de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00044",
                      'ou par tout autre agent mandaté. Si la notification individuelle est impossible, la décision est rendue publique « par tous moyens ». ',
                    ),
              ),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00045",
                  'Contrôle préfectoral et contentieux',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00046",
                        'Lorsque l’interdiction est décidée par le maire dans une zone de police non étatisée, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00047",
                        'l’arrêté doit être transmis au préfet dans les 24 heures.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00048",
                        'Si le préfet estime que l’interdiction n’est pas justifiée, il peut saisir le tribunal administratif ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00049",
                        'et demander la suspension de l’arrêté par la procédure du sursis à exécution.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00050",
                        'À l’inverse, si le maire refuse d’interdire une manifestation alors que les troubles sont manifestement prévisibles, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00051",
                        'le préfet peut se substituer à lui et prendre lui-même l’arrêté d’interdiction.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00052",
                  'Conditions de légalité de l’interdiction',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00053",
                    'Existence d’un danger réel de troubles graves à l’ordre public directement liés à la manifestation projetée.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00054",
                    'Absence d’un autre moyen efficace (modification du parcours, horaires, renforcement du dispositif policier…) pour maintenir l’ordre public.',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00055",
                      'L’arrêté d’interdiction peut faire l’objet d’un recours en référé devant le tribunal administratif, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00056",
                      'qui vérifie la réalité du risque, la nécessité et la proportionnalité de la mesure.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — SANCTIONS
          // =====================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00057",
              'Chapitre 2 — Les sanctions applicables',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 14),

          // ------------------ 2.1 NON-RESPECT DECLARATION --------
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00058",
              '2.1  Non-respect de la déclaration préalable\n     ou de l’interdiction de manifester',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00059",
                  '2.1.1  Article 431-9 du Code pénal',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00060",
                    'Est puni de 6 mois d’emprisonnement et 7 500 € d’amende le fait :',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00061",
                    'd’avoir organisé une manifestation sur la voie publique n’ayant pas fait l’objet d’une déclaration préalable ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00062",
                    'd’avoir organisé une manifestation sur la voie publique malgré une interdiction régulièrement notifiée ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00063",
                    'd’avoir présenté une déclaration incomplète ou inexacte destinée à tromper l’autorité sur l’objet ou les conditions de la manifestation.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00064",
                  '2.1.2  Article R.644-4 du Code pénal',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00065",
                        'La participation à une manifestation interdite sur le fondement de l’article L.211-4 du C.S.I. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00066",
                        'est punie de l’amende prévue pour les contraventions de 4ᵉ classe.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00067",
                  'Contrôles d’identité',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00068",
                          'Sur le fondement de l’article 78-2 alinéa 8 du Code de procédure pénale, des contrôles d’identité peuvent être réalisés ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00069",
                          'aux abords des manifestations pour prévenir les atteintes aux personnes et aux biens, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00070",
                          'notamment en cas de risque avéré de violences.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 2.2 INFRACTIONS LORS MANIF --------
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00071",
              '2.2  Infractions pouvant être retenues\n     lors d’une manifestation',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00072",
                  '2.2.1  Port d’arme (article 431-10 C.P.)',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00073",
                        'Le fait de participer à une manifestation ou à une réunion publique en étant porteur d’une arme ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00074",
                        'constitue un délit puni de 3 ans d’emprisonnement et 45 000 € d’amende.',
                      ),
                ),
              ]),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00075",
                  '2.2.2  Dissimulation illicite du visage (article 431-9-1 C.P.)',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00076",
                      'Est puni d’un an d’emprisonnement et de 15 000 € d’amende le fait, sans motif légitime, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00077",
                      'de dissimuler volontairement tout ou partie de son visage lors d’une manifestation sur la voie publique ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00078",
                      'ou à ses abords immédiats, dans des circonstances faisant craindre des atteintes à l’ordre public et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00079",
                      'en vue d’échapper à son identification.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00080",
                      'Une contravention de 5ᵉ classe (art. R.645-14 C.P.) sanctionne des faits proches lorsque l’atteinte à l’ordre public est moins grave. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00081",
                      'L’infraction n’est pas constituée quand la dissimulation répond à un usage légitime (ex. carnaval traditionnel).',
                    ),
              ),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00082",
                  '2.2.3  Outrage public à l’hymne national ou au drapeau tricolore (article 433-5-1 C.P.)',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00083",
                        'Le fait d’outrager publiquement l’hymne national ou le drapeau tricolore est puni de 7 500 € d’amende ; ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00084",
                        'lorsque l’outrage est commis en réunion, la peine peut être portée à 6 mois d’emprisonnement et 7 500 € d’amende.',
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 2.3 PEINES COMPLÉMENTAIRES --------
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00085",
              '2.3  Peines complémentaires\n     relatives aux manifestations',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00086",
                  '2.3.1  Interdiction de manifester (article 131-32-1 C.P.)',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00087",
                      'Le juge peut prononcer, en peine complémentaire, une interdiction de participer à des manifestations sur la voie publique ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00088",
                      'pour une durée maximale de 3 ans lorsque certains délits ont été commis à cette occasion (violences, destructions, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00089",
                      'dégradations, infractions prévues aux articles 431-9, 431-9-1, 431-10 C.P., etc.).',
                    ),
              ),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00090",
                  '2.3.2  Interdiction de droits civiques, civils et de famille',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00091",
                        'Pour certains délits commis lors de manifestations, le juge peut également prononcer des interdictions ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00092",
                        'de droits civiques (droit de vote, d’éligibilité…), des interdictions professionnelles ou de séjour.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00093",
                  '2.3.3  Interdiction du territoire français (article L.211-14 C.S.I.)',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00094",
                        'À l’encontre d’un étranger condamné pour certaines infractions commises lors de manifestations, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00095",
                        'le juge peut prononcer une interdiction du territoire français pour une durée pouvant aller jusqu’à 3 ans ou plus, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00096",
                        'selon la gravité des faits.',
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // ------------------ 2.4 MESURES PRÉVENTIVES --------
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00097",
              '2.4  Mesures préventives autour des manifestations',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00098",
                  '2.4.1  Interdiction de porter tout objet pouvant constituer une arme',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00099",
                      'L’article L.211-3 C.S.I. permet, lorsqu’il existe des risques sérieux de troubles graves à l’ordre public, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00100",
                      'd’interdire temporairement, dans un périmètre déterminé (lieux de la manifestation et abords), ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00101",
                      'le port et le transport, sans motif légitime, d’objets pouvant constituer une arme par destination.',
                    ),
              ),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00102",
                  '2.4.2  Contrôle des personnes',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00103",
                      'Pour prévenir les atteintes à la sécurité des personnes et des biens, l’O.P.J. peut, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00104",
                      'sous le contrôle du procureur de la République, mettre en œuvre des contrôles aux abords ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00105",
                      'des manifestations (articles 78-2 et 78-2-3 C.P.P.), dans des zones et pour une durée limités.',
                    ),
              ),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00106",
                  '2.4.3  Réquisitions pour fouilles de bagages / visites de véhicules',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00107",
                      'L’article 78-2-5 C.P.P. autorise le procureur de la République à délivrer des réquisitions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00108",
                      'permettant de contrôler les bagages et les véhicules situés sur les lieux d’une manifestation ou à ses abords immédiats, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00109",
                      'afin de rechercher les infractions, notamment le port d’armes lors d’une réunion publique.',
                    ),
              ),
              const SizedBox(height: 12),

              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00110",
                  '2.4.4  Détention ou transport de substances ou produits explosifs',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00111",
                      'L’article 322-11-1 C.P. réprime la détention ou le transport de substances ou produits ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00112",
                      'incendiaires ou explosifs destinés à préparer des atteintes graves aux personnes ou aux biens ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00113",
                      'à l’occasion d’une manifestation. La peine peut aller jusqu’à 7 ans d’emprisonnement et 100 000 € d’amende, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00114",
                      'aggravée en cas de bande organisée ou de régime particulier.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — RÉPARATION
          // =====================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00115",
              'Chapitre 3 — Réparation des dommages causés\nau cours des manifestations',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 14),

          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
              "f00116",
              'Responsabilité de l’État (article L.211-10 C.S.I.)',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00117",
                        'L’article L.211-10 du C.S.I. prévoit que l’État est civilement responsable des dégâts et dommages ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00118",
                        'résultant des crimes et délits commis à force ouverte ou par violence lors des manifestations ou rassemblements, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                        "f00119",
                        'armés ou non armés, qu’ils visent les personnes ou les biens. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                    "f00120",
                    'Il s’agit d’une responsabilité de plein droit.',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00121",
                      'Les victimes peuvent demander réparation devant la juridiction civile. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00122",
                      'L’État peut ensuite exercer une action récursoire contre les auteurs identifiés des infractions. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                      "f00123",
                      'La commune peut également être mise en cause lorsque sa responsabilité propre est engagée.',
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                  "f00124",
                  'Intérêt opérationnel pour les forces de l’ordre',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00125",
                          'Chaque fois que des dégradations importantes sont commises lors d’une manifestation, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00126",
                          'la qualité des constatations (photographies, vidéos, auditions, procès-verbaux détaillés) est déterminante ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/regime_manifestations_page.dart",
                          "f00127",
                          'pour permettre à l’État d’engager une action récursoire contre les auteurs et de limiter le coût pour la collectivité.',
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

/// ------------------------------------------------------------------
/// CARTE DE CONTENU (bloc structuré)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PARAGRAPHES (texte simple ou riche)
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans);

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE (non utilisé ici mais dispo si tu veux en rajouter)
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
/// BLOC NOTA / MISE EN GARDE
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
