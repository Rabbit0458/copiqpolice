import 'package:flutter_test/flutter_test.dart';
import 'package:copiqpolice/features/home/gpx_school_progress_service.dart';

void main() {
  group('GPX school progress registry', () {
    test('classe les principaux cours de scolarité', () {
      expect(
        gpxSchoolModuleKey('Organisation de la Police Nationale'),
        'institution_organisation',
      );
      expect(gpxSchoolModuleKey('Enquête préliminaire'), 'police_judiciaire');
      expect(gpxSchoolModuleKey('Sécurité routière'), 'securite_routiere');
      expect(gpxSchoolModuleKey('Intervention en patrouille'), 'intervention');
      expect(gpxSchoolModuleKey('Accueil des victimes'), 'public_victimes');
    });

    test('toutes les recommandations ont une route exploitable', () {
      for (final key in <String>[
        'institution_organisation',
        'police_judiciaire',
        'securite_routiere',
        'intervention',
        'public_victimes',
        'fondamentaux',
      ]) {
        expect(gpxSchoolModuleMeta(key).route, '/home-gpx-school');
      }
    });
  });
}
