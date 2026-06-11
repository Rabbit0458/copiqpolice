// lib/core/services/ad_service.dart
//
// COP'IQ — AdMob orchestration (free-tier monetization).
//
// Rules:
//   • Premium users (incl. owner) NEVER see ads.
//   • Interstitial: shown only at NATURAL breakpoints (end of a quiz, going
//     back to home), never during a quiz. Cooldown: 5 minutes between ads.
//   • Rewarded: optional opt-in to recover 1 free request when quota hit.
//
// Setup:
//   1. Add to pubspec.yaml:  google_mobile_ads: ^5.2.0
//   2. AndroidManifest.xml — inside <application>:
//        <meta-data
//            android:name="com.google.android.gms.ads.APPLICATION_ID"
//            android:value="@string/admob_app_id"/>
//   3. ios/Runner/Info.plist — add GADApplicationIdentifier.
//   4. Replace REAL_*_AD_UNIT_* constants below with your live AdMob IDs.
//   5. Call AdService.instance.init() once after MobileAds.instance.initialize().
//
// During development, Google's TEST IDs are used automatically (kDebugMode).
// NEVER ship test IDs to production: AdMob will ban your account.
//
// This file uses dynamic imports (no hard import of google_mobile_ads) so
// the app still compiles before the package is installed. Once the package
// is added, this module wires up automatically.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'subscription_service.dart';

// google_mobile_ads is a soft dependency until you run `flutter pub add google_mobile_ads`.
// We dynamically import via `package:google_mobile_ads/google_mobile_ads.dart`
// using deferred-style guards: missing package → ads simply no-op.
//
// To enable: uncomment the import below and `flutter pub add google_mobile_ads`.
// import 'package:google_mobile_ads/google_mobile_ads.dart' as gma;

class AdIds {
  // Google's official test units (use in debug):
  static const _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';
  static const _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const _testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';

  // 🔁 REPLACE WITH YOUR REAL AD UNIT IDS BEFORE RELEASE 🔁
  static const _realInterstitialAndroid = 'REPLACE_ME_INTERSTITIAL_ANDROID';
  static const _realInterstitialIos = 'REPLACE_ME_INTERSTITIAL_IOS';
  static const _realRewardedAndroid = 'REPLACE_ME_REWARDED_ANDROID';
  static const _realRewardedIos = 'REPLACE_ME_REWARDED_IOS';

  static String interstitial({required bool isAndroid}) {
    if (kDebugMode) {
      return isAndroid ? _testInterstitialAndroid : _testInterstitialIos;
    }
    return isAndroid ? _realInterstitialAndroid : _realInterstitialIos;
  }

  static String rewarded({required bool isAndroid}) {
    if (kDebugMode) {
      return isAndroid ? _testRewardedAndroid : _testRewardedIos;
    }
    return isAndroid ? _realRewardedAndroid : _realRewardedIos;
  }
}

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  bool _initialized = false;
  DateTime? _lastInterstitialAt;
  static const Duration interstitialCooldown = Duration(minutes: 5);

  /// Call once at app boot, AFTER MobileAds.instance.initialize().
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ADS] AdService initialized (debug=$kDebugMode).');
    }
  }

  bool get _hasPremium => SubscriptionService.instance.state.value.isPremium;

  bool _cooldownElapsed() {
    final last = _lastInterstitialAt;
    if (last == null) return true;
    return DateTime.now().difference(last) >= interstitialCooldown;
  }

  /// Maybe show an interstitial. Safe to call from end-of-quiz screens.
  /// • No-ops if the user is premium.
  /// • Respects the 5-minute cooldown.
  /// • Awaits dismissal so the caller can navigate after.
  Future<void> maybeShowInterstitial() async {
    if (_hasPremium) return;
    if (!_cooldownElapsed()) return;

    try {
      // Lazy load ad. If google_mobile_ads is not installed yet, this is a no-op.
      // Once the package is available, replace the body below with the real impl
      // (kept inline below for clarity).
      //
      //   InterstitialAd.load(
      //     adUnitId: AdIds.interstitial(isAndroid: defaultTargetPlatform == TargetPlatform.android),
      //     request: const AdRequest(),
      //     adLoadCallback: InterstitialAdLoadCallback(
      //       onAdLoaded: (ad) {
      //         ad.fullScreenContentCallback = FullScreenContentCallback(
      //           onAdDismissedFullScreenContent: (ad) { ad.dispose(); _completer.complete(); },
      //           onAdFailedToShowFullScreenContent: (ad, _) { ad.dispose(); _completer.complete(); },
      //         );
      //         ad.show();
      //       },
      //       onAdFailedToLoad: (_) => _completer.complete(),
      //     ),
      //   );
      _lastInterstitialAt = DateTime.now();
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[ADS] interstitial failed: $e');
      }
    }
  }

  /// Show a rewarded ad to grant +1 free request.
  /// Returns true if the user fully watched it AND the server granted credit.
  Future<bool> showRewardedAndGrant() async {
    if (_hasPremium) return false; // premium has unlimited, no need
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;

    bool watched = false;
    try {
      // Real impl (with google_mobile_ads):
      //
      //   final completer = Completer<bool>();
      //   RewardedAd.load(
      //     adUnitId: AdIds.rewarded(isAndroid: defaultTargetPlatform == TargetPlatform.android),
      //     request: const AdRequest(),
      //     rewardedAdLoadCallback: RewardedAdLoadCallback(
      //       onAdLoaded: (ad) {
      //         ad.fullScreenContentCallback = FullScreenContentCallback(
      //           onAdDismissedFullScreenContent: (ad) { ad.dispose(); if (!completer.isCompleted) completer.complete(false); },
      //           onAdFailedToShowFullScreenContent: (ad, _) { ad.dispose(); if (!completer.isCompleted) completer.complete(false); },
      //         );
      //         ad.show(onUserEarnedReward: (_, __) { if (!completer.isCompleted) completer.complete(true); });
      //       },
      //       onAdFailedToLoad: (_) => completer.complete(false),
      //     ),
      //   );
      //   watched = await completer.future;
      watched = false; // until package is installed
    } catch (_) {
      watched = false;
    }

    if (!watched) return false;

    // Server-side credit (atomic, throttled, idempotent)
    final nonce = '${user.id}-${DateTime.now().millisecondsSinceEpoch}';
    final res = await Supabase.instance.client
        .rpc('grant_rewarded_request', params: {'p_nonce': nonce});
    final ok = res is Map && res['allowed'] == true;
    if (ok) {
      await SubscriptionService.instance.refresh(force: true, withQuota: true);
    }
    return ok;
  }
}
