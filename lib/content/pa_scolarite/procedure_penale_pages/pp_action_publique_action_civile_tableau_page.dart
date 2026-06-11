import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          "Actions publique et civile",
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
                      child: Text("ACTION PUBLIQUE", style: headerStyle),
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
                      child: Text("ACTION CIVILE", style: headerStyle),
                    ),
                  ),
                ],
              ),

              // --------------------- TABLE BODY ---------------------
              _row(
                leftTitle: "ORIGINE",
                left: "Une infraction pénale ayant causé ou non un préjudice",
                rightTitle: "ORIGINE",
                right: "Une infraction pénale ayant causé un préjudice",
              ),

              _row(
                leftTitle: "OBJET",
                left: "Faire appliquer une peine",
                rightTitle: "OBJET",
                right: "Obtenir la réparation du préjudice causé",
              ),

              _row(
                leftTitle: "MISE EN MOUVEMENT",
                leftWidget: _rich([
                  "Par :\n",
                  " - les magistrats du ministère public (Parquet – Maires, Commissaires ou Officiers)\n",
                  " - Exceptionnellement par les fonctionnaires de certaines administrations\n\n",
                  "Indirectement : la personne lésée ou ses ayants droit",
                ]),
                rightTitle: "MISE EN MOUVEMENT",
                right:
                    "Par la personne lésée, ses ayants droit ou certaines personnes morales agissant pour la défense d’intérêts collectifs\n\n→ Constitution de partie civile",
              ),

              _row(
                leftTitle: "COMPÉTENCE",
                left: "Juridictions répressives",
                rightTitle: "COMPÉTENCE",
                right: "Juridictions civiles et juridictions répressives",
              ),

              _row(
                leftTitle: "EXERCICE",
                leftWidget: _rich([
                  "MINISTÈRE PUBLIC\n",
                  "Exceptionnellement : certaines administrations",
                ]),
                rightTitle: "EXERCICE",
                rightWidget: _rich([
                  "PERSONNE LÉSÉE\n",
                  "ou\n",
                  "ses héritiers – ses créanciers",
                ]),
              ),

              _row(
                leftTitle: "SUJET ACTIF",
                left: "Auteur de l’infraction",
                rightTitle: "SUJET ACTIF",
                right: "Auteur de l’infraction",
              ),

              _row(
                leftTitle: "SUJET PASSIF",
                left: "La personne lésée",
                rightTitle: "SUJET PASSIF",
                rightWidget: _rich([
                  "Auteur de l’infraction ou :\n",
                  " - Ses héritiers\n",
                  " - Personnes civilement responsables\n",
                  " - Personne morale pour son préposé",
                ]),
              ),

              _row(
                leftTitle: "CLÔTURE",
                left: "Condamnation à une peine",
                rightTitle: "CLÔTURE",
                right: "Condamnation à réparation",
              ),

              _row(
                leftTitle: "EXTINCTION",
                leftWidget: _rich([
                  " - Le décès de l’auteur de l’infraction\n",
                  " - L’abrogation de la loi pénale\n",
                  " - L’amnistie\n",
                  " - L’exécution de la composition pénale\n",
                  " - L’autorité de la chose jugée\n",
                  " - La prescription\n",
                  "Exceptionnellement :\n",
                  " - Le retrait de la plainte\n",
                  " - La transaction",
                ]),
                rightTitle: "EXTINCTION",
                rightWidget: _rich([
                  " - Le désistement\n",
                  " - La transaction (accord de la victime – auteur)\n",
                  " - L’acquiescement\n",
                  " - L’autorité de la chose jugée\n",
                  " - La prescription",
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
