import 'package:shared_preferences/shared_preferences.dart';

/// Persistance locale du dernier programme de scolarité choisi.
///
/// Le mode (`school`/`exam`) et le grade (`gpx`/`pa`) sont déjà conservés
/// ailleurs. Ces deux clés complètent le contexte afin que le démarrage puisse
/// rouvrir directement la bonne page d'accueil de scolarité.
abstract final class SchoolProgramPreferences {
  static const String _gpxKey = 'selected_gpx_school_program';
  static const String _paKey = 'selected_pa_school_program';

  static Future<String?> readGpx() => _read(_gpxKey);

  static Future<String?> readPa() => _read(_paKey);

  static Future<void> saveGpx(String programKey) => _save(_gpxKey, programKey);

  static Future<void> savePa(String programKey) => _save(_paKey, programKey);

  static Future<String?> _read(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(key)?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  static Future<void> _save(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }
}
