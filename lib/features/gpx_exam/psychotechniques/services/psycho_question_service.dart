// COP'IQ — Service de chargement des questions psychotechniques.
//
// Une seule classe expose des méthodes par catégorie. Chaque méthode :
//   1. tire un seed aléatoire,
//   2. requête sur rand_key >= seed avec is_active = true et la difficulté,
//   3. complète si insuffisant via rand_key < seed,
//   4. fusionne et mélange localement.
//
// On NE FAIT JAMAIS `order by random()` côté serveur.
//
// Toutes les méthodes renvoient List<PsychoQuestion> (modèle commun).

import 'dart:math' as math;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/psycho_question.dart';

class PsychoCategory {
  static const calculMental = 'calcul_mental';
  static const logiqueVerbale = 'logique_verbale';
  static const raisonnementLogique = 'raisonnement_logique';
  static const raisonnementSpatial = 'raisonnement_spatial';
  static const rotationsSymetries = 'rotations_symetries';
  static const concentration = 'concentration';
  static const attentionVisuelle = 'attention_visuelle';
  static const suiteLogique = 'suite_logique';
}

class PsychoTable {
  static const calculMental = 'tests_psyco_calcul_mental';
  static const logiqueVerbale = 'tests_psyco_logique_verbale';
  static const raisonnementLogique = 'tests_psyco_raisonnement_logique';
  static const raisonnementSpatial = 'tests_psyco_raisonnement_spatial';
  static const rotationsSymetries = 'tests_psyco_rotations_symetries';
  static const concentration = 'tests_psyco_concentration';
  static const attentionVisuelle = 'tests_psyco_attention_visuelle';
  static const suiteLogique = 'tests_psyco_suite_logique';
}

typedef PsychoMapper = PsychoQuestion Function(Map<String, dynamic> row);

class PsychoQuestionService {
  PsychoQuestionService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;
  final math.Random _random = math.Random();

  // ==========================================================================
  // ENTRÉE PRINCIPALE
  // ==========================================================================
  Future<List<PsychoQuestion>> loadByCategory({
    required String category,
    required String difficulty,
    int limit = 30,
  }) {
    switch (category) {
      case PsychoCategory.calculMental:
        return loadCalculMental(difficulty: difficulty, limit: limit);
      case PsychoCategory.logiqueVerbale:
        return loadLogiqueVerbale(difficulty: difficulty, limit: limit);
      case PsychoCategory.raisonnementLogique:
        return loadRaisonnementLogique(difficulty: difficulty, limit: limit);
      case PsychoCategory.raisonnementSpatial:
        return loadRaisonnementSpatial(difficulty: difficulty, limit: limit);
      case PsychoCategory.rotationsSymetries:
        return loadRotationsSymetries(difficulty: difficulty, limit: limit);
      case PsychoCategory.concentration:
        return loadConcentration(difficulty: difficulty, limit: limit);
      case PsychoCategory.attentionVisuelle:
        return loadAttentionVisuelle(difficulty: difficulty, limit: limit);
      case PsychoCategory.suiteLogique:
        return loadSuiteLogique(difficulty: difficulty, limit: limit);
    }
    throw ArgumentError('Catégorie psycho inconnue : $category');
  }

  // ==========================================================================
  // COMPTEURS — pour afficher "X questions disponibles" dans difficulty screen
  // ==========================================================================
  Future<int> countAvailable({
    required String table,
    required String difficulty,
  }) async {
    try {
      // Attention visuelle utilise easy/medium/hard côté BDD — on traduit
      // depuis le label français affiché dans l'UI.
      final dbDifficulty = (table == PsychoTable.attentionVisuelle)
          ? _attentionVisuelleDifficultyKey(difficulty)
          : difficulty;
      final res = await _supabase
          .from(table)
          .select('id')
          .eq('is_active', true)
          .eq('difficulty', dbDifficulty);
      return (res as List).length;
    } catch (_) {
      return 0;
    }
  }

  // ==========================================================================
  // CHARGEURS PAR CATÉGORIE
  // ==========================================================================
  Future<List<PsychoQuestion>> loadCalculMental({
    required String difficulty,
    int limit = 30,
  }) {
    return _loadGeneric(
      table: PsychoTable.calculMental,
      difficulty: difficulty,
      limit: limit,
      mapper: _mapCalculMental,
    );
  }

  Future<List<PsychoQuestion>> loadLogiqueVerbale({
    required String difficulty,
    int limit = 30,
  }) {
    return _loadGeneric(
      table: PsychoTable.logiqueVerbale,
      difficulty: difficulty,
      limit: limit,
      mapper: _mapLogiqueVerbale,
    );
  }

