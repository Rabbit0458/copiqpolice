import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class VerificationIdentiteProcedureGpxSchool extends StatelessWidget {
  const VerificationIdentiteProcedureGpxSchool({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/controle_identite/chapitre3/obligations_legales_procedure';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F7FF);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

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
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
            "f00002",
            'Obligations légales de procédure',
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
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ===================== TITRE PRINCIPAL ===========================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
              "f00003",
              '3.3 — Les obligations légales de procédure',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00004",
                  'Garanties procédurales encadrant la vérification d’identité : rôle central de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00005",
                  'l’officier de police judiciaire, information de la personne retenue et contrôle ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00006",
                  'exercé par le procureur de la République afin d’assurer la protection des libertés ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00007",
                  'individuelles.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CARTE CONTENU =============================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
              "f00008",
              '3.3 — Les obligations légales de procédure',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              // ---------- 3.3.1 Présentation immédiate ---------------------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00009",
                  'La présentation immédiate à l’officier de police judiciaire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00010",
                      'Pour assurer la protection des libertés individuelles face à la vérification ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00011",
                      'd’identité, le législateur a prévu un encadrement précis des formalités ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00012",
                      'procédurales et un contrôle renforcé du procureur de la République.',
                    ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00013",
                      'Toute personne soumise à une vérification d’identité doit être présentée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00014",
                      'immédiatement à un officier de police judiciaire. En pratique, la personne a ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00015",
                      'souvent été contrôlée par un agent de police judiciaire qui rend compte à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00016",
                      'l’officier de police judiciaire.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00017",
                        'S’il s’agit d’un mineur, celui-ci doit être assisté de son représentant légal, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00018",
                        'sauf impossibilité (',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00019",
                    'article 78-3, alinéa 2, du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00020",
                        '). En pratique, cette impossibilité est fréquente, puisque l’identité du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00021",
                        'mineur n’est pas encore connue au moment du contrôle. L’agent apprécie ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00022",
                        'alors son âge à partir de son apparence, dans l’attente de l’établissement ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00023",
                        'de son identité réelle.',
                      ),
                ),
              ]),

              SizedBox(height: 14),

              // ---------- 3.3.2 Information immédiate ----------------------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00024",
                  'L’information immédiate de la personne retenue',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00025",
                        'Dès sa présentation à l’officier de police judiciaire, la personne qui fait ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00026",
                        'l’objet des vérifications doit être informée par celui-ci, ou sous son contrôle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00027",
                        'par un agent de police judiciaire, de son droit de faire aviser le procureur de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00028",
                        'la République de la vérification dont elle fait l’objet (',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00029",
                    'article 78-3, alinéa 1, du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00030",
                        'Par ailleurs, lorsque la mesure de garde à vue fait suite à une vérification ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00031",
                        'd’identité, la personne doit être aussitôt informée de son droit de faire aviser ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00032",
                        'le procureur de la République de la mesure dont elle fait l’objet (',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00033",
                    'article 78-3, alinéa 10, du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00034",
                        '). Cet avis se cumule avec celui déjà prévu dans le cadre de la garde à vue ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00035",
                        'par l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00036",
                    'article 63 du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00037",
                        ', de sorte qu’il n’est pas indispensable de le rappeler à nouveau dans le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00038",
                        'procès-verbal de vérification, dès lors qu’il figure dans le procès-verbal de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00039",
                        'garde à vue.',
                      ),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00040",
                        'S’il s’agit d’un mineur, le procureur de la République doit être obligatoirement ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00041",
                        'informé dès le début de la rétention, conformément à l’',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00042",
                    'article 78-3, alinéa 2, du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00043",
                        'L’officier de police judiciaire ou l’agent de police judiciaire informe ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00044",
                        'également la personne soumise à vérification de son droit de prévenir à tout ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00045",
                        'moment sa famille ou toute personne de son choix (',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00046",
                    'article 78-3, alinéa 1, du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00047",
                        '). Cette disposition permet à l’intéressé de choisir librement une personne ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00048",
                        'susceptible d’apporter des indications utiles sur son identité.',
                      ),
                ),
              ]),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00049",
                      'Toutefois, cette faculté n’implique pas nécessairement un contact direct entre la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00050",
                      'personne retenue et la personne choisie : lorsque des circonstances particulières ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00051",
                      'l’exigent, l’officier ou l’agent de police judiciaire peut procéder lui-même à cet avis. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00052",
                      'La communication légale se limite alors à informer que l’intéressé est retenu pour ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00053",
                      'vérification d’identité, sans qu’il soit permis de tenir une véritable conversation.',
                    ),
              ),

              SizedBox(height: 14),

              // ---------- 3.3.3 Contrôle du procureur ----------------------
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00054",
                  'Le contrôle du procureur de la République',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00055",
                    'L’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00056",
                    'article 78-1, alinéa 1, du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00057",
                        ' prévoit que l’ensemble des opérations relatives à l’établissement de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00058",
                        'l’identité est placé sous le contrôle des autorités judiciaires mentionnées aux ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00059",
                        'articles 12 et 13 du même code, c’est-à-dire le procureur de la République, le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00060",
                        'procureur général et la chambre de l’instruction.',
                      ),
                ),
              ]),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00061",
                      'En pratique, c’est le procureur de la République qui dispose des moyens concrets ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00062",
                      'd’exercer ce contrôle. Celui-ci intervient à deux niveaux :',
                    ),
              ),

              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00063",
                  'Pendant la durée de la rétention :',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00064",
                        'Le procureur de la République veille au bon déroulement de la détention et ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00065",
                        'aux conditions d’utilisation des moyens de l’identité judiciaire. Il peut se rendre ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00066",
                        'dans les locaux de police, ordonner un examen médical, ou mettre fin à tout ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                        "f00067",
                        'moment à la détention (',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                    "f00068",
                    'article 78-3, alinéa 3, du code de procédure pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00069",
                      'Pour sécuriser la procédure et prévenir tout risque de contestation ultérieure, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00070",
                      'l’officier de police judiciaire peut, après avis et accord du procureur de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00071",
                      'République, requérir un médecin chargé de constater l’état physique de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00072",
                      'personne retenue ou d’apprécier sa capacité à supporter la rétention.',
                    ),
              ),

              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                  "f00073",
                  'À l’issue de la vérification :',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00074",
                      'À la réception du procès-verbal de vérification établi obligatoirement par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00075",
                      'l’officier de police judiciaire, le procureur de la République exerce un contrôle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00076",
                      'essentiellement juridique sur la régularité de la mesure, le respect des délais, des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/controle_identite/verification_identite_procedure_gpx_school.dart",
                      "f00077",
                      'droits de la personne et des textes applicables.',
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
