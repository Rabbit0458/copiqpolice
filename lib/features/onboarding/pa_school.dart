// lib/home/pa_school.dart
// Espace PA — Choix du programme du jour (NON sauvegardé)
// - 2 cartes héro ultra premium (blur + spotlight + badge glass)
// - Aucun SharedPreferences / Supabase
// - Retourne le choix via Navigator.pop(PaSchoolProgram)

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

  static BoxShadow get softShadow => BoxShadow(
    color: Colors.black.withValues(alpha: .08),
    blurRadius: 18,
    offset: const Offset(0, 10),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withValues(alpha: a);
}

enum PaSchoolProgram { institutionValeurs, dpsDpg, mememtoCirculationRoutiere }

extension PaSchoolProgramX on PaSchoolProgram {
  String get key => switch (this) {
    PaSchoolProgram.institutionValeurs => 'institution_valeurs',
    PaSchoolProgram.dpsDpg => 'dps_dpg',
    PaSchoolProgram.mememtoCirculationRoutiere =>
      'memento_circulation_routiere',
  };

  String get title => switch (this) {
    PaSchoolProgram.institutionValeurs => 'Institution & Valeurs',
    PaSchoolProgram.dpsDpg => 'DPS / DPG',
    PaSchoolProgram.mememtoCirculationRoutiere =>
      'Mémento • Circulation routière',
  };

  String get subtitle => switch (this) {
    PaSchoolProgram.institutionValeurs =>
      'Déontologie, hiérarchie, institutions : les repères essentiels.',
    PaSchoolProgram.dpsDpg =>
      'Droit pénal spécial + droit pénal général : le cœur des infractions.',
    PaSchoolProgram.mememtoCirculationRoutiere =>
      'Contraventions, contrôles, documents, procédures : l’essentiel terrain.',
  };

  String get heroImage => switch (this) {
    PaSchoolProgram.institutionValeurs => 'assets/images/school.jpeg',
    PaSchoolProgram.dpsDpg => 'assets/images/exam.jpeg',
    PaSchoolProgram.mememtoCirculationRoutiere =>
      'assets/images/contravention.jpeg',
  };

  String get badge => switch (this) {
    PaSchoolProgram.institutionValeurs => 'Aujourd’hui • Valeurs',
    PaSchoolProgram.dpsDpg => 'Aujourd’hui • Pénal',
    PaSchoolProgram.mememtoCirculationRoutiere => 'Aujourd’hui • Route',
  };

  IconData get icon => switch (this) {
    PaSchoolProgram.institutionValeurs => Icons.account_balance_rounded,
    PaSchoolProgram.dpsDpg => Icons.gavel_rounded,
    PaSchoolProgram.mememtoCirculationRoutiere => Icons.directions_car_rounded,
  };
}

class PaSchoolArt extends StatefulWidget {
  const PaSchoolArt({super.key});

  static const routeName = '/pa_school';

  @override
  State<PaSchoolArt> createState() => _PaSchoolArtState();
}

class _PaSchoolArtState extends State<PaSchoolArt> {
  bool _loading = false;
  PaSchoolProgram? _selected;

  Future<void> _pick(PaSchoolProgram program) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _selected = program;
    });

    // Petit micro délai “premium” pour laisser l’anim respirer
    await Future.delayed(const Duration(milliseconds: 140));

    if (!mounted) return;
    Navigator.of(context).pop(program);
  }

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
            // Header premium
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Espace PA',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : _T.ink,
                          letterSpacing: .2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Qu’est-ce que tu révises aujourd’hui ?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _muted(context, .86),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [_T.softShadow],
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: .22),
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(
              '💡 Ce choix n’est pas mémorisé : tu le sélectionnes à chaque démarrage.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _muted(context, .72),
                height: 1.35,
              ),
            ),

            const SizedBox(height: 18),

            _ProgramHeroCard(
              program: PaSchoolProgram.institutionValeurs,
              selected: _selected == PaSchoolProgram.institutionValeurs,
              disabled: _loading,
              onTap: () => _pick(PaSchoolProgram.institutionValeurs),
            ),
            const SizedBox(height: 16),
            _ProgramHeroCard(
              program: PaSchoolProgram.dpsDpg,
              selected: _selected == PaSchoolProgram.dpsDpg,
              disabled: _loading,
              onTap: () => _pick(PaSchoolProgram.dpsDpg),
            ),
            const SizedBox(height: 16),
            _ProgramHeroCard(
              program: PaSchoolProgram.mememtoCirculationRoutiere,
              selected: _selected == PaSchoolProgram.mememtoCirculationRoutiere,
              disabled: _loading,
              onTap: () => _pick(PaSchoolProgram.mememtoCirculationRoutiere),
            ),

            if (_loading) ...[
              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
            Center(
              child: Text(
                'Tu pourras revenir ici quand tu veux pour changer de focus.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _muted(context, .70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Carte héro programme (blur + spotlight + overlay premium) ---
class _ProgramHeroCard extends StatelessWidget {
  final PaSchoolProgram program;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const _ProgramHeroCard({
    required this.program,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget img;
    try {
      img = Image.asset(program.heroImage, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.black.withValues(alpha: .06));
    }

    final borderColor = selected
        ? (isDark
              ? const Color(0xFF90CAF9)
              : const Color(0xFF1565C0).withValues(alpha: .92))
        : theme.dividerColor.withValues(alpha: .18);

    return AnimatedScale(
      scale: selected ? 1.0 : 0.975,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: disabled ? .75 : (selected ? 1 : 0.965),
        child: GestureDetector(
          onTap: disabled ? null : onTap,
          child: Container(
            height: 245,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: [_T.shadow],
              border: Border.all(color: borderColor, width: selected ? 2 : 1),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: img),

                // Glass blur + gradient
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: .42),
                            Colors.black.withValues(alpha: .22),
                            Colors.black.withValues(alpha: .50),
                          ],
                          stops: const [0.0, 0.52, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // Spotlight
                Center(
                  child: Container(
                    width: 300,
                    height: 170,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.72,
                        colors: [
                          Colors.white.withValues(alpha: .38),
                          Colors.white.withValues(alpha: .14),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                  ),
                ),

                // Badge
                Positioned(
                  left: 14,
                  top: 14,
                  child: _GlassPill(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(program.icon, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          program.badge,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            letterSpacing: .2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Title + subtitle
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          program.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 23,
                            letterSpacing: .3,
                            height: 1.05,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          program.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white.withValues(alpha: .92),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.8,
                            height: 1.25,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 10,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // CTA bottom
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: _DiscoverButton(
                    label: selected ? 'Continuer' : 'Choisir',
                    onTap: disabled ? null : onTap,
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

class _GlassPill extends StatelessWidget {
  final Widget child;
  const _GlassPill({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: .18)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DiscoverButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const _DiscoverButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: disabled ? .55 : 1,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _T.ink.withValues(alpha: .92),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .18),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      letterSpacing: .2,
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: _T.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
