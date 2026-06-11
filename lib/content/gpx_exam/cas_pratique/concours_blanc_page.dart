// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Page CONCOURS BLANC (mode timer)              ║
// ║  Tâche      : CODE-061                                                  ║
// ║                                                                         ║
// ║  Mode "épreuve réelle" :                                                ║
// ║   - Countdown 45 min imposé (configurable côté DB)                      ║
// ║   - Verrouillage strict : pas de retour arrière entre questions        ║
// ║   - Autosave debounce 2s par réponse (RLS bloquera après deadline)     ║
// ║   - Auto-submit quand le timer atteint 0                                 ║
// ║   - Confirmation explicite avant submit manuel                          ║
// ║   - Sortie de la page = abandon (warning AlertDialog)                  ║
// ║   - Soumission → bascule sur écran "Soumis ✓"                          ║
// ║                                                                         ║
// ║  Route : `/gpx_exam/concours/cas_pratique/concours_blanc` qui accepte   ║
// ║  en argument l'`id` d'un cas_pratique_mock_exam, OU un Map              ║
// ║  { 'mock_exam_id': '...', 'cases': [CaseDetail] }.                      ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:copiqpolice/core/cas_pratique/mock_exams/mock_exam_service.dart';
import 'package:copiqpolice/core/cas_pratique/theme/cp_tokens.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/answer_text_area.dart';
import 'package:copiqpolice/core/cas_pratique/widgets/cas_pratique_scaffold.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository.dart';
import 'package:copiqpolice/data/cas_pratique/cas_pratique_repository_impl.dart';
import 'package:copiqpolice/data/cas_pratique/models/cas_pratique_models.dart';

class CasPratiqueConcoursBlancPage extends StatefulWidget {
  const CasPratiqueConcoursBlancPage({super.key, this.mockExamId});

  static const String routeName =
      '/gpx_exam/concours/cas_pratique/concours_blanc';

  final String? mockExamId;

  @override
  State<CasPratiqueConcoursBlancPage> createState() =>
      _CasPratiqueConcoursBlancPageState();
}

