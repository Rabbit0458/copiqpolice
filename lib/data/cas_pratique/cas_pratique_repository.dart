// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Repository (contrat abstrait)                 ║
// ║  Référence : docs/cas_pratique/10_API_SURFACE.md (section 3.1)          ║
// ║  Tâche      : CODE-013                                                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';

/// Tri des cas dans la liste.
enum CaseSortBy {
  recent,
  scoreAsc,
  scoreDesc,
  durationAsc,
  durationDesc,
  alphabetical,
}

/// Contrat unique d'accès aux données Cas Pratique.
///
/// **Règle d'or** : aucun appel direct à `Supabase.instance.client` depuis
/// l'UI. Tout passe par ce repository.
///
/// L'implémentation concrète vit dans `cas_pratique_repository_impl.dart`.
abstract class CasPratiqueRepository {
  // ─── THÈMES ───────────────────────────────────────────────────────────
  Future<List<CpTheme>> listThemes();

  // ─── CASES (LIST + DETAIL) ────────────────────────────────────────────
  Future<List<CaseSummary>> listCases({
    Set<String>? themeSlugs,
    Set<int>? years,
    Set<CpDifficulty>? difficulties,
    String? searchQuery,
    CaseSortBy sortBy = CaseSortBy.recent,
    int limit = 50,
    int offset = 0,
  });

  Future<CaseDetail> getCaseDetail(String slugOrId);

  /// Force le rafraîchissement du cache.
  Future<void> refreshCache();

  // ─── ATTEMPTS ─────────────────────────────────────────────────────────
  Future<Attempt> startAttempt(String caseId);
  Future<Attempt> getAttempt(String attemptId);

  /// Tente de récupérer une attempt `in_progress` pour ce cas, sinon null.
  Future<Attempt?> getActiveAttempt(String caseId);

  // ─── ANSWERS ──────────────────────────────────────────────────────────
  Future<void> saveDraftAnswer({
    required String attemptId,
    required String caseSlugLegacy, // pour rétrocompat avec la table existante
    required String questionId,
    required int questionIndex,
    required String text,
  });

  Future<void> validateAnswer({
    required String attemptId,
    required String caseSlugLegacy,
    required String questionId,
    required int questionIndex,
    required String text,
  });

  Future<List<Answer>> listAnswersForAttempt(String attemptId);

  // ─── CORRECTION ───────────────────────────────────────────────────────
  /// Lance la correction de la tentative et persiste le résultat.
  ///
  /// Si le réseau est disponible, appelle l'edge function `cas_pratique_correct_attempt`
  /// (source de vérité). Sinon utilise le moteur local (mode offline).
  Future<Correction> finishAttemptAndCorrect({
    required String attemptId,
    required CaseDetail fullCase,
    required Map<String, String> answersByQuestionId,
    required int timeSpentMs,
  });

  Future<Correction> getCorrection(String attemptId);

  // ─── APPELS ───────────────────────────────────────────────────────────
  Future<Appeal> createAppeal({
    required String correctionDetailId,
    required String message,
  });

  Future<List<Appeal>> listMyAppeals();

  /// Stream realtime des mises à jour d'appels (statut, réponse admin).
  Stream<Appeal> watchMyAppeals();

  // ─── PROGRESSION GLOBALE ──────────────────────────────────────────────
  Future<UserGlobalProgress> getMyProgress();
}