  Future<List<PsychoQuestion>> loadRaisonnementLogique({
    required String difficulty,
    int limit = 30,
  }) {
    return _loadGeneric(
      table: PsychoTable.raisonnementLogique,
      difficulty: difficulty,
      limit: limit,
      mapper: _mapRaisonnementLogique,
    );
  }

  Future<List<PsychoQuestion>> loadRaisonnementSpatial({
    required String difficulty,
    int limit = 30,
  }) {
    return _loadGeneric(
      table: PsychoTable.raisonnementSpatial,
      difficulty: difficulty,
      limit: limit,
      mapper: _mapRaisonnementSpatial,
    );
  }

  Future<List<PsychoQuestion>> loadRotationsSymetries({
    required String difficulty,
    int limit = 30,
  }) {
    return _loadGeneric(
      table: PsychoTable.rotationsSymetries,
      difficulty: difficulty,
      limit: limit,
      mapper: _mapRotationsSymetries,
    );
  }

  Future<List<PsychoQuestion>> loadConcentration({
    required String difficulty,
    int limit = 30,
  }) {
    return _loadGeneric(
      table: PsychoTable.concentration,
      difficulty: difficulty,
      limit: limit,
      mapper: _mapConcentration,
    );
  }

  // -- Tables existantes ------------------------------------------------------
  Future<List<PsychoQuestion>> loadSuiteLogique({
    required String difficulty,
    int limit = 30,
  }) {
    return _loadGeneric(
      table: PsychoTable.suiteLogique,
      difficulty: difficulty,
      limit: limit,
      mapper: _mapSuiteLogique,
    );
  }

  /// Attention visuelle a un schéma différent (text_a / text_b / is_true) —
  /// on l'expose pour le mode concours et pour la page dédiée.
  /// Pas de rand_key sur cette table → fetch + shuffle local.
  Future<List<PsychoQuestion>> loadAttentionVisuelle({
    required String difficulty,
    int limit = 30,
  }) async {
    try {
      // Ici la table n'a pas de rand_key, on utilise donc un fetch + shuffle.
      // Carte difficulty existante : 'easy' / 'medium' / 'hard'
      final mapped = _attentionVisuelleDifficultyKey(difficulty);
      final res = await _supabase
          .from(PsychoTable.attentionVisuelle)
          .select()
          .eq('is_active', true)
          .eq('difficulty', mapped);
      final list = (res as List).cast<Map<String, dynamic>>();
      list.shuffle(_random);
      return list.take(limit).map(_mapAttentionVisuelle).toList();
    } catch (_) {
      return const [];
    }
  }

  // ==========================================================================
  // CHARGEUR GÉNÉRIQUE rand_key
  // ==========================================================================
  Future<List<PsychoQuestion>> _loadGeneric({
    required String table,
    required String difficulty,
    required int limit,
    required PsychoMapper mapper,
  }) async {
    final seed = _random.nextDouble();

    try {
      // Pass 1 : rand_key >= seed
      final first = await _supabase
          .from(table)
          .select()
          .eq('is_active', true)
          .eq('difficulty', difficulty)
          .gte('rand_key', seed)
          .order('rand_key', ascending: true)
          .limit(limit);
      final firstList = (first as List).cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> merged = List.of(firstList);
      if (merged.length < limit) {
        // Pass 2 : rand_key < seed
        final second = await _supabase
            .from(table)
            .select()
            .eq('is_active', true)
            .eq('difficulty', difficulty)
            .lt('rand_key', seed)
            .order('rand_key', ascending: true)
            .limit(limit - merged.length);
        final secondList = (second as List).cast<Map<String, dynamic>>();
        merged.addAll(secondList);
      }
      // Dédupe par id puis shuffle local pour variabilité.
      final seen = <String>{};
      merged = merged.where((m) {
        final k = (m['id'] ?? '').toString();
        if (seen.contains(k)) return false;
        seen.add(k);
        return true;
      }).toList()..shuffle(_random);

      return merged.take(limit).map(mapper).toList();
    } catch (_) {
      // Fallback sans rand_key (au cas où).
      try {
        final res = await _supabase
            .from(table)
            .select()
            .eq('is_active', true)
            .eq('difficulty', difficulty)
            .limit(limit);
        final list = (res as List).cast<Map<String, dynamic>>();
        list.shuffle(_random);
        return list.map(mapper).toList();
      } catch (_) {
        return const [];
      }
    }
  }

