// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Extracteur legacy → JSON                      ║
// ║  Tâche      : CODE-046                                                  ║
// ║                                                                         ║
// ║  Usage : `dart run tools/cas_pratique/extract_legacy_cases.dart`        ║
// ║                                                                         ║
// ║  Parse les 6 fichiers `case_1_page.dart` … `case_6_page.dart`           ║
// ║  (recherche pattern Dart, scanner brace-matching robuste pour            ║
// ║  les littéraux + listes imbriquées) et émet en sortie un fichier        ║
// ║  JSON par cas dans `tools/cas_pratique/legacy_dump/case_<n>.json`.     ║
// ║                                                                         ║
// ║  Le format de sortie suit `docs/cas_pratique/fixtures/                  ║
// ║  example_case_complete.json`, avec des valeurs par défaut sensées :    ║
// ║   - theme : null (admin choisira lors du seed)                          ║
// ║   - difficulty : moyen                                                  ║
// ║   - total_points : 15 / estimated_minutes : 15                          ║
// ║   - weight : 1.0, is_required : true (1er point), false ensuite         ║
// ║   - kind : core                                                         ║
// ║   - max_points : 5, char_min : 80, char_recommended : 400               ║
// ║   - fuzzy_max_dist : 1                                                  ║
// ║                                                                         ║
// ║  Les champs non extractibles automatiquement (explication pédagogique, ║
// ║  groupes optionnels, références légales) sont marqués `_TODO_admin`.   ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:convert';
import 'dart:io';

// ─── Constantes ─────────────────────────────────────────────────────────────

const String _kLegacyDir =
    'lib/content/gpx_exam/cas_pratique/cas_pratique_excercice';
const String _kOutputDir = 'tools/cas_pratique/legacy_dump';
const int _kNumCases = 6;

void main(List<String> args) {
  print('═════════════════════════════════════════════════════════════');
  print('  COP\'IQ — Extracteur legacy cas pratique → JSON  (CODE-046)');
  print('═════════════════════════════════════════════════════════════\n');

  Directory(_kOutputDir).createSync(recursive: true);

  int ok = 0;
  int failed = 0;
  for (int i = 1; i <= _kNumCases; i++) {
    final inPath = '$_kLegacyDir/case_${i}_page.dart';
    final outPath = '$_kOutputDir/case_$i.json';
    try {
      print('▶ case_$i …');
      final source = File(inPath).readAsStringSync();
      final extracted = _extractCase(source, caseIndex: i);
      File(outPath).writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(extracted),
      );
      print('  ✅ écrit dans $outPath');
      ok++;
    } catch (e, st) {
      print('  ❌ échec : $e');
      print(st);
      failed++;
    }
  }
  print('\n────────────────────────────────────────────────────────────');
  print('  Bilan : $ok réussis · $failed échecs');
  print('────────────────────────────────────────────────────────────');
  if (failed > 0) exit(1);
}

// ═══════════════════════════════════════════════════════════════════════════
//  Extraction d'un cas complet
// ═══════════════════════════════════════════════════════════════════════════

