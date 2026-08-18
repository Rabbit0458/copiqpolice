import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — LA LIBERTÉ DE LA PRESSE
///
///  D’après le polycopié « Liberté de la presse »
///
///  CHAPITRE 1 : Étapes fondamentales de la liberté de la presse
///    - Avant la loi du 29 juillet 1881
///    - Après la loi du 29 juillet 1881
///
///  CHAPITRE 2 : Le contenu de la liberté de la presse
///    - L’entreprise de presse (création, fonctionnement, transparence,
///      pluralisme, aides publiques)
///    - Les journalistes (statut, carte de presse, clause de conscience,
///      liberté et limites, protection des sources)
///
///  CHAPITRE 3 : Les limites à la liberté de la presse
///    - Infractions commises par voie de presse
///    - Personnes responsables / prescription
///    - Contrôles et saisies en matière de presse
/// ===================================================================
class LibertePressePage extends StatelessWidget {
  const LibertePressePage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/collectives/liberte_presse';

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
        ? const Color(0xFF90CAF9)
        : const Color(0xFF0D47A1);
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
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
            "f00001",
            'La liberté de la presse',
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
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00002",
              'La liberté de la presse',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00003",
                    'La liberté de la presse est une liberté fondamentale. Elle est le corollaire ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00004",
                    'de la liberté d’opinion et, plus largement, un pilier de la démocratie. ',
                  ),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00005",
                    'La presse est parfois qualifiée de « 4ème pouvoir » : elle peut influencer durablement ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00006",
                    'l’opinion publique, dénoncer les dérives du pouvoir, mais aussi fragiliser les ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00007",
                    'institutions lorsqu’elle s’éloigne de ses responsabilités.',
                  ),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00008",
              'Repères doctrinaux',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00009",
                      'Alexis de Tocqueville souligne que la souveraineté du peuple et la liberté de la presse ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00010",
                      'sont deux réalités inséparables : sans l’une, l’autre ne peut se maintenir. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00011",
                      'Philippe Burdeau rappelle toutefois que cette liberté rend parfois difficile ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00012",
                      'la tâche de gouverner, car elle se heurte aux nécessités de l’ordre public. ',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — ÉTAPES FONDAMENTALES
          // =====================================================
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00013",
              'Chapitre 1 — Les étapes fondamentales de la liberté de la presse',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00014",
                      'Le régime de la presse a connu de très fortes variations : périodes libérales, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00015",
                      'puis phases de contrôle strict voire de censure. La grande rupture reste la loi ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00016",
                      'du 29 juillet 1881, véritable charte de la liberté de la presse en France.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1.1 AVANT 1881
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00017",
              '1.1 — La liberté de la presse avant la loi du 29 juillet 1881',
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
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00018",
                        'Avant 1881, la presse reste largement soumise au contrôle du pouvoir. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00019",
                        'La liberté proclamée à la Révolution est vite encadrée par un régime ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00020",
                        'd’autorisation préalable et de censure. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00021",
                    'L’article 11 de la Déclaration des droits de l’Homme et du citoyen de 1789',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00022",
                        ' proclame pourtant « la libre communication des pensées et des opinions ». ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00023",
                        'En pratique, les régimes successifs oscillent entre ouverture et répression.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00024",
                    'Période révolutionnaire : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00025",
                        'affirmation de la liberté d’expression, multiplication des journaux, mais ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00026",
                        'déjà mise en place de mécanismes de contrôle lorsque la situation politique ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00027",
                        'se tend (excès de certains écrits, troubles à l’ordre public).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00028",
                    'Directoire, Consulat, Empire : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00029",
                        'régimes rigoureux, censure efficace. Le pouvoir freine la liberté de la presse ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00030",
                        'par autorisations, saisies, poursuites. Sous l’Empire, la presse devient un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00031",
                        'instrument de propagande étroitement surveillé.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00032",
                    'Restauration et monarchie de Juillet : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00033",
                        'le régime oscille entre liberté et « liberté surveillée ». Les périodes de crise ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00034",
                        'conduisent à des lois répressives, à des poursuites facilitée contre les journaux. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00035",
                        'Les mécanismes d’autorisation préalable et de censure demeurent fréquents.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00036",
                    'Second Empire : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00037",
                        'jusqu’aux années 1860, la presse est strictement encadrée : avertissements, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00038",
                        'suspensions, cautionnements élevés. Le régime se libéralise légèrement en fin ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00039",
                        'de période, mais sans véritable statut protecteur.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00040",
                      'Au total, avant 1881, le régime est marqué par un contrôle très fort de la presse : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00041",
                      'autorisations préalables, censure, cautionnement financier, saisies administratives. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00042",
                      'La nécessité d’une loi libérale, garantissant à la fois la liberté et la responsabilité, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00043",
                      'devient évidente.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 1.2 APRES 1881
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00044",
              '1.2 — La liberté de la presse après la loi du 29 juillet 1881',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00045",
                      'La loi du 29 juillet 1881 marque la grande rupture. Elle met fin à l’arbitraire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00046",
                      'gouvernemental et organise un régime libéral : la liberté est le principe, la répression ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00047",
                      'n’intervient qu’a posteriori, en cas d’abus.',
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00048",
                        'La loi ne s’intéresse qu’à la liberté d’opinion et d’expression : l’aspect matériel ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00049",
                        'de la presse (organisation industrielle, concentration, transparence des entreprises) ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00050",
                        'reste d’abord en retrait.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00051",
                        'Après la Seconde Guerre mondiale, l’ordonnance du 26 août 1944 cherche à éviter ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00052",
                        'les concentrations excessives et à encadrer la transparence des organes de presse. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00053",
                        'Elle sera ensuite complétée par les lois du 23 octobre 1984, du 1ᵉʳ août 1986 et du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00054",
                        '27 novembre 1986.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00055",
                    'Par une décision importante du 11 octobre 1984, le Conseil constitutionnel fait du ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00056",
                    'pluralisme des courants d’expression',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00057",
                        ' un principe à valeur constitutionnelle. Il souligne également la nécessité de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00058",
                        'la transparence pour garantir un équilibre entre liberté d’opinion et moyens ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00059",
                        'd’expression.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00060",
                  'Aujourd’hui, le régime de la liberté de la presse repose donc sur quatre piliers :',
                ),
              ),
              const SizedBox(height: 4),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00061",
                    '• Article 11 de la D.D.H.C. de 1789 ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00062",
                    '• Loi du 29 juillet 1881 ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00063",
                    '• Loi du 1ᵉʳ août 1986 ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00064",
                    '• Loi du 27 novembre 1986.',
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — CONTENU DE LA LIBERTÉ DE LA PRESSE
          // =====================================================
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00065",
              'Chapitre 2 — Le contenu de la liberté de la presse',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00066",
                      'La liberté de la presse peut être menacée par plusieurs facteurs : un régime ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00067",
                      'préventif (autorisation préalable ou censure), la dépendance à l’égard des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00068",
                      'pouvoirs publics, ou encore la domination des puissances financières. Les textes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00069",
                      'postérieurs à 1881 cherchent précisément à protéger l’indépendance de la presse, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00070",
                      'tout en rappelant les responsabilités des acteurs.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 2.1 ENTREPRISE DE PRESSE
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00071",
              '2.1 — L’entreprise de presse',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00072",
                  '2.1.1 — La création d’une entreprise de presse',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00073",
                      'L’article 5 de la loi de 1881 prévoit que « tout journal ou écrit périodique peut être publié ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00074",
                      'sans autorisation préalable, ni dépôt de cautionnement ». Il s’agit d’un régime de simple ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00075",
                      'déclaration, beaucoup plus libéral que celui de l’audiovisuel ou du cinéma.',
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00076",
                  '2.1.2 — Le fonctionnement d’une entreprise de presse',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00077",
                  '2.1.2.1 — La transparence',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00078",
                      'L’objectif est de favoriser la transparence des organes de presse et de permettre au lecteur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00079",
                      'de connaître les véritables responsables. L’ordonnance de 1944, puis la loi du 23 octobre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00080",
                      '1984 et les lois des 1ᵉʳ août et 27 novembre 1986, imposent des règles de publicité sur la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00081",
                      'propriété et la direction des entreprises de presse.',
                    ),
              ),
              const SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00082",
                    'Chaque journal doit avoir un directeur de la publication, véritable responsable pénal ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00083",
                    'L’actionnaire majoritaire ou son représentant légal doit être identifié ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00084",
                    'Chaque numéro doit mentionner les principaux dirigeants (P.-D.G., directeurs, propriétaires, etc.) ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00085",
                    'Les investissements étrangers sont limités à une certaine fraction du capital (20 % dans les règles classiques).',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00086",
                  '2.1.2.2 — Le pluralisme',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00087",
                      'Le pluralisme consiste à éviter les concentrations excessives qui mettraient en péril la diversité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00088",
                      'des opinions. La décision du Conseil constitutionnel du 29 juillet 1986 fait du pluralisme des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00089",
                      'quotidiens d’information politique et générale un objectif de valeur constitutionnelle. La loi du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00090",
                      '27 novembre 1986 précise les limites de concentration admissibles (quotas de diffusion, part du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00091",
                      'tirage national, nombre maximum de titres contrôlés par une même personne).',
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00092",
                  '2.1.2.3 — Les aides publiques',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00093",
                      'L’État soutient la presse écrite par différents mécanismes : aides fiscales (TVA réduite, exonérations), ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00094",
                      'tarifs postaux préférentiels, aides directes aux titres les plus fragiles. L’objectif affiché est de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00095",
                      'favoriser le pluralisme, mais ces aides alimentent aussi le débat sur l’indépendance réelle de la presse ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00096",
                      'vis-à-vis du pouvoir politique.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2.2 LES JOURNALISTES
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00097",
              '2.2 — Les journalistes',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00098",
                  '2.2.1 — Le statut du journaliste',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00099",
                  '2.2.1.1 — Définition',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00100",
                      'L’article 2 de la loi du 29 juillet 1881, complété par le Code du travail, définit le journaliste ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00101",
                      'professionnel comme toute personne qui exerce, à titre principal et rétribué, une activité de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00102",
                      'rédaction ou de diffusion d’informations pour un ou plusieurs organes de presse ou de communication ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00103",
                      'au public. Sont assimilés certains collaborateurs directs (rédacteurs, photographes, reporters, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00104",
                      'secrétaires de rédaction, etc.).',
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00105",
                  '2.2.1.2 — La carte d’identité professionnelle',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00106",
                      'La carte de presse est délivrée par une Commission paritaire composée de journalistes et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00107",
                      'd’éditeurs. Elle atteste de la qualité de journaliste professionnel et ouvre certains droits ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00108",
                      '(facilités de circulation, accès à certains lieux, etc.). Le refus ou le retrait de la carte ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00109",
                      'peuvent être contestés devant le juge administratif par un recours pour excès de pouvoir.',
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00110",
                  '2.2.1.3 — La clause de conscience',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00111",
                      'La clause de conscience permet au journaliste de rompre son contrat de travail avec indemnités ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00112",
                      'majorées lorsqu’un changement important dans l’orientation du journal porte atteinte à son honneur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00113",
                      'ou à ses intérêts moraux (cession du journal, cessation de la publication, modification profonde de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00114",
                      'ligne éditoriale…).',
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00115",
                  '2.2.2 — La liberté du journaliste',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00116",
                  '2.2.2.1 — Liberté dans son travail',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00117",
                      'Le journaliste se veut indépendant dans ses jugements, mais il reste salarié. Son contrat de travail ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00118",
                      'est encadré par le Code du travail et par les conventions collectives. Pour protéger au mieux cette ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00119",
                      'indépendance, des « sociétés de journalistes » se sont créées dans certains organes de presse, afin ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00120",
                      'de veiller au respect d’une éthique professionnelle (charte de 1918, Déclaration de Munich de 1971).',
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00121",
                  '2.2.2.2 — Les limites à la liberté du journaliste',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00122",
                      'Le journaliste doit vérifier ses informations, refuser les méthodes déloyales (intrusion, vol de documents, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00123",
                      'enregistrements clandestins…) et respecter le secret des sources recueillies dans l’exercice de sa fonction. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00124",
                      'Le Code de procédure pénale et le Code pénal organisent également un secret professionnel renforcé ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00125",
                      'pour protéger ses sources, sous peine de faire du journaliste un auxiliaire de police plutôt qu’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00126",
                      'acteur indépendant de l’information.',
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00127",
                  '2.2.3 — La protection du secret des sources',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00128",
                  '2.2.3.1 — Principe général',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00129",
                        'La loi du 29 juillet 1881, complétée par le Code de procédure pénale, dispose qu’il ne peut être porté atteinte ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00130",
                        'au secret des sources que si un impératif prépondérant d’intérêt public l’exige, et si les mesures d’investigation ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00131",
                        'sont strictement nécessaires et proportionnées. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00132",
                    'Le journaliste a le droit de refuser de révéler l’origine de ses informations.',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00133",
                  '2.2.3.2 — Perquisitions et saisies',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00134",
                      'Les perquisitions dans les locaux d’une entreprise de presse, d’une agence ou au domicile d’un journaliste ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00135",
                      'sont encadrées : elles doivent être décidées et dirigées par un magistrat, qui doit préciser l’infraction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00136",
                      'visée et les documents recherchés. Toute perquisition irrégulière est frappée de nullité, de même que les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00137",
                      'saisies qui en résulteraient.',
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00138",
                  '2.2.3.3 — Secret des sources et témoignage',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00139",
                      'Lorsqu’un journaliste est entendu comme témoin sur des informations recueillies dans le cadre de son activité, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00140",
                      'il bénéficie d’une protection renforcée : il peut refuser de révéler l’identité de la source. Les décisions de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00141",
                      'la Cour de cassation et de la Cour européenne des droits de l’Homme sont venues rappeler que la protection ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00142",
                      'des sources est une condition essentielle de la liberté de la presse.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — LIMITES À LA LIBERTÉ DE LA PRESSE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
              "f00143",
              'Chapitre 3 — Les limites à la liberté de la presse',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00144",
                      'La liberté de la presse ne consiste pas à pouvoir dire ou écrire n’importe quoi. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00145",
                      'La société et les individus doivent être protégés contre certains abus. La loi de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00146",
                      '1881 et les textes ultérieurs définissent donc un ensemble d’infractions commises par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00147",
                      'voie de presse.',
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00148",
                  '3.1 — Les infractions commises par voie de presse',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00149",
                  '3.1.1 — Protection des particuliers',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00150",
                    'Les injures publiques : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00151",
                        'toute expression outrageante ou terme de mépris ne renfermant l’imputation d’aucun fait. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00152",
                        'Le régime est aggravé lorsque l’injure vise un agent public ou repose sur un motif discriminatoire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00153",
                        '(origine, appartenance à une race ou une religion déterminée, sexe, orientation sexuelle, handicap…).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00154",
                    'La diffamation : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00155",
                        'allégation ou imputation d’un fait précis portant atteinte à l’honneur ou à la considération ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00156",
                        'd’une personne. Elle nécessite la preuve d’un fait susceptible de contrôle. La victime peut ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00157",
                        'demander la publication d’un droit de réponse et obtenir réparation. La diffamation non publique ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00158",
                        'constitue une contravention moins gravement sanctionnée.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00159",
                    'Atteintes à la vie privée : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00160",
                        'divulgation non autorisée d’éléments de la vie personnelle (adresse, santé, vie sentimentale…). ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00161",
                        'Elles sont réprimées par les dispositions relatives au droit au respect de la vie privée.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00162",
                  '3.1.2 — Protection de la société',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00163",
                    'Publication de fausses nouvelles : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00164",
                        'diffusion de nouvelles inexactes ou falsifiées de nature à troubler la paix publique ou à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00165",
                        'démoraliser les forces armées (article 27 loi 1881).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00166",
                    'Publication d’informations secrètes : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00167",
                        'divulgation d’informations relatives à la défense nationale, aux opérations de police, à la justice ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00168",
                        'ou au secret de l’instruction. De nombreux textes (articles 38 à 41-1 de la loi de 1881, article 39 sexies, etc.) ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00169",
                        'encadrent ces atteintes.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00170",
                        'Provocation ou apologie de crimes et délits, notamment crimes de guerre, crimes contre l’humanité ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00171",
                        'ou actes terroristes (articles 23, 24 et 24 bis loi 1881). ',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00172",
                  '3.1.3 — Protection de l’autorité de l’État et de ses représentants',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00173",
                      'Sont notamment réprimés : le non-respect des décisions de justice, la pression exercée sur les magistrats, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00174",
                      'l’injure ou la diffamation envers le Président de la République ou les membres du Gouvernement, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00175",
                      'dans les conditions prévues par le Code pénal et la loi de 1881.',
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00176",
                  '3.1.4 — Personnes responsables et prescription',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00177",
                    'Personne responsable principale : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00178",
                        'pour les écrits périodiques, il s’agit du directeur de la publication ; pour les autres, l’éditeur. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00179",
                        'À défaut, l’auteur, puis l’imprimeur, peuvent être poursuivis.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00180",
                    'Les complices : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00181",
                        'ceux qui ont participé à la diffusion ou à la publication peuvent être poursuivis comme complices, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00182",
                        'dans les conditions du Code pénal.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00183",
                    'Prescription : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00184",
                        'le délai de prescription de l’action publique en matière de délits de presse est en principe de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00185",
                        'trois mois à compter de la publication, porté à un an pour certains délits à caractère raciste ou ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00186",
                        'discriminatoire.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00187",
                  '3.2 — Contrôles et saisies en matière de presse',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00188",
                  '3.2.1 — Les contrôles',
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
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00189",
                      'Certaines publications sont plus strictement encadrées, notamment celles destinées à la jeunesse : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00190",
                      'contenu à caractère violent, pornographique ou discriminatoire. Les tribunaux peuvent ordonner la saisie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00191",
                      'ou la destruction des supports. En période d’état de siège ou d’état d’urgence, des mesures de censure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                      "f00192",
                      'exceptionnelles peuvent également être décidées.',
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00193",
                  '3.2.2 — Les perquisitions',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00194",
                        'Les perquisitions dans les locaux de presse ou chez les journalistes sont particulièrement sensibles. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                        "f00195",
                        'Elles ne peuvent être décidées que par un magistrat et doivent respecter le principe de proportionnalité. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                    "f00196",
                    'Toute dérive peut remettre en cause la confiance entre les médias et les forces de l’ordre.',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: dangerColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _ExempleBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                  "f00197",
                  'Réflexe pratique pour le policier',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                          "f00198",
                          'Lorsqu’une enquête touche un média ou un journaliste, l’agent doit toujours garder à l’esprit la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                          "f00199",
                          'protection de la liberté de la presse : prudence dans les contacts avec les rédactions, respect ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                          "f00200",
                          'des réquisitions judiciaires, attention particulière à la confidentialité des sources. La recherche ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/libertés_publiques/collectives/liberte_presse_page.dart",
                          "f00201",
                          'de la vérité ne doit jamais servir de prétexte à une pression illégitime sur le travail journalistique.',
                        ),
                  ),
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
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .95);

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
