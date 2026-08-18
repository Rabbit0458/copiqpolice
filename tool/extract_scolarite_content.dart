import 'dart:convert';
import 'dart:io';

const roots = ['lib/content/gpx_scolarite', 'lib/content/pa_scolarite'];
const outputDir = 'progression/migration_data';

void main() {
  final files = <File>[];
  for (final root in roots) {
    files.addAll(
      Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart')),
    );
  }
  files.sort((a, b) => a.path.compareTo(b.path));
  if (files.length != 1409)
    throw StateError('1409 fichiers attendus, ${files.length} trouvés.');

  final dir = Directory(outputDir)..createSync(recursive: true);
  final registry = File('${dir.path}/sources.jsonl').openWrite();
  final courses = File('${dir.path}/courses.jsonl').openWrite();
  final questions = File('${dir.path}/quiz_questions.jsonl').openWrite();
  var courseCount = 0, quizFileCount = 0, questionCount = 0;
  final usedCourseRoutes = <String>{};

  for (var i = 0; i < files.length; i++) {
    final file = files[i];
    final path = file.path.replaceAll('\\', '/');
    final source = file.readAsStringSync();
    final info = _extract(path, source, i + 1, usedCourseRoutes);
    registry.writeln(jsonEncode(info.registry));
    if (info.course != null) {
      courses.writeln(jsonEncode(info.course));
      courseCount++;
    }
    for (final question in info.questions) {
      questions.writeln(jsonEncode(question));
      questionCount++;
    }
    if (info.kind == 'quiz') quizFileCount++;
  }
  registry.close();
  courses.close();
  questions.close();
  File('${dir.path}/SUMMARY.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'source_files': files.length,
      'courses_and_introductions': courseCount,
      'quiz_files': quizFileCount,
      'quiz_questions': questionCount,
    }),
  );
  stdout.writeln(
    'Extraction terminée : ${files.length} sources, $courseCount cours, $quizFileCount fichiers quiz, $questionCount questions.',
  );
}

_Extraction _extract(
  String path,
  String source,
  int order,
  Set<String> usedCourseRoutes,
) {
  final track = path.contains('/gpx_scolarite/') ? 'gpx' : 'pa';
  final relative = path.substring(
    path.indexOf('${track}_scolarite/') + '${track}_scolarite/'.length,
  );
  final parts = relative.split('/');
  final module = parts.first.replaceAll('.dart', '');
  final quizModule = '${track}_${relative.replaceAll('.dart', '')}'
      .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '')
      .toLowerCase();
  final section = parts.length > 2 ? parts[1] : null;
  final lower = path.toLowerCase();
  final isQuiz =
      lower.contains('quiz') ||
      lower.contains('quizz') ||
      RegExp(r'\b(?:QuizQuestion|QcmQuestion|Question)\s*\(').hasMatch(source);
  final isIntro = !isQuiz && lower.contains('intro');
  final kind = isQuiz
      ? 'quiz'
      : isIntro
      ? 'introduction'
      : 'course';
  final declaredRoute = RegExp(
    r'''static\s+const\s+String\s+routeName\s*=\s*['"]([^'"]+)['"]''',
  ).firstMatch(source)?.group(1);
  var route =
      declaredRoute ??
      '/${track}_scolarite/${relative.replaceAll('.dart', '')}';
  if (!isQuiz && !usedCourseRoutes.add(route)) {
    route = '/${track}_scolarite/${relative.replaceAll('.dart', '')}';
    var suffix = 2;
    final base = route;
    while (!usedCourseRoutes.add(route)) {
      route = '${base}_$suffix';
      suffix++;
    }
  }
  final literals = _stringLiterals(source).where(_isContentString).toList();
  final title = _title(source) ?? _human(parts.last.replaceAll('.dart', ''));
  final blocks = <Map<String, dynamic>>[];
  for (final value in literals) {
    final text = value.trim();
    if (text == title || text.startsWith('package:') || text == declaredRoute)
      continue;
    final heading =
        text.length < 100 &&
        !text.endsWith('.') &&
        (RegExp(
          r'^(?:[IVX]+\.|\d+[.)]|[A-ZÀ-Ÿ][A-ZÀ-Ÿ\s’\-]{4,})',
        ).hasMatch(text));
    blocks.add({
      'type': heading ? 'heading' : 'paragraph',
      'text': text,
      if (heading) 'level': 2,
    });
  }
  final body = blocks
      .map((b) => b['type'] == 'heading' ? '## ${b['text']}' : b['text'])
      .join('\n\n');
  final hash = _fnv1a64(utf8.encode(source));
  final questions = isQuiz
      ? _quizQuestions(source, path, track, quizModule, hash)
      : <Map<String, dynamic>>[];
  final payload = {
    'title': title,
    'route': route,
    'class_name': RegExp(
      r'class\s+([A-Za-z0-9_]+)\s+extends\s+(?:StatefulWidget|StatelessWidget|ConsumerWidget)',
    ).firstMatch(source)?.group(1),
    // Les quiz sont intégralement normalisés dans quiz_scolarite_questions ;
    // ne pas dupliquer leurs dizaines de milliers de chaînes dans le registre.
    'blocks': isQuiz ? const <Map<String, dynamic>>[] : blocks,
    'assets': RegExp(
      r'''assets/[A-Za-z0-9_./%À-ÿ -]+''',
    ).allMatches(source).map((m) => m.group(0)).toSet().toList(),
  };
  final registry = {
    'source_path': path,
    'track': track,
    'content_type': kind,
    'module': module,
    'section': section,
    'source_hash': hash,
    'source_bytes': utf8.encode(source).length,
    'source_lines': source.isEmpty
        ? 0
        : '\n'.allMatches(source).length + (source.endsWith('\n') ? 0 : 1),
    'course_route': isQuiz ? null : route,
    'quiz_question_count': questions.length,
    'migration_status': 'extracted',
    'extracted_payload': payload,
  };
  final course = isQuiz
      ? null
      : {
          'route': route,
          'track': track,
          'module': module,
          'section': section,
          'code': null,
          'title': title,
          'subtitle': null,
          'body_md': body,
          'content_blocks': blocks,
          'key_points': const [],
          'legal_refs': const [],
          'quiz_module': null,
          'color_hex': track == 'pa' ? '#C0392B' : '#1147D9',
          'sort_order': order,
          'publication_status': 'published',
          'source_path': path,
          'source_hash': hash,
          'source_kind': kind,
          'metadata': {
            'legacy_route_declared': declaredRoute != null,
            'extraction_version': 1,
          },
        };
  return _Extraction(kind, registry, course, questions);
}

