import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PPDeroulementDetentionProvisoirePage extends StatelessWidget {
  const PPDeroulementDetentionProvisoirePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_deroulement_detention_provisoire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

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
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
            "f00002",
            'Déroulement de la détention provisoire',
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
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // ====================== CHAPITRE & TITRE ==========================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00003",
              'CHAPITRE 2',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00004",
              'Déroulement de la détention provisoire',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00005",
                  'Durée de la détention provisoire, contrôle par la chambre de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00006",
                  'l’instruction et prolongations de la mesure.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ====================== 2.1 – DURÉE ===============================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00007",
              '2.1 – Durée de la détention provisoire',
            ),
          ),

          _Paragraph.rich([
            TextSpan(text: 'Selon '),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00008",
                'l’article 144-1 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00009",
                    ', la détention provisoire ne peut excéder une durée raisonnable, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00010",
                    'appréciée au regard de la gravité des faits reprochés à la ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00011",
                    'personne mise en examen et de la complexité des investigations ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00012",
                    'nécessaires à la manifestation de la vérité. Le magistrat doit ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00013",
                    'ordonner la mise en liberté dès que ces conditions et celles ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00014",
                    'prévues par ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00015",
                'l’article 144 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00016",
                ' ne sont plus remplies.',
              ),
            ),
          ]),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00017",
              'Durées maximales initiales de détention provisoire',
            ),
            cardColor: isDark
                ? const Color(0xFF102027)
                : const Color(0xFFE3F2FD),
            accent: const Color(0xFF1565C0),
            titleColor: isDark
                ? const Color(0xFFBBDEFB)
                : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00018",
                    '• En matière correctionnelle : ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00019",
                    'l’article 145-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00020",
                        ' fixe à quatre mois la durée maximale de la détention provisoire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00021",
                        'pour un délit de droit commun.',
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00022",
                    '• Pour certains délits aggravés : ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00023",
                    'l’article 145-1-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00024",
                        ' permet une durée maximale initiale de six mois lorsque ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00025",
                        'l’instruction porte notamment sur un délit commis en bande ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00026",
                        'organisée puni de dix ans d’emprisonnement ou sur certains ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00027",
                        'délits particuliers tels que le trafic de stupéfiants ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00028",
                        '(art. 222-37 C. pén.), le proxénétisme (art. 225-5 C. pén.), ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00029",
                        'l’extorsion (art. 312-1 C. pén.) ou l’association de malfaiteurs ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00030",
                        '(art. 450-1 C. pén.).',
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00031",
                    '• En matière criminelle : ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00032",
                    'l’article 145-2 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00033",
                        ' prévoit une durée maximale initiale d’un an de détention ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                        "f00034",
                        'provisoire.',
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 12),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00035",
                  'À titre exceptionnel et sous les conditions fixées par les textes, ces ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00036",
                  'durées peuvent être prolongées, notamment jusqu’à deux ans et quatre ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00037",
                  'mois en matière correctionnelle et jusqu’à quatre ans et huit mois ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00038",
                  'en matière criminelle. Le détail des rythmes et modalités de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00039",
                  'prolongation est présenté dans le tableau dédié.',
                ),
          ),

          const SizedBox(height: 22),

          // ====================== 2.2 – MISE EN ÉTAT =======================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00040",
              '2.2 – Procédure de « mise en état »',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00041",
                'La procédure de mise en état est organisée par ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00042",
                'l’article 221-3 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00043",
                    '. Lorsque trois mois se sont écoulés depuis le placement en ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00044",
                    'détention provisoire, que cette détention est toujours en cours ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00045",
                    'et que l’avis de fin d’information prévu par ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00046",
                'l’article 175 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00047",
                    ' n’a pas été délivré, le président de la chambre de l’instruction ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00048",
                    'peut décider de saisir cette chambre, d’office, à la demande du ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00049",
                    'ministère public ou de la personne mise en examen. La chambre ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00050",
                    'examine alors l’ensemble de la procédure.',
                  ),
            ),
          ]),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00051",
              'Pouvoirs de la chambre de l’instruction\n(lors de la mise en état – art. 221-3 C. proc. pén.)',
            ),
            cardColor: isDark
                ? const Color(0xFF263238)
                : const Color(0xFFE0F2F1),
            accent: const Color(0xFF00796B),
            titleColor: isDark
                ? const Color(0xFFB2DFDB)
                : const Color(0xFF004D40),
            children: [
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00052",
                      'Ordonner la mise en liberté de la personne mise en examen, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00053",
                      'assortie ou non d’un contrôle judiciaire.',
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00054",
                  'Prononcer la nullité d’un ou de plusieurs actes de procédure.',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00055",
                      'Évoquer le dossier et procéder, le cas échéant, dans les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00056",
                      'conditions prévues par les articles 201, 202, 204 et 205 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00057",
                      'du Code de procédure pénale.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00058",
                      'Procéder à une évocation partielle du dossier pour ne réaliser ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00059",
                      'que certains actes avant renvoi au juge d’instruction.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00060",
                      'Renvoyer le dossier au juge d’instruction afin de poursuivre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00061",
                      'l’information en lui prescrivant certains actes.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00062",
                      'Désigner un ou plusieurs autres juges d’instruction pour ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00063",
                      'poursuivre la procédure.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00064",
                      'Décider le dessaisissement du juge d’instruction lorsque cette ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00065",
                      'décision est indispensable à la manifestation de la vérité.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00066",
                      'Ordonner le règlement, y compris partiel, de la procédure, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00067",
                      'notamment en prononçant un ou plusieurs non-lieux.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ====================== 2.3 – PROLONGATION =======================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00068",
              '2.3 – Prolongation de la détention provisoire',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00069",
                    'La décision de prolonger une détention provisoire relève du juge ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00070",
                    'des libertés et de la détention, saisi à cette fin par une ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00071",
                    'ordonnance motivée du juge d’instruction, qui lui transmet le ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00072",
                    'dossier accompagné des réquisitions du procureur de la République, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                    "f00073",
                    'conformément aux règles de ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00074",
                'l’article 145 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                "f00075",
                ' et des articles suivants.',
              ),
            ),
          ]),
          const SizedBox(height: 8),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00076",
                  'Le juge des libertés et de la détention doit, à chaque prolongation, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00077",
                  'vérifier à nouveau la réunion des conditions légales de la détention ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00078",
                  'provisoire, son caractère exceptionnel et l’insuffisance des mesures ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00079",
                  'alternatives telles que le contrôle judiciaire ou l’assignation à ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                  "f00080",
                  'résidence avec surveillance électronique.',
                ),
          ),
          const SizedBox(height: 10),

          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
              "f00081",
              'Prolongations et tableau récapitulatif',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00082",
                      'Les régimes de prolongation (délais, durée maximale, nombre de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00083",
                      'prolongations, spécificités pour la criminalité organisée, les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00084",
                      'délits punis de dix ans, etc.) sont détaillés dans le tableau ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00085",
                      'spécifique consacré à la détention provisoire. Il constitue un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00086",
                      'outil de synthèse essentiel pour mémoriser les différents ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_deroulement_detention_provisoire.dart",
                      "f00087",
                      'cas de figure.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 26),
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
