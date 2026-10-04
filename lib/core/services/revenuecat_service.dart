import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'subscription_plan.dart';
import 'store_operation_queue.dart';
import 'revenuecat_configuration.dart';

const String kRevenueCatEntitlementId = 'premium';

const String kStoreBillingLine =
    'Paiement sécurisé et abonnement géré par votre boutique d’applications.';

class RevenueCatSnapshot {
  final bool configured;
  final bool loading;
  final bool isPremium;
  final String? error;
  final String? managementUrl;
  final String? productIdentifier;
  final String? store;
  final DateTime? expiresAt;
  final bool willRenew;
  final Map<CopiqPlan, Package> packages;

  const RevenueCatSnapshot({
    this.configured = false,
    this.loading = false,
    this.isPremium = false,
    this.error,
    this.managementUrl,
    this.productIdentifier,
    this.store,
    this.expiresAt,
    this.willRenew = false,
    this.packages = const {},
  });

  RevenueCatSnapshot copyWith({
    bool? configured,
    bool? loading,
    bool? isPremium,
    String? error,
    bool clearError = false,
    String? managementUrl,
    bool clearManagementUrl = false,
    String? productIdentifier,
    bool clearProductIdentifier = false,
    String? store,
    bool clearStore = false,
    DateTime? expiresAt,
    bool clearExpiresAt = false,
    bool? willRenew,
    Map<CopiqPlan, Package>? packages,
  }) {
    return RevenueCatSnapshot(
      configured: configured ?? this.configured,
      loading: loading ?? this.loading,
      isPremium: isPremium ?? this.isPremium,
      error: clearError ? null : (error ?? this.error),
      managementUrl: clearManagementUrl
          ? null
          : (managementUrl ?? this.managementUrl),
      productIdentifier: clearProductIdentifier
          ? null
          : (productIdentifier ?? this.productIdentifier),
      store: clearStore ? null : (store ?? this.store),
      expiresAt: clearExpiresAt ? null : (expiresAt ?? this.expiresAt),
      willRenew: willRenew ?? this.willRenew,
      packages: packages ?? this.packages,
    );
  }
}

class StorePurchaseResult {
  final bool ok;
  final bool cancelled;
  final String? reason;

  const StorePurchaseResult._({
    required this.ok,
    required this.cancelled,
    this.reason,
  });

  const StorePurchaseResult.success() : this._(ok: true, cancelled: false);

  const StorePurchaseResult.cancelled()
    : this._(ok: false, cancelled: true, reason: 'cancelled');

  const StorePurchaseResult.failure(String reason)
    : this._(ok: false, cancelled: false, reason: reason);
}

/// Source native des achats Premium. Le même AppUserID Supabase est utilisé
/// sur Android et iOS afin que RevenueCat puisse unifier les droits.
class RevenueCatService {
  RevenueCatService._();
  static final RevenueCatService instance = RevenueCatService._();

