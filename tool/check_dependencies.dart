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
  final lockFile = File('pubspec.lock');
  if (!lockFile.existsSync()) {
    print('pubspec.lock introuvable. Lance flutter pub get avant ce controle.');
    exitCode = 1;
    return;
  }
  final lock = loadYaml(lockFile.readAsStringSync()) as YamlMap;
  final packages = lock['packages'] as YamlMap;

  print('\n🔎 Vérification des dépendances...\n');

  for (final entry in dependencies.entries) {
    final name = entry.key.toString();
    final versionConstraint = entry.value.toString();

    if (entry.value is YamlMap) {
      if ((entry.value as YamlMap).containsKey('sdk')) continue;
    }
    final installed = packages[name];
    if (installed is! YamlMap || installed['source'] != 'hosted') {
      print('$name → Pas de version pub.dev installee a comparer');
      continue;
    }
    final current = installed['version'].toString();

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

      if (current == latest) {
        print('🟢 $name (installee : $current ; declaree : $versionConstraint) → À JOUR');
      } else {
        print('🟠 $name (installee : $current ; declaree : $versionConstraint) → Dernière version : $latest');
      }
    } catch (e) {
      print('⚠️ $name → Erreur');
    }
  }

  print('\n✅ Vérification terminée\n');
}
