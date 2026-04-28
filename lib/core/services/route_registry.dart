// lib/services/route_registry.dart
import 'package:copiqpolice/features/home/home_page.dart'
    show CategoryConfig, SubCategoryConfig;

/// Registre unique : mappe un libellé (module_name, quiz_name, label UI)
/// -> route réelle.
/// + support d'alias (variations de noms) + normalisation accents/ponctuation.
class RouteRegistry {
  final Map<String, String> _byKey = {};

  static String norm(String s) {
    var t = s.toLowerCase().trim();
    const from = 'àáâäãåçèéêëìíîïñòóôöõùúûüýÿœæ’\'"';
    const to = 'aaaaaaceeeeiiiinooooouuuuyyoea  ';
    for (var i = 0; i < from.length; i++) {
      t = t.replaceAll(from[i], to[i]);
    }
    t = t.replaceAll(RegExp(r'[^a-z0-9]+'), ' ');
    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    return t;
  }

  void register(String labelOrName, String route) {
    final k = norm(labelOrName);
    if (k.isEmpty) return;
    _byKey[k] = route;
  }

  void alias(String alias, String route) => register(alias, route);

  String? routeFor(String labelOrName) {
    final k = norm(labelOrName);
    if (k.isEmpty) return null;
    return _byKey[k];
  }

  /// Build depuis categoriesConfig (cat + subcats).
  static RouteRegistry fromCategories(List<CategoryConfig> cats) {
    final r = RouteRegistry();
    for (final c in cats) {
      r.register(c.label, c.route);
      final subs = c.subcategories ?? const <SubCategoryConfig>[];
      for (final s in subs) {
        r.register(s.label, s.route);
      }
    }
    return r;
  }
}
