import 'dart:convert';
import 'dart:io';

const _roots = ['lib/content/gpx_scolarite', 'lib/content/pa_scolarite'];
const _output = 'progression/migration_data/text_fragments.jsonl';

Future<void> main() async {
  final files = <File>[
    for (final root in _roots)
      ...Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart')),
  ]..sort((a, b) => a.path.compareTo(b.path));

  if (files.length != 1409) {
    throw StateError('1409 fichiers attendus, ${files.length} trouvés.');
  }

  final sink = File(_output).openWrite();
  var total = 0;
  var editable = 0;
  for (final file in files) {
    final path = file.path.replaceAll('\\', '/');
    final source = file.readAsStringSync();
    final lowerPath = path.toLowerCase();
    final isQuiz =
        lowerPath.contains('/quiz') ||
        lowerPath.contains('/quizz') ||
        RegExp(
          r'\b(?:QuizQuestion|QcmQuestion|Question)\s*\(',
        ).hasMatch(source);
    // Les quiz disposent de leur modèle relationnel dédié (question, choix,
    // réponse et explication). Les inclure ici dupliquerait inutilement leurs
    // dizaines de milliers de chaînes.
    if (isQuiz) continue;
    final literals = _scanStrings(source);
    var position = 0;
    var panel = 'Informations générales';
    for (final literal in literals) {
      if (!_isEditorial(literal.value)) continue;
      position++;
      final contextStart = (literal.start - 220).clamp(0, source.length);
      final contextEnd = (literal.end + 420).clamp(0, source.length);
      final context = source.substring(contextStart, contextEnd);
      final component = _componentBefore(source, literal.start);
      if (_startsPanel(source, literal.start, component, literal.value)) {
        panel = literal.value.trim();
      }
      final style = _styleHints(context);
      final canEdit = !_isTechnical(literal.value, component);
      sink.writeln(
        jsonEncode({
          'source_path': path,
          'fragment_key': 'f${position.toString().padLeft(5, '0')}',
          'position': position,
          'component': component,
          'panel': panel,
          'text_value': literal.value,
          'original_text': literal.value,
          'style_payload': style,
          'is_editable': canEdit,
          'source_offset': literal.start,
        }),
      );
      total++;
      if (canEdit) editable++;
    }
  }
  await sink.close();
  stdout.writeln(
    'Fragments exacts extraits : $total au total, $editable éditables, '
    '${files.length} fichiers couverts.',
  );
}

bool _startsPanel(String source, int offset, String component, String value) {
  final text = value.trim();
  if (text.length > 120 || text.contains('\n')) return false;
  final start = (offset - 180).clamp(0, source.length);
  final before = source.substring(start, offset);
  if (before.contains('_ConditionCard(') && component == 'title') return true;
  return RegExp(
        r'^(?:Définition|Introduction|[IVX]+\s*[—.-]|\d+\s*[—.-])',
        caseSensitive: false,
      ).hasMatch(text) &&
      (component == 'title' || component == '_SubTitle');
}

String _componentBefore(String source, int offset) {
  final start = (offset - 240).clamp(0, source.length);
  final before = source.substring(start, offset);
  final matches = RegExp(
    r'(TextSpan|Text|SelectableText|_Paragraph|_SubTitle|_NotaBox|_ConditionCard|title|subtitle|label|tooltip)\s*[:(]',
  ).allMatches(before).toList();
  return matches.isEmpty ? 'string' : matches.last.group(1)!;
}

Map<String, dynamic> _styleHints(String context) {
  final colors = RegExp(
    r'(?:color\s*:\s*)?((?:const\s+)?Color\(0x[0-9A-Fa-f]{8}\)|Colors\.[A-Za-z0-9_]+|_[A-Za-z0-9_]*(?:Red|Blue|Green|Pink|Amber|Grey|Color))',
  ).allMatches(context).map((match) => match.group(1)!).toSet().toList();
  final weights = RegExp(
    r'FontWeight\.w[0-9]+',
  ).allMatches(context).map((match) => match.group(0)!).toSet().toList();
  final sizes = RegExp(
    r'fontSize\s*:\s*([0-9.]+)',
  ).allMatches(context).map((match) => match.group(1)!).toSet().toList();
  return {
    if (colors.isNotEmpty) 'color_hints': colors,
    if (weights.isNotEmpty) 'font_weight_hints': weights,
    if (sizes.isNotEmpty) 'font_size_hints': sizes,
  };
}

bool _isEditorial(String value) {
  final text = value.trim();
  if (text.isEmpty || text.length < 2) return false;
  if (text.startsWith('package:') || text.startsWith('dart:')) return false;
  if (text.startsWith('assets/') || text.startsWith('/')) return false;
  if (RegExp(r'^[A-Za-z0-9_]+$').hasMatch(text) && !text.contains(' ')) {
    return const {
      'Retour',
      'Définition',
      'Attention',
      'Jurisprudence',
      'Répression',
      'Oui',
      'Non',
      'Vrai',
      'Faux',
    }.contains(text);
  }
  return RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(text);
}

bool _isTechnical(String value, String component) {
  final text = value.trim();
  if (component == 'tooltip') return false;
  return text.startsWith('http://') ||
      text.startsWith('https://') ||
      text.contains('Supabase') && text.contains('Exception');
}

List<_Literal> _scanStrings(String source) {
  final out = <_Literal>[];
  var i = 0;
  while (i < source.length) {
    if (i + 1 < source.length && source[i] == '/' && source[i + 1] == '/') {
      final newline = source.indexOf('\n', i + 2);
      i = newline < 0 ? source.length : newline + 1;
      continue;
    }
    if (i + 1 < source.length && source[i] == '/' && source[i + 1] == '*') {
      final close = source.indexOf('*/', i + 2);
      i = close < 0 ? source.length : close + 2;
      continue;
    }
    final char = source.codeUnitAt(i);
    if (char != 0x27 && char != 0x22) {
      i++;
      continue;
    }
    final quote = source[i];
    final triple =
        i + 2 < source.length &&
        source[i + 1] == quote &&
        source[i + 2] == quote;
    final start = i;
    i += triple ? 3 : 1;
    final buffer = StringBuffer();
    var escaped = false;
    while (i < source.length) {
      if (!triple && !escaped && source[i] == quote) {
        i++;
        break;
      }
      if (triple &&
          i + 2 < source.length &&
          source[i] == quote &&
          source[i + 1] == quote &&
          source[i + 2] == quote) {
        i += 3;
        break;
      }
      final current = source[i];
      if (!triple && !escaped && current == r'\') {
        escaped = true;
        buffer.write(current);
        i++;
        continue;
      }
      escaped = false;
      buffer.write(current);
      i++;
    }
    try {
      final raw = buffer.toString();
      final decoded = jsonDecode('"${raw.replaceAll('"', r'\"')}"') as String;
      out.add(_Literal(start, i, decoded));
    } catch (_) {
      out.add(_Literal(start, i, buffer.toString()));
    }
  }
  return out;
}

class _Literal {
  const _Literal(this.start, this.end, this.value);
  final int start;
  final int end;
  final String value;
}
