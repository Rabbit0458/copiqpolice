import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

const _manifest = 'progression/migration_data/text_fragments.jsonl';
const _import =
    "import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';";

void main(List<String> arguments) {
  final requested = _argument(arguments, '--file');
  final applyAll = arguments.contains('--all');
  if (requested == null && !applyAll) {
    throw ArgumentError('Utilise --file <chemin> pour un essai ou --all.');
  }

  final rowsBySource = <String, List<Map<String, dynamic>>>{};
  for (final line in File(_manifest).readAsLinesSync()) {
    if (line.trim().isEmpty) continue;
    final row = jsonDecode(line) as Map<String, dynamic>;
    final path = row['source_path'] as String;
    if (requested != null && path != requested) continue;
    (rowsBySource[path] ??= []).add(row);
  }

  var fileCount = 0;
  var fragmentCount = 0;
  var interpolationCount = 0;
  for (final entry in rowsBySource.entries) {
    final file = File(entry.key);
    var source = file.readAsStringSync();
    if (source.contains('ScolariteText.value(')) continue;

    final rowsByOffset = <int, Map<String, dynamic>>{
      for (final row in entry.value) row['source_offset'] as int: row,
    };
    final unit = parseString(
      content: source,
      path: entry.key,
      throwIfDiagnostics: false,
    ).unit;
    final collector = _LiteralCollector(source, entry.key, rowsByOffset);
    unit.accept(collector);
    interpolationCount += collector.skippedInterpolations;
    if (collector.replacements.isEmpty) continue;

    final replacements = <_Replacement>[
      ...collector.replacements,
      ...collector.constReplacements,
    ]..sort((a, b) => b.start.compareTo(a.start));
    var previousStart = source.length + 1;
    for (final replacement in replacements) {
      if (replacement.end > previousStart) {
        throw StateError('Remplacements superposés dans ${entry.key}.');
      }
      source = source.replaceRange(
        replacement.start,
        replacement.end,
        replacement.value,
      );
      previousStart = replacement.start;
    }

    if (!source.contains(_import)) {
      final matches = RegExp(
        r"^import .+;$",
        multiLine: true,
      ).allMatches(source);
      if (matches.isEmpty) {
        throw StateError('Imports introuvables dans ${entry.key}');
      }
      final last = matches.last;
      final lineEnd = source.indexOf('\n', last.end);
      final insertion = lineEnd < 0 ? source.length : lineEnd + 1;
      source = source.replaceRange(insertion, insertion, '$_import\n');
    }

    file.writeAsStringSync(source);
    fileCount++;
    fragmentCount += collector.fragmentCount;
  }
  stdout.writeln(
    '$fragmentCount fragments branchés dans $fileCount fichier(s); '
    '$interpolationCount interpolation(s) conservée(s) intacte(s).',
  );
}

class _LiteralCollector extends RecursiveAstVisitor<void> {
  _LiteralCollector(this.source, this.sourcePath, this.rowsByOffset);

  final String source;
  final String sourcePath;
  final Map<int, Map<String, dynamic>> rowsByOffset;
  final List<_Replacement> replacements = [];
  final Map<int, _Replacement> _constReplacements = {};
  int fragmentCount = 0;
  int skippedInterpolations = 0;

  Iterable<_Replacement> get constReplacements => _constReplacements.values;

  @override
  void visitAdjacentStrings(AdjacentStrings node) {
    if (node.strings.any((literal) => literal is StringInterpolation)) {
      skippedInterpolations++;
      return;
    }
    final parts = <String>[];
    var hasRemotePart = false;
    var remoteParts = 0;
    for (final literal in node.strings) {
      final row = _rowFor(literal);
      if (row == null) {
        parts.add(source.substring(literal.offset, literal.end));
      } else {
        parts.add(_remote(row, source.substring(literal.offset, literal.end)));
        hasRemotePart = true;
        remoteParts++;
      }
    }
    if (!hasRemotePart) return;
    replacements.add(_Replacement(node.offset, node.end, parts.join(' + ')));
    fragmentCount += remoteParts;
    _makeAncestorsDynamic(node);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    skippedInterpolations++;
  }

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    if (node.parent is AdjacentStrings) return;
    final row = _rowFor(node);
    if (row == null) return;
    replacements.add(
      _Replacement(
        node.offset,
        node.end,
        _remote(row, source.substring(node.offset, node.end)),
      ),
    );
    fragmentCount++;
    _makeAncestorsDynamic(node);
  }

  Map<String, dynamic>? _rowFor(StringLiteral node) {
    AstNode? ancestor = node.parent;
    while (ancestor != null) {
      if (ancestor is Directive) return null;
      if (ancestor is DefaultFormalParameter ||
          ancestor is AssertInitializer ||
          ancestor is Annotation ||
          ancestor.runtimeType.toString().contains('SwitchCase') ||
          ancestor.runtimeType.toString().contains('SwitchPatternCase')) {
        return null;
      }
      ancestor = ancestor.parent;
    }
    var quoteOffset = node.offset;
    while (quoteOffset < node.end &&
        source[quoteOffset] != "'" &&
        source[quoteOffset] != '"') {
      quoteOffset++;
    }
    return rowsByOffset[quoteOffset] ?? rowsByOffset[node.offset];
  }

  String _remote(Map<String, dynamic> row, String fallback) =>
      'ScolariteText.value(${_dart(sourcePath)}, '
      '${_dart(row['fragment_key'] as String)}, $fallback)';

  void _makeAncestorsDynamic(AstNode node) {
    AstNode? current = node.parent;
    while (current != null) {
      if (current is InstanceCreationExpression &&
          current.keyword?.lexeme == 'const') {
        _removeConst(current.keyword!);
      } else if (current is ListLiteral && current.constKeyword != null) {
        _removeConst(current.constKeyword!);
      } else if (current is SetOrMapLiteral && current.constKeyword != null) {
        _removeConst(current.constKeyword!);
      } else if (current is VariableDeclarationList &&
          current.keyword?.lexeme == 'const') {
        final token = current.keyword!;
        _constReplacements[token.offset] = _Replacement(
          token.offset,
          token.end,
          'final',
        );
      }
      current = current.parent;
    }
  }

  void _removeConst(dynamic token) {
    _constReplacements[token.offset as int] = _Replacement(
      token.offset as int,
      token.end as int,
      '',
    );
  }
}

String? _argument(List<String> arguments, String name) {
  final index = arguments.indexOf(name);
  return index >= 0 && index + 1 < arguments.length
      ? arguments[index + 1]
      : null;
}

String _dart(String value) => jsonEncode(value).replaceAll(r'$', r'\$');

class _Replacement {
  const _Replacement(this.start, this.end, this.value);
  final int start;
  final int end;
  final String value;
}
