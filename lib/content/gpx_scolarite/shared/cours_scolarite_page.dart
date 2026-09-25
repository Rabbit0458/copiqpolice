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

import 'package:copiqpolice/core/content/course_markdown_parser.dart';

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
    // Une seule couleur de marque sur toutes les fiches dynamiques. Les
    // anciennes valeurs distantes rouge/bleu créaient deux designs différents.
    return const Color(0xFF2563EB);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF101114) : const Color(0xFFF5F6F8);
    final foreground = isDark ? Colors.white : const Color(0xFF17181B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Retour',
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: foreground),
        ),
        title: Text(
          (_cours?['code'] as String?) ?? 'Fiche',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'InstrumentSans',
            color: foreground,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
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
    final surface = isDark ? const Color(0xFF1A1C20) : Colors.white;
    final foreground = isDark ? Colors.white : const Color(0xFF17181B);
    final muted = isDark
        ? Colors.white.withValues(alpha: .68)
        : const Color(0xFF596170);
    final border = isDark
        ? Colors.white.withValues(alpha: .09)
        : const Color(0xFFE6E9EF);
    final keyPoints = <String>[
      if (c['key_points'] is List)
        ...(c['key_points'] as List).map((e) => e.toString()),
    ];
    final legalRefs = <String>[
      if (c['legal_refs'] is List)
        ...(c['legal_refs'] as List).map((e) => e.toString()),
    ];
    final quizModule = c['quiz_module'] as String?;
    final title = (c['title'] as String?)?.trim() ?? '';
    final subtitle = (c['subtitle'] as String?)?.trim() ?? '';
    final code = (c['code'] as String?)?.trim() ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 760 ? 28.0 : 16.0;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            6,
            horizontalPadding,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 21),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? .12 : .045,
                            ),
                            blurRadius: 22,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const _FrenchSignature(),
                              const Spacer(),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: _accent.withValues(
                                    alpha: isDark ? .18 : .09,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.menu_book_rounded,
                                  color: _accent,
                                  size: 21,
                                ),
                              ),
                            ],
                          ),
                          if (code.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _accent.withValues(
                                  alpha: isDark ? .17 : .08,
                                ),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                code.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'InstrumentSans',
                                  color: isDark
                                      ? const Color(0xFF8AB4FF)
                                      : const Color(0xFF1D4ED8),
                                  fontSize: 10.5,
                                  letterSpacing: .9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 11),
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'InstrumentSans',
                              color: foreground,
                              fontSize: title.length > 44 ? 23 : 26,
                              fontWeight: FontWeight.w900,
                              height: 1.12,
                              letterSpacing: -.4,
                            ),
                          ),
                          if (subtitle.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontFamily: 'InstrumentSans',
                                color: muted,
                                fontSize: 14.5,
                                height: 1.42,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (keyPoints.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? .12 : .045,
                            ),
                            blurRadius: 22,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _accent.withValues(
                                    alpha: isDark ? .18 : .1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.lightbulb_outline_rounded,
                                  size: 20,
                                  color: _accent,
                                ),
                              ),
                              const SizedBox(width: 11),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'L’ESSENTIEL',
                                    style: TextStyle(
                                      fontFamily: 'InstrumentSans',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                      color: _accent,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    'À retenir',
                                    style: TextStyle(
                                      fontFamily: 'InstrumentSans',
                                      color: foreground,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Divider(color: border, height: 1),
                          const SizedBox(height: 14),
                          ...List.generate(keyPoints.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == keyPoints.length - 1 ? 0 : 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(top: 1),
                                    decoration: BoxDecoration(
                                      color: _accent.withValues(
                                        alpha: isDark ? .18 : .1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 13,
                                      color: _accent,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      keyPoints[index],
                                      style: TextStyle(
                                        fontFamily: 'InstrumentSans',
                                        color: foreground.withValues(
                                          alpha: .86,
                                        ),
                                        fontSize: 14.5,
                                        height: 1.42,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: border),
                    ),
                    child: _MarkdownBody(
                      source: (c['body_md'] as String?) ?? '',
                      accent: _accent,
                      surface: surface,
                    ),
                  ),
                  if (legalRefs.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_outlined,
                                size: 19,
                                color: _accent,
                              ),
                              const SizedBox(width: 9),
                              Text(
                                'Références',
                                style: TextStyle(
                                  fontFamily: 'InstrumentSans',
                                  color: foreground,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: legalRefs
                                .map(
                                  (reference) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _accent.withValues(
                                        alpha: isDark ? .16 : .08,
                                      ),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      reference,
                                      style: TextStyle(
                                        fontFamily: 'InstrumentSans',
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? const Color(0xFF8AB4FF)
                                            : const Color(0xFF1D4ED8),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (quizModule != null) ...[
                    const SizedBox(height: 18),
                    Semantics(
                      button: true,
                      label: 'Tester mes connaissances sur ce cours',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 56),
                        child: FilledButton.icon(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pushNamed(
                              '/gpx/scolarite/quiz',
                              arguments: quizModule,
                            );
                          },
                          icon: const Icon(Icons.quiz_rounded, size: 20),
                          label: Text(
                            'Tester mes connaissances',
                            style: const TextStyle(
                              fontFamily: 'InstrumentSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF17181B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FrenchSignature extends StatelessWidget {
  const _FrenchSignature();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: 'COP’IQ',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ColoredBox(
              color: Color(0xFF2563EB),
              child: SizedBox(width: 18, height: 4),
            ),
            ColoredBox(
              color: isDark ? Colors.white : const Color(0xFFDDE1E8),
              child: const SizedBox(width: 18, height: 4),
            ),
            const ColoredBox(
              color: Color(0xFFEF4444),
              child: SizedBox(width: 18, height: 4),
            ),
          ],
        ),
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
    final parsed = parseCourseMarkdown(source);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        parsed.length,
        (index) => _renderBlock(
          context,
          parsed[index],
          isFirst: index == 0,
          isLast: index == parsed.length - 1,
        ),
      ),
    );
  }

  Widget _renderBlock(
    BuildContext context,
    CourseMarkdownBlock block, {
    required bool isFirst,
    required bool isLast,
  }) {
    switch (block.type) {
      case CourseMarkdownBlockType.divider:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: .45),
            height: 1,
          ),
        );
      case CourseMarkdownBlockType.table:
        return _table(context, block.rows);
      case CourseMarkdownBlockType.quote:
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: isFirst ? 0 : 8, bottom: 14),
          padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: .07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withValues(alpha: .16)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.format_quote_rounded, color: accent, size: 21),
              const SizedBox(width: 10),
              Expanded(
                child: _rich(
                  context,
                  block.text,
                  fontSize: 15,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      case CourseMarkdownBlockType.heading:
        return _heading(
          context,
          block.text,
          block.headingLevel,
          isFirst: isFirst,
        );
      case CourseMarkdownBlockType.orderedList:
      case CourseMarkdownBlockType.unorderedList:
        final ordered = block.type == CourseMarkdownBlockType.orderedList;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 8 : 14),
          child: Column(
            children: List.generate(
              block.items.length,
              (index) => _listItem(
                context,
                ordered ? '${block.listStart + index}' : '•',
                block.items[index],
                isLast: index == block.items.length - 1,
              ),
            ),
          ),
        );
      case CourseMarkdownBlockType.paragraph:
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 12 : 16),
          child: _rich(context, block.text, fontSize: 15.5, height: 1.52),
        );
    }
  }

  Widget _heading(
    BuildContext context,
    String text,
    int level, {
    required bool isFirst,
  }) {
    final foreground = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF17181B);
    final size = switch (level) {
      1 => 22.0,
      2 => 19.5,
      3 => 17.0,
      _ => 15.5,
    };
    final heading = Text(
      text,
      style: TextStyle(
        fontFamily: 'InstrumentSans',
        color: foreground,
        fontSize: size,
        fontWeight: level <= 2 ? FontWeight.w900 : FontWeight.w800,
        height: 1.25,
        letterSpacing: level <= 2 ? -.2 : 0,
      ),
    );
    return Semantics(
      header: true,
      child: Padding(
        padding: EdgeInsets.only(
          top: isFirst ? 0 : (level <= 2 ? 16 : 10),
          bottom: level <= 2 ? 10 : 8,
        ),
        child: level <= 2
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: size * 1.25,
                    margin: const EdgeInsets.only(right: 11),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  Expanded(child: heading),
                ],
              )
            : heading,
      ),
    );
  }

  Widget _listItem(
    BuildContext context,
    String bullet,
    String text, {
    required bool isLast,
  }) {
    final ordered = bullet != '•';
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ordered)
            Container(
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 8, top: 1),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                bullet,
                style: TextStyle(
                  fontFamily: 'InstrumentSans',
                  color: accent,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
            SizedBox(
              width: 28,
              height: 24,
              child: Align(
                alignment: const Alignment(0, -.25),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          Expanded(child: _rich(context, text, fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }

  Widget _table(BuildContext context, List<List<String>> rows) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final header = rows.first;
    final body = rows.skip(1).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : const Color(0xFF17181B);
    final border = isDark
        ? Colors.white.withValues(alpha: .1)
        : const Color(0xFFE5E9F0);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 620 && body.isNotEmpty) {
            return Column(
              children: List.generate(body.length, (rowIndex) {
                final row = body[rowIndex];
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    bottom: rowIndex == body.length - 1 ? 0 : 10,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: .035)
                        : const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(header.length, (cellIndex) {
                      final value = cellIndex < row.length
                          ? row[cellIndex]
                          : '';
                      if (value.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: cellIndex == header.length - 1 ? 0 : 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              header[cellIndex],
                              style: TextStyle(
                                fontFamily: 'InstrumentSans',
                                color: accent,
                                fontSize: 10.5,
                                letterSpacing: .65,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            _rich(context, value, fontSize: 14, height: 1.4),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),
            );
          }

          final desiredWidth = header.length * 150.0;
          final tableWidth = desiredWidth < constraints.maxWidth
              ? constraints.maxWidth
              : desiredWidth;
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(color: border),
                      verticalInside: BorderSide(color: border),
                    ),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: isDark ? .16 : .08),
                        ),
                        children: header
                            .map(
                              (cell) => Padding(
                                padding: const EdgeInsets.all(11),
                                child: Text(
                                  cell,
                                  style: TextStyle(
                                    fontFamily: 'InstrumentSans',
                                    color: isDark
                                        ? const Color(0xFF8AB4FF)
                                        : const Color(0xFF1D4ED8),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      ...body.map(
                        (row) => TableRow(
                          children: List.generate(header.length, (index) {
                            final value = index < row.length ? row[index] : '';
                            return Padding(
                              padding: const EdgeInsets.all(11),
                              child: _rich(
                                context,
                                value,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Applique **gras**, *italique* et `code` sur un fragment de texte.
  Widget _rich(
    BuildContext context,
    String text, {
    required double fontSize,
    required double height,
    FontStyle? fontStyle,
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
      textScaler: MediaQuery.textScalerOf(context),
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'InstrumentSans',
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .82)
              : const Color(0xFF2C3037),
          fontSize: fontSize,
          height: height,
          fontWeight: FontWeight.w500,
          fontStyle: fontStyle,
        ),
        children: spans,
      ),
    );
  }
}