Map<String, dynamic> _extractCase(String source, {required int caseIndex}) {
  // 1) Texte du cas (situation)
  final caseText = _extractStringConst(source, '_caseText') ??
      _extractStringConst(source, 'kCaseText') ??
      '';

  // 2) Questions : on récupère les blocs `_QuestionSlide(title: "Question N", question: "..."`
  final questions = _extractQuestionSlides(source);

  // 3) Perfect answers : on récupère les `const qXPerfect = "..."`
  final perfects = _extractPerfectAnswerStrings(source);

  // 4) Rubrics : on récupère les `final qXRubric = <_ExpectedPoint>[...]`
  final rubrics = _extractRubrics(source);

  // Pour chaque question : combine label + perfect + rubric
  final outQuestions = <Map<String, dynamic>>[];
  // On prend l'union des indices détectés (1-based)
  final indices = <int>{
    ...questions.keys,
    ...perfects.keys,
    ...rubrics.keys,
  }.toList()
    ..sort();

  for (final n in indices) {
    final qLabel = questions[n] ?? 'Question $n';
    final perfect = perfects[n] ?? '';
    final rubric = rubrics[n] ?? const <Map<String, dynamic>>[];

    outQuestions.add(<String, dynamic>{
      'position': n,
      'label': qLabel,
      'hint': null,
      'max_points': 5,
      'char_min': 80,
      'char_recommended': 400,
      'perfect_answer': <String, dynamic>{
        'body_md': perfect,
        'references_legal': <Map<String, dynamic>>[],
      },
      'rubric': rubric,
    });
  }

  return <String, dynamic>{
    '_comment':
        'Cas legacy case_$caseIndex extrait automatiquement. À enrichir manuellement par un admin : theme/difficulty/year/month, weights, is_required, kind, explanation_md, references_legal, synonyms_dict.',
    '_engine_compatible_with': '2.0.0',
    '_legacy_source': 'case_${caseIndex}_page.dart',
    'theme': null,
    'case': <String, dynamic>{
      'slug': 'case_$caseIndex',
      'title': 'Cas pratique n°$caseIndex',
      'year': 0,
      'month': null,
      'difficulty': 'moyen',
      'total_points': 15,
      'estimated_minutes': 15,
      'status': 'draft',
      'situation_md': caseText,
      'situation_text': caseText,
    },
    'questions': outQuestions,
    '_TODO_admin_review': <String>[
      'Définir le theme.slug (deontologie/cadre_legal/securite_publique/intervention/famille_mineur/routier/accueil)',
      'Définir year + month',
      'Ajuster la difficulty (facile/moyen/difficile) si nécessaire',
      'Affiner les weights des rubric_points (somme par question = max_points cible)',
      'Marquer is_required / kind (core vs bonus) pour chaque point',
      'Ajouter les explanation_md pédagogiques',
      'Ajouter les references_legal (article + code)',
      'Référencer un synonyms_dictionary slug si pertinent',
      'Passer status à "published" après revue',
    ],
  };
}

// ═══════════════════════════════════════════════════════════════════════════
//  Helpers — lecture de littéraux de chaîne Dart
// ═══════════════════════════════════════════════════════════════════════════

/// Lit un littéral String à partir de [start] (qui doit pointer sur un guillemet).
/// Gère :
///   - chaînes simples '...' ou doubles "..."
///   - les échappements (\", \', \\, \n, etc.)
///   - les chaînes raw  r'...' et r"..."
///   - la concaténation automatique d'adjacent string literals
///     (Dart : "abc" "def" "ghi" → "abcdefghi")
///
/// Retourne `(value, endIndex)` où endIndex pointe juste après le dernier char
/// du dernier littéral lu. Retourne null si pas de littéral à [start].
({String value, int end})? _readDartString(String src, int start) {
  int i = _skipWsAndComments(src, start);
  if (i >= src.length) return null;

  String buffer = '';
  bool first = true;

  while (i < src.length) {
    final pos = _skipWsAndComments(src, i);
    if (pos >= src.length) break;

    // Optional raw prefix
    bool raw = false;
    int qStart = pos;
    if (src[pos] == 'r' && pos + 1 < src.length &&
        (src[pos + 1] == '"' || src[pos + 1] == '\'')) {
      raw = true;
      qStart = pos + 1;
    }

    if (qStart >= src.length) break;
    final q = src[qStart];
    if (q != '"' && q != '\'') {
      if (first) return null;
      break; // plus de littéral adjacent à concaténer
    }

    // Gère les chaînes triples """ ou '''
    final triple = qStart + 2 < src.length &&
        src[qStart + 1] == q &&
        src[qStart + 2] == q;
    final closer = triple ? '$q$q$q' : q;
    int j = qStart + closer.length;

    final sb = StringBuffer();
    while (j < src.length) {
      if (src.startsWith(closer, j)) {
        j += closer.length;
        break;
      }
      if (!raw && src[j] == '\\' && j + 1 < src.length) {
        final c = src[j + 1];
        switch (c) {
          case 'n': sb.write('\n'); break;
          case 't': sb.write('\t'); break;
          case 'r': sb.write('\r'); break;
          case '\\': sb.write('\\'); break;
          case '\'': sb.write('\''); break;
          case '"': sb.write('"'); break;
          case '\$': sb.write('\$'); break;
          case 'b': sb.write('\b'); break;
          case 'f': sb.write('\f'); break;
          case '0': sb.write(' '); break;
          default:
            // Unicode \uXXXX (simple, sans curly)
            if (c == 'u' && j + 5 < src.length) {
              final code = src.substring(j + 2, j + 6);
              final cp = int.tryParse(code, radix: 16);
              if (cp != null) {
                sb.write(String.fromCharCode(cp));
                j += 6;
                continue;
              }
            }
            sb.write(c);
        }
        j += 2;
        continue;
      }
      sb.write(src[j]);
      j++;
    }
    buffer += sb.toString();
    i = j;
    first = false;
  }

  if (first) return null;
  return (value: buffer, end: i);
}

