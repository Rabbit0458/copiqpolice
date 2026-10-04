import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'subscription_service.dart';
import 'ad_policy.dart';

/// Identifiants AdMob COP'IQ.
///
/// Les builds debug utilisent toujours les identifiants de test officiels de
/// Google. Les builds release utilisent les blocs d'annonces créés dans le
/// compte AdMob COP'IQ.
abstract final class AdIds {
  static const _testInterstitialAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';
  static const _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const _testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';

  static const _liveInterstitialAndroid =
      'ca-app-pub-5486022144325892/9625359483';
  static const _liveInterstitialIos = 'ca-app-pub-5486022144325892/8648204215';
  static const _liveRewardedAndroid = 'ca-app-pub-5486022144325892/3779020910';
  static const _liveRewardedIos = 'ca-app-pub-5486022144325892/5012211534';

  static String interstitial(TargetPlatform platform) {
    if (kDebugMode) {
      return platform == TargetPlatform.android
          ? _testInterstitialAndroid
          : _testInterstitialIos;
    }
    return platform == TargetPlatform.android
        ? _liveInterstitialAndroid
        : _liveInterstitialIos;
  }

  static String rewarded(TargetPlatform platform) {
    if (kDebugMode) {
      return platform == TargetPlatform.android
          ? _testRewardedAndroid
          : _testRewardedIos;
    }
    return platform == TargetPlatform.android
        ? _liveRewardedAndroid
        : _liveRewardedIos;
  }
}

class AdService {
  AdService._();

  static final AdService instance = AdService._();

  AdPolicy _policy = const AdPolicy();
  bool _showing = false;
  static const _lastInterstitialKey = 'admob_last_interstitial_at_v1';

  bool _initialized = false;
  bool _canRequestAds = false;
  bool _interstitialLoading = false;
  bool _rewardedLoading = false;
  DateTime? _lastInterstitialAt;
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  bool get _supportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool get _hasPremium => SubscriptionService.instance.state.value.isPremium;

  bool get _eligible =>
      !_hasPremium &&
      SubscriptionService.instance.state.value.lastRefreshedAt != null &&
      SubscriptionService.instance.state.value.lastError == null &&
      _policy.activeAt(DateTime.now());

  Future<void> _refreshPolicy() async {
    try {
      final data = await Supabase.instance.client
          .from('app_runtime_config')
          .select('ads_enabled,ads_interval_minutes,ads_starts_at,ads_ends_at')
          .eq('id', 1)
          .single()
          .timeout(const Duration(seconds: 4));
      _policy = AdPolicy.fromJson(data);
    } catch (_) {
      _policy = const AdPolicy(); // No ads when configuration is unavailable.
    }
    if (!_eligible) disposeCachedAds();
  }

  Future<void> init() async {
    if (_initialized || !_supportedPlatform) return;

    SubscriptionService.instance.registerRewardedUnlockHandler(
      showRewardedAndGrant,
    );
    await _refreshPolicy();

    final preferences = await SharedPreferences.getInstance();
    final lastShownMillis = preferences.getInt(_lastInterstitialKey);
    if (lastShownMillis != null) {
      _lastInterstitialAt = DateTime.fromMillisecondsSinceEpoch(
        lastShownMillis,
      );
    }

    await _requestConsent();
    if (!_canRequestAds) return;

    await MobileAds.instance.initialize();
    _initialized = true;
    _preloadInterstitial();
    _preloadRewarded();
  }

  Future<void> _requestConsent() async {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => completer.complete(),
      (error) {
        debugPrint('[ADS] Consentement indisponible: ${error.message}');
        completer.complete();
      },
    );
    await completer.future;

