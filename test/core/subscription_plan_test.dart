import 'package:copiqpolice/core/services/subscription_plan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('COP’IQ Premium plans', () {
    test('only monthly and annual plans are exposed', () {
      expect(CopiqPlan.values, [CopiqPlan.month, CopiqPlan.year]);
    });

    test('Google Play product identifiers stay stable', () {
      expect(CopiqPlan.month.androidProductId, 'copiq_premium_monthly');
      expect(CopiqPlan.year.androidProductId, 'copiq_premium_yearly');
    });

    test('RevenueCat standard packages are mapped', () {
      expect(CopiqPlan.month.revenueCatPackageId, r'$rc_monthly');
      expect(CopiqPlan.year.revenueCatPackageId, r'$rc_annual');
    });

    test('annual fallback matches the validated V6 price', () {
      expect(CopiqPlan.year.fallbackPriceLabel, '79,99 € / an');
    });
  });
}
