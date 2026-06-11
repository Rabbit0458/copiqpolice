// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Sounds service (audio + haptic patterns)      ║
// ║  Tâche      : CODE-065                                                  ║
// ║                                                                         ║
// ║  Service singleton qui joue des sons subtils sur les événements clés  ║
// ║  du parcours (tap, validation, succès correction, fanfare, erreur).   ║
// ║                                                                         ║
// ║  Stratégie :                                                              ║
// ║  ────────────                                                            ║
// ║  - Implémentation immédiate via `SystemSound.play(SystemSoundType.*)`  ║
// ║    + `HapticFeedback` (aucune dépendance audio nouvelle ajoutée).      ║
// ║  - Patterns combinés (haptic + system sound décalés en µs) pour les   ║
// ║    sons "complexes" (validation, fanfare) sans charge audio.          ║
// ║  - **À venir (post-MVP)** : brancher `audioplayers` ou `just_audio`   ║
// ║    avec assets `assets/sounds/*.mp3` pour avoir de vrais sons design. ║
// ║    Le contrat `SoundsService` ne changera pas → aucun call-site à       ║
// ║    modifier.                                                            ║
// ║                                                                         ║
// ║  Mute global :                                                           ║
// ║   - Persisté dans shared_preferences (`cas_pratique_sounds_muted`)     ║
// ║   - Toggle via `setMuted(bool)`, observable via `isMutedSync()`       ║
// ║   - Initialisation : appeler `init()` au boot pour pré-charger l'état ║
// ║                                                                         ║
// ║  Usage :                                                                 ║
// ║   await SoundsService.instance.init();                                  ║
// ║   SoundsService.instance.play(SoundEvent.validation);                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Types d'événements sonores. Sera enrichi quand de vrais assets seront
/// ajoutés (assets/sounds/).
enum SoundEvent {
  /// Click discret — feedback de tap léger.
  tap,

  /// Question validée (uplift léger : médium impact + click).
  validation,

  /// Correction lancée (transition vers le score).
  correction,

  /// Score révélé (heavy + clicks rythmés).
  fanfare,

  /// Erreur (réponse vide, save fail, etc.).
  error,

  /// Succès silencieux (toast positif).
  successQuiet,
}

class SoundsService {
  SoundsService._();

  static final SoundsService instance = SoundsService._();

  static const String _kMutedKey = 'cas_pratique_sounds_muted';

  bool _muted = false;
  bool _initialized = false;

  /// Pré-charge l'état persistant. À appeler au boot (juste après Supabase).
  Future<void> init() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _muted = prefs.getBool(_kMutedKey) ?? false;
    } catch (e) {
      if (kDebugMode) debugPrint('[SoundsService] init failed: $e');
    }
    _initialized = true;
  }

  /// Lecture rapide sans round-trip async. Avant `init()`, retourne `false`.
  bool isMutedSync() => _muted;

  Future<bool> isMuted() async {
    await init();
    return _muted;
  }

  Future<void> setMuted(bool muted) async {
    _muted = muted;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kMutedKey, muted);
    } catch (e) {
      if (kDebugMode) debugPrint('[SoundsService] setMuted failed: $e');
    }
  }

  Future<void> toggle() async => setMuted(!_muted);

  // ─── PLAY ───────────────────────────────────────────────────────────────

  /// Joue un événement. No-op si muet.
  ///
  /// L'implémentation actuelle utilise `SystemSound` + `HapticFeedback`.
  /// Quand `audioplayers` sera ajouté à pubspec.yaml et que les assets
  /// `assets/sounds/*.mp3` seront fournis, on remplacera juste le `switch`
  /// par des appels `_pool.play(asset)` — sans toucher aux call-sites.
  void play(SoundEvent event) {
    if (_muted) return;
    switch (event) {
      case SoundEvent.tap:
        _playTap();
        break;
      case SoundEvent.validation:
        _playValidation();
        break;
      case SoundEvent.correction:
        _playCorrection();
        break;
      case SoundEvent.fanfare:
        _playFanfare();
        break;
      case SoundEvent.error:
        _playError();
        break;
      case SoundEvent.successQuiet:
        _playSuccessQuiet();
        break;
    }
  }

  // ─── Patterns (haptic + system sound) ───────────────────────────────────

  void _playTap() {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }

  void _playValidation() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    // Petit second click rythmique
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      SystemSound.play(SystemSoundType.click);
    });
  }

  void _playCorrection() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
  }

  void _playFanfare() {
    // 1) Heavy impact
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
    // 2) 3 clicks rythmés (≈ une mini-fanfare avec les moyens du bord)
    const delays = [120, 220, 340];
    for (final d in delays) {
      Future<void>.delayed(Duration(milliseconds: d), () {
        HapticFeedback.selectionClick();
        SystemSound.play(SystemSoundType.click);
      });
    }
  }

  void _playError() {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  void _playSuccessQuiet() {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }
}