    final formCompleter = Completer<void>();
    ConsentForm.loadAndShowConsentFormIfRequired((error) {
      if (error != null) {
        debugPrint('[ADS] Formulaire de consentement: ${error.message}');
      }
      formCompleter.complete();
    });
    await formCompleter.future;
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
  }

  Future<void> showPrivacyOptions() async {
    if (!_supportedPlatform) return;
    final completer = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) {
        debugPrint('[ADS] Options de confidentialité: ${error.message}');
      }
      completer.complete();
    });
    await completer.future;
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
    if (!_canRequestAds) disposeCachedAds();
  }

  bool _cooldownElapsed() {
    final last = _lastInterstitialAt;
    return _policy.canShowInterstitial(DateTime.now(), last);
  }

  Future<void> _rememberInterstitial() async {
    _lastInterstitialAt = DateTime.now();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(
      _lastInterstitialKey,
      _lastInterstitialAt!.millisecondsSinceEpoch,
    );
  }

  void _preloadInterstitial() {
    if (!_initialized || !_canRequestAds || !_eligible) return;
    if (_interstitial != null || _interstitialLoading) return;
    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: AdIds.interstitial(defaultTargetPlatform),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialLoading = false;
          _interstitial = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialLoading = false;
          debugPrint('[ADS] Interstitielle non chargée: $error');
        },
      ),
    );
  }

  void _preloadRewarded() {
    if (!_initialized || !_canRequestAds || !_eligible) return;
    if (_rewarded != null || _rewardedLoading) return;
    _rewardedLoading = true;
    RewardedAd.load(
      adUnitId: AdIds.rewarded(defaultTargetPlatform),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedLoading = false;
          _rewarded = ad;
        },
        onAdFailedToLoad: (error) {
          _rewardedLoading = false;
          debugPrint('[ADS] Récompense non chargée: $error');
        },
      ),
    );
  }

  /// À appeler uniquement à une rupture naturelle, après l'écran de résultat.
  Future<void> maybeShowInterstitial() async {
    if (_showing || !_supportedPlatform) return;
    _showing = true;
    try {
      await _refreshPolicy();
      if (!_eligible) return;
      await _showInterstitial();
    } finally {
      _showing = false;
    }
  }

  Future<void> _showInterstitial() async {
    if (!_supportedPlatform || _hasPremium || !_cooldownElapsed()) return;
    if (!_initialized) await init();
    if (!_initialized || !_canRequestAds || _hasPremium) return;

    _preloadInterstitial();
    final deadline = DateTime.now().add(const Duration(seconds: 8));
    while (_interstitial == null && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    final ad = _interstitial;
    if (ad == null || !_eligible || !_canRequestAds || !_cooldownElapsed())
      return;
    _interstitial = null;
    final dismissed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        unawaited(_rememberInterstitial());
      },
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        if (!dismissed.isCompleted) dismissed.complete();
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        shownAd.dispose();
        if (!dismissed.isCompleted) dismissed.complete();
      },
    );
    await ad.show();
    await dismissed.future;
    _preloadInterstitial();
  }

  /// Affiche volontairement une annonce et crédite une utilisation gratuite
  /// côté serveur uniquement après réception de la récompense AdMob.
  Future<bool> showRewardedAndGrant() async {
    if (_showing || !_supportedPlatform) return false;
    _showing = true;
    try {
      await _refreshPolicy();
      if (!_eligible) return false;
      return await _showRewardedAndGrant();
    } finally {
      _showing = false;
    }
  }

  Future<bool> _showRewardedAndGrant() async {
    if (!_supportedPlatform || _hasPremium) return false;
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;
    if (!_initialized) await init();
    if (!_initialized || !_canRequestAds || _hasPremium) return false;

    _preloadRewarded();
    final deadline = DateTime.now().add(const Duration(seconds: 10));
    while (_rewarded == null && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    final ad = _rewarded;
    if (ad == null ||
        !_eligible ||
        !_canRequestAds ||
        Supabase.instance.client.auth.currentUser?.id != user.id)
      return false;
    _rewarded = null;
    var earnedReward = false;
    final dismissed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        if (!dismissed.isCompleted) dismissed.complete();
      },
      onAdFailedToShowFullScreenContent: (shownAd, error) {
        shownAd.dispose();
        if (!dismissed.isCompleted) dismissed.complete();
      },
    );
    ad.show(onUserEarnedReward: (_, __) => earnedReward = true);
    await dismissed.future;
    _preloadRewarded();
    if (!earnedReward ||
        Supabase.instance.client.auth.currentUser?.id != user.id)
      return false;

    final nonce = '${user.id}-${DateTime.now().microsecondsSinceEpoch}';
    final response = await Supabase.instance.client.rpc(
      'grant_rewarded_request',
      params: {'p_nonce': nonce},
    );
    final granted = response is Map && response['allowed'] == true;
    if (granted) {
      await SubscriptionService.instance.refresh(force: true, withQuota: true);
    }
    return granted;
  }

  void disposeCachedAds() {
    _interstitial?.dispose();
    _rewarded?.dispose();
    _interstitial = null;
    _rewarded = null;
  }
}
