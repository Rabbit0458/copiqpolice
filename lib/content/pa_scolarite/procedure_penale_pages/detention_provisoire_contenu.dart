import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPDetentionProvisoireContenuPage extends StatelessWidget {
  const PaPPDetentionProvisoireContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_detention_provisoire_contenu';

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
          'Détention provisoire',
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
            'La détention provisoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Placement, déroulement, fin de la détention provisoire et réparation de la détention injustifiée.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ============= MODULE 1 — PLACEMENT EN DÉTENTION PROVISOIRE ======
          _ModuleCard(
            tag: 'pp_placement_detention_provisoire',
            title: 'Le placement en détention provisoire',
            subtitle:
                'Conditions de fond et de forme, critères légaux et rôle du J.L.D. et du juge d’instruction.',
            imagePath: 'assets/images/mandat_arret.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_placement_detention_provisoire',
            ),
          ),
          const SizedBox(height: 14),

          // ========= MODULE 2 — DÉROULEMENT DE LA DÉTENTION PROVISOIRE =====
          _ModuleCard(
            tag: 'pp_deroulement_detention_provisoire',
            title: 'Déroulement de la détention provisoire',
            subtitle:
                'Durée, prolongations, contrôle juridictionnel et interventions de la chambre de l’instruction.',
            imagePath: 'assets/images/retention.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_deroulement_detention_provisoire',
            ),
          ),
          const SizedBox(height: 14),

          // ============== MODULE 3 — FIN DE LA DÉTENTION PROVISOIRE =========
          _ModuleCard(
            tag: 'pp_fin_detention_provisoire',
            title: 'Fin de la détention provisoire',
            subtitle:
                'Mises en liberté, fins anticipées, effets sur les mesures de contrôle et la suite de la procédure.',
            imagePath: 'assets/images/recherche_fuite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_fin_detention_provisoire',
            ),
          ),
          const SizedBox(height: 14),

          // ===== MODULE 4 — RÉPARATION D’UNE DÉTENTION INJUSTIFIÉE =========
          _ModuleCard(
            tag: 'pp_reparation_detention_injustifiee',
            title: 'Réparation d’une détention provisoire injustifiée',
            subtitleSpans: const [
              TextSpan(
                text:
                    'Conditions d’indemnisation, procédure devant la commission et voies de recours (',
              ),
              TextSpan(
                text: 'art. 149 et s. C. proc. pén.',
                style: TextStyle(
                  color: Colors.red, // articles de loi en rouge
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: ').'),
            ],
            imagePath: 'assets/images/controle_identite.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_reparation_detention_injustifiee',
            ),
          ),
          const SizedBox(height: 14),

          // ================= MODULE 5 — TABLEAU RÉCAPITULATIF ===============
          _ModuleCard(
            tag: 'pp_detention_provisoire_tableau',
            title: 'Tableau récapitulatif',
            subtitle:
                'Synthèse visuelle des délais, autorités compétentes et voies de recours en matière de détention provisoire.',
            imagePath: 'assets/images/cat_organisation.jpg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/procedure_penale/pp_detention_provisoire_tableau',
            ),
          ),

          const SizedBox(height: 22),

          // ================= MODULE 7 — QUIZ =================
          _ModuleCard(
            tag: 'quiz_instruction_preparatoire',
            title: 'Quiz — Détention provisoire',
            subtitle:
                'Testez votre maîtrise des mesures de contrainte et du déroulement de la détention provisoire.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/gpx/procedure_penale/quiz/detention_provisoire',
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
//  CARD MODULE — même rendu que tes autres pages, avec support du texte riche
// ---------------------------------------------------------------------------
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.tag,
    required this.title,
    required this.imagePath,
    required this.textMain,
    required this.textSoft,
    required this.onTap,
    this.subtitle,
    this.subtitleSpans,
  }) : assert(subtitle != null || subtitleSpans != null);

  final String tag;
  final String title;
  final String imagePath;
  final Color textMain;
  final Color textSoft;
  final VoidCallback onTap;

  /// Sous-titre simple
  final String? subtitle;

  /// Sous-titre avec parties stylées (pour les articles de loi en rouge)
  final List<InlineSpan>? subtitleSpans;

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

                  // Sous-titre (simple ou riche)
                  if (subtitleSpans != null)
                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: GoogleFonts.fustat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.5,
                          height: 1.3,
                          color: subtitleColor,
                        ),
                        children: subtitleSpans!,
                      ),
                    )
                  else if (subtitle != null)
                    Text(
                      subtitle!,
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
