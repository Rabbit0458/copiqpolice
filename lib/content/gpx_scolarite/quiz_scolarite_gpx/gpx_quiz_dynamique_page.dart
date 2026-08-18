// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Quiz de scolarité générique, alimenté par Supabase             ║
// ║                                                                          ║
// ║  Pourquoi cette page existe                                              ║
// ║  ─────────────────────────                                               ║
// ║  Chaque quiz de scolarité était jusqu'ici un fichier Dart de ~2 900      ║
// ║  lignes avec ses questions écrites en dur. Conséquences :                ║
// ║    • corriger une faute d'orthographe imposait de recompiler et de       ║
// ║      republier l'application sur les stores ;                            ║
// ║    • 66 fichiers quasi identiques à maintenir en parallèle.              ║
// ║                                                                          ║
// ║  Cette page lit ses questions dans `quiz_scolarite_questions` et son      ║
// ║  habillage dans `quiz_scolarite_modules`. Créer un nouveau quiz ne        ║
// ║  demande donc plus une seule ligne de Dart : tout se fait depuis le       ║
// ║  panel administrateur (copiq.fr/admin).                                   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/services/user_context_service.dart';
import 'package:copiqpolice/core/widgets/quiz_report_dialog.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  MODÈLES
// ═══════════════════════════════════════════════════════════════════════════

class QuizScolariteQuestion {
  final int id;
  final String? category;
  final String difficulty;
  final String question;
  final List<String> options;
  final String answer;
  final String? explanation;
  final String? legalRef;

  const QuizScolariteQuestion({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.legalRef,
  });

  factory QuizScolariteQuestion.fromJson(Map<String, dynamic> j) {
    final rawOptions = j['options'];
    final opts = <String>[
      if (rawOptions is List) ...rawOptions.map((e) => e.toString()),
    ];
    return QuizScolariteQuestion(
      id: (j['id'] as num).toInt(),
      category: j['category'] as String?,
      difficulty: (j['difficulty'] as String?) ?? 'Moyenne',
      question: (j['question'] as String?) ?? '',
      options: opts,
      answer: (j['answer'] as String?) ?? '',
      explanation: j['explanation'] as String?,
      legalRef: j['legal_ref'] as String?,
    );
  }
}

class QuizScolariteModule {
  final String module;
  final String title;
  final String? subtitle;
  final Color color;

