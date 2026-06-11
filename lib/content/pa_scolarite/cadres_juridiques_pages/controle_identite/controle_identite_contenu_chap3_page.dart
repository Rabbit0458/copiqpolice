import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaControleIdentiteChap3ContenuPage extends StatelessWidget {
  const PaControleIdentiteChap3ContenuPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
? Colors.white70
: const Color(0xFF222222).withValues(alpha: .70);

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
          'Chapitre 3 — Vérification d’identité',
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
          // ===================== TITRE & INTRO RAPIDE ======================
          Text(
            'Chapitre 3 — Vérification d’identité',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rétention de la personne contrôlée, recherche de l’identité, obligations légales de '
            'procédure et rédaction du procès-verbal de vérification : cadre juridique et bonnes '
            'pratiques pour l’officier de police judiciaire.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== INTRODUCTION ==============================
          _ModuleCard(
            tag: 'chap3_intro',
            title: 'Introduction',
            subtitle:
                'Rôle de la vérification d’identité, articulation avec le contrôle d’identité et le relevé '
                'd’identité, et enjeux en matière de libertés individuelles.',
            imagePath: 'assets/images/verficiation_identite_chap3.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/introduction',
            ),
          ),
          const SizedBox(height: 14),

          // ========== LA RÉTENTION DE LA PERSONNE CONTRÔLÉE ===============
          _ModuleCard(
            tag: 'chap3_retention',
            title: 'La rétention de la personne contrôlée',
            subtitle:
                'Conditions de placement en rétention, durée maximale, droits de la personne et '
                'contrôle exercé par l’autorité judiciaire.',
            imagePath: 'assets/images/verficiation_identite_chap3.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/retention',
            ),
          ),
          const SizedBox(height: 14),

          // ================== LA RECHERCHE DE L’IDENTITÉ ===================
          _ModuleCard(
            tag: 'chap3_recherche_identite',
            title: 'La recherche de l’identité',
            subtitle:
                'Moyens mis en œuvre pour établir l’identité, vérifications possibles, recours aux '
                'fichiers et coopération avec les autres services.',
            imagePath: 'assets/images/verficiation_identite_chap3.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/recherche_identite',
            ),
          ),
          const SizedBox(height: 14),

          // ============ LES OBLIGATIONS LÉGALES DE PROCÉDURE ==============
          _ModuleCard(
            tag: 'chap3_obligations_legales',
            title: 'Les obligations légales de procédure',
            subtitle:
                'Information des droits, formalités obligatoires, respect des délais et risques de '
                'nullité en cas d’irrégularité.',
            imagePath: 'assets/images/verficiation_identite_chap3.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/obligations_legales_procedure',
            ),
          ),
          const SizedBox(height: 14),

          // ============ LE PROCÈS-VERBAL DE VÉRIFICATION ==================
          _ModuleCard(
            tag: 'chap3_pv_verification',
            title: 'Le procès-verbal de vérification',
            subtitle:
                'Mentions indispensables, chronologie des opérations, articulation avec les autres '
                'pièces de procédure et bonnes pratiques de rédaction.',
            imagePath: 'assets/images/verficiation_identite_chap3.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => _openRoute(
              context,
              '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/pv_verification_identite',
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
//  CARTE MODULE (même style que ta page de contenu principale)
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
      child: Semantics(
        button: true,
        label: '$title — découvrir',
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
                    // Badge "Module"
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

                    // Titre (2 lignes max)
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
                      maxLines: 3,
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
      ),
    );
  }
}
