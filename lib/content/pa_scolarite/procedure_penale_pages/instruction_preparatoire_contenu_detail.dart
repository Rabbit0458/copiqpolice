import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPInstructionPreparatoireContenuPage extends StatelessWidget {
  const PaPPInstructionPreparatoireContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_instruction_preparatoire';

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
          "Instruction préparatoire",
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
            "L'instruction préparatoire",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            "Définition, ouverture d’une information, pouvoirs du juge "
            "d’instruction, clôture, rôle de la chambre de l’instruction "
            "et attributions du juge des libertés et de la détention.",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ================= MODULE 1 — DÉFINITION =================
          _ModuleCard(
            tag: 'pp_instruction_def',
            title: "Définition et principes généraux",
            subtitle:
                "Organisation, finalité, objectifs, caractère inquisitoire, écrit, secret et non contradictoire.",
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_instruction_def',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 2 — OUVERTURE ====================
          _ModuleCard(
            tag: 'pp_instruction_ouverture',
            title: "Chapitre 2 : L'ouverture d'une information",
            subtitle:
                "Cas d’ouverture, critères légaux, plainte avec constitution, saisine, rôle du procureur.",
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_instruction_ouverture',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 3 — POUVOIRS DU JUGE =====================
          _ModuleCard(
            tag: 'pp_instruction_pouvoirs',
            title: "Chapitre 3 : Les pouvoirs du juge d'instruction",
            subtitle:
                "Caractères généraux, perquisitions, auditions, expertises, commissions rogatoires.",
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_instruction_pouvoirs',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 4 — CLÔTURE =====================
          _ModuleCard(
            tag: 'pp_instruction_cloture',
            title: "Chapitre 4 : La clôture de l’instruction",
            subtitle:
                "Moment de la clôture, avis aux parties, ordonnances de règlement et décisions du juge.",
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_instruction_cloture',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 5 — CHAMBRE DE L'INSTRUCTION ========================
          _ModuleCard(
            tag: 'pp_chambre_instruction',
            title: "Chapitre 5 : La chambre de l'instruction",
            subtitle:
                "Composition, rôle, contrôle de l’instruction, décisions rendues, voies de recours.",
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_chambre_instruction',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 6 — JLD ============================
          _ModuleCard(
            tag: 'pp_jld',
            title: "Chapitre 6 : Le juge des libertés et de la détention",
            subtitle:
                "Statut, rôle, pouvoirs, mesures de sûreté, détention provisoire et libertés individuelles.",
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_jld',
            ),
          ),

          const SizedBox(height: 22),

          // ================= MODULE 7 — QUIZ =================
          _ModuleCard(
            tag: 'quiz_instruction_preparatoire',
            title: 'Quiz — Instruction préparatoire',
            subtitle:
                'Testez vos connaissances sur la procédure d’instruction, ses phases et ses acteurs.',
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