  const QuizScolariteModule({
    required this.module,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  factory QuizScolariteModule.fromJson(Map<String, dynamic> j) {
    final hex = (j['color_hex'] as String?) ?? '#1147D9';
    return QuizScolariteModule(
      module: j['module'] as String,
      title: (j['title'] as String?) ?? 'Quiz',
      subtitle: j['subtitle'] as String?,
      color: _parseHex(hex),
    );
  }

  static Color _parseHex(String hex) {
    final v = hex.replaceAll('#', '').trim();
    final parsed = int.tryParse(v.length == 6 ? 'FF$v' : v, radix: 16);
    return Color(parsed ?? 0xFF1147D9);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  PAGE
// ═══════════════════════════════════════════════════════════════════════════

/// Quiz générique. Le module est passé soit par le constructeur, soit par les
/// `arguments` de la route (String ou `{'module': '...'}`).
class QuizScolariteDynamiquePage extends StatefulWidget {
  const QuizScolariteDynamiquePage({super.key, this.module});

  static const String routeName = '/gpx/scolarite/quiz';

  final String? module;

  @override
  State<QuizScolariteDynamiquePage> createState() =>
      _QuizScolariteDynamiquePageState();
}

enum _Phase { loading, error, intro, playing, finished }

class _QuizScolariteDynamiquePageState
    extends State<QuizScolariteDynamiquePage> {
  final _sb = Supabase.instance.client;

  _Phase _phase = _Phase.loading;
  String? _errorMessage;
  String _module = '';

  QuizScolariteModule? _config;
  Map<String, int> _counts = const {};
  List<QuizScolariteQuestion> _questions = const [];

  int _index = 0;
  int _score = 0;
  String? _selected;
  bool _revealed = false;
  int? _historyRowId;
  String? _difficultyFilter; // null = tous niveaux

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  // ─── Chargement ────────────────────────────────────────────────────────

  Future<void> _bootstrap() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    final resolved =
        widget.module ??
        (args is String
            ? args
            : (args is Map && args['module'] is String
                  ? args['module'] as String
                  : null));

    if (resolved == null || resolved.isEmpty) {
      setState(() {
        _phase = _Phase.error;
        _errorMessage = 'Aucun quiz spécifié.';
      });
      return;
    }
    _module = resolved;
    await _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() {
      _phase = _Phase.loading;
      _errorMessage = null;
    });
    try {
      final cfg = await _sb
          .from('quiz_scolarite_modules')
          .select()
          .eq('module', _module)
          .maybeSingle();

      if (cfg == null) {
        setState(() {
          _phase = _Phase.error;
          _errorMessage = 'Ce quiz n’est pas encore disponible.';
        });
        return;
      }

      final counts = await _sb.rpc(
        'quiz_scolarite_counts',
        params: {'p_module': _module},
      );

      if (!mounted) return;
      setState(() {
        _config = QuizScolariteModule.fromJson(Map<String, dynamic>.from(cfg));
        _counts = <String, int>{
          for (final e in (counts as Map).entries)
            e.key.toString(): (e.value as num?)?.toInt() ?? 0,
        };
        _phase = _Phase.intro;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _errorMessage = 'Chargement impossible. Vérifie ta connexion.';
      });
      debugPrint('quiz_scolarite: chargement config KO — $e');
    }
  }

  Future<void> _startQuiz({String? difficulty}) async {
    setState(() {
      _phase = _Phase.loading;
      _difficultyFilter = difficulty;
    });
    try {
      final rows = await _sb.rpc(
        'quiz_scolarite_session',
        params: {
          'p_module': _module,
          'p_difficulty': difficulty,
          'p_limit': 15,
        },
      );

      final list = (rows as List)
          .whereType<Map<String, dynamic>>()
          .map(QuizScolariteQuestion.fromJson)
          .where((q) => q.options.length >= 2)
          .toList();

      if (list.isEmpty) {
        setState(() {
          _phase = _Phase.error;
          _errorMessage = 'Aucune question disponible pour ce niveau.';
        });
        return;
      }

      // Les propositions sont mélangées pour éviter l'apprentissage par position
      final rnd = math.Random();
      for (final q in list) {
        q.options.shuffle(rnd);
      }

      if (!mounted) return;
      setState(() {
        _questions = list;
        _index = 0;
        _score = 0;
        _selected = null;
        _revealed = false;
        _phase = _Phase.playing;
      });
      await _createHistory();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _errorMessage = 'Impossible de démarrer le quiz.';
      });
      debugPrint('quiz_scolarite: démarrage KO — $e');
    }
  }

  // ─── Persistance ───────────────────────────────────────────────────────

