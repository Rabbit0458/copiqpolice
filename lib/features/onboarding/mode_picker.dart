// lib/onboarding/mode_picker.dart
// Choix du mode : Concours / Scolarité
// - 2 cartes "Découvrir" -> redirige vers GradePickerScreen
// - Persistance du mode (SharedPreferences + Supabase user_profiles.user_mode)
// - Redirection immédiate vers le grade picker
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/features/home/home_page.dart'
    show UserMode, UserModeController;
// Import du grade picker
import 'package:copiqpolice/features/onboarding/grade_picker.dart';

// ✅ NEW: abonnement / lock
import 'package:copiqpolice/core/services/subscription_service.dart';

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

  /// ✅ Tutoriel : permet de récupérer la position exacte de la carte "Scolarité"
  /// pour afficher un spotlight parfaitement aligné.
  final GlobalKey? schoolCardKey;

  /// ✅ Tutoriel : permet de récupérer la position exacte de la carte "Concours"
  /// (si tu veux un spotlight dessus plus tard).
  final GlobalKey? examCardKey;

  /// ✅ Tutoriel : si défini, le ModePicker ne fait pas de navigation ni de save.
  /// Il appelle simplement ce callback avec le mode choisi.
  final Future<void> Function(UserMode mode)? onModeSelectedOverride;

  /// ✅ Tutoriel : si true, empêche l’utilisateur de choisir "Je prépare le concours".
  final bool lockToSchoolOnly;

  @override
  State<ModePickerScreen> createState() => _ModePickerScreenState();
}

class _ModePickerScreenState extends State<ModePickerScreen> {
  UserMode? _mode;
  bool _saving = false;

  // ✅ NEW: entitlements
  bool _loadingEntitlements = true;
  bool _isPremium = false;
  final _sub = SubscriptionService.instance;

  @override
  void initState() {
    super.initState();
    _loadEntitlements();
  }

  Future<void> _loadEntitlements() async {
    try {
      await _sub.refresh(force: true);
      _isPremium = _sub.state.value.isPremium;
    } catch (_) {
      _isPremium = false;
    } finally {
      if (mounted) {
        setState(() => _loadingEntitlements = false);
      }
    }
  }

  void _showSubscriptionRequiredSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                color: isDark ? const Color(0xFF14171A) : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: .18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.lock_rounded),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Abonnement requis',
                              style: GoogleFonts.instrumentSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : _T.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Le mode “Je suis en scolarité” est inclus dans Premium.\nActive Premium pour débloquer l’accès complet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _muted(context, .78),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Plus tard'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // ✅ Mets ici ta navigation vers l'écran abonnement
                                // Exemple:
                                // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
                                Navigator.of(
                                  context,
                                ).pushNamed('/subscription');
                              },
                              child: const Text('Voir Premium'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
      // Réseau/permissions: on ignore, le cache local est déjà bon
      debugPrint('[ModePicker] upsert user_profiles failed: $e');
    }
  }

  Future<void> _select(UserMode mode) async {
    if (_saving) return;

    // ✅ TUTORIEL : on bloque "concours" si demandé
    if (widget.lockToSchoolOnly && mode == UserMode.exam) {
      HapticFeedback.selectionClick();
      return;
    }

    // ✅ LOCK PREMIUM : scolarité interdite si FREE
    if (mode == UserMode.school && !_isPremium) {
      HapticFeedback.selectionClick();
      _showSubscriptionRequiredSheet();
      return;
    }

    // ✅ TUTORIEL : si override, on délègue au tuto (pas de save / pas de nav)
    if (widget.onModeSelectedOverride != null) {
      await widget.onModeSelectedOverride!(mode);
      return;
    }

    // ✅ COMPORTEMENT NORMAL (inchangé)
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

    final bool schoolLocked = !_isPremium; // ✅ lock uniquement sur scolarité

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
              'Choisis ton mode pour adapter l’application.',
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
              // ✅ NEW: lock sans changer le design
              locked: schoolLocked,
              onLockedTap: _showSubscriptionRequiredSheet,
              showLoadingLock:
                  _loadingEntitlements, // optionnel (pendant check)
            ),

            const SizedBox(height: 22),
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
    );
  }
}

/// --- Carte héro (visuel + bouton "Découvrir") ---
/// ✅ DESIGN INCHANGÉ : on ajoute uniquement un overlay lock + interception du tap.
class _ChoiceHeroCard extends StatelessWidget {
  final String image;
  final String badge;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  // ✅ NEW
  final bool locked;
  final VoidCallback? onLockedTap;
  final bool showLoadingLock;

  const _ChoiceHeroCard({
    super.key,
    required this.image,
    required this.badge,
    required this.title,
    required this.selected,
    required this.onTap,
    this.locked = false,
    this.onLockedTap,
    this.showLoadingLock = false,
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

    final effectiveTap = locked ? (onLockedTap ?? () {}) : onTap;

    return AnimatedScale(
      scale: selected ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: selected ? 1 : 0.96,
        child: GestureDetector(
          onTap: effectiveTap,
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

                // BOUTON EN BAS (design inchangé, mais tap redirigé si locked)
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: _DiscoverButton(onTap: effectiveTap),
                ),

                // ✅ LOCK OVERLAY (très léger, ne change pas la carte)
                if (locked || showLoadingLock)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        color: Colors.black.withOpacity(locked ? 0.12 : 0.06),
                      ),
                    ),
                  ),

                // ✅ Petit badge lock discret (pro, sans casser ton design)
                if (locked)
                  Positioned(
                    right: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _T.ink.withValues(alpha: .82),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.lock_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ✅ Loading discret (pendant check abonnement)
                if (showLoadingLock)
                  const Positioned(
                    right: 18,
                    top: 18,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
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
