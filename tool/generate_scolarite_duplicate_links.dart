import 'dart:convert';
import 'dart:io';

const _input = 'progression/migration_data/text_fragments.jsonl';
const _output = 'progression/migration_data/duplicate_links.sql';

void main() {
  final bySource = <String, List<Map<String, dynamic>>>{};
  for (final line in File(_input).readAsLinesSync()) {
    if (line.trim().isEmpty) continue;
    final row = jsonDecode(line) as Map<String, dynamic>;
    (bySource[row['source_path'] as String] ??= []).add(row);
  }

  final paByKey = <String, List<String>>{};
  for (final entry in bySource.entries.where(
    (e) => e.key.contains('/pa_scolarite/'),
  )) {
    (paByKey[_matchKey(entry.key, entry.value)] ??= []).add(entry.key);
  }

  final pairs = <(String, String)>[];
  for (final entry in bySource.entries.where(
    (e) => e.key.contains('/gpx_scolarite/'),
  )) {
    final candidates = paByKey[_matchKey(entry.key, entry.value)] ?? const [];
    if (candidates.length == 1) pairs.add((entry.key, candidates.single));
  }
  pairs.sort((a, b) => a.$1.compareTo(b.$1));

  final sql = StringBuffer()
    ..writeln('-- Doublons GPX/PA prouvés identiques fragment par fragment.')
    ..writeln('insert into public.scolarite_content_links')
    ..writeln('  (gpx_source_path,pa_source_path,link_status)')
    ..writeln('values');
  for (var index = 0; index < pairs.length; index++) {
    final pair = pairs[index];
    sql.write("('${_q(pair.$1)}','${_q(pair.$2)}','linked')");
    sql.writeln(index == pairs.length - 1 ? '' : ',');
  }
  if (pairs.isNotEmpty) {
    sql.writeln('on conflict (gpx_source_path) do nothing;');
  }
  File(_output).writeAsStringSync(sql.toString());
  stdout.writeln(
    '${pairs.length} doublons GPX/PA strictement identiques détectés.',
  );
}

String _matchKey(String path, List<Map<String, dynamic>> rows) {
  final basename = path.split('/').last;
  final content = rows
      .map(
        (row) => [
          row['fragment_key'],
          row['panel'],
          row['component'],
          row['original_text'],
        ],
      )
      .toList();
  return '$basename\u0000${jsonEncode(content)}';
}

String _q(String value) => value.replaceAll("'", "''");
