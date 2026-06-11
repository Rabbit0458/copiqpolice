// lib/features/onboarding/reserve_school.dart
//
// Espace Réserve — Choix du programme du jour (NON sauvegardé).
//
// ⚠️ SQUELETTE À CONFIGURER MANUELLEMENT.
//
// Calque exact de `pa_school.dart` et `gpx_school.dart`. Pour ajouter des
// programmes Réserve :
//   1. Ajouter une valeur dans `ReserveSchoolProgram` (ex: `connaissancesGen`).
//   2. Ajouter ses textes dans les `extension ReserveSchoolProgramX` (key,
//      title, subtitle, etc.).
//   3. Ajouter un `_ChoiceHeroCard` dans le `build()` plus bas.
//
// La page retourne le programme choisi via `Navigator.pop(ReserveSchoolProgram)`
// — c'est `HomeBootstrap` qui l'injecte ensuite dans `HomePageReserveSchool`.

import 'dart:ui'; // ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _T {
  static const Color ink = Color(0xFF212529);

  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .12),
    blurRadius: 28,
    offset: const Offset(0, 16),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withValues(alpha: a);
}

// ============================================================================
// PROGRAMMES RÉSERVE — TODO: à enrichir selon le programme final de formation.
// ============================================================================

enum ReserveSchoolProgram {
  // TODO(reserve): remplacer ces 2 valeurs par les vrais modules Réserve.
  introduction,
  modulePlaceholder,
}

extension ReserveSchoolProgramX on ReserveSchoolProgram {
  String get key => switch (this) {
    ReserveSchoolProgram.introduction => 'introduction',
    ReserveSchoolProgram.modulePlaceholder => 'module_placeholder',
  };

  String get title => switch (this) {
    ReserveSchoolProgram.introduction => 'Introduction à la Réserve',
    ReserveSchoolProgram.modulePlaceholder => 'Module à définir',
  };

  String get subtitle => switch (this) {
    ReserveSchoolProgram.introduction =>
      'Présentation, missions et statut du Réserviste.',
    ReserveSchoolProgram.modulePlaceholder =>
      'À compléter avec le programme officiel.',
  };

  /// Image d'illustration (placeholder — remplacer par les vraies assets).
  String get image => switch (this) {
    ReserveSchoolProgram.introduction => 'assets/images/reserve.jpeg',
    ReserveSchoolProgram.modulePlaceholder => 'assets/images/reserve.jpeg',
  };

  String get badge => switch (this) {
    ReserveSchoolProgram.introduction => 'Module 1',
    ReserveSchoolProgram.modulePlaceholder => 'Module 2',
  };
}

// ============================================================================
// SCREEN
// ============================================================================

class ReserveSchoolArt extends StatelessWidget {
  const ReserveSchoolArt({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            Text(
              'Espace Réserve',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : _T.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choisis le module sur lequel tu veux travailler aujourd’hui.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _muted(context, .8),
              ),
            ),
            const SizedBox(height: 22),

            // TODO(reserve): ajouter une carte par valeur de ReserveSchoolProgram.
            for (final program in ReserveSchoolProgram.values) ...[
              _ChoiceHeroCard(
                image: program.image,
                badge: program.badge,
                title: program.title,
                subtitle: program.subtitle,
                onTap: () => Navigator.of(context).pop<ReserveSchoolProgram>(program),
              ),
              const SizedBox(height: 18),
            ],

            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tu pourras toujours changer de module depuis l’accueil.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _muted(context, .7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HERO CARD (calque sur pa_school.dart / gpx_school.dart)
// ============================================================================

class _ChoiceHeroCard extends StatelessWidget {
  final String image;
  final String badge;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceHeroCard({
    required this.image,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget img;
    try {
      img = Image.asset(image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.black.withValues(alpha: .06));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [_T.shadow],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: img),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(color: Colors.black.withValues(alpha: .28)),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.instrumentSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        letterSpacing: .3,
                        height: 1.05,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .85),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: .3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
