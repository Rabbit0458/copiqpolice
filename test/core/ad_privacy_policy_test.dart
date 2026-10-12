import 'dart:io';

import 'package:copiqpolice/core/services/ad_privacy_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all requests are non-personalized without account targeting', () {
    final request = AdPrivacyPolicy.request;
    expect(request.nonPersonalizedAds, isTrue);
    expect(request.keywords, isNull);
    expect(request.contentUrl, isNull);
  });

  test('ads require an iOS version that protects IDFA with ATT', () {
    for (final version in ['13.7', '14', '14.0', '14.4.2', '', 'unknown']) {
      expect(AdPrivacyPolicy.supportsIosAds(version), isFalse, reason: version);
    }
    for (final version in ['14.5', '14.8.1', '15', '18.0', '26.0']) {
      expect(AdPrivacyPolicy.supportsIosAds(version), isTrue, reason: version);
    }
  });

  test('interstitial and rewarded formats share the privacy policy', () {
    final source = File('lib/core/services/ad_service.dart').readAsStringSync();
    expect('request: AdPrivacyPolicy.request'.allMatches(source).length, 2);
    expect(source.contains('const AdRequest('), isFalse);
    expect(source.contains('setSameAppKeyEnabled(false)'), isTrue);
    expect(
      source.indexOf('setSameAppKeyEnabled(false)'),
      lessThan(source.indexOf('MobileAds.instance.initialize()')),
    );
  });

  test('Android removes the SDK advertising ID permission', () {
    final source = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    for (final permission in [
      'com.google.android.gms.permission.AD_ID',
      'android.permission.ACCESS_ADSERVICES_AD_ID',
      'android.permission.ACCESS_ADSERVICES_ATTRIBUTION',
      'android.permission.ACCESS_ADSERVICES_TOPICS',
    ]) {
      expect(source, contains('android:name="$permission"\n        tools:node="remove"'));
    }
  });
}