  // ==========================================================================
  // MAPPERS
  // ==========================================================================
  PsychoQuestion _mapCalculMental(Map<String, dynamic> row) {
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.calculMental,
      module: (row['module'] ?? 'psychotechnique').toString(),
      category: PsychoCategory.calculMental,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: (row['question'] ?? '').toString(),
      prompt: _str(row['prompt']) ?? _str(row['expression']),
      options: PsychoQuestion.parseOptions(row['options']),
      answer: (row['answer'] ?? '').toString(),
      explanation: _str(row['explanation']),
      hint: _str(row['hint']),
      rawData: row,
    );
  }

  PsychoQuestion _mapLogiqueVerbale(Map<String, dynamic> row) {
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.logiqueVerbale,
      module: (row['module'] ?? 'psychotechnique').toString(),
      category: PsychoCategory.logiqueVerbale,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: (row['question'] ?? '').toString(),
      prompt: _str(row['prompt']),
      options: PsychoQuestion.parseOptions(row['options']),
      answer: (row['answer'] ?? '').toString(),
      explanation: _str(row['explanation']),
      hint: _str(row['hint']),
      rawData: row,
    );
  }

  PsychoQuestion _mapRaisonnementLogique(Map<String, dynamic> row) {
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.raisonnementLogique,
      module: (row['module'] ?? 'psychotechnique').toString(),
      category: PsychoCategory.raisonnementLogique,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: (row['question'] ?? '').toString(),
      prompt: _str(row['prompt']),
      options: PsychoQuestion.parseOptions(row['options']),
      answer: (row['answer'] ?? '').toString(),
      explanation: _str(row['explanation']),
      hint: _str(row['hint']),
      rawData: row,
    );
  }

  PsychoQuestion _mapRaisonnementSpatial(Map<String, dynamic> row) {
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.raisonnementSpatial,
      module: (row['module'] ?? 'psychotechnique').toString(),
      category: PsychoCategory.raisonnementSpatial,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: (row['question'] ?? '').toString(),
      prompt: _str(row['prompt']),
      options: PsychoQuestion.parseOptions(row['options']),
      answer: (row['answer'] ?? '').toString(),
      explanation: _str(row['explanation']),
      hint: _str(row['hint']),
      imageUrl: _str(row['image_url']),
      figureData: row['figure_data'] is Map
          ? (row['figure_data'] as Map).cast<String, dynamic>()
          : null,
      rawData: row,
    );
  }

  PsychoQuestion _mapRotationsSymetries(Map<String, dynamic> row) {
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.rotationsSymetries,
      module: (row['module'] ?? 'psychotechnique').toString(),
      category: PsychoCategory.rotationsSymetries,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: (row['question'] ?? '').toString(),
      prompt: _str(row['prompt']),
      options: PsychoQuestion.parseOptions(row['options']),
      answer: (row['answer'] ?? '').toString(),
      explanation: _str(row['explanation']),
      hint: _str(row['hint']),
      imageUrl: _str(row['image_url']),
      figureData: row['figure_data'] is Map
          ? (row['figure_data'] as Map).cast<String, dynamic>()
          : null,
      rawData: row,
    );
  }

  PsychoQuestion _mapConcentration(Map<String, dynamic> row) {
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.concentration,
      module: (row['module'] ?? 'psychotechnique').toString(),
      category: PsychoCategory.concentration,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: (row['question'] ?? '').toString(),
      prompt: _str(row['prompt']) ?? _str(row['stimulus']),
      options: PsychoQuestion.parseOptions(row['options']),
      answer: (row['answer'] ?? '').toString(),
      explanation: _str(row['explanation']),
      hint: _str(row['hint']),
      rawData: row,
    );
  }

  PsychoQuestion _mapSuiteLogique(Map<String, dynamic> row) {
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.suiteLogique,
      module: (row['module'] ?? 'psychotechnique').toString(),
      category: PsychoCategory.suiteLogique,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: (row['sequence_text'] ?? '').toString(),
      prompt: _str(row['prompt']),
      options: PsychoQuestion.parseOptions(row['options']),
      answer: (row['answer'] ?? '').toString(),
      explanation: _str(row['explanation']),
      hint: _str(row['hint']),
      rawData: row,
    );
  }

  PsychoQuestion _mapAttentionVisuelle(Map<String, dynamic> row) {
    final isTrue = row['is_true'] == true;
    return PsychoQuestion(
      id: (row['id'] ?? '').toString(),
      tableName: PsychoTable.attentionVisuelle,
      module: 'psychotechnique',
      category: PsychoCategory.attentionVisuelle,
      difficulty: PsychoQuestion.normalizeDifficulty(row['difficulty']),
      question: 'Les deux textes sont-ils strictement identiques ?',
      prompt: '${row['text_a']}\n${row['text_b']}',
      options: const [
        PsychoOption(key: 'true', label: 'Identiques'),
        PsychoOption(key: 'false', label: 'Différents'),
      ],
      answer: isTrue ? 'true' : 'false',
      explanation: _str(row['explanation']),
      rawData: row,
    );
  }

  String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  String _attentionVisuelleDifficultyKey(String niceLabel) {
    switch (niceLabel) {
      case 'Facile':
        return 'easy';
      case 'Difficile':
        return 'hard';
      default:
        return 'medium';
    }
  }
}