class _CasPratiqueConcoursBlancPageState
    extends State<CasPratiqueConcoursBlancPage> with WidgetsBindingObserver {
  final CasPratiqueRepository _repo = CasPratiqueRepositoryImpl();
  final MockExamService _mockSvc = MockExamService.instance;

  bool _loading = true;
  Object? _loadError;

  String? _mockExamId;
  MockExamAttempt? _attempt;

  /// Cas chargés (en réalité on charge 1 cas pour l'exemple ; pour un mock
  /// multi-cas, la migration prévoit la jointure cases — à enrichir côté
  /// repo dans une session dédiée).
  CaseDetail? _detail;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, Timer?> _debouncers = {};
  String? _currentQuestionId;
  int _qIndex = 0;

  // Timer global
  Timer? _ticker;
  Duration _remaining = Duration.zero;
  bool _submitting = false;
  bool _submitted = false;
  FinishStatus? _finalStatus;

  static const Duration _kAutosaveDebounce = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    for (final t in _debouncers.values) {
      t?.cancel();
    }
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Si l'app passe en background pendant un concours, on garde le timer
    // (DB-driven via deadline_at) — on resync au resume.
    if (state == AppLifecycleState.resumed && _attempt != null && !_submitted) {
      _recomputeRemaining();
    }
  }

  Future<void> _bootstrap() async {
    final argId = widget.mockExamId ??
        (ModalRoute.of(context)?.settings.arguments is String
            ? ModalRoute.of(context)!.settings.arguments as String
            : null);
    if (argId == null || argId.isEmpty) {
      setState(() {
        _loading = false;
        _loadError = StateError('Aucun mock_exam_id fourni');
      });
      return;
    }
    _mockExamId = argId;
    setState(() {
      _loading = true;
      _loadError = null;
    });

    try {
      // 1) Démarre / reprend l'attempt
      final attempt = await _mockSvc.startOrResume(argId);
      if (attempt == null) {
        throw StateError('Impossible de démarrer le concours blanc.');
      }
      // 2) Charge le premier cas attaché au mock — pour la démo on tente de
      //    récupérer le premier cas du repo (à étendre quand la jointure
      //    cas_pratique_mock_exam_cases sera exposée via repo).
      final cases = await _repo.listCases(limit: 1);
      if (cases.isEmpty) {
        throw StateError('Aucun cas disponible pour ce concours blanc.');
      }
      final detail = await _repo.getCaseDetail(cases.first.slug);

      // 3) Init controllers + autosave per question
      for (final q in detail.questions) {
        final ctrl = TextEditingController();
        _controllers[q.id] = ctrl;
        ctrl.addListener(() => _scheduleAutosave(attempt.attemptId, q.id, ctrl));
      }

      if (!mounted) return;
      setState(() {
        _attempt = attempt;
        _detail = detail;
        _currentQuestionId = detail.questions.first.id;
        _qIndex = 0;
        _loading = false;
      });
      _startTicker();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e;
      });
    }
  }

  // ─── Timer ──────────────────────────────────────────────────────────────

  void _startTicker() {
    _ticker?.cancel();
    _recomputeRemaining();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _recomputeRemaining();
    });
  }

  void _recomputeRemaining() {
    final a = _attempt;
    if (a == null || !mounted) return;
    final r = a.remaining();
    setState(() => _remaining = r);
    if (r == Duration.zero && !_submitted && !_submitting) {
      _autoSubmitOnExpiry();
    }
  }

  Future<void> _autoSubmitOnExpiry() async {
    HapticFeedback.heavyImpact();
    await _doSubmit(reason: 'expired');
  }

  // ─── Autosave ───────────────────────────────────────────────────────────

  void _scheduleAutosave(String attemptId, String questionId, TextEditingController ctrl) {
    _debouncers[questionId]?.cancel();
    _debouncers[questionId] = Timer(_kAutosaveDebounce, () async {
      if (_remaining == Duration.zero || _submitted) return;
      await _mockSvc.saveAnswer(
        mockAttemptId: attemptId,
        questionId: questionId,
        text: ctrl.text,
      );
    });
  }

  // ─── Navigation entre questions ─────────────────────────────────────────

  bool get _hasNext =>
      _detail != null && _qIndex + 1 < _detail!.questions.length;

  void _goNext() {
    if (!_hasNext) return;
    HapticFeedback.selectionClick();
    setState(() {
      _qIndex++;
      _currentQuestionId = _detail!.questions[_qIndex].id;
    });
  }

  // ─── Submit ─────────────────────────────────────────────────────────────

  Future<void> _confirmAndSubmit() async {
    final remainingMin = (_remaining.inSeconds / 60).ceil();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Soumettre ton concours blanc ?'),
        content: Text(
          'Il te reste $remainingMin min. Une fois soumis, '
          'tu ne pourras plus modifier tes réponses.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Soumettre'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _doSubmit(reason: 'manual');
    }
  }

  Future<void> _doSubmit({required String reason}) async {
    final a = _attempt;
    if (a == null) return;
    setState(() => _submitting = true);
    // Force flush des autosaves pending
    for (final entry in _debouncers.entries) {
      entry.value?.cancel();
      final ctrl = _controllers[entry.key];
      if (ctrl != null) {
        await _mockSvc.saveAnswer(
          mockAttemptId: a.attemptId,
          questionId: entry.key,
          text: ctrl.text,
        );
      }
    }
    final result = await _mockSvc.finish(a.attemptId);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
      _finalStatus = result.status;
    });
    _ticker?.cancel();
  }

  Future<bool> _onWillPop() async {
    if (_submitted || _attempt == null) return true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter le concours blanc ?'),
        content: const Text(
          'Si tu quittes maintenant, ton attempt restera en cours et '
          'le timer continue. Tu pourras reprendre tant qu\'il reste du temps.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Continuer le concours'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  // ─── BUILD ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: CasPratiqueScaffold(
        title: 'Concours blanc',
        subtitle: _subtitleText(),
        canGoBack: !_submitting,
        body: SafeArea(
          top: false,
          child: _loading
              ? const _LoadingState()
              : _loadError != null
                  ? _ErrorState(error: _loadError)
                  : _submitted
                      ? _SubmittedState(status: _finalStatus)
                      : _buildExamBody(),
        ),
      ),
    );
  }

  String? _subtitleText() {
    if (_loading) return 'Préparation…';
    if (_submitted) return 'Soumis ✓';
    if (_detail != null) {
      final total = _detail!.questions.length;
      return 'Question ${_qIndex + 1} / $total';
    }
    return null;
  }

  Widget _buildExamBody() {
    final detail = _detail;
    final qId = _currentQuestionId;
    if (detail == null || qId == null) return const SizedBox.shrink();
    final question = detail.questions[_qIndex];
    final ctrl = _controllers[qId]!;
    final low = _remaining.inSeconds < 300; // < 5 min = rouge

    return Column(
      children: [
        _TimerBanner(remaining: _remaining, isCritical: low),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'QUESTION ${_qIndex + 1} / ${detail.questions.length}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  question.label,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                AnswerTextArea(
                  controller: ctrl,
                  charMin: question.charMin,
                  charRecommended: question.charRecommended,
                  saveState: AnswerSaveState.idle,
                  enabled: !_submitting && _remaining > Duration.zero,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _submitting ? null : _confirmAndSubmit,
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: Text(
                          'Soumettre maintenant',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w900,
                            fontSize: 13.5,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.45)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(CpTokens.r3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: (_hasNext && !_submitting) ? _goNext : null,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: Text(
                          _hasNext ? 'Question suivante' : 'Dernière question',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: CpTokens.darkNavy,
                          disabledBackgroundColor:
                              Colors.white.withValues(alpha: 0.40),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(CpTokens.r3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Verrouillage strict : tu ne peux pas revenir aux questions précédentes.',
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
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Timer banner
// ═══════════════════════════════════════════════════════════════════════════

class _TimerBanner extends StatelessWidget {
  const _TimerBanner({required this.remaining, required this.isCritical});
  final Duration remaining;
  final bool isCritical;

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final bg = isCritical ? CpTokens.danger : Colors.white.withValues(alpha: 0.12);
    final fg = isCritical ? Colors.white : Colors.white;
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CpTokens.r3),
        border: Border.all(
          color: isCritical
              ? Colors.white.withValues(alpha: 0.30)
              : Colors.white.withValues(alpha: 0.18),
        ),
        boxShadow: isCritical
            ? [
                BoxShadow(
                  color: CpTokens.danger.withValues(alpha: 0.40),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(Icons.timer_rounded, color: fg, size: 18),
          const SizedBox(width: 10),
          Text(
            isCritical ? 'TEMPS CRITIQUE' : 'TEMPS RESTANT',
            style: GoogleFonts.montserrat(
              color: fg,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.4,
            ),
          ),
          const Spacer(),
          Text(
            _fmt(remaining),
            style: GoogleFonts.montserrat(
              color: fg,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  States
// ═══════════════════════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3.2,
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_rounded, color: Colors.white, size: 56),
          const SizedBox(height: 14),
          Text(
            'Concours blanc indisponible',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error?.toString() ?? 'Erreur inconnue',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.82),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmittedState extends StatelessWidget {
  const _SubmittedState({required this.status});
  final FinishStatus? status;

  @override
  Widget build(BuildContext context) {
    final ok = status == FinishStatus.submitted;
    final expired = status == FinishStatus.expired;
    final color = expired
        ? CpTokens.warning
        : (ok ? CpTokens.success : Colors.white);
    final icon = expired
        ? Icons.timer_off_rounded
        : (ok ? Icons.check_circle_rounded : Icons.help_rounded);
    final title = expired
        ? 'Temps écoulé'
        : (ok ? 'Concours soumis 🎉' : 'Soumis');
    final msg = expired
        ? 'Le timer a atteint zéro — ta tentative a été automatiquement clôturée. Le classement sera disponible après correction.'
        : 'Tes réponses ont été enregistrées. Le classement et le score apparaîtront après correction par l\'équipe.';

    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96, height: 96,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.45), width: 2),
            ),
            child: Icon(icon, color: color, size: 46),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 26),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: CpTokens.darkNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CpTokens.r3),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28),
              ),
              child: Text(
                'Retour',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ),
     
        ],
      ),
    );
  }
}