int _skipWsAndComments(String src, int i) {
  while (i < src.length) {
    final c = src[i];
    if (c == ' ' || c == '\t' || c == '\r' || c == '\n') {
      i++;
      continue;
    }
    // // single-line comment
    if (c == '/' && i + 1 < src.length && src[i + 1] == '/') {
      while (i < src.length && src[i] != '\n') {
        i++;
      }
      continue;
    }
    // /* block comment */
    if (c == '/' && i + 1 < src.length && src[i + 1] == '*') {
      i += 2;
      while (i + 1 < src.length && !(src[i] == '*' && src[i + 1] == '/')) {
        i++;
      }
      i = i + 2 < src.length ? i + 2 : src.length;
      continue;
    }
    break;
  }
  return i;
}

/// Trouve l'index correspondant au [closer] (`)` ou `]`) en partant de [start]
/// (qui doit pointer juste après le [opener] correspondant — `(` ou `[`).
/// Saute les chaînes Dart et les commentaires.
int _findMatchingClose(String src, int start,
    {required String opener, required String closer}) {
  int depth = 1;
  int i = start;
  while (i < src.length) {
    final c = src[i];
    // Skip Dart strings
    if (c == '"' || c == '\'') {
      final r = _readDartString(src, i);
      if (r != null) {
        i = r.end;
        continue;
      }
    }
    // Skip line comment
    if (c == '/' && i + 1 < src.length && src[i + 1] == '/') {
      while (i < src.length && src[i] != '\n') {
        i++;
      }
      continue;
    }
    // Skip block comment
    if (c == '/' && i + 1 < src.length && src[i + 1] == '*') {
      i += 2;
      while (i + 1 < src.length && !(src[i] == '*' && src[i + 1] == '/')) {
        i++;
      }
      i += 2;
      continue;
    }
    if (c == opener) {
      depth++;
      i++;
      continue;
    }
    if (c == closer) {
      depth--;
      if (depth == 0) return i;
      i++;
      continue;
    }
    i++;
  }
  return -1;
}

// ═══════════════════════════════════════════════════════════════════════════
//  Extracteurs spécifiques
// ═══════════════════════════════════════════════════════════════════════════

String? _extractStringConst(String src, String name) {
  // const NAME = "..." "..." "...";
  // const String NAME = ...
  // final NAME = ...
  final patterns = [
    RegExp(
      'const\\s+(?:String\\s+)?$name\\s*=\\s*',
      multiLine: true,
    ),
    RegExp(
      'final\\s+(?:String\\s+)?$name\\s*=\\s*',
      multiLine: true,
    ),
    RegExp(
      'static\\s+const\\s+(?:String\\s+)?$name\\s*=\\s*',
      multiLine: true,
    ),
  ];
  for (final re in patterns) {
    final m = re.firstMatch(src);
    if (m == null) continue;
    final r = _readDartString(src, m.end);
    if (r != null) return r.value;
  }
  return null;
}

/// Map<questionIndex (1-based), label>
Map<int, String> _extractQuestionSlides(String src) {
  final out = <int, String>{};
  final re = RegExp(
    '_QuestionSlide\\(\\s*title:\\s*("Question\\s+(\\d+)"|\'Question\\s+(\\d+)\'),\\s*question:\\s*',
  );
  for (final m in re.allMatches(src)) {
    final n = int.parse(m.group(2) ?? m.group(3) ?? '0');
    final r = _readDartString(src, m.end);
    if (r != null && n > 0) {
      out[n] = r.value;
    }
  }
  return out;
}

/// Map<questionIndex, perfectAnswerString>.
/// Cherche : `const q1Perfect = "..."` (et variantes).
Map<int, String> _extractPerfectAnswerStrings(String src) {
  final out = <int, String>{};
  // ex: const q1Perfect =, const String q12Perfect =, final q3Perfect =
  final re = RegExp(
    r'(?:const|final|static\s+const)\s+(?:String\s+)?q(\d+)Perfect\s*=\s*',
  );
  for (final m in re.allMatches(src)) {
    final n = int.parse(m.group(1) ?? '0');
    final r = _readDartString(src, m.end);
    if (r != null && n > 0) {
      out[n] = r.value;
    }
  }
  return out;
}

