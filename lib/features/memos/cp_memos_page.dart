// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Liste + lecteur des fiches mémo                  ║
// ║  Référence : docs/cas_pratique/PROGRESSION_CODE.md — CODE-090             ║
// ║                                                                           ║
// ║  Deux écrans :                                                            ║
// ║   • CpMemosListPage    : grid des fiches mémo (lit la vue                ║
// ║                          cp_memos_with_read_state)                       ║
// ║   • CpMemoReaderPage   : lecteur markdown léger (parsing inline,        ║
// ║                          pas de dépendance flutter_markdown forcée)    ║
// ║                                                                           ║
// ║  Tracking : `cp_memo_mark_read(memo_id, duration_seconds)` RPC appelé   ║
// ║  quand l'utilisateur quitte le reader (back ou pop).                    ║
// ║                                                                           ║
// ║  Routes :                                                                 ║
// ║   • CpMemosListPage.routeName  = '/cas-pratique/memos'                  ║
// ║   • CpMemoReaderPage.routeName = '/cas-pratique/memos/reader'           ║
// ║     Argument : `{ 'slug': 'deontologie-5-points' }`                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ──────────────────────────────────────────────────────────────────────────
//  Modèles
// ──────────────────────────────────────────────────────────────────────────

class CpMemoListItem {
  final String id;
  final String slug;
  final String title;
  final String? excerpt;
  final List<String> tags;
  final int readingTimeMinutes;
  final bool isPremium;
  final bool isReadByUser;

  const CpMemoListItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.tags,
    required this.readingTimeMinutes,
    required this.isPremium,
    required this.isReadByUser,
  });

  factory CpMemoListItem.fromMap(Map<String, dynamic> m) {
    final tagsRaw = m['tags'];
    final tags = <String>[];
    if (tagsRaw is List) {
      for (final t in tagsRaw) {
        if (t is String) tags.add(t);
      }
    }
    return CpMemoListItem(
      id: m['id']?.toString() ?? '',
      slug: m['slug']?.toString() ?? '',
      title: m['title']?.toString() ?? '',
      excerpt: m['excerpt']?.toString(),
      tags: tags,
      readingTimeMinutes: (m['reading_time_minutes'] as num?)?.toInt() ?? 0,
      isPremium: m['is_premium'] == true,
      isReadByUser: m['is_read_by_user'] == true,
    );
  }
}

class CpMemoFull {
  final String id;
  final String slug;
  final String title;
  final String contentMd;
  final int readingTimeMinutes;

  const CpMemoFull({
    required this.id,
    required this.slug,
    required this.title,
    required this.contentMd,
    required this.readingTimeMinutes,
  });

