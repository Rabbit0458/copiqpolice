import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaEntraideJudiciaireInternationalePage extends StatelessWidget {
  const PaEntraideJudiciaireInternationalePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/entraide_internationale';

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

    Color lawRed(BuildContext context) => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
            "f00001",
            'Retour',
          ),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
            "f00002",
            'Entraide judiciaire internationale',
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
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00003",
              'L’entraide judiciaire internationale',
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
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00004",
              '1.4 — L’entraide judiciaire internationale',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ===============================================================
          // 1.4.1  EN L’ABSENCE DE CONVENTION INTERNATIONALE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00005",
              '1.4.1 — En l’absence de convention internationale',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00006",
              'Principe de la transmission indirecte',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00007",
                    'Le principe de la transmission indirecte des demandes d’entraide est posé par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00008",
                    'l’article 694 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00009",
                      'Par l’intermédiaire du ministère de la Justice pour les demandes émanant des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00010",
                      'autorités judiciaires françaises ; le retour des pièces d’exécution s’effectue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00011",
                      'par la même voie.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00012",
                      'Par la voie diplomatique pour les demandes d’entraide étrangères à destination ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00013",
                      'des autorités françaises ; un avis est donné par voie diplomatique au ministère ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00014",
                      'des Affaires étrangères et le retour des pièces d’exécution se fait par la même voie.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00015",
                      'En cas d’urgence, les demandes d’entraide sollicitées par les autorités françaises ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00016",
                      'ou étrangères peuvent être transmises directement aux autorités judiciaires de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00017",
                      'l’État requis compétentes pour les exécuter.',
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00018",
                        'Les demandes d’entraide émanant des autorités judiciaires étrangères sont ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00019",
                        'exécutées par le procureur de la République ou par les officiers de police ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00020",
                        'judiciaire ou les agents de police judiciaire requis à cette fin par ce magistrat. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00021",
                        'Elles peuvent également être exécutées par le juge d’instruction ou par des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00022",
                        'officiers de police judiciaire agissant sur commission rogatoire dans le cadre ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00023",
                        'd’une instruction, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00024",
                    'l’article 694-2 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                          "f00025",
                          'Les demandes d’entraide sont exécutées selon les règles du Code de procédure pénale français. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                          "f00026",
                          'Les règles procédurales de l’État requérant peuvent cependant être appliquées si l’autorité ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                          "f00027",
                          'judiciaire le demande, à condition qu’elles ne réduisent pas les droits des parties ni les ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                          "f00028",
                          'garanties procédurales prévues par le Code de procédure pénale ; à défaut, la nullité est encourue.',
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 1.4.1.1  CLAUSE DE SAUVEGARDE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00029",
              '1.4.1.1 — Clause de sauvegarde de l’ordre public et des intérêts essentiels de la Nation',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00030",
              'Protection de l’ordre public et des intérêts fondamentaux de la Nation',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00031",
                      'Lorsqu’une demande d’entraide est de nature à porter atteinte à l’ordre public ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00032",
                      'ou aux intérêts essentiels de la Nation, le procureur de la République saisi de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00033",
                      'la demande, ou informé par le juge d’instruction, la transmet au procureur général, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00034",
                      'qui peut à son tour saisir le ministre de la Justice.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00035",
                      'Si le ministre de la Justice estime que la demande porte atteinte à l’ordre public ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00036",
                      'ou aux intérêts fondamentaux de la Nation, il informe l’autorité requérante de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00037",
                      'l’impossibilité de donner suite. Cette information est également notifiée à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00038",
                      'l’autorité judiciaire française concernée et fait obstacle à l’exécution de la demande d’entraide.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 1.4.1.2  MOYENS D’ENTRAIDE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00039",
              '1.4.1.2 — Moyens d’entraide',
            ),
          ),
          const SizedBox(height: 4),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00040",
                  'Le Code de procédure pénale prévoit expressément certains moyens d’entraide, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00041",
                  'notamment l’audition à distance et les procédures de surveillance et d’infiltration ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00042",
                  'sur le territoire national.',
                ),
          ),
          const SizedBox(height: 10),

          // 1.4.1.2.1 Audition à distance
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00043",
              '1.4.1.2.1 — Audition à distance',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00044",
                    'Les auditions, interrogatoires et confrontations par vidéoconférence sont prévues par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00045",
                    'l’article 694-5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00046",
                        '. Elles permettent l’exécution simultanée, sur le territoire français et à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00047",
                        'l’étranger, des demandes d’entraide.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00048",
                      'Lorsque ces actes sont réalisés à l’étranger à la demande des autorités françaises, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00049",
                      'les règles du Code de procédure pénale français demeurent applicables.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1.4.1.2.2 Surveillance et infiltration
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00050",
              '1.4.1.2.2 — Procédure de surveillance et d’infiltration',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00051",
                    'Les procédures de surveillance et d’infiltration sont prévues par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00052",
                    'les articles 694-6, 694-7 et 694-8 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00053",
                      'Surveillance poursuivie dans un État étranger : elle est autorisée, dans les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00054",
                      'conditions fixées par les conventions internationales, par le procureur de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00055",
                      'République chargé de l’enquête.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00056",
                      'Infiltration d’agents étrangers sur le territoire français : elle n’est possible ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00057",
                      'que pour les crimes ou délits entrant dans le champ d’application des articles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00058",
                      '706-73 et 706-73-1 du Code de procédure pénale. Elle requiert l’accord préalable ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00059",
                      'du ministre de la Justice et l’autorisation du procureur de la République de Paris ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00060",
                      'ou du juge d’instruction. Les agents étrangers infiltrés sont placés sous la direction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00061",
                      'd’officiers de police judiciaire français et doivent appartenir dans leur pays ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00062",
                      'd’origine à un service spécialisé.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ===============================================================
          // 1.4.2  ENTRAIDE ENTRE LES ÉTATS MEMBRES DE L’UNION EUROPÉENNE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00063",
              '1.4.2 — Entraide entre les États membres de l’Union européenne',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00064",
              'Cadre juridique de la décision d’enquête européenne',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00065",
                      'La circulaire D.A.C.G. du 16 mai 2017 présente les dispositions de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00066",
                      'l’ordonnance n° 2016-1636 du 1ᵉʳ décembre 2016 et du décret n° 2017-511 du 7 avril 2017, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00067",
                      'qui transposent la directive 2014/41/UE du Parlement européen et du Conseil du 3 avril 2014 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00068",
                      'relative à la décision d’enquête européenne en matière pénale.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00069",
                    'Conformément à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00070",
                    'l’article 694-15 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00071",
                        ', au sein de l’Union européenne, toutes les demandes d’entraide judiciaire en matière ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00072",
                        'pénale tendant à l’obtention d’éléments de preuve doivent en principe être formulées sous ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00073",
                        'forme de décision d’enquête européenne, sauf exceptions précisées par la circulaire D.A.C.G. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00074",
                        'du 16 mai 2017.',
                      ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 16),

          // 1.4.2.1  DÉCISION D’ENQUÊTE EUROPÉENNE
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00075",
              '1.4.2.1 — La décision d’enquête européenne (D.E.E.)',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00076",
              'Nature et effets de la décision d’enquête européenne',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00077",
                    'Définie par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00078",
                    'l’article 694-16 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00079",
                        ', la décision d’enquête européenne est une décision judiciaire émise par un État membre de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00080",
                        'l’Union européenne à destination d’un autre État membre. Elle utilise des formulaires communs ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00081",
                        'et permet :',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00082",
                      'De réaliser, dans certains délais, sur le territoire de l’État d’exécution, des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00083",
                      'investigations visant à obtenir, conserver ou transmettre des éléments de preuve ;',
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00084",
                  'D’organiser la communication d’éléments de preuve déjà recueillis ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00085",
                  'De transférer temporairement une personne détenue afin de lui permettre de participer à des actes d’enquête.',
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00086",
                      'Toute décision d’enquête européenne doit être reconnue et exécutée de la même manière ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00087",
                      'qu’une décision émanant d’une juridiction nationale de l’État d’exécution.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00088",
                        'Les décisions d’enquête européenne peuvent être émises d’office par les autorités ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00089",
                        'judiciaires mentionnées à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00090",
                    'l’article 694-20 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00091",
                        'Elles ne doivent toutefois pas être utilisées lorsque l’affaire relève d’une équipe ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00092",
                        'commune d’enquête, de mesures de gel de biens ou d’observation transfrontalière, ces dernières étant ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00093",
                        'régies par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00094",
                    'l’article 694-18 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // 1.4.2.2  ÉQUIPES COMMUNES D’ENQUÊTE
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00095",
              '1.4.2.2 — Les équipes communes d’enquête',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00096",
              'Création et conditions des équipes communes d’enquête',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00097",
                        'La circulaire du ministère de la Justice du 23 mars 2009 précise le régime des équipes ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00098",
                        'communes d’enquête. Il n’y a pas lieu d’émettre une décision d’enquête européenne lorsque ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00099",
                        'est mise en place une telle équipe, en application ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00100",
                    'des articles 695-2 et 695-3 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00101",
                  'L’autorité judiciaire compétente peut créer une équipe commune d’enquête sous réserve :',
                ),
              ),
              const SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00102",
                  'De l’accord préalable du ministre de la Justice ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00103",
                  'Du consentement des autres États membres concernés.',
                ),
              ),
              const SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00104",
                  'Lorsque, dans le cadre d’une procédure française, des enquêtes complexes nécessitent la mobilisation de moyens importants et impliquent d’autres États membres ;',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00105",
                      'Lorsque plusieurs États membres conduisent des enquêtes relatives à des infractions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00106",
                      'nécessitant une action coordonnée et concertée.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00107",
                      'L’équipe commune ne peut être constituée que dans le cadre d’une procédure judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00108",
                      'préexistante (enquête préliminaire, flagrance ou information judiciaire). Elle peut être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00109",
                      'créée à l’initiative du procureur de la République, dans le cadre d’une enquête préliminaire, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00110",
                      'ou du juge d’instruction après ouverture d’une information judiciaire. L’autorité judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00111",
                      'étrangère compétente peut être un magistrat du parquet ou du siège.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00112",
                        'L’Agence Eurojust, agissant par l’intermédiaire du membre national ou en tant que collège, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00113",
                        'peut demander au procureur général de mettre en place une équipe commune d’enquête, en vertu de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00114",
                    'l’article 695-5, alinéa 4, du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // 1.4.2.3  MISSIONS DES AGENTS
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00115",
              '1.4.2.3 — Mission des agents auprès des équipes communes d’enquête',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00116",
              '1.4.2.3.1 — Agents d’un État membre détachés dans l’équipe commune agissant en France',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00117",
                  'Les agents d’un État membre détachés dans l’équipe commune agissant en France peuvent :',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00118",
                      'Constater tous crimes, délits ou contraventions et en dresser procès-verbal, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00119",
                      'au besoin dans les formes prévues par le droit de leur État ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00120",
                      'Recevoir par procès-verbal les déclarations de toute personne susceptible ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00121",
                      'd’apporter des renseignements ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00122",
                      'Assister, participer ou procéder à des auditions, à condition qu’elles se réalisent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00123",
                      'sous la direction d’un ou plusieurs enquêteurs français ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00124",
                      'Assister l’officier de police judiciaire français dans l’exercice de ses fonctions, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00125",
                      'sans accomplir d’acte de coercition (mise en garde à vue, contrainte à comparaître, etc.) ;',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                  "f00126",
                  'Procéder à des surveillances et, s’ils sont spécialement habilités, à des infiltrations.',
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00127",
                      'Ces agents n’interviennent que dans la limite de la mission qui leur a été confiée. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00128",
                      'L’original des procès-verbaux qu’ils établissent est versé à la procédure française.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00129",
              '1.4.2.3.2 — Agents français détachés dans l’équipe commune agissant sur le territoire d’un État membre',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00130",
                        'Les officiers de police judiciaire et les agents de police judiciaire français détachés ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00131",
                        'auprès d’une équipe commune d’enquête peuvent procéder aux opérations prescrites par le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00132",
                        'responsable d’équipe, dans la limite des pouvoirs qui leur sont conférés par le Code de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00133",
                        'procédure pénale. Leurs missions sont définies par l’autorité de l’État sur le territoire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00134",
                        'duquel ils interviennent, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00135",
                    'l’article 695-3 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00136",
                      'Ils peuvent recevoir des déclarations et constater les infractions dans les formes prévues ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00137",
                      'par le Code de procédure pénale de l’État d’exécution, sous réserve de l’accord de cet État ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00138",
                      'Lorsqu’ils dressent des procès-verbaux, un exemplaire est adressé à l’autorité judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00139",
                      'qui leur a confié l’exécution de l’enquête (procureur de la République ou juge d’instruction).',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1.4.2.4  PRÉCISIONS PROCÉDURALES
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00140",
              '1.4.2.4 — Précisions procédurales',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00141",
              '1.4.2.4.1 — La garde à vue',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00142",
                      'Une garde à vue commencée sur le territoire d’un État membre cocontractant ne peut se ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00143",
                      'poursuivre en France, aucun texte ne le prévoyant. La remise des personnes ne peut intervenir ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00144",
                      'que dans les cadres prévus par les mécanismes de coopération judiciaire (mandat d’arrêt ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00145",
                      'européen, extradition, etc.).',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00146",
                      'À défaut de convention l’autorisant, il n’est pas possible de continuer sur un territoire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00147",
                      'étranger une garde à vue débutée en France.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
              "f00148",
              '1.4.2.4.2 — La perquisition',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00149",
                        'Lorsqu’une personne est en garde à vue dans un État membre cocontractant et qu’une ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00150",
                        'perquisition urgente de son domicile en France est nécessaire, cette mesure peut être ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                        "f00151",
                        'demandée à un magistrat français par un agent français détaché, sur le fondement de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                    "f00152",
                    'l’article 13, paragraphe 7, de la convention européenne d’entraide judiciaire du 29 mai 2000',
                  ),
                  style: TextStyle(
                    color: lawRed(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' :'),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00153",
                      'La perquisition peut être effectuée, sur le fondement des articles 57, alinéa 2, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00154",
                      'et 95 du Code de procédure pénale, en présence de deux témoins ou d’un représentant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00155",
                      'désigné par la personne dont le domicile est en cause ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00156",
                      'En enquête préliminaire, la même possibilité existe sur le fondement de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/entraide_judiciaire_internationale_page.dart",
                      "f00157",
                      'l’article 76 du Code de procédure pénale pour les perquisitions sans assentiment.',
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
