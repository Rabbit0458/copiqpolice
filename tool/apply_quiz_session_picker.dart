import 'dart:io';

const pickerImport =
    "import 'package:copiqpolice/core/quiz/quiz_session_picker.dart';";

void main() {
  final root = Directory('lib');
  var localUpdated = 0;
  var remoteUpdated = 0;
  var remoteCountsUpdated = 0;
  var importsRepaired = 0;
  var answeredTotalsRepaired = 0;
  var answeredCalculationsRepaired = 0;
  var duplicateAnsweredTotalsRemoved = 0;

  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    var source = entity.readAsStringSync();
    final repaired = source.replaceAllMapped(
      RegExp(
        r"(import 'package:copiqpolice/core/widgets/app_notifier\.dart')\n"
        '${RegExp.escape(pickerImport)}\n'
        r'(    show [^;]+;)',
      ),
      (match) => '${match.group(1)}\n${match.group(2)}\n$pickerImport',
    );
    if (repaired != source) {
      source = repaired;
      entity.writeAsStringSync(source);
      importsRepaired++;
    }
    if (source.contains('showQuizSessionPicker(') &&
        source.contains("'score': percent") &&
        !source.contains("'total_questions': answered")) {
      source = source.replaceFirst(
        "'score': percent",
        "'total_questions': answered,\n            'score': percent",
      );
      entity.writeAsStringSync(source);
      answeredTotalsRepaired++;
    }
    const oldFullBankCalculation =
        '      final int total = _qs.length.clamp(1, 1 << 30);\n'
        '      final int percent = ((_score / total) * 100).round();';
    const answeredCalculation =
        '      final int answered = _answers.where((a) => a != null).length;\n'
        '      final int totalForScore = answered <= 0 ? 1 : answered;\n'
        '      final int percent = ((_score / totalForScore) * 100).round();';
    if (source.contains(oldFullBankCalculation)) {
      source = source.replaceAll(oldFullBankCalculation, answeredCalculation);
      entity.writeAsStringSync(source);
      answeredCalculationsRepaired++;
    }
    const duplicateAnsweredTotal =
        "            'correct_count': _score,\n"
        "            'total_questions':\n"
        "                answered, // 🔥 comme grammaire: questions traitées";
    if (source.contains(duplicateAnsweredTotal)) {
      source = source.replaceAll(
        duplicateAnsweredTotal,
        "            'correct_count': _score,",
      );
      entity.writeAsStringSync(source);
      duplicateAnsweredTotalsRemoved++;
    }
    if (!source.contains('Future<void> _startQuiz({bool mix = false}) async')) {
      continue;
    }
    if (source.contains('showQuizSessionPicker(') &&
        source.contains('availableQuestions: 100,') &&
        source.contains('> fetchRandomSet({')) {
      final repositoryNeedle = RegExp(
        r'  Future<List<[^>]+>> fetchRandomSet\(\{',
      ).firstMatch(source)?.group(0);
      if (repositoryNeedle == null) continue;
      const countMethod = '''  Future<int> countAvailable({
    required String category,
    String? difficulty,
  }) async {
    dynamic query = sb
        .from('quiz_questions')
        .count(CountOption.exact)
        .eq('category', category);
    if (difficulty != null) query = query.eq('difficulty', difficulty);
    return await query as int;
  }

''';
      if (!source.contains('Future<int> countAvailable({')) {
        source = source.replaceFirst(
          repositoryNeedle,
          '$countMethod$repositoryNeedle',
        );
      }
      const oldPicker = '''    final session = await showQuizSessionPicker(
      context,
      availableQuestions: 100,
      allowFullBank: false,
    );
    if (!mounted || session == null) return;
''';
      const newPicker =
          '''    final availableQuestions = await _repo.countAvailable(
      category: _categoryNameDb,
      difficulty: _difficultyFilter,
    );
    if (!mounted) return;
    if (availableQuestions <= 0) {
      AppNotifier.warning(
        context,
        title: 'Aucune question disponible',
        message: 'Aucune question ne correspond à ce niveau pour le moment.',
      );
      return;
    }
    final session = await showQuizSessionPicker(
      context,
      availableQuestions: availableQuestions,
    );
    if (!mounted || session == null) return;
''';
      source = source.replaceFirst(oldPicker, newPicker);
      source = source.replaceAll(
        "'total_questions': 500,",
        "'total_questions': _total,",
      );
      entity.writeAsStringSync(source);
      remoteCountsUpdated++;
      continue;
    }
    if (source.contains('showQuizSessionPicker(')) continue;

    if (!source.contains(pickerImport)) {
      final lastImport = source.lastIndexOf("import '");
      if (lastImport < 0) continue;
      final end = source.indexOf(';', lastImport);
      source = source.replaceRange(end + 1, end + 1, '\n$pickerImport');
    }

    const localNeedle = '    _seedAndShuffle();\n';
    if (source.contains(localNeedle)) {
      const replacement = '''    _seedAndShuffle();
    final session = await showQuizSessionPicker(
      context,
      availableQuestions: _qs.length,
    );
    if (!mounted || session == null) return;
    if (session.questionCount < _qs.length) {
      _qs = _qs.take(session.questionCount).toList(growable: false);
      _opts = _opts.take(session.questionCount).toList(growable: false);
      _answers = List<String?>.filled(_qs.length, null);
    }
''';
      source = source.replaceFirst(localNeedle, replacement);
      localUpdated++;
    } else if (source.contains('      const int quizLength = 50;')) {
      const remoteNeedle = '    setState(() {\n      _loading = true;';
      const remotePrefix = '''    final session = await showQuizSessionPicker(
      context,
      availableQuestions: 100,
      allowFullBank: false,
    );
    if (!mounted || session == null) return;

    setState(() {
      _loading = true;''';
      if (!source.contains(remoteNeedle)) {
        stderr.writeln('Remote pattern absent: ${entity.path}');
        exitCode = 1;
        continue;
      }
      source = source.replaceFirst(remoteNeedle, remotePrefix);
      source = source.replaceFirst(
        '      const int quizLength = 50;',
        '      final quizLength = session.questionCount;',
      );
      remoteUpdated++;
    } else {
      stderr.writeln('Quiz pattern inconnu: ${entity.path}');
      exitCode = 1;
      continue;
    }
    entity.writeAsStringSync(source);
  }

  stdout.writeln('Local: $localUpdated');
  stdout.writeln('Remote: $remoteUpdated');
  stdout.writeln('Remote counts: $remoteCountsUpdated');
  stdout.writeln('Imports repaired: $importsRepaired');
  stdout.writeln('Answered totals repaired: $answeredTotalsRepaired');
  stdout.writeln(
    'Answered calculations repaired: $answeredCalculationsRepaired',
  );
  stdout.writeln(
    'Duplicate answered totals removed: $duplicateAnsweredTotalsRemoved',
  );
}
