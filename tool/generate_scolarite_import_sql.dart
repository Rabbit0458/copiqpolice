import 'dart:convert';
import 'dart:io';

const input = 'progression/migration_data';
const output = 'progression/migration_data/sql';

void main() {
  final out = Directory(output);
  if (out.existsSync()) out.deleteSync(recursive: true);
  out.createSync(recursive: true);

  final courses = _read('$input/courses.jsonl');
  final questions = _read('$input/quiz_questions.jsonl');
  final sources = _read('$input/sources.jsonl');

  var count = 0;
  count += _writeBatches('01_courses', courses, 350000, _courseSql);
  count += _writeBatches('02_questions', questions, 350000, _questionSql);
  count += _writeBatches('03_sources', sources, 350000, _sourceSql);
  File('$output/MANIFEST.json').writeAsStringSync(
    const JsonEncoder.withIndent(' ').convert({
      'batches': count,
      'courses': courses.length,
      'quiz_questions': questions.length,
      'sources': sources.length,
    }),
  );
  stdout.writeln('$count lots SQL générés.');
}

List<Map<String, dynamic>> _read(String path) => File(path)
    .readAsLinesSync()
    .where((line) => line.trim().isNotEmpty)
    .map((line) => Map<String, dynamic>.from(jsonDecode(line) as Map))
    .toList();

int _writeBatches(
  String prefix,
  List<Map<String, dynamic>> rows,
  int maxBytes,
  String Function(List<Map<String, dynamic>>) sql,
) {
  var batch = <Map<String, dynamic>>[];
  var bytes = 0;
  var index = 0;
  void flush() {
    if (batch.isEmpty) return;
    index++;
    File(
      '$output/${prefix}_${index.toString().padLeft(4, '0')}.sql',
    ).writeAsStringSync(sql(batch));
    batch = [];
    bytes = 0;
  }

  for (final row in rows) {
    final size = utf8.encode(jsonEncode(row)).length;
    if (batch.isNotEmpty && bytes + size > maxBytes) flush();
    batch.add(row);
    bytes += size;
  }
  flush();
  return index;
}

String _payload(List<Map<String, dynamic>> rows) =>
    base64.encode(utf8.encode(jsonEncode(rows)));

String _courseSql(List<Map<String, dynamic>> rows) =>
    '''
with data as (
  select * from jsonb_to_recordset(convert_from(decode('${_payload(rows)}','base64'),'utf8')::jsonb) as x(
    route text, track text, module text, section text, code text, title text, subtitle text,
    body_md text, content_blocks jsonb, key_points jsonb, legal_refs jsonb, quiz_module text,
    color_hex text, sort_order integer, publication_status text, source_path text, source_hash text,
    source_kind text, metadata jsonb
  )
)
insert into public.cours_scolarite
  (route,track,module,section,code,title,subtitle,body_md,content_blocks,key_points,legal_refs,
   quiz_module,color_hex,sort_order,is_published,publication_status,published_at,source_path,
   source_hash,source_kind,metadata)
select route,track,module,section,code,title,subtitle,body_md,content_blocks,key_points,legal_refs,
 quiz_module,color_hex,sort_order,true,'published',now(),source_path,source_hash,source_kind,metadata
from data
on conflict (route) do update set
 track=excluded.track,module=excluded.module,section=excluded.section,code=excluded.code,title=excluded.title,
 subtitle=excluded.subtitle,body_md=excluded.body_md,content_blocks=excluded.content_blocks,
 key_points=excluded.key_points,legal_refs=excluded.legal_refs,quiz_module=excluded.quiz_module,
 color_hex=excluded.color_hex,sort_order=excluded.sort_order,is_published=true,publication_status='published',
 source_path=excluded.source_path,source_hash=excluded.source_hash,source_kind=excluded.source_kind,
 metadata=public.cours_scolarite.metadata || excluded.metadata;
''';

String _questionSql(List<Map<String, dynamic>> rows) =>
    '''
with data as (
 select * from jsonb_to_recordset(convert_from(decode('${_payload(rows)}','base64'),'utf8')::jsonb) as x(
  module text,track text,category text,difficulty text,question text,options jsonb,answer text,
  explanation text,legal_ref text,position integer,source_path text,source_hash text,
  source_question_key text,publication_status text,metadata jsonb
 )
)
insert into public.quiz_scolarite_questions
 (module,track,category,difficulty,question,options,answer,explanation,legal_ref,position,is_active,
  publication_status,published_at,source_path,source_hash,source_question_key,metadata)
select module,track,category,difficulty,question,options,answer,explanation,legal_ref,position,true,
 'published',now(),source_path,source_hash,source_question_key,metadata from data
on conflict do nothing;
''';

String _sourceSql(List<Map<String, dynamic>> rows) =>
    '''
with data as (
 select * from jsonb_to_recordset(convert_from(decode('${_payload(rows)}','base64'),'utf8')::jsonb) as x(
  source_path text,track text,content_type text,module text,section text,source_hash text,
  source_bytes bigint,source_lines integer,course_route text,quiz_question_count integer,
  migration_status text,extracted_payload jsonb
 )
)
insert into public.scolarite_source_registry
 (source_path,track,content_type,module,section,source_hash,source_bytes,source_lines,course_route,
  quiz_question_count,migration_status,extracted_payload,extracted_at,imported_at,updated_at)
select source_path,track,content_type,module,section,source_hash,source_bytes,source_lines,course_route,
 quiz_question_count,'imported',extracted_payload,now(),now(),now() from data
on conflict (source_path) do update set
 track=excluded.track,content_type=excluded.content_type,module=excluded.module,section=excluded.section,
 source_hash=excluded.source_hash,source_bytes=excluded.source_bytes,source_lines=excluded.source_lines,
 course_route=excluded.course_route,quiz_question_count=excluded.quiz_question_count,
 migration_status='imported',extracted_payload=excluded.extracted_payload,extracted_at=now(),
 imported_at=now(),updated_at=now(),migration_error=null;
''';
