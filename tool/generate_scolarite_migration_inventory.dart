import 'dart:io';

const _roots = <String>[
  'lib/content/gpx_scolarite',
  'lib/content/pa_scolarite',
];

void main() {
  const inventoryPath =
      'progression/AUDIT_MIGRATION_1409_FICHIERS_SCOLARITE.md';
  final previousTracking = _readPreviousTracking(File(inventoryPath));
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

  final rows = files.map(_inspect).toList(growable: false);
  final now = DateTime.now().toLocal().toIso8601String();
  final inventory = StringBuffer()
    ..writeln('# Registre exhaustif de migration — PA et GPX Scolarité')
    ..writeln()
    ..writeln('> Généré automatiquement le `$now` par ')
    ..writeln('> `dart run tool/generate_scolarite_migration_inventory.dart`.')
    ..writeln(
      '> Ne jamais retirer manuellement une ligne : le registre doit rester aligné avec le projet.',
    )
    ..writeln()
    ..writeln('## Contrôle de périmètre')
    ..writeln()
    ..writeln('- Fichiers Dart attendus : **1 409**')
    ..writeln('- Fichiers Dart recensés : **${rows.length}**')
    ..writeln(
      '- GPX Scolarité : **${rows.where((r) => r.track == 'GPX').length}**',
    )
    ..writeln(
      '- PA Scolarité : **${rows.where((r) => r.track == 'PA').length}**',
    )
    ..writeln(
      '- Contrôle : **${rows.length == 1409 ? 'CONFORME' : 'ÉCART À TRAITER'}**',
    )
    ..writeln()
    ..writeln('## Signification des statuts')
    ..writeln()
    ..writeln(
      '- `À auditer` : fichier recensé, analyse éditoriale détaillée non validée.',
    )
    ..writeln('- `Extrait` : contenu converti dans le format d’import.')
    ..writeln('- `Importé` : contenu écrit dans Supabase.')
    ..writeln(
      '- `Vérifié` : contenu relu et comparé au rendu Flutter original.',
    )
    ..writeln(
      '- `Non éditorial` : navigation, composant ou moteur sans contenu à migrer.',
    )
    ..writeln()
    ..writeln('## Registre des fichiers')
    ..writeln()
    ..writeln(
      '| # | Filière | Domaine | Cours parent | Type détecté | Fichier | Route | Classe/page | Titre détecté | Lignes | Statut | Preuve Supabase |',
    )
    ..writeln('|---:|---|---|---|---|---|---|---|---|---:|---|---|');

  for (var index = 0; index < rows.length; index++) {
    final row = rows[index];
    final tracking = previousTracking[row.path];
    inventory.writeln(
      '| ${index + 1} | ${_cell(row.track)} | ${_cell(row.domain)} | '
      '${_cell(row.course)} | ${_cell(row.kind)} | `${_cell(row.path)}` | '
      '${_codeOrDash(row.route)} | ${_codeOrDash(row.pageClass)} | '
      '${_cell(row.title)} | ${row.lines} | '
      '${_cell(tracking?.status ?? 'À auditer')} | '
      '${_cell(tracking?.proof ?? '—')} |',
    );
  }

  final progress = StringBuffer()
    ..writeln('# Progression — Migration complète des contenus PA/GPX')
    ..writeln()
    ..writeln('Dernière mise à jour automatique : `$now`')
    ..writeln()
    ..writeln('## Objectif')
    ..writeln()
    ..writeln(
      'Rendre administrables depuis `copiq.fr/admin` tous les cours de PA Scolarité et GPX Scolarité, ainsi que leurs quiz et les quiz PA/GPX Exam, sans modifier l’identité visuelle existante et sans supprimer de table Supabase.',
    )
    ..writeln()
    ..writeln('## Périmètre mesuré')
    ..writeln()
    ..writeln(
      '- **${rows.length} fichiers Dart** suivis dans le registre exhaustif.',
    )
    ..writeln(
      '- **${rows.where((r) => r.track == 'GPX').length} fichiers GPX Scolarité**.',
    )
    ..writeln(
      '- **${rows.where((r) => r.track == 'PA').length} fichiers PA Scolarité**.',
    )
    ..writeln(
      '- Registre détaillé : [AUDIT_MIGRATION_1409_FICHIERS_SCOLARITE.md](./AUDIT_MIGRATION_1409_FICHIERS_SCOLARITE.md)',
    )
    ..writeln()
    ..writeln('## Sauvegarde de référence')
    ..writeln()
    ..writeln(
      '- Archive : `/private/tmp/copiqpolice-before-content-migration-20260814-161850.tar.gz`',
    )
    ..writeln('- Taille : **2,8 Go**')
    ..writeln(
      '- SHA-256 : `cdae106a848bb0f894c76fcdb0981c9a2f0244a89c63b1787896fa1ce9d19e15`',
    )
    ..writeln()
    ..writeln('## Décisions validées')
    ..writeln()
    ..writeln(
      '- [x] Lire tous les fichiers Dart de `gpx_scolarite` et `pa_scolarite`.',
    )
    ..writeln(
      '- [x] Migrer l’intégralité du contenu éditorial, pas uniquement les paragraphes simples.',
    )
    ..writeln(
      '- [x] Conserver les designs, routes et moteurs Flutter existants.',
    )
    ..writeln(
      '- [x] Permettre la création de nouveaux cours sans republication sur les stores.',
    )
    ..writeln('- [x] Conserver le design actuel du panneau administrateur.')
    ..writeln(
      '- [x] Fournir un éditeur visuel par blocs et un mode Markdown avancé synchronisé.',
    )
    ..writeln(
      '- [x] Gérer images, PDF, vidéos, audio et schémas via Supabase Storage.',
    )
    ..writeln(
      '- [x] Appliquer les migrations Supabase après sauvegarde et contrôle RLS.',
    )
    ..writeln('- [x] Ne supprimer aucune table Supabase existante.')
    ..writeln()
    ..writeln('## État actuel')
    ..writeln()
    ..writeln('| Lot | État | Détail |')
    ..writeln('|---|---|---|')
    ..writeln(
      '| Sauvegarde initiale | Terminé | Archive complète et SHA-256 vérifiés |',
    )
    ..writeln(
      '| Inventaire filesystem | Terminé | ${rows.length} fichiers Dart recensés |',
    )
    ..writeln(
      '| Fondation Supabase existante | Audit initial terminé | `cours_scolarite`, quiz dynamiques et cycle éditorial repérés |',
    )
    ..writeln(
      '| Panneau existant | Audit initial terminé | Liste, Markdown, aperçu, publication et RPC sécurisées repérés |',
    )
    ..writeln(
      '| Classification éditoriale fichier par fichier | À faire | Valider cours, navigation, composant, quiz et média |',
    )
    ..writeln(
      '| Extraction complète | À faire | Convertir chaque page en blocs structurés sans perte |',
    )
    ..writeln(
      '| Import Supabase | À faire | Import idempotent avec preuve par fichier |',
    )
    ..writeln(
      '| Moteur Flutter universel | À faire | Chargement distant, cache et secours local |',
    )
    ..writeln(
      '| Création de cours dans le panneau | À faire | Filière, hiérarchie, route, blocs, médias et publication |',
    )
    ..writeln(
      '| Éditeur visuel par blocs | À faire | Deux modes synchronisés avec le Markdown |',
    )
    ..writeln(
      '| Supabase Storage | À faire | Upload, remplacement, aperçu et politiques |',
    )
    ..writeln(
      '| Quiz School et Exam | À faire | Import et administration de toutes les familles |',
    )
    ..writeln(
      '| Validation finale | À faire | Comparaison visuelle, tests, RLS, build statique |',
    )
    ..writeln()
    ..writeln('## Plan de développement')
    ..writeln()
    ..writeln('### Phase 1 — Audit exhaustif')
    ..writeln()
    ..writeln('- [x] Générer le registre des fichiers.')
    ..writeln('- [ ] Lire et classifier chaque fichier.')
    ..writeln(
      '- [ ] Associer chaque page à sa route dans `main.dart` et `app_router.dart`.',
    )
    ..writeln(
      '- [ ] Identifier les pages orphelines, doublons et redirections.',
    )
    ..writeln('- [ ] Recenser tous les assets et composants spéciaux.')
    ..writeln(
      '- [ ] Marquer les fichiers sans contenu éditorial comme `Non éditorial`.',
    )
    ..writeln()
    ..writeln('### Phase 2 — Modèle Supabase')
    ..writeln()
    ..writeln(
      '- [ ] Auditer intégralement `cours_scolarite` et les tables quiz existantes.',
    )
    ..writeln('- [ ] Ajouter uniquement les colonnes/tables manquantes.')
    ..writeln(
      '- [ ] Modéliser hiérarchie, blocs, versions, médias et liens quiz.',
    )
    ..writeln(
      '- [ ] Créer les RPC administratives avec garde d’autorisation et audit.',
    )
    ..writeln(
      '- [ ] Créer les politiques RLS de lecture publiée et d’administration.',
    )
    ..writeln(
      '- [ ] Tester les accès `anon`, `authenticated`, admin AAL2 et refus non-admin.',
    )
    ..writeln()
    ..writeln('### Phase 3 — Extraction et import')
    ..writeln()
    ..writeln(
      '- [ ] Extraire titres, textes, RichText, listes, cartes, tableaux et références.',
    )
    ..writeln('- [ ] Conserver l’ordre exact des blocs.')
    ..writeln(
      '- [ ] Associer routes, classes, catégories, modules et cours parents.',
    )
    ..writeln('- [ ] Importer de façon idempotente dans Supabase.')
    ..writeln(
      '- [ ] Enregistrer dans le registre l’identifiant et la preuve Supabase.',
    )
    ..writeln('- [ ] Comparer chaque contenu importé au fichier Dart source.')
    ..writeln()
    ..writeln('### Phase 4 — Application Flutter')
    ..writeln()
    ..writeln('- [ ] Créer le dépôt de contenu distant et son cache.')
    ..writeln(
      '- [ ] Créer le rendu des blocs correspondant aux designs existants.',
    )
    ..writeln('- [ ] Préserver toutes les routes actuelles.')
    ..writeln(
      '- [ ] Ajouter la découverte des nouveaux cours créés depuis le panneau.',
    )
    ..writeln('- [ ] Ajouter un contenu local de secours hors ligne.')
    ..writeln(
      '- [ ] Vérifier navigation, progression, journal et liens vers les quiz.',
    )
    ..writeln()
    ..writeln('### Phase 5 — Panneau administrateur')
    ..writeln()
    ..writeln('- [ ] Ajouter « Nouveau cours ».')
    ..writeln('- [ ] Ajouter l’éditeur visuel par blocs existants.')
    ..writeln('- [ ] Synchroniser éditeur visuel et Markdown.')
    ..writeln('- [ ] Ajouter glisser-déposer et réorganisation des blocs.')
    ..writeln('- [ ] Ajouter upload et bibliothèque Supabase Storage.')
    ..writeln(
      '- [ ] Ajouter brouillon, aperçu, programmation, publication, archivage et versions.',
    )
    ..writeln('- [ ] Étendre le panneau à tous les quiz PA/GPX School et Exam.')
    ..writeln()
    ..writeln('### Phase 6 — Vérification et livraison')
    ..writeln()
    ..writeln('- [ ] Tests unitaires et intégration Supabase.')
    ..writeln('- [ ] Analyse Flutter complète.')
    ..writeln('- [ ] Build Flutter concerné et build statique du panneau.')
    ..writeln(
      '- [ ] Comparaison visuelle d’un échantillon puis de chaque famille de pages.',
    )
    ..writeln(
      '- [ ] Contrôle de complétude : 1 409/1 409 fichiers avec statut final.',
    )
    ..writeln('- [ ] Générer `fae16dc1/admin` prêt à déposer.')
    ..writeln('- [ ] Créer la sauvegarde finale et son SHA-256.')
    ..writeln()
    ..writeln('## Journal de développement')
    ..writeln()
    ..writeln('### $now')
    ..writeln()
    ..writeln('- Périmètre fonctionnel confirmé avec le propriétaire.')
    ..writeln('- Sauvegarde complète créée et vérifiée.')
    ..writeln('- 1 409 fichiers Dart recensés dans PA/GPX Scolarité.')
    ..writeln(
      '- Architecture existante du panneau, du moteur dynamique et du cycle éditorial identifiée.',
    )
    ..writeln('- Registre exhaustif et document de progression générés.')
    ..writeln()
    ..writeln('## Règles de mise à jour du suivi')
    ..writeln()
    ..writeln(
      '1. Mettre à jour le statut de chaque ligne du registre après chaque étape.',
    )
    ..writeln('2. Ne marquer `Importé` qu’après retour positif de Supabase.')
    ..writeln(
      '3. Ne marquer `Vérifié` qu’après comparaison avec le fichier source et contrôle du rendu.',
    )
    ..writeln('4. Ajouter chaque changement important au journal ci-dessus.')
    ..writeln(
      '5. Régénérer le registre après ajout, déplacement ou suppression autorisée d’un fichier Dart.',
    );

  final progressionDir = Directory('progression')..createSync(recursive: true);
  File(inventoryPath).writeAsStringSync(inventory.toString());
  File(
    '${progressionDir.path}/PROGRESSION_MIGRATION_CONTENUS_PA_GPX.md',
  ).writeAsStringSync(progress.toString());

  stdout.writeln('Inventaire généré : ${rows.length} fichiers.');
  if (rows.length != 1409) exitCode = 2;
}

