import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPNulliteActesProcedureContenuPage extends StatelessWidget {
  const PaPPNulliteActesProcedureContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_nullite_actes_procedure_contenu';

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
          'Nullité des actes de procédure',
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
            'La nullité des actes de procédure',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Les nullités textuelles, les nullités substantielles, l’action en nullité '
            'et les effets de la nullité dans la procédure pénale.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ================= MODULE 1 — NULLITÉS TEXTUELLES =================
          _ModuleCard(
            tag: 'pp_nullites_textuelles',
            title: 'Les nullités textuelles',
            subtitle:
                'Nullités prévues expressément par un texte pour sanctionner la violation d’une formalité imposée par la loi.',
            imagePath: 'assets/images/procedure_penale.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_nullites_textuelles',
            ),
          ),
          const SizedBox(height: 14),

          // ============= MODULE 2 — NULLITÉS SUBSTANTIELLES =================
          _ModuleCard(
            tag: 'pp_nullites_substantielles',
            title: 'Les nullités substantielles',
            subtitle:
                'Atteinte à une garantie essentielle, aux droits de la défense ou aux libertés individuelles, même sans texte exprès.',
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_nullites_substantielles',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 3 — ACTION EN NULLITÉ ====================
          _ModuleCard(
            tag: 'pp_action_en_nullite',
            title: 'L’action en nullité',
            subtitle:
                'Conditions, titulaires, délais et juridictions compétentes pour demander l’annulation d’un acte de procédure.',
            imagePath: 'assets/images/libertes_intro.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_action_en_nullite',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 4 — EFFETS DE LA NULLITÉ =================
          _ModuleCard(
            tag: 'pp_effets_nullite',
            title: 'Les effets de la nullité',
            subtitle:
                'Effets de l’annulation sur l’acte irrégulier, les actes subséquents et la validité des preuves recueillies.',
            imagePath: 'assets/images/reserve.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_effets_nullite',
            ),
          ),

          const SizedBox(height: 22),

          // ================= MODULE 5 — Quizz =================
          _ModuleCard(
            tag: 'quiz_nullite',
            title: 'Quiz — Nullité',
            subtitle: 'Vérifiez votre maîtrise des conditions, de la nullité.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () =>
                _openRoute(context, '/gpx/procedure_penale/quiz/nullite'),
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
