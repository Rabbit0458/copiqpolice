/// Parseur Markdown léger utilisé par les fiches de cours COP'IQ.
///
/// Un simple retour à la ligne dans l'éditeur est considéré comme une coupure
/// typographique, pas comme un nouveau paragraphe. Un paragraphe ne se termine
/// qu'avec une ligne vide ou le début explicite d'un autre bloc Markdown.
enum CourseMarkdownBlockType {
  paragraph,
  heading,
  unorderedList,
  orderedList,
  quote,
  divider,
  table,
}

class CourseMarkdownBlock {
  const CourseMarkdownBlock({
    required this.type,
    this.text = '',
    this.headingLevel = 0,
    this.listStart = 1,
    this.items = const [],
    this.rows = const [],
  });

  final CourseMarkdownBlockType type;
  final String text;
  final int headingLevel;
  final int listStart;
  final List<String> items;
  final List<List<String>> rows;
}

List<CourseMarkdownBlock> parseCourseMarkdown(String source) {
  final normalized = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final lines = normalized.split('\n');
  final blocks = <CourseMarkdownBlock>[];
  var index = 0;

  while (index < lines.length) {
    final trimmed = lines[index].trim();
    if (trimmed.isEmpty) {
      index++;
      continue;
    }

    if (_isDivider(trimmed)) {
      blocks.add(
        const CourseMarkdownBlock(type: CourseMarkdownBlockType.divider),
      );
      index++;
      continue;
    }

    if (_startsTable(lines, index)) {
      final result = _readTable(lines, index);
      blocks.add(
        CourseMarkdownBlock(
          type: CourseMarkdownBlockType.table,
          rows: result.rows,
        ),
      );
      index = result.nextIndex;
      continue;
    }

    if (trimmed.startsWith('>')) {
      final quoteLines = <String>[];
      while (index < lines.length && lines[index].trim().startsWith('>')) {
        quoteLines.add(lines[index].trim().replaceFirst(RegExp(r'^>\s?'), ''));
        index++;
      }
      blocks.add(
        CourseMarkdownBlock(
          type: CourseMarkdownBlockType.quote,
          text: _joinSoftWrappedLines(quoteLines),
        ),
      );
      continue;
    }

    final heading = RegExp(r'^(#{1,6})\s+(.*?)\s*#*\s*$').firstMatch(trimmed);
    if (heading != null) {
      blocks.add(
        CourseMarkdownBlock(
          type: CourseMarkdownBlockType.heading,
          headingLevel: heading.group(1)!.length,
          text: heading.group(2)!.trim(),
        ),
      );
      index++;
      continue;
    }

    if (_unorderedItem(trimmed) != null) {
      final result = _readList(lines, index, ordered: false);
      blocks.add(
        CourseMarkdownBlock(
          type: CourseMarkdownBlockType.unorderedList,
          items: result.items,
        ),
      );
      index = result.nextIndex;
      continue;
    }

    if (_orderedItem(trimmed) != null) {
      final result = _readList(lines, index, ordered: true);
      blocks.add(
        CourseMarkdownBlock(
          type: CourseMarkdownBlockType.orderedList,
          listStart: result.start,
          items: result.items,
        ),
      );
      index = result.nextIndex;
      continue;
    }

    final paragraphLines = <String>[lines[index].trimLeft()];
    index++;
    while (index < lines.length) {
      final next = lines[index].trim();
      if (next.isEmpty) {
        index++;
        break;
      }
      if (_startsTable(lines, index)) break;
      if (_startsBlock(next)) break;
      paragraphLines.add(lines[index].trimLeft());
      index++;
    }
    blocks.add(
      CourseMarkdownBlock(
        type: CourseMarkdownBlockType.paragraph,
        text: _joinSoftWrappedLines(paragraphLines),
      ),
    );
  }

  return List<CourseMarkdownBlock>.unmodifiable(blocks);
}

