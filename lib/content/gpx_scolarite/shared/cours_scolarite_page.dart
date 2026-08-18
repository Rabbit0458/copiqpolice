// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Fiche de cours générique, alimentée par Supabase               ║
// ║                                                                          ║
// ║  Le contenu pédagogique vit dans la table `cours_scolarite` : titre,      ║
// ║  corps en Markdown, points clés, références légales et quiz associé.     ║
// ║  Corriger une fiche se fait depuis le panel admin, sans republier         ║
// ║  l'application sur les stores.                                            ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Catalogue des nouvelles fiches créées depuis le panneau administrateur.
/// Les cours historiques conservent leurs routes et leurs widgets d'origine.
class CoursScolariteCatalogPage extends StatefulWidget {
  const CoursScolariteCatalogPage({super.key});

  @override
  State<CoursScolariteCatalogPage> createState() =>
      _CoursScolariteCatalogPageState();
}

class _CoursScolariteCatalogPageState extends State<CoursScolariteCatalogPage> {
  late final Future<List<Map<String, dynamic>>> _courses = _load();

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await Supabase.instance.client
        .from('cours_scolarite')
        .select('route, code, title, subtitle, track, category, sort_order')
        .eq('is_published', true)
        .order('sort_order')
        .order('title');
    return (rows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fiches de cours')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _courses,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Chargement des cours impossible.'),
            );
          }
          final courses = snapshot.data ?? const <Map<String, dynamic>>[];
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final course = courses[index];
              final title = (course['title'] as String?) ?? 'Cours';
              final code = (course['code'] as String?) ?? '';
              final subtitle = (course['subtitle'] as String?) ?? '';
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(code)),
                  title: Text(title),
                  subtitle: subtitle.isEmpty ? null : Text(subtitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CoursScolaritePage(
                        courseRoute: course['route'] as String?,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Fiche de cours chargée depuis Supabase.
///
/// La route est l'identifiant : soit passée au constructeur (`courseRoute`),
/// soit déduite de la route courante.
class CoursScolaritePage extends StatefulWidget {
  const CoursScolaritePage({super.key, this.courseRoute});

  static const String routeName = '/gpx/scolarite/cours';

  final String? courseRoute;

  @override
  State<CoursScolaritePage> createState() => _CoursScolaritePageState();
}

class _CoursScolaritePageState extends State<CoursScolaritePage> {
  final _sb = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _cours;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final settings = ModalRoute.of(context)?.settings;
    final args = settings?.arguments;
    final key =
        widget.courseRoute ?? (args is String ? args : null) ?? settings?.name;

    if (key == null || key.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Aucune fiche demandée.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final row = await _sb
          .from('cours_scolarite')
          .select()
          .eq('route', key)
          .eq('is_published', true)
          .maybeSingle();

      if (!mounted) return;
      if (row == null) {
        setState(() {
          _loading = false;
          _error = 'Cette fiche n’est pas encore disponible.';
        });
        return;
      }
      setState(() {
        _cours = Map<String, dynamic>.from(row);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Chargement impossible. Vérifie ta connexion.';
      });
      debugPrint('cours_scolarite: chargement KO — $e');
    }
  }

  Color get _accent {
    final hex = (_cours?['color_hex'] as String?) ?? '#1147D9';
    final v = hex.replaceAll('#', '').trim();
    return Color(
      int.tryParse(v.length == 6 ? 'FF$v' : v, radix: 16) ?? 0xFF1147D9,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF06102A) : const Color(0xFFF4F6FB);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          (_cours?['code'] as String?) ?? 'Fiche',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? _buildError()
            : _buildContent(isDark),
      ),
    );
  }

  Widget _buildError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 44,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(height: 14),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _load, child: const Text('Réessayer')),
        ],
      ),
    ),
  );

  Widget _buildContent(bool isDark) {
    final c = _cours!;
    final surface = isDark ? const Color(0xFF0D1B4B) : Colors.white;
    final keyPoints = <String>[
      if (c['key_points'] is List)
        ...(c['key_points'] as List).map((e) => e.toString()),
    ];
    final legalRefs = <String>[
      if (c['legal_refs'] is List)
        ...(c['legal_refs'] as List).map((e) => e.toString()),
    ];
    final quizModule = c['quiz_module'] as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── En-tête ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accent, _accent.withValues(alpha: .78)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (c['code'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .22),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      c['code'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  (c['title'] as String?) ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                if (c['subtitle'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    c['subtitle'] as String,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ─── Points clés ───────────────────────────────────────────────
          if (keyPoints.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _accent.withValues(alpha: .28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.push_pin_rounded, size: 17, color: _accent),
                      const SizedBox(width: 7),
                      Text(
                        'À RETENIR',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .8,
                          color: _accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...keyPoints.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 7, right: 10),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: _accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              p,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ─── Corps de la fiche ─────────────────────────────────────────
          const SizedBox(height: 20),
          _MarkdownBody(
            source: (c['body_md'] as String?) ?? '',
            accent: _accent,
            surface: surface,
          ),

          // ─── Références légales ────────────────────────────────────────
          if (legalRefs.isNotEmpty) ...[
            const SizedBox(height: 22),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: legalRefs
                  .map(
                    (r) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        r,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _accent,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          // ─── Quiz associé ──────────────────────────────────────────────
          if (quizModule != null) ...[
            const SizedBox(height: 26),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(
                    context,
                  ).pushNamed('/gpx/scolarite/quiz', arguments: quizModule);
                },
                icon: const Icon(Icons.quiz_rounded, size: 20),
                label: const Text(
                  'Tester mes connaissances',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  Rendu Markdown minimal
//
//  Volontairement sans dépendance externe : le projet n'embarque pas de
//  paquet Markdown côté application. Le sous-ensemble supporté couvre ce
//  qu'utilisent les fiches : titres, listes, tableaux, citations, gras,
//  italique, code et séparateurs.
// ═══════════════════════════════════════════════════════════════════════════

class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({
    required this.source,
    required this.accent,
    required this.surface,
  });

  final String source;
  final Color accent;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[];
    final lines = source.split('\n');
    var i = 0;

    while (i < lines.length) {
      final line = lines[i];
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        i++;
        continue;
      }

      // Séparateur
      if (trimmed == '---' || trimmed == '___' || trimmed == '***') {
        blocks.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: accent.withValues(alpha: .2), height: 1),
          ),
        );
        i++;
        continue;
      }

      // Tableau
      if (trimmed.startsWith('|')) {
        final rows = <List<String>>[];
        while (i < lines.length && lines[i].trim().startsWith('|')) {
          final cells = lines[i]
              .trim()
              .split('|')
              .where((c) => c.isNotEmpty || false)
              .map((c) => c.trim())
              .toList();
          cells.removeWhere((c) => c.isEmpty && cells.length > 1);
          // Ligne de séparation |---|---|
          if (!RegExp(r'^[\s:\-|]+$').hasMatch(lines[i].trim())) {
            rows.add(cells);
          }
          i++;
        }
        if (rows.isNotEmpty) blocks.add(_table(context, rows));
        continue;
      }

      // Citation
      if (trimmed.startsWith('>')) {
        final buffer = <String>[];
        while (i < lines.length && lines[i].trim().startsWith('>')) {
          buffer.add(lines[i].trim().replaceFirst(RegExp(r'^>\s?'), ''));
          i++;
        }
        blocks.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .07),
              border: Border(left: BorderSide(color: accent, width: 3)),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: _rich(context, buffer.join(' '), fontSize: 14, height: 1.5),
          ),
        );
        continue;
      }

      // Titres
      final h = RegExp(r'^(#{1,4})\s+(.*)$').firstMatch(trimmed);
      if (h != null) {
        final level = h.group(1)!.length;
        final sizes = {1: 22.0, 2: 19.0, 3: 16.5, 4: 15.0};
        blocks.add(
          Padding(
            padding: EdgeInsets.only(top: level <= 2 ? 20 : 14, bottom: 8),
            child: Text(
              h.group(2)!,
              style: TextStyle(
                fontSize: sizes[level] ?? 15,
                fontWeight: FontWeight.w800,
                height: 1.3,
                color: level <= 2 ? accent : null,
              ),
            ),
          ),
        );
        i++;
        continue;
      }

      // Liste numérotée
      final ol = RegExp(r'^(\d+)\.\s+(.*)$').firstMatch(trimmed);
      if (ol != null) {
        blocks.add(_listItem(context, ol.group(1)!, ol.group(2)!));
        i++;
        continue;
      }

      // Liste à puces
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        blocks.add(_listItem(context, '•', trimmed.substring(2)));
        i++;
        continue;
      }

      // Paragraphe
      blocks.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: _rich(context, trimmed, fontSize: 14.5, height: 1.55),
        ),
      );
      i++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }

  Widget _listItem(BuildContext context, String bullet, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          child: Text(
            bullet.length > 1 ? '$bullet.' : bullet,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: accent,
              height: 1.55,
            ),
          ),
        ),
        Expanded(child: _rich(context, text, fontSize: 14.5, height: 1.55)),
      ],
    ),
  );

  Widget _table(BuildContext context, List<List<String>> rows) {
    final header = rows.first;
    final body = rows.skip(1).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: surface,
            border: Border.all(color: accent.withValues(alpha: .2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                color: accent.withValues(alpha: .10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: header
                      .map(
                        (cell) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              cell,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: accent,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              ...body.map(
                (r) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(header.length, (idx) {
                      final cell = idx < r.length ? r[idx] : '';
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _rich(
                            context,
                            cell,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Applique **gras**, *italique* et `code` sur un fragment de texte.
  Widget _rich(
    BuildContext context,
    String text, {
    required double fontSize,
    required double height,
  }) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'(\*\*[^*]+\*\*|\*[^*]+\*|`[^`]+`)');
    var last = 0;

    for (final m in pattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start)));
      }
      final token = m.group(0)!;
      if (token.startsWith('**')) {
        spans.add(
          TextSpan(
            text: token.substring(2, token.length - 2),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        );
      } else if (token.startsWith('`')) {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: fontSize - 1,
              backgroundColor: accent.withValues(alpha: .10),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      }
      last = m.end;
    }
    if (last < text.length) spans.add(TextSpan(text: text.substring(last)));

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(
          context,
        ).style.copyWith(fontSize: fontSize, height: height),
        children: spans,
      ),
    );
  }
}
