import 'dart:io';

const _roots = <String>[
  'lib/content/gpx_scolarite',
  'lib/content/pa_scolarite',
];

const _output = 'progression/AUDIT_DETAILLE_1409_FICHIERS_SCOLARITE.md';

void main() {
  final files = <File>[];
  for (final root in _roots) {
    files.addAll(
      Directory(root)
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart')),
    );
  }
  files.sort((a, b) => a.path.compareTo(b.path));

  final rows = files.map(_audit).toList(growable: false);
  final uniquePaths = rows.map((row) => row.path).toSet().length;
  final duplicateRoutes = <String, List<_AuditRow>>{};
  for (final row in rows.where((row) => row.route != null)) {
    duplicateRoutes.putIfAbsent(row.route!, () => []).add(row);
  }
  duplicateRoutes.removeWhere((_, values) => values.length < 2);

  final byKind = <String, int>{};
  final byRisk = <String, int>{};
  for (final row in rows) {
    byKind[row.kind] = (byKind[row.kind] ?? 0) + 1;
    byRisk[row.risk] = (byRisk[row.risk] ?? 0) + 1;
  }

  final now = DateTime.now().toLocal().toIso8601String();
  final out = StringBuffer()
    ..writeln('# Audit détaillé des 1 409 fichiers PA/GPX Scolarité')
    ..writeln()
    ..writeln('Généré le `$now` avec :')
    ..writeln()
    ..writeln('```bash')
    ..writeln('dart run tool/audit_scolarite_files.dart')
    ..writeln('```')
    ..writeln()
    ..writeln('## Garantie de complétude')
    ..writeln()
    ..writeln('- Fichiers attendus : **1 409**')
    ..writeln('- Fichiers lus intégralement : **${rows.length}**')
    ..writeln('- Chemins uniques : **$uniquePaths**')
    ..writeln('- GPX : **${rows.where((row) => row.track == 'GPX').length}**')
    ..writeln('- PA : **${rows.where((row) => row.track == 'PA').length}**')
    ..writeln(
      '- Total de lignes analysées : **${_number(rows.fold<int>(0, (sum, row) => sum + row.lines))}**',
    )
    ..writeln(
      '- Total d’octets analysés : **${_number(rows.fold<int>(0, (sum, row) => sum + row.bytes))}**',
    )
    ..writeln(
      '- Verdict : **${rows.length == 1409 && uniquePaths == 1409 ? 'CONFORME — 1 409/1 409' : 'ÉCART À CORRIGER'}**',
    )
    ..writeln()
    ..writeln('## Portée de cet audit')
    ..writeln()
    ..writeln(
      'Chaque fichier a été ouvert et analysé intégralement. Le registre décrit sa hiérarchie, son rôle, sa route, sa classe principale, ses volumes de texte, ses composants visuels, ses médias, sa navigation, ses dépendances Supabase et son niveau de difficulté de migration.',
    )
    ..writeln()
    ..writeln(
      'Le statut `Audité` valide la lecture et la classification structurelle. Il ne signifie pas encore `Extrait`, `Importé` ou `Vérifié visuellement`.',
    )
    ..writeln()
    ..writeln('## Répartition par type')
    ..writeln()
    ..writeln('| Type | Fichiers |')
    ..writeln('|---|---:|');

  for (final entry
      in byKind.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
    out.writeln('| ${_cell(entry.key)} | ${entry.value} |');
  }

  out
    ..writeln()
    ..writeln('## Complexité de migration détectée')
    ..writeln()
    ..writeln('| Niveau | Fichiers | Interprétation |')
    ..writeln('|---|---:|---|');
  for (final level in const ['Faible', 'Moyenne', 'Élevée', 'Critique']) {
    out.writeln('| $level | ${byRisk[level] ?? 0} | ${_riskMeaning(level)} |');
  }

  out
    ..writeln()
    ..writeln('## Légende compacte')
    ..writeln()
    ..writeln('- `T` : widgets `Text` ou `SelectableText`.')
    ..writeln('- `RT` : `RichText`.')
    ..writeln('- `TS` : `TextSpan`.')
    ..writeln('- `L` : listes (`ListView`).')
    ..writeln('- `C` : cartes (`Card`).')
    ..writeln('- `TB` : tableaux (`Table` ou `DataTable`).')
    ..writeln('- `IMG` : images locales ou réseau.')
    ..writeln('- `NAV` : appels de navigation détectés.')
    ..writeln('- `Q` : déclarations ou collections de questions détectées.')
    ..writeln('- `SB` : accès Supabase détecté dans le fichier.')
    ..writeln()
    ..writeln('## Registre audité fichier par fichier')
    ..writeln()
    ..writeln(
      '| # | Filière | Domaine | Cours / hiérarchie | Type | Fichier | Route | Classe | Titre | Lignes | Signaux de contenu | Médias / spécial | Dépendances | Risque | Audit | Extraction | Import Supabase | Vérification |',
    )
    ..writeln(
      '|---:|---|---|---|---|---|---|---|---|---:|---|---|---|---|---|---|---|---|',
    );

  for (var index = 0; index < rows.length; index++) {
    final row = rows[index];
    out.writeln(
      '| ${index + 1} | ${row.track} | ${_cell(row.domain)} | ${_cell(row.hierarchy)} | '
      '${_cell(row.kind)} | `${_cell(row.path)}` | ${_code(row.route)} | '
      '${_code(row.pageClass)} | ${_cell(row.title)} | ${row.lines} | '
      '${_cell(row.contentSignals)} | ${_cell(row.specialSignals)} | '
      '${_cell(row.dependencies)} | ${row.risk} | **Audité** | À faire | À faire | À faire |',
    );
  }

  out
    ..writeln()
    ..writeln('## Routes dupliquées à contrôler')
    ..writeln();
  if (duplicateRoutes.isEmpty) {
    out.writeln('Aucune constante `routeName` dupliquée détectée.');
  } else {
    out
      ..writeln('| Route | Nombre | Fichiers |')
      ..writeln('|---|---:|---|');
    final entries = duplicateRoutes.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    for (final entry in entries) {
      out.writeln(
        '| `${_cell(entry.key)}` | ${entry.value.length} | ${entry.value.map((row) => '`${_cell(row.path)}`').join('<br>')} |',
      );
    }
  }

  out
    ..writeln()
    ..writeln('## Files d’action')
    ..writeln()
    ..writeln('### Fichiers sans route déclarée')
    ..writeln()
    ..writeln(
      '${rows.where((row) => row.route == null).length} fichiers n’exposent pas de constante `routeName`. Cela peut être normal pour des composants ou des pages ouvertes avec `MaterialPageRoute`.',
    )
    ..writeln()
    ..writeln('### Fichiers avec médias')
    ..writeln()
    ..writeln(
      '${rows.where((row) => row.hasMedia).length} fichiers référencent au moins une image, une vidéo, un audio, un PDF ou un SVG.',
    )
    ..writeln()
    ..writeln('### Fichiers de quiz')
    ..writeln()
    ..writeln(
      '${rows.where((row) => row.kind == 'Quiz/QCM').length} fichiers sont classés comme quiz ou QCM.',
    )
    ..writeln()
    ..writeln('### Accès Supabase embarqués')
    ..writeln()
    ..writeln(
      '${rows.where((row) => row.usesSupabase).length} fichiers accèdent directement ou indirectement au client Supabase et nécessitent une revue lors de la centralisation.',
    )
    ..writeln()
    ..writeln('## Règle de suivi')
    ..writeln()
    ..writeln('1. Ne jamais supprimer une ligne de ce registre.')
    ..writeln('2. `Extraction` passe à terminé après conversion sans perte.')
    ..writeln(
      '3. `Import Supabase` exige un identifiant ou une preuve de requête.',
    )
    ..writeln(
      '4. `Vérification` exige une comparaison avec la page Flutter originale.',
    )
    ..writeln(
      '5. Toute variation du total 1 409 doit être expliquée avant de poursuivre.',
    );

  File(_output).writeAsStringSync(out.toString());
  stdout.writeln('Audit généré : ${rows.length} fichiers lus intégralement.');
  stdout.writeln('Sortie : $_output');
  if (rows.length != 1409 || uniquePaths != 1409) exitCode = 2;
}

