import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaMaeExecutionParJuridictionsFrPage extends StatelessWidget {
  const PaMaeExecutionParJuridictionsFrPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/mae_execution_par_juridictions_fr';

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

    Color lawRed() => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
            "f00001",
            'Retour',
          ),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
            "f00002",
            'MAE — Exécution par les juridictions françaises',
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
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00003",
              'Le mandat d’arrêt européen',
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
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00004",
              '2.4 — Exécution d’un mandat d’arrêt européen par les juridictions françaises',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                  "f00005",
                  'L’exécution, en France, d’un mandat d’arrêt européen émis par une autorité ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                  "f00006",
                  'judiciaire étrangère obéit à des règles précises : modalités de diffusion, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                  "f00007",
                  'conditions d’interpellation et de présentation devant le procureur général, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                  "f00008",
                  'rôle de la chambre de l’instruction, motifs de refus d’exécution et organisation ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                  "f00009",
                  'de la remise de la personne recherchée.',
                ),
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.1  DIFFUSION & TRANSMISSION
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00010",
              '2.4.1 — Diffusion et transmission du mandat',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00011",
              'Acheminement du mandat d’arrêt européen vers la France',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00012",
                      'Lorsque l’autorité étrangère connaît l’endroit où la personne recherchée se ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00013",
                      'trouve sur le territoire français, elle peut adresser directement le mandat ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00014",
                      'au procureur général territorialement compétent. Elle peut également en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00015",
                      'organiser la diffusion.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00016",
                      'Lorsque l’autorité judiciaire étrangère ne connaît pas l’endroit où se trouve ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00017",
                      'la personne recherchée, elle procède à la diffusion du signalement dans les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00018",
                      'systèmes appropriés (Système d’information Schengen, INTERPOL).',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.2  MODALITÉS D’EXÉCUTION
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00019",
              '2.4.2 — Modalités d’exécution du mandat',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00020",
              'Interpellation, présentation au procureur général et droits de la personne',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00021",
                        'L’agent chargé de l’exécution du mandat d’arrêt européen ne peut pénétrer dans ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00022",
                        'le domicile d’un citoyen que dans la plage horaire prévue par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00023",
                    'l’article 134 alinéa 1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00024",
                    ' (entre 6 heures et 21 heures).',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00025",
                        'La personne recherchée et appréhendée doit être conduite devant le procureur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00026",
                        'général du lieu d’arrestation dans les 48 heures. Pendant ce délai, elle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00027",
                        'bénéficie des droits prévus par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00028",
                    'les articles 63-1 à 63-7 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00029",
                    ' relatifs à la garde à vue, en application de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00030",
                    'l’article 695-27 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00031",
                      'La rétention de la personne sur le fondement du mandat d’arrêt européen n’a pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00032",
                      'la même finalité qu’une mesure de garde à vue : la personne n’est pas entendue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00033",
                      'sur les faits. Les enquêteurs l’informent uniquement de ses droits et de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00034",
                      'l’existence du titre de recherche. L’article 695-27 du Code de Procédure Pénale ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00035",
                      'lui confère toutefois les mêmes droits que ceux reconnus à une personne gardée à vue.',
                    ),
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                          "f00036",
                          'En pratique, le droit à l’assistance d’un avocat au cours des auditions a ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                          "f00037",
                          'peu vocation à s’appliquer, la personne n’étant pas interrogée sur les faits ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                          "f00038",
                          'mais uniquement sur son identité avant la notification du titre de recherche ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                          "f00039",
                          '(circulaire CRIM 11-14/E8 du 31 mai 2011).',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00040",
                      'Le procureur général vérifie l’identité de la personne, l’informe de l’existence ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00041",
                      'et du contenu du mandat d’arrêt européen, de son droit d’être assistée d’un avocat, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00042",
                      'de la faculté qu’elle a de consentir ou de s’opposer à sa remise à l’autorité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00043",
                      'judiciaire étrangère, ainsi que des conséquences juridiques liées à ce consentement.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00044",
                      'S’il décide de ne pas laisser la personne en liberté, le procureur général la présente ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00045",
                      'au premier président de la cour d’appel ou au magistrat du siège désigné par lui. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00046",
                      'Ce magistrat peut ordonner l’incarcération de la personne, à moins qu’il n’estime ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00047",
                      'que sa représentation à tous les actes de la procédure est suffisamment garantie. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00048",
                      'La chambre de l’instruction est immédiatement saisie et la personne recherchée doit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00049",
                      'lui être présentée dans les cinq jours de sa présentation au procureur général.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 2.4.2.1 et 2.4.2.2
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00050",
              '2.4.2.1 — La personne consent à sa remise',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00051",
                      'La chambre de l’instruction informe la personne recherchée des conséquences ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00052",
                      'juridiques de son consentement et de son caractère irrévocable. Il lui est également ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00053",
                      'demandé si elle renonce au principe de spécialité (limitation des poursuites aux faits ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00054",
                      'visés par le mandat).',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00055",
                      'Si la chambre de l’instruction constate que les conditions légales d’exécution du mandat ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00056",
                      'sont réunies, elle rend un arrêt accordant la remise. Elle statue dans un délai de sept ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00057",
                      'jours à compter de la comparution de la personne devant elle.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00058",
              '2.4.2.2 — La personne ne consent pas à sa remise',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00059",
                      'Lorsque la personne ne consent pas à sa remise, la chambre de l’instruction statue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00060",
                      'par décision motivée dans un délai de vingt jours à compter de sa comparution. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00061",
                      'Ce délai impose une instruction rapide du dossier et un examen précis des motifs ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00062",
                      'éventuels de refus d’exécution du mandat.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.3  MOTIFS DE REFUS
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00063",
              '2.4.3 — Motifs de refus d’exécution d’un mandat d’arrêt européen',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00064",
              '2.4.3.1 — Les motifs de refus obligatoires',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00065",
                      'Les faits auraient pu être poursuivis par les juridictions françaises et l’action ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00066",
                      'publique est éteinte par l’amnistie ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00067",
                      'La personne recherchée a déjà fait l’objet d’une décision définitive en France ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00068",
                      'dans un État membre pour les mêmes faits que ceux visés par le mandat d’arrêt, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00069",
                      'à condition que la peine ait été exécutée ou soit en cours d’exécution ;',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                  "f00070",
                  'La personne recherchée était âgée de moins de 13 ans au moment des faits ;',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00071",
                      'Le mandat a été émis dans le but de poursuivre ou de condamner une personne en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00072",
                      'raison de son sexe, de sa race, de sa religion, de son origine ethnique, de sa ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00073",
                      'nationalité, de sa langue, de ses opinions politiques, de son orientation sexuelle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00074",
                      'ou de son identité sexuelle.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00075",
              '2.4.3.2 — Les motifs de refus facultatif',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00076",
                      'Les faits, qui ne relèvent pas des catégories d’infractions mentionnées à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00077",
                      'l’article 694-32 du Code de Procédure Pénale, ne constituent pas une infraction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00078",
                      'en droit français, conformément à ',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00079",
                    'ce principe de double incrimination rappelé par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00080",
                    'l’article 695-23 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00081",
                      'Les faits objet du mandat d’arrêt européen font déjà l’objet de poursuites devant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00082",
                      'une juridiction française ou cette juridiction a décidé de ne pas engager les poursuites ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00083",
                      'ou d’y mettre fin ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00084",
                      'La personne recherchée pour l’exécution d’une peine est de nationalité française et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00085",
                      'les autorités françaises s’engagent à faire procéder à l’exécution de cette peine en France ;',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00086",
                      'Les faits pour lesquels le mandat a été émis ont été commis, en tout ou partie, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00087",
                      'sur le territoire français.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00088",
              '2.4.3.3 — Autre motif de refus facultatif : jugement rendu en l’absence de l’intéressé',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00089",
                        'L’exécution du mandat d’arrêt européen peut également être refusée lorsque le jugement ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00090",
                        'a été rendu en l’absence de la personne recherchée. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00091",
                    'L’article 695-22-1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00092",
                        ' définit toutefois les situations dans lesquelles ce motif de refus ne peut pas ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00093",
                        'être opposé.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                  "f00094",
                  'Il s’agit notamment des hypothèses suivantes :',
                ),
              ),
              const SizedBox(height: 6),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00095",
                      'la personne a été informée officiellement et de manière non équivoque, en temps utile, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00096",
                      'par citation ou par tout autre moyen, de la date et du lieu du procès ainsi que de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00097",
                      'possibilité qu’une décision soit rendue en son absence en cas de non-comparution ;',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00098",
                      'ayant eu connaissance de la date et du lieu du procès, elle a été effectivement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00099",
                      'défendue pendant celui-ci par un conseil ;',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00100",
                      'ayant reçu signification de la décision et ayant été informée de son droit de former ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00101",
                      'un recours, elle a indiqué expressément ne pas contester la décision initiale ou n’a ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00102",
                      'pas exercé de recours dans le délai imparti ;',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00103",
                      'la décision, qui n’a pas encore été notifiée, doit l’être dès la remise de la personne, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00104",
                      'avec information explicite sur la possibilité d’exercer un recours.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 2.4.4  REMISE DE LA PERSONNE RECHERCHÉE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00105",
              '2.4.4 — Remise de la personne recherchée',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
              "f00106",
              'Décision de la chambre de l’instruction et organisation pratique de la remise',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00107",
                        'La chambre de l’instruction statue par arrêt motivé. Sa décision peut consister en une ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00108",
                        'remise, un refus de remise ou une remise assortie de conditions particulières. Lorsque ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00109",
                        'la décision devient définitive, l’arrêt est notifié à la personne réclamée puis transmis ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00110",
                        'sans délai à l’autorité étrangère par le procureur général. ',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00111",
                        'Le procureur général prend ensuite les mesures nécessaires pour organiser matériellement ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00112",
                        'la remise. Celle-ci doit intervenir dans les dix jours suivant la date de la décision ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                        "f00113",
                        'définitive de la chambre de l’instruction, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                    "f00114",
                    'l’article 695-37 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00115",
                      'Si la personne réclamée est en liberté au moment où la décision autorisant la remise est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00116",
                      'prononcée, elle peut être arrêtée et placée sous écrou en vue de l’organisation de sa remise.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00117",
                      'La remise peut être différée pour des raisons humanitaires sérieuses (état de santé, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00118",
                      'situation familiale particulière, etc.) ou lorsque la personne recherchée fait déjà ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00119",
                      'l’objet de poursuites en France ou doit y purger une peine pour un autre fait que celui ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/mae_execution_par_juridictions_fr_page.dart",
                      "f00120",
                      'visé par le mandat d’arrêt européen.',
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
