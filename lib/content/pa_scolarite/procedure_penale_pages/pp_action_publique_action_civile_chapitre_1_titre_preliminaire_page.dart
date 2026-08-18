import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPPActionPubliqueChapitre1TitrePreliminairePage extends StatelessWidget {
  const PaPPActionPubliqueChapitre1TitrePreliminairePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_1_titre_preliminaire';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardBg = isDark
        ? const Color(0xFF2B3036)
        : const Color(0xFFF5F7FB);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleBlue = isDark ? Colors.white : const Color(0xFF0D47A1);

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
            "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
            "f00002",
            'Chapitre 1 — Titre préliminaire',
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
          // =================== EN-TÊTE CHAPITRE ============================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
              "f00003",
              'Titre préliminaire et\nfondements de la procédure pénale',
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
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00004",
                  'Repères essentiels sur les grands principes de la procédure pénale ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00005",
                  'et sur la naissance des actions publique et civile à partir d’une ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00006",
                  'même infraction.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // =================== ARTICLE PRELIMINAIRE ========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
              "f00007",
              'Article préliminaire du Code de procédure pénale',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00008",
                    'Article préliminaire du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00009",
                        ' : ce texte pose les grands principes qui s’imposent à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00010",
                        'tous les acteurs de la procédure pénale.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00011",
                  'I — Procédure équitable, contradictoire et équilibrée',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00012",
                      'La procédure pénale doit être équitable et contradictoire et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00013",
                      'préserver l’équilibre des droits des parties. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00014",
                      'Elle doit garantir la séparation entre, d’une part, les autorités ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00015",
                      'chargées de l’action publique (principalement le ministère public) ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00016",
                      'et, d’autre part, les autorités de jugement. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00017",
                      'Les personnes placées dans des conditions semblables et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00018",
                      'poursuivies pour les mêmes infractions doivent être jugées ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00019",
                      'selon les mêmes règles.',
                    ),
              ),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00020",
                  'II — Protection des victimes',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00021",
                      'L’autorité judiciaire veille, au cours de toute procédure pénale, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00022",
                      'à l’information et à la garantie des droits des victimes. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00023",
                      'Les victimes doivent pouvoir être associées à la procédure et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00024",
                      'être informées des suites données à leur affaire.',
                    ),
              ),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00025",
                  'III — Présomption d’innocence et droits de la défense',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00026",
                      'Toute personne suspectée ou poursuivie est présumée innocente ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00027",
                      'tant que sa culpabilité n’a pas été légalement établie. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00028",
                      'Les atteintes à la présomption d’innocence doivent être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00029",
                      'prévenues, réparées et réprimées conformément à la loi. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00030",
                      'La personne a le droit d’être informée des charges retenues ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00031",
                      'contre elle et d’être assistée par un défenseur.',
                    ),
              ),
              const SizedBox(height: 6),

              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00032",
                      'Si la personne ne comprend pas la langue française, elle a droit, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00033",
                      'dans une langue qu’elle comprend, à l’assistance d’un interprète ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00034",
                      'tout au long de la procédure, y compris pour les entretiens ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00035",
                      'avec son avocat en lien direct avec un interrogatoire ou une audience.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00036",
                      'Sauf renonciation expresse et éclairée de sa part, elle a droit à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00037",
                      'traduction des pièces essentielles à l’exercice de sa défense et à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00038",
                      'garantie du caractère équitable du procès.',
                    ),
              ),
              const SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00039",
                  'Mesures de contrainte et respect de la dignité',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00040",
                      'Les mesures de contrainte dont la personne peut faire l’objet sont ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00041",
                      'prises sur décision ou sous le contrôle effectif de l’autorité judiciaire. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00042",
                      'Elles doivent être strictement limitées aux nécessités de la procédure, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00043",
                      'proportionnées à la gravité de l’infraction reprochée et ne pas porter ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00044",
                      'atteinte à la dignité de la personne.',
                    ),
              ),
              const SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00045",
                  'Délai raisonnable et vie privée',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00046",
                      'Il doit être définitivement statué sur l’accusation dans un délai raisonnable. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00047",
                      'Les mesures portant atteinte à la vie privée d’une personne ne peuvent être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00048",
                      'prises, sur décision ou sous le contrôle effectif de l’autorité judiciaire, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00049",
                      'que si elles sont nécessaires à la manifestation de la vérité et proportionnées ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00050",
                      'à la gravité de l’infraction.',
                    ),
              ),
              const SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00051",
                  'Voies de recours et déclarations de la personne',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00052",
                      'Toute personne condamnée a le droit de faire examiner sa condamnation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00053",
                      'par une autre juridiction. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00054",
                      'En matière criminelle et correctionnelle, aucune condamnation ne peut être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00055",
                      'prononcée sur le seul fondement de déclarations faites par la personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00056",
                      'sans qu’elle ait pu s’entretenir avec un avocat et être assistée par lui.',
                    ),
              ),
              const SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00057",
                  'Droit de se taire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00058",
                      'En matière de crime ou de délit, le droit de se taire sur les faits reprochés ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00059",
                      'est notifié à toute personne suspectée ou poursuivie avant tout recueil de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00060",
                      'ses observations et avant tout interrogatoire, y compris lorsque l’audition ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00061",
                      'vise à obtenir des renseignements sur sa personnalité ou à prononcer une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00062",
                      'mesure de sûreté. Aucune condamnation ne peut être prononcée sur le seul ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00063",
                      'fondement de déclarations recueillies sans que ce droit ait été notifié.',
                    ),
              ),
              const SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00064",
                    'Le respect du secret professionnel de la défense et du conseil, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00065",
                    'prévu à l’article 66-5 de la loi n° 71-1130 du 31 décembre 1971 ',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00066",
                        'portant réforme de certaines professions judiciaires et juridiques, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00067",
                        'est garanti au cours de la procédure pénale dans les conditions ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00068",
                        'prévues par le Code de procédure pénale.',
                      ),
                ),
              ]),
              const SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00069",
                  'À retenir pour l’enquêteur',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00070",
                          'ces principes guident toutes les mesures d’enquête. Un acte utile ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00071",
                          'juridiquement mais réalisé en violation de ces garanties fondamentales ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00072",
                          'risque d’être annulé et de fragiliser tout le dossier.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 1.1 NOTIONS GENERALES =======================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
              "f00073",
              '1.1 — Notions générales',
            ),
          ),
          const SizedBox(height: 4),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00074",
                  'Le plus souvent, une infraction à la loi pénale — crime, délit ou ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00075",
                  'contravention — cause un dommage à autrui. Par exemple, une personne ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00076",
                  'blessée après des violences volontaires. Dans ce cas, un même fait pénal ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00077",
                  'fait naître deux actions en justice distinctes.',
                ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
              "f00078",
              'Naissance des deux actions',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00079",
                      'Une action tendant à faire appliquer à l’auteur une peine prévue par la loi : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00080",
                      'c’est l’action publique.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00081",
                    'Article 1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00082",
                    ' : l’action publique a pour objet l’application des peines.',
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00083",
                      'Une action visant à la réparation du dommage corporel, matériel ou moral ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00084",
                      'subi par la victime : c’est l’action civile.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00085",
                    'Article 2 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00086",
                    ' : l’action civile tend à la réparation du dommage causé par l’infraction.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00087",
                  'Cas particuliers',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00088",
                      'Certaines infractions ne causent pas de dommage direct à une personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00089",
                      'déterminée (par exemple : port d’une arme à feu soumise à autorisation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00090",
                      'sans droit). Elles ne donnent alors naissance qu’à une seule action : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00091",
                      'l’action publique.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00092",
                      'À l’inverse, il peut exister une action civile indépendante de toute ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00093",
                      'infraction pénale. La victime agit alors sur le fondement de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00094",
                      'responsabilité civile.',
                    ),
              ),
              const SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00095",
                    'Article 1240 du Code civil',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' et '),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00096",
                    'article 4-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00097",
                        ' permettent à une victime d’obtenir réparation de son préjudice même ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00098",
                        'en dehors de toute poursuite pénale. Cette action relève alors du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00099",
                        'juge civil uniquement.',
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 1.2 COMPARAISON DES DEUX ACTIONS ============
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
              "f00100",
              '1.2 — Comparaison des deux actions',
            ),
          ),
          const SizedBox(height: 4),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00101",
                  'L’action publique et l’action civile présentent des différences nettes, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00102",
                  'mais aussi des points de rapprochement puisqu’elles prennent naissance ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00103",
                  'à partir d’une même infraction.',
                ),
          ),
          const SizedBox(height: 14),

          // ----------------- 1.2.1 LES DIFFERENCES -------------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
              "f00104",
              '1.2.1 — Les différences entre action publique et action civile',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _SubTitle('Fondement'),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00105",
                      'L’action publique trouve son fondement dans l’infraction elle-même ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00106",
                      '(atteinte à l’ordre public).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00107",
                      'L’action civile a pour fondement le dommage causé à la victime. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00108",
                      'Sans préjudice, il n’y a pas d’action civile.',
                    ),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00109",
                  'But poursuivi',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00110",
                      'L’action publique vise à réparer le trouble social par l’application ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00111",
                      'd’une peine.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00112",
                      'L’action civile a pour objet la réparation du préjudice individuel ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00113",
                      '(dommages-intérêts).',
                    ),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00114",
                  'Personnes pouvant agir',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00115",
                      'L’action publique est exercée par les magistrats du ministère public ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00116",
                      'contre les auteurs et complices de l’infraction, sauf cas particuliers ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00117",
                      'où la victime peut la mettre en mouvement (plainte avec constitution ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00118",
                      'de partie civile, citations directes, etc.).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00119",
                      'L’action civile appartient à la victime ou à ses ayants cause, qui ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00120",
                      'l’exercent contre l’auteur de l’infraction, ses héritiers ou les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00121",
                      'personnes civilement responsables.',
                    ),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00122",
                  'Caractère de chaque action',
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00123",
                      'L’action publique est d’ordre public : le ministère public ne peut ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00124",
                      'ni y renoncer ni transiger, sauf exceptions prévues par la loi ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00125",
                      '(par exemple certaines alternatives aux poursuites).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00126",
                      'L’action civile est d’ordre privé : la partie lésée peut renoncer à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00127",
                      'son action ou transiger.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ----------------- 1.2.2 RAPPROCHEMENTS -------------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
              "f00128",
              '1.2.2 — Points de rapprochement',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00129",
                      'Les deux actions naissent d’un même fait : l’infraction. C’est ce ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00130",
                      'fait unique qui déclenche à la fois la réaction de la société et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00131",
                      'la demande de réparation de la victime.',
                    ),
              ),
              const SizedBox(height: 6),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                    "f00132",
                    'Article 3 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00133",
                        ' : l’action civile peut être exercée en même temps que l’action ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00134",
                        'publique devant la juridiction répressive. La victime conserve ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                        "f00135",
                        'néanmoins la faculté de saisir directement le juge civil.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00136",
                      'Lorsque la victime dépose une plainte avec constitution de partie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00137",
                      'civile alors que l’action publique n’a pas encore été mise en œuvre, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00138",
                      'son initiative déclenche l’action publique.',
                    ),
              ),
              const SizedBox(height: 6),

              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00139",
                      'Si l’action civile est portée devant le juge civil, celui-ci doit tenir ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00140",
                      'compte de la décision pénale définitive : la chose jugée au pénal a ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00141",
                      'autorité sur le civil. On dit que « le criminel tient le civil en état ».',
                    ),
              ),
              const SizedBox(height: 6),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00142",
                      'Tout au long du procès pénal, l’action publique et, par ricochet, l’action ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00143",
                      'civile s’exercent à travers les actes de poursuite, d’instruction et de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00144",
                      'jugement. Ce n’est pas un moment unique du procès, mais un fil conducteur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                      "f00145",
                      'qui suit toute la procédure.',
                    ),
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                  "f00146",
                  'En pratique',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00147",
                          'l’enquêteur doit toujours garder à l’esprit la double dimension de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00148",
                          'son dossier : la réponse pénale (action publique) et la réparation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00149",
                          'du préjudice de la victime (action civile). Une procédure claire, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00150",
                          'précise et respectueuse des droits des parties sécurise ces deux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_1_titre_preliminaire_page.dart",
                          "f00151",
                          'volets.',
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