_AuditRow _audit(File file) {
  final source = file.readAsStringSync();
  final path = file.path.replaceAll('\\', '/');
  final parts = path.split('/').skip(3).toList();
  final track = path.contains('/gpx_scolarite/') ? 'GPX' : 'PA';
  final domain = parts.isEmpty ? 'racine' : _humanize(parts.first);
  final hierarchyParts = parts.length > 1
      ? parts.sublist(0, parts.length - 1).map(_humanize).toList()
      : <String>[];
  final hierarchy = hierarchyParts.isEmpty
      ? _humanize(file.uri.pathSegments.last)
      : hierarchyParts.join(' › ');
  final route = RegExp(
    r'''static\s+const\s+String\s+routeName\s*=\s*['"]([^'"]+)['"]''',
  ).firstMatch(source)?.group(1);
  final pageClass = RegExp(
    r'class\s+([A-Za-z0-9_]+)\s+extends\s+(?:StatefulWidget|StatelessWidget|ConsumerWidget|State<)',
  ).firstMatch(source)?.group(1);

  final text = _count(source, r'\b(?:Selectable)?Text\s*\(');
  final richText = _count(source, r'\bRichText\s*\(');
  final textSpan = _count(source, r'\bTextSpan\s*\(');
  final lists = _count(source, r'\bListView(?:\.[A-Za-z]+)?\s*\(');
  final cards = _count(source, r'\bCard\s*\(');
  final tables = _count(source, r'\b(?:Table|DataTable)\s*\(');
  final images = _count(
    source,
    r'\b(?:Image\.(?:asset|network|memory|file)|AssetImage|NetworkImage|SvgPicture\.)\s*\(',
  );
  final navigation = _count(
    source,
    r'\b(?:Navigator\.|context\.(?:go|push|replace)|GoRouter\.)',
  );
  final questions = _count(
    source,
    r'\b(?:Question|QuizQuestion|QcmQuestion)\s*\(|\bquestions\s*=|\b_questionBank\b',
  );
  final usesSupabase = RegExp(
    r'\bSupabase\b|supabase_flutter|\.from\s*\(|\.rpc\s*\(',
    caseSensitive: false,
  ).hasMatch(source);
  final hasTimer = RegExp(
    r'\bTimer\b|countdown|timeRemaining',
  ).hasMatch(source);
  final hasMarkdown = RegExp(r'Markdown(?:Body)?\s*\(').hasMatch(source);
  final hasCustomPaint = RegExp(
    r'CustomPaint(?:er)?\b|Canvas\b',
  ).hasMatch(source);
  final hasAnimation = RegExp(
    r'AnimationController|AnimatedBuilder|TweenAnimationBuilder|Lottie',
  ).hasMatch(source);
  final hasMedia =
      images > 0 ||
      RegExp(
        r'video_player|audioplayers|just_audio|\.pdf\b|\.svg\b',
      ).hasMatch(source);
  final imports = RegExp(
    r'''import\s+['"]([^'"]+)['"]''',
  ).allMatches(source).map((match) => match.group(1)!).toList();
  final localImports = imports.where(
    (value) =>
        value.startsWith('package:copiqpolice/') || value.startsWith('.'),
  );

  final signals = <String>[
    'T:$text',
    if (richText > 0) 'RT:$richText',
    if (textSpan > 0) 'TS:$textSpan',
    if (lists > 0) 'L:$lists',
    if (cards > 0) 'C:$cards',
    if (tables > 0) 'TB:$tables',
    if (images > 0) 'IMG:$images',
    if (navigation > 0) 'NAV:$navigation',
    if (questions > 0) 'Q:$questions',
    if (usesSupabase) 'SB',
  ];
  final special = <String>[
    if (hasTimer) 'chronomètre',
    if (hasMarkdown) 'Markdown',
    if (hasCustomPaint) 'dessin/canvas',
    if (hasAnimation) 'animation',
    if (RegExp(r'video_player').hasMatch(source)) 'vidéo',
    if (RegExp(r'audioplayers|just_audio').hasMatch(source)) 'audio',
    if (RegExp(r'\.pdf\b').hasMatch(source)) 'PDF',
    if (RegExp(r'\.svg\b|SvgPicture').hasMatch(source)) 'SVG',
  ];
  final kind = _detectKind(path, source, questions);
  final score =
      (questions > 0 ? 4 : 0) +
      (hasTimer ? 2 : 0) +
      (hasCustomPaint ? 2 : 0) +
      (hasAnimation ? 1 : 0) +
      (hasMedia ? 1 : 0) +
      (usesSupabase ? 2 : 0) +
      (source.length > 100000
          ? 2
          : source.length > 40000
          ? 1
          : 0);
  final risk = score >= 8
      ? 'Critique'
      : score >= 5
      ? 'Élevée'
      : score >= 2
      ? 'Moyenne'
      : 'Faible';

  return _AuditRow(
    path: path,
    track: track,
    domain: domain,
    hierarchy: hierarchy,
    kind: kind,
    route: route,
    pageClass: pageClass,
    title: _detectTitle(source, file),
    lines: source.isEmpty
        ? 0
        : '\n'.allMatches(source).length + (source.endsWith('\n') ? 0 : 1),
    bytes: file.lengthSync(),
    contentSignals: signals.join(' · '),
    specialSignals: special.isEmpty ? '—' : special.join(', '),
    dependencies: 'imports:${imports.length} · locaux:${localImports.length}',
    risk: risk,
    hasMedia: hasMedia,
    usesSupabase: usesSupabase,
  );
}

