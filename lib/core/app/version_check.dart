// ╔════════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Force Update / Version Check                                    ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-098             ║
// ║                                                                            ║
// ║  Au boot, vérifie que la version de l'app ≥ min_version retournée par     ║
// ║  l'edge function `app_minimum_version`. Si la version est trop vieille    ║
// ║  (ou si force_update = true côté serveur), affiche un écran bloquant      ║
// ║  "Mets à jour COP'IQ" avec lien vers le store.                           ║
// ║                                                                            ║
// ║  WIRING main.dart (3 lignes à ajouter — non modifié automatiquement) :   ║
// ║                                                                            ║
// ║    // 1. Import (en haut de main.dart) :                                   ║
// ║    import 'package:copiqpolice/core/app/version_check.dart';               ║
// ║                                                                            ║
// ║    // 2. Dans _bootstrap(), AVANT la logique warning/onboarding :          ║
// ║    final updateRequired = await AppVersionChecker.I.checkAndCache();       ║
// ║    if (updateRequired) {                                                    ║
// ║      setState(() => _route = _Route.forceUpdate);                          ║
// ║      return;                                                                ║
// ║    }                                                                        ║
// ║                                                                            ║
// ║    // 3. Dans _MyAppState.build(), ajouter au switch de home :             ║
// ║    _Route.forceUpdate => const ForceUpdateScreen(),                        ║
// ║                                                                            ║
// ║    // 4. Ajouter 'forceUpdate' à l'enum _Route dans main.dart :            ║
// ║    enum _Route { loading, warning, onboarding, home, forceUpdate }         ║
// ║                                                                            ║
// ║  Architecture :                                                             ║
// ║   • AppVersionChecker   — singleton, compare semver + cache SP 6h          ║
// ║   • AppVersionConfig     — modèle de réponse de l'edge function            ║
// ║   • ForceUpdateScreen    — UI bloquante palette COP'IQ dark/light          ║
// ║   • AppVersionGate       — widget wrapper alternatif (sans modif main.dart) ║
// ╚════════════════════════════════════════════════════════════════════════════╝

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modèle
// ─────────────────────────────────────────────────────────────────────────────

/// Réponse de l'edge function `app_minimum_version`.
class AppVersionConfig {
  const AppVersionConfig({
    required this.platform,
    required this.minVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.storeUrl,
    required this.messageFr,
    required this.checkedAt,
  });

  final String platform;
  final String minVersion;
  final String latestVersion;
  final bool forceUpdate;
  final String storeUrl;
  final String messageFr;
  final DateTime checkedAt;