List<Map<String, dynamic>> _quizQuestions(
  String source,
  String path,
  String track,
  String module,
  String hash,
) {
  final out = <Map<String, dynamic>>[];
  final starts = RegExp(
    r'(?:const\s+)?(?:QuizQuestion|QcmQuestion|Question)\s*\(',
  ).allMatches(source);
  var index = 0;
  for (final start in starts) {
    final open = source.indexOf('(', start.start);
    final end = _matchingParen(source, open);
    if (end < 0) continue;
    final chunk = source.substring(open + 1, end);
    final question =
        _namedString(chunk, 'question') ??
        _namedString(chunk, 'text') ??
        _namedString(chunk, 'enonce');
    final answer =
        _namedString(chunk, 'answer') ??
        _namedString(chunk, 'correctAnswer') ??
        _namedString(chunk, 'bonneReponse');
    final extractedOptions =
        _namedList(chunk, 'options') ??
        _namedList(chunk, 'answers') ??
        _namedList(chunk, 'reponses');
    if (question == null ||
        answer == null ||
        extractedOptions == null ||
        extractedOptions.length < 2)
      continue;
    final options = [...extractedOptions];
    if (!options.contains(answer)) options.add(answer);
    index++;
    out.add({
      'module': module,
      'track': track,
      'category': _namedString(chunk, 'category') ?? _human(module),
      'difficulty': _difficulty(_namedString(chunk, 'difficulty')),
      'question': question,
      'options': options,
      'answer': answer,
      'explanation':
          _namedString(chunk, 'explanation') ??
          _namedString(chunk, 'explication'),
      'legal_ref':
          _namedString(chunk, 'legalRef') ?? _namedString(chunk, 'reference'),
      'position': index,
      'source_path': path,
      'source_hash': hash,
      'source_question_key': '$index',
      'publication_status': 'published',
      'metadata': {'extraction_version': 1},
    });
  }
  return out;
}

String? _namedString(String chunk, String name) {
  final m = RegExp('\\b${RegExp.escape(name)}\\s*:').firstMatch(chunk);
  if (m == null) return null;
  return _readAdjacentStrings(chunk, m.end)?.trim();
}

