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
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/services/learning_answer_history_service.dart';
import 'package:copiqpolice/core/services/quiz_report_queue_service.dart';
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
  final String? imageAsset;
  final String questionType;
  final String stableKey;
  final int revision;

  const QuizScolariteQuestion({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.legalRef,
    required this.imageAsset,
    required this.questionType,
    required this.stableKey,
    required this.revision,
  });

  factory QuizScolariteQuestion.fromJson(Map<String, dynamic> j) {
    final rawOptions = j['options'];
    final opts = <String>[
      if (rawOptions is List) ...rawOptions.map((e) => e.toString()),
    ];
    final metadata = j['metadata'] is Map
        ? Map<String, dynamic>.from(j['metadata'] as Map)
        : const <String, dynamic>{};
    return QuizScolariteQuestion(
      id: (j['id'] as num).toInt(),
      category: j['category'] as String?,
      difficulty: (j['difficulty'] as String?) ?? 'Moyenne',
      question: (j['question'] as String?) ?? '',
      options: opts,
      answer: (j['answer'] as String?) ?? '',
      explanation: j['explanation'] as String?,
      legalRef: j['legal_ref'] as String?,
      imageAsset: metadata['image_asset']?.toString(),
      questionType: metadata['question_type']?.toString() ?? 'multiple_choice',
      stableKey: metadata['stable_key']?.toString() ?? 'question-${j['id']}',
      revision: (j['revision'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'difficulty': difficulty,
    'question': question,
    'options': options,
    'answer': answer,
    'explanation': explanation,
    'legal_ref': legalRef,
    'revision': revision,
    'metadata': {
      'image_asset': imageAsset,
      'question_type': questionType,
      'stable_key': stableKey,
    },
  };
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
  int _answeredCount = 0;
  DateTime? _questionStartedAt;
  int? _historyRowId;
  String? _difficultyFilter; // null = tous niveaux
  String? _pendingDifficulty;

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
      final isOrganisation = _module.contains('organisation');
      final rows = await _sb.rpc(
        isOrganisation ? 'organisation_quiz_session' : 'quiz_scolarite_session',
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
        _answeredCount = 0;
        _questionStartedAt = DateTime.now();
        _phase = _Phase.playing;
      });
      await _cacheQuestions(list, difficulty);
      await _createHistory();
    } catch (e) {
      final cached = await _readCachedQuestions(difficulty);
      if (!mounted) return;
      if (cached.isNotEmpty) {
        setState(() {
          _questions = cached;
          _index = 0;
          _score = 0;
          _selected = null;
          _revealed = false;
          _answeredCount = 0;
          _questionStartedAt = DateTime.now();
          _phase = _Phase.playing;
        });
        await _createHistory();
      } else {
        setState(() {
          _phase = _Phase.error;
          _errorMessage = 'Impossible de démarrer le quiz, même hors ligne.';
        });
      }
      debugPrint('quiz_scolarite: démarrage réseau KO — $e');
    }
  }

  String _cacheKey(String? difficulty) =>
      'copiq_quiz_cache_v2_${_module}_${difficulty ?? 'all'}';

  Future<void> _cacheQuestions(
    List<QuizScolariteQuestion> questions,
    String? difficulty,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _cacheKey(difficulty),
      jsonEncode(questions.map((q) => q.toJson()).toList()),
    );
  }

  Future<List<QuizScolariteQuestion>> _readCachedQuestions(
    String? difficulty,
  ) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(_cacheKey(difficulty));
      if (raw == null) return const [];
      return (jsonDecode(raw) as List)
          .whereType<Map>()
          .map(
            (row) =>
                QuizScolariteQuestion.fromJson(Map<String, dynamic>.from(row)),
          )
          .where((q) => q.options.length == 4)
          .toList();
    } catch (_) {
      return const [];
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
    try {
      if (answered <= 0) {
        await _sb
            .from('quiz_history')
            .delete()
            .eq('id', _historyRowId!)
            .eq('uid', user.id);
        _historyRowId = null;
        return;
      }
      await _sb
          .from('quiz_history')
          .update({
            'score': (_score * 100 ~/ answered).clamp(0, 100),
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
    final track = UserContextService.I.trackOrDefault;
    await LearningAnswerHistoryService().record(
      historyId: _historyRowId,
      track: track,
      mode: 'school',
      moduleKey: _module,
      quizKey: 'quiz_scolarite_dynamique',
      questionId: q.stableKey,
      question: q.question,
      options: q.options,
      userAnswer: _selected ?? '',
      correctAnswer: q.answer,
      isCorrect: correct,
      explanation: q.explanation,
      difficulty: q.difficulty,
      responseTimeMs: _questionStartedAt == null
          ? null
          : DateTime.now().difference(_questionStartedAt!).inMilliseconds,
      questionPosition: _index + 1,
      questionVersion: q.revision.toString(),
    );
  }

  // ─── Jeu ───────────────────────────────────────────────────────────────

  void _select(String option) {
    if (_revealed) return;
    HapticFeedback.selectionClick();
    setState(() => _selected = option);
  }

  void _validateAnswer() {
    if (_selected == null || _revealed) return;
    final q = _questions[_index];
    final correct = _selected == q.answer;
    HapticFeedback.mediumImpact();
    setState(() {
      _revealed = true;
      _answeredCount++;
      if (correct) _score++;
    });
    unawaited(_saveAnswer(q, correct));
  }

  Future<void> _next() async {
    if (_index + 1 >= _questions.length) {
      await _finishHistory(_answeredCount);
      if (!mounted) return;
      setState(() => _phase = _Phase.finished);
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _revealed = false;
      _questionStartedAt = DateTime.now();
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
    await _finishHistory(_answeredCount);
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
        await QuizReportQueueService(client: _sb).send({
          'user_uid': user?.id,
          'email': user?.email,
          'question_id': q?.stableKey,
          'question_version': q?.revision.toString(),
          'question_text': q?.question ?? '',
          // Permet à l'admin de retrouver la ligne exacte à corriger.
          'source_file': 'quiz_scolarite_questions#${q?.id ?? 0}',
          'question_category': q?.category,
          'question_difficulty': q?.difficulty,
          'question_answer': q?.answer,
          'question_options': q?.options,
          'question_snapshot': q?.toJson() ?? const <String, dynamic>{},
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
    final bg = isDark ? const Color(0xFF071028) : const Color(0xFFF4F6FD);

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
            _phase == _Phase.finished ? (_config?.title ?? 'Quiz') : '',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
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
    final textColor = isDark ? Colors.white : const Color(0xFF212529);
    final secondary = textColor.withValues(alpha: .72);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF071028), Color(0xFF111936)]
              : const [Color(0xFFF8FAFF), Color(0xFFE9EDFF)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sélectionne le niveau de\ndifficulté',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'InstrumentSans',
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nouvelles questions à chaque partie.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondary,
                    fontFamily: 'InstrumentSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 26),
                _difficultyCard(
                  label: 'Facile',
                  difficulty: 'Facile',
                  icon: Icons.eco_rounded,
                  tint: const Color(0xFF22C55E),
                  isDark: isDark,
                  count: _counts['facile'] ?? 0,
                ),
                const SizedBox(height: 14),
                _difficultyCard(
                  label: 'Moyen',
                  difficulty: 'Moyenne',
                  icon: Icons.military_tech_rounded,
                  tint: const Color(0xFFF0A51B),
                  isDark: isDark,
                  count: _counts['moyenne'] ?? 0,
                ),
                const SizedBox(height: 14),
                _difficultyCard(
                  label: 'Difficile',
                  difficulty: 'Difficile',
                  icon: Icons.emoji_events_rounded,
                  tint: const Color(0xFFE5484D),
                  isDark: isDark,
                  count: _counts['difficile'] ?? 0,
                ),
                const SizedBox(height: 26),
                SizedBox(
                  height: 64,
                  child: FilledButton(
                    onPressed: _pendingDifficulty == null
                        ? null
                        : () => _startQuiz(difficulty: _pendingDifficulty),
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.white
                          : const Color(0xFF212529),
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      disabledBackgroundColor: isDark
                          ? Colors.white.withValues(alpha: .12)
                          : const Color(0xFFCBD2E5),
                      disabledForegroundColor: secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      _pendingDifficulty == null
                          ? 'Choisis un niveau'
                          : 'Commencer',
                      style: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 64,
                  child: OutlinedButton.icon(
                    onPressed: (_counts['total'] ?? 0) > 0
                        ? () => _startQuiz()
                        : null,
                    icon: const Icon(Icons.shuffle_rounded, size: 21),
                    label: const Text('Mélanger les 3 niveaux'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      side: BorderSide(color: textColor.withValues(alpha: .7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'InstrumentSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
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

  Widget _difficultyCard({
    required String label,
    required String difficulty,
    required IconData icon,
    required Color tint,
    required bool isDark,
    required int count,
  }) {
    final active = _pendingDifficulty == difficulty;
    final enabled = count > 0;
    final inactiveBorder = isDark
        ? Colors.white.withValues(alpha: .16)
        : Colors.white.withValues(alpha: .85);

    return Opacity(
      opacity: enabled ? 1 : .45,
      child: Semantics(
        button: true,
        selected: active,
        label: 'Niveau $label',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled
                ? () {
                    HapticFeedback.selectionClick();
                    setState(() => _pendingDifficulty = difficulty);
                  }
                : null,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              height: 136,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: tint.withValues(alpha: isDark ? .18 : .20),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: active ? tint : inactiveBorder,
                  width: active ? 2 : 1,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: tint.withValues(alpha: .10),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tint.withValues(alpha: .13),
                      border: Border.all(color: tint.withValues(alpha: .55)),
                    ),
                    child: Icon(icon, color: tint, size: 27),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF212529),
                        fontFamily: 'InstrumentSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 31,
                    height: 31,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active ? tint : Colors.white,
                        width: 2.5,
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? tint : Colors.transparent,
                      ),
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

  Widget _buildQuestion(bool isDark) {
    final q = _questions[_index];
    final surface = isDark ? const Color(0xFF151A31) : Colors.white;
    const accent = Color(0xFF6C63FF);
    final textColor = isDark ? Colors.white : const Color(0xFF212529);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF071028), Color(0xFF111936)]
              : const [Color(0xFFF8FAFF), Color(0xFFE8ECFF)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${_index + 1} / ${_questions.length}',
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'InstrumentSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: (_index + 1) / _questions.length,
                    minHeight: 7,
                    color: accent,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: .10)
                        : const Color(0xFFE7E9F1),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    q.question,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'InstrumentSans',
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.18,
                    ),
                  ),
                  if (q.imageAsset != null && q.imageAsset!.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    Semantics(
                      image: true,
                      label: 'Insigne à identifier',
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 150),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .9),
                          ),
                        ),
                        child: Image.asset(
                          q.imageAsset!,
                          height: 190,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 34,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Visuel momentanément indisponible'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ...q.options.map(
                    (o) => _optionTile(o, q, surface, accent, isDark),
                  ),
                  if (_revealed && (q.explanation?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF22C55E,
                        ).withValues(alpha: isDark ? .15 : .10),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF22C55E).withValues(alpha: .65),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 36,
                            color: Color(0xFF22C55E),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Text(
                              q.explanation!,
                              style: TextStyle(
                                color: textColor,
                                fontFamily: 'InstrumentSans',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.42,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 62,
                    child: FilledButton(
                      onPressed: !_revealed
                          ? (_selected == null ? null : _validateAnswer)
                          : _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        disabledBackgroundColor: isDark
                            ? Colors.white.withValues(alpha: .10)
                            : const Color(0xFFCAD0E2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31),
                        ),
                      ),
                      child: Text(
                        !_revealed
                            ? 'Valider'
                            : (_index + 1 >= _questions.length
                                  ? 'Résultats'
                                  : 'Suivant'),
                        style: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 62,
                    child: OutlinedButton(
                      onPressed: _requestFinish,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF5350),
                        side: const BorderSide(
                          color: Color(0xFFEF6C6A),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'InstrumentSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: const FittedBox(child: Text('Mettre fin')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(
    String option,
    QuizScolariteQuestion q,
    Color surface,
    Color accent,
    bool isDark,
  ) {
    const good = Color(0xFF27C93F);
    const bad = Color(0xFFE8574B);

    Color border = isDark ? Colors.white.withValues(alpha: .10) : Colors.white;
    Color bg = surface;
    IconData? trailingIcon;
    Color radioColor = isDark
        ? Colors.white.withValues(alpha: .30)
        : const Color(0xFFE2E5EC);

    if (!_revealed && option == _selected) {
      border = accent;
      bg = accent.withValues(alpha: .10);
      radioColor = accent;
    }

    if (_revealed) {
      if (option == q.answer) {
        border = good;
        bg = good.withValues(alpha: .10);
        trailingIcon = Icons.check_circle_rounded;
        radioColor = good;
      } else if (option == _selected) {
        border = bad;
        bg = bad.withValues(alpha: .10);
        trailingIcon = Icons.cancel_rounded;
        radioColor = bad;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _revealed ? null : () => _select(option),
          child: Container(
            constraints: const BoxConstraints(minHeight: 82),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: border,
                width: option == _selected || (_revealed && option == q.answer)
                    ? 1.6
                    : 1,
              ),
              boxShadow: isDark
                  ? null
                  : const [
                      BoxShadow(
                        color: Color(0x100A1638),
                        blurRadius: 16,
                        offset: Offset(0, 7),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: radioColor, width: 2.2),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: option == _selected && !_revealed
                          ? radioColor
                          : Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF212529),
                      fontFamily: 'InstrumentSans',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      height: 1.28,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 10),
                  Icon(trailingIcon, size: 28, color: border),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(bool isDark) {
    final total = _answeredCount;
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