Map<String, ({String status, String proof})> _readPreviousTracking(File file) {
  if (!file.existsSync()) return const {};
  final tracking = <String, ({String status, String proof})>{};
  for (final line in file.readAsLinesSync()) {
    if (!line.startsWith('| ') || !line.contains('`lib/content/')) continue;
    final columns = line.split('|').map((part) => part.trim()).toList();
    if (columns.length < 14) continue;
    final path = columns[6].replaceAll('`', '');
    if (!path.startsWith('lib/content/')) continue;
    tracking[path] = (status: columns[11], proof: columns[12]);
  }
  return tracking;
}

_Row _inspect(File file) {
  final source = file.readAsStringSync();
  final path = file.path.replaceAll('\\', '/');
  final relative = path.split('/').skip(3).toList();
  final track = path.contains('/gpx_scolarite/') ? 'GPX' : 'PA';
  final domain = relative.isEmpty ? 'racine' : _humanize(relative.first);
  final courseParts = relative.length <= 1
      ? <String>[]
      : relative.sublist(0, relative.length - 1);
  final course = courseParts.isEmpty
      ? _humanize(file.uri.pathSegments.last.replaceFirst('.dart', ''))
      : courseParts.map(_humanize).join(' › ');
  final route = RegExp(
    r'''static\s+const\s+String\s+routeName\s*=\s*['"]([^'"]+)['"]''',
  ).firstMatch(source)?.group(1);
  final pageClass = RegExp(
    r'class\s+([A-Za-z0-9_]*(?:Page|Screen|Quiz)[A-Za-z0-9_]*)\s+extends\s+',
  ).firstMatch(source)?.group(1);
  final title = _detectTitle(source, file);
  final lines = '\n'.allMatches(source).length + 1;
  return _Row(
    path: path,
    track: track,
    domain: domain,
    course: course,
    kind: _detectKind(path, source),
    route: route,
    pageClass: pageClass,
    title: title,
    lines: lines,
  );
}

