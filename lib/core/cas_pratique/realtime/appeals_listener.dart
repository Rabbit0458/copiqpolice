// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Realtime listener pour les appels            ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (notifications)      ║
// ║  Tâche      : CODE-044                                                  ║
// ║                                                                         ║
// ║  Service singleton qui :                                                ║
// ║   1. S'abonne au flux Realtime `watchMyAppeals()` du repo               ║
// ║   2. Tient une copie en mémoire du dernier statut connu par appeal id  ║
// ║   3. Détecte les transitions pending → approved/rejected                ║
// ║   4. Pousse une notification AppNotifier (success/warning/info selon)  ║
// ║                                                                         ║
// ║  Le service a besoin d'un `GlobalKey<NavigatorState>` pour récupérer    ║
// ║  un BuildContext valide (puisqu'il vit en dehors du widget tree).      ║
// ║                                                                         ║
// ║  À démarrer après l'authentification (start) et arrêter au logout      ║
// ║  (stop). Le service est idempotent : start() multiple = no-op.         ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository_impl.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';

/// Listener singleton pour les appels en realtime.
class CasPratiqueAppealsListener {
  CasPratiqueAppealsListener._();

  static final CasPratiqueAppealsListener instance =
      CasPratiqueAppealsListener._();

  CasPratiqueRepository _repo = CasPratiqueRepositoryImpl();
  StreamSubscription<Appeal>? _sub;
  GlobalKey<NavigatorState>? _navKey;
  bool _started = false;

  /// Snapshot du dernier statut connu par appel id (en mémoire).
  /// Permet de détecter les transitions pending → approved/rejected.
  final Map<String, AppealStatus> _lastStatusById = <String, AppealStatus>{};

  /// Démarre l'abonnement realtime. Idempotent.
  ///
  /// - [navKey] : nécessaire pour pouvoir afficher des `AppNotifier` (qui
  ///   exigent un BuildContext valide).
  Future<void> start({
    required GlobalKey<NavigatorState> navKey,
    CasPratiqueRepository? repository,
  }) async {
    if (_started) return;
    _started = true;
    _navKey = navKey;
    if (repository != null) _repo = repository;

    try {
      // Hydratation initiale : on récupère la liste actuelle pour seeder
      // `_lastStatusById` afin de ne pas déclencher de notification au boot
      // pour des appels déjà processed avant l'abonnement.
      try {
        final initial = await _repo.listMyAppeals();
        for (final a in initial) {
          _lastStatusById[a.id] = a.status;
        }
      } catch (_) {
        /* pas grave : le seed n'est qu'une optimisation */
      }

      _sub = _repo.watchMyAppeals().listen(
        _onAppealEvent,
        onError: (Object e, StackTrace st) {
          if (kDebugMode) {
            debugPrint('[CasPratiqueAppealsListener] stream error: $e');
          }
        },
        cancelOnError: false,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CasPratiqueAppealsListener] start failed: $e');
      }
      _started = false;
    }
  }

  /// Stoppe l'abonnement et purge le cache mémoire.
  Future<void> stop() async {
    final s = _sub;
    _sub = null;
    _started = false;
    _lastStatusById.clear();
    if (s != null) {
      try {
        await s.cancel();
      } catch (_) {/* ignore */}
    }
  }

  /// Réinitialise le snapshot mémoire (utile sur changement d'utilisateur).
  void clearMemory() {
    _lastStatusById.clear();
  }

  // ─── Internes ───────────────────────────────────────────────────────────

  void _onAppealEvent(Appeal a) {
    final prev = _lastStatusById[a.id];
    _lastStatusById[a.id] = a.status;

    // On ne notifie que sur les transitions vers un état "résolu".
    if (a.status == AppealStatus.pending) return;
    if (prev == a.status) return; // déjà notifié pour ce statut

    final ctx = _navKey?.currentContext;
    if (ctx == null) {
      // Pas de contexte dispo : on garde la transition en mémoire pour
      // ne pas la renotifier plus tard, mais on skip l'UI.
      if (kDebugMode) {
        debugPrint(
          '[CasPratiqueAppealsListener] no context to notify (appeal=${a.id}, '
          'status=${a.status.name})',
        );
      }
      return;
    }

    switch (a.status) {
      case AppealStatus.approved:
        AppNotifier.success(
          ctx,
          title: 'Appel approuvé 🎉',
          message: (a.adminResponse != null && a.adminResponse!.isNotEmpty)
              ? a.adminResponse!
              : 'Un correcteur a validé ton appel. Ton score peut être ajusté.',
          duration: const Duration(seconds: 5),
        );
        break;
      case AppealStatus.rejected:
        AppNotifier.warning(
          ctx,
          title: 'Appel rejeté',
          message: (a.adminResponse != null && a.adminResponse!.isNotEmpty)
              ? a.adminResponse!
              : 'Après examen, l\'équipe pédagogique n\'a pas retenu ton appel.',
          duration: const Duration(seconds: 5),
        );
        break;
      case AppealStatus.pending:
        // Cas déjà filtré au-dessus, on ne fait rien.
        break;
    }
  }
}
