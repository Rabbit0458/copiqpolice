import 'dart:convert';

import 'package:flutter/services.dart';

/// Only public native SDK keys belong in this asset; never server credentials.
Future<String> loadRevenueCatKey({
  required bool android,
  String override = '',
  AssetBundle? bundle,
}) async {
  var key = override.trim();
  if (key.isEmpty) {
    final config = jsonDecode(
      await (bundle ?? rootBundle).loadString('config/revenuecat.public.json'),
    );
    final field = android
        ? 'REVENUECAT_ANDROID_API_KEY'
        : 'REVENUECAT_IOS_API_KEY';
    if (config is! Map || config[field] is! String) {
      throw const FormatException('Missing RevenueCat public SDK key');
    }
    key = (config[field] as String).trim();
  }
  final prefix = android ? 'goog' : 'appl';
  if (!RegExp('^${prefix}_[A-Za-z0-9]+\$').hasMatch(key)) {
    throw const FormatException('Invalid RevenueCat native SDK key');
  }
  return key;
}
