// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Haptics service (impacts contextuels)         ║
// ║  Tâche      : CODE-066                                                  ║
// ║                                                                         ║
// ║  Wrapper unifié autour de `HapticFeedback` qui :                       ║
// ║   - Sémantise les events (selection / light / medium / heavy /         ║
// ║     success / warning / error)                                         ║
// ║   - Compose des patterns custom (score reveal = heavy + 3 clicks      ║
// ║     rythmés, success = medium + selection après 80ms)                  ║
// ║   - Mute global persisté (shared_preferences)                          ║
// ║   - Respecte les préférences d'accessibilité de l'OS (si l'utilisateur ║
// ║     a activé "réduire les vibrations", on n'envoie rien)              ║
// ║                                                                         ║
// ║  Usage :                                                                 ║
// ║    await HapticsService.instance.init();                                ║
// ║    HapticsService.instance.fire(HapticEvent.success);                  ║
// ║    HapticsService.instance.scoreReveal(); // pattern composé            ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Événements haptiques sémantiques.
enum HapticEvent {
  selection,
  light,
  medium,
  heavy,
  success,   // pattern composé
  warning,   // pattern composé
  error,     // pattern composé
}

class HapticsService {
  HapticsService._();

  static final HapticsService instance = HapticsService._();

  static const String _kMutedKey = 'cas_pratique_haptics_muted';

  bool _muted = false;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _muted = prefs.getBool(_kMutedKey) ?? false;
    } catch (e) {
      if (kDebugMode) debugPrint('[HapticsService] init failed: $e');
    }
    _initialized = true;
  }

  bool isMutedSync() => _muted;

  Future<void> setMuted(bool muted) async {
    _muted = muted;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kMutedKey, muted);
    } catch (e) {
      if (kDebugMode) debugPrint('[HapticsService] setMuted failed: $e');
    }
  }

  Future<void> toggle() async => setMuted(!_muted);

  /// Vrai si l'OS demande de réduire les animations / vibrations
  /// (préférence d'accessibilité système).
  bool _osReduceMotion() {
    try {
      return WidgetsBinding
          .instance.platformDispatcher.accessibilityFeatures.reduceMotion;
    } catch (_) {
      return false;
    }
  }

  bool get _suppressed => _muted || _osReduceMotion();

  // ─── API événementielle ────────────────────────────────────────────────

  void fire(HapticEvent event) {
    if (_suppressed) return;
    switch (event) {
      case HapticEvent.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticEvent.light:
        HapticFeedback.lightImpact();
        break;
      case HapticEvent.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticEvent.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticEvent.success:
        _patternSuccess();
        break;
      case HapticEvent.warning:
        _patternWarning();
        break;
      case HapticEvent.error:
        _patternError();
        break;
    }
  }

  // ─── Patterns composés (publics nommés) ────────────────────────────────

  /// Heavy initial + 3 selectionClicks rythmés (pour le ScoreReveal).
  void scoreReveal() {
    if (_suppressed) return;
    HapticFeedback.heavyImpact();
    Future<void>.delayed(const Duration(milliseconds: 180),
        () => HapticFeedback.selectionClick());
    Future<void>.delayed(const Duration(milliseconds: 300),
        () => HapticFeedback.selectionClick());
    Future<void>.delayed(const Duration(milliseconds: 420),
        () => HapticFeedback.selectionClick());
  }

  /// Pour les level-up XpService (light + medium 60ms après).
  void levelUp() {
    if (_suppressed) return;
    HapticFeedback.lightImpact();
    Future<void>.delayed(const Duration(milliseconds: 60),
        () => HapticFeedback.mediumImpact());
  }

  /// Pour les unlocks de badges (selection + selection 80ms après).
  void badgeUnlock() {
    if (_suppressed) return;
    HapticFeedback.selectionClick();
    Future<void>.delayed(const Duration(milliseconds: 80),
        () => HapticFeedback.selectionClick());
  }

  // ─── Internals ──────────────────────────────────────────────────────────

  void _patternSuccess() {
    // medium + selection après 80ms = "tic-toc" léger positif
    HapticFeedback.mediumImpact();
    Future<void>.delayed(const Duration(milliseconds: 80),
        () => HapticFeedback.selectionClick());
  }

  void _patternWarning() {
    // light deux fois (140ms)
    HapticFeedback.lightImpact();
    Future<void>.delayed(const Duration(milliseconds: 140),
        () => HapticFeedback.lightImpact());
  }

  void _patternError() {
    // medium + light + light : pattern court négatif
    HapticFeedback.mediumImpact();
    Future<void>.delayed(const Duration(milliseconds: 80),
        () => HapticFeedback.lightImpact());
    Future<void>.delayed(const Duration(milliseconds: 200),
        () => HapticFeedback.lightImpact());
  }
}
