// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Exceptions typées                             ║
// ║  Référence : docs/cas_pratique/10_API_SURFACE.md (section 3.2)          ║
// ║  Tâche      : CODE-012                                                  ║
// ╚════════════════════════════════════════════════════════════════════════╝

/// Codes d'erreur typés exposés par le module Cas Pratique.
/// L'UI mappe chaque code en message friendly via un dictionnaire centralisé.
enum CasPratiqueErrorCode {
  notAuthenticated,
  rlsForbidden,
  caseNotFound,
  caseNotPublished,
  attemptNotFound,
  attemptAlreadyFinished,
  attemptNotOwned,
  questionNotFound,
  answerEmpty,
  answerTooShort,
  saveFailed,
  correctionEngineCrashed,
  networkOffline,
  serverError,
  rateLimited,
  unknown,
}

/// Exception unique du module Cas Pratique.
///
/// **Usage** :
/// ```dart
/// try {
///   await repo.getCaseDetail(slug);
/// } on CasPratiqueException catch (e) {
///   switch (e.code) {
///     case CasPratiqueErrorCode.caseNotFound:
///       AppNotifier.warning(context, title: 'Cas introuvable', message: '...');
///       break;
///     default:
///       AppNotifier.error(context, title: 'Erreur', message: e.message);
///   }
/// }
/// ```
class CasPratiqueException implements Exception {
  final CasPratiqueErrorCode code;
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const CasPratiqueException({
    required this.code,
    required this.message,
    this.cause,
    this.stackTrace,
  });

  factory CasPratiqueException.notAuthenticated() => const CasPratiqueException(
        code: CasPratiqueErrorCode.notAuthenticated,
        message: 'Tu dois être connecté pour cette action.',
      );

  factory CasPratiqueException.caseNotFound(String slug) => CasPratiqueException(
        code: CasPratiqueErrorCode.caseNotFound,
        message: 'Le cas "$slug" est introuvable ou n\'est plus disponible.',
      );

  factory CasPratiqueException.network(Object cause, [StackTrace? st]) =>
      CasPratiqueException(
        code: CasPratiqueErrorCode.networkOffline,
        message: 'Impossible de joindre le serveur. Vérifie ta connexion.',
        cause: cause,
        stackTrace: st,
      );

  factory CasPratiqueException.server(Object cause, [StackTrace? st]) =>
      CasPratiqueException(
        code: CasPratiqueErrorCode.serverError,
        message: 'Erreur serveur. Réessaie dans quelques instants.',
        cause: cause,
        stackTrace: st,
      );

  factory CasPratiqueException.engineCrashed(Object cause, [StackTrace? st]) =>
      CasPratiqueException(
        code: CasPratiqueErrorCode.correctionEngineCrashed,
        message: 'Le moteur de correction a rencontré une erreur interne.',
        cause: cause,
        stackTrace: st,
      );

  factory CasPratiqueException.unknown(Object cause, [StackTrace? st]) =>
      CasPratiqueException(
        code: CasPratiqueErrorCode.unknown,
        message: 'Une erreur inattendue est survenue.',
        cause: cause,
        stackTrace: st,
      );

  @override
  String toString() =>
      'CasPratiqueException(${code.name}): $message'
      '${cause != null ? '\n  cause: $cause' : ''}';
}

/// Dictionnaire centralisé : code → message UI friendly (FR).
class CasPratiqueErrorMessages {
  CasPratiqueErrorMessages._();

  static const Map<CasPratiqueErrorCode, String> _fr = {
    CasPratiqueErrorCode.notAuthenticated:
        'Connexion requise. Reconnecte-toi pour continuer.',
    CasPratiqueErrorCode.rlsForbidden:
        'Accès refusé. Cette ressource ne t\'appartient pas.',
    CasPratiqueErrorCode.caseNotFound:
        'Ce cas pratique n\'existe pas ou n\'est plus disponible.',
    CasPratiqueErrorCode.caseNotPublished:
        'Ce cas n\'est pas encore publié.',
    CasPratiqueErrorCode.attemptNotFound:
        'Tentative introuvable.',
    CasPratiqueErrorCode.attemptAlreadyFinished:
        'Cette tentative est déjà terminée.',
    CasPratiqueErrorCode.attemptNotOwned:
        'Cette tentative ne t\'appartient pas.',
    CasPratiqueErrorCode.questionNotFound:
        'Question introuvable.',
    CasPratiqueErrorCode.answerEmpty:
        'Écris une réponse avant de valider.',
    CasPratiqueErrorCode.answerTooShort:
        'Ta réponse est trop courte pour être évaluée correctement.',
    CasPratiqueErrorCode.saveFailed:
        'Impossible d\'enregistrer ta réponse. Réessaie.',
    CasPratiqueErrorCode.correctionEngineCrashed:
        'Le moteur de correction a rencontré un problème. Notre équipe a été notifiée.',
    CasPratiqueErrorCode.networkOffline:
        'Pas de connexion internet.',
    CasPratiqueErrorCode.serverError:
        'Le serveur ne répond pas. Réessaie dans quelques instants.',
    CasPratiqueErrorCode.rateLimited:
        'Trop de requêtes. Patiente un instant.',
    CasPratiqueErrorCode.unknown:
        'Une erreur inattendue est survenue.',
  };

  /// Message friendly pour un code donné. Retourne le message par défaut
  /// si le code n'est pas mappé.
  static String of(CasPratiqueErrorCode code) =>
      _fr[code] ?? 'Une erreur est survenue.';
}
