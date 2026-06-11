// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Page DYNAMIQUE (orchestrateur)                ║
// ║  Référence : docs/cas_pratique/05_DESIGN_SYSTEM.md (flow utilisateur)   ║
// ║  Tâches    : CODE-033 + CODE-034 + CODE-035 + CODE-036                  ║
// ║                                                                         ║
// ║  Cette page remplace les 6 fichiers case_X_page.dart legacy. Elle      ║
// ║  reçoit un argument de route `caseSlug` et :                            ║
// ║    1. Fetch le CaseDetail via le repository                             ║
// ║    2. Affiche un skeleton premium pendant le chargement                 ║
// ║    3. Orchestre un PageController :                                     ║
// ║       Page 0 : Intro (CODE-034)                                         ║
// ║       Page 1 : Texte du cas (CODE-034)                                  ║
// ║       Page 2..N+1 : Questions (CODE-035) — auto-save + lock back        ║
// ║       Page N+2 : Correction (CODE-036) — engine + ScoreReveal + Pills   ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/engine/correction_engine.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/answer_text_area.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/appeal_sheet.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/cas_pratique_scaffold.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/point_pill.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/score_reveal.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_exception.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository_impl.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart';

class CasPratiqueDynamicPage extends StatefulWidget {
  const CasPratiqueDynamicPage({super.key, this.caseSlug});

  static const String routeName = '/gpx_exam/concours/cas_pratique/case_dynamic';

  /// Slug ou ID du cas. Si null, on regarde les arguments de route.
  final String? caseSlug;

  @override
  State<CasPratiqueDynamicPage> createState() => _CasPratiqueDynamicPageState();
}

class _CasPratiqueDynamicPageState extends State<CasPratiqueDynamicPage> {
  // ─── Dépendances ────────────────────────────────────────────────────────
  final CasPratiqueRepository _repo = CasPratiqueRepositoryImpl();
  final CorrectionEngine _engine = CorrectionEngine();
  final PageController _pc = PageController();

  // ─── État principal ─────────────────────────────────────────────────────
  String? _slug;
  CaseDetail? _detail;
  Attempt? _attempt;
  Object? _loadError;
  bool _loading = true;
  int _index = 0;

  /// Stopwatch pour mesurer le temps total passé (envoyé au moteur).
  final Stopwatch _stopwatch = Stopwatch();

  /// Map question_id → controller texte (un par question).
  final Map<String, TextEditingController> _controllers = {};

  /// Map question_id → listener attaché au controller (pour disposal propre).
  final Map<String, VoidCallback> _listeners = {};

  /// Map question_id → état autosave (idle / typing / saving / saved / error).
  final Map<String, AnswerSaveState> _saveStates = {};

  /// Map question_id → DateTime du dernier save réussi.
  final Map<String, DateTime?> _lastSavedAt = {};

  /// Map question_id → Timer debounce courant.
  final Map<String, Timer?> _debouncers = {};

  /// Map question_id → bool "déjà validée".
  final Map<String, bool> _validatedByQuestionId = {};

  /// Set des question_id en cours de validation (UI loading).
  final Set<String> _validatingIds = {};

  /// Index minimal vers lequel on a le droit de revenir.
  /// Lock après validation pour empêcher la triche.
  int _minBackIndex = 0;

  // ─── État correction (page finale) ──────────────────────────────────────
  Correction? _correction;
  bool _correctionLoading = false;
  Object? _correctionError;
  bool _correctionTriggered = false;

  // ─── État système d'appel (CODE-043) ───────────────────────────────────
  /// Ids de correction_details pour lesquels un appel a déjà été envoyé
  /// (évite les doubles soumissions UI).
  final Set<String> _appealedDetailIds = <String>{};

  /// Détails en cours d'envoi (spinner).
  final Set<String> _appealInFlightIds = <String>{};

  // ─── Constantes locales ─────────────────────────────────────────────────
  static const Duration _kAutosaveDebounce = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _stopwatch.stop();
    for (final t in _debouncers.values) {
      t?.cancel();
    }
    for (final entry in _controllers.entries) {
      final l = _listeners[entry.key];
      if (l != null) entry.value.removeListener(l);
      entry.value.dispose();
    }
    _pc.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  BOOTSTRAP
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _bootstrap() async {
    final argSlug = widget.caseSlug ??
        (ModalRoute.of(context)?.settings.arguments is String
            ? ModalRoute.of(context)!.settings.arguments as String
            : null);
    if (argSlug == null || argSlug.isEmpty) {
      setState(() {
        _loading = false;
        _loadError = const CasPratiqueException(
          code: CasPratiqueErrorCode.caseNotFound,
          message: 'Aucun cas spécifié.',
        );
      });
      return;
    }
    _slug = argSlug;
    await _loadCase(argSlug);
  }

