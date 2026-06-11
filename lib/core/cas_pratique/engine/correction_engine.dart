// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Façade Engine                                 ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md             ║
// ║  Tâche      : CODE-028                                                  ║
// ║                                                                         ║
// ║  API simple : load rubric depuis Supabase → score local → persist.     ║
// ║                                                                         ║
// ║  Note : la rubric est ADMIN-ONLY côté RLS. Donc cet engine ne fonctionne║
// ║  pour un user lambda que si la lecture se fait via une edge function   ║
// ║  ou si une RPC SECURITY DEFINER expose les rubrics au moment du scoring.║
// ║  En mode dev/admin, on peut tester directement.                         ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/cas_pratique/engine/keyword_matcher.dart';
import 'package:copiqpolice/core/cas_pratique/engine/point_evaluator.dart';
import 'package:copiqpolice/core/cas_pratique/engine/scorer.dart';
import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_exception.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart' as api;

/// Version du moteur — incrémentée à chaque changement de logique.
const String kEngineVersion = '2.0.0';

/// Façade publique du moteur de correction.
///
/// Usage :
/// ```dart
/// final engine = CorrectionEngine();
/// final result = await engine.correct(
///   attemptId: '...',
///   caseId:    '...',
///   answersByQuestionId: { 'q1': 'ma réponse...', ... },
/// );
/// ```
///
/// La méthode :
///   1. Charge rubric (rubric_points + keyword_groups + keywords + synonyms_dictionary)
///   2. Exécute AttemptScorer
///   3. INSERT cas_pratique_corrections + cas_pratique_correction_details
///   4. UPDATE cas_pratique_attempts (status=completed, total_score, percent, ...)
///   5. Renvoie un `api.Correction` enrichi
class CorrectionEngine {
  CorrectionEngine({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  final SupabaseClient _sb;

  Future<api.Correction> correct({
    required String attemptId,
    required String caseId,
    required Map<String, String> answersByQuestionId,
    int timeSpentMs = 0,
  }) async {
    try {
      // ─── 1. Charger les questions + rubric_points du cas ──────────────────
      final questionRows = await _sb
          .from('cas_pratique_questions')
          .select('id, max_points, position')
          .eq('case_id', caseId)
          .order('position', ascending: true);

      final List<Map<String, dynamic>> questions =
          (questionRows as List).whereType<Map<String, dynamic>>().toList();

      if (questions.isEmpty) {
        throw CasPratiqueException.caseNotFound(caseId);
      }

      final qIds = questions.map((q) => q['id'] as String).toList();

      // ─── 2. Charger les rubric_points pour ces questions ──────────────────
      final pointRows = await _sb
          .from('cas_pratique_rubric_points')
          .select('id, question_id, position, label, weight, is_required, kind, explanation_md')
          .inFilter('question_id', qIds)
          .order('position', ascending: true);

      final pointsByQuestion = <String, List<EngineRubricPoint>>{};
      final allPointIds = <String>[];
      for (final r in (pointRows as List).whereType<Map<String, dynamic>>()) {
        final qid = r['question_id'] as String;
        final p = EngineRubricPoint.fromJson(r);
        pointsByQuestion.putIfAbsent(qid, () => []).add(p);
        allPointIds.add(p.id);
      }

      // ─── 3. Charger les keyword_groups ────────────────────────────────────
      final Map<String, List<EngineKeywordGroup>> groupsByPoint = {};
      final List<String> allGroupIds = [];

      if (allPointIds.isNotEmpty) {
        final groupRows = await _sb
            .from('cas_pratique_keyword_groups')
            .select('id, point_id, position, description, is_optional')
            .inFilter('point_id', allPointIds)
            .order('position', ascending: true);

        final tempGroups = <String, Map<String, dynamic>>{};
        for (final r in (groupRows as List).whereType<Map<String, dynamic>>()) {
          tempGroups[r['id'] as String] = {
            ...r,
            'keywords': <Map<String, dynamic>>[],
          };
          allGroupIds.add(r['id'] as String);
        }

        // ─── 4. Charger les keywords ────────────────────────────────────────
        if (allGroupIds.isNotEmpty) {
          final kwRows = await _sb
              .from('cas_pratique_keywords')
              .select('id, group_id, syn_dict_id, value, is_phrase, is_negation, fuzzy_max_dist, position')
              .inFilter('group_id', allGroupIds)
              .order('position', ascending: true);

          for (final k in (kwRows as List).whereType<Map<String, dynamic>>()) {
            final gid = k['group_id'] as String;
            (tempGroups[gid]?['keywords'] as List).add(k);
          }
        }

        for (final tg in tempGroups.values) {
          final group = EngineKeywordGroup.fromJson(tg);
          final pid = tg['point_id'] as String;
          groupsByPoint.putIfAbsent(pid, () => []).add(group);
        }
      }

      // ─── 5. Charger le dictionnaire de synonymes (utiles seulement) ──────
      final synDictIds = <String>{};
      for (final groups in groupsByPoint.values) {
        for (final g in groups) {
          for (final kw in g.keywords) {
            if (kw.synDictId != null) synDictIds.add(kw.synDictId!);
          }
        }
      }
      final dictById = <String, EngineSynDict>{};
      if (synDictIds.isNotEmpty) {
        final dictRows = await _sb
            .from('cas_pratique_synonyms_dictionary')
            .select('id, slug, terms')
            .inFilter('id', synDictIds.toList());
        for (final r in (dictRows as List).whereType<Map<String, dynamic>>()) {
          dictById[r['id'] as String] = EngineSynDict.fromJson(r);
        }
      }

      // ─── 6. Construire l'AttemptScoringInput ──────────────────────────────
      final specs = <QuestionScoringSpec>[];
      for (final q in questions) {
        final qid = q['id'] as String;
        specs.add(QuestionScoringSpec(
          questionId: qid,
          maxPoints: (q['max_points'] as int?) ?? 5,
          rubricPoints: pointsByQuestion[qid] ?? const <EngineRubricPoint>[],
          groupsByPoint: groupsByPoint,
        ));
      }

      final scorer = AttemptScorer(
        matcher: KeywordMatcher(synonymResolver: SynonymResolver(dictById)),
      );

      // ─── 7. Scoring ───────────────────────────────────────────────────────
      final result = scorer.score(AttemptScoringInput(
        answersByQuestionId: answersByQuestionId,
        questions: specs,
      ));

      // ─── 8. Persistance : corrections + correction_details ────────────────
      final corrRow = await _sb
          .from('cas_pratique_corrections')
          .insert({
            'attempt_id': attemptId,
            'total_score': result.totalScore,
            'total_max': result.totalMax,
            'percent': result.percent,
            'engine_version': kEngineVersion,
            'engine_settings': {
              'normalizer': 'v1',
              'fuzzy': true,
              'ngrams': true,
              'lemma': true,
              'partial_threshold': 0.5,
            },
          })
          .select('id')
          .single();

      final corrId = corrRow['id'] as String;

      // INSERT correction_details en bulk
      final detailsPayload = <Map<String, dynamic>>[];
      for (final qr in result.questionResults) {
        for (final pe in qr.points) {
          detailsPayload.add({
            'correction_id': corrId,
            'question_id': qr.questionId,
            'point_id': pe.pointId,
            'status': pointStatusToString(pe.status),
            'score': pe.score,
            'weight': pe.weight,
            'group_matches': pe.groupResults.map((g) => g.toJson()).toList(),
          });
        }
      }
      // INSERT + select pour récupérer les IDs réels (nécessaires pour
      // les appels utilisateur — CODE-042 / CODE-043).
      List<Map<String, dynamic>> insertedDetails = const [];
      if (detailsPayload.isNotEmpty) {
        final inserted = await _sb
            .from('cas_pratique_correction_details')
            .insert(detailsPayload)
            .select('id, correction_id, question_id, point_id, status, score, weight, group_matches');
        insertedDetails =
            (inserted as List).whereType<Map<String, dynamic>>().toList();
      }

      // ─── 9. Update de l'attempt ───────────────────────────────────────────
      await _sb.from('cas_pratique_attempts').update({
        'status': 'completed',
        'total_score': result.totalScore,
        'total_max': result.totalMax,
        'percent': result.percent,
        'finished_at': DateTime.now().toUtc().toIso8601String(),
        'time_spent_ms': timeSpentMs,
      }).eq('id', attemptId);

      // ─── 10. Construire le DTO API à renvoyer ─────────────────────────────
      // Pour éviter une 2e requête DB, on remplit point_label & point_kind
      // depuis le `pointsByQuestion` déjà chargé en mémoire.
      final pointById = <String, EngineRubricPoint>{};
      for (final list in pointsByQuestion.values) {
        for (final p in list) {
          pointById[p.id] = p;
        }
      }
      // On parcourt les lignes insérées (avec leur id réel) plutôt que le
      // payload local — ainsi le DTO retourné est cohérent avec la DB.
      final details = insertedDetails.map((d) {
        final pointId = d['point_id'] as String?;
        final p = pointId == null ? null : pointById[pointId];
        return api.CorrectionDetail.fromJson({
          ...d,
          'point_label': p?.label ?? '',
          'point_kind': p?.kind ?? 'core',
          'explanation_md': p?.explanationMd,
        });
      }).toList();

      return api.Correction(
        id: corrId,
        attemptId: attemptId,
        totalScore: result.totalScore,
        totalMax: result.totalMax,
        percent: result.percent,
        evaluatedAt: DateTime.now().toUtc(),
        engineVersion: kEngineVersion,
        details: details,
      );
    } on CasPratiqueException {
      rethrow;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[CorrectionEngine] error: $e\n$st');
      }
      throw CasPratiqueException.engineCrashed(e, st);
    }
  }
}