String _detectKind(String path, String source, int questions) {
  final lower = path.toLowerCase();
  if (lower.contains('quiz') || lower.contains('quizz') || questions > 0) {
    return 'Quiz/QCM';
  }
  if (lower.contains('intro')) return 'Introduction';
  if (lower.contains('contenu') || lower.contains('content')) {
    return 'Cours/contenu';
  }
  if (RegExp(
    r'class\s+[A-Za-z0-9_]+\s+extends\s+(?:StatefulWidget|StatelessWidget|ConsumerWidget)',
  ).hasMatch(source)) {
    if (source.contains('Navigator.') && source.contains('ListView')) {
      return 'Navigation/sommaire';
    }
    return 'Page/composant';
  }
  if (RegExp(
    r'class\s+[A-Za-z0-9_]+(?:Painter|Controller|Service|Model)',
  ).hasMatch(source)) {
    return 'Support technique';
  }
  return 'Ressource/données';
}

String _detectTitle(String source, File file) {
  final candidates = <RegExp>[
    RegExp(
      r'''title\s*:\s*(?:const\s+)?Text\(\s*['"]([^'"\n]{2,140})['"]''',
      multiLine: true,
    ),
    RegExp(
      r'''(?:const\s+)?Text\(\s*['"]([^'"\n]{3,140})['"]''',
      multiLine: true,
    ),
  ];
  for (final pattern in candidates) {
    final value = pattern.firstMatch(source)?.group(1);
    if (value != null && value.trim().isNotEmpty) {
      return value.replaceAll(r'\n', ' ').trim();
    }
  }
  return _humanize(file.uri.pathSegments.last);
}