({List<String> items, int nextIndex, int start}) _readList(
  List<String> lines,
  int start, {
  required bool ordered,
}) {
  final items = <String>[];
  var index = start;
  final firstLine = lines[start].trim();
  final firstNumber = ordered
      ? int.tryParse(RegExp(r'^(\d+)').firstMatch(firstLine)?.group(1) ?? '')
      : null;

  while (index < lines.length) {
    final line = lines[index].trimLeft();
    final match = ordered ? _orderedItem(line) : _unorderedItem(line);
    if (match == null) break;

    final itemLines = <String>[match];
    index++;
    while (index < lines.length) {
      final continuation = lines[index].trimLeft();
      if (continuation.trim().isEmpty) {
        index++;
        break;
      }
      if ((ordered
              ? _orderedItem(continuation)
              : _unorderedItem(continuation)) !=
          null) {
        break;
      }
      if (_startsTable(lines, index) || _startsBlock(continuation.trim()))
        break;
      itemLines.add(continuation);
      index++;
    }
    items.add(_joinSoftWrappedLines(itemLines));

    if (index >= lines.length) break;
    final next = lines[index].trim();
    if ((ordered ? _orderedItem(next) : _unorderedItem(next)) == null) break;
  }

  return (
    items: List<String>.unmodifiable(items),
    nextIndex: index,
    start: firstNumber ?? 1,
  );
}

String? _unorderedItem(String line) {
  final match = RegExp(r'^[-*+]\s+(.*)$').firstMatch(line);
  return match?.group(1);
}

String? _orderedItem(String line) {
  final match = RegExp(r'^\d+[.)]\s+(.*)$').firstMatch(line);
  return match?.group(1);
}

bool _isDivider(String line) => line == '---' || line == '___' || line == '***';

bool _startsBlock(String line) =>
    _isDivider(line) ||
    line.startsWith('>') ||
    RegExp(r'^#{1,6}\s+').hasMatch(line) ||
    _unorderedItem(line) != null ||
    _orderedItem(line) != null;

bool _startsTable(List<String> lines, int index) {
  if (index + 1 >= lines.length) return false;
  final header = _splitTableRow(lines[index]);
  final divider = _splitTableRow(lines[index + 1]);
  if (header.length < 2 || divider.length != header.length) return false;
  return divider.every((cell) => RegExp(r'^:?-{3,}:?$').hasMatch(cell.trim()));
}

({List<List<String>> rows, int nextIndex}) _readTable(
  List<String> lines,
  int start,
) {
  final rows = <List<String>>[_splitTableRow(lines[start])];
  var index = start + 2; // La deuxième ligne est le séparateur Markdown.
  while (index < lines.length) {
    final line = lines[index];
    if (line.trim().isEmpty || !_hasUnescapedPipe(line)) break;
    rows.add(_splitTableRow(line));
    index++;
  }
  return (rows: List<List<String>>.unmodifiable(rows), nextIndex: index);
}

bool _hasUnescapedPipe(String line) {
  var escaped = false;
  for (final unit in line.codeUnits) {
    if (unit == 0x5C && !escaped) {
      escaped = true;
      continue;
    }
    if (unit == 0x7C && !escaped) return true;
    escaped = false;
  }
  return false;
}

List<String> _splitTableRow(String line) {
  final cells = <String>[];
  final buffer = StringBuffer();
  var escaped = false;
  for (final unit in line.trim().codeUnits) {
    if (unit == 0x5C && !escaped) {
      escaped = true;
      continue;
    }
    if (unit == 0x7C && !escaped) {
      cells.add(buffer.toString().trim());
      buffer.clear();
    } else {
      if (escaped && unit != 0x7C) buffer.writeCharCode(0x5C);
      buffer.writeCharCode(unit);
    }
    escaped = false;
  }
  if (escaped) buffer.writeCharCode(0x5C);
  cells.add(buffer.toString().trim());
  if (cells.isNotEmpty && cells.first.isEmpty) cells.removeAt(0);
  if (cells.isNotEmpty && cells.last.isEmpty) cells.removeLast();
  return List<String>.unmodifiable(cells);
}

String _joinSoftWrappedLines(List<String> lines) {
  final buffer = StringBuffer();
  var previousWasHardBreak = false;
  for (final rawLine in lines) {
    var line = rawLine;
    final spacesHardBreak = RegExp(r' {2,}$').hasMatch(line);
    final slashHardBreak = line.endsWith(r'\');
    final hardBreak = spacesHardBreak || slashHardBreak;
    if (slashHardBreak) {
      line = line.substring(0, line.length - 1).trimRight();
    } else if (spacesHardBreak) {
      line = line.replaceFirst(RegExp(r' {2,}$'), '');
    } else {
      line = line.trimRight();
    }
    if (buffer.isNotEmpty) buffer.write(previousWasHardBreak ? '\n' : ' ');
    buffer.write(line.trimLeft());
    previousWasHardBreak = hardBreak;
  }
  return buffer.toString().trim();
}