List<String>? _namedList(String chunk, String name) {
  final m = RegExp(
    '\\b${RegExp.escape(name)}\\s*:\\s*(?:const\\s*)?\\[',
  ).firstMatch(chunk);
  if (m == null) return null;
  final close = _matchingSquare(chunk, chunk.indexOf('[', m.start));
  if (close < 0) return null;
  return _stringLiterals(
    chunk.substring(chunk.indexOf('[', m.start) + 1, close),
  ).where((s) => s.trim().isNotEmpty).toList();
}

String? _readAdjacentStrings(String source, int from) {
  final values = <String>[];
  var i = from;
  while (i < source.length) {
    while (i < source.length && RegExp(r'\s').hasMatch(source[i])) i++;
    if (i >= source.length || (source[i] != "'" && source[i] != '"')) break;
    final parsed = _readString(source, i);
    if (parsed == null) break;
    values.add(parsed.$1);
    i = parsed.$2;
  }
  return values.isEmpty ? null : values.join();
}

List<String> _stringLiterals(String source) {
  final out = <String>[];
  for (var i = 0; i < source.length;) {
    if (source[i] == "'" || source[i] == '"') {
      final parsed = _readString(source, i);
      if (parsed != null) {
        out.add(parsed.$1);
        i = parsed.$2;
        continue;
      }
    }
    i++;
  }
  return out;
}

(String, int)? _readString(String s, int start) {
  final quote = s[start];
  final triple =
      start + 2 < s.length && s[start + 1] == quote && s[start + 2] == quote;
  final begin = start + (triple ? 3 : 1);
  final b = StringBuffer();
  for (var i = begin; i < s.length;) {
    if (triple &&
        i + 2 < s.length &&
        s[i] == quote &&
        s[i + 1] == quote &&
        s[i + 2] == quote)
      return (b.toString(), i + 3);
    if (!triple && s[i] == quote) return (b.toString(), i + 1);
    if (s[i] == r'\' && i + 1 < s.length) {
      final n = s[i + 1];
      b.write(switch (n) {
        'n' => '\n',
        'r' => '\r',
        't' => '\t',
        _ => n,
      });
      i += 2;
      continue;
    }
    b.write(s[i]);
    i++;
  }
  return null;
}

int _matchingParen(String s, int open) => _matching(s, open, '(', ')');
int _matchingSquare(String s, int open) => _matching(s, open, '[', ']');
int _matching(String s, int open, String left, String right) {
  var depth = 0;
  for (var i = open; i < s.length; i++) {
    if (s[i] == "'" || s[i] == '"') {
      final p = _readString(s, i);
      if (p != null) {
        i = p.$2 - 1;
        continue;
      }
    }
    if (s[i] == left) depth++;
    if (s[i] == right && --depth == 0) return i;
  }
  return -1;
}

bool _isContentString(String s) {
  final v = s.trim();
  if (v.length < 3 ||
      v.startsWith('package:') ||
      v.startsWith('dart:') ||
      v.startsWith('/gpx') ||
      v.startsWith('/pa'))
    return false;
  if (RegExp(
    r'^(?:#[0-9A-Fa-f]{6,8}|[A-Za-z0-9_./%-]+\.(?:dart|png|jpg|jpeg|webp|svg|mp3|wav|pdf))$',
  ).hasMatch(v))
    return false;
  return RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(v);
}

String? _title(String source) {
  for (final r in [
    RegExp(r'''title\s*:\s*(?:const\s+)?Text\(\s*['"]([^'"\n]{2,180})['"]'''),
    RegExp(r'''(?:const\s+)?Text\(\s*['"]([^'"\n]{3,180})['"]'''),
  ]) {
    final v = r.firstMatch(source)?.group(1);
    if (v != null) return v.replaceAll(r'\n', ' ').trim();
  }
  return null;
}

String _human(String s) => s
    .replaceAll(RegExp(r'[_-]+'), ' ')
    .trim()
    .split(' ')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');
String _difficulty(String? value) {
  final v = (value ?? '').toLowerCase().trim();
  if (v.contains('facile') || v.contains('début') || v.contains('debut')) {
    return 'Facile';
  }
  if (v.contains('diffic') || v.contains('expert') || v.contains('avanc')) {
    return 'Difficile';
  }
  return 'Moyenne';
}

String _fnv1a64(List<int> bytes) {
  var h = 0xcbf29ce484222325;
  for (final b in bytes) {
    h ^= b;
    h = (h * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
  }
  return h.toRadixString(16).padLeft(16, '0');
}

class _Extraction {
  _Extraction(this.kind, this.registry, this.course, this.questions);
  final String kind;
  final Map<String, dynamic> registry;
  final Map<String, dynamic>? course;
  final List<Map<String, dynamic>> questions;
}