int _count(String source, String pattern) =>
    RegExp(pattern, multiLine: true).allMatches(source).length;

String _humanize(String value) =>
    value.replaceAll('.dart', '').replaceAll(RegExp(r'[_-]+'), ' ').trim();

String _cell(String? value) =>
    (value == null || value.trim().isEmpty ? '—' : value)
        .replaceAll('|', r'\|')
        .replaceAll('\n', ' ');

String _code(String? value) =>
    value == null || value.isEmpty ? '—' : '`${_cell(value)}`';

String _number(int value) {
  final digits = value.toString();
  final out = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) out.write(' ');
    out.write(digits[index]);
  }
  return out.toString();
}

String _riskMeaning(String level) => switch (level) {
  'Faible' => 'contenu standard, conversion généralement directe',
  'Moyenne' => 'médias, navigation ou composants particuliers',
  'Élevée' => 'quiz, dessin, chronomètre ou accès distant',
  'Critique' => 'plusieurs moteurs ou dépendances sensibles combinés',
  _ => '—',
};

class _AuditRow {
  const _AuditRow({
    required this.path,
    required this.track,
    required this.domain,
    required this.hierarchy,
    required this.kind,
    required this.route,
    required this.pageClass,
    required this.title,
    required this.lines,
    required this.bytes,
    required this.contentSignals,
    required this.specialSignals,
    required this.dependencies,
    required this.risk,
    required this.hasMedia,
    required this.usesSupabase,
  });

  final String path;
  final String track;
  final String domain;
  final String hierarchy;
  final String kind;
  final String? route;
  final String? pageClass;
  final String title;
  final int lines;
  final int bytes;
  final String contentSignals;
  final String specialSignals;
  final String dependencies;
  final String risk;
  final bool hasMedia;
  final bool usesSupabase;
}
