import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

Future<void> main() async {
  final pubspecFile = File('pubspec.yaml');

  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml introuvable');
    return;
  }

  final pubspec = loadYaml(pubspecFile.readAsStringSync());
  final dependencies = pubspec['dependencies'] as YamlMap;

  print('\n🔎 Vérification des dépendances...\n');

  for (final entry in dependencies.entries) {
    final name = entry.key.toString();
    final versionConstraint = entry.value.toString();

    if (versionConstraint.contains('sdk:')) continue;

    try {
      final response = await http.get(
        Uri.parse('https://pub.dev/api/packages/$name'),
      );

      if (response.statusCode != 200) {
        print('⚠️ $name → Impossible de vérifier');
        continue;
      }

      final data = jsonDecode(response.body);
      final latest = data['latest']['version'];

      final current =
          versionConstraint.replaceAll('^', '').trim();

      if (current == latest) {
        print('🟢 $name ($current) → À JOUR');
      } else {
        print('🟠 $name ($current) → Dernière version : $latest');
      }
    } catch (e) {
      print('⚠️ $name → Erreur');
    }
  }

  print('\n✅ Vérification terminée\n');
}