  factory AppVersionConfig.fromJson(Map<String, dynamic> json) {
    return AppVersionConfig(
      platform: (json['platform'] as String?) ?? 'android',
      minVersion: (json['min_version'] as String?) ?? '1.0.0',
      latestVersion: (json['latest_version'] as String?) ?? '1.0.0',
      forceUpdate: (json['force_update'] as bool?) ?? false,
      storeUrl: (json['store_url'] as String?) ?? '',
      messageFr: (json['message_fr'] as String?) ??
          "Une nouvelle version de COP'IQ est disponible.",
      checkedAt: json['checked_at'] != null
          ? DateTime.tryParse(json['checked_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'min_version': minVersion,
        'latest_version': latestVersion,
        'force_update': forceUpdate,
        'store_url': storeUrl,
        'message_fr': messageFr,
        'checked_at': checkedAt.toIso8601String(),
      };

  /// Vrai si [currentVersion] < [minVersion] OU si [forceUpdate] est activé.
  bool requiresUpdate(String currentVersion) {
    if (forceUpdate) return true;
    return _compareSemver(currentVersion, minVersion) < 0;
  }

  /// Comparaison semver simple (X.Y.Z). Retourne -1, 0 ou 1.
  static int _compareSemver(String a, String b) {
    final av = _parseSemver(a);
    final bv = _parseSemver(b);
    for (int i = 0; i < 3; i++) {
      if (av[i] < bv[i]) return -1;
      if (av[i] > bv[i]) return 1;
    }
    return 0;
  }

  static List<int> _parseSemver(String v) {
    final parts = v.split('.')..length; // ignore trailing labels like -beta
    final nums = v
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .split('.')
        .take(3)
        .map((s) => int.tryParse(s) ?? 0)
        .toList();
    while (nums.length < 3) {
      nums.add(0);
    }
    return nums;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────

/// Singleton responsable de vérifier si l'app doit être mise à jour.
///
/// Usage au boot (dans _bootstrap) :
/// ```dart
/// final updateRequired = await AppVersionChecker.I.checkAndCache();
/// if (updateRequired) { ... }
/// ```
class AppVersionChecker {
  AppVersionChecker._();
  static final AppVersionChecker I = AppVersionChecker._();

  static const _cacheKey = 'cp_version_check_v1';
  static const _cacheTtlHours = 6;

  AppVersionConfig? _cachedConfig;

  /// Retourne `true` si une mise à jour est requise.
  ///
  /// Stratégie :
  ///  1. Si un cache SP valide (<6h) existe, l'utilise.
  ///  2. Sinon, appelle l'edge function.
  ///  3. En cas d'erreur réseau, retourne `false` (fail-open : ne pas bloquer
  ///     les users si le serveur est down).
  Future<bool> checkAndCache() async {
    if (kIsWeb) return false; // Pas de force-update sur web

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version; // ex: "1.2.0"

      AppVersionConfig? config = await _loadFromCache();

      if (config == null) {
        config = await _fetchFromNetwork();
        if (config != null) await _saveToCache(config);
      }

      if (config == null) return false; // réseau KO → fail-open

      _cachedConfig = config;
      return config.requiresUpdate(currentVersion);
    } catch (e) {
      debugPrint('[AppVersionChecker] error: $e');
      return false; // fail-open
    }
  }

  /// Retourne la config courante (null si jamais chargée).
  AppVersionConfig? get currentConfig => _cachedConfig;

  /// Force un re-fetch (utile pour les tests ou après un refresh manuel).
  Future<void> invalidate() async {
    _cachedConfig = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  // ── Privé ─────────────────────────────────────────────────────────────────

  Future<AppVersionConfig?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final config = AppVersionConfig.fromJson(map);
      final age = DateTime.now().difference(config.checkedAt);
      if (age.inHours >= _cacheTtlHours) return null; // expiré
      return config;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(AppVersionConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(config.toJson()));
    } catch (_) {}
  }

  Future<AppVersionConfig?> _fetchFromNetwork() async {
    try {
      final platform = !kIsWeb && Platform.isIOS ? 'ios' : 'android';
      // Appel via le client Supabase (gère l'URL de base et les headers apikey)
      final response = await Supabase.instance.client.functions.invoke(
        'app_minimum_version',
        method: HttpMethod.get,
        queryParameters: {'platform': platform},
      );
      if (response.data == null) return null;
      final map = response.data is Map
          ? response.data as Map<String, dynamic>
          : jsonDecode(response.data.toString()) as Map<String, dynamic>;
      return AppVersionConfig.fromJson(map);
    } catch (e) {
      debugPrint('[AppVersionChecker] network error: $e');
      return null;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Écran bloquant
// ─────────────────────────────────────────────────────────────────────────────

/// Écran bloquant affiché quand la version de l'app est trop ancienne.
///
/// Design : gradient COP'IQ dark/light, Montserrat, CTA bleu → store.
/// Pas de back button, pas de navigation — l'utilisateur DOIT mettre à jour.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    final config = AppVersionChecker.I.currentConfig;
    final message = config?.messageFr ??
        "Une nouvelle version de COP'IQ est requise pour continuer.";
    final storeUrl = config?.storeUrl ?? '';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor:
            isDark ? CpTokens.darkNavy : CpTokens.blueLight,
        body: _ForceUpdateBody(
          isDark: isDark,
          message: message,
          storeUrl: storeUrl,
        ),
      ),
    );
  }
}

class _ForceUpdateBody extends StatelessWidget {
  const _ForceUpdateBody({
    required this.isDark,
    required this.message,
    required this.storeUrl,
  });

  final bool isDark;
  final String message;
  final String storeUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  CpTokens.darkNavy,
                  const Color(0xFF001875),
                ]
              : [
                  const Color(0xFF1A55E6),
                  CpTokens.darkNavy,
                ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Icône ──────────────────────────────────────────────────
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.08),
                      blurRadius: 32,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.system_update_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // ── Titre ──────────────────────────────────────────────────
              Text(
                "Mise à jour requise",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // ── Message ────────────────────────────────────────────────
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              // ── CTA principal ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: storeUrl.isNotEmpty
                      ? () => _openStore(storeUrl)
                      : null,
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 20,
                  ),
                  label: Text(
                    "Mettre à jour COP'IQ",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: CpTokens.blueLight,
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Texte légal ────────────────────────────────────────────
              Text(
                "Cette mise à jour est nécessaire pour garantir\nla sécurité et le bon fonctionnement de l'app.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.55),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStore(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('[ForceUpdateScreen] cannot open store: $e');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget gate alternatif (sans modifier main.dart)
// ─────────────────────────────────────────────────────────────────────────────

/// Wrapper alternatif à utiliser si l'on ne veut pas modifier _bootstrap().
///
/// Usage :
/// ```dart
/// // Dans _MyAppState.build(), remplacer :
/// home: SubscriptionGate(child: const ModePickerScreen()),
/// // par :
/// home: AppVersionGate(child: SubscriptionGate(child: const ModePickerScreen())),
/// ```
///
/// ⚠️  Cette approche fait le check APRÈS le rendu initial — préférer
/// l'intégration dans _bootstrap() pour un écran bloquant dès le splash.
class AppVersionGate extends StatefulWidget {
  const AppVersionGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppVersionGate> createState() => _AppVersionGateState();
}

class _AppVersionGateState extends State<AppVersionGate> {
  bool _checking = true;
  bool _requiresUpdate = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final needsUpdate = await AppVersionChecker.I.checkAndCache();
    if (mounted) {
      setState(() {
        _requiresUpdate = needsUpdate;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      // Transparent pendant le check (quelques ms max si cache SP chaud)
      return const SizedBox.shrink();
    }
    if (_requiresUpdate) {
      return const ForceUpdateScreen();
    }
    return widget.child;
  }
}
