// lib/gpx_scolarite_pages/cadres_juridiques/mort_inconnue/mort_inconnue_actes_delegues.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

const Color _lawColor = Color(0xFFE53935);

class MortInconnueActesDeleguesPage extends StatelessWidget {
  const MortInconnueActesDeleguesPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/mort_inconnue/actes_delegues';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
            "f00001",
            'Retour',
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
            "f00002",
            'Mort de cause inconnue',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================================================================
          //                          TITRE PAGE
          // ================================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
              "f00003",
              'Les actes délégués par le procureur de la République',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: textMain,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00004",
                    'L’article 74 du Code de procédure pénale dresse une liste précise des actes ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00005",
                    'que peuvent réaliser les officiers de police judiciaire (O.P.J.) ou, sous leur contrôle, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00006",
                    'les agents de police judiciaire (A.P.J.), sur instructions du procureur de la République. ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00007",
                    'Outre les constatations et réquisitions à personnes qualifiées, les enquêteurs peuvent ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00008",
                    'également mettre en œuvre les actes prévus aux articles 56 à 62 du Code de procédure pénale, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00009",
                    'afin de rechercher les causes du décès.',
                  ),
            ),
          ]),
          const SizedBox(height: 18),

          // ================================================================
          //                          2.2.1.1 CONSTATATIONS
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
              "f00010",
              '1. Les constatations',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00011",
                      'L’officier ou l’agent de police judiciaire procède à toutes constatations ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00012",
                      'utiles visant à déterminer les causes et les circonstances de la mort. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00013",
                      'Cela inclut l’examen du lieu, l’environnement, la position du corps, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00014",
                      'les traces visibles, les objets présents et tout élément susceptible ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00015",
                      'd’éclairer la nature du décès.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //                          2.2.1.2 AUTOPSIE
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
              "f00016",
              '2. L’autopsie',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                        "f00017",
                        'L’article 230-28 du Code de procédure pénale dispose qu’une autopsie peut être ordonnée ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                        "f00018",
                        'dans le cadre d’une enquête judiciaire mise en œuvre selon ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00019",
                    'l’article 74 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00020",
                    '. Les règles particulières figurent aux articles 230-28 à 230-31.',
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00021",
                      'L’autopsie ne peut être confiée qu’à un médecin titulaire d’un diplôme en médecine légale ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00022",
                      'ou disposant d’une expertise reconnue.',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                  "f00023",
                  'Le médecin procède aux prélèvements biologiques nécessaires et peut les placer sous scellés.',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00024",
                      'La présence des enquêteurs n’est pas obligatoire, sauf si la nature de l’enquête justifie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00025",
                      'leur présence pour guider le légiste ou être informés immédiatement.',
                    ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00026",
                          'Il est recommandé d’inclure explicitement dans la réquisition judiciaire la possibilité ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00027",
                          'de placer sous scellés les objets ou prélèvements effectués lors de l’autopsie ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00028",
                          '(circulaire JUSD1910288C du 8 avril 2019).',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00029",
                      'Le médecin légiste doit veiller à la meilleure restauration possible du corps avant sa remise ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00030",
                      'aux proches. Ceux-ci doivent être informés dans les meilleurs délais qu’une autopsie a été ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00031",
                      'ordonnée et que des prélèvements ont été réalisés, sauf impératifs de santé publique.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //                        2.2.1.3 RÉQUISITIONS
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
              "f00032",
              '3. Les réquisitions',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                        "f00033",
                        'L’officier ou l’agent de police judiciaire reçoit délégation du procureur de la République ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                        "f00034",
                        'pour requérir toute personne qualifiée afin ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                    "f00035",
                    '« d’apprécier la nature des circonstances du décès »',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                  "f00036",
                  'Le médecin est prioritairement requis : constatation du décès et examen externe du corps.',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00037",
                      'D’autres experts peuvent être requis selon la situation : armurier, serrurier, électricien, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                      "f00038",
                      'mécanicien, expert incendie, etc.',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                  "f00039",
                  'Les personnes requises doivent prêter serment par écrit, sauf si elles figurent sur l’une des listes prévues à l’article 157 du Code de procédure pénale.',
                ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00040",
                          'Toute personne refusant de déférer à une réquisition s’expose aux sanctions de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00041",
                          'l’article R 642-1 du Code pénal (contravention de 2ᵉ classe). S’agissant d’un médecin, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00042",
                          'le refus constitue un délit puni par l’article L 4163-7 du Code de la santé publique.',
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ================================================================
          //                        2.2.1.4 à 2.2.1.8 LISTE SYNTHÉTIQUE
          // ================================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
              "f00043",
              '4. Autres actes délégués',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                  "f00044",
                  'Liste des actes prévus par les articles 56 à 62 du Code de procédure pénale',
                ),
              ),
              _BulletPoint(text: 'Perquisitions'),
              _BulletPoint(text: 'Saisies'),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                  "f00045",
                  'Réquisitions à toute personne, établissement ou organisme privé, public ou administration',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                  "f00046",
                  'Empêcher toute personne de s’éloigner du lieu de découverte du corps jusqu’à la fin des opérations',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                  "f00047",
                  'Auditions des témoins, y compris par comparution forcée',
                ),
              ),
              _SizedGap(),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00048",
                          'Dans ce cadre d’enquête, l’officier de police judiciaire ne peut pas placer une personne en garde à vue. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                          "f00049",
                          'Le procureur de la République ne peut pas non plus délivrer de mandat de recherche.',
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

class _SizedGap extends StatelessWidget {
  const _SizedGap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 8);
}

////////////////////////////////////////////////////////////////////////////////
//                        WIDGETS PERSONNALISÉS
////////////////////////////////////////////////////////////////////////////////
// (identiques à tes widgets standard : _ConditionCard, _Paragraph, _BulletPoint, etc.)
// ------------------------------------------------------------------------------

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
    return Container(
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
    final color = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text!,
        style: GoogleFonts.fustat(
          height: 1.45,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        textAlign: TextAlign.justify,
      );
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: GoogleFonts.fustat(
          height: 1.45,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans!,
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
    final iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
    final Color titleColor = borderColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
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
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/mort_inconnue/mort_inconnue_actes_delegues.dart",
                "f00050",
                'NOTA : ',
              ),
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
