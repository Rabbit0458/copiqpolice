import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaJuridictionContenuPage extends StatelessWidget {
  const PaJuridictionContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/juridictions_contenu';

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
          'Les juridictions pénales',
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
            'Les juridictions pénales',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Les principes généraux des juridictions pénales et l’exécution des décisions de justice.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ============ MODULE 1 — PRINCIPES GÉNÉRAUX ======================
          _ModuleCard(
            tag: 'pp_juridictions_principes_generaux',
            title: 'Les principes généraux',
            subtitle:
                'Organisation des juridictions pénales, compétences, voies de recours et grands principes directeurs de la justice pénale.',
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/juridictions_principes_generaux',
            ),
          ),
          const SizedBox(height: 14),

          // ===== MODULE 2 — EXÉCUTION DES DÉCISIONS DE JUSTICE =============
          _ModuleCard(
            tag: 'pp_execution_decisions_justice',
            title: 'L’exécution des décisions de justice',
            subtitle:
                'Mise à exécution des peines, rôle du parquet et du juge de l’application des peines, incidents et aménagements de peine.',
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/juridictions_execution_decisions_justice',
            ),
          ),
          const SizedBox(height: 22),

          // ===== MODULE 3 — LES JURIDICTIONS PENALES =============
          _ModuleCard(
            tag: 'pp_juridictions_penales',
            title: 'Les juridictions pénales',
            subtitle:
                'Comprendre les juridictions pénales et le fonctionnement',
            imagePath: 'assets/images/action_justice.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_juridictions_penales',
            ),
          ),
          const SizedBox(height: 22),

          // ================= MODULE 4 — QUIZ =================
          _ModuleCard(
            tag: 'quiz_juridictions_penales',
            title: 'Quiz — Juridictions pénales',
            subtitle:
                'Testez vos connaissances sur les principes généraux et l’exécution des décisions de justice.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/procedure_penale/quiz/juridictions_penales',
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  // OUVERTURE D’UNE AUTRE PAGE (pas de PDF ici)
  void _openRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }
}

// ---------------------------------------------------------------------------
//  CARD MODULE — COHÉRENCE VISUELLE AVEC TES AUTRES PAGES
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
