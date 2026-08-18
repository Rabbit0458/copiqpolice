import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPPActionPubliqueActionCivileTableauPage extends StatelessWidget {
  const PaPPActionPubliqueActionCivileTableauPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/tableau_actions_publique_civile';

  Color get headerColor => const Color(0xFF0D47A1);
  Color get lineColor => const Color(0x33000000);

  TextStyle get headerStyle => GoogleFonts.fustat(
    fontSize: 17,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  TextStyle get cellTitle => GoogleFonts.fustat(
    fontSize: 15.5,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF0D47A1),
  );

  TextStyle get cellText => GoogleFonts.fustat(
    fontSize: 14,
    height: 1.32,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1F1F1F),
  );

  TextStyle get articleStyle => GoogleFonts.fustat(
    fontSize: 14,
    height: 1.32,
    fontWeight: FontWeight.w800,
    color: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color tableBackground = isDark
        ? const Color(0xFF1A1A1A)
        : Colors.white;
    final Color headerBg = isDark
        ? const Color(0xFF1565C0)
        : const Color(0xFF0D47A1);
    final Color border = isDark ? Colors.white24 : Colors.black12;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
            "f00001",
            "Actions publique et civile",
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          decoration: BoxDecoration(
            color: tableBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .10),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // --------------------- HEADER ---------------------
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: headerBg,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                          "f00002",
                          "ACTION PUBLIQUE",
                        ),
                        style: headerStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: headerBg,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(18),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                          "f00003",
                          "ACTION CIVILE",
                        ),
                        style: headerStyle,
                      ),
                    ),
                  ),
                ],
              ),

              // --------------------- TABLE BODY ---------------------
              _row(
                leftTitle: "ORIGINE",
                left: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00004",
                  "Une infraction pénale ayant causé ou non un préjudice",
                ),
                rightTitle: "ORIGINE",
                right: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00005",
                  "Une infraction pénale ayant causé un préjudice",
                ),
              ),

              _row(
                leftTitle: "OBJET",
                left: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00006",
                  "Faire appliquer une peine",
                ),
                rightTitle: "OBJET",
                right: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00007",
                  "Obtenir la réparation du préjudice causé",
                ),
              ),

              _row(
                leftTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00008",
                  "MISE EN MOUVEMENT",
                ),
                leftWidget: _rich([
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00009",
                    "Par :\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00010",
                    " - les magistrats du ministère public (Parquet – Maires, Commissaires ou Officiers)\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00011",
                    " - Exceptionnellement par les fonctionnaires de certaines administrations\n\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00012",
                    "Indirectement : la personne lésée ou ses ayants droit",
                  ),
                ]),
                rightTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00013",
                  "MISE EN MOUVEMENT",
                ),
                right: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00014",
                  "Par la personne lésée, ses ayants droit ou certaines personnes morales agissant pour la défense d’intérêts collectifs\n\n→ Constitution de partie civile",
                ),
              ),

              _row(
                leftTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00015",
                  "COMPÉTENCE",
                ),
                left: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00016",
                  "Juridictions répressives",
                ),
                rightTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00017",
                  "COMPÉTENCE",
                ),
                right: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00018",
                  "Juridictions civiles et juridictions répressives",
                ),
              ),

              _row(
                leftTitle: "EXERCICE",
                leftWidget: _rich([
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00019",
                    "MINISTÈRE PUBLIC\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00020",
                    "Exceptionnellement : certaines administrations",
                  ),
                ]),
                rightTitle: "EXERCICE",
                rightWidget: _rich([
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00021",
                    "PERSONNE LÉSÉE\n",
                  ),
                  "ou\n",
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00022",
                    "ses héritiers – ses créanciers",
                  ),
                ]),
              ),

              _row(
                leftTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00023",
                  "SUJET ACTIF",
                ),
                left: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00024",
                  "Auteur de l’infraction",
                ),
                rightTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00025",
                  "SUJET ACTIF",
                ),
                right: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00026",
                  "Auteur de l’infraction",
                ),
              ),

              _row(
                leftTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00027",
                  "SUJET PASSIF",
                ),
                left: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00028",
                  "La personne lésée",
                ),
                rightTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00029",
                  "SUJET PASSIF",
                ),
                rightWidget: _rich([
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00030",
                    "Auteur de l’infraction ou :\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00031",
                    " - Ses héritiers\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00032",
                    " - Personnes civilement responsables\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00033",
                    " - Personne morale pour son préposé",
                  ),
                ]),
              ),

              _row(
                leftTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00034",
                  "CLÔTURE",
                ),
                left: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00035",
                  "Condamnation à une peine",
                ),
                rightTitle: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00036",
                  "CLÔTURE",
                ),
                right: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                  "f00037",
                  "Condamnation à réparation",
                ),
              ),

              _row(
                leftTitle: "EXTINCTION",
                leftWidget: _rich([
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00038",
                    " - Le décès de l’auteur de l’infraction\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00039",
                    " - L’abrogation de la loi pénale\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00040",
                    " - L’amnistie\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00041",
                    " - L’exécution de la composition pénale\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00042",
                    " - L’autorité de la chose jugée\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00043",
                    " - La prescription\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00044",
                    "Exceptionnellement :\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00045",
                    " - Le retrait de la plainte\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00046",
                    " - La transaction",
                  ),
                ]),
                rightTitle: "EXTINCTION",
                rightWidget: _rich([
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00047",
                    " - Le désistement\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00048",
                    " - La transaction (accord de la victime – auteur)\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00049",
                    " - L’acquiescement\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00050",
                    " - L’autorité de la chose jugée\n",
                  ),
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_tableau_page.dart",
                    "f00051",
                    " - La prescription",
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // TABLE ROW
  // ---------------------------------------------------------------------
  Widget _row({
    required String leftTitle,
    String? left,
    Widget? leftWidget,
    required String rightTitle,
    String? right,
    Widget? rightWidget,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12, width: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cell(leftTitle, left, leftWidget),
          const SizedBox(width: 18),
          _cell(rightTitle, right, rightWidget),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // INDIVIDUAL CELL
  // ---------------------------------------------------------------------
  Widget _cell(String title, String? text, Widget? widget) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: cellTitle),
          const SizedBox(height: 6),
          widget ?? Text(text!, style: cellText, textAlign: TextAlign.justify),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // RICH TEXT BUILDER
  // ---------------------------------------------------------------------
  Widget _rich(List<String> lines) {
    return Text(lines.join(""), style: cellText, textAlign: TextAlign.justify);
  }
}
