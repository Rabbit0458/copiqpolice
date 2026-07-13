// lib/onboarding/mode_picker.dart
// Choix du mode : Concours / Scolarité
// - 2 cartes "Découvrir" -> redirige vers GradePickerScreen
// - Persistance du mode (SharedPreferences + Supabase user_profiles.user_mode)
// - Redirection immédiate vers le grade picker
// ✅ V2 : Plus de lock premium sur la carte "Je suis en scolarité"
//         Le blocage premium intervient à l'ouverture du contenu réel (modules).
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/features/home/home_page.dart'
    show UserMode, UserModeController;
import 'package:copiqpolice/features/onboarding/grade_picker.dart';

class _T {
  static const Color ink = Color(0xFF212529);
  static BoxShadow get shadow => BoxShadow(
    color: Colors.black.withValues(alpha: .08),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

Color _muted(BuildContext context, [double a = .72]) {
  final base =
      Theme.of(context).textTheme.bodySmall?.color ??
      (Theme.of(context).brightness == Brightness.dark ? Colors.white : _T.ink);
  return base.withValues(alpha: a);
}

class ModePickerScreen extends StatefulWidget {
  const ModePickerScreen({
    super.key,
    this.schoolCardKey,
    this.examCardKey,
    this.onModeSelectedOverride,
    this.lockToSchoolOnly = false,
  });

  /// Tutoriel : permet de récupérer la position exacte de la carte "Scolarité"
  final GlobalKey? schoolCardKey;

  /// Tutoriel : permet de récupérer la position exacte de la carte "Concours"
  final GlobalKey? examCardKey;

  /// Tutoriel : si défini, le ModePicker ne fait pas de navigation ni de save.
  final Future<void> Function(UserMode mode)? onModeSelectedOverride;

  /// Tutoriel : si true, empêche l'utilisateur de choisir "Je prépare le concours".
  final bool lockToSchoolOnly;

  @override
  State<ModePickerScreen> createState() => _ModePickerScreenState();
}

class _ModePickerScreenState extends State<ModePickerScreen> {
  UserMode? _mode;
  bool _saving = false;

  /// Upsert dans `public.user_profiles` (clé unique: user_id)
  Future<void> _upsertProfile({required String userMode}) async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) return;
      await client.from('user_profiles').upsert({
        'user_id': user.id,
        'user_mode': userMode, // 'exam' | 'school'
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');
    } catch (e) {
      debugPrint('[ModePicker] upsert user_profiles failed: $e');
    }
  }

  Future<void> _select(UserMode mode) async {
    if (_saving) return;

    // Tutoriel : on bloque "concours" si demandé
    if (widget.lockToSchoolOnly && mode == UserMode.exam) {
      HapticFeedback.selectionClick();
      return;
    }

    // Tutoriel : si override, on délègue au tuto (pas de save / pas de nav)
    if (widget.onModeSelectedOverride != null) {
      await widget.onModeSelectedOverride!(mode);
      return;
    }

    // Comportement normal
    setState(() {
      _mode = mode;
      _saving = true;
    });

    try {
      // 1) Local + Live controllers
      final sp = await SharedPreferences.getInstance();
      final userModeString = mode == UserMode.school ? 'school' : 'exam';
      await sp.setString('user_mode', userModeString);
      await UserModeController.I.setMode(mode);

      // 2) Distant
      await _upsertProfile(userMode: userModeString);

      // 3) Route vers le GradePicker
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GradePickerScreen()),
      );
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          children: [
            Text(
              'Bienvenue 👋',
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : _T.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Choisis ton mode pour adapter l'application.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _muted(context, .8),
              ),
            ),
            const SizedBox(height: 20),

            _ChoiceHeroCard(
              key: widget.examCardKey,
              image: 'assets/images/exam.jpeg',
              badge: 'Préparation',
              title: 'Je prépare le concours',
              selected: _mode == UserMode.exam,
              onTap: () => _select(UserMode.exam),
            ),

            _ChoiceHeroCard(
              key: widget.schoolCardKey,
              image: 'assets/images/school.jpeg',
              badge: 'École',
              title: 'Je suis en scolarité',
              selected: _mode == UserMode.school,
              onTap: () => _select(UserMode.school),
            ),

            const SizedBox(height: 22),
            Center(
              child: Text(
                'Tu pourras modifier ce choix plus tard dans "Mon compte".',
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

/// --- Carte héro (visuel + bouton "Découvrir") ---
class _ChoiceHeroCard extends StatelessWidget {
  final String image;
  final String badge;
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
      img = Container(color: Colors.black.withValues(alpha: .06));
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
                  color: Colors.black.withValues(alpha: .12),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
              border: selected
                  ? Border.all(
                      color: isDark
                          ? const Color(0xFF90CAF9)
                          : const Color(0xFF1565C0).withValues(alpha: .9),
                      width: 2,
                    )
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                Positioned.fill(child: img),

                // Overlay blur
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(color: Colors.black.withValues(alpha: 0.28)),
                  ),
                ),

                // Spotlight derrière le titre
                Center(
                  child: Container(
                    width: 260,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.65,
                        colors: [
                          Colors.white.withValues(alpha: .35),
                          Colors.white.withValues(alpha: .12),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // Titre
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

                // Bouton en bas
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
