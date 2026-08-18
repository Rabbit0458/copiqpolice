import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EnquetePreliminaireChapitre1DomainePage extends StatelessWidget {
  const EnquetePreliminaireChapitre1DomainePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/enquete_preliminaire/chapitre1_domaine';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .90);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
            "f00002",
            'Enquête préliminaire',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00003",
              'Chapitre 1 — Le domaine d’application',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO GÉNÉRALE -------------------
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                "f00004",
                'L’enquête préliminaire, prévue aux articles 75 à 78 du code de procédure pénale, est une enquête ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                "f00005",
                'légalisée par le C.P.P.',
              ),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                "f00006",
                ' et destinée à obtenir sur une infraction les premiers renseignements afin de permettre au procureur de la République de prendre une décision quant à l’opportunité des poursuites.',
              ),
            ),
          ]),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00007",
              'Elle est diligentée par la police judiciaire (officiers et agents de police judiciaire), soit à la demande du parquet, soit d’initiative. Elle est très fréquemment mise en œuvre dans la pratique.',
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00008",
              'Bien que caractérisée classiquement par l’absence de coercition, l’enquête préliminaire n’est pas pour autant dépourvue de risques pour les libertés individuelles, ce qui justifie un encadrement procédural strict.',
            ),
          ),
          const SizedBox(height: 14),

          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00009",
              'L’enquête préliminaire est une enquête légalement organisée aux articles 75 à 78 du C.P.P.',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00010",
              'Elle vise à recueillir les premiers renseignements sur une infraction afin d’éclairer la décision du procureur de la République sur l’opportunité des poursuites.',
            ),
          ),
          _IntroBullet(
            text: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00011",
              'Elle est diligentée par la police judiciaire, à la demande du parquet ou d’initiative, et peut porter atteinte aux libertés si ses règles ne sont pas strictement respectées.',
            ),
          ),

          const SizedBox(height: 20),

          // =======================================================
          // 1.1 — LES INFRACTIONS
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00012",
              '1.1 — Les infractions',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00013",
                      'Tous les crimes, délits et contraventions peuvent faire l’objet d’une enquête préliminaire. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00014",
                      'Il est même possible de traiter en enquête préliminaire des crimes et délits flagrants, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00015",
                      'le choix du cadre procédural relevant de l’appréciation de l’autorité judiciaire.',
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00016",
                    'La seule limite tient au principe selon lequel, lorsqu’une information judiciaire est ouverte, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00017",
                    'la police judiciaire ne peut plus agir que pour exécuter les délégations du magistrat instructeur ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00018",
                    '(article 14 alinéa 2 du code de procédure pénale).',
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00019",
                      'Ainsi, tant qu’un officier de police judiciaire (O.P.J.) ou un agent de police judiciaire (A.P.J.) ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00020",
                      'n’a pas connaissance qu’une infraction fait l’objet d’une information judiciaire, les actes accomplis ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00021",
                      'dans le cadre de l’enquête préliminaire demeurent réguliers.',
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00022",
                      'Le basculement vers l’information judiciaire ne prive pas rétroactivement de validité les actes régulièrement accomplis en enquête préliminaire avant que les enquêteurs n’aient connaissance de l’ouverture de cette information.',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // 1.2 — LES PERSONNES
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00023",
              '1.2 — Les personnes',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00024",
                  '1.2.1 — Le principe',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00025",
                      'Toute personne qui réside sur le territoire français peut se trouver impliquée dans une enquête préliminaire. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00026",
                      'Ce principe de compétence personnelle large connaît toutefois des exceptions et des règles particulières, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00027",
                      'notamment en raison de certains statuts protecteurs ou immunités.',
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00028",
                  '1.2.2 — Les exceptions',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00029",
                      'Certaines personnes bénéficient d’un régime dérogatoire qui limite, voire exclut, la possibilité de mesures ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00030",
                      'd’enquête habituelles à leur encontre.',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00031",
                      'Les agents diplomatiques accrédités en France, en raison de leur statut protégé par le droit international, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00032",
                      'bénéficient d’immunités qui font obstacle, sauf exceptions, aux mesures d’enquête et de contrainte ordinaires.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00033",
                      'Le Président de la République bénéficie d’une irresponsabilité à raison des actes accomplis dans l’exercice de ses fonctions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00034",
                      'et d’une inviolabilité totale durant son mandat.',
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00035",
                  '1.2.3 — Les règles particulières',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00036",
                      'D’autres catégories de personnes ne sont pas totalement exclues du champ de l’enquête préliminaire, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00037",
                      'mais bénéficient de règles spécifiques limitant certaines mesures d’enquête, notamment les mesures ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00038",
                      'privatives ou restrictives de liberté.',
                    ),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00039",
                  '1.2.3.1 — Les agents consulaires',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00040",
                      'La plupart des conventions bilatérales accordent aux agents consulaires un privilège d’exemption d’arrestation, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00041",
                      'sauf en cas de crime flagrant. Cela implique, en pratique, une grande prudence pour toute mesure de contrainte ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00042",
                      'à leur encontre.',
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00043",
                  '1.2.3.2 — Les parlementaires',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00044",
                      'Les parlementaires peuvent faire l’objet de poursuites pénales. Cependant, ces poursuites peuvent être suspendues ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00045",
                      'par l’assemblée concernée pendant la durée de la session parlementaire.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00046",
                    'En enquête préliminaire, lorsque l’autorité judiciaire envisage, à l’encontre d’un parlementaire, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00047",
                    'des mesures privatives ou restrictives de liberté ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00048",
                    '(par exemple garde à vue, contrôle judiciaire, etc.), elle doit préalablement obtenir une autorisation ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00049",
                    'du bureau de l’Assemblée ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00050",
                    'dont dépend ce parlementaire. À défaut de cette autorisation, la mesure ne peut légalement être exécutée.',
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00051",
                          'Ce régime vise à concilier la séparation des pouvoirs, la protection de la représentation nationale ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00052",
                          'et la nécessité de poursuites pénales lorsqu’un parlementaire est susceptible d’avoir commis une infraction.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // 1.3 — LES LIEUX
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
              "f00053",
              '1.3 — Les lieux',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00054",
                      'Dans le cadre d’une enquête préliminaire, l’introduction dans un lieu privé, et notamment dans un domicile, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00055",
                      'est en principe subordonnée à l’accord de la personne qui en a la jouissance. Ce principe reflète la protection ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00056",
                      'renforcée accordée au domicile et, plus largement, à la vie privée.',
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00057",
                  'Accord du maître des lieux',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                        "f00058",
                        'L’introduction dans un domicile ou un autre lieu privé, lorsqu’une enquête préliminaire est en cours, ',
                      ) +
                      'suppose ',
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00059",
                    'l’accord verbal et préalable du maître des lieux. ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00060",
                    'Cet accord doit être mentionné dans la procédure par l’O.P.J. ou l’A.P.J. qui intervient.',
                  ),
                ),
              ]),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00061",
                  'Perquisitions en enquête préliminaire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00062",
                      'Les perquisitions dans des lieux privés, réalisées afin d’y découvrir des documents, objets ou indices susceptibles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00063",
                      'd’intéresser l’enquête, ou des biens dont la confiscation est prévue à l’article 131-21 du code pénal, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00064",
                      'supposent en principe l’assentiment exprès et écrit de la personne chez laquelle elles ont lieu.',
                    ),
              ),
              SizedBox(height: 8),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00065",
                  'Assentiment exprès et écrit',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00066",
                          'L’assentiment doit être clair, non équivoque et matérialisé par un écrit signé par la personne concernée. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00067",
                          'Ce document, annexé à la procédure, permet de démontrer le respect des conditions légales de la perquisition ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00068",
                          'en enquête préliminaire.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00069",
                  'Perquisitions sans assentiment : intervention du JLD',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                        "f00070",
                        'Toutefois, pour les crimes et délits punis d’une peine d’emprisonnement d’une durée égale ou supérieure à trois ans ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                        "f00071",
                        '(article 76 alinéa 4 du C.P.P.), ainsi que pour les infractions prévues à l’article 706-73 du C.P.P. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                        "f00072",
                        '(article 76 et 706-90 du C.P.P.), ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00073",
                    'le juge des libertés et de la détention (J.L.D.) peut, à la requête du procureur de la République, ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                    "f00074",
                    'décider que l’assentiment de la personne n’est pas nécessaire pour procéder à la perquisition.',
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00075",
                      'Ce régime dérogatoire permet, dans des dossiers plus graves (notamment criminalité organisée, infractions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00076",
                      'visées par l’article 706-73 du C.P.P.), d’effectuer des perquisitions en enquête préliminaire sans le consentement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                      "f00077",
                      'de l’occupant, sous contrôle du J.L.D. saisi par le procureur.',
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00078",
                          'L’intervention du juge des libertés et de la détention constitue une garantie importante pour les libertés ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00079",
                          'individuelles, en encadrant strictement les perquisitions sans assentiment dans les enquêtes préliminaires ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00080",
                          'portant sur les infractions les plus graves.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _ExempleBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                  "f00081",
                  'Référence documentaire',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00082",
                          'Version au 01/07/2025 — SDCP — Tous droits réservés UoPl — Page 1. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_chapitre1_domaine_page.dart",
                          "f00083",
                          'Ces éléments rappellent que les règles présentées sont à jour à cette date et issues d’une documentation officielle.',
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
/// CARTE GLOBALE POUR CHAQUE BLOC (1.1 / 1.2 / 1.3)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (1., 2., 3. …)
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE D’INTRO (les 3 bullets au début)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
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