  factory CpMemoFull.fromMap(Map<String, dynamic> m) {
    return CpMemoFull(
      id: m['id']?.toString() ?? '',
      slug: m['slug']?.toString() ?? '',
      title: m['title']?.toString() ?? '',
      contentMd: m['content_md']?.toString() ?? '',
      readingTimeMinutes: (m['reading_time_minutes'] as num?)?.toInt() ?? 0,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Page liste
// ──────────────────────────────────────────────────────────────────────────

class CpMemosListPage extends StatefulWidget {
  const CpMemosListPage({super.key});
  static const String routeName = '/cas-pratique/memos';

  @override
  State<CpMemosListPage> createState() => _CpMemosListPageState();
}

class _CpMemosListPageState extends State<CpMemosListPage> {
  late Future<List<CpMemoListItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<CpMemoListItem>> _load() async {
    final sb = Supabase.instance.client;
    final res = await sb.from('cp_memos_with_read_state').select();
    return res
        .whereType<Map>()
        .map((m) => CpMemoListItem.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);
    final muted = ink.withValues(alpha: .65);
    final cardBg = isDark ? const Color(0xFF111111) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: .08)
        : Colors.black.withValues(alpha: .06);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: ink, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Fiches mémo',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<CpMemoListItem>>(
            future: _future,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Text(
                    'Erreur : ${snap.error}',
                    style: GoogleFonts.montserrat(color: muted),
                  ),
                );
              }
              final items = snap.data ?? const [];
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Pas encore de fiche mémo.',
                    style: GoogleFonts.montserrat(color: muted),
                  ),
                );
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final m = items[i];
                  return _MemoCard(
                    item: m,
                    onTap: () => Navigator.of(context).pushNamed(
                      CpMemoReaderPage.routeName,
                      arguments: {'slug': m.slug},
                    ),
                    ink: ink,
                    muted: muted,
                    cardBg: cardBg,
                    borderColor: borderColor,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Card mémo (liste)
// ──────────────────────────────────────────────────────────────────────────

class _MemoCard extends StatelessWidget {
  final CpMemoListItem item;
  final VoidCallback onTap;
  final Color ink;
  final Color muted;
  final Color cardBg;
  final Color borderColor;

  const _MemoCard({
    required this.item,
    required this.onTap,
    required this.ink,
    required this.muted,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1147D9).withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF1147D9),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: ink,
                      ),
                    ),
                  ),
                  if (item.isReadByUser)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF22C55E),
                      size: 18,
                    ),
                ],
              ),
              if (item.excerpt != null && item.excerpt!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  item.excerpt!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: muted,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.timer_outlined, color: muted, size: 13),
                  const SizedBox(width: 3),
                  Text(
                    '${item.readingTimeMinutes} min',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: muted,
                    ),
                  ),
                  if (item.isPremium) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC700),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'PREMIUM',
                        style: GoogleFonts.montserrat(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF000B36),
                          letterSpacing: .6,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  for (final tag in item.tags.take(2)) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ink.withValues(alpha: .06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#$tag',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: muted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Page lecteur (markdown léger inline)
// ──────────────────────────────────────────────────────────────────────────

class CpMemoReaderPage extends StatefulWidget {
  const CpMemoReaderPage({super.key, required this.slug});
  static const String routeName = '/cas-pratique/memos/reader';
  final String slug;

  @override
  State<CpMemoReaderPage> createState() => _CpMemoReaderPageState();
}

class _CpMemoReaderPageState extends State<CpMemoReaderPage> {
  Future<CpMemoFull?>? _future;
  DateTime? _startedAt;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _future = _load();
  }

  Future<CpMemoFull?> _load() async {
    final sb = Supabase.instance.client;
    final res = await sb
        .from('cas_pratique_memos')
        .select('id, slug, title, content_md, reading_time_minutes')
        .eq('slug', widget.slug)
        .maybeSingle();
    if (res == null) return null;
    return CpMemoFull.fromMap(Map<String, dynamic>.from(res));
  }

  @override
  void dispose() {
    _trackRead();
    super.dispose();
  }

  Future<void> _trackRead() async {
    try {
      final sb = Supabase.instance.client;
      final memo = await _future;
      if (memo == null) return;
      final duration = _startedAt == null
          ? null
          : DateTime.now().difference(_startedAt!).inSeconds;
      await sb.rpc(
        'cp_memo_mark_read',
        params: {
          'p_memo_id': memo.id,
          'p_duration_seconds': duration,
        },
      );
    } catch (_) {/* silencieux */}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF1C1C1C);
    final muted = ink.withValues(alpha: .65);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: ink, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<CpMemoFull?>(
          future: _future,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snap.hasData || snap.data == null) {
              return Center(
                child: Text(
                  'Fiche introuvable.',
                  style: GoogleFonts.montserrat(color: muted),
                ),
              );
            }
            final memo = snap.data!;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memo.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ink,
                      height: 1.2,
                      letterSpacing: -.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, color: muted, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${memo.readingTimeMinutes} min de lecture',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _MemoMarkdownBody(content: memo.contentMd, ink: ink),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
//  Markdown léger (h1/h2/h3, **bold**, *italic*, bullet `- `)
//  Pas de dépendance externe — parsing inline simple ligne par ligne.
// ──────────────────────────────────────────────────────────────────────────

class _MemoMarkdownBody extends StatelessWidget {
  final String content;
  final Color ink;
  const _MemoMarkdownBody({required this.content, required this.ink});

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    final lines = content.split(RegExp(r'\r?\n'));

    for (final raw in lines) {
      final line = raw.trimRight();
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }
      if (line.startsWith('# ')) {
        widgets.add(_h(line.substring(2), 20, FontWeight.w800));
        continue;
      }
      if (line.startsWith('## ')) {
        widgets.add(_h(line.substring(3), 16.5, FontWeight.w800));
        continue;
      }
      if (line.startsWith('### ')) {
        widgets.add(_h(line.substring(4), 14, FontWeight.w700));
        continue;
      }
      if (line.startsWith('- ')) {
        widgets.add(_bullet(line.substring(2)));
        continue;
      }
      widgets.add(_paragraph(line));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _h(String text, double size, FontWeight weight) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        _stripInline(text),
        style: GoogleFonts.montserrat(
          fontSize: size,
          fontWeight: weight,
          color: ink,
          height: 1.2,
          letterSpacing: -.2,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: _inlineSpan(text, ink),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: ink.withValues(alpha: .55),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: RichText(text: _inlineSpan(text, ink)),
          ),
        ],
      ),
    );
  }

  String _stripInline(String text) {
    return text
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
  }

  TextSpan _inlineSpan(String raw, Color ink) {
    final base = GoogleFonts.montserrat(
      fontSize: 13.5,
      fontWeight: FontWeight.w500,
      color: ink,
      height: 1.55,
    );
    final boldStyle = base.copyWith(fontWeight: FontWeight.w800);
    final italicStyle = base.copyWith(fontStyle: FontStyle.italic);

    final pattern = RegExp(r'(\*\*[^*]+\*\*|\*[^*]+\*)');
    final spans = <InlineSpan>[];
    int last = 0;
    for (final match in pattern.allMatches(raw)) {
      if (match.start > last) {
        spans.add(TextSpan(text: raw.substring(last, match.start), style: base));
      }
      final m = match.group(0)!;
      if (m.startsWith('**') && m.endsWith('**')) {
        spans.add(TextSpan(
            text: m.substring(2, m.length - 2), style: boldStyle));
      } else if (m.startsWith('*') && m.endsWith('*')) {
        spans.add(TextSpan(
            text: m.substring(1, m.length - 1), style: italicStyle));
      } else {
        spans.add(TextSpan(text: m, style: base));
      }
      last = match.end;
    }
    if (last < raw.length) {
      spans.add(TextSpan(text: raw.substring(last), style: base));
    }
    return TextSpan(children: spans);
  }
}
