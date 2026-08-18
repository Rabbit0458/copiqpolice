import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — LIBERTÉS PUBLIQUES
///
///  LE RÉGIME JURIDIQUE / LA RÉGLEMENTATION
///  ET L’AMÉNAGEMENT DES LIBERTÉS PUBLIQUES
///
///  CHAPITRE 1 : LES AUTORITÉS RÉGLEMENTANT LES LIBERTÉS PUBLIQUES
///    - 1.1 Compétence de principe & rôle du législateur
///    - 1.2 Rôle du pouvoir exécutif : pouvoir réglementaire
///      • Réglementation en période normale
///      • Réglementation en période exceptionnelle
///        (état de siège, article 16, état d’urgence, état d’urgence sanitaire,
///         théorie des circonstances exceptionnelles, plan Vigipirate)
///
///  CHAPITRE 2 : LES MOYENS DE RÉGLEMENTATION
///    - 2.1 Le régime répressif
///    - 2.2 Le régime préventif
///      • Autorisation préalable
///      • Déclaration préalable
///      • Interdiction préalable
/// ===================================================================
class RegimeJuridiqueLibertesPubliquesPage extends StatelessWidget {
  const RegimeJuridiqueLibertesPubliquesPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/introduction/regime_juridique';

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
        ? const Color(0xFF5E35B1)
        : const Color(0xFF4527A0);
    final Color referenceColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);
    const Color dangerColor = Color(0xFFFF3B30);

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
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
            "f00001",
            'Régime juridique des libertés',
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
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00002",
                  'Le régime juridique ou la réglementation\n',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00003",
                  'et l’aménagement des libertés publiques',
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
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00004",
                    'Il ne peut exister de liberté publique absolue : sans règles, la liberté se transforme en anarchie. ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00005",
                    'Le droit encadre donc l’exercice des libertés pour concilier protection des droits et maintien de l’ordre public. ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00006",
                    'La Déclaration de 1789 admet d’ailleurs des limites à la liberté de chacun, à condition qu’elles ne portent pas atteinte ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00007",
                    'à l’exercice de cette même liberté par les autres individus.',
                  ),
            ),
          ]),
          const SizedBox(height: 16),
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
              "f00008",
              'Idée directrice',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00009",
                      'Réglementer une liberté publique ne signifie pas la supprimer. Il s’agit de fixer des bornes juridiques pour que la liberté demeure la règle, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00010",
                      'et que la restriction reste l’exception, strictement justifiée par l’intérêt général.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 1 — LES AUTORITÉS RÉGLEMENTANT LES LIBERTÉS
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
              "f00011",
              'Chapitre 1 — Les autorités réglementant les libertés publiques',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00012",
                      'Deux grands acteurs interviennent pour encadrer les libertés publiques : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00013",
                      'le législateur (compétence de principe) et le pouvoir exécutif (pouvoir réglementaire).',
                    ),
              ),
              const SizedBox(height: 14),

              // ---------- 1.1 LÉGISLATEUR ----------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00014",
                  '1.1 – La compétence de principe et le rôle du législateur',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00015",
                        'Traditionnellement, la loi est l’outil principal pour fixer le régime des libertés publiques. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00016",
                        'La Déclaration de 1789 rappelle que seule la loi peut poser les "bornes" à l’exercice des droits. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00017",
                        'La Constitution de 1958 confie au Parlement le soin de déterminer les règles concernant les droits civiques ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00018",
                        'et les garanties fondamentales accordées aux citoyens pour leur exercice (article 34). ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00019",
                    'Le législateur dispose donc d’une compétence de principe ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00020",
                    'en matière de libertés publiques, sous réserve du respect de la hiérarchie des normes (Constitution, traités, lois…).',
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00021",
                  'Concrètement, la loi peut :',
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00022",
                    'Créer de nouvelles libertés reconnues au niveau législatif ou constitutionnel (ex. droit au respect de la vie privée, liberté de recourir à l’IVG).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00023",
                    'Définir les modalités d’exercice permettant aux citoyens de jouir effectivement de leurs droits (conditions pratiques, procédures, garanties).',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00024",
                        'Restreindre l’exercice de libertés, y compris constitutionnelles, pour concilier plusieurs exigences de valeur identique ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00025",
                        '(ex. droit de grève et continuité du service public).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00026",
                    'Supprimer une liberté préexistante, mais uniquement sous contrôle du Conseil constitutionnel et pour des raisons impérieuses.',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00027",
                    'En revanche, le législateur ne peut revenir sur une liberté publique déjà acquise que dans deux cas : ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00028",
                    'soit parce qu’elle n’a jamais été légalement consacrée, ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00029",
                        'soit parce que sa remise en cause est indispensable pour atteindre un objectif de valeur constitutionnelle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00030",
                        '(sécurité, ordre public, continuité du service, etc.).',
                      ),
                ),
              ]),
              const SizedBox(height: 12),
              _ExempleBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00031",
                  'Exemples de lois marquantes',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00032",
                      '• Loi du 17 juillet 1970 : renforce la protection de la vie privée (atteintes illicites punies, droit au respect du domicile…).\n',
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00033",
                      '• Loi du 8 mars 2024 : consacre la liberté de recourir à l’interruption volontaire de grossesse dans le respect du cadre constitutionnel.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ---------- 1.2 POUVOIR EXÉCUTIF ----------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00034",
                  '1.2 – Le rôle du pouvoir exécutif : le pouvoir réglementaire',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00035",
                        'Si la loi fixe les principes fondamentaux, le pouvoir exécutif (gouvernement, préfet, maire…) est chargé de mettre en œuvre, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00036",
                        'par des règlements, l’aménagement concret des libertés. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00037",
                        'Ce pouvoir réglementaire s’exerce principalement dans deux hypothèses : ',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00038",
                        'Compléter la loi lorsque celle-ci renvoie à un décret ou à un règlement pour préciser les conditions d’exercice de la liberté ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00039",
                        '(ex. partie réglementaire du code de la route).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00040",
                        'Prendre, au plan national ou local, les mesures nécessaires au maintien de l’ordre public, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00041",
                        'en conciliant la sécurité collective avec l’exercice des libertés (circulation, manifestations, ouverture de lieux recevant du public…).',
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00042",
                      'Le pouvoir réglementaire peut donc restreindre l’exercice d’une liberté, mais à condition de respecter les principes de légalité, de nécessité et de proportionnalité. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00043",
                      'Son intensité varie selon que l’on se trouve en période normale ou en période exceptionnelle.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // 1.2.1 / 1.2.2 — PÉRIODE NORMALE & EXCEPTIONNELLE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
              "f00044",
              '1.2.1 – Réglementation en période normale\n1.2.2 – Réglementation en période exceptionnelle',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // ------- PÉRIODE NORMALE -------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00045",
                  'A. Exercices des pouvoirs en période normale',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00046",
                      'En période ordinaire, la réglementation des libertés doit rester mesurée. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00047",
                      'Deux règles classiques gouvernent l’action de l’autorité administrative :',
                    ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00048",
                        'L’autorité ne peut interdire de manière générale et absolue l’exercice d’une liberté publique. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00049",
                        'Toute interdiction doit être limitée dans le temps, l’espace et l’objet.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00050",
                        'Toute mesure d’interdiction doit être indispensable au maintien de l’ordre public, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00051",
                        'et motivée par des circonstances précises et établies.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00052",
                      'Plus une liberté est regardée comme fondamentale (liberté d’aller et venir, de réunion, d’expression…), ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00053",
                      'plus le juge administratif contrôle strictement la proportionnalité des restrictions décidées par l’exécutif.',
                    ),
              ),
              const SizedBox(height: 14),

              // ------- PÉRIODE EXCEPTIONNELLE -------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00054",
                  'B. Réglementation en période exceptionnelle',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00055",
                        'Lorsque la survie des institutions, l’indépendance de la Nation ou la sécurité intérieure sont gravement menacées, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00056",
                        'le droit prévoit des régimes d’exception permettant un renforcement temporaire des pouvoirs de l’exécutif. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00057",
                        'Ces régimes demeurent encadrés par la Constitution et contrôlés par le juge. ',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              // -- ÉTAT DE SIÈGE --
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00058",
                  '1) L’état de siège',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00059",
                      'Issu d’une loi du XIXᵉ siècle et désormais prévu par la Constitution, l’état de siège est proclamé ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00060",
                      'en cas de péril résultant d’une guerre étrangère ou d’une insurrection armée. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00061",
                      'Il entraîne le transfert de certaines compétences de police à l’autorité militaire et autorise des mesures restrictives importantes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00062",
                      '(perquisitions de nuit, contrôle des publications, interdiction de réunions…). Sa prolongation au-delà d’une certaine durée suppose l’intervention du Parlement.',
                    ),
              ),
              const SizedBox(height: 10),

              // -- ARTICLE 16 (ÉTAT DE CRISE) --
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00063",
                  '2) L’état de crise (article 16 de la Constitution)',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00064",
                      'Lorsque les institutions de la République, l’indépendance de la Nation ou l’intégrité du territoire sont gravement et immédiatement menacées, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00065",
                      'et que le fonctionnement régulier des pouvoirs publics est interrompu, le Président de la République peut mettre en œuvre les pouvoirs exceptionnels prévus à l’article 16. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00066",
                      'Après consultation de plusieurs autorités (Premier ministre, présidents des Assemblées, Conseil constitutionnel), il concentre temporairement la plénitude des pouvoirs exécutifs et réglementaires, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00067",
                      'sous le contrôle du Conseil constitutionnel et de l’opinion publique.',
                    ),
              ),
              const SizedBox(height: 10),

              // -- ÉTAT D’URGENCE --
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00068",
                  '3) L’état d’urgence',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00069",
                        'Créé en 1955 et plusieurs fois modifié, ce régime permet de faire face à des situations de péril imminent résultant d’atteintes graves à l’ordre public ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00070",
                        'ou de calamités publiques. Il autorise notamment l’assignation à résidence, les perquisitions administratives, les interdictions de réunions ou de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00071",
                        'manifestations, ainsi que des mesures renforcées de contrôle d’identité. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00072",
                    'Les lois adoptées à la suite des attentats récents ont étendu ces prérogatives, notamment en matière de lutte antiterroriste.',
                  ),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              const SizedBox(height: 10),

              // -- ÉTAT D’URGENCE SANITAIRE --
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00073",
                  '4) L’état d’urgence sanitaire',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00074",
                      'Institué pour faire face à la pandémie de Covid-19, ce régime permet au gouvernement de prendre des mesures exceptionnelles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00075",
                      'pour lutter contre une catastrophe sanitaire : restrictions de déplacements, fermetures d’établissements recevant du public, limitation des rassemblements, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00076",
                      'fixation de plafonds de prix pour certains produits, etc. Il illustre la manière dont l’exécutif peut, sous contrôle du Parlement et du juge, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00077",
                      'adapter l’étendue des libertés en fonction d’un risque sanitaire majeur.',
                    ),
              ),
              const SizedBox(height: 10),

              // -- THÉORIE DES CIRCONSTANCES EXCEPTIONNELLES --
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00078",
                  '5) La théorie des circonstances exceptionnelles',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00079",
                      'Élaborée par la jurisprudence administrative, cette théorie permet au juge d’admettre que, dans des circonstances anormales ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00080",
                      '(guerre, troubles graves, catastrophes…), l’administration puisse disposer de pouvoirs plus étendus que ceux prévus en temps normal, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00081",
                      'afin d’assurer la continuité du service public et la sauvegarde de l’ordre. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00082",
                      'En contrepartie, ces mesures restent contrôlées a posteriori par le juge, qui vérifie que les circonstances invoquées justifiaient réellement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00083",
                      'la restriction des libertés.',
                    ),
              ),
              const SizedBox(height: 10),

              // -- PLAN VIGIPIRATE --
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00084",
                  '6) Une mesure intermédiaire : le plan Vigipirate',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00085",
                      'Le plan Vigipirate est un dispositif gouvernemental permanent, associant autorités civiles et militaires, visant à prévenir la menace terroriste. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00086",
                      'Il repose sur différents niveaux d’alerte et permet de déclencher, sans basculer dans un régime d’exception formel, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00087",
                      'un ensemble de mesures graduées de protection de la population et des infrastructures sensibles.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00088",
                      'Objectifs principaux : assurer en permanence une protection adaptée du territoire, développer la culture de vigilance de l’ensemble des acteurs, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00089",
                      'et permettre une réaction rapide et coordonnée en cas de menace identifiée.',
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00090",
                    'Niveau « vigilance » : renforcement ponctuel face à une menace localisée ou à une vulnérabilité particulière.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00091",
                    'Niveau « sécurité renforcée – risque attentat » : activation de mesures complémentaires pour une menace élevée.',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00092",
                    'Niveau « urgence attentat » : déclenché après un attentat ou en cas de menace imminente liée à un groupe terroriste identifié.',
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00093",
                  'Attention',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00094",
                      'Même en période exceptionnelle, les mesures prises restent soumises au contrôle du juge et doivent cesser dès que redevient possible un fonctionnement normal des institutions.',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — MOYENS DE RÉGLEMENTATION
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
              "f00095",
              'Chapitre 2 — Les moyens de réglementation :\nL’aménagement des libertés publiques',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00096",
                      'Aménager une liberté publique, c’est fixer les limites de son exercice. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00097",
                      'En régime démocratique, deux techniques se partagent cette fonction : le régime répressif et le régime préventif.',
                    ),
              ),
              const SizedBox(height: 16),

              // ---------- 2.1 RÉGIME RÉPRESSIF ----------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00098",
                  '2.1 – Le régime répressif',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00099",
                        'Contrairement à ce que son nom pourrait laisser penser, le régime répressif est en réalité le plus favorable aux libertés publiques. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00100",
                        'Le principe est simple : ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00101",
                    'la liberté est la règle, la sanction n’intervient qu’en cas d’abus caractérisé.',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00102",
                      'Abuse de sa liberté celui qui commet une infraction prévue par la loi (délit de presse, provocation à la haine, atteintes à la vie privée, etc.) ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00103",
                      'ou qui trouble gravement l’ordre public. La sanction est alors prononcée par le juge, à l’issue d’une procédure contradictoire, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00104",
                      'sur le fondement des textes pénaux ou administratifs applicables.',
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00105",
                  'Point clef',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                          "f00106",
                          'Dans le régime répressif, l’autorité publique n’empêche pas a priori l’exercice de la liberté : le citoyen est libre d’agir, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                          "f00107",
                          'mais il engage sa responsabilité s’il dépasse les limites fixées par la loi.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ---------- 2.2 RÉGIME PRÉVENTIF ----------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00108",
                  '2.2 – Le régime préventif',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00109",
                        'À la différence du régime répressif, le régime préventif intervient en amont : il vise à éviter les troubles avant qu’ils ne se produisent. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00110",
                        'Selon une formule classique, ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00111",
                    '« n’est permis que ce qui est autorisé expressément ou tacitement ».',
                  ),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00112",
                      'Ce régime repose sur l’action du pouvoir exécutif, responsable de l’ordre public. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00113",
                      'Trois techniques principales sont utilisées : l’autorisation préalable, la déclaration préalable et l’interdiction préalable.',
                    ),
              ),
              const SizedBox(height: 12),

              // ------ 2.2.1 Autorisation préalable ------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00114",
                  '2.2.1 – L’autorisation préalable',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00115",
                      'Certaines activités ne peuvent être exercées que si l’autorité administrative a donné son accord à l’avance. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00116",
                      'À défaut d’autorisation, la liberté ne peut s’exercer licitement.',
                    ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00117",
                    'Visa d’exploitation cinématographique délivré par le ministre de la Culture pour la diffusion d’un film ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00118",
                    'Permis de construire ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00119",
                    'Permis de conduire, soumis à des conditions de capacité et d’aptitude ;',
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00120",
                      'L’administration peut disposer d’un pouvoir d’appréciation plus ou moins large. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00121",
                      'Le juge administratif contrôle que le refus d’autorisation repose sur des motifs légaux, proportionnés et exempts d’erreur manifeste.',
                    ),
              ),
              const SizedBox(height: 12),

              // ------ 2.2.2 Déclaration préalable ------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00122",
                  '2.2.2 – La déclaration préalable',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00123",
                      'Dans ce régime, la liberté peut s’exercer, mais son titulaire doit informer préalablement l’autorité administrative, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00124",
                      'qui enregistre la déclaration et peut éventuellement prendre des mesures d’encadrement.',
                    ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00125",
                    'Déclaration en préfecture pour l’organisation d’une manifestation sur la voie publique ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00126",
                    'Information de l’employeur pour l’exercice du droit de grève ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00127",
                    'Déclaration auprès du parquet pour la création d’un journal ou d’une publication périodique.',
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00128",
                        'L’omission de la déclaration peut entraîner des sanctions pénales ou administratives. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00129",
                        'Elle ne supprime pas la liberté en elle-même, mais expose celui qui l’exerce à un risque juridique accru. ',
                      ),
                ),
              ]),
              const SizedBox(height: 12),

              // ------ 2.2.3 Interdiction préalable ------
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00130",
                  '2.2.3 – L’interdiction préalable',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: dangerColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00131",
                        'Technique la plus attentatoire aux libertés, l’interdiction préalable permet à l’autorité administrative de prohiber, avant qu’elle ne se réalise, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                        "f00132",
                        'une activité jugée dangereuse pour l’ordre public. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                    "f00133",
                    'Elle doit rester l’ultime recours, strictement encadré par le juge.',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00134",
                  'a) Au titre de polices spéciales',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00135",
                      'Certains textes prévoient explicitement la possibilité d’interdire l’exercice d’une liberté particulière : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00136",
                      'interdiction de manifester sur la voie publique en cas de risque manifeste de troubles graves, dissolution d’associations représentant une menace pour l’ordre public, etc.',
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00137",
                  'b) Au titre de la police générale',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00138",
                      'En dehors de tout texte spécial, le maire ou le préfet peuvent interdire une manifestation ou une réunion lorsqu’il apparaît qu’aucune autre mesure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00139",
                      'ne permet de prévenir un trouble grave à l’ordre public. Dans les communes à police étatisée, le préfet détient seul ce pouvoir pour les manifestations.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00140",
                      'Le juge administratif contrôle : la compétence de l’auteur de la décision, la forme de l’acte, le but poursuivi, les motifs invoqués et l’examen complet des circonstances. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                      "f00141",
                      'Ce contrôle est particulièrement approfondi lorsque sont en cause des libertés fondamentales (réunion, association, circulation…).',
                    ),
              ),
              const SizedBox(height: 10),
              _ExempleBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                  "f00142",
                  'Arrêt Benjamin (Conseil d’État, 1933)',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                          "f00143",
                          'Le maire de Nevers avait interdit une conférence littéraire, invoquant le risque de troubles lors d’une manifestation d’opposition. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                          "f00144",
                          'Le Conseil d’État annule l’interdiction : il estime qu’il existait d’autres moyens moins radicaux pour assurer l’ordre public (mobilisation de forces de police), ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                          "f00145",
                          'sans empêcher la réunion elle-même. Cet arrêt consacre le principe selon lequel l’interdiction d’une liberté ne peut être décidée que si aucune mesure moins restrictive ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/introduction/regime_juridique_libertes_publiques_page.dart",
                          "f00146",
                          'n’est suffisante pour prévenir le trouble.',
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
/// BLOC EXEMPLE
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
