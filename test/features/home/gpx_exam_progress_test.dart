import 'package:copiqpolice/features/home/gpx_exam_progress_source_registry.dart';
import 'package:copiqpolice/features/home/pa_exam_progress_calculator.dart';
import 'package:copiqpolice/features/home/pa_exam_progress_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('registre du suivi GPX Exam', () {
    test('classe les principales familles sans les mélanger avec PA', () {
      expect(
        gpxModuleKeyFromNames('Culture générale', 'Quiz histoire'),
        'culture_generale',
      );
      expect(
        gpxModuleKeyFromNames('Langue étrangère', 'Anglais'),
        'langue_etrangere',
      );
      expect(
        gpxModuleKeyFromNames('Institution', 'Police nationale'),
        'institution',
      );
      expect(
        gpxModuleKeyFromNames('Tests psychotechniques', 'Calcul mental'),
        'psychotechnique',
      );
    });

    test('chaque matière connue ouvre une route GPX Exam', () {
      const registeredRoutes = {
        '/gpx_exam/concours/culture_generale_actualite',
        '/gpx_exam/concours/tests_psychotechniques/calcul_rapide',
        '/gpx_exam/concours/langue_etrangere/exemples_anglais',
        '/gpx_exam/concours/culture_generale_police_securite',
        '/gpx_exam/concours/cas_pratique/welcome',
      };
      for (final meta in gpxProgressModules.values) {
        expect(meta.route, startsWith('/gpx_exam/concours'));
        expect(registeredRoutes, contains(meta.route));
      }
    });

    test('le calculateur utilise les libellés et routes GPX', () {
      const calculator = PaExamProgressCalculator(
        moduleMetaResolver: gpxModuleMeta,
      );
      final snapshot = calculator.build(
        activities: [
          PaProgressActivity(
            id: 'gpx:1',
            source: PaProgressSource.quiz,
            moduleKey: 'langue_etrangere',
            moduleLabel: 'Langue étrangère',
            title: 'Anglais',
            correct: 7,
            total: 10,
            finishedAt: DateTime(2026, 8, 4),
          ),
        ],
        errors: const [],
        dailyGoal: 3,
        now: DateTime(2026, 8, 4),
      );

      expect(snapshot.subjects.single.label, 'Langue étrangère');
      expect(
        snapshot.subjects.single.route,
        '/gpx_exam/concours/langue_etrangere/exemples_anglais',
      );
      expect(snapshot.globalPercent, 70);
    });
  });
}
