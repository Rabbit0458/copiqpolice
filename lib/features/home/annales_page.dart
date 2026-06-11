// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Page ANNALES (placeholder)                                      ║
// ║                                                                           ║
// ║  ⚠️  CETTE PAGE DOIT ÊTRE CODÉE PLUS TARD.                                ║
// ║                                                                           ║
// ║  Roadmap complète A→Z dans :                                              ║
// ║    docs/cas_pratique/ANNALES_DEV_PROGRESSION.md                           ║
// ║                                                                           ║
// ║  Objectif final : centraliser les PDF des annales (cas pratiques,         ║
// ║  sujets concours, corrigés officiels) avec téléchargement, recherche,    ║
// ║  visionneuse intégrée.                                                    ║
// ║                                                                           ║
// ║  Route : AnnalesPage.routeName = '/home-gpx-exam/annales'                 ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnalesPage extends StatelessWidget {
  const AnnalesPage({super.key});

  static const String routeName = '/home-gpx-exam/annales';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1147D9).withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF1147D9),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Annales',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: ink,
                    letterSpacing: -.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cette page doit être codée plus tard',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ink.withValues(alpha: .6),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
