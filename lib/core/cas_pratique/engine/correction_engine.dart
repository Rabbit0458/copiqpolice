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
      // ═══════════════════════════════════════════════════════════════════
      //  1. CHARGEMENT DE LA GRILLE DE CORRECTION
      //
      //  Jusqu'au 2026-07-26, cette etape faisait quatre lectures directes
      //  sur `cas_pratique_rubric_points`, `_keyword_groups`, `_keywords` et
      //  `_synonyms_dictionary`, toutes ouvertes en lecture a n'importe quel
      //  utilisateur authentifie. Une seule requete suffisait donc a
      //  recuperer les mots-cles attendus de TOUS les cas — l'epreuve
      //  perdait tout interet.
      //
      //  La grille passe desormais par `cp_get_rubric_for_attempt`, une
      //  fonction SECURITY DEFINER qui ne renvoie que la grille du cas
      //  rattache a la tentative, et uniquement si celle-ci appartient a
      //  l'appelant. Les lectures directes sont maintenant refusees par la
      //  RLS pour tout le monde sauf les administrateurs.
      // ═══════════════════════════════════════════════════════════════════
      final rubricRaw = await _sb.rpc(
        'cp_get_rubric_for_attempt',
        params: {'p_attempt_id': attemptId},
      );

      final rubric = (rubricRaw is Map)
          ? Map<String, dynamic>.from(rubricRaw)
          : <String, dynamic>{};

      final questionNodes = (rubric['questions'] as List?) ?? const [];
      if (questionNodes.isEmpty) {
        throw CasPratiqueException.caseNotFound(caseId);
      }

      // Dictionnaire de synonymes, limite a ceux reellement utilises.
      final dictById = <String, EngineSynDict>{};
      for (final d in (rubric['synonyms'] as List?) ?? const []) {
        if (d is Map) {
          final m = Map<String, dynamic>.from(d);
          dictById[m['id'] as String] = EngineSynDict.fromJson(m);
        }
      }

      // Aplatissement de l'arbre renvoye par la RPC vers les structures
      // attendues par le scorer.
      final pointsByQuestion = <String, List<EngineRubricPoint>>{};
      final groupsByPoint = <String, List<EngineKeywordGroup>>{};
      final specs = <QuestionScoringSpec>[];

      for (final qn in questionNodes) {
        if (qn is! Map) continue;
        final q = Map<String, dynamic>.from(qn);
        final qid = q['id'] as String;

        final points = <EngineRubricPoint>[];
        for (final pn in (q['points'] as List?) ?? const []) {
          if (pn is! Map) continue;
          final p = Map<String, dynamic>.from(pn);
          final point = EngineRubricPoint.fromJson(p);
          points.add(point);

          final groups = <EngineKeywordGroup>[];
          for (final gn in (p['groups'] as List?) ?? const []) {
            if (gn is! Map) continue;
            final g = Map<String, dynamic>.from(gn);
            groups.add(
              EngineKeywordGroup.fromJson({
                ...g,
                'keywords': ((g['keywords'] as List?) ?? const [])
                    .whereType<Map>()
                    .map((k) => Map<String, dynamic>.from(k))
                    .toList(),
              }),
            );
          }
          groupsByPoint[point.id] = groups;
        }

        pointsByQuestion[qid] = points;
        specs.add(
          QuestionScoringSpec(
            questionId: qid,
            maxPoints: (q['max_points'] as int?) ?? 5,
            rubricPoints: points,
            groupsByPoint: groupsByPoint,
          ),
        );
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
