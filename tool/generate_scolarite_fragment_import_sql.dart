import 'dart:convert';
import 'dart:io';

const _input = 'progression/migration_data/text_fragments.jsonl';
const _outputDir = 'progression/migration_data/fragment_batches';
// Reste sous la limite de transport du connecteur SQL, y compris pour les
// pages contenant beaucoup de fragments et de métadonnées typographiques.
const _batchSize = 750;

void main() {
  final rows = File(_input)
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .map((line) => jsonDecode(line) as Map<String, dynamic>)
      .toList();
  final output = Directory(_outputDir)..createSync(recursive: true);

  var batch = 0;
  for (var start = 0; start < rows.length; start += _batchSize) {
    batch++;
    final end = (start + _batchSize).clamp(0, rows.length);
    final sql = StringBuffer()
      ..writeln('insert into public.scolarite_content_fragments')
      ..writeln(
        '  (source_path,fragment_key,panel,position,component,text_value,original_text,style_payload,is_editable)',
      )
      ..writeln('values');
    for (var index = start; index < end; index++) {
      final row = rows[index];
      sql.write(
        "('${_q(row['source_path'])}','${_q(row['fragment_key'])}',"
        "'${_q(row['panel'])}',${row['position']},'${_q(row['component'])}',"
        "'${_q(row['text_value'])}','${_q(row['original_text'])}',"
        "'${_q(jsonEncode(row['style_payload']))}'::jsonb,${row['is_editable'] == true})",
      );
      sql.writeln(index == end - 1 ? '' : ',');
    }
    sql.writeln('on conflict (source_path,fragment_key) do update set');
    sql.writeln(
      '  panel=excluded.panel, position=excluded.position, component=excluded.component,',
    );
    sql.writeln(
      '  original_text=excluded.original_text, style_payload=excluded.style_payload,',
    );
    sql.writeln('  is_editable=excluded.is_editable,');
    sql.writeln(
      '  text_value=case when scolarite_content_fragments.revision=1 then excluded.text_value else scolarite_content_fragments.text_value end;',
    );
    File(
      '${output.path}/fragment_${batch.toString().padLeft(3, '0')}.sql',
    ).writeAsStringSync(sql.toString());
  }
  stdout.writeln('${rows.length} fragments répartis dans $batch lots SQL.');
}

String _q(Object? value) => value.toString().replaceAll("'", "''");