/// Map<questionIndex, listOfRubricPoints>.
/// Cherche : `final q1Rubric = <_ExpectedPoint>[ … ];`
Map<int, List<Map<String, dynamic>>> _extractRubrics(String src) {
  final out = <int, List<Map<String, dynamic>>>{};
  final re = RegExp(
    r'(?:final|var|const)\s+q(\d+)Rubric\s*=\s*(?:<\s*_ExpectedPoint\s*>\s*)?\[',
  );
  for (final m in re.allMatches(src)) {
    final n = int.parse(m.group(1) ?? '0');
    if (n <= 0) continue;
    final openIdx = m.end - 1; // pointe sur '['
    final closeIdx =
        _findMatchingClose(src, openIdx + 1, opener: '[', closer: ']');
    if (closeIdx < 0) continue;
    final body = src.substring(openIdx + 1, closeIdx);
    out[n] = _parseExpectedPoints(body);
  }
  return out;
}

List<Map<String, dynamic>> _parseExpectedPoints(String body) {
  final points = <Map<String, dynamic>>[];
  // Trouve chaque `_ExpectedPoint(` et lit jusqu'à sa matching `)`
  final re = RegExp(r'_ExpectedPoint\s*\(');
  int position = 1;
  for (final m in re.allMatches(body)) {
    final afterOpen = m.end; // juste après '('
    final close =
        _findMatchingClose(body, afterOpen, opener: '(', closer: ')');
    if (close < 0) continue;
    final inner = body.substring(afterOpen, close);

    // label: "..."
    String label = '';
    final lm = RegExp(r'label\s*:\s*').firstMatch(inner);
    if (lm != null) {
      final r = _readDartString(inner, lm.end);
      if (r != null) label = r.value;
    }

    // groups: [ [ "...", "..." ], [ "..." ], … ]
    final groups = <Map<String, dynamic>>[];
    final gm = RegExp(r'groups\s*:\s*\[').firstMatch(inner);
    if (gm != null) {
      final openIdx = gm.end - 1; // '['
      final closeIdx =
          _findMatchingClose(inner, openIdx + 1, opener: '[', closer: ']');
      if (closeIdx >= 0) {
        final groupsBody = inner.substring(openIdx + 1, closeIdx);
        groups.addAll(_parseKeywordGroups(groupsBody));
      }
    }

    points.add(<String, dynamic>{
      'position': position,
      'label': label,
      // Champs par défaut — à ajuster par l'admin avant publication
      'weight': position == 1 ? 1.5 : 1.0,
      'is_required': position == 1,
      'kind': 'core',
      'explanation_md': null,
      'groups': groups,
    });
    position++;
  }
  return points;
}

List<Map<String, dynamic>> _parseKeywordGroups(String body) {
  final groups = <Map<String, dynamic>>[];
  int i = 0;
  int position = 1;
  while (i < body.length) {
    i = _skipWsAndComments(body, i);
    if (i >= body.length) break;
    if (body[i] != '[') {
      // ignore les virgules et autres bruits
      i++;
      continue;
    }
    final open = i;
    final close =
        _findMatchingClose(body, open + 1, opener: '[', closer: ']');
    if (close < 0) break;
    final inner = body.substring(open + 1, close);
    final keywords = _parseKeywordList(inner);
    groups.add(<String, dynamic>{
      'position': position,
      'description': null,
      'is_optional': false,
      'keywords': keywords,
    });
    position++;
    i = close + 1;
  }
  return groups;
}

List<Map<String, dynamic>> _parseKeywordList(String body) {
  final out = <Map<String, dynamic>>[];
  int i = 0;
  while (i < body.length) {
    i = _skipWsAndComments(body, i);
    if (i >= body.length) break;
    if (body[i] == '"' || body[i] == '\'') {
      final r = _readDartString(body, i);
      if (r == null) break;
      final value = r.value.trim();
      if (value.isNotEmpty) {
        out.add(<String, dynamic>{
          'value': value,
          'is_phrase': value.contains(' '),
          'is_negation': false,
          'fuzzy_max_dist': 1,
        });
      }
      i = r.end;
      continue;
    }
    // raw string prefix
    if (body[i] == 'r' && i + 1 < body.length &&
        (body[i + 1] == '"' || body[i + 1] == '\'')) {
      final r = _readDartString(body, i);
      if (r == null) break;
      final value = r.value.trim();
      if (value.isNotEmpty) {
        out.add(<String, dynamic>{
          'value': value,
          'is_phrase': value.contains(' '),
          'is_negation': false,
          'fuzzy_max_dist': 1,
        });
      }
      i = r.end;
      continue;
    }
    i++;
  }
  return out;
}