  Future<void> _createHistory() async {
    final user = _sb.auth.currentUser;
    if (user == null) return;
    try {
      final res = await _sb
          .from('quiz_history')
          .insert({
            'uid': user.id,
            'email': user.email,
            'grade': UserContextService.I.trackOrDefault,
            'track': UserContextService.I.trackOrDefault,
            'mode': UserContextService.I.modeOrDefault,
            'module_name': _config?.title ?? _module,
            'quiz_name': _config?.title ?? _module,
            'score': 0,
            'total_questions': _questions.length,
            'correct_count': 0,
            'started_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select('id')
          .single();
      _historyRowId = (res['id'] as num).toInt();
    } catch (e) {
      debugPrint('quiz_scolarite: quiz_history insert KO — $e');
    }
  }

  Future<void> _finishHistory(int answered) async {
    if (_historyRowId == null) return;
    final user = _sb.auth.currentUser;
    if (user == null) return;
    final total = answered <= 0 ? 1 : answered;
    try {
      await _sb
          .from('quiz_history')
          .update({
            'score': (_score * 100 ~/ total).clamp(0, 100),
            'correct_count': _score,
            'total_questions': answered,
            'finished_at': DateTime.now().toUtc().toIso8601String(),
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _historyRowId!)
          .eq('uid', user.id);
    } catch (e) {
      debugPrint('quiz_scolarite: quiz_history update KO — $e');
    }
  }

  Future<void> _saveAnswer(QuizScolariteQuestion q, bool correct) async {
    final user = _sb.auth.currentUser;
    if (user == null) return;
    try {
      await _sb.from('quiz_scolarite_answers').insert({
        'user_uid': user.id,
        'email': user.email,
        'module': _module,
        'question_id': q.id,
        'question': q.question,
        'user_answer': _selected,
        'correct_answer': q.answer,
        'is_correct': correct,
        'difficulty': q.difficulty,
        'track': UserContextService.I.trackOrDefault,
      });
    } catch (e) {
      debugPrint('quiz_scolarite: enregistrement réponse KO — $e');
    }
  }

  // ─── Jeu ───────────────────────────────────────────────────────────────

  void _select(String option) {
    if (_revealed) return;
    final q = _questions[_index];
    final correct = option == q.answer;
    HapticFeedback.selectionClick();
    setState(() {
      _selected = option;
      _revealed = true;
      if (correct) _score++;
    });
    unawaited(_saveAnswer(q, correct));
  }

  Future<void> _next() async {
    if (_index + 1 >= _questions.length) {
      await _finishHistory(_questions.length);
      if (!mounted) return;
      setState(() => _phase = _Phase.finished);
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _revealed = false;
    });
  }

  Future<void> _requestFinish() async {
    if (_phase != _Phase.playing) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mettre fin au quiz ?'),
        content: const Text(
          'Tes réponses déjà validées seront enregistrées et le résultat sera calculé sur cette base.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Continuer'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Mettre fin'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final answered = (_index + (_revealed ? 1 : 0)).clamp(0, _questions.length);
    await _finishHistory(answered);
    if (!mounted) return;
    setState(() => _phase = _Phase.finished);
  }

  Future<void> _report() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final q = _questions.isEmpty ? null : _questions[_index];
    await showQuizReportDialog(
      context: context,
      isDark: isDark,
      onInsert: ({required String reportType, required String message}) async {
        final user = _sb.auth.currentUser;
        await _sb.from('report_question').insert({
          'user_uid': user?.id,
          'email': user?.email,
          'question_text': q?.question ?? '',
          // Permet à l'admin de retrouver la ligne exacte à corriger.
          'source_file': 'quiz_scolarite_questions#${q?.id ?? 0}',
          'question_category': q?.category,
          'question_difficulty': q?.difficulty,
          'question_answer': q?.answer,
          'report_type': reportType,
          'report_message': message,
          'status': 'new',
        });
      },
    );
  }

  // ═════════════════════════════════════════════════════════════════════
  //  RENDU
  // ═════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF06102A) : const Color(0xFFF4F6FB);

    return PopScope(
      canPop: _phase != _Phase.playing,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && _phase == _Phase.playing) await _requestFinish();
      },
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Fermer',
            onPressed: _phase == _Phase.playing
                ? _requestFinish
                : () => Navigator.maybePop(context),
            icon: const Icon(Icons.close_rounded),
          ),
          title: Text(
            _config?.title ?? 'Quiz',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          actions: [
            if (_phase == _Phase.playing) ...[
              TextButton(
                onPressed: _requestFinish,
                child: const Text('Mettre fin'),
              ),
              IconButton(
                tooltip: 'Signaler cette question',
                onPressed: _report,
                icon: const Icon(Icons.flag_outlined, size: 20),
              ),
            ],
          ],
        ),
        body: SafeArea(
          child: switch (_phase) {
            _Phase.loading => const Center(child: CircularProgressIndicator()),
            _Phase.error => _buildError(isDark),
            _Phase.intro => _buildIntro(isDark),
            _Phase.playing => _buildQuestion(isDark),
            _Phase.finished => _buildResult(isDark),
          },
        ),
      ),
    );
  }

  Widget _buildError(bool isDark) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 44, color: Color(0xFFE8574B)),
          const SizedBox(height: 14),
          Text(
            _errorMessage ?? 'Une erreur est survenue.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _loadConfig, child: const Text('Réessayer')),
        ],
      ),
    ),
  );

  Widget _buildIntro(bool isDark) {
    final c = _config!;
    final total = _counts['total'] ?? 0;
    final surface = isDark ? const Color(0xFF0D1B4B) : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.color, c.color.withValues(alpha: .78)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                if (c.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    c.subtitle!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    _pill('$total questions'),
                    const SizedBox(width: 8),
                    _pill('15 par session'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Choisis ton niveau',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _levelCard(
            surface,
            c.color,
            'Tous niveaux',
            'Session mixte, recommandée',
            total,
            null,
          ),
          _levelCard(
            surface,
            const Color(0xFF3FA34D),
            'Facile',
            'Les fondamentaux',
            _counts['facile'] ?? 0,
            'Facile',
          ),
          _levelCard(
            surface,
            const Color(0xFFE8A44B),
            'Moyenne',
            'Niveau concours',
            _counts['moyenne'] ?? 0,
            'Moyenne',
          ),
          _levelCard(
            surface,
            const Color(0xFFC0392B),
            'Difficile',
            'Pour se démarquer',
            _counts['difficile'] ?? 0,
            'Difficile',
          ),
        ],
      ),
    );
  }

  Widget _pill(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .22),
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _levelCard(
    Color surface,
    Color accent,
    String title,
    String subtitle,
    int count,
    String? difficulty,
  ) {
    final enabled = count > 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? () => _startQuiz(difficulty: difficulty) : null,
          child: Opacity(
            opacity: enabled ? 1 : .45,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 38,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          enabled
                              ? '$subtitle · $count question${count > 1 ? 's' : ''}'
                              : 'Aucune question pour ce niveau',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Theme.of(context).textTheme.bodySmall?.color
                                ?.withValues(alpha: .75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(bool isDark) {
    final q = _questions[_index];
    final surface = isDark ? const Color(0xFF0D1B4B) : Colors.white;
    final accent = _config?.color ?? const Color(0xFF1147D9);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_index + 1} sur ${_questions.length}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$_score bonne${_score > 1 ? 's' : ''} réponse${_score > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 12.5, color: accent),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: (_index + 1) / _questions.length,
                  minHeight: 5,
                  color: accent,
                  backgroundColor: accent.withValues(alpha: .15),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (q.category != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '${q.category} · ${q.difficulty}',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                Text(
                  q.question,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                ...q.options.map((o) => _optionTile(o, q, surface, accent)),
                if (_revealed && (q.explanation?.isNotEmpty ?? false)) ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: accent.withValues(alpha: .25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explication',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .4,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          q.explanation!,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                        if (q.legalRef != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            q.legalRef!,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: .8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_revealed)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _index + 1 >= _questions.length
                      ? 'Voir mon résultat'
                      : 'Question suivante',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _optionTile(
    String option,
    QuizScolariteQuestion q,
    Color surface,
    Color accent,
  ) {
    const good = Color(0xFF27C93F);
    const bad = Color(0xFFE8574B);

    Color border = Colors.transparent;
    Color bg = surface;
    IconData? icon;

    if (_revealed) {
      if (option == q.answer) {
        border = good;
        bg = good.withValues(alpha: .10);
        icon = Icons.check_circle_rounded;
      } else if (option == _selected) {
        border = bad;
        bg = bad.withValues(alpha: .10);
        icon = Icons.cancel_rounded;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _revealed ? null : () => _select(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: border == Colors.transparent
                    ? accent.withValues(alpha: .14)
                    : border,
                width: border == Colors.transparent ? 1 : 1.6,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, size: 21, color: border),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(bool isDark) {
    final total = _questions.length;
    final percent = total == 0 ? 0 : (_score * 100 / total).round();
    final accent = _config?.color ?? const Color(0xFF1147D9);
    final surface = isDark ? const Color(0xFF0D1B4B) : Colors.white;

    final (String verdict, Color verdictColor) = switch (percent) {
      >= 80 => ('Excellent', const Color(0xFF27C93F)),
      >= 60 => ('Bon niveau', const Color(0xFF3FA34D)),
      >= 40 => ('À consolider', const Color(0xFFE8A44B)),
      _ => ('À retravailler', const Color(0xFFE8574B)),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '$percent %',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: verdictColor,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  verdict,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: verdictColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_score bonne${_score > 1 ? 's' : ''} réponse${_score > 1 ? 's' : ''} sur $total',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () => _startQuiz(difficulty: _difficultyFilter),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Rejouer une session',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: () => setState(() => _phase = _Phase.intro),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Changer de niveau'),
            ),
          ),
        ],
      ),
    );
  }
}
