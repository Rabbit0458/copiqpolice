import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaInstructionContenuPage extends StatelessWidget {
  const PaInstructionContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_instruction_preparatoire_contenu';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark ? Colors.white70 : const Color(0xFF222222).withValues(alpha: .70);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          "Instruction préparatoire – Mesures",
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
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            "L'instruction préparatoire – les mesures de contrainte",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Organisation de l’instruction, contrôle judiciaire, détention provisoire, "
            "assignation à résidence avec surveillance électronique, mandats de justice "
            "et dispositions particulières applicables aux mineurs.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ================= MODULE 1 — L'INSTRUCTION PRÉPARATOIRE =================
          _ModuleCard(
            tag: 'pp_instruction_preparatoire',
            title: "L'instruction préparatoire",
            subtitle:
                "Rôle du juge d’instruction, ouverture de l’information, actes d’enquête et garanties procédurales.",
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_instruction_preparatoire',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 2 — LA DÉTENTION PROVISOIRE ====================
          _ModuleCard(
            tag: 'pp_detention_provisoire',
            title: 'La détention provisoire',
            subtitle:
                "Conditions légales, motifs, durée, contrôle du JLD et garanties des droits de la personne mise en examen.",
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_detention_provisoire_contenu',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 3 — LE CONTRÔLE JUDICIAIRE =====================
          _ModuleCard(
            tag: 'pp_controle_judiciaire',
            title: 'Le contrôle judiciaire',
            subtitle:
                "Mesure alternative à la détention : conditions, obligations imposées et conséquences en cas de non-respect.",
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_controle_judiciaire_contenu',
            ),
          ),
          const SizedBox(height: 14),

          // ============ MODULE 4 — ASSIGNATION À RÉSIDENCE + SURVEILLANCE =========
          _ModuleCard(
            tag: 'pp_assignation_residence_surveillance',
            title: "L'assignation à résidence avec surveillance électronique",
            subtitle:
                "Régime de l’assignation à résidence, surveillance électronique, articulation avec la détention provisoire.",
            imagePath: 'assets/images/bracelet.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_assignation_residence_surveillance_contenu',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 5 — MANDATS DE JUSTICE ========================
          _ModuleCard(
            tag: 'pp_mandats_justice',
            title: 'Les mandats de justice (art. 122 à 136 C.P.P.)',
            subtitle:
                "Mandat de comparution, d’amener, de dépôt et d’arrêt : définition, effets et exécution.",
            imagePath: 'assets/images/aggravations.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_mandats_justice',
            ),
          ),
          const SizedBox(height: 14),

          // ========== MODULE 6 — DISPOSITIONS APPLICABLES AUX MINEURS ============
          _ModuleCard(
            tag: 'pp_dispositions_mineurs_instruction',
            title: 'Dispositions applicables aux mineurs',
            subtitle:
                "Règles spécifiques de l’instruction préparatoire lorsque la personne mise en cause est mineure.",
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_dispositions_mineurs_instruction_contenu',
            ),
          ),

          const SizedBox(height: 22),

          // ================= MODULE 7 — QUIZ =================
          _ModuleCard(
            tag: 'quiz_instruction_preparatoire',
            title: 'Quiz — Instruction préparatoire',
            subtitle:
                'Testez votre maîtrise des mesures de contrainte et du déroulement de l’instruction préparatoire.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/procedure_penale/quiz/instruction_preparatoire',
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  void _openRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}

// ---------------------------------------------------------------------------
//  CARD MODULE — identique à ton template
// ---------------------------------------------------------------------------
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.onTap,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color subtitleColor = isDark
        ? textSoft
        : Colors.white.withValues(alpha: 0.92);
    final Color badgeBg = Colors.white.withValues(alpha: 0.14);
    final Color borderClr = Colors.white.withValues(alpha: 0.18);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.transparent,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'hero_$tag',
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .25),
                    Colors.black.withValues(alpha: .60),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: borderClr),
                    ),
                    child: Text(
                      'Module',
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Titre
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Sous-titre
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fustat(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.5,
                      height: 1.3,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
