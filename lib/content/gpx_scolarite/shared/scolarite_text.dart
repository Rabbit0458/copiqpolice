import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Résout uniquement les textes éditoriaux des pages de scolarité.
///
/// Les widgets, couleurs, typographies et espacements restent définis dans les
/// pages Flutter historiques. En cas d'absence de réseau ou de donnée, le texte
/// original compilé dans l'application est conservé.
abstract final class ScolariteText {
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);
  static final Map<String, Map<String, String>> _values = {};
  static final Set<String> _loading = {};
  static final Set<String> _loaded = {};

  /// Hauteur commune des cartes de scolarité. Lorsqu'un écran contient au
  /// maximum quatre cartes, elles se partagent l'espace visible disponible et
  /// restent entièrement affichées sur iOS comme sur Android.
  static double adaptiveCardHeight(
    BuildContext context, {
    required int cardCount,
    double minHeight = 126,
    double maxHeight = 200,
  }) {
    if (cardCount <= 0 || cardCount > 4) return maxHeight;
    final media = MediaQuery.of(context);
    final available =
        media.size.height - media.padding.vertical - kToolbarHeight - 64;
    return (available / cardCount).clamp(minHeight, maxHeight).toDouble();
  }

  static String value(String sourcePath, String fragmentKey, String fallback) {
    if (!_loaded.contains(sourcePath) && !_loading.contains(sourcePath)) {
      unawaited(_load(sourcePath));
    }
    return _values[sourcePath]?[fragmentKey] ?? fallback;
  }

  static Future<void> refresh(String sourcePath) async {
    _loaded.remove(sourcePath);
    await _load(sourcePath, force: true);
  }

  static Future<void> _load(String sourcePath, {bool force = false}) async {
    if (!force &&
        (_loaded.contains(sourcePath) || _loading.contains(sourcePath))) {
      return;
    }
    _loading.add(sourcePath);
    final preferences = await SharedPreferences.getInstance();
    final cacheKey = 'scolarite_text_fragments_v1::$sourcePath';

    try {
      final cached = preferences.getString(cacheKey);
      if (cached != null) {
        final decoded = Map<String, dynamic>.from(jsonDecode(cached) as Map);
        _values[sourcePath] = decoded.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        revision.value++;
      }
    } catch (_) {
      // Un cache illisible ne doit jamais empêcher l'affichage local.
    }

    try {
      final rows = await Supabase.instance.client
          .from('scolarite_content_fragments')
          .select('fragment_key,text_value')
          .eq('source_path', sourcePath)
          .order('position');
      final remote = <String, String>{
        for (final row in rows)
          row['fragment_key'] as String: row['text_value'] as String,
      };
      _values[sourcePath] = remote;
      _loaded.add(sourcePath);
      await preferences.setString(cacheKey, jsonEncode(remote));
      revision.value++;
    } catch (error) {
      _loaded.add(sourcePath);
      debugPrint('scolarite_text: secours local pour $sourcePath — $error');
    } finally {
      _loading.remove(sourcePath);
    }
  }
}

/// Place ce widget au-dessus de l'application afin que la page courante se
/// reconstruise lorsqu'un lot de textes distants vient d'être chargé.
class ScolariteTextRefresh extends StatelessWidget {
  const ScolariteTextRefresh({required this.builder, super.key});

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: ScolariteText.revision,
    builder: (context, _, __) => builder(context),
  );
}
