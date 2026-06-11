// lib/core/services/deep_links_service.dart
//
// Service de gestion des deep links et universal links.
//
// Schémas pris en charge :
//   - copiqpolice://...  (scheme custom)
//   - https://copiqpolice.app/...  (universal/applinks)
//
// Routes mappées :
//   copiqpolice://quiz/<topic>          -> /gpx/<topic>/quiz/<topic>
//   copiqpolice://module/<module>       -> route directe vers la page de cours
//   copiqpolice://payment-success       -> /abonnement (refresh subscription)
//   copiqpolice://abonnement            -> /abonnement
//   copiqpolice://compte                -> /user
//
// Setup natif requis :
//   ANDROID — AndroidManifest.xml :
//     <intent-filter android:autoVerify="true">
//       <action android:name="android.intent.action.VIEW"/>
//       <category android:name="android.intent.category.DEFAULT"/>
//       <category android:name="android.intent.category.BROWSABLE"/>
//       <data android:scheme="copiqpolice"/>
//     </intent-filter>
//     <intent-filter android:autoVerify="true">
//       <action android:name="android.intent.action.VIEW"/>
//       <category android:name="android.intent.category.DEFAULT"/>
//       <category android:name="android.intent.category.BROWSABLE"/>
//       <data android:scheme="https" android:host="copiqpolice.app"/>
//     </intent-filter>
//     <!-- CODE-071 Cas Pratique — app.copiq.fr -->
//     <intent-filter android:autoVerify="true">
//       <action android:name="android.intent.action.VIEW"/>
//       <category android:name="android.intent.category.DEFAULT"/>
//       <category android:name="android.intent.category.BROWSABLE"/>
//       <data android:scheme="https" android:host="app.copiq.fr"/>
//     </intent-filter>
//
//   IOS — Runner.entitlements :
//     <key>com.apple.developer.associated-domains</key>
//     <array>
//       <string>applinks:copiqpolice.app</string>
//       <!-- CODE-071 Cas Pratique -->
//       <string>applinks:app.copiq.fr</string>
//     </array>
//   IOS — Info.plist :
//     <key>CFBundleURLTypes</key>
//     <array>
//       <dict>
//         <key>CFBundleURLSchemes</key>
//         <array><string>copiqpolice</string></array>
//       </dict>
//     </array>
//
//   ASSETLINKS (Android) — https://app.copiq.fr/.well-known/assetlinks.json :
//     → docs/cas_pratique/DEEP_LINKS_NATIVE_CONFIG.md
//   APPLE-APP-SITE-ASSOCIATION (iOS) — https://app.copiq.fr/.well-known/apple-app-site-association :
//     → docs/cas_pratique/DEEP_LINKS_NATIVE_CONFIG.md

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:copiqpolice/core/cas_pratique/deep_links/cp_deep_links_handler.dart';
import 'package:flutter/widgets.dart';

class DeepLinksService {
  DeepLinksService._();
  static final DeepLinksService instance = DeepLinksService._();
  static DeepLinksService get I => instance;

  final AppLinks _appLinks = AppLinks();

  /// Navigator key partagé avec MaterialApp pour pouvoir naviguer en background.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription<Uri>? _sub;
  bool _initialized = false;

  /// À appeler dans main() APRÈS Supabase init et AVANT runApp(MyApp()).
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Lien initial (l'app a été ouverte via un lien).
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        // Délai pour laisser MaterialApp s'initialiser.
        Future.delayed(const Duration(milliseconds: 400), () {
          _handleUri(initialUri);
        });
      }
    } catch (e) {
      debugPrint('[DeepLinks] initialLink failed: $e');
    }

    // Stream pour les liens reçus pendant que l'app tourne.
    _sub = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (e) => debugPrint('[DeepLinks] stream error: $e'),
    );
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _initialized = false;
  }

  void _handleUri(Uri uri) {
    // CODE-071 — Cas Pratique links (app.copiq.fr/c/<slug>) ont priorité.
    if (CpDeepLinksHandler.I.handleUri(uri, navigatorKey.currentState)) return;

    final route = _routeForUri(uri);
    if (route == null) return;
    debugPrint('[DeepLinks] $uri -> $route');
    navigatorKey.currentState?.pushNamed(route);
  }

  /// Conversion d'un Uri en route Flutter.
  String? _routeForUri(Uri uri) {
    // copiqpolice://payment-success
    // copiqpolice://abonnement
    // copiqpolice://compte
    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();
    final segs = uri.pathSegments;

    if (scheme == 'copiqpolice') {
      switch (host) {
        case 'payment-success':
        case 'abonnement':
          return '/abonnement';
        case 'compte':
        case 'user':
          return '/user';
        case 'quiz':
          if (segs.isNotEmpty) {
            final topic = segs.first;
            return '/gpx/$topic/quiz/$topic';
          }
          return null;
        case 'module':
          if (segs.isNotEmpty) {
            return '/gpx/${segs.join('/')}';
          }
          return null;
        default:
          return null;
      }
    }

    // https://copiqpolice.app/* : on prend simplement le path.
    if ((scheme == 'https' || scheme == 'http') &&
        (host == 'copiqpolice.app' || host == 'www.copiqpolice.app')) {
      if (uri.path.isEmpty || uri.path == '/') return '/home-bootstrap';
      return uri.path;
    }

    return null;
  }
}
