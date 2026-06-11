// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Feature Flags & A/B Testing Service              ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-075 / CODE-076  ║
// ║                                                                           ║
// ║  Conception                                                                ║
// ║    • Façade no-op self-contained (zéro dépendance externe forcée).        ║
// ║    • Override par dart-define ou bind() programmatique au démarrage.      ║
// ║    • Assignment déterministe : hash(userId + flagKey) → bucket [0..99].   ║
// ║    • Tracking d'exposition via callback `onExposed` branché sur          ║
// ║      `CpAnalytics.I` au binding (zéro couplage direct).                  ║
// ║                                                                           ║
// ║  Quand SDK distant disponible (GrowthBook, LaunchDarkly, PostHog flags) : ║
// ║    Implémenter `CpFeatureFlagsInterface` dans un autre fichier et        ║
// ║    appeler `CpFeatureFlags.I.bindImpl(myImpl)` au démarrage.             ║
// ║                                                                           ║
// ║  Usage                                                                    ║
// ║    if (CpFeatureFlags.I.isEnabled(CpFlagKeys.newCorrectionScreen)) { … } ║
// ║    final variant = CpFeatureFlags.I.assignVariant(                       ║
// ║      CpFlagKeys.validateButtonCopy,                                       ║
// ║      ['Valider', 'Soumettre', 'Terminer'],                                ║
// ║    );                                                                     ║
// ║    if (CpFeatureFlags.I.isInRollout('cp_edge_correction', 10)) { … }     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝


import 'package:flutter/foundation.dart';

// ──────────────────────────────────────────────────────────────────────────
//  Contrat public
// ──────────────────────────────────────────────────────────────────────────

abstract class CpFeatureFlagsInterface {
  /// True si le flag est activé pour l'utilisateur courant.
  bool isEnabled(String key, {bool defaultValue = false});

  /// Valeur typée string. Si non défini, retourne `defaultValue`.
  String getString(String key, {String defaultValue = ''});

  /// Valeur typée int.
  int getInt(String key, {int defaultValue = 0});

  /// Valeur typée double.
  double getDouble(String key, {double defaultValue = 0.0});

  /// Assigne une variante d'A/B test parmi `variants` de façon déterministe.
  /// Le même userId tombera toujours sur la même variante pour un même
  /// `experimentKey`. Retourne `null` si la liste est vide.
  String? assignVariant(String experimentKey, List<String> variants);

  /// True si l'utilisateur est dans les `rolloutPercent` premiers % du rollout.
  /// Idéal pour les feature flags progressifs (1% → 10% → 50% → 100%).
  bool isInRollout(String key, int rolloutPercent);
}

// ──────────────────────────────────────────────────────────────────────────
//  Catalogue des flags / expériences Cas Pratique
//  Centralise toutes les clés pour éviter les typos.
// ──────────────────────────────────────────────────────────────────────────

abstract class CpFlagKeys {
  CpFlagKeys._();

  // ── Rollouts progressifs (booléens) ──────────────────────────────────────
  /// Bascule l'app sur l'edge function TS au lieu du moteur Dart embarqué
  /// (CODE-051 / CODE-052). Permet un canary 1% → 10% → 100%.
  static const String edgeCorrection = 'cp_edge_correction';

  /// Nouvelle page correction premium (refonte CODE-067 dark mode + a11y).
  static const String newCorrectionScreen = 'cp_new_correction_screen';

  /// Permet le partage natif story (CODE-069) ; off par défaut sur iOS < 15.
  static const String shareStoryEnabled = 'cp_share_story_enabled';

  /// Export PDF de la copie corrigée (CODE-070).
  static const String pdfExportEnabled = 'cp_pdf_export_enabled';

  // ── Expériences A/B (variantes) ──────────────────────────────────────────
  /// Couleur du CTA principal (bleu / or / gradient).
  static const String validateButtonStyle = 'cp_validate_button_style';

  /// Copy du bouton de validation.
  static const String validateButtonCopy = 'cp_validate_button_copy';

  /// Ordre de présentation des questions (séquentiel / mélangé).
  static const String questionOrder = 'cp_question_order';

  /// Affichage des hints pendant la saisie (helper bar).
  static const String inlineHints = 'cp_inline_hints';
}

// ──────────────────────────────────────────────────────────────────────────
//  Implémentation par défaut — façade no-op + overrides locaux
// ──────────────────────────────────────────────────────────────────────────

