// test/core/user_context_service_test.dart
//
// Tests unitaires du UserContextService.
// On ne teste pas les appels Supabase ici (réseau) — uniquement la logique
// de cache mémoire et de fallback.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:copiqpolice/core/services/user_context_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await UserContextService.I.clear();
  });

  group('UserContextService — état initial', () {
    test('track et mode null par défaut', () {
      expect(UserContextService.I.track, isNull);
      expect(UserContextService.I.mode, isNull);
    });

    test('trackOrDefault et modeOrDefault fournissent un fallback safe', () {
      expect(UserContextService.I.trackOrDefault, UserTracks.fallback);
      expect(UserContextService.I.modeOrDefault, UserModes.fallback);
    });
  });

  group('UserContextService — setTrack/setMode', () {
    test('setTrack persiste et met à jour le listenable', () async {
      await UserContextService.I.setTrack(UserTracks.pa);
      expect(UserContextService.I.track, UserTracks.pa);
      expect(UserContextService.I.trackListenable.value, UserTracks.pa);
    });

    test('setTrack ignore une valeur invalide', () async {
      await UserContextService.I.setTrack('pilot');
      expect(UserContextService.I.track, isNull);
    });

    test('setMode persiste et met à jour le listenable', () async {
      await UserContextService.I.setMode(UserModes.school);
      expect(UserContextService.I.mode, UserModes.school);
      expect(UserContextService.I.modeListenable.value, UserModes.school);
    });

    test('setMode ignore une valeur invalide', () async {
      await UserContextService.I.setMode('demo');
      expect(UserContextService.I.mode, isNull);
    });
  });

  group('UserContextService — clear', () {
    test('réinitialise le cache + SharedPreferences', () async {
      await UserContextService.I.setTrack(UserTracks.pa);
      await UserContextService.I.setMode(UserModes.school);
      await UserContextService.I.clear();
      expect(UserContextService.I.track, isNull);
      expect(UserContextService.I.mode, isNull);
      expect(UserContextService.I.isInitialized, isFalse);
    });
  });
}
