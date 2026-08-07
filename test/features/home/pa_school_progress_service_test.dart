import 'package:flutter_test/flutter_test.dart';
import 'package:copiqpolice/features/home/pa_school_progress_service.dart';

void main() {
  group('PA school progress registry', () {
    test('classe les principaux cours de scolarité', () {
      expect(paSchoolModuleKey('Quiz — Déontologie'), 'institutions_valeurs');
      expect(paSchoolModuleKey('Circulation routière'), 'circulation_routiere');
      expect(paSchoolModuleKey('Enquête préliminaire'), 'dps_dpg');
      expect(paSchoolModuleKey('Communication radio'), 'intervention');
    });

    test('toutes les recommandations ont une route exploitable', () {
      for (final key in <String>[
        'institutions_valeurs',
        'circulation_routiere',
        'dps_dpg',
        'intervention',
        'fondamentaux',
      ]) {
        expect(paSchoolModuleMeta(key).route, startsWith('/'));
      }
    });
  });
}
