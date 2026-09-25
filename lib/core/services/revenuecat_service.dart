import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'subscription_plan.dart';

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

  bool get isPremium => state.value.isPremium;

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
    _initializeInternal().then(completer.complete).catchError((Object error) {
      completer.completeError(error);
    });
    return _initializing!;
  }

  Future<void> _initializeInternal() async {
    if (!isSupported) return;
    if (_apiKey.trim().isEmpty) {
      state.value = state.value.copyWith(error: 'missing_revenuecat_api_key');
      if (kDebugMode) {
        debugPrint(
          '[REVENUECAT] Clé absente. Utilise --dart-define='
          'REVENUECAT_${Platform.isAndroid ? 'ANDROID' : 'IOS'}_API_KEY=…',
        );
      }
      return;
    }

    state.value = state.value.copyWith(loading: true, clearError: true);
    try {
      if (kDebugMode) await Purchases.setLogLevel(LogLevel.debug);

      final alreadyConfigured = await Purchases.isConfigured;
      if (!alreadyConfigured) {
        final configuration = PurchasesConfiguration(_apiKey)
          ..appUserID = _supabase.auth.currentUser?.id
          ..diagnosticsEnabled = kDebugMode;
        await Purchases.configure(configuration);
      } else {
        await _identifyUser(_supabase.auth.currentUser?.id);
      }

      _customerInfoListener ??= _onCustomerInfoUpdated;
      Purchases.addCustomerInfoUpdateListener(_customerInfoListener!);

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

  Future<void> _identifyUser(String? userId) async {
    if (!isSupported || !(await Purchases.isConfigured)) return;
    try {
      final currentId = await Purchases.appUserID;
      if (userId == null) {
        if (!currentId.startsWith(r'$RCAnonymousID:')) {
          final info = await Purchases.logOut();
          _onCustomerInfoUpdated(info);
        }
        return;
      }
      if (currentId != userId) {
        final result = await Purchases.logIn(userId);
        _onCustomerInfoUpdated(result.customerInfo);
      }
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] identification: $error');
    }
  }

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
    try {
      _onCustomerInfoUpdated(await Purchases.getCustomerInfo());
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] droits: $error');
      state.value = state.value.copyWith(error: 'customer_info_unavailable');
    }
  }

  Future<StorePurchaseResult> purchase(CopiqPlan plan) async {
    if (_supabase.auth.currentUser == null) {
      return const StorePurchaseResult.failure('not_authenticated');
    }
    await initialize();
    if (!state.value.configured) {
      return const StorePurchaseResult.failure('store_not_configured');
    }
    if (state.value.packages[plan] == null) await refreshOfferings();
    final package = state.value.packages[plan];
    if (package == null) {
      return const StorePurchaseResult.failure('product_unavailable');
    }

    state.value = state.value.copyWith(loading: true, clearError: true);
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
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

  Future<StorePurchaseResult> restorePurchases() async {
    await initialize();
    if (!state.value.configured) {
      return const StorePurchaseResult.failure('store_not_configured');
    }
    state.value = state.value.copyWith(loading: true, clearError: true);
    try {
      final info = await Purchases.restorePurchases();
      _onCustomerInfoUpdated(info);
      state.value = state.value.copyWith(loading: false);
      return info.entitlements.active[kRevenueCatEntitlementId]?.isActive ==
              true
          ? const StorePurchaseResult.success()
          : const StorePurchaseResult.failure('nothing_to_restore');
    } catch (error) {
      if (kDebugMode) debugPrint('[REVENUECAT] restauration: $error');
      state.value = state.value.copyWith(loading: false);
      return const StorePurchaseResult.failure('restore_failed');
    }
  }

  Future<bool> openSubscriptionManagement() async {
    var url = state.value.managementUrl;
    if (url == null || url.isEmpty) {
      await refreshCustomerInfo();
      url = state.value.managementUrl;
    }
    if (url == null || url.isEmpty) return false;
    return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
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
