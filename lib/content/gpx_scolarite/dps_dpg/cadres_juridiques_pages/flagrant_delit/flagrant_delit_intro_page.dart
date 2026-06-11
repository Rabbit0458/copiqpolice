// lib/gpx_scolarite_pages/generalite_pages/hierarchie/hierarchie_intro_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/flagrant_delit/flagrant_delit_contenu_page.dart';

/// ==============================================================
///  COP'IQ — Hiérarchie (SPLASH IA 2025)
///
///  ✅ Une SEULE image de fond
///  ✅ Titre "écriture IA" + glow
///  ✅ Sous-texte en fade
///  ✅ Bouton "COMMENCER" (glow/pulse) → navigation vers FlagrantDelitContenuPage
///  ✅ Bouton retour réutilisable : CopiqHeroBackButton
/// ==============================================================
class FlagrantDelitIntroPage extends StatefulWidget {
  const FlagrantDelitIntroPage({super.key});

  /// Route (si tu veux l’ouvrir par nom)
  static const String routeName = '/gpx/generalites/flagrant_delit_intro';

  @override
  State<FlagrantDelitIntroPage> createState() => _FlagrantDelitIntroPageState();
}

class _FlagrantDelitIntroPageState extends State<FlagrantDelitIntroPage>
    with TickerProviderStateMixin {
  // === EDITABLE — CONFIG ===
  // Change l’image si besoin (par ex. 'assets/images/hierarchie.jpeg')
  static const String _kBackgroundPath = 'assets/images/copic_institutions.jpg';
  static const Alignment _kBackgroundAlignment = Alignment(0, -0.50);
  static const BoxFit _kFit = BoxFit.cover;

  // Cible : ta page contenu existante
  static const String _kTargetRouteName = FlagrantDelitContenuPage.routeName;

  // Animations
  late final AnimationController _fadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  late final AnimationController _subtitleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final AnimationController _buttonPulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
    lowerBound: 0.0,
    upperBound: 1.0,
  )..repeat(reverse: true);

  // Écriture IA (typewriter)
  static const String _titleFull = 'L\'ENQUÊTE DE FLAGRANT DÉLIT';
  int _typedCount = 0;
  Timer? _typeTimer;

  @override
  void initState() {
    super.initState();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 36), (t) {
      if (!mounted) return;
      if (_typedCount < _titleFull.length) {
        setState(() => _typedCount++);
      } else {
        t.cancel();
        _subtitleCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _fadeCtrl.dispose();
    _subtitleCtrl.dispose();
    _buttonPulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _onStart() async {
    if (!mounted) return;
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const _RouteShimToTarget();
        },
        transitionsBuilder: (context, animation, secondary, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF070707);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Image de fond
          AnimatedBuilder(
            animation: _fadeCtrl,
            builder: (context, _) {
              return Opacity(
                opacity: CurvedAnimation(
                  parent: _fadeCtrl,
                  curve: Curves.easeOut,
                ).value,
                child: Image.asset(
                  _kBackgroundPath,
                  fit: _kFit,
                  alignment: _kBackgroundAlignment,
                  filterQuality: FilterQuality.high,
                ),
              );
            },
          ),

          // 2) Voile lisibilité
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x99000000), Color(0xD0000000)],
              ),
            ),
          ),

          // 3) Contenu centré
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),

                  // Titre typewriter
                  _TypewriterTitle(text: _titleFull.substring(0, _typedCount)),

                  const SizedBox(height: 14),

                  // Sous-texte (après fin titre)
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _subtitleCtrl,
                      curve: Curves.easeOutCubic,
                    ),
                    child: Text(
                      "Comprendre l'enquête de flagrant délit.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fustat(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Bouton principal
                  _NeonButton(
                    label: 'COMMENCER',
                    glow: _buttonPulseCtrl,
                    onTap: _onStart,
                  ),

                  const Spacer(),

                  // Indice de navigation minimal
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withValues(alpha: 0.55),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4) Bouton RETOUR (réutilisable)
          const CopiqHeroBackButton(),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// Bouton retour réutilisable (à coller UNE FOIS dans un fichier commun
/// si tu veux le partager partout, sinon tu peux le laisser ici.
/// ------------------------------------------------------------------
class CopiqHeroBackButton extends StatelessWidget {
  const CopiqHeroBackButton({super.key, this.iconColor, this.backgroundColor});

  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveIconColor =
        iconColor ?? (isDark ? Colors.white : const Color(0xFF050505));

    final Color effectiveBg =
        backgroundColor ??
        (isDark
            ? Colors.black.withValues(alpha: .35)
            : Colors.white.withValues(alpha: .30));

    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: .25)
        : Colors.black.withValues(alpha: .12);

    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                final nav = Navigator.of(context);
                if (nav.canPop()) {
                  nav.pop();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: effectiveBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: effectiveIconColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Retour',
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: .2,
                        color: effectiveIconColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
///  Widgets visuels partagés (Typewriter + bouton néon)
/// ------------------------------------------------------------------
class _TypewriterTitle extends StatelessWidget {
  const _TypewriterTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFD3E3FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.fustat(
          textStyle: const TextStyle(
            fontSize: 32, // légèrement plus petit vu la longueur du titre
            height: 1.08,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Color(0x66FFFFFF),
                offset: Offset(0, 0),
              ),
              Shadow(
                blurRadius: 22,
                color: Color(0x22A9C7FF),
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  const _NeonButton({required this.label, required this.glow, this.onTap});
  final String label;
  final AnimationController glow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glow,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(glow.value);
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              color: Colors.white.withValues(alpha: 0.10 + t * 0.08),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.85),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF4DA3FF,
                  ).withValues(alpha: 0.22 + t * 0.18),
                  blurRadius: 22 + t * 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.fustat(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ------------------------------------------------------------------
/// Shim de redirection vers la route cible (FlagrantDelitContenuPage)
/// ------------------------------------------------------------------
class _RouteShimToTarget extends StatelessWidget {
  const _RouteShimToTarget();
  @override
  Widget build(BuildContext context) {
    Future.microtask(
      () => Navigator.of(
        context,
      ).pushReplacementNamed(_FlagrantDelitIntroPageState._kTargetRouteName),
    );
    return const Scaffold(backgroundColor: Colors.black);
  }
}
