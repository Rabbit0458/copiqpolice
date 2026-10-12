import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract final class AdPrivacyPolicy {
  static const request = AdRequest(nonPersonalizedAds: true);

  // Before iOS 14.5, IDFA can be available without an ATT authorization.
  static bool supportsIosAds(String systemVersion) {
    final parts = systemVersion.split('.');
    final major = int.tryParse(parts.first);
    final minor = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (major == null || minor == null) return false;
    return major > 14 || (major == 14 && minor >= 5);
  }
}
