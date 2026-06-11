// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Performance Utilities                            ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-077             ║
// ║                                                                           ║
// ║  Boîte à outils centralisée pour atteindre la cible :                     ║
// ║    • 60fps minimum (toute device)                                         ║
// ║    • 90fps idéal (Pixel 8, Samsung Galaxy S23+, OnePlus, etc.)            ║
// ║    • 120fps iOS sur ProMotion (iPhone 13 Pro+)                            ║
// ║                                                                           ║
// ║  Stratégies couvertes :                                                   ║
// ║    1. Précache des images critiques au boot                              ║
// ║    2. Sélection adaptative DPR (faible/moyen/haut)                       ║
// ║    3. Helper pour `SliverList`/`SliverGrid` (lazy + recycling)           ║
// ║    4. Frame pacing : exposition du refresh rate côté Dart                ║
// ║    5. Mesure de jank (frame drops) et report Sentry                      ║
// ║                                                                           ║
// ║  N.B. Les configs natives (Info.plist iOS / build.gradle Android) sont   ║
// ║       documentées séparément dans                                         ║
// ║       docs/cas_pratique/PERFORMANCE_TUNING.md                             ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ──────────────────────────────────────────────────────────────────────────
//  1. Précache d'images critiques
// ──────────────────────────────────────────────────────────────────────────

/// Précache les images critiques au démarrage de l'app.
/// À appeler dans `home_page` ou root widget une fois que `BuildContext` est
/// disponible (post-`mounted`).
///
/// Exemple :
/// ```dart
/// @override
/// void didChangeDependencies() {
///   super.didChangeDependencies();
///   CpImagePrecache.warmUp(context);
/// }
/// ```
class CpImagePrecache {
  CpImagePrecache._();

  /// Liste des images critiques pour le premier render.
  /// Garde-la courte (~5-10 max) sinon ça dégrade le startup.
  static const List<String> _critical = [
    'assets/images/logo.png',
    'assets/splash/branding.png',
  ];

  static bool _done = false;