  Future<void> _loadCase(String slug) async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final detail = await _repo.getCaseDetail(slug);

      Attempt? attempt;
      try {
        attempt = await _repo.getActiveAttempt(detail.summary.id) ??
            await _repo.startAttempt(detail.summary.id);
      } catch (_) {
        // L'utilisateur n'est peut-être pas connecté : on continue en consultation
        attempt = null;
      }

      // Initialiser les controllers pour chaque question
      _initControllers(detail);

      // Si on a une attempt, on hydrate les réponses existantes (reprise)
      if (attempt != null) {
        await _hydrateExistingAnswers(attempt.id, detail);
      }

      if (!mounted) return;
      setState(() {
        _detail = detail;
        _attempt = attempt;
        _loading = false;
      });
      _stopwatch.reset();
      _stopwatch.start();
    } on CasPratiqueException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = CasPratiqueException.unknown(e);
      });
    }
  }

  void _initControllers(CaseDetail detail) {
    for (final q in detail.questions) {
      final ctrl = TextEditingController();
      _controllers[q.id] = ctrl;
      _saveStates[q.id] = AnswerSaveState.idle;
      _lastSavedAt[q.id] = null;
      _validatedByQuestionId[q.id] = false;

      // Listener pour autosave debounced
      void listener() {
        // Si déjà validée, on ignore les modifications (read-only)
        if (_validatedByQuestionId[q.id] == true) return;
        // Repasse en typing puis schedule
        if (_saveStates[q.id] != AnswerSaveState.typing) {
          setState(() => _saveStates[q.id] = AnswerSaveState.typing);
        }
        _scheduleAutosave(q.id, q.position);
      }

      _listeners[q.id] = listener;
      ctrl.addListener(listener);
    }
  }

  Future<void> _hydrateExistingAnswers(String attemptId, CaseDetail detail) async {
    try {
      final existing = await _repo.listAnswersForAttempt(attemptId);
      if (existing.isEmpty) return;

      // Index des questions par id pour retrouver leur position
      final qById = {for (final q in detail.questions) q.id: q};

      // On trouve l'index max d'une question validée pour le lock back
      int maxValidatedPageIndex = -1;

      for (final a in existing) {
        final qid = a.questionId;
        if (qid == null) continue;
        final ctrl = _controllers[qid];
        if (ctrl == null) continue;
        ctrl.text = a.text;
        if (a.status == AnswerStatus.validated) {
          _validatedByQuestionId[qid] = true;
          _saveStates[qid] = AnswerSaveState.saved;
          _lastSavedAt[qid] = a.updatedAt;
          final q = qById[qid];
          if (q != null) {
            // Page d'une question = 2 + (position - 1) → on prend max
            final pageIndex = 2 + (q.position - 1);
            if (pageIndex > maxValidatedPageIndex) {
              maxValidatedPageIndex = pageIndex;
            }
          }
        } else {
          _saveStates[qid] = AnswerSaveState.saved;
          _lastSavedAt[qid] = a.updatedAt;
        }
      }

      if (maxValidatedPageIndex >= 0) {
        // On bloque le retour jusqu'à la première question NON validée
        _minBackIndex = maxValidatedPageIndex + 1;
      }
    } catch (_) {
      // Pas grave : on continue sans hydratation
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  AUTOSAVE — Debounced 1.5s
  // ═══════════════════════════════════════════════════════════════════════

  void _scheduleAutosave(String questionId, int position) {
    _debouncers[questionId]?.cancel();
    _debouncers[questionId] = Timer(_kAutosaveDebounce, () {
      _doSave(questionId, position);
    });
  }

  Future<void> _doSave(String questionId, int position) async {
    final attempt = _attempt;
    final detail = _detail;
    if (attempt == null || detail == null) {
      // Pas connecté → on ne sauve pas en remote, mais on indique "saved"
      // localement pour ne pas frustrer l'utilisateur (la donnée est dans le controller).
      if (!mounted) return;
      setState(() {
        _saveStates[questionId] = AnswerSaveState.idle;
      });
      return;
    }
    final ctrl = _controllers[questionId];
    if (ctrl == null) return;
    final text = ctrl.text;

    if (!mounted) return;
    setState(() => _saveStates[questionId] = AnswerSaveState.saving);

    try {
      await _repo.saveDraftAnswer(
        attemptId: attempt.id,
        caseSlugLegacy: detail.summary.slug,
        questionId: questionId,
        questionIndex: position,
        text: text,
      );
      if (!mounted) return;
      setState(() {
        _saveStates[questionId] = AnswerSaveState.saved;
        _lastSavedAt[questionId] = DateTime.now();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _saveStates[questionId] = AnswerSaveState.error);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  VALIDATION D'UNE QUESTION
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _onValidateQuestion(Question question, int pageIndex) async {
    final attempt = _attempt;
    final detail = _detail;
    final ctrl = _controllers[question.id];
    if (ctrl == null || detail == null) return;

    final text = ctrl.text.trim();
    if (text.isEmpty) {
      HapticFeedback.lightImpact();
      _showSnack('Écris une réponse avant de valider.');
      return;
    }
    if (text.length < question.charMin) {
      HapticFeedback.lightImpact();
      _showSnack(
        'Ta réponse fait ${text.length} caractères : '
        'au moins ${question.charMin} sont attendus.',
      );
      return;
    }

    // On annule le debounce d'autosave : on va faire un upsert validé direct
    _debouncers[question.id]?.cancel();

    if (!mounted) return;
    setState(() {
      _validatingIds.add(question.id);
      _saveStates[question.id] = AnswerSaveState.saving;
    });

    try {
      if (attempt != null) {
        await _repo.validateAnswer(
          attemptId: attempt.id,
          caseSlugLegacy: detail.summary.slug,
          questionId: question.id,
          questionIndex: question.position,
          text: text,
        );
      }
      if (!mounted) return;
      setState(() {
        _validatedByQuestionId[question.id] = true;
        _saveStates[question.id] = AnswerSaveState.saved;
        _lastSavedAt[question.id] = DateTime.now();
        _validatingIds.remove(question.id);
        // Lock back : la prochaine page minimum est celle d'après cette question
        if (pageIndex + 1 > _minBackIndex) _minBackIndex = pageIndex + 1;
      });

      HapticFeedback.mediumImpact();
      _goNext();
    } on CasPratiqueException catch (e) {
      if (!mounted) return;
      setState(() {
        _validatingIds.remove(question.id);
        _saveStates[question.id] = AnswerSaveState.error;
      });
      _showSnack(CasPratiqueErrorMessages.of(e.code));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _validatingIds.remove(question.id);
        _saveStates[question.id] = AnswerSaveState.error;
      });
      _showSnack('Impossible de valider la réponse. Réessaie.');
    }
  }

  /// Notification standard via AppNotifier — auto-route selon le contenu.
  /// Garde la signature legacy `_showSnack(msg)` pour minimiser les diffs.
  void _showSnack(String msg) {
    if (!mounted) return;
    // Heuristique : detection du kind à partir du texte du message
    final lower = msg.toLowerCase();
    final isError = lower.contains('impossible') ||
        lower.contains('erreur') ||
        lower.contains('échec') ||
        lower.contains('failed');
    final isInfo = lower.contains('plus revenir');
    if (isError) {
      AppNotifier.error(context, title: 'Oups', message: msg);
    } else if (isInfo) {
      AppNotifier.info(context, title: 'Information', message: msg);
    } else {
      AppNotifier.warning(context, title: 'Attention', message: msg);
    }
  }
  // ═══════════════════════════════════════════════════════════════════════
  //  CORRECTION (déclenchée à l'arrivée sur la page finale)
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _runCorrectionIfNeeded() async {
    if (_correctionTriggered) return;
    _correctionTriggered = true;
    final attempt = _attempt;
    final detail = _detail;
    if (attempt == null || detail == null) {
      setState(() {
        _correctionError = const CasPratiqueException(
          code: CasPratiqueErrorCode.notAuthenticated,
          message: 'Connecte-toi pour obtenir ta correction.',
        );
      });
      return;
    }

    setState(() {
      _correctionLoading = true;
      _correctionError = null;
    });

    _stopwatch.stop();
    final timeSpentMs = _stopwatch.elapsedMilliseconds;

    final answersByQuestionId = <String, String>{
      for (final q in detail.questions)
        q.id: (_controllers[q.id]?.text ?? '').trim(),
    };

    try {
      final corr = await _engine.correct(
        attemptId: attempt.id,
        caseId: detail.summary.id,
        answersByQuestionId: answersByQuestionId,
        timeSpentMs: timeSpentMs,
      );
      if (!mounted) return;
      setState(() {
        _correction = corr;
        _correctionLoading = false;
      });
      // Invalide le cache (l'attempt est completed → la prochaine liste doit
      // refléter le nouveau best_score)
      try {
        await _repo.refreshCache();
      } catch (_) {/* ignore */}
    } on CasPratiqueException catch (e) {
      if (!mounted) return;
      setState(() {
        _correctionError = e;
        _correctionLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _correctionError = CasPratiqueException.unknown(e);
        _correctionLoading = false;
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  CODE-043 — APPEL d'un point manqué
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _onAppealRequest(CorrectionDetail d, Question q) async {
    if (d.id.isEmpty) {
      _showSnack('Impossible de faire appel sur ce point.');
      return;
    }
    if (_appealedDetailIds.contains(d.id) ||
        _appealInFlightIds.contains(d.id)) {
      return;
    }
    final userAnswer = _controllers[q.id]?.text.trim();
    final message = await showAppealSheet(
      context: context,
      pointLabel: d.pointLabel.isEmpty ? 'Point manqué' : d.pointLabel,
      pointExplanation: d.explanationMd,
      userAnswerPreview:
          (userAnswer == null || userAnswer.isEmpty) ? null : userAnswer,
    );
    if (message == null || message.trim().isEmpty) return;
    if (!mounted) return;
    setState(() => _appealInFlightIds.add(d.id));
    try {
      await _repo.createAppeal(
        correctionDetailId: d.id,
        message: message.trim(),
      );
      if (!mounted) return;
      setState(() {
        _appealInFlightIds.remove(d.id);
        _appealedDetailIds.add(d.id);
      });
      HapticFeedback.lightImpact();
      _showSnack(
        'Appel envoyé. L\'équipe pédagogique va l\'examiner.',
      );
    } on CasPratiqueException catch (e) {
      if (!mounted) return;
      setState(() => _appealInFlightIds.remove(d.id));
      _showSnack(CasPratiqueErrorMessages.of(e.code));
    } catch (_) {
      if (!mounted) return;
      setState(() => _appealInFlightIds.remove(d.id));
      _showSnack('Impossible d\'envoyer ton appel. Réessaie.');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════

  void _goNext() {
    HapticFeedback.selectionClick();
    _pc.nextPage(
      duration: CpTokens.animPage,
      curve: Curves.easeOutCubic,
    );
  }

  void _goPrev() {
    HapticFeedback.selectionClick();
    final target = _index - 1;
    if (target < _minBackIndex) {
      _showSnack('Tu ne peux plus revenir en arrière après validation.');
      return;
    }
    _pc.previousPage(
      duration: CpTokens.animPage,
      curve: Curves.easeOutCubic,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _SkeletonScaffold();
    }
    if (_loadError != null || _detail == null) {
      return _ErrorScaffold(
        error: _loadError,
        onRetry: _slug == null ? null : () => _loadCase(_slug!),
      );
    }

    final detail = _detail!;
    final pages = _buildPageList(detail);
    final qCount = detail.questions.length;
    final isOnCorrection = _index == qCount + 2;
    // Pas de bouton retour sur la page de correction (lock par design).
    // Sinon, on n'affiche le retour que si la page précédente est encore
    // accessible (au-dessus du verrou de validation).
    final showBack =
        _index > 0 && !isOnCorrection && (_index - 1) >= _minBackIndex;

    return CasPratiqueScaffold(
      title: _titleForIndex(_index, detail),
      subtitle: _subtitleForIndex(_index, detail),
      canGoBack: showBack,
      onBack: showBack ? _goPrev : null,
      // CODE-045 : sur la page correction, on offre un raccourci vers "Mes appels".
      rightAction: isOnCorrection
          ? _MyAppealsTopAction(
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pushNamed(
                  '/gpx_exam/concours/cas_pratique/my_appeals',
                );
              },
            )
          : null,
      body: PageView(
        controller: _pc,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) {
          setState(() => _index = i);
          // Arrivée sur la page correction → on déclenche
          if (i == qCount + 2) {
            _runCorrectionIfNeeded();
          }
        },
        children: pages,
      ),
    );
  }

  String _titleForIndex(int i, CaseDetail d) {
    final qCount = d.questions.length;
    if (i == 0) return d.summary.title;
    if (i == 1) return 'Le cas';
    if (i >= 2 && i < 2 + qCount) return 'Question ${i - 1} / $qCount';
    return 'Correction';
  }

  String? _subtitleForIndex(int i, CaseDetail d) {
    if (i == 0) {
      final year = d.summary.year;
      final month = d.summary.month;
      if (month != null && month.isNotEmpty) {
        return '$month $year';
      }
      return '$year';
    }
    return null;
  }

  List<Widget> _buildPageList(CaseDetail d) {
    return [
      _IntroPage(detail: d, onStart: _goNext),
      _TextPage(detail: d, onStart: _goNext),
      for (int i = 0; i < d.questions.length; i++)
        _QuestionPage(
          question: d.questions[i],
          index: i,
          total: d.questions.length,
          controller: _controllers[d.questions[i].id]!,
          saveState: _saveStates[d.questions[i].id] ?? AnswerSaveState.idle,
          lastSavedAt: _lastSavedAt[d.questions[i].id],
          isValidated: _validatedByQuestionId[d.questions[i].id] ?? false,
          isValidating: _validatingIds.contains(d.questions[i].id),
          onValidate: () => _onValidateQuestion(d.questions[i], 2 + i),
        ),
      _CorrectionPage(
        detail: d,
        correction: _correction,
        loading: _correctionLoading,
        error: _correctionError,
        appealedDetailIds: _appealedDetailIds,
        onAppeal: _onAppealRequest,
        onBackToList: () {
          HapticFeedback.selectionClick();
          // Pop jusqu'à la liste des cas si possible, sinon root
          Navigator.of(context).maybePop();
        },
        onRetry: () {
          _correctionTriggered = false;
          _runCorrectionIfNeeded();
        },
      ),
    ];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  SKELETON LOADER (CODE-033)
// ═══════════════════════════════════════════════════════════════════════════

class _SkeletonScaffold extends StatefulWidget {
  @override
  State<_SkeletonScaffold> createState() => _SkeletonScaffoldState();
}

class _SkeletonScaffoldState extends State<_SkeletonScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CasPratiqueScaffold(
      title: 'Chargement du cas…',
      body: Padding(
        padding: const EdgeInsets.all(CpTokens.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SkeletonBox(controller: _ctrl, height: 36, widthFactor: 0.7),
            const SizedBox(height: CpTokens.s4),
            _SkeletonBox(controller: _ctrl, height: 20, widthFactor: 0.5),
            const SizedBox(height: CpTokens.s7),
            _SkeletonBox(controller: _ctrl, height: 120, widthFactor: 1.0),
            const SizedBox(height: CpTokens.s5),
            _SkeletonBox(controller: _ctrl, height: 16, widthFactor: 0.9),
            const SizedBox(height: CpTokens.s2),
            _SkeletonBox(controller: _ctrl, height: 16, widthFactor: 0.85),
            const SizedBox(height: CpTokens.s2),
            _SkeletonBox(controller: _ctrl, height: 16, widthFactor: 0.7),
            const Spacer(),
            _SkeletonBox(controller: _ctrl, height: 56, widthFactor: 1.0),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.controller,
    required this.height,
    required this.widthFactor,
  });

  final AnimationController controller;
  final double height;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06 + 0.06 * controller.value),
                borderRadius: BorderRadius.circular(CpTokens.r2),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  ERROR SCAFFOLD (CODE-033)
// ═══════════════════════════════════════════════════════════════════════════

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback? onRetry;

  String get _message {
    if (error is CasPratiqueException) {
      return CasPratiqueErrorMessages.of((error as CasPratiqueException).code);
    }
    return 'Une erreur est survenue.';
  }

  @override
  Widget build(BuildContext context) {
    return CasPratiqueScaffold(
      title: 'Cas introuvable',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(CpTokens.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                color: Colors.white70,
                size: 64,
              ),
              const SizedBox(height: CpTokens.s5),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.94),
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: CpTokens.s6),
              if (onRetry != null)
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: CpTokens.darkNavy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(CpTokens.r3),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: CpTokens.s7,
                      vertical: CpTokens.s4,
                    ),
                  ),
                  child: Text(
                    'Réessayer',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  INTRO PAGE (CODE-034)
// ═══════════════════════════════════════════════════════════════════════════

class _IntroPage extends StatelessWidget {
  const _IntroPage({required this.detail, required this.onStart});

  final CaseDetail detail;
  final VoidCallback onStart;

  String _difficultyLabel() {
    switch (detail.summary.difficulty) {
      case CpDifficulty.facile:    return 'Facile';
      case CpDifficulty.difficile: return 'Difficile';
      case CpDifficulty.moyen:     return 'Moyen';
    }
  }

  Color _difficultyColor() {
    switch (detail.summary.difficulty) {
      case CpDifficulty.facile:    return CpTokens.success;
      case CpDifficulty.difficile: return CpTokens.danger;
      case CpDifficulty.moyen:     return CpTokens.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = detail.summary.theme;
    final diffColor = _difficultyColor();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s6, CpTokens.s5, CpTokens.s6, CpTokens.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: CpTokens.s4),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (theme != null) _Pill(label: theme.label, color: Colors.white),
              _Pill(label: _difficultyLabel(), color: diffColor),
            ],
          ),
          const SizedBox(height: CpTokens.s6),
          Text(
            detail.summary.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: CpTokens.s3),
          Text(
            '${detail.questions.length} question${detail.questions.length > 1 ? 's' : ''}'
            '  ·  environ ${detail.summary.estimatedMinutes} min'
            '  ·  ${detail.summary.totalPoints} pts',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: CpTokens.s7),
          const _InfoLine(text: 'Lecture immersive du scénario'),
          const SizedBox(height: CpTokens.s2),
          const _InfoLine(text: 'Structure claire de réponse'),
          const SizedBox(height: CpTokens.s2),
          const _InfoLine(text: 'Correction expliquée point par point'),
          const SizedBox(height: CpTokens.s8),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: CpTokens.darkNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CpTokens.r3),
                ),
                elevation: 0,
              ),
              child: Text(
                'Lire le scénario',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CpTokens.s4, vertical: CpTokens.s2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(CpTokens.rPill),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Colors.white.withValues(alpha: 0.92);
    return Row(
      children: [
        Icon(Icons.check_circle_rounded, size: 18, color: c),
        const SizedBox(width: CpTokens.s3),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: c,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  TEXT PAGE (CODE-034)
// ═══════════════════════════════════════════════════════════════════════════

class _TextPage extends StatelessWidget {
  const _TextPage({required this.detail, required this.onStart});
  final CaseDetail detail;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CpTokens.s6, CpTokens.s5, CpTokens.s6, CpTokens.s5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                detail.situationText,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.94),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
            ),
          ),
          const SizedBox(height: CpTokens.s5),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: CpTokens.darkNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CpTokens.r3),
                ),
              ),
              child: Text(
                'Je commence',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  QUESTION PAGE (CODE-035) — AnswerTextArea + autosave + lock
// ═══════════════════════════════════════════════════════════════════════════

class _QuestionPage extends StatelessWidget {
  const _QuestionPage({
    required this.question,
    required this.index,
    required this.total,
    required this.controller,
    required this.saveState,
    required this.lastSavedAt,
    required this.isValidated,
    required this.isValidating,
    required this.onValidate,
  });

  final Question question;
  final int index;
  final int total;
  final TextEditingController controller;
  final AnswerSaveState saveState;
  final DateTime? lastSavedAt;
  final bool isValidated;
  final bool isValidating;
  final VoidCallback onValidate;

  bool get _isLast => index + 1 >= total;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            CpTokens.s6, CpTokens.s4, CpTokens.s6, CpTokens.s6,
          ),
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header petit : "QUESTION N / TOTAL · X pts"
              Row(
                children: [
                  Text(
                    'QUESTION ${index + 1} / $total',
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${question.maxPoints} pts',
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (isValidated) ...[
                    const Spacer(),
                    _ValidatedPill(),
                  ],
                ],
              ),
              const SizedBox(height: CpTokens.s3),
              // Label de la question
              Text(
                question.label,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  height: 1.28,
                  letterSpacing: -0.3,
                ),
              ),
              if (question.hint != null && question.hint!.trim().isNotEmpty) ...[
                const SizedBox(height: CpTokens.s2),
                _HintBlock(text: question.hint!),
              ],
              const SizedBox(height: CpTokens.s5),
              // Textarea
              AnswerTextArea(
                controller: controller,
                charMin: question.charMin,
                charRecommended: question.charRecommended,
                saveState: saveState,
                lastSavedAt: lastSavedAt,
                enabled: !isValidated && !isValidating,
              ),
              const SizedBox(height: CpTokens.s6),
              // Bouton valider
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: (isValidated || isValidating) ? null : onValidate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: CpTokens.darkNavy,
                    disabledBackgroundColor:
                        Colors.white.withValues(alpha: isValidated ? 0.55 : 0.35),
                    disabledForegroundColor: CpTokens.darkNavy.withValues(alpha: 0.55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(CpTokens.r3),
                    ),
                    elevation: 0,
                  ),
                  child: isValidating
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor:
                                AlwaysStoppedAnimation(CpTokens.darkNavy),
                          ),
                        )
                      : Text(
                          isValidated
                              ? 'Réponse validée ✓'
                              : (_isLast
                                  ? 'Valider et corriger'
                                  : 'Valider et continuer'),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: CpTokens.s3),
              if (!isValidated)
                Text(
                  'Une fois validée, tu ne pourras plus modifier cette réponse.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValidatedPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: CpTokens.success.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(CpTokens.rPill),
        border: Border.all(color: CpTokens.success.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 12, color: CpTokens.success),
          const SizedBox(width: 4),
          Text(
            'Validée',
            style: GoogleFonts.montserrat(
              color: CpTokens.success,
              fontWeight: FontWeight.w900,
              fontSize: 10.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HintBlock extends StatelessWidget {
  const _HintBlock({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CpTokens.s4, vertical: CpTokens.s3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(CpTokens.r2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 16,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          const SizedBox(width: CpTokens.s2),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  CORRECTION PAGE (CODE-036) — Engine + ScoreReveal + PointPills
// ═══════════════════════════════════════════════════════════════════════════

class _CorrectionPage extends StatelessWidget {
  const _CorrectionPage({
    required this.detail,
    required this.correction,
    required this.loading,
    required this.error,
    required this.appealedDetailIds,
    required this.onAppeal,
    required this.onBackToList,
    required this.onRetry,
  });

  final CaseDetail detail;
  final Correction? correction;
  final bool loading;
  final Object? error;
  final Set<String> appealedDetailIds;
  final Future<void> Function(CorrectionDetail d, Question q) onAppeal;
  final VoidCallback onBackToList;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const _CorrectionLoading();
    }
    if (error != null || correction == null) {
      return _CorrectionError(
        error: error,
        onRetry: onRetry,
        onBackToList: onBackToList,
      );
    }
    return _CorrectionContent(
      detail: detail,
      correction: correction!,
      appealedDetailIds: appealedDetailIds,
      onAppeal: onAppeal,
      onBackToList: onBackToList,
    );
  }
}

class _CorrectionLoading extends StatelessWidget {
  const _CorrectionLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CpTokens.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 56, height: 56,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
            const SizedBox(height: CpTokens.s6),
            Text(
              'On corrige ta copie…',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: CpTokens.s2),
            Text(
              'Analyse de chaque réponse, mots-clés, formulations…',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectionError extends StatelessWidget {
  const _CorrectionError({
    required this.error,
    required this.onRetry,
    required this.onBackToList,
  });

  final Object? error;
  final VoidCallback onRetry;
  final VoidCallback onBackToList;

  String get _message {
    if (error is CasPratiqueException) {
      return CasPratiqueErrorMessages.of((error as CasPratiqueException).code);
    }
    return 'Une erreur est survenue pendant la correction.';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CpTokens.s6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 56,
            color: Colors.white70,
          ),
          const SizedBox(height: CpTokens.s4),
          Text(
            'Correction impossible',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: CpTokens.s2),
          Text(
            _message,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.82),
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: CpTokens.s6),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: CpTokens.darkNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CpTokens.r3),
                ),
              ),
              child: Text(
                'Réessayer',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: CpTokens.s3),
          TextButton(
            onPressed: onBackToList,
            child: Text(
              'Retour à la liste',
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.88),
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrectionContent extends StatelessWidget {
  const _CorrectionContent({
    required this.detail,
    required this.correction,
    required this.appealedDetailIds,
    required this.onAppeal,
    required this.onBackToList,
  });

  final CaseDetail detail;
  final Correction correction;
  final Set<String> appealedDetailIds;
  final Future<void> Function(CorrectionDetail d, Question q) onAppeal;
  final VoidCallback onBackToList;

  @override
  Widget build(BuildContext context) {
    final byQuestion = correction.detailsByQuestion;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              CpTokens.s6, CpTokens.s2, CpTokens.s6, CpTokens.s6,
            ),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Score reveal ────────────────────────────────────────
                Center(
                  child: ScoreReveal(
                    score: correction.totalScore,
                    maxScore: correction.totalMax,
                  ),
                ),
                const SizedBox(height: CpTokens.s7),
                // ─── Détail par question ─────────────────────────────────
                for (int i = 0; i < detail.questions.length; i++)
                  _QuestionDetailBlock(
                    question: detail.questions[i],
                    index: i,
                    details: byQuestion[detail.questions[i].id] ?? const [],
                    appealedDetailIds: appealedDetailIds,
                    onAppeal: onAppeal,
                  ),
                const SizedBox(height: CpTokens.s4),
                _LegalFooter(version: correction.engineVersion),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            CpTokens.s6, 0, CpTokens.s6, CpTokens.s5,
          ),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: onBackToList,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: CpTokens.darkNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CpTokens.r3),
                ),
                elevation: 0,
              ),
              child: Text(
                'Retour à la liste',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter({required this.version});
  final String version;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Moteur de correction v$version',
        style: GoogleFonts.montserrat(
          color: Colors.white.withValues(alpha: 0.48),
          fontWeight: FontWeight.w700,
          fontSize: 10.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _QuestionDetailBlock extends StatelessWidget {
  const _QuestionDetailBlock({
    required this.question,
    required this.index,
    required this.details,
    required this.appealedDetailIds,
    required this.onAppeal,
  });

  final Question question;
  final int index;
  final List<CorrectionDetail> details;
  final Set<String> appealedDetailIds;
  final Future<void> Function(CorrectionDetail d, Question q) onAppeal;

  double get _totalScore => details.fold(0.0, (s, d) => s + d.score);
  double get _totalWeight => details.fold(0.0, (s, d) => s + d.weight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CpTokens.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête question
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: CpTokens.s3),
              Expanded(
                child: Text(
                  question.label,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: CpTokens.s3),
              _ScoreBadge(score: _totalScore, max: _totalWeight),
            ],
          ),
          const SizedBox(height: CpTokens.s4),
          // Liste des PointPills
          if (details.isEmpty)
            _EmptyDetails()
          else
            for (final d in details)
              Padding(
                padding: const EdgeInsets.only(bottom: CpTokens.s2),
                child: PointPill(
                  label: d.pointLabel.isEmpty
                      ? 'Point ${details.indexOf(d) + 1}'
                      : d.pointLabel,
                  status: d.status,
                  score: d.score,
                  weight: d.weight,
                  explanationMd: _explanationWithAppealSuffix(d),
                  matchedKeywords: _extractMatched(d.groupMatches),
                  // CODE-043 : on autorise l'appel sur les points manqués
                  // qui ont un id réel (les corrections fraîches l'ont) et
                  // qui n'ont pas encore fait l'objet d'un appel.
                  canAppeal: d.status == PointStatus.missing &&
                      d.id.isNotEmpty &&
                      !appealedDetailIds.contains(d.id),
                  onAppeal: () => onAppeal(d, question),
                ),
              ),
          // Section "Réponse parfaite" si dispo
          if (question.perfectAnswer != null) ...[
            const SizedBox(height: CpTokens.s3),
            _PerfectAnswerSection(answer: question.perfectAnswer!),
          ],
        ],
      ),
    );
  }

  /// Suffixe l'explication avec une mention "Appel envoyé" si nécessaire
  /// pour rappeler à l'utilisateur qu'il a déjà fait appel (le bouton est
  /// retiré côté UI mais on garde une trace claire).
  String? _explanationWithAppealSuffix(CorrectionDetail d) {
    final base = d.explanationMd ?? '';
    final wasAppealed = appealedDetailIds.contains(d.id);
    if (!wasAppealed) return base.isEmpty ? null : base;
    const suffix = '\n\n📨 Appel envoyé. L\'équipe pédagogique va l\'examiner.';
    return base.isEmpty ? suffix.trim() : base + suffix;
  }

  List<String> _extractMatched(List<Map<String, dynamic>> groupMatches) {
    final out = <String>{};
    for (final g in groupMatches) {
      final matched = (g['matched_keywords'] as List?) ?? const [];
      for (final m in matched) {
        if (m is String && m.trim().isNotEmpty) out.add(m);
      }
    }
    return out.toList();
  }
}

