// lib/features/home/home_page_reserve_school.dart
//
// ⚠️ SQUELETTE À CONFIGURER MANUELLEMENT.
//
// Home page du parcours Réserve en mode "scolarité".
//
// Pour le moment, cette page :
//   - Affiche un bandeau "Espace Réserve" minimal.
//   - Liste les programmes Réserve définis dans `ReserveSchoolProgram`.
//   - Permet d'ouvrir des modules (TODO: brancher les vraies routes des
//     pages de cours Réserve).
//
// Pour enrichir :
//   1. Créer/dupliquer des pages de cours dans `lib/content/reserve_scolarite/`
//      OU mutualiser vers GPX (voir QuizRouter pour la réécriture automatique).
//   2. Ajouter les routes correspondantes dans `app_router.dart`.
//   3. Brancher la grille de cartes ci-dessous via `_buildModuleCard`.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/features/onboarding/reserve_school.dart';
import 'package:copiqpolice/core/services/user_context_service.dart';

class HomePageReserveSchool extends StatefulWidget {
  const HomePageReserveSchool({super.key});

  /// Programme actif — injecté par `HomeBootstrap` après le picker.
  static ReserveSchoolProgram program = ReserveSchoolProgram.introduction;

  static const String routeName = '/home-reserve-school';

  @override
  State<HomePageReserveSchool> createState() => _HomePageReserveSchoolState();
}

class _HomePageReserveSchoolState extends State<HomePageReserveSchool> {
  @override
  void initState() {
    super.initState();
    // Cohérence : on s'assure que le UserContextService connaît bien le track.
    UserContextService.I.setTrack('reserve');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Espace Réserve'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Changer de module',
            onPressed: _openProgramPicker,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _ProgramBanner(program: HomePageReserveSchool.program, isDark: isDark),
          const SizedBox(height: 20),

          Text(
            'Modules',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),

          // TODO(reserve): brancher les vraies pages de cours.
          //   Exemples :
          //   _buildModuleCard(
          //     icon: Icons.gavel_rounded,
          //     title: 'Statut du Réserviste',
          //     subtitle: 'Engagement, durée, conditions',
          //     onTap: () => Navigator.pushNamed(context, '/reserve/statut'),
          //   ),
          _buildModuleCard(
            context,
            icon: Icons.school_rounded,
            title: 'Module : ${HomePageReserveSchool.program.title}',
            subtitle: HomePageReserveSchool.program.subtitle,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Module Réserve à configurer. Voir home_page_reserve_school.dart.',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildModuleCard(
            context,
            icon: Icons.menu_book_rounded,
            title: 'Cours mutualisés (GPX/PA)',
            subtitle:
                'Tu peux accéder aux cours communs en attendant les pages dédiées.',
            onTap: () => Navigator.pushNamed(context, '/gpx/generalites/infraction'),
          ),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: .04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: .08),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'L’espace Réserve est en cours de construction. Le contenu et les quiz arrivent bientôt.',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openProgramPicker() async {
    final picked = await Navigator.of(context).push<ReserveSchoolProgram>(
      MaterialPageRoute(builder: (_) => const ReserveSchoolArt()),
    );
    if (picked != null && mounted) {
      setState(() => HomePageReserveSchool.program = picked);
    }
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: isDark ? Colors.white10 : Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: .08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramBanner extends StatelessWidget {
  final ReserveSchoolProgram program;
  final bool isDark;
  const _ProgramBanner({required this.program, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1565C0),
            const Color(0xFF1976D2).withValues(alpha: .85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  program.badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .4,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                program.title,
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                program.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .9),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