  /// Précharge les images. Idempotent.
  static Future<void> warmUp(BuildContext context, {List<String>? extra}) async {
    if (_done) return;
    _done = true;
    final assets = <String>[..._critical, if (extra != null) ...extra];
    for (final path in assets) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (e) {
        // Silencieux : un asset manquant ne doit pas planter l'app
        if (kDebugMode) {
          debugPrint('[CpImagePrecache] precache failed for $path: $e');
        }
      }
    }
  }

  /// Force un nouveau warmup (utile pour tests ou hot-reload de devops).
  static void reset() {
    _done = false;
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  2. Adaptation DPR — choisir la bonne résolution d'asset
// ──────────────────────────────────────────────────────────────────────────

class CpAdaptiveResolution {
  CpAdaptiveResolution._();

  /// Renvoie un suffixe pour les assets selon la densité d'écran.
  /// Permet de servir `image@1x.png` / `image@2x.png` / `image@3x.png` :
  ///   - DPR ≤ 1.5 : @1x  (devices low-end / large écrans)
  ///   - DPR ≤ 2.5 : @2x  (la plupart des téléphones)
  ///   - DPR > 2.5 : @3x  (iPhone Plus / Pixel Pro / écrans rétina)
  static String suffix(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    if (dpr <= 1.5) return '@1x';
    if (dpr <= 2.5) return '@2x';
    return '@3x';
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  3. Helpers Sliver — listes longues haute performance
// ──────────────────────────────────────────────────────────────────────────

class CpSliverHelpers {
  CpSliverHelpers._();

  /// Construit une liste Sliver optimisée :
  ///   • addAutomaticKeepAlives = false  (libère la mémoire des items off-screen)
  ///   • addRepaintBoundaries = true     (isole les repaint par item)
  ///   • addSemanticIndexes = true       (accessibilité TalkBack/VoiceOver)
  ///
  /// Utiliser pour toute liste de + de 30 items.
  static SliverList list<T>({
    required List<T> items,
    required Widget Function(BuildContext, int, T) builder,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => builder(ctx, i, items[i]),
        childCount: items.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        addSemanticIndexes: true,
      ),
    );
  }

  /// Construit une grille Sliver optimisée (par exemple pour les cards cas).
  static SliverGrid grid<T>({
    required List<T> items,
    required Widget Function(BuildContext, int, T) builder,
    required SliverGridDelegate gridDelegate,
  }) {
    return SliverGrid(
      gridDelegate: gridDelegate,
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => builder(ctx, i, items[i]),
        childCount: items.length,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        addSemanticIndexes: true,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  4. Frame pacing & refresh rate
// ──────────────────────────────────────────────────────────────────────────

class CpFramePacing {
  CpFramePacing._();

  /// Refresh rate du device courant (Hz). 60.0 par défaut si introuvable.
  /// Sur iPhone ProMotion : 120.0
  /// Sur Pixel 8/Samsung S23 : 90.0 ou 120.0
  /// Sur low-end : 60.0
  static double currentRefreshRate(BuildContext context) {
    try {
      final view = View.maybeOf(context);
      final rate = view?.display.refreshRate;
      if (rate != null && rate > 0) return rate;
    } catch (_) {/* ignore */}
    return 60.0;
  }

  /// Budget par frame (ms) pour rester à 60fps stable.
  /// = 16.67 ms ; au-delà → drop frame.
  static const double frameBudgetMs60fps = 1000.0 / 60.0;

  /// Budget par frame pour 90fps : 11.11 ms.
  static const double frameBudgetMs90fps = 1000.0 / 90.0;

  /// Budget par frame pour 120fps : 8.33 ms.
  static const double frameBudgetMs120fps = 1000.0 / 120.0;
}

// ──────────────────────────────────────────────────────────────────────────
//  5. Mesure de jank — détection des frames dropées
// ──────────────────────────────────────────────────────────────────────────

/// Wrapper léger autour de `SchedulerBinding.addTimingsCallback`.
/// Compte les frames qui dépassent le budget et permet de remonter un
/// rapport à Sentry / PostHog. À démarrer une fois au boot via `start()`.
class CpJankMonitor {
  CpJankMonitor._();

  static int _slowFrames = 0;
  static int _totalFrames = 0;
  static Timer? _reportTimer;
  static void Function(JankSnapshot snapshot)? _onReport;
  static bool _started = false;

  /// Démarre la mesure. Idempotent. Le `onReport` est appelé toutes les
  /// `reportInterval` secondes avec un snapshot des stats.
  static void start({
    Duration reportInterval = const Duration(minutes: 5),
    void Function(JankSnapshot snapshot)? onReport,
  }) {
    if (_started) return;
    _started = true;
    _onReport = onReport;

    SchedulerBinding.instance.addTimingsCallback(_onTimings);

    _reportTimer?.cancel();
    _reportTimer = Timer.periodic(reportInterval, (_) {
      _flush();
    });
  }

  /// Stoppe la mesure (au logout ou pour les tests).
  static void stop() {
    if (!_started) return;
    _started = false;
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _reportTimer?.cancel();
    _reportTimer = null;
    _slowFrames = 0;
    _totalFrames = 0;
  }

  static void _onTimings(List<ui.FrameTiming> timings) {
    for (final t in timings) {
      _totalFrames++;
      final totalMs =
          (t.totalSpan.inMicroseconds / 1000.0); // build + raster
      if (totalMs > CpFramePacing.frameBudgetMs60fps + 4) {
        // +4ms de tolérance pour éviter les faux positifs
        _slowFrames++;
      }
    }
  }

  static void _flush() {
    if (_totalFrames == 0) return;
    final snap = JankSnapshot(
      totalFrames: _totalFrames,
      slowFrames: _slowFrames,
      jankRatio: _slowFrames / _totalFrames,
      capturedAt: DateTime.now(),
    );
    _slowFrames = 0;
    _totalFrames = 0;
    _onReport?.call(snap);
  }
}

/// Stats agrégées d'une période de mesure.
@immutable
class JankSnapshot {
  final int totalFrames;
  final int slowFrames;
  final double jankRatio; // 0..1
  final DateTime capturedAt;

  const JankSnapshot({
    required this.totalFrames,
    required this.slowFrames,
    required this.jankRatio,
    required this.capturedAt,
  });

  Map<String, Object?> toJson() => {
        'total_frames': totalFrames,
        'slow_frames': slowFrames,
        'jank_ratio': jankRatio,
        'captured_at': capturedAt.toIso8601String(),
      };

  @override
  String toString() =>
      'JankSnapshot($slowFrames/$totalFrames = ${(jankRatio * 100).toStringAsFixed(1)}%)';
}
