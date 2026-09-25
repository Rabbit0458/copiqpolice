import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'active_access_service.dart';

class ActiveVerificationPage extends StatefulWidget {
  const ActiveVerificationPage({super.key});

  @override
  State<ActiveVerificationPage> createState() => _ActiveVerificationPageState();
}

class _ActiveVerificationPageState extends State<ActiveVerificationPage> {
  final _service = ActiveAccessService();
  final _formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> _controllers = {};
  List<ActiveVerificationQuestion> _questions = const [];
  ActiveAccessStatus? _status;
  Timer? _timer;
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  int? _lastScore;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && (_status?.coolingDown ?? false)) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final status = await _service.status();
      if (!mounted) return;
      if (status.granted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/active-home', (_) => false);
        return;
      }
      final questions = await _service.questions();
      if (questions.length != 4) {
        throw StateError('Le questionnaire de validation est indisponible.');
      }
      for (final question in questions) {
        _controllers.putIfAbsent(question.id, TextEditingController.new);
      }
      setState(() {
        _status = status;
        _questions = questions;
      });
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'La vérification sécurisée ne peut pas être chargée. Réessaie dans un instant.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (_submitting || (_status?.coolingDown ?? false)) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final result = await _service.submit(_questions, {
        for (final q in _questions) q.id: _controllers[q.id]!.text,
      });
      if (!mounted) return;
      if (result.passed) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/active-home', (_) => false);
        return;
      }
      setState(() {
        _lastScore = result.score;
        _status = ActiveAccessStatus(
          status: result.status,
          granted: false,
          cooldownUntil: result.cooldownUntil,
        );
      });
      for (final controller in _controllers.values) {
        controller.clear();
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'La réponse n’a pas pu être vérifiée. Aucun accès n’a été accordé.',
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  int get _remainingSeconds {
    final until = _status?.cooldownUntil;
    if (until == null) return 0;
    final seconds = until.difference(DateTime.now()).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final ink = dark ? Colors.white : const Color(0xFF151922);
    final surface = dark ? const Color(0xFF151A26) : Colors.white;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Changer de mode',
          onPressed: () => Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/mode_picker', (_) => false),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _questions.isEmpty
          ? _Failure(message: _error!, onRetry: _load)
          : SafeArea(
              top: false,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
                  children: [
                    Container(
                      width: 54,
                      height: 5,
                      margin: const EdgeInsets.only(right: 280, bottom: 22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1769E8),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Text(
                      'Validation de l’accès professionnel',
                      style: GoogleFonts.instrumentSans(
                        color: ink,
                        fontSize: 30,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Réponds aux 4 questions de contrôle. Les réponses sont vérifiées de façon sécurisée et ne sont jamais affichées.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: ink.withValues(alpha: .65),
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (_lastScore != null)
                      _Notice(
                        color: const Color(0xFFF59E0B),
                        icon: Icons.shield_outlined,
                        text:
                            'Validation non obtenue : $_lastScore/4. Les bonnes réponses ne sont pas révélées.',
                      ),
                    if (_remainingSeconds > 0)
                      _Notice(
                        color: const Color(0xFFE04F5F),
                        icon: Icons.timer_outlined,
                        text:
                            'Trop de tentatives. Nouvel essai possible dans ${(_remainingSeconds / 60).ceil()} min ${_remainingSeconds % 60} s.',
                      ),
                    if (_error != null)
                      _Notice(
                        color: const Color(0xFFE04F5F),
                        icon: Icons.error_outline_rounded,
                        text: _error!,
                      ),
                    ..._questions.map(
                      (question) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: ink.withValues(alpha: .09),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .05),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'QUESTION ${question.position}/4',
                                style: TextStyle(
                                  color: const Color(0xFF1769E8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.prompt,
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 16,
                                  height: 1.35,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _controllers[question.id],
                                enabled: _remainingSeconds == 0,
                                textInputAction: question.position == 4
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                onFieldSubmitted: question.position == 4
                                    ? (_) => _submit()
                                    : null,
                                validator: (value) =>
                                    (value?.trim().isEmpty ?? true)
                                    ? 'Une réponse est requise.'
                                    : null,
                                decoration: InputDecoration(
                                  hintText: 'Ta réponse',
                                  filled: true,
                                  fillColor: dark
                                      ? const Color(0xFF0C111C)
                                      : const Color(0xFFF5F7FB),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: _submitting || _remainingSeconds > 0
                          ? null
                          : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        backgroundColor: const Color(0xFF1769E8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: _submitting
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.verified_user_outlined),
                      label: Text(
                        _submitting ? 'Vérification…' : 'Vérifier mon accès',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.color, required this.icon, required this.text});
  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      border: Border.all(color: color.withValues(alpha: .3)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
      ],
    ),
  );
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_outlined, size: 52),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          FilledButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    ),
  );
}