String _detectKind(String path, String source) {
  final lower = path.toLowerCase();
  if (lower.contains('quiz') ||
      lower.contains('quizz') ||
      source.contains('Question(')) {
    return 'Quiz/QCM';
  }
  if (lower.contains('intro')) return 'Introduction';
  if (lower.contains('contenu') || lower.contains('content'))
    return 'Cours/contenu';
  if (source.contains('Navigator.') && source.contains('ListView'))
    return 'Navigation/sommaire';
  if (source.contains('Widget build')) return 'Page ou composant';
  return 'Support/ressource';
}

String _detectTitle(String source, File file) {
  final appBar = RegExp(
    r'''title\s*:\s*(?:const\s+)?Text\(\s*['"]([^'"\n]{2,120})['"]''',
    multiLine: true,
  ).firstMatch(source)?.group(1);
  if (appBar != null) return appBar.replaceAll(r'\n', ' ');
  final firstText = RegExp(
    r'''(?:const\s+)?Text\(\s*['"]([^'"\n]{3,120})['"]''',
    multiLine: true,
  ).firstMatch(source)?.group(1);
  return firstText?.replaceAll(r'\n', ' ') ??
      _humanize(file.uri.pathSegments.last.replaceFirst('.dart', ''));
}

String _humanize(String value) =>
    value.replaceAll('.dart', '').replaceAll(RegExp(r'[_-]+'), ' ').trim();

String _cell(String? value) =>
    (value == null || value.trim().isEmpty ? '—' : value)
        .replaceAll('|', r'\|')
        .replaceAll('\n', ' ');

String _codeOrDash(String? value) =>
    value == null || value.isEmpty ? '—' : '`${_cell(value)}`';

class _Row {
  const _Row({
    required this.path,
    required this.track,
    required this.domain,
    required this.course,
    required this.kind,
    required this.route,
    required this.pageClass,
    required this.title,
    required this.lines,
  });

  final String path;
  final String track;
  final String domain;
  final String course;
  final String kind;
  final String? route;
  final String? pageClass;
  final String title;
  final int lines;
}
