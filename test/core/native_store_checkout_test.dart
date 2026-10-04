import 'package:copiqpolice/core/payments/payments_service.dart';
import 'package:copiqpolice/core/services/stripe_payment_service.dart';
import 'package:copiqpolice/core/services/subscription_plan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    test(
      'legacy Stripe checkout is blocked on $platform before backend access',
      () async {
        debugDefaultTargetPlatformOverride = platform;
        // Supabase is deliberately not initialized: neither entry point may
        // reach authentication, the checkout backend or the external browser.
        final result = await StripePaymentService.instance.startCheckout(
          CopiqPlan.month,
        );
        expect(result.ok, isFalse);
        expect(result.reason, 'native_store_required');
        expect(await CpPayments.I.startCheckout(priceId: 'unused'), isNull);
      },
    );
  }
}
