// COP'IQ — Photolangage PA : éditeur de rédaction chronométré.
//
// Timer robuste : la source de vérité est `deadline = startedAt + durée`,
// persistée dans le brouillon (local + distant). L'UI se rafraîchit chaque
// seconde mais recalcule toujours depuis l'horloge — pas de dérive en
// arrière-plan, reprise exacte après fermeture.
//
// Règle produit : le chronomètre démarre à l'appui sur « Commencer la
// rédaction » (création du brouillon avec deadline). Revoir l'image ne met
// jamais le temps en pause.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:copiqpolice/core/widgets/app_notifier.dart' show AppNotifier;

import '../psycotechniques/pa_psycho_brand.dart';
import 'pa_photolangage_core.dart';
import 'pa_photolangage_result_page.dart';
import 'pa_photolangage_training_pages.dart' show PaPhotolangageImagePage;

class PaPhotolangageEditorPage extends StatefulWidget {
  final PhotolangageCase c;
  const PaPhotolangageEditorPage({super.key, required this.c});

  @override
  State<PaPhotolangageEditorPage> createState() =>
      _PaPhotolangageEditorPageState();
}

class _PaPhotolangageEditorPageState extends State<PaPhotolangageEditorPage>
    with WidgetsBindingObserver {
  final _repo = PaPhotolangageRepository.instance;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  DateTime? _startedAt;
  DateTime? _deadline;
  Timer? _ticker;
  Timer? _saveDebounce;
  DateTime _lastRemoteSave = DateTime.fromMillisecondsSinceEpoch(0);

  bool _initializing = true;
  bool _expired = false;
  bool _submitting = false;
  bool _warned5 = false;
  bool _warned1 = false;
  String _saveStatus = '';

  int _charCount = 0;
  int _wordCount = 0;

  PhotolangageCase get c => widget.c;

  Duration get _remaining {
    final d = _deadline;
    if (d == null) return Duration.zero;
    final r = d.difference(DateTime.now().toUtc());
    return r.isNegative ? Duration.zero : r;
  }

  bool get _minimumReached =>
      _charCount >= c.minimumCharacters && _wordCount >= c.minimumWords;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_onTextChanged);
    _init();
  }

  Future<void> _init() async {
    final existing = await _repo.loadDraft(c.id);
    final nowUtc = DateTime.now().toUtc();

    if (existing != null && existing.timerStarted) {
      // Reprise d'un exercice interrompu.
      _startedAt = existing.startedAt;
      _deadline = existing.deadline;
      _controller.text = existing.text;
      if (mounted && existing.text.trim().isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            AppNotifier.info(
              context,
              title: 'Brouillon restauré',
              message: 'Ta rédaction et ton chronomètre ont été repris.',
            );
          }
        });
      }
    } else {
      // Nouveau départ : le chronomètre démarre MAINTENANT.
      _startedAt = nowUtc;
      _deadline = nowUtc.add(Duration(seconds: c.durationSeconds));
      await _repo.saveDraft(
        PhotolangageDraft(
          caseId: c.id,
          text: '',
          startedAt: _startedAt,
          deadline: _deadline,
          lastSavedAt: nowUtc,
          caseVersion: c.version,
        ),
      );
    }

    _recount();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    if (mounted) setState(() => _initializing = false);
    _onTick();
  }

  void _recount() {
    _charCount = PaPhotolangageTextUtils.charCount(_controller.text);
    _wordCount = PaPhotolangageTextUtils.wordCount(_controller.text);
  }

  void _onTextChanged() {
    if (_expired) return;
    setState(_recount);
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 900), () {
      _saveDraft();
    });
  }

  Future<void> _saveDraft({bool forceRemote = false}) async {
    if (_startedAt == null) return;
    final now = DateTime.now().toUtc();
    final remote =
        forceRemote ||
        now.difference(_lastRemoteSave) > const Duration(seconds: 8);
    if (remote) _lastRemoteSave = now;
    if (mounted) setState(() => _saveStatus = 'Enregistrement…');
    await _repo.saveDraft(
      PhotolangageDraft(
        caseId: c.id,
        text: _controller.text,
        startedAt: _startedAt,
        deadline: _deadline,
        lastSavedAt: now,
        caseVersion: c.version,
      ),
      remote: remote,
    );
    if (mounted) setState(() => _saveStatus = 'Enregistré');
  }

  void _onTick() {
    if (!mounted || _expired) return;
    final r = _remaining;
    if (r.inSeconds <= 0) {
      _handleExpiry();
      return;
    }
    if (!_warned5 && r.inSeconds <= 300) {
      _warned5 = true;
      AppNotifier.warning(
        context,
        title: 'Plus que 5 minutes',
        message: 'Pense à garder du temps pour la relecture.',
      );
    }
    if (!_warned1 && r.inSeconds <= 60) {
      _warned1 = true;
      AppNotifier.warning(
        context,
        title: 'Dernière minute',
        message: 'Termine ta phrase et relis l’essentiel.',
      );
    }
    setState(() {});
  }

  Future<void> _handleExpiry() async {
    if (_expired) return;
    setState(() => _expired = true);
    _focusNode.unfocus();
    await _saveDraft(forceRemote: true);
    if (!mounted) return;

    if (_minimumReached) {
      AppNotifier.info(
        context,
        title: 'Temps écoulé',
        message: 'Ta réponse atteint le minimum : envoi pour correction.',
      );
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (mounted) _submit(expiredIncomplete: false);
    } else {
      final analyse = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Temps écoulé'),
          content: const Text(
            'Le minimum demandé n’est pas atteint. Ta tentative sera '
            'enregistrée comme « temps écoulé — réponse incomplète ». '
            'Souhaites-tu tout de même obtenir une analyse partielle de '
            'ton texte ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Non, quitter'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Analyser quand même'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (analyse == true) {
        _submit(expiredIncomplete: true);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _confirmSubmit() async {
    if (!_minimumReached || _submitting) return;

    final gaming = PaPhotolangageTextUtils.antiGamingIssue(_controller.text);
    if (gaming != null) {
      AppNotifier.warning(
        context,
        title: 'Texte à retravailler',
        message: gaming,
      );
      return;
    }

    final r = _remaining;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Valider ma réponse ?'),
        content: Text(
          'Temps restant : ${_fmt(r)}\n'
          '$_wordCount mots — $_charCount caractères\n\n'
          'Après validation, ta réponse ne pourra plus être modifiée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Continuer la rédaction'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Valider définitivement'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) _submit(expiredIncomplete: false);
  }

  Future<void> _submit({required bool expiredIncomplete}) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    _ticker?.cancel();

    try {
      final attemptId = await _repo.insertAttempt(
        c: c,
        rawText: _controller.text,
        startedAt: _startedAt ?? DateTime.now().toUtc(),
        remainingSeconds: _remaining.inSeconds,
        expiredIncomplete: expiredIncomplete,
      );
      await _repo.deleteDraft(c.id);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaPhotolangageProcessingPage(
            c: c,
            attemptId: attemptId,
            rawText: _controller.text,
          ),
        ),
      );
    } catch (e) {
      debugPrint('photolangage submit failed: $e');
      if (!mounted) return;
      setState(() => _submitting = false);
      // Le texte est préservé dans le brouillon : rien n'est perdu.
      _saveDraft(forceRemote: true);
      AppNotifier.error(
        context,
        title: 'Envoi impossible',
        message:
            'Vérifie ta connexion puis réessaie. Ton texte est sauvegardé.',
      );
      if (!_expired) {
        _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
      }
    }
  }

  Future<void> _reviewImage() async {
    await _saveDraft(forceRemote: true);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaPhotolangageImagePage(c: c, reviewMode: true),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quitter l’exercice ?'),
        content: const Text(
          'Ton brouillon et ton chronomètre sont sauvegardés : tu pourras '
          'reprendre exactement où tu en étais. Le temps continue de '
          's’écouler.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Rester'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
    if (leave == true) await _saveDraft(forceRemote: true);
    return leave == true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _saveDraft(forceRemote: true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _saveDebounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return Scaffold(
        backgroundColor: PaPsychoBrand.bg(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final r = _remaining;
    final urgent = r.inSeconds <= 60 && !_expired;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: PaPsychoBrand.bg(context),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  // ── Barre supérieure : sortie, timer, revoir l'image ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (await _confirmExit() && mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: PaPsychoBrand.text(context),
                          ),
                        ),
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: PaPsychoBrand.tinted(
                            context,
                            color: urgent
                                ? PaPsychoBrand.bad
                                : PaPsychoBrand.accent,
                            radius: 999,
                            alpha: urgent ? .16 : .10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_rounded,
                                size: 16,
                                color: urgent
                                    ? PaPsychoBrand.bad
                                    : PaPsychoBrand.accent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _expired ? '00:00' : _fmt(r),
                                style: PaPsychoBrand.h3(context).copyWith(
                                  color: urgent
                                      ? PaPsychoBrand.bad
                                      : PaPsychoBrand.accent,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Revoir l’image (le temps continue)',
                          onPressed: _expired ? null : _reviewImage,
                          icon: Icon(
                            Icons.image_rounded,
                            color: PaPsychoBrand.accent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Compteurs + statut de sauvegarde ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _CounterPill(
                          label: 'mots',
                          value: _wordCount,
                          minimum: c.minimumWords,
                        ),
                        const SizedBox(width: 8),
                        _CounterPill(
                          label: 'caractères',
                          value: _charCount,
                          minimum: c.minimumCharacters,
                        ),
                        const Spacer(),
                        Text(
                          _saveStatus,
                          style: PaPsychoBrand.small(
                            context,
                          ).copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Zone de rédaction ──
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: PaPsychoBrand.card(context),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          enabled: !_expired && !_submitting,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          style: PaPsychoBrand.body(
                            context,
                          ).copyWith(fontSize: 16, height: 1.5),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'La photographie représente… \n\nDécris du '
                                'général au particulier, uniquement ce qui '
                                'est visible.',
                            hintStyle: PaPsychoBrand.body(
                              context,
                            ).copyWith(color: PaPsychoBrand.textMuted(context)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Indicateur de minimum + bouton de validation ──
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: (_charCount / c.minimumCharacters).clamp(
                              0.0,
                              1.0,
                            ),
                            minHeight: 6,
                            backgroundColor: PaPsychoBrand.borderColor(context),
                            valueColor: AlwaysStoppedAnimation(
                              _minimumReached
                                  ? PaPsychoBrand.good
                                  : PaPsychoBrand.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _minimumReached
                              ? 'Minimum atteint — pense à te relire avant '
                                    'de valider.'
                              : 'Minimum : ${c.minimumWords} mots et '
                                    '${c.minimumCharacters} caractères '
                                    '(≈ 20 lignes manuscrites).',
                          style: PaPsychoBrand.small(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton.icon(
                            onPressed:
                                (_minimumReached && !_submitting && !_expired)
                                ? _confirmSubmit
                                : null,
                            icon: _submitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send_rounded),
                            label: Text(
                              _submitting
                                  ? 'Envoi en cours…'
                                  : 'Valider ma réponse',
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: PaPsychoBrand.accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CounterPill extends StatelessWidget {
  final String label;
  final int value;
  final int minimum;
  const _CounterPill({
    required this.label,
    required this.value,
    required this.minimum,
  });

  @override
  Widget build(BuildContext context) {
    final ok = value >= minimum;
    final color = ok ? PaPsychoBrand.good : PaPsychoBrand.textMuted(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: ok ? PaPsychoBrand.good : PaPsychoBrand.borderColor(context),
        ),
      ),
      child: Text(
        '$value / $minimum $label',
        style: PaPsychoBrand.small(
          context,
        ).copyWith(color: color, fontSize: 11.5),
      ),
    );
  }
}
