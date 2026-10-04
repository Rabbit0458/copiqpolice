import 'dart:convert';
import 'dart:typed_data';

import 'package:copiqpolice/core/services/revenuecat_configuration.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class ConfigBundle extends CachingAssetBundle {
  ConfigBundle(this.contents);
  final String contents;
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(contents)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final android in [true, false]) {
    test(
      'Bundled production key loads without defines: android=$android',
      () async {
        final key = await loadRevenueCatKey(android: android);
        expect(key, startsWith(android ? 'goog_' : 'appl_'));
      },
    );
  }
  test('Explicit override does not depend on asset', () async {
    expect(
      await loadRevenueCatKey(
        android: false,
        override: ' appl_custom ',
        bundle: ConfigBundle('invalid'),
      ),
      'appl_custom',
    );
  });
  test('Wrong platform, secret and test overrides fail closed', () async {
    for (final key in ['goog_other', 'sk_secret', 'test_mock']) {
      await expectLater(
        loadRevenueCatKey(android: false, override: key),
        throwsFormatException,
      );
    }
  });
  test('Missing or malformed asset never configures billing', () async {
    for (final contents in [
      'broken',
      '{}',
      '[]',
      '{"REVENUECAT_IOS_API_KEY":42}',
    ]) {
      await expectLater(
        loadRevenueCatKey(android: false, bundle: ConfigBundle(contents)),
        throwsFormatException,
      );
    }
  });
}
