// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — SkeletonBox + ShimmerController                ║
// ║  Tâche      : CODE-067                                                  ║
// ║                                                                         ║
// ║  Brique de base pour tous les états "loading" du module.                ║
// ║   - `SkeletonBox` : un rectangle shimmer (controllerless = partage     ║
// ║     l'AnimationController parent via Provider/InheritedWidget).        ║
// ║   - `SkeletonShimmer` : InheritedWidget qui expose l'AnimationController║
// ║     unique pour toute la sous-arborescence (évite de créer 1 controller║
// ║     par box = O(1) au lieu de O(n)).                                   ║
// ║                                                                         ║
// ║  Respecte `MediaQuery.disableAnimations` + OS reduceMotion.            ║
// ║                                                                         ║
// ║  Usage typique :                                                         ║
// ║    return SkeletonShimmer(                                              ║
// ║      child: Column(children: [                                          ║
// ║        SkeletonBox(width: 200, height: 16),                              ║
// ║        SkeletonBox(width: 120, height: 12),                              ║
// ║      ]),                                                                 ║
// ║    );                                                                    ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';

class SkeletonShimmer extends StatefulWidget {
  const SkeletonShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
  });

  final Widget child;
  final Duration duration;

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SkeletonShimmerScope(
      controller: _ctrl,
      child: widget.child,
    );
  }
}

class _SkeletonShimmerScope extends InheritedWidget {
  const _SkeletonShimmerScope({
    required this.controller,
    required super.child,
  });

  final AnimationController controller;

  static _SkeletonShimmerScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SkeletonShimmerScope>();
  }

  @override
  bool updateShouldNotify(_SkeletonShimmerScope oldWidget) =>
      oldWidget.controller != controller;
}

/// Boîte shimmer réutilisable. Pour la couleur, on choisit automatiquement
/// le bon contraste selon le brightness ambiant.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = 8,
    this.color,
  });

  final double? width;
  final double height;
  final double radius;
  final Color? color;

  bool _reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final osDisable = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    return (mq?.disableAnimations ?? false) || osDisable;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = color ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06));

    final scope = _SkeletonShimmerScope.maybeOf(context);
    final reduceMotion = _reduceMotion(context);
    if (scope == null || reduceMotion) {
      // Pas de shimmer disponible (ou reduceMotion actif) : un simple
      // rectangle statique fait l'affaire.
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: scope.controller,
      builder: (_, __) {
        final t = scope.controller.value;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Color.lerp(
              base,
              base.withValues(alpha: (base.alpha / 255.0) + 0.06),
              t,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
        );
      },
    );
  }
}

/// Circle skeleton (avatar, badge rond, etc.).
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({super.key, this.size = 40, this.color});
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: size,
      height: size,
      radius: size / 2,
      color: color,
    );
  }
}
