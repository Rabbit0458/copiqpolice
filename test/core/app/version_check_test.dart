import 'package:copiqpolice/core/app/version_check.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AppVersionConfig config({
    bool force = true,
    String minVersion = '1.0.0',
    int minBuild = 3,
  }) => AppVersionConfig(
    platform: 'ios',
    minVersion: minVersion,
    latestVersion: minVersion,
    minBuildNumber: minBuild,
    latestBuildNumber: minBuild,
    forceUpdate: force,
    storeUrl: 'itms-beta://',
    messageFr: 'Mise à jour requise',
    checkedAt: DateTime(2026, 8, 26),
  );

  test('le build minimum peut continuer', () {
    expect(config().requiresUpdate('1.0.0', 3), isFalse);
  });

  test('un build inférieur est bloqué', () {
    expect(config().requiresUpdate('1.0.0', 2), isTrue);
  });

  test('une version supérieure reste autorisée', () {
    expect(config().requiresUpdate('1.1.0', 1), isFalse);
  });

  test('le verrou peut être préparé sans être activé', () {
    expect(config(force: false).requiresUpdate('1.0.0', 2), isFalse);
  });
}
