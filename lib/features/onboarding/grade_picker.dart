// lib/onboarding/grade_picker.dart
// Choix du grade : Réserviste / Policier adjoint / Gardien de la paix
// - Upsert Supabase (user_profiles.user_track)
// - Persistance locale + live controllers (si exposés)
// - Redirection Home (ou Réserve)

import 'dart:ui'; // pour ImageFilter.blur
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Si tu as exposé le contrôleur du grade depuis home_page.dart
import 'package:copiqpolice/features/home/home_page.dart'
    show UserTrackController, UserTrack;
import 'package:copiqpolice/features/reserve/accueil_reserve.dart';

class _T {
  static const Color ink = Color(0xFF212529);
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withOpacity(a);
}

enum GradeChoice { reserve, pa, gpx }

class GradePickerScreen extends StatefulWidget {
  const GradePickerScreen({
    super.key,
    this.gpxCardKey,
    this.onGradeSelectedOverride,
    this.lockToGpxOnly = false,
  });

  /// Tutoriel : clé pour mesurer la carte "GPX"
  final GlobalKey? gpxCardKey;

  /// Tutoriel : délègue la sélection (pas de save / pas de nav)
  final Future<void> Function(GradeChoice choice)? onGradeSelectedOverride;

  /// Tutoriel : bloque tout sauf GPX
  final bool lockToGpxOnly;

  @override
  State<GradePickerScreen> createState() => _GradePickerScreenState();
}

class _GradePickerScreenState extends State<GradePickerScreen> {
  GradeChoice? _grade;
  bool _saving = false;

  Future<void> _upsertProfile({required String userTrack}) async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) return;
      await client.from('user_profiles').upsert({
        'user_id': user.id,
        'user_track': userTrack, // 'pa' | 'gpx' | 'reserve'
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');
    } catch (_) {
      // ignore réseau
    }
  }

  Future<void> _apply(GradeChoice g) async {
    if (_saving) return;

    // ✅ TUTORIEL : bloque les autres choix si demandé
    if (widget.lockToGpxOnly && g != GradeChoice.gpx) {
      HapticFeedback.selectionClick();
      return;
    }

    // ✅ TUTORIEL : override => pas de save / pas de navigation
    if (widget.onGradeSelectedOverride != null) {
      await widget.onGradeSelectedOverride!(g);
      return;
    }

    // ✅ COMPORTEMENT NORMAL
    setState(() {
      _grade = g;
      _saving = true;
    });

    try {
      final sp = await SharedPreferences.getInstance();

      if (g == GradeChoice.reserve) {
        await _upsertProfile(userTrack: 'reserve');
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacementNamed(ReserveAccueilPage.routeName);
        return;
      }

      if (g == GradeChoice.pa) {
        await sp.setString('selected_track', 'pa');
        try {
          await UserTrackController.I.setTrack(UserTrack.pa);
        } catch (_) {}
        await _upsertProfile(userTrack: 'pa');
      } else {
        await sp.setString('selected_track', 'gpx');
        try {
          await UserTrackController.I.setTrack(UserTrack.gpx);
        } catch (_) {}
        await _upsertProfile(userTrack: 'gpx');
      }

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/home-bootstrap', (r) => false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor.withOpacity(0.97),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            children: [
              Text(
                'Choisis ton grade',
                style: GoogleFonts.instrumentSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.1,
                  color: isDark ? Colors.white : _T.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Réserve, Policier adjoint ou Gardien de la paix.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _muted(context, .8),
                ),
              ),
              const SizedBox(height: 22),

              _ChoiceHeroCard(
                image: 'assets/images/reserve.jpeg',
                badge: 'Réserve',
                title: 'Réserviste',
                selected: _grade == GradeChoice.reserve,
                onTap: () => _apply(GradeChoice.reserve),
              ),
              const SizedBox(height: 18),

              _ChoiceHeroCard(
                image: 'assets/images/pa.jpg',
                badge: 'Adjoint',
                title: 'Policier adjoint',
                selected: _grade == GradeChoice.pa,
                onTap: () => _apply(GradeChoice.pa),
              ),
              const SizedBox(height: 18),

              _ChoiceHeroCard(
                key: widget.gpxCardKey, // ✅ IMPORTANT : clé pour spotlight
                image: 'assets/images/gpx.jpg',
                badge: 'GPX',
                title: 'Gardien de la paix',
                selected: _grade == GradeChoice.gpx,
                onTap: () => _apply(GradeChoice.gpx),
              ),

              const SizedBox(height: 26),
              Center(
                child: Text(
                  'Tu pourras modifier ce choix plus tard dans “Mon compte”.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _muted(context, .7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Carte héro ultra léchée ---
class _ChoiceHeroCard extends StatelessWidget {
  final String image;
  final String badge; // non utilisé mais gardé pour compat
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceHeroCard({
    super.key,
    required this.image,
    required this.badge,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget img;
    try {
      img = Image.asset(image, fit: BoxFit.cover);
    } catch (_) {
      img = Container(color: Colors.black.withOpacity(.06));
    }

    return AnimatedScale(
      scale: selected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: selected ? 1 : 0.96,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 220,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.12),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
              border: selected
                  ? Border.all(
                      color: isDark
                          ? const Color(0xFF90CAF9)
                          : const Color(0xFF1565C0).withOpacity(.9),
                      width: 2,
                    )
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // IMG
                Positioned.fill(child: img),

                // FLUO GLOBAL
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(color: Colors.black.withOpacity(0.28)),
                  ),
                ),

                // SPOTLIGHT DERRIÈRE LE TITRE (effet premium)
                Center(
                  child: Container(
                    width: 260,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.65,
                        colors: [
                          Colors.white.withOpacity(.35),
                          Colors.white.withOpacity(.12),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // TITRE SANS BACKGROUND
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
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
                  ),
                ),

                // BOUTON EN BAS
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: _DiscoverButton(onTap: onTap),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscoverButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DiscoverButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _T.ink.withValues(alpha: .92),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Expanded(
              child: Center(
                child: Text(
                  'Découvrir',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    shadows: [
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
            SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_forward_rounded, size: 18, color: _T.ink),
            ),
          ],
        ),
      ),
    );
  }
}
