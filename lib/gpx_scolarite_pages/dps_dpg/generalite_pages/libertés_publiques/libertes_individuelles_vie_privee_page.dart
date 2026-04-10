import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// =============================================================
///  COP'IQ — Les libertés individuelles et la vie privée (hub)
///  - Liberté d’aller et venir
///  - Sûreté / liberté individuelle
///  - Droit au respect de la vie privée
///  - Respect de la personne / législation
///  - Rôle de la CNIL
///  (les pages cibles seront configurées plus tard)
/// =============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Pages de destination
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/individuelles/liberte_aller_venir_detail_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/individuelles/surete_liberte_individuelle_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/individuelles/droit_vie_privee_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/individuelles/respect_personne_legislation_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/libert%C3%A9s_publiques/individuelles/cnil_protection_donnees_page.dart';
import 'package:copiqpolice/gpx_scolarite_pages/dps_dpg/generalite_pages/quizz_generalit%C3%A9/quiz_libertes_publiques_individuelles_page.dart';

/// Petite fonction d’ouverture avec fondu
void _open(BuildContext context, Widget page, String tag) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, animation, __) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: page,
      ),
    ),
  );
}

class LibertesIndividuellesViePriveePage extends StatelessWidget {
  const LibertesIndividuellesViePriveePage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/libertes_individuelles_vie_privee';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withOpacity(.70);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'Libertés individuelles & vie privée',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _ModuleCard(
            tag: 'liberte_aller_venir_detail',
            title: 'La liberté d’aller et venir',
            subtitle: 'Définition, valeur constitutionnelle et restrictions.',
            imagePath: 'assets/images/liberte_aller_venir_detail.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () {
              _open(
                context,
                const LiberteAllerVenirDetailPage(),
                'liberte_aller_venir_detail',
              );
            },
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'surete_liberte_individuelle',
            title: 'La sûreté ou liberté individuelle',
            subtitle: 'Arrestations, détentions, garanties procédurales.',
            imagePath: 'assets/images/surete_liberte_individuelle.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () {
              _open(
                context,
                const SureteLiberteIndividuellePage(),
                'surete_liberte_individuelle',
              );
            },
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'droit_vie_privee',
            title: 'Le droit au respect de la vie privée',
            subtitle: 'Domicile, correspondances, image, données personnelles.',
            imagePath: 'assets/images/droit_vie_privee.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () {
              _open(context, const DroitViePriveePage(), 'droit_vie_privee');
            },
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'respect_personne_legislation',
            title: 'Le respect de la personne\n(législation applicable)',
            subtitle: 'Intégrité physique, dignité, traitement des personnes.',
            imagePath: 'assets/images/respect_personne_legislation.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () {
              _open(
                context,
                const RespectPersonneLegislationPage(),
                'respect_personne_legislation',
              );
            },
          ),
          const SizedBox(height: 14),
          _ModuleCard(
            tag: 'cnil',
            title: 'La CNIL et la protection des données',
            subtitle: 'Rôle, pouvoirs de contrôle et sanctions.',
            imagePath: 'assets/images/cnil.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () {
              _open(context, const CnilProtectionDonneesPage(), 'cnil');
            },
          ),
          // ===== QUIZ LIBERTÉS PUBLIQUES =====
          const SizedBox(height: 22),
          _ModuleCard(
            tag: 'quiz_libertes',
            title: 'Quiz — Individuelles',
            subtitle:
                'Testez votre maîtrise de la liberté individuelle / sûreté et de la liberté d’aller et venir.',
            imagePath: 'assets/images/quiz.jpeg',
            textMain: textMain,
            textSoft: textSoft,
            onTap: () => Navigator.of(
              context,
            ).pushNamed(QuizLibertesPubliquesIndividuellesPage.routeName),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

/// ICI tu gardes ton `_ModuleCard` déjà présent dans le fichier
/// (je ne le recolle pas pour éviter les doublons).

/// ==================== Carte visuelle d’un module ====================
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
    final Color badgeBg = Colors.white.withOpacity(0.14);
    final Color borderClr = Colors.white.withOpacity(0.18);

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        button: true,
        label: '$title — découvrir',
        child: Container(
          height: 190,
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
                      Colors.black.withOpacity(.25),
                      Colors.black.withOpacity(.55),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white.withOpacity(.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(right: 16, bottom: 16, child: _RoundCTA()),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundCTA extends StatelessWidget {
  const _RoundCTA();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.12),
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 6),
            Text(
              'Découvrir',
              style: GoogleFonts.fustat(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
