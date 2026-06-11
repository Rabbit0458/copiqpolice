// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Scaffold immersif commun                      ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (§ 4.1)              ║
// ║  Tâche      : CODE-029                                                  ║
// ║                                                                         ║
// ║  Fond gradient COP'IQ + halo radial + vignette + back pill + titre.   ║
// ║  Réutilisable par toutes les pages du module Cas Pratique.            ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

/// Scaffold immersif avec :
///  - Gradient background (light = bleu, dark = navy)
///  - Halo radial blanc subtil au centre haut
///  - Vignette douce sur les bords
///  - TopBar transparent : back pill + titre + (optionnel) action droite
///  - Bouton d'action sticky bottom (optionnel)
class CasPratiqueScaffold extends StatelessWidget {
  const CasPratiqueScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.onBack,
    this.canGoBack = true,
    this.rightAction,
    this.bottomAction,
    this.bottomPadding = 16.0,
    this.showBackdrop = true,
  });

  /// Titre centré dans la top bar.
  final String title;

  /// Sous-titre (petit, sous le titre). Optionnel.
  final String? subtitle;

  /// Corps de la page (déjà à l'intérieur d'un SafeArea).
  final Widget body;

  /// Callback bouton retour. Si null, comportement par défaut = Navigator.pop.
  final VoidCallback? onBack;

  /// Si false, on grise le bouton retour et on désactive le tap.
  final bool canGoBack;

  /// Widget aligné à droite du titre (icône action, par ex.).
  final Widget? rightAction;

  /// Widget sticky en bas (typiquement le CTA "Suivant" / "Valider").
  final Widget? bottomAction;

  /// Padding bottom pour le bottomAction.
  final double bottomPadding;

  /// Si false, on désactive le backdrop complet (pour les pages déjà
  /// gérant leur propre fond, par ex. la page de correction).
  final bool showBackdrop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CpTokens.darkNavy : CpTokens.blueLight,
      body: Stack(
        children: [
          if (showBackdrop) _CpBackdrop(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                _CpTopBar(
                  title: title,
                  subtitle: subtitle,
                  canGoBack: canGoBack,
                  onBack: onBack ?? () => _defaultBack(context),
                  rightAction: rightAction,
                ),
                Expanded(child: body),
                if (bottomAction != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      CpTokens.s6, 0, CpTokens.s6, bottomPadding,
                    ),
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: bottomAction!,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _defaultBack(BuildContext context) {
    HapticFeedback.selectionClick();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

// ─── Backdrop : gradient + halo + vignette ──────────────────────────────────

class _CpBackdrop extends StatelessWidget {
  const _CpBackdrop({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgTop = isDark ? CpTokens.darkNavy     : CpTokens.blueLight;
    final bgMid = isDark ? CpTokens.darkNavyMid  : CpTokens.blueMidLight;
    final bgBot = isDark ? CpTokens.darkNavyDeep : CpTokens.blueDeepLight;

    return Stack(
      children: [
        // 1) Gradient vertical
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgTop, bgMid, bgBot],
                ),
              ),
            ),
          ),
        ),
        // 2) Halo radial blanc subtil
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.18),
                  radius: 1.18,
                  colors: [
                    Colors.white.withValues(alpha: isDark ? 0.10 : 0.07),
                    Colors.white.withValues(alpha: isDark ? 0.04 : 0.03),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.62, 1.0],
                ),
              ),
            ),
          ),
        ),
        // 3) Vignette sombre subtile en bord
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.15),
                  radius: 1.10,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: isDark ? 0.40 : 0.30),
                  ],
                  stops: const [0.55, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Top bar : back pill + titre centré + action droite ────────────────────

class _CpTopBar extends StatelessWidget {
  const _CpTopBar({
    required this.title,
    required this.subtitle,
    required this.canGoBack,
    required this.onBack,
    required this.rightAction,
  });

  final String title;
  final String? subtitle;
  final bool canGoBack;
  final VoidCallback onBack;
  final Widget? rightAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s4, CpTokens.s3, CpTokens.s4, CpTokens.s2,
      ),
      child: Row(
        children: [
          _BackPill(enabled: canGoBack, onTap: onBack),
          const SizedBox(width: CpTokens.s3),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.98),
                    fontWeight: FontWeight.w900,
                    fontSize: 16.8,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: CpTokens.s3),
          // Action droite ou spacer fantôme pour équilibrer le titre
          rightAction ?? const SizedBox(width: 76),
        ],
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  const _BackPill({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(CpTokens.rPill),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: CpTokens.s3, vertical: CpTokens.s2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(CpTokens.rPill),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: Colors.white.withValues(alpha: 0.92),
                size: 18,
              ),
              const SizedBox(width: 2),
              Text(
                'Retour',
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 12.5,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