class _CpFeatureFlagsNoop implements CpFeatureFlagsInterface {
  const _CpFeatureFlagsNoop();

  @override
  bool isEnabled(String key, {bool defaultValue = false}) => defaultValue;

  @override
  String getString(String key, {String defaultValue = ''}) => defaultValue;

  @override
  int getInt(String key, {int defaultValue = 0}) => defaultValue;

  @override
  double getDouble(String key, {double defaultValue = 0.0}) => defaultValue;

  @override
  String? assignVariant(String experimentKey, List<String> variants) =>
      variants.isEmpty ? null : variants.first;

  @override
  bool isInRollout(String key, int rolloutPercent) => false;
}

// ──────────────────────────────────────────────────────────────────────────
//  Implémentation locale — overrides + bucket déterministe
// ──────────────────────────────────────────────────────────────────────────

class _CpFeatureFlagsLocal implements CpFeatureFlagsInterface {
  _CpFeatureFlagsLocal({
    required String? userId,
    required Map<String, Object?> overrides,
    required void Function(String flag, Object? variant)? onExposed,
  })  : _userId = userId,
        _overrides = Map<String, Object?>.unmodifiable(overrides),
        _onExposed = onExposed;

  final String? _userId;
  final Map<String, Object?> _overrides;
  final void Function(String, Object?)? _onExposed;

