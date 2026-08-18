import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class JuridictionsPrincipesGenerauxPage extends StatelessWidget {
  const JuridictionsPrincipesGenerauxPage({super.key});

  /// Chemin/route demandé
  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/juridictions_principes_generaux';

  TextSpan _cppArticle(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _cjpmArticle(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
            "f00001",
            'Juridictions – Principes généraux',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau version
              Center(
                child: Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                    "f00002",
                    'Version au 01/07/2025  © SDCP - Tous droits réservés',
                  ),
                  style: GoogleFonts.fustat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white60
                        : const Color(0xFF424242).withValues(alpha: .85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),

              ////////////////////////////////////////////////////////////
              /// CHAPITRE 1 – LES JURIDICTIONS DE JUGEMENT / PRINCIPES
              ////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                  "f00003",
                  'Chapitre 1 : Les juridictions de jugement',
                ),
                cardColor: isDark
                    ? const Color(0xFF121212)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00004",
                          'Le tribunal évoque le lieu où sont sanctionnées les personnes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00005",
                          'qui ont violé la loi et où les personnes en conflit viennent ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00006",
                          'chercher justice.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00007",
                          'Il existe plusieurs catégories de tribunaux organisés selon la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00008",
                          'nature et la gravité des litiges qui leur sont soumis.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00009",
                          'Certaines juridictions sont chargées de régler les litiges entre ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00010",
                          'les citoyens et les pouvoirs publics : ce sont les tribunaux de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00011",
                          "l'ordre administratif.",
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00012",
                          'Dans le cas de litiges entre les personnes ou d’atteintes portées ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00013",
                          'à la société, les tribunaux judiciaires sont compétents. Ils ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00014",
                          'comprennent des juridictions civiles et des juridictions pénales.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                  "f00015",
                  'Les juridictions pénales',
                ),
                cardColor: isDark
                    ? const Color(0xFF101218)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF1A237E),
                titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00016",
                          'Parmi les juridictions pénales, il faut distinguer les juridictions ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00017",
                          'de droit commun des juridictions d’exception.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00018",
                          'Les juridictions de droit commun ont compétence pour juger toutes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00019",
                          'les infractions d’une catégorie déterminée, sauf celles dont un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00020",
                          'texte spécial leur a retiré la connaissance.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00021",
                          'Les juridictions d’exception, quant à elles, n’ont qu’une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00022",
                          "compétence d’attribution étroitement délimitée par la loi, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00023",
                          'soit en considération de la nature des infractions, soit en raison ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00024",
                          'de la qualité des auteurs (mineurs par exemple).',
                        ),
                  ),
                  SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00025",
                      '1.1 - Les juridictions de droit commun',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00026",
                          'Elles statuent au fond sur l’affaire. On y trouve notamment : ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00027",
                          'le tribunal de police, le tribunal correctionnel et la cour d’assises.',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ///////////////////////////////////////////
              /// 1.1.1 – LE TRIBUNAL DE POLICE
              ///////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                  "f00028",
                  '1.1.1 - Le tribunal de police',
                ),
                cardColor: isDark
                    ? const Color(0xFF111820)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00029",
                        'Le tribunal de police est régi principalement par les ',
                      ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00030",
                        'Articles 521 à 549 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00031",
                      '1.1.1.1 - Organisation',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00032",
                            'Le tribunal de police est constitué par un juge du tribunal ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00033",
                            'judiciaire, un officier du ministère public et par un greffier (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00034",
                        'Article 523 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00035",
                            'Les fonctions du ministère public sont remplies par le procureur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00036",
                            'de la République près le tribunal judiciaire, et ce ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00037",
                            'obligatoirement pour les contraventions de 5ᵉ classe ne ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00038",
                            'relevant pas de la procédure de l’amende forfaitaire (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00039",
                        'Article 45 alinéa 1 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00040",
                            'En cas d’empêchement du commissaire de police, le procureur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00041",
                            'général désigne, pour une année entière, un ou plusieurs ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00042",
                            'remplaçants qu’il choisit parmi les commissaires et les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00043",
                            'commandants ou capitaines de police en résidence dans le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00044",
                            'ressort du tribunal judiciaire (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00045",
                        'Article 46 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00046",
                            'Pour les infractions forestières, les fonctions du ministère ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00047",
                            'public sont dévolues au directeur régional de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00048",
                            "l'administration chargée des forêts ou au fonctionnaire qu’il ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00049",
                            'désigne (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00050",
                        'Article 46 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00051",
                      '1.1.1.2 - Compétences',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00052",
                            'Le tribunal de police est compétent pour juger toutes les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00053",
                            'contraventions (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00054",
                        'Article 521 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00055",
                            'Est compétent le tribunal de police du lieu de commission ou de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00056",
                            'constatation de l’infraction ou celui de la résidence du prévenu (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00057",
                        'Article 522 alinéa 1 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00058",
                            'En cas de contravention aux règles relatives au chargement ou à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00059",
                            'l’équipement de véhicule, ou aux conditions de travail dans les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00060",
                            'transports routiers, ou encore à la coordination des transports, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00061",
                            'est compétent le tribunal du siège de l’entreprise détentrice du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00062",
                            'véhicule (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00063",
                        'Article 522 alinéa 2 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00064",
                            'Le tribunal de police n’est pas compétent pour juger les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00065",
                            'contraventions de 5ᵉ classe commises par les mineurs ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00066",
                            '(compétence des juridictions pour enfants). Les contraventions ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00067",
                            'des 4 premières classes commises par des mineurs relèvent de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00068",
                            'compétence du tribunal de police (',
                          ),
                    ),
                    _cjpmArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00069",
                        'Article L.423-1 du Code de la justice pénale des mineurs',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00070",
                      '1.1.1.3 - Modes de saisine',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00071",
                          'Les modes de saisine du tribunal de police sont définis à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00072",
                          "l'article 531 du C.P.P.",
                        ),
                  ),
                  const SizedBox(height: 6),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00073",
                          'Citation directe : consiste à faire citer l’auteur d’une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00074",
                          'contravention, par le biais d’un huissier, directement devant le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00075",
                          'tribunal de police.',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00076",
                          'Convocation en justice : elle est notifiée au prévenu soit par un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00077",
                          'greffier, un officier ou agent de police judiciaire, un assistant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00078",
                          'd’enquête agissant sous le contrôle de l’officier ou de l’agent de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00079",
                          'police judiciaire, un fonctionnaire ou agent d’une administration ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00080",
                          'relevant de l’article 28, ou un délégué ou médiateur du procureur ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00081",
                          'de la République, soit, si le prévenu est détenu, par le chef de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00082",
                          "l’établissement pénitentiaire.",
                        ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00083",
                      'Comparution volontaire.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ///////////////////////////////////////////
              /// 1.1.2 – TRIBUNAL CORRECTIONNEL
              ///////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                  "f00084",
                  '1.1.2 - Le tribunal correctionnel',
                ),
                cardColor: isDark
                    ? const Color(0xFF111820)
                    : const Color(0xFFE8F5E9),
                accent: const Color(0xFF2E7D32),
                titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00085",
                            'Le tribunal correctionnel est la formation de jugement normale ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00086",
                            'du tribunal judiciaire dans le domaine pénal. Il est régi par les ',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00087",
                        'Articles 381 à 495-25 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 12),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00088",
                      '1.1.2.1 - Composition',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00089",
                            'Le tribunal correctionnel, dans sa formation ordinaire, est une ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00090",
                            'juridiction collégiale composée d’un président et de deux juges (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00091",
                        'Article 398 alinéa 1 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00092",
                        '). Le parquet est représenté par le procureur de la République.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00093",
                            'Le tribunal correctionnel peut siéger à juge unique, notamment ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00094",
                            'pour les délits énumérés à ',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00095",
                        'l’Article 398-1 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00096",
                            ' (ex. délits liés aux chèques, au code de la route, aux armes, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00097",
                            'à la chasse…).',
                          ),
                    ),
                  ]),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00098",
                      '1.1.2.2 - Compétence',
                    ),
                  ),
                  _Paragraph.rich([
                    const TextSpan(text: 'Selon '),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00099",
                        'l’Article 381 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00100",
                            ', le tribunal correctionnel juge les délits, c’est-à-dire les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00101",
                            'infractions que la loi punit d’une peine d’emprisonnement ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00102",
                            'd’une amende supérieure ou égale à 3 750 euros.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00103",
                          'Le tribunal correctionnel est compétent pour juger tous les délits ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00104",
                          'qui ne sont pas renvoyés devant une juridiction particulière.',
                        ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00105",
                            'Il est apte à connaître des contraventions connexes à un délit et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00106",
                            'peut également juger une contravention dont il a été saisi par ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00107",
                            'erreur sous la qualification de délit (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00108",
                        'Article 466 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00109",
                            'Compétence territoriale : le tribunal du lieu de l’infraction, de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00110",
                            'la résidence ou du lieu d’arrestation ou de détention du prévenu, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00111",
                            'même lorsque cette arrestation ou cette détention a été opérée ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00112",
                            'est effectuée pour une autre cause.',
                          ),
                    ),
                  ]),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00113",
                      '1.1.2.3 - Modes de saisine',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00114",
                        'Les modes de saisine du tribunal correctionnel sont listés à ',
                      ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00115",
                        'l’Article 388 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ' :'),
                  ]),
                  const SizedBox(height: 6),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00116",
                      'Comparution volontaire (Article 389 du Code de procédure pénale).',
                    ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00117",
                          'Citation directe émanant du ministère public, de la partie civile ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00118",
                          'ou de toute administration légalement habilitée (Article 390 du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00119",
                          'Code de procédure pénale).',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00120",
                          'Convocation en justice (Article 390-1 du Code de procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00121",
                          'pénale).',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00122",
                          'Convocation par procès-verbal dite du « rendez-vous judiciaire » ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00123",
                          '(Article 394 du Code de procédure pénale).',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00124",
                          'Comparution immédiate (Article 395 du Code de procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00125",
                          'pénale).',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00126",
                          'Comparution différée (Article 397-1-1 du Code de procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00127",
                          'pénale).',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00128",
                          'Ordonnance du juge d’instruction ou de la chambre de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00129",
                          'l’instruction (Articles 179 et 213 du Code de procédure pénale).',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00130",
                          'Saisine d’office, notamment en cas d’infraction commise à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00131",
                          'l’audience d’une juridiction de jugement (Articles 675 à 678 du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00132",
                          'Code de procédure pénale).',
                        ),
                  ),

                  const SizedBox(height: 12),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00133",
                      '1.1.2.4 - Procédures simplifiées',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00134",
                            'Plusieurs procédures simplifiées existent devant le tribunal ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00135",
                            'correctionnel : ',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00136",
                        'Articles 495 à 495-6 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00137",
                        ' (ordonnance pénale), ',
                      ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00138",
                        'Articles 495-7 à 495-16 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00139",
                        ' (comparution sur reconnaissance préalable de culpabilité), ',
                      ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00140",
                        'Articles 495-17 à 495-25 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00141",
                            ' (amende forfaitaire délictuelle). Elles sont détaillées dans le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00142",
                            'fascicule n° 14 – Action publique et action civile.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00143",
                            'Le tribunal correctionnel statue également au civil sur les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00144",
                            'réparations des dommages causés aux victimes lorsqu’elles se ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00145",
                            'sont constituées partie civile, et ce quel que soit le taux des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00146",
                            'dommages et intérêts demandés. La partie civile peut se ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00147",
                            'constituer :',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00148",
                          'soit avant l’audience au greffe, soit pendant l’audience, par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00149",
                          'déclaration consignée par le greffier ou dépôt de conclusions ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00150",
                          '(Article 419 du Code de procédure pénale) ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00151",
                          'soit au stade de l’enquête devant les enquêteurs (Article 420-1 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00152",
                          'alinéa 2 du Code de procédure pénale) ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00153",
                          'soit par lettre recommandée avec avis de réception, par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00154",
                          'télécopie ou par le moyen d’une communication électronique ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00155",
                          'parvenue au moins 24 heures avant la date de l’audience ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00156",
                          '(Article 420-1 alinéa 1 du Code de procédure pénale).',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ///////////////////////////////////////////
              /// 1.1.3 – COUR D’ASSISES
              ///////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                  "f00157",
                  "1.1.3 - La cour d'assises",
                ),
                cardColor: isDark
                    ? const Color(0xFF151218)
                    : const Color(0xFFFFF3E0),
                accent: const Color(0xFFEF6C00),
                titleColor: isDark ? Colors.white : const Color(0xFFE65100),
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00158",
                            "La cour d’assises est compétente pour juger les crimes. Elle est ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00159",
                            'régie par les ',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00160",
                        'Articles 231 à 380-15 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00161",
                      '1.1.3.1 - Composition',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00162",
                          'Il y a une cour d’assises par département. Elle se tient en principe ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00163",
                          'au siège de la cour d’appel ou au chef-lieu du département, dans les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00164",
                          'locaux du tribunal judiciaire.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00165",
                      '1.1.3.1.1 - La cour',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00166",
                          'La cour d’assises a une composition originale car elle rassemble un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00167",
                          'élément professionnel, la cour, et un élément non professionnel, le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00168",
                          'jury.',
                        ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00169",
                          'La cour est composée de trois membres : un président et deux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00170",
                          'assesseurs. Le président est un conseiller à la cour d’appel, désigné ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00171",
                          'pour chaque session par le premier président de la cour d’appel. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00172",
                          'Les assesseurs sont choisis soit parmi les conseillers de la cour ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00173",
                          'd’appel, soit parmi les présidents, vice-présidents ou juges du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00174",
                          'tribunal judiciaire du lieu de la tenue des assises. L’un des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00175",
                          'assesseurs peut être un magistrat honoraire.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00176",
                      '1.1.3.1.2 - Le jury',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00177",
                          'Le jury populaire est composé de six jurés lorsque la cour d’assises ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00178",
                          'statue en premier ressort et de neuf jurés lorsqu’elle statue en appel.',
                        ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00179",
                            'Les jurés, au moment de la constitution du jury, doivent prêter ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00180",
                            'serment (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00181",
                        'Article 304 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00182",
                            '), ce serment rappelant notamment la présomption d’innocence et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00183",
                            'la règle selon laquelle le doute profite à l’accusé et aux ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00184",
                            'intérêts des victimes.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00185",
                          'Pour être juré, il faut : être Français, âgé d’au moins 23 ans, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00186",
                          'savoir lire et écrire, et jouir de ses droits civils et civiques.',
                        ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00187",
                        'Certaines incompatibilités sont prévues par les ',
                      ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00188",
                        'Articles 256 et 257 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00189",
                            ' : elles peuvent tenir aux fonctions exercées (préfets, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00190",
                            'fonctionnaires de police, militaires…), à la capacité (incapables ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00191",
                            'majeurs, majeurs en tutelle…) ou à la moralité (personnes en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00192",
                            'état d’accusation, sous mandat de dépôt ou d’arrêt, personnes ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00193",
                            'dont le bulletin n° 1 du casier judiciaire mentionne une ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00194",
                            'condamnation pour crime ou pour certains délits).',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00195",
                          'Certaines personnes peuvent être dispensées des fonctions de juré ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00196",
                          'lorsqu’elles sont âgées de plus de 70 ans ou lorsque leur résidence ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00197",
                          'principale n’est pas située dans le département siège de la cour ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00198",
                          'd’assises, dès lors qu’elles justifient d’un motif grave reconnu ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00199",
                          'valable.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00200",
                      'Désignation des jurés',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00201",
                          'À partir des listes électorales, chaque commune dresse une liste ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00202",
                          'comportant un certain nombre de noms fixé par arrêté. Ces listes sont ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00203",
                          'envoyées au greffe de la juridiction où siège la cour d’assises.',
                        ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00204",
                          'Une commission composée de magistrats, du bâtonnier de l’ordre des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00205",
                          'avocats et de personnalités électives locales établit ensuite la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00206",
                          'liste annuelle du jury. Elle exclut les personnes ne pouvant exercer ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00207",
                          'les fonctions de juré, puis procède à un tirage au sort.',
                        ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00208",
                          'Trente jours avant l’ouverture de la session d’assises, le premier ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00209",
                          'président de la cour d’appel ou son délégué, ou le président du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00210",
                          'tribunal judiciaire siège de la cour d’assises ou son délégué, tire ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00211",
                          'au sort en audience publique les noms de 35 jurés titulaires et 10 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00212",
                          'suppléants qui composeront la liste de session du jury. Ces nombres ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00213",
                          'sont portés à 45 titulaires et 15 suppléants pour la cour d’assises ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00214",
                          'de Paris ainsi que pour certaines cours désignées par arrêté du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                          "f00215",
                          'ministre de la Justice.',
                        ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00216",
                            'Quand il estime qu’un nombre important de jurés risque de ne pas ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00217",
                            'répondre à la convocation, le premier président de la cour ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00218",
                            'd’appel peut décider une augmentation de ces effectifs (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00219",
                        'Article 266 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00220",
                            'Cette liste est signifiée à chaque accusé au plus tard l’avant-',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00221",
                            'veille de l’ouverture des débats (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00222",
                        'Article 282 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00223",
                            'Avant le jugement de chaque nouvelle affaire, le président de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00224",
                            'cour d’assises tire au sort, à partir de la liste de session, les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00225",
                            'noms des 6 ou 9 jurés qui composeront le jury de jugement. À ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00226",
                            'mesure que les noms sortent de l’urne, l’accusé peut récuser ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00227",
                            'jusqu’à 4 jurés en premier ressort et jusqu’à 5 jurés en appel ; ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00228",
                            'le ministère public peut récuser plus de 3 jurés en premier ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00229",
                            'ressort et plus de 4 en appel (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00230",
                        'Articles 297 et 298 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00231",
                            'Quinze jours au moins avant l’ouverture de la session, le ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00232",
                            'greffier de la cour d’assises convoque, par courrier, chacun des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00233",
                            'jurés titulaires et suppléants. Cette convocation rappelle ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00234",
                            'l’obligation pour tout citoyen de répondre à celle-ci. Si ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00235",
                            'nécessaire, le greffier peut requérir les services de police ou ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00236",
                            'de gendarmerie afin de rechercher les jurés qui n’auraient pas ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00237",
                            'répondu et de leur remettre la convocation (',
                          ),
                    ),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00238",
                        'Article 267 du Code de procédure pénale',
                      ),
                    ),
                    const TextSpan(text: ').'),
                  ]),
                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00239",
                      '1.1.3.1.3 - Le parquet général',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00240",
                            'Le ministère public est représenté devant la cour d’assises par ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00241",
                            "l’avocat général si la cour siège au niveau de la cour d’appel, ",
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00242",
                            'ou par le procureur de la République si elle siège dans les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00243",
                            'locaux du tribunal judiciaire.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                      "f00244",
                      '1.1.3.2 - Compétence',
                    ),
                  ),
                  _Paragraph.rich([
                    const TextSpan(text: 'Selon '),
                    _cppArticle(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                        "f00245",
                        'l’Article 231 du Code de procédure pénale',
                      ),
                    ),
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00246",
                            ', « la cour d’assises a plénitude de juridiction pour juger en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00247",
                            'premier ressort ou en appel les personnes renvoyées devant elle ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00248",
                            'par la décision de mise en accusation ». Elle connaît donc des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                            "f00249",
                            'crimes et de certaines infractions connexes.',
                          ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/juridictions_principes_generaux_page.dart",
                    "f00250",
                    '© SDCP - Tous droits réservés',
                  ),
                  style: GoogleFonts.fustat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : const Color(0xFF757575),
                  ),
                ),
              ),
            ],
          ),
        ),
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