class _EmptyDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CpTokens.s4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(CpTokens.r2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 18),
          const SizedBox(width: CpTokens.s3),
          Expanded(
            child: Text(
              'Pas de détail de correction pour cette question.',
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.86),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score, required this.max});
  final double score;
  final double max;

  Color _color() {
    if (max == 0) return CpTokens.warning;
    final pct = (score / max) * 100;
    if (pct >= 70) return CpTokens.success;
    if (pct >= 30) return CpTokens.warning;
    return CpTokens.danger;
  }

  String _fmt(double v) => v == v.toInt() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(CpTokens.rPill),
        border: Border.all(color: c.withValues(alpha: 0.55)),
      ),
      child: Text(
        '${_fmt(score)} / ${_fmt(max)}',
        style: GoogleFonts.montserrat(
          color: c,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _PerfectAnswerSection extends StatefulWidget {
  const _PerfectAnswerSection({required this.answer});
  final PerfectAnswer answer;

  @override
  State<_PerfectAnswerSection> createState() => _PerfectAnswerSectionState();
}

class _PerfectAnswerSectionState extends State<_PerfectAnswerSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = CpTokens.surface(isDark);
    final onSurface = CpTokens.onSurface(isDark);
    final onSurfaceMuted = CpTokens.onSurfaceMuted(isDark);
    final infoColor = CpTokens.infoFor(isDark);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(color: infoColor.withValues(alpha: 0.32)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        child: InkWell(
          borderRadius: BorderRadius.circular(CpTokens.r3),
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              CpTokens.s4, CpTokens.s3, CpTokens.s4, CpTokens.s3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: infoColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: infoColor, size: 18,
                      ),
                    ),
                    const SizedBox(width: CpTokens.s3),
                    Expanded(
                      child: Text(
                        'Réponse modèle',
                        style: GoogleFonts.montserrat(
                          color: onSurface,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: _expanded ? 0.5 : 0.0,
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: onSurfaceMuted,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                SizeTransition(
                  sizeFactor: _anim,
                  axisAlignment: -1.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: CpTokens.s3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.answer.bodyMd,
                          style: GoogleFonts.montserrat(
                            color: onSurfaceMuted,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                        if (widget.answer.referencesLegal.isNotEmpty) ...[
                          const SizedBox(height: CpTokens.s3),
                          Text(
                            'Références',
                            style: GoogleFonts.montserrat(
                              color: onSurface,
                              fontWeight: FontWeight.w900,
                              fontSize: 11.5,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final r in widget.answer.referencesLegal)
                                _LegalChip(reference: r, color: infoColor),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalChip extends StatelessWidget {
  const _LegalChip({required this.reference, required this.color});
  final LegalReference reference;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = reference.label != null && reference.label!.isNotEmpty
        ? reference.label!
        : 'Art. ${reference.article} — ${reference.code.toUpperCase()}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(CpTokens.rPill),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 10.5,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  TOP ACTION : "Mes appels" (CODE-045)
// ═══════════════════════════════════════════════════════════════════════════

class _MyAppealsTopAction extends StatelessWidget {
  const _MyAppealsTopAction({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Mes appels',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.gavel_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.92),
              ),
              const SizedBox(width: 5),
              Text(
                'Mes appels',
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 11.5,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