  /// Hash déterministe FNV-1a 32-bit → bucket 0..99.
  /// Identique sur Dart et TS (utilisable côté edge function pour parité).
  int _bucket(String flagKey) {
    final input = '${_userId ?? 'anon'}:$flagKey';
    int hash = 0x811c9dc5; // FNV offset basis
    for (var i = 0; i < input.length; i++) {
      hash ^= input.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash % 100;
  }

  void _track(String flag, Object? variant) {
    final cb = _onExposed;
    if (cb == null) return;
    try {
      cb(flag, variant);
    } catch (e, st) {
      // L'analytics ne doit jamais casser un check de flag
      if (kDebugMode) {
        debugPrint('[CpFeatureFlags] onExposed error: $e\n$st');
      }
    }
  }

  @override
  bool isEnabled(String key, {bool defaultValue = false}) {
    if (_overrides.containsKey(key)) {
      final value = _overrides[key];
      final resolved = value is bool ? value : defaultValue;
      _track(key, resolved);
      return resolved;
    }
    _track(key, defaultValue);
    return defaultValue;
  }

  @override
  String getString(String key, {String defaultValue = ''}) {
    if (_overrides.containsKey(key)) {
      final value = _overrides[key];
      final resolved = value is String ? value : defaultValue;
      _track(key, resolved);
      return resolved;
    }
    _track(key, defaultValue);
    return defaultValue;
  }

  @override
  int getInt(String key, {int defaultValue = 0}) {
    if (_overrides.containsKey(key)) {
      final value = _overrides[key];
      final resolved = value is int
          ? value
          : (value is num ? value.toInt() : defaultValue);
      _track(key, resolved);
      return resolved;
    }
    _track(key, defaultValue);
    return defaultValue;
  }

  @override
  double getDouble(String key, {double defaultValue = 0.0}) {
    if (_overrides.containsKey(key)) {
      final value = _overrides[key];
      final resolved = value is double
          ? value
          : (value is num ? value.toDouble() : defaultValue);
      _track(key, resolved);
      return resolved;
    }
    _track(key, defaultValue);
    return defaultValue;
  }

  @override
  String? assignVariant(String experimentKey, List<String> variants) {
    if (variants.isEmpty) return null;
    // Si overrides force une variante valide, on la respecte
    if (_overrides.containsKey(experimentKey)) {
      final value = _overrides[experimentKey];
      if (value is String && variants.contains(value)) {
        _track(experimentKey, value);
        return value;
      }
    }
    final bucket = _bucket(experimentKey);
    final variant = variants[bucket % variants.length];
    _track(experimentKey, variant);
    return variant;
  }

  @override
  bool isInRollout(String key, int rolloutPercent) {
    if (rolloutPercent <= 0) {
      _track(key, false);
      return false;
    }
    if (rolloutPercent >= 100) {
      _track(key, true);
      return true;
    }
    final inside = _bucket(key) < rolloutPercent;
    _track('rollout:$key', inside);
    return inside;
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Singleton façade — point d'entrée unique pour l'app
// ──────────────────────────────────────────────────────────────────────────

class CpFeatureFlags implements CpFeatureFlagsInterface {
  CpFeatureFlags._();

  static final CpFeatureFlags _instance = CpFeatureFlags._();
  static CpFeatureFlags get I => _instance;

  CpFeatureFlagsInterface _impl = const _CpFeatureFlagsNoop();
  bool _bound = false;

  /// Status du binding (utile pour les tests / debug).
  bool get isBound => _bound;

  /// Init au démarrage. Appel sans args = mode dev sans overrides.
  ///
  /// Exemples :
  /// ```dart
  /// // Mode dev : tout désactivé par défaut
  /// CpFeatureFlags.I.bind();
  ///
  /// // Avec utilisateur + overrides locaux (utile en QA)
  /// CpFeatureFlags.I.bind(
  ///   userId: supabase.auth.currentUser?.id,
  ///   overrides: {
  ///     CpFlagKeys.newCorrectionScreen: true,
  ///     CpFlagKeys.validateButtonCopy: 'Soumettre',
  ///   },
  ///   onExposed: (flag, variant) => CpAnalytics.I.screenViewed(
  ///     'cp_experiment_exposed',
  ///     extra: {'flag': flag, 'variant': variant},
  ///   ),
  /// );
  /// ```
  void bind({
    String? userId,
    Map<String, Object?>? overrides,
    void Function(String flag, Object? variant)? onExposed,
  }) {
    _impl = _CpFeatureFlagsLocal(
      userId: userId,
      overrides: overrides ?? const {},
      onExposed: onExposed,
    );
    _bound = true;
  }

  /// Remplace l'implémentation par une autre (ex: SDK distant GrowthBook).
  /// L'instance fournie doit être idempotente et thread-safe.
  void bindImpl(CpFeatureFlagsInterface impl) {
    _impl = impl;
    _bound = true;
  }

  /// Réinitialise à no-op (utile en logout ou pour les tests).
  void reset() {
    _impl = const _CpFeatureFlagsNoop();
    _bound = false;
  }

  // ── Délégations ──────────────────────────────────────────────────────────

  @override
  bool isEnabled(String key, {bool defaultValue = false}) =>
      _impl.isEnabled(key, defaultValue: defaultValue);

  @override
  String getString(String key, {String defaultValue = ''}) =>
      _impl.getString(key, defaultValue: defaultValue);

  @override
  int getInt(String key, {int defaultValue = 0}) =>
      _impl.getInt(key, defaultValue: defaultValue);

  @override
  double getDouble(String key, {double defaultValue = 0.0}) =>
      _impl.getDouble(key, defaultValue: defaultValue);

  @override
  String? assignVariant(String experimentKey, List<String> variants) =>
      _impl.assignVariant(experimentKey, variants);

  @override
  bool isInRollout(String key, int rolloutPercent) =>
      _impl.isInRollout(key, rolloutPercent);
}

// ──────────────────────────────────────────────────────────────────────────
//  Helpers ergonomiques pour l'app Cas Pratique
//  Pré-câblage des expériences les plus courantes — évite de répéter les
//  listes de variants dans le code UI.
// ──────────────────────────────────────────────────────────────────────────

class CpExperiments {
  CpExperiments._();

  /// Copy du bouton Valider — A : "Valider" / B : "Soumettre" / C : "Terminer"
  static String validateButtonCopy() {
    return CpFeatureFlags.I.assignVariant(
          CpFlagKeys.validateButtonCopy,
          const ['Valider', 'Soumettre', 'Terminer'],
        ) ??
        'Valider';
  }

  /// Style du CTA principal — A : "blue" / B : "gold" / C : "gradient"
  static String validateButtonStyle() {
    return CpFeatureFlags.I.assignVariant(
          CpFlagKeys.validateButtonStyle,
          const ['blue', 'gold', 'gradient'],
        ) ??
        'blue';
  }

  /// Ordre des questions — A : "sequential" / B : "shuffled"
  static String questionOrder() {
    return CpFeatureFlags.I.assignVariant(
          CpFlagKeys.questionOrder,
          const ['sequential', 'shuffled'],
        ) ??
        'sequential';
  }

  /// Affichage des hints inline (helper bar de saisie).
  static bool inlineHintsEnabled() {
    return CpFeatureFlags.I.isEnabled(
      CpFlagKeys.inlineHints,
      defaultValue: false,
    );
  }
}
