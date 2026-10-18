import 'package:flutter_test/flutter_test.dart';
import 'package:copiqpolice/core/services/subscription_plan.dart';

void main() {
  test('iOS USD uses French reference amounts, not a symbol replacement', () {
    expect(
      CopiqPlan.month.displayPrice(
        storePrice: r'7.99 $US',
        currencyCode: 'USD',
        isIOS: true,
      ),
      '8,99 \u20ac / mois',
    );
    expect(
      CopiqPlan.year.displayPrice(
        storePrice: r'79.99 $US',
        currencyCode: 'USD',
        isIOS: true,
      ),
      '79,99 \u20ac / an',
    );
  });

  test('live EUR prices take precedence over reference prices', () {
    expect(
      CopiqPlan.month.displayPrice(
        storePrice: '9,99 \u20ac',
        currencyCode: 'EUR',
        isIOS: true,
      ),
      '9,99 \u20ac / mois',
    );
  });

  test('Android prices remain localized by the store', () {
    expect(
      CopiqPlan.month.displayPrice(
        storePrice: r'$7.99',
        currencyCode: 'USD',
        isIOS: false,
      ),
      r'$7.99 / mois',
    );
  });

  test('missing offers do not display an available price', () {
    for (final plan in CopiqPlan.values) {
      expect(
        plan.displayPrice(storePrice: null, currencyCode: null, isIOS: true),
        'Prix indisponible',
      );
      expect(
        plan.displayPrice(storePrice: ' ', currencyCode: 'USD', isIOS: true),
        'Prix indisponible',
      );
    }
  });
}
