// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — AmoledService (toggle AMOLED dark)            ║
// ║  Tâche      : CODE-068                                                  ║
// ║                                                                         ║
// ║  Le mode AMOLED remplace le `#000B36` (navy COP'IQ) par du `#000000`   ║
// ║  pur en dark, ce qui économise la batterie sur les écrans OLED (chaque ║
// ║  pixel #000 est éteint).                                                ║
// ║                                                                         ║
// ║  Le toggle est persisté dans shared_preferences. L'app peut s'abonner  ║
// ║  via `valueListenable` pour rebuild quand l'utilisateur change le mode.║
// ║                                                                         ║
// ║  Usage :                                                                 ║
// ║   await AmoledService.instance.init();                                  ║
// ║   ValueListenableBuilder<bool>(                                          ║
// ║     valueListenable: AmoledService.instance.enabled,                    ║
// ║     builder: (_, isAmoled, __) =>                                       ║
// ║         MyScaffold(bg: CpTokens.amoledOr(isDark, isAmoled, defaultBg)),  ║
// ║   );                                                                     ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmoledService {
  AmoledService._();
  static final AmoledService instance = AmoledService._();

  static const String _kKey = 'cas_pratique_amoled_enabled';

  /// État réactif : true = mode AMOLED actif (vrai noir).
  final ValueNotifier<bool> enabled = ValueNotifier<bool>(false);

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      enabled.value = prefs.getBool(_kKey) ?? false;
    } catch (e) {
      if (kDebugMode) debugPrint('[AmoledService] init failed: $e');
    }
    _initialized = true;
  }

  Future<void> setEnabled(bool value) async {
    enabled.value = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kKey, value);
    } catch (e) {
      if (kDebugMode) debugPrint('[AmoledService] setEnabled failed: $e');
    }
  }

  Future<void> toggle() async => setEnabled(!enabled.value);

  /// Lecture synchrone sans round-trip (cache mémoire).
  bool isEnabledSync() => enabled.value;
}