  static const String _androidApiKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_API_KEY',
  );
  static const String _iosApiKey = String.fromEnvironment(
    'REVENUECAT_IOS_API_KEY',
  );

  final ValueNotifier<RevenueCatSnapshot> state =
      ValueNotifier<RevenueCatSnapshot>(const RevenueCatSnapshot());

  StreamSubscription<AuthState>? _authSubscription;
  CustomerInfoUpdateListener? _customerInfoListener;
  Future<void>? _initializing;

  SupabaseClient get _supabase => Supabase.instance.client;

  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  String get _apiKey => Platform.isAndroid ? _androidApiKey : _iosApiKey;

  String? _identifiedUserId;
  Future<bool> _identityQueue = Future.value(false);
  final _sdkQueue = StoreOperationQueue();
  bool _storeOperationInFlight = false;

  Future<StorePurchaseResult> _runStoreOperation(
    Future<StorePurchaseResult> Function() operation,
  ) async {
    if (_storeOperationInFlight) {
      return const StorePurchaseResult.failure('operation_in_progress');
    }
    _storeOperationInFlight = true;
    try {
      return await operation();
    } finally {
      _storeOperationInFlight = false;
    }
  }

  // Identity changes and store transactions must never overlap in the SDK.
  Future<T> _withSdkLock<T>(Future<T> Function() operation) {
    return _sdkQueue.run(operation);
  }

  bool get isPremium =>
      _identifiedUserId != null &&
      _identifiedUserId == _supabase.auth.currentUser?.id &&
      state.value.isPremium;

  String priceLabel(CopiqPlan plan) {
    final price = state.value.packages[plan]?.storeProduct.priceString;
    if (price == null || price.trim().isEmpty) return plan.fallbackPriceLabel;
    return switch (plan) {
      CopiqPlan.month => '$price / mois',
      CopiqPlan.year => '$price / an',
    };
  }

  Future<void> initialize() {
    if (_initializing != null) return _initializing!;
    final completer = Completer<void>();
    _initializing = completer.future;
    _initializeInternal()
        .then(completer.complete)
        .catchError((Object error) {
          completer.completeError(error);
        })
        .whenComplete(() => _initializing = null);
    return _initializing!;
  }

  Future<void> _initializeInternal() async {
    if (!isSupported) return;
    state.value = state.value.copyWith(loading: true, clearError: true);
    try {
      final apiKey = await loadRevenueCatKey(
        android: Platform.isAndroid,
        override: _apiKey,
      );
      if (kDebugMode) await Purchases.setLogLevel(LogLevel.debug);

      final alreadyConfigured = await Purchases.isConfigured;
      if (!alreadyConfigured) {
        final userId = _supabase.auth.currentUser?.id;
        final configuration = PurchasesConfiguration(apiKey)
          ..appUserID = userId
          ..diagnosticsEnabled = kDebugMode;
        await Purchases.configure(configuration);
        _identifiedUserId = userId;
      } else {
        await _identifyUser(_supabase.auth.currentUser?.id);
      }

      if (_customerInfoListener == null) {
        _customerInfoListener = (_) => unawaited(refreshCustomerInfo());
        Purchases.addCustomerInfoUpdateListener(_customerInfoListener!);
      }

      _authSubscription ??= _supabase.auth.onAuthStateChange.listen((event) {
        final userId = event.session?.user.id ?? _supabase.auth.currentUser?.id;
        switch (event.event) {
          case AuthChangeEvent.signedIn:
          case AuthChangeEvent.userUpdated:
          case AuthChangeEvent.tokenRefreshed:
            unawaited(_identifyUser(userId));
            break;
          case AuthChangeEvent.signedOut:
            unawaited(_identifyUser(null));
            break;
          default:
            break;
        }
      });

      await Future.wait([refreshCustomerInfo(), refreshOfferings()]);
      state.value = state.value.copyWith(
        configured: true,
        loading: false,
        clearError: true,
      );
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[REVENUECAT] initialisation impossible: $error\n$stackTrace',
        );
      }
      state.value = state.value.copyWith(
        loading: false,
        error: 'configuration_failed',
      );
    }
  }

  Future<bool> _identifyUser(String? userId) {
    // Clear rights immediately; serialize SDK identity changes across auth events.
    _identifiedUserId = null;
    state.value = state.value.copyWith(
      isPremium: false,
      clearManagementUrl: true,
      clearProductIdentifier: true,
      clearStore: true,
      clearExpiresAt: true,
      willRenew: false,
    );
    _identityQueue = _identityQueue.then((_) => _identifyUserInternal(userId));
    return _identityQueue;
  }

  Future<bool> _identifyUserInternal(String? userId) => _withSdkLock(() async {
    if (!isSupported || !(await Purchases.isConfigured)) return false;
    if (userId != _supabase.auth.currentUser?.id) return false;
    try {
      final currentId = await Purchases.appUserID;
      if (userId == null) {
        if (!currentId.startsWith(r'$RCAnonymousID:')) {
          await Purchases.logOut();
        }
        return false;
      }
      CustomerInfo info;
      if (currentId != userId) {
        final result = await Purchases.logIn(userId);
        info = result.customerInfo;
      } else {
        info = await Purchases.getCustomerInfo();
      }
      if (userId != _supabase.auth.currentUser?.id) return false;
      _identifiedUserId = userId;
      _onCustomerInfoUpdated(info);
      return true;
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] identification: $error');
      return false;
    }
  });

  Future<void> refreshOfferings() async {
    if (!isSupported || !(await Purchases.isConfigured)) return;
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      final packages = <CopiqPlan, Package>{};
      if (current != null) {
        for (final package in current.availablePackages) {
          if (package.identifier == CopiqPlan.month.revenueCatPackageId ||
              package.packageType == PackageType.monthly) {
            packages[CopiqPlan.month] = package;
          } else if (package.identifier == CopiqPlan.year.revenueCatPackageId ||
              package.packageType == PackageType.annual) {
            packages[CopiqPlan.year] = package;
          }
        }
      }
      state.value = state.value.copyWith(
        packages: Map.unmodifiable(packages),
        clearError: true,
      );
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] offres: $error');
      state.value = state.value.copyWith(error: 'offerings_unavailable');
    }
  }

  Future<void> refreshCustomerInfo() async {
    if (!isSupported || !(await Purchases.isConfigured)) return;
    final userId = _identifiedUserId;
    if (userId == null || userId != _supabase.auth.currentUser?.id) return;
    try {
      final info = await Purchases.getCustomerInfo();
      if (userId != _identifiedUserId ||
          userId != _supabase.auth.currentUser?.id)
        return;
      _onCustomerInfoUpdated(info);
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] droits: $error');
      state.value = state.value.copyWith(error: 'customer_info_unavailable');
    }
  }

  Future<StorePurchaseResult> purchase(CopiqPlan plan) =>
      _runStoreOperation(() => _purchase(plan));

  Future<StorePurchaseResult> _purchase(CopiqPlan plan) async {
    final purchaseUserId = _supabase.auth.currentUser?.id;
    if (_supabase.auth.currentUser == null) {
      return const StorePurchaseResult.failure('not_authenticated');
    }
    await initialize();
    if (!await _identifyUser(_supabase.auth.currentUser?.id)) {
      return const StorePurchaseResult.failure('identity_not_verified');
    }
    if (!state.value.configured) {
      return const StorePurchaseResult.failure('store_not_configured');
    }
    if (state.value.packages[plan] == null) await refreshOfferings();
    final package = state.value.packages[plan];
    if (package == null) {
      return const StorePurchaseResult.failure('product_unavailable');
    }
    if (purchaseUserId != _supabase.auth.currentUser?.id ||
        purchaseUserId != _identifiedUserId) {
      return const StorePurchaseResult.failure('account_changed');
    }

    state.value = state.value.copyWith(loading: true, clearError: true);
    try {
      return await _withSdkLock(() async {
        if (purchaseUserId != _supabase.auth.currentUser?.id ||
            purchaseUserId != _identifiedUserId) {
          state.value = state.value.copyWith(loading: false);
          return const StorePurchaseResult.failure('account_changed');
        }
        final result = await Purchases.purchase(
          PurchaseParams.package(package),
        );
        if (purchaseUserId != _supabase.auth.currentUser?.id ||
            purchaseUserId != _identifiedUserId) {
          state.value = state.value.copyWith(loading: false);
          return const StorePurchaseResult.failure('account_changed');
        }
        _onCustomerInfoUpdated(result.customerInfo);
        final active =
            result
                .customerInfo
                .entitlements
                .active[kRevenueCatEntitlementId]
                ?.isActive ==
            true;
        state.value = state.value.copyWith(loading: false);
        return active
            ? const StorePurchaseResult.success()
            : const StorePurchaseResult.failure('entitlement_not_active');
      });
    } on PlatformException catch (error) {
      final code = PurchasesErrorHelper.getErrorCode(error);
      state.value = state.value.copyWith(loading: false);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return const StorePurchaseResult.cancelled();
      }
      return StorePurchaseResult.failure(code.name);
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] achat: $error');
      state.value = state.value.copyWith(loading: false);
      return const StorePurchaseResult.failure('purchase_failed');
    }
  }

  Future<StorePurchaseResult> restorePurchases() =>
      _runStoreOperation(_restorePurchases);

  Future<StorePurchaseResult> _restorePurchases() async {
    final restoreUserId = _supabase.auth.currentUser?.id;
    if (_supabase.auth.currentUser == null) {
      return const StorePurchaseResult.failure('not_authenticated');
    }
    await initialize();
    if (!await _identifyUser(_supabase.auth.currentUser?.id)) {
      return const StorePurchaseResult.failure('identity_not_verified');
    }
    if (!state.value.configured) {
      return const StorePurchaseResult.failure('store_not_configured');
    }
    if (restoreUserId != _supabase.auth.currentUser?.id ||
        restoreUserId != _identifiedUserId) {
      return const StorePurchaseResult.failure('account_changed');
    }
    state.value = state.value.copyWith(loading: true, clearError: true);
    try {
      return await _withSdkLock(() async {
        if (restoreUserId != _supabase.auth.currentUser?.id ||
            restoreUserId != _identifiedUserId) {
          state.value = state.value.copyWith(loading: false);
          return const StorePurchaseResult.failure('account_changed');
        }
        final info = await Purchases.restorePurchases();
        if (restoreUserId != _supabase.auth.currentUser?.id ||
            restoreUserId != _identifiedUserId) {
          state.value = state.value.copyWith(loading: false);
          return const StorePurchaseResult.failure('account_changed');
        }
        _onCustomerInfoUpdated(info);
        state.value = state.value.copyWith(loading: false);
        return info.entitlements.active[kRevenueCatEntitlementId]?.isActive ==
                true
            ? const StorePurchaseResult.success()
            : const StorePurchaseResult.failure('nothing_to_restore');
      });
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] restauration: $error');
      state.value = state.value.copyWith(loading: false);
      return const StorePurchaseResult.failure('restore_failed');
    }
  }

  Future<bool> openSubscriptionManagement() async {
    if (_identifiedUserId == null ||
        _identifiedUserId != _supabase.auth.currentUser?.id)
      return false;
    var url = state.value.managementUrl;
    if (url == null || url.isEmpty) {
      await refreshCustomerInfo();
      url = state.value.managementUrl;
    }
    if (url == null || url.isEmpty) return false;
    return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
    if (_identifiedUserId == null ||
        _identifiedUserId != _supabase.auth.currentUser?.id)
      return;
    final entitlement = info.entitlements.all[kRevenueCatEntitlementId];
    final active = entitlement?.isActive == true;
    state.value = state.value.copyWith(
      configured: true,
      isPremium: active,
      managementUrl: info.managementURL,
      clearManagementUrl: info.managementURL == null,
      productIdentifier: entitlement?.productIdentifier,
      clearProductIdentifier: entitlement == null,
      store: entitlement?.store.name,
      clearStore: entitlement == null,
      expiresAt: entitlement?.expirationDate == null
          ? null
          : DateTime.tryParse(entitlement!.expirationDate!),
      clearExpiresAt: entitlement?.expirationDate == null,
      willRenew: entitlement?.willRenew == true,
      clearError: true,
    );
  }

  Future<void> dispose() async {
    await _authSubscription?.cancel();
    _authSubscription = null;
    final listener = _customerInfoListener;
    if (listener != null && isSupported && await Purchases.isConfigured) {
      Purchases.removeCustomerInfoUpdateListener(listener);
    }
    _customerInfoListener = null;
  }
}
