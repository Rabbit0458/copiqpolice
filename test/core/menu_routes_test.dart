import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/main.dart' as app;
import 'package:copiqpolice/features/home/home_page.dart' as home;
import 'package:copiqpolice/features/home/home_page_pa_school.dart' as pa;

void main() {
  group('Menu routes', () {
    test('every navigable main-menu route is registered', () {
      final missing = <String>[];

      for (final mode in home.categoriesConfig.entries) {
        for (final track in mode.value.entries) {
          _collectMissing(
            '${mode.key.name}/${track.key.name}',
            track.value,
            missing,
          );
        }
      }

      expect(missing, isEmpty, reason: missing.join('\n'));
    });

    test('every navigable PA school route resolves to a registered page', () {
      final missing = <String>[];

      for (final program in pa.paSchoolCategoriesConfig.entries) {
        _collectMissing(program.key.name, program.value, missing);
      }

      expect(missing, isEmpty, reason: missing.join('\n'));
    });

  });
}

void _collectMissing(
  String scope,
  List<home.CategoryConfig> categories,
  List<String> missing,
) {
  for (final category in categories) {
    final subcategories = category.subcategories ?? const [];
    if (subcategories.isEmpty) {
      _checkRoute('$scope/${category.label}', category.route, missing);
      continue;
    }

    for (final subcategory in subcategories) {
      _checkRoute(
        '$scope/${category.label}/${subcategory.label}',
        subcategory.route,
        missing,
      );
    }
  }
}

void _checkRoute(String source, String route, List<String> missing) {
  final paResolved = pa.redirectConfigPaSchool[route] ?? route;
  final resolved = home.resolveHomeRoute(paResolved);
  if (!app.RouteRegistry.routes.containsKey(resolved)) {
    missing.add('$source: $route (resolved: $resolved)');
  }
}
