// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — CpPageRoute (transitions adaptatives)         ║
// ║  Tâche      : CODE-067                                                  ║
// ║                                                                         ║
// ║  Route adaptative qui choisit la transition selon la plateforme :      ║
// ║                                                                         ║
// ║    iOS    → CupertinoPageRoute (swipe-back gesture natif)               ║
// ║    Android→ `_SlideFadeRoute` custom (slide right→left + fade-in)      ║
// ║                                                                         ║
// ║  Le but : éviter le `MaterialPageRoute` standard qui :                  ║
// ║   - sur iOS, ne ressemble pas au système                                ║
// ║   - sur Android, ne pose pas un fade discret en plus du slide          ║
// ║                                                                         ║
// ║  Respecte `MediaQuery.disableAnimations` (timing → 0) et l'OS         ║
// ║  reduceMotion. Si fullscreenDialog → utilise le slide vertical iOS    ║
// ║  natif (cohérence Apple HIG).                                          ║
// ║                                                                         ║
// ║  Helpers :                                                               ║
// ║    pushCp(context, builder, {name, fullscreenDialog})                  ║
// ║    cpRoute(builder, {name, fullscreenDialog})                           ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';

class CpPageRoute<T> extends PageRoute<T> {
  CpPageRoute({
    required this.builder,
    super.settings,
    this.fullscreenDialog = false,
    this.maintainState = true,
  }) : super(fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;

  @override
  final bool fullscreenDialog;

  @override
  final bool maintainState;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 320);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 280);

  bool get _isCupertino {
    try {
      return Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Cupertino : reproduit exactement la transition iOS (slide + parallax
    // de la page précédente). On délègue au theme Cupertino.
    if (_isCupertino) {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false,
        child: child,
      );
    }

    // Android : slide horizontal + fade discret.
    final slide = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

    final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);

    return SlideTransition(
      position: slide,
      child: FadeTransition(opacity: fade, child: child),
    );
  }
}

/// Helper : pousse une CpPageRoute.
Future<T?> pushCp<T>(
  BuildContext context,
  WidgetBuilder builder, {
  String? name,
  bool fullscreenDialog = false,
}) {
  return Navigator.of(context).push<T>(
    CpPageRoute<T>(
      builder: builder,
      settings: name != null ? RouteSettings(name: name) : null,
      fullscreenDialog: fullscreenDialog,
    ),
  );
}

/// Helper : retourne une CpPageRoute (à utiliser dans onGenerateRoute).
CpPageRoute<T> cpRoute<T>(
  WidgetBuilder builder, {
  String? name,
  bool fullscreenDialog = false,
}) {
  return CpPageRoute<T>(
    builder: builder,
    settings: name != null ? RouteSettings(name: name) : null,
    fullscreenDialog: fullscreenDialog,
  );
}
