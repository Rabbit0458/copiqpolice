import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/services/ad_policy.dart';

void main() {
  final start = DateTime.utc(2026, 10, 2, 10);
  Map<String, dynamic> config() => {
    'ads_enabled': true,
    'ads_interval_minutes': 20,
    'ads_starts_at': '2026-10-02T12:00:00+02:00',
    'ads_ends_at': '2026-10-02T13:00:00+02:00',
  };
  test(
    'scheduled ads start inclusively and end exclusively across timezones',
    () {
      final policy = AdPolicy.fromJson(config());
      expect(
        policy.activeAt(start.subtract(const Duration(seconds: 1))),
        false,
      );
      expect(policy.activeAt(start), true);
      expect(policy.activeAt(start.add(const Duration(hours: 1))), false);
    },
  );
  for (final minutes in [15, 20, 30]) {
    test('$minutes minute interval survives an earlier saved impression', () {
      final policy = AdPolicy.fromJson(
        config()..['ads_interval_minutes'] = minutes,
      );
      expect(policy.canShowInterstitial(start, null), true);
      expect(
        policy.canShowInterstitial(
          start.add(Duration(minutes: minutes - 1)),
          start,
        ),
        false,
      );
      expect(
        policy.canShowInterstitial(
          start.add(Duration(minutes: minutes)),
          start,
        ),
        true,
      );
      expect(
        policy.canShowInterstitial(
          start,
          start.add(const Duration(minutes: 1)),
        ),
        false,
      );
    });
  }
  test('disabled and missing configuration never displays', () {
    expect(const AdPolicy().activeAt(start), false);
    expect(
      AdPolicy.fromJson(config()..['ads_enabled'] = false).activeAt(start),
      false,
    );
  });
  test('invalid interval or inverted dates rejected', () {
    for (final interval in [0, 4, 1441, null, '20', 20.5]) {
      expect(
        () => AdPolicy.fromJson(config()..['ads_interval_minutes'] = interval),
        throwsFormatException,
      );
    }
    expect(
      () =>
          AdPolicy.fromJson(config()..['ads_ends_at'] = '2026-10-01T10:00:00Z'),
      throwsFormatException,
    );
  });
}
