// COP'IQ — Modèle commun pour toutes les questions psychotechniques.
// Chaque table Supabase psycho est convertie vers PsychoQuestion via
// son propre adapter (voir psycho_question_service.dart).
//
// Champs :
// - id          : identifiant universel (string)
// - tableName   : table Supabase d'origine (ex: tests_psyco_calcul_mental)
// - module      : 'psychotechnique'
// - category    : ex: calcul_mental, concentration, ...
// - difficulty  : Facile / Moyenne / Difficile
// - question    : énoncé principal affiché à l'utilisateur
// - prompt      : texte d'introduction / aide visuelle (facultatif)
// - options     : List<PsychoOption> — toujours convertis en clé/label
// - answer      : clé ou label de la bonne réponse
// - explanation : explication post-réponse
// - hint        : indice optionnel (rarement affiché)
// - imageUrl    : si exercice spatial / rotation
// - figureData  : payload jsonb (figures, schémas)
// - rawData     : map brute pour signalement / debug
//
// Cette classe est volontairement immuable.

import 'dart:convert';

class PsychoOption {
  final String key;
  final String label;
  final String? imageUrl;

  const PsychoOption({required this.key, required this.label, this.imageUrl});

  factory PsychoOption.fromValue(dynamic raw, int index) {
    if (raw is String) {
      return PsychoOption(key: raw, label: raw);
    }
    if (raw is Map) {
      final m = raw.cast<String, dynamic>();
      final key = (m['key'] ?? m['id'] ?? m['value'] ?? '$index').toString();
      final label =
          (m['label'] ?? m['text'] ?? m['title'] ?? key).toString().trim();
      final img = (m['image_url'] ?? m['imageUrl'])?.toString();
      return PsychoOption(
        key: key,
        label: label.isEmpty ? key : label,
        imageUrl: (img != null && img.isNotEmpty) ? img : null,
      );
    }
    return PsychoOption(key: '$index', label: raw?.toString() ?? '');
  }

  Map<String, dynamic> toMap() => {
    'key': key,
    'label': label,
    if (imageUrl != null) 'image_url': imageUrl,
  };
}

class PsychoQuestion {
  final String id;
  final String tableName;
  final String module;
  final String category;
  final String difficulty;
  final String question;
  final String? prompt;
  final List<PsychoOption> options;
  final String answer;
  final String? explanation;
  final String? hint;
  final String? imageUrl;
  final Map<String, dynamic>? figureData;
  final Map<String, dynamic> rawData;

  const PsychoQuestion({
    required this.id,
    required this.tableName,
    required this.module,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.answer,
    this.prompt,
    this.explanation,
    this.hint,
    this.imageUrl,
    this.figureData,
    required this.rawData,
  });

  // Vrai si la réponse choisie correspond à la bonne réponse.
  // Compare à la fois la clé et le label.
  bool isCorrect(PsychoOption picked) {
    return picked.key == answer || picked.label == answer;
  }

  PsychoOption? findCorrectOption() {
    for (final o in options) {
      if (o.key == answer || o.label == answer) return o;
    }
    return null;
  }

  // Sérialisation pour signalement (jsonb).
  Map<String, dynamic> toReportPayload() {
    return {
      'id': id,
      'table': tableName,
      'category': category,
      'difficulty': difficulty,
      'question': question,
      if (prompt != null) 'prompt': prompt,
      'options': options.map((o) => o.toMap()).toList(),
      'answer': answer,
      if (explanation != null) 'explanation': explanation,
    };
  }

  static String normalizeDifficulty(dynamic raw) {
    final s = (raw ?? '').toString().trim().toLowerCase();
    if (s.contains('fac') || s == 'easy') return 'Facile';
    if (s.contains('dif') || s == 'hard') return 'Difficile';
    if (s.contains('moy') ||
        s.contains('med') ||
        s == 'medium' ||
        s == 'normal') {
      return 'Moyenne';
    }
    return 'Moyenne';
  }

  static List<PsychoOption> parseOptions(dynamic raw) {
    if (raw == null) return const [];
    if (raw is String) {
      // Cas où la colonne arriverait sérialisée en JSON string.
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .asMap()
              .entries
              .map((e) => PsychoOption.fromValue(e.value, e.key))
              .toList();
        }
      } catch (_) {}
      return const [];
    }
    if (raw is List) {
      return raw
          .asMap()
          .entries
          .map((e) => PsychoOption.fromValue(e.value, e.key))
          .toList();
    }
    return const [];
  }
}
