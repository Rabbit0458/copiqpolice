// Chemin : /pa/dps_dpg/procedure_penale/pp_juridictions_penales_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPpJuridictionsPenalesPage extends StatelessWidget {
  const PaPpJuridictionsPenalesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_juridictions_penales';

  // Helper pour les articles de loi en ROUGE
  TextSpan _law(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF111111) : const Color(0xFFF4F6FB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
            "f00001",
            'Juridictions pénales & voies de recours',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bandeau d’en-tête / mémo version
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                    "f00002",
                    'Version au 01/07/2025 – © COPIQ',
                  ),
                  style: GoogleFonts.fustat(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00003",
                        'Les juridictions pénales jugent les infractions et appliquent les peines prévues par la loi. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00004",
                        'On distingue les juridictions de droit commun, compétentes pour connaître de toutes les infractions ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00005",
                        'd’une catégorie déterminée, et les juridictions d’exception, dont la compétence est limitée par un texte particulier.',
                      ),
                ),
              ]),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////////////
              /// 1. LES JURIDICTIONS DE DROIT COMMUN
              ////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                  "f00006",
                  '1.1 - Les juridictions de droit commun',
                ),
                cardColor: isDark ? const Color(0xFF1E2430) : Colors.white,
                accent: const Color(0xFF1565C0),
                titleColor: isDark
                    ? const Color(0xFFBBDEFB)
                    : const Color(0xFF0D47A1),
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00007",
                      '1.1.1 - Le tribunal de police',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00008",
                        'Le tribunal de police juge les contraventions. Il est organisé et compétent selon les règles suivantes :\n\n',
                      ),
                    ),
                  ]),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00009",
                          'Organisation (1.1.1.1) : le tribunal de police est constitué par un juge du tribunal judiciaire, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00010",
                          'un officier du ministère public et un greffier. Les fonctions du ministère public sont assurées ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00011",
                          'par le procureur de la République près le tribunal judiciaire ou par le commissaire de police selon les cas.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00012",
                        'Compétence matérielle (1.1.1.2) : le tribunal de police est compétent pour juger toutes les contraventions. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00013",
                        'Article 521 du Code de procédure pénale. ',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00014",
                        'Il est également apte à connaître des contraventions connexes à un délit ou dont il a été saisi par erreur sous la qualification de délit.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00015",
                            'Compétence territoriale : est compétent le tribunal de police du lieu de commission ou de constatation de l’infraction, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00016",
                            'ou celui de la résidence du prévenu. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00017",
                        'Article 522 alinéa 1 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00018",
                        'Pour certaines infractions (par exemple en matière de transports routiers), est compétent le tribunal du siège de l’entreprise détentrice du véhicule. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00019",
                        'Article 522 alinéa 2 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00020",
                      'Modes de saisine (1.1.1.3)',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00021",
                          'Le tribunal de police peut être saisi par citation directe, convocation en justice, comparution volontaire ou renvoi d’une autre juridiction. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00022",
                          'Les modes de saisine sont définis par le Code de procédure pénale, notamment pour la procédure de l’amende forfaitaire et la citation du prévenu.',
                        ),
                  ),

                  const SizedBox(height: 16),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00023",
                      '1.1.2 - Le tribunal correctionnel',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00024",
                            'Le tribunal correctionnel est la formation de jugement normale du tribunal judiciaire en matière pénale. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00025",
                            'Il juge les délits, infractions punies d’une peine d’emprisonnement ou d’une amende importante. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00026",
                        'Article 381 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00027",
                        'Composition (1.1.2.1) : dans sa formation ordinaire, le tribunal correctionnel est une juridiction collégiale composée d’un président et de deux juges. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00028",
                        'Article 398 alinéa 1 du Code de procédure pénale.',
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00029",
                        ' Le parquet est représenté par le procureur de la République. Pour certains délits énumérés par la loi, le tribunal peut siéger à juge unique.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00030",
                            'Compétence (1.1.2.2) : le tribunal correctionnel juge tous les délits qui ne sont pas renvoyés devant une juridiction particulière. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00031",
                            'Il peut également connaître de contraventions connexes à un délit. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00032",
                        'Articles 381 et 466 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00033",
                      'Modes de saisine (1.1.2.3)',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00034",
                            'Les modes de saisine du tribunal correctionnel sont listés par le Code de procédure pénale : comparution volontaire, citation directe, convocation en justice, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00035",
                            'convocation par procès-verbal ("rendez-vous judiciaire"), comparution immédiate, comparution différée, ordonnance de renvoi du juge d’instruction ou de la chambre de l’instruction, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00036",
                            'saisine d’office en cas d’infraction à l’audience, etc. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00037",
                        'Articles 388, 389, 390, 390-1, 394, 395, 397-1-1, 419, 420-1, 675 à 678 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00038",
                        'Des procédures simplifiées existent : ordonnance pénale, comparution sur reconnaissance préalable de culpabilité, amende forfaitaire délictuelle. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00039",
                        'Articles 495 à 495-25 du Code de procédure pénale.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 16),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00040",
                      '1.1.3 - La cour d’assises',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00041",
                        'La cour d’assises juge les crimes. Elle est définie comme ayant plénitude de juridiction pour juger en premier ressort ou en appel les personnes renvoyées devant elle par décision de mise en accusation. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00042",
                        'Article 231 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00043",
                      'Il existe une cour d’assises par département. Elle se tient en principe au siège de la cour d’appel ou au chef-lieu du département, dans les locaux du tribunal judiciaire.',
                    ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00044",
                          'Composition (1.1.3.1) : la cour d’assises comprend un élément professionnel, la cour, et un élément non professionnel, le jury. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00045",
                          'La cour est composée d’un président et de deux assesseurs ; le jury est composé de six jurés en premier ressort et de neuf jurés en appel. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00046",
                          'Un jury est tiré au sort à partir des listes électorales, selon une procédure encadrée par le Code de procédure pénale.',
                        ),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00047",
                        'Les jurés doivent prêter serment, notamment en référence à la présomption d’innocence et au principe selon lequel le doute profite à l’accusé. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00048",
                        'Article 304 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00049",
                      'Le ministère public est représenté selon les cas par l’avocat général (lorsque la cour siège au siège de la cour d’appel) ou par le procureur de la République (lorsqu’elle siège dans les locaux du tribunal judiciaire).',
                    ),
                  ),
                  const SizedBox(height: 10),

                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00050",
                      '1.1.4 - La cour criminelle départementale',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00051",
                            'La cour criminelle départementale est compétente pour juger en premier ressort les personnes majeures accusées de certains crimes punis de quinze ou vingt ans de réclusion criminelle, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00052",
                            'lorsque le crime n’a pas été commis en état de récidive légale. Elle peut aussi connaître des délits connexes. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00053",
                        'Articles 380-16 à 380-22 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00054",
                          'Elle est composée exclusivement de magistrats professionnels : un président et quatre assesseurs (sans jury populaire). ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00055",
                          'Les décisions sont motivées et susceptibles d’appel devant une autre cour d’assises.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              ////////////////////////////////////////////////////////
              /// 1.2 - JURIDICTIONS D’EXCEPTION ET SPÉCIALISÉES
              ////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                  "f00056",
                  '1.2 - Les juridictions d’exception et spécialisées',
                ),
                cardColor: isDark ? const Color(0xFF1E2430) : Colors.white,
                accent: const Color(0xFF6A1B9A),
                titleColor: isDark
                    ? const Color(0xFFE1BEE7)
                    : const Color(0xFF4A148C),
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00057",
                      '1.2.1 - Les juridictions pour mineurs',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00058",
                            'Les juridictions pour mineurs sont des juridictions d’exception dont la compétence est déterminée par la qualité de l’auteur (mineur) et par la nature de l’infraction. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00059",
                            'Elles appliquent les règles du Code de justice pénale des mineurs et du Code de l’organisation judiciaire.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00060",
                            'Le juge des enfants est un magistrat spécialisé du siège, compétent pour juger les contraventions de 5ᵉ classe et de nombreux délits commis par les mineurs, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00061",
                            'notamment selon la procédure de mise à l’épreuve éducative. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00062",
                            'Article L.231-2 du Code de justice pénale des mineurs ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00063",
                            'et articles L.252-1 et suivants du Code de l’organisation judiciaire.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00064",
                        'Le tribunal pour enfants est présidé par le juge des enfants, assisté de deux assesseurs non professionnels choisis pour leur intérêt et leurs compétences en matière de protection de l’enfance. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00065",
                        'Articles L.251-1 à L.251-6 du Code de l’organisation judiciaire.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00066",
                        'La cour d’assises des mineurs est compétente pour les crimes commis par les mineurs de seize à dix-huit ans et pour certains délits ou crimes connexes. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00067",
                            'Articles L.231-7 à L.231-10 du Code de justice pénale des mineurs ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00068",
                            'et 706-25 du Code de procédure pénale.',
                          ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                              "f00069",
                              'L’appel des jugements rendus à l’égard des mineurs relève de la chambre spéciale des mineurs de la cour d’appel (chambre de l’enfance), ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                              "f00070",
                              'conformément aux dispositions du Code de justice pénale des mineurs.',
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00071",
                      '1.2.3 - Juridictions spécialisées en matière de terrorisme',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00072",
                            'Les crimes et délits à caractère terroriste peuvent être jugés par des juridictions parisiennes spécialisées (pôle antiterroriste du tribunal judiciaire de Paris et cour d’assises spéciale), ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00073",
                            'compétentes sur tout le territoire national. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00074",
                        'Articles 706-16 à 706-25 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00075",
                            'En pratique, les crimes terroristes sont souvent confiés à la cour d’assises de Paris, composée uniquement de magistrats professionnels, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00076",
                            'sans jury populaire. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00077",
                        'Article 698-6 du Code de procédure pénale.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00078",
                      '1.2.4 - Juridictions spécialisées économiques et financières',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00079",
                            'Dans les affaires d’une grande complexité en matière économique et financière (grand nombre d’auteurs, de victimes, opérations internationales, etc.), ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00080",
                            'la compétence territoriale d’un tribunal judiciaire peut être étendue au ressort de plusieurs cours d’appel pour l’enquête, la poursuite, l’instruction et le jugement. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00081",
                        'Article 704 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00082",
                        'Un procureur de la République financier exerce ses attributions près le tribunal judiciaire de Paris, mais est compétent sur tout le territoire national pour la poursuite de certaines infractions économiques et financières. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00083",
                        'Article 705 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00084",
                        'Certaines infractions boursières et financières sont expressément visées, notamment celles prévues aux articles L.465-1 à L.465-3-3 du Code monétaire et financier. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00085",
                            'Articles 705-1 et 705-2 du Code de procédure pénale ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00086",
                            'et articles L.465-1 à L.465-3-3 du Code monétaire et financier.',
                          ),
                    ),
                  ]),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00087",
                      '1.2.5 - Juridictions spécialisées en matière de criminalité organisée',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00088",
                            'La compétence territoriale d’un tribunal judiciaire et d’une cour d’assises peut être étendue au ressort d’une ou plusieurs cours d’appel pour l’enquête, la poursuite, l’instruction et le jugement de certaines infractions de criminalité organisée, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00089",
                            'celles listées à l’article 706-73 du Code de procédure pénale (terrorisme, trafics de stupéfiants, traite des êtres humains, crimes contre les intérêts fondamentaux de la Nation, etc.) ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00090",
                            'et à l’article 706-73-1. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00091",
                        'Articles 706-73, 706-73-1 et 706-74 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00092",
                        'Pour ces infractions, le procureur de la République, le juge d’instruction et la formation correctionnelle spécialisée exercent une compétence concurrente à la compétence de droit commun. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00093",
                        'Article 706-75 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00094",
                        'Huit juridictions interrégionales spécialisées (JIRS) ont été créées : Paris, Lyon, Marseille, Lille, Rennes, Bordeaux, Nancy et Fort-de-France. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00095",
                        'Article D.47-3 du Code de procédure pénale.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00096",
                      '1.2.6 - Juridictions spécialisées en matière de crimes contre l’humanité et de crimes et délits de guerre',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00097",
                            'Les crimes contre l’humanité et les crimes et délits de guerre, ainsi que les infractions qui leur sont connexes, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00098",
                            'sont susceptibles d’être jugés par les tribunaux territorialement compétents ou par des juridictions parisiennes spécialisées. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00099",
                        'Article 628-1 du Code de procédure pénale.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00100",
                      '1.2.7 - Juridiction spécialisée dans les crimes sériels ou non élucidés',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00101",
                            'Le tribunal judiciaire de Nanterre, désigné comme pôle judiciaire national spécialisé, exerce une compétence concurrente avec les tribunaux territorialement compétents ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00102",
                            'pour l’enquête, la poursuite, l’instruction et le jugement des crimes sériels ou non élucidés, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00103",
                            'ainsi que des crimes connexes. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00104",
                        'Article 706-106-1 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00105",
                      'Lorsque les investigations présentent une particulière complexité et :',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00106",
                      '✓ lorsque les crimes auront été commis ou seront susceptibles d’avoir été commis de manière répétée à des dates différentes par une même personne à l’encontre de différentes victimes ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00107",
                      '✓ et/ou lorsque leur auteur n’aura pas pu être identifié plus de 18 mois après la commission des faits.',
                    ),
                  ),

                  const SizedBox(height: 14),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00108",
                      '1.2.8 - Les autres juridictions',
                    ),
                  ),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00109",
                      '1.2.8.1 - Les tribunaux militaires',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00110",
                            'Les infractions militaires, ainsi que les crimes et délits de droit commun commis dans l’exercice du service par les militaires, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00111",
                            'relèvent de juridictions spécialisées en matière militaire. En pratique, il s’agit d’un tribunal judiciaire par cour d’appel. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00112",
                        'Article 697 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00113",
                        'Toute infraction commise par un militaire en dehors de l’exercice du service relève des juridictions de droit commun. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00114",
                        'Article L.2 du Code de justice militaire.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00115",
                        'Certains tribunaux judiciaires sont spécialement compétents pour les infractions commises par ou à l’encontre de militaires français hors du territoire national. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00116",
                        'Article L.111-1 du Code de justice militaire.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00117",
                      '1.2.8.4 - Juridictions du littoral maritime spécialisées',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00118",
                        'Certaines juridictions sont compétentes en matière de pollution des eaux maritimes par rejets de navires ou atteintes aux biens culturels maritimes. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00119",
                        'Articles 706-107 à 706-111-2 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00120",
                            'Elles ont une compétence concurrente avec les tribunaux territorialement compétents, à tous les stades de la procédure : enquête, poursuite, instruction et jugement des infractions, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00121",
                            'sauf pour certaines infractions commises en haute mer, qui relèvent de la compétence exclusive du tribunal judiciaire de Paris.',
                          ),
                    ),
                  ]),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00122",
                      '1.2.8.5 - Juridictions en matière sanitaire et environnementale',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00123",
                        'Les articles 706-2 à 706-2-3 du Code de procédure pénale prévoient une procédure applicable aux infractions en matière sanitaire et environnementale. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00124",
                        'Articles 706-2 à 706-2-3 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00125",
                        'La compétence territoriale d’un tribunal judiciaire peut être étendue au ressort d’une ou plusieurs cours d’appel pour l’enquête, la poursuite, l’instruction et, s’il s’agit de délits, le jugement des affaires complexes relatives :\n',
                      ),
                    ),
                  ]),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00126",
                      '✓ à un produit de santé ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00127",
                      '✓ à un produit destiné à l’alimentation de l’homme ou de l’animal ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00128",
                      '✓ à un produit ou une substance ou des pratiques et prestations de service médicales, paramédicales ou esthétiques régies en raison de leurs effets ou de leur dangerosité.',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00129",
                        'Actuellement, les tribunaux judiciaires de Paris et Marseille sont désignés comme pôles spécialisés. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00130",
                        'Article D.47-5 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 24),

              ////////////////////////////////////////////////////////
              /// CHAPITRE 2 – LES VOIES DE RECOURS
              ////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                  "f00131",
                  'CHAPITRE 2 : LES VOIES DE RECOURS',
                ),
                cardColor: isDark ? const Color(0xFF1E2430) : Colors.white,
                accent: const Color(0xFF3949AB),
                titleColor: isDark
                    ? const Color(0xFFC5CAE9)
                    : const Color(0xFF1A237E),
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00132",
                      '2.1 - Les différentes voies de recours',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00133",
                          'Une décision rendue par une juridiction répressive n’acquiert autorité de chose jugée que lorsqu’elle n’est plus susceptible de voie de recours. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00134",
                          'Selon la juridiction qui a rendu la décision, plusieurs voies de recours sont possibles et sont dirigées devant diverses instances.',
                        ),
                  ),
                  const SizedBox(height: 10),

                  //////////////////////////////////////////////////
                  /// 2.1.1 - Voies de recours ordinaires
                  //////////////////////////////////////////////////
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00135",
                      '2.1.1 - Les voies de recours ordinaires',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00136",
                          'Ce sont celles qui sont ouvertes pour n’importe quel motif de fond ou de forme. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00137",
                          'Elles comprennent essentiellement l’opposition et l’appel.',
                        ),
                  ),

                  const SizedBox(height: 8),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00138",
                      '2.1.1.1 - L’opposition (Art. 489 à 493-1 et 545 du C.P.P.)',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00139",
                            'L’opposition est possible lorsque le jugement a été rendu par défaut, c’est-à-dire lorsque le prévenu n’a pas comparu ou n’a pas été régulièrement avisé, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00140",
                            'ou encore lorsqu’il justifie d’une excuse valable. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00141",
                        'Articles 410, 412, 489 à 493-1 et 545 du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00142",
                      '2.1.1.1.1 - Délai',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00143",
                          'Le délai pour former opposition est en principe de 10 jours à compter de la signification du jugement si le prévenu réside en France métropolitaine, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00144",
                          'et d’un mois s’il réside hors du territoire. Pour l’ordonnance pénale, des règles particulières s’appliquent.',
                        ),
                  ),
                  const SizedBox(height: 4),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00145",
                      '2.1.1.1.2 - Effet extinctif',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00146",
                          'L’opposition anéantit la décision rendue par défaut : celle-ci ne reçoit donc pas exécution. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00147",
                          'L’opposition interrompt également la prescription de la peine et constitue le point de départ d’une nouvelle prescription de l’action publique.',
                        ),
                  ),
                  const SizedBox(height: 4),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00148",
                      '2.1.1.1.3 - Itératif défaut',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00149",
                          'Si le prévenu régulièrement avisé fait à nouveau défaut et ne comparaît pas, son opposition est déclarée non avenue. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00150",
                          'La juridiction rend alors un jugement dit « débouté d’opposition » et la décision initiale reprend toute sa valeur. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00151",
                          'Une nouvelle opposition n’est plus possible, mais la voie de l’appel reste ouverte.',
                        ),
                  ),

                  const SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00152",
                      '2.1.1.2 - L’appel',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00153",
                        'L’appel est une voie de recours qui permet à une juridiction supérieure de procéder à un nouvel examen de l’affaire jugée en première instance. ',
                      ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00154",
                        'Articles 496 et suivants du Code de procédure pénale.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00155",
                      '2.1.1.2.1 - Décisions susceptibles d’appel',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00156",
                        'Sont notamment susceptibles d’appel :\n',
                      ),
                    ),
                  ]),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00157",
                      '✓ les ordonnances juridictionnelles du juge d’instruction ou du juge des libertés et de la détention ;',
                    ),
                  ),
                  _IntroBullet(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00158",
                      '✓ certaines décisions des juridictions de jugement ou de l’application des peines ;',
                    ),
                  ),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00159",
                            'Les jugements rendus en matière correctionnelle peuvent presque toujours faire l’objet d’un appel. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                            "f00160",
                            'En matière contraventionnelle, l’appel n’est recevable que lorsque certaines conditions de gravité sont remplies. ',
                          ),
                    ),
                    _law(
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                        "f00161",
                        'Articles 496 et 546 du Code de procédure pénale.',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 6),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00162",
                      '2.1.1.2.2 - Personnes pouvant former appel',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00163",
                          'Ont notamment qualité pour interjeter appel :\n',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00164",
                          '✓ en matière criminelle : l’accusé, le ministère public, le prévenu ou l’accusé, la partie civile pour ses seuls intérêts civils, la personne civilement responsable ;\n',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00165",
                          '✓ en matière correctionnelle : toutes les parties au procès (prévenu, ministère public, partie civile, civilement responsable, assureur, administrations poursuivantes…) ;\n',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00166",
                          '✓ en matière de police : le prévenu, la partie civile, la personne civilement responsable, le ministère public et, dans certains cas, même le procureur général.',
                        ),
                  ),

                  const SizedBox(height: 6),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00167",
                      '2.1.1.2.3 - Forme et délai',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00168",
                          'L’appel est formé par déclaration au greffe de la juridiction qui a rendu la décision. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00169",
                          'Le délai est en principe de 10 jours à compter du prononcé du jugement ou de sa signification, selon le type de décision. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00170",
                          'Des délais particuliers existent, notamment en matière de détention ou de mise en liberté.',
                        ),
                  ),

                  const SizedBox(height: 6),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                      "f00171",
                      '2.1.1.2.5 - Effets de l’appel',
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00172",
                          '✓ Effet suspensif : le délai d’appel et, lorsque l’appel est formé, suspendent en principe l’exécution de la décision, sauf dans certains cas prévus par la loi (par exemple, maintien en détention).\n',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_juridictions_penales_page.dart",
                          "f00173",
                          '✓ Effet dévolutif : l’affaire est rejugée par une juridiction supérieure (la cour d’appel, chambre des appels correctionnels ou chambre de l’instruction, selon les cas).',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// TES WIDGETS PERSONNALISÉS EXACTS
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
  final String title = 'NOTA';

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
