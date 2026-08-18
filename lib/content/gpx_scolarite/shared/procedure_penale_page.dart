// lib/pages/gpx/procedure_penale_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:copiqpolice/core/services/favorites.dart';
import 'package:copiqpolice/core/widgets/app_notifier.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/plainte_page.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ProcedurePenalePage extends StatefulWidget {
  static const routeName = '/procedure_penale';
  const ProcedurePenalePage({super.key});
  @override
  State<ProcedurePenalePage> createState() => _ProcedurePenalePageState();
}

class _ProcedurePenalePageState extends State<ProcedurePenalePage> {
  final _search = TextEditingController();
  bool _isFav = false;

  // ————— Données (reprennent ta base, tu peux compléter à l’identique) ————
  final List<_Section> _sections = _demoData();

  // états d’expansion
  final Map<String, bool> _sectionOpen = {};
  final Map<String, bool> _chapterOpen = {};

  // filtre par texte
  String _q = '';

  @override
  void initState() {
    super.initState();
    _initFav();
  }

  Future<void> _initFav() async {
    _isFav = await FavoritesStore.I.isFavorite(ProcedurePenalePage.routeName);
    if (mounted) setState(() {});
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isFav = !_isFav);
    await FavoritesStore.I.toggle(
      FavoriteItem(
        route: ProcedurePenalePage.routeName,
        title: ScolariteText.value(
          "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
          "f00001",
          'Procédure Pénale',
        ),
        subtitle: ScolariteText.value(
          "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
          "f00002",
          'Cadres juridiques et actes de PJ',
        ),
        image: 'assets/images/procedure_penale.jpg',
        rating: 4.9,
        reviews: 215,
      ),
    );
  }

  void _openQuiz(_Quiz quiz, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _QuizPage(quiz: quiz, chapterTitle: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = cs.brightness == Brightness.dark;

    final filtered = _sections.where((s) {
      if (_q.isEmpty) return true;
      final q = _q.toLowerCase();
      if (s.title.toLowerCase().contains(q)) return true;
      for (final c in s.chapters) {
        if (c.title.toLowerCase().contains(q)) return true;
        if (c.content.toLowerCase().contains(q)) return true;
      }
      return false;
    }).toList();

    return Scaffold(
      // On garde l’AppBar vide pour un HÉRO custom très propre
      body: CustomScrollView(
        slivers: [
          // ——— HERO / ENTÊTE ———
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.how_to_vote_rounded),
                      label: Text(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                          "f00003",
                          'Ouvrir la page Plainte',
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PlaintePage(),
                          ),
                        );
                        // ou Navigator.pushNamed(context, PlaintePage.routeName);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ——— BARRE DE RECHERCHE (pill) ———
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: _SearchPill(
                controller: _search,
                hint: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00004",
                  'Rechercher (ex: contrôle d’identité, GAV, plainte…)',
                ),
                onChanged: (v) => setState(() => _q = v.trim()),
              ),
            ),
          ),

          // ——— SECTIONS ———
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00005",
                    'Aucun résultat',
                  ),
                  style: tt.titleMedium?.copyWith(color: cs.outline),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final s = filtered[i];
                  final open = _sectionOpen[s.id] ?? false;
                  return _SectionTile(
                    section: s,
                    open: open,
                    onToggle: (v) => setState(() => _sectionOpen[s.id] = v),
                    chapterOpen: _chapterOpen,
                    onChapterToggle: (cid, v) =>
                        setState(() => _chapterOpen['${s.id}/$cid'] = v),
                    onStartQuiz: _openQuiz,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// /////////////////////////////////////////////////////////////////////////////
///  UI WIDGETS
/// /////////////////////////////////////////////////////////////////////////////

class _HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isFav;
  final VoidCallback onFavTap;
  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.isFav,
    required this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = cs.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [cs.surfaceContainerHighest, cs.surface]
                : [cs.primary.withValues(alpha: .10), cs.surface],
          ),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .35)),
        ),
        child: Stack(
          children: [
            // décor discret
            Positioned(
              right: -30,
              top: -20,
              child: _SoftBlob(
                color: cs.primary.withValues(alpha: .08),
                size: 160,
              ),
            ),
            Positioned(
              left: -20,
              bottom: -30,
              child: _SoftBlob(
                color: cs.secondary.withValues(alpha: .06),
                size: 140,
              ),
            ),

            // contenu
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _IconBadge(icon: Icons.gavel_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: tt.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _TinyTag(
                              icon: Icons.shield_moon_rounded,
                              label: 'CPP',
                            ),
                            _TinyTag(
                              icon: Icons.edit_note_rounded,
                              label: ScolariteText.value(
                                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                                "f00007",
                                'Trames PV',
                              ),
                            ),
                            _TinyTag(icon: Icons.quiz_rounded, label: 'Quiz'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onFavTap,
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                    color: isFav ? Colors.redAccent : null,
                    tooltip: isFav
                        ? ScolariteText.value(
                            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                            "f00008",
                            'Retirer des favoris',
                          )
                        : ScolariteText.value(
                            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                            "f00009",
                            'Ajouter aux favoris',
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchPill({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: .55),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: cs.outlineVariant.withValues(alpha: .5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: cs.outlineVariant.withValues(alpha: .5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: cs.primary.withValues(alpha: .6)),
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final _Section section;
  final bool open;
  final ValueChanged<bool> onToggle;
  final Map<String, bool> chapterOpen;
  final void Function(String chapterId, bool) onChapterToggle;
  final void Function(_Quiz quiz, String chapterTitle) onStartQuiz;

  const _SectionTile({
    required this.section,
    required this.open,
    required this.onToggle,
    required this.chapterOpen,
    required this.onChapterToggle,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .35)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: .06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: open,
            onExpansionChanged: onToggle,
            tilePadding: const EdgeInsets.fromLTRB(14, 6, 12, 6),
            childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 14),
            leading: _IconBadge(icon: section.icon),
            title: Text(
              section.title,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            subtitle: section.badge == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: _TinyTag(
                      icon: Icons.folder_rounded,
                      label: section.badge!,
                    ),
                  ),
            trailing: const Icon(Icons.keyboard_arrow_down_rounded),
            children: [
              const SizedBox(height: 8),
              ...section.chapters.map((c) {
                final open = chapterOpen['${section.id}/${c.id}'] ?? false;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                  child: _ChapterTile(
                    chapter: c,
                    open: open,
                    onToggle: (v) => onChapterToggle(c.id, v),
                    onStartQuiz: onStartQuiz,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  final _Chapter chapter;
  final bool open;
  final ValueChanged<bool> onToggle;
  final void Function(_Quiz quiz, String chapterTitle) onStartQuiz;

  const _ChapterTile({
    required this.chapter,
    required this.open,
    required this.onToggle,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: .6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .25)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: open,
            onExpansionChanged: onToggle,
            tilePadding: const EdgeInsets.fromLTRB(14, 6, 12, 6),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            title: Text(
              chapter.title,
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            subtitle: chapter.tags.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: chapter.tags
                          .map(
                            (t) => _TinyTag(icon: Icons.sell_rounded, label: t),
                          )
                          .toList(),
                    ),
                  ),
            trailing: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
            children: [
              Text(
                chapter.content,
                style: tt.bodyMedium,
                textAlign: TextAlign.start,
              ),
              if (chapter.quiz != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () => onStartQuiz(chapter.quiz!, chapter.title),
                    icon: const Icon(Icons.quiz_rounded, size: 18),
                    label: Text(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                        "f00011",
                        'Commencer le quiz',
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
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withValues(alpha: .25)),
      ),
      child: Icon(icon, color: cs.primary),
    );
  }
}

class _TinyTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TinyTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: .3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSecondaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: tt.labelSmall?.copyWith(color: cs.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}

class _SoftBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _SoftBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: pi / 12,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
    );
  }
}

/// /////////////////////////////////////////////////////////////////////////////
///  QUIZ
/// /////////////////////////////////////////////////////////////////////////////

class _QuizPage extends StatefulWidget {
  final _Quiz quiz;
  final String chapterTitle;
  const _QuizPage({required this.quiz, required this.chapterTitle});

  @override
  State<_QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<_QuizPage> {
  int _i = 0;
  int? _sel;
  int _score = 0;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final q = widget.quiz.questions[_i];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz — ${widget.chapterTitle}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _done
            ? _result(tt)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (_i + 1) / widget.quiz.questions.length,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Question ${_i + 1}/${widget.quiz.questions.length}',
                    style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    q.q,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...q.options.asMap().entries.map(
                    (e) => _answerTile(e.key, e.value, q.answerIndex),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _sel == null ? null : _next,
                      child: Text(
                        _i < widget.quiz.questions.length - 1
                            ? ScolariteText.value(
                                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                                "f00014",
                                'Question suivante',
                              )
                            : 'Terminer',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _answerTile(int index, String text, int answerIndex) {
    final isSelected = _sel == index;
    final isCorrect = _sel != null && index == answerIndex;
    final isWrong = _sel != null && isSelected && index != answerIndex;

    Color? bg;
    if (isCorrect) bg = Colors.green.withValues(alpha: .12);
    if (isWrong) bg = Colors.red.withValues(alpha: .12);

    return Card(
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(child: Text(String.fromCharCode(65 + index))),
        title: Text(text),
        onTap: () => setState(() => _sel = index),
      ),
    );
  }

  void _next() {
    final q = widget.quiz.questions[_i];
    if (_sel == q.answerIndex) _score++;

    if (_i < widget.quiz.questions.length - 1) {
      setState(() {
        _i++;
        _sel = null;
      });
    } else {
      setState(() => _done = true);
      AppNotifier.success(
        context,
        title: ScolariteText.value(
          "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
          "f00015",
          'Quiz terminé',
        ),
        message: 'Score: $_score/${widget.quiz.questions.length}',
      );
    }
  }

  Widget _result(TextTheme tt) {
    final p = _score / widget.quiz.questions.length;
    String msg = p == 1
        ? ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00017",
            'Excellent !',
          )
        : p >= .7
        ? ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00018",
            'Très bon résultat !',
          )
        : p >= .5
        ? ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00019",
            'Correct, continue.',
          )
        : ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00020",
            'Revois le chapitre et réessaie.',
          );

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            p >= .7 ? Icons.emoji_events_rounded : Icons.check_circle_rounded,
            size: 80,
          ),
          const SizedBox(height: 10),
          Text(
            'Score: $_score/${widget.quiz.questions.length}',
            style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(msg, style: tt.bodyLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                      "f00022",
                      'Retour',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () => setState(() {
                    _i = 0;
                    _sel = null;
                    _score = 0;
                    _done = false;
                  }),
                  child: const Text('Recommencer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// /////////////////////////////////////////////////////////////////////////////
///  DATA MODELS & DEMO
/// /////////////////////////////////////////////////////////////////////////////

class _Section {
  final String id;
  final String title;
  final IconData icon;
  final String? badge;
  final List<_Chapter> chapters;
  const _Section({
    required this.id,
    required this.title,
    required this.icon,
    this.badge,
    required this.chapters,
  });
}

class _Chapter {
  final String id;
  final String title;
  final String content;
  final List<String> tags;
  final _Quiz? quiz;
  const _Chapter({
    required this.id,
    required this.title,
    required this.content,
    this.quiz,
    this.tags = const [],
  });
}

class _Quiz {
  final List<_Question> questions;
  const _Quiz({required this.questions});
}

class _Question {
  final String q;
  final List<String> options;
  final int answerIndex;
  const _Question({
    required this.q,
    required this.options,
    required this.answerIndex,
  });
}

List<_Section> _demoData() {
  return [
    _Section(
      id: 'ci',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
        "f00023",
        'Contrôles & vérifications d’identité',
      ),
      icon: Icons.badge_rounded,
      badge: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
        "f00024",
        'Art. 78-2 CPP',
      ),
      chapters: [
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00025",
            'ci-cadre',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00026",
            'Cadre général du contrôle',
          ),
          content:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00027",
                'Personnes concernées : toute personne sur le territoire national.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00028",
                'Autorités habilitées : OPJ, APJ sur ordre des OPJ.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00029",
                'Exclusions : volontaires gendarmerie, police municipale, policiers adjoints.',
              ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00030",
                  'Qui peut procéder à un contrôle d’identité ?',
                ),
                options: [
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00031",
                    'Les OPJ uniquement',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00032",
                    'Les OPJ et les APJ sur ordre des OPJ',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00033",
                    'Tous les fonctionnaires de police',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00034",
                    'Les agents de police municipale',
                  ),
                ],
                answerIndex: 1,
              ),
            ],
          ),
        ),
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00035",
            'ci-cas',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00036",
            'Cas de contrôle d’identité',
          ),
          content:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00037",
                'Police judiciaire : infraction commise/tentée, préparation crime/délit, renseignements utiles, violation obligations judiciaires, recherches PJ.\n\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00038",
                'Préventif : prévention atteinte à l’ordre public, lieux publics, circonstances particulières.\n\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00039",
                'Zone frontalière : 20 km des frontières Schengen, ports/aéroports internationaux, criminalité transfrontalière.',
              ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00040",
                  'Un contrôle préventif peut être effectué :',
                ),
                options: [
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00041",
                    'Dans un domicile privé',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00042",
                    'Uniquement sur personne suspecte',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00043",
                    'Dans des lieux publics',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00044",
                    'De façon systématique sans motif',
                  ),
                ],
                answerIndex: 2,
              ),
            ],
          ),
        ),
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00045",
            'ci-verif',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00046",
            'Vérification d’identité',
          ),
          content: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00047",
            'Durée maximale : 4h (8h à Mayotte/Guyane). Présentation à l’OPJ, information des droits, empreintes/photos avec autorisation magistrat, PV obligatoire, pas de mise en mémoire si sans suite.',
          ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00048",
                  'Durée maximale de rétention pour vérification d’identité :',
                ),
                options: [
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00049",
                    '24 heures',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00050",
                    '4 heures',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00051",
                    '8 heures',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00052",
                    '12 heures',
                  ),
                ],
                answerIndex: 1,
              ),
            ],
          ),
        ),
      ],
    ),
    _Section(
      id: 'flagrance',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
        "f00053",
        'Enquête de flagrance',
      ),
      icon: Icons.warning_amber_rounded,
      chapters: [
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00054",
            'flagrance-notion',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00055",
            'Notion de flagrance',
          ),
          content:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00056",
                'Proprement dite : crime/délit en train de se commettre ou venant de se commettre.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00057",
                'Par présomption : clameur publique, découverte d’objets/traces/indices.',
              ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00058",
                  'La flagrance par présomption peut résulter de :',
                ),
                options: [
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00059",
                    'Une rumeur',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00060",
                    'La clameur publique',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00061",
                    'Un simple soupçon',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00062",
                    'Un rapport anonyme',
                  ),
                ],
                answerIndex: 1,
              ),
            ],
          ),
        ),
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00063",
            'flagrance-procedure',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00064",
            'Procédure & durée',
          ),
          content:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00065",
                'Durée initiale : 8 jours sans discontinuer, prolongeable +8 jours sur décision PR.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00066",
                'Actes : constatations, perquisitions, saisies, auditions, GAV, réquisitions.',
              ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00067",
                  'Durée initiale d’une enquête de flagrance :',
                ),
                options: [
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00068",
                    '24 heures',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00069",
                    '8 jours',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00070",
                    '15 jours',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00071",
                    '48 heures',
                  ),
                ],
                answerIndex: 1,
              ),
            ],
          ),
        ),
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00072",
            'flagrance-gav',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00073",
            'Garde à vue — droit commun',
          ),
          content:
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00074",
                'Conditions : soupçon plausible, crime/délit puni d’emprisonnement, nécessité pour l’enquête.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00075",
                'Durée : 24h renouvelable 24h.\n',
              ) +
              ScolariteText.value(
                "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                "f00076",
                'Droits : information, avis proche/employeur, avocat, médecin, silence.',
              ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00077",
                  'Durée maximale de GAV sans prolongation :',
                ),
                options: [
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00078",
                    '48 heures',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00079",
                    '24 heures',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00080",
                    '72 heures',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00081",
                    '12 heures',
                  ),
                ],
                answerIndex: 1,
              ),
            ],
          ),
        ),
      ],
    ),
    _Section(
      id: 'prelim',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
        "f00082",
        'Enquête préliminaire',
      ),
      icon: Icons.search_rounded,
      chapters: [
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00083",
            'prelim-cadre',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00084",
            'Cadre & caractéristiques',
          ),
          content: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00085",
            'Ouverte par OPJ ou sur réquisition PR. Pas de délai légal maximum. Actes moins coercitifs qu’en flagrance. Contradictoire possible.',
          ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00086",
                  'L’enquête préliminaire :',
                ),
                options: [
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00087",
                    'Dure max 8 jours',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00088",
                    'N’a pas de durée maximale fixée',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00089",
                    'Dure max 6 mois',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00090",
                    'Est limitée à 48 heures',
                  ),
                ],
                answerIndex: 1,
              ),
            ],
          ),
        ),
      ],
    ),
    _Section(
      id: 'cr',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
        "f00091",
        'Commission rogatoire',
      ),
      icon: Icons.assignment_rounded,
      chapters: [
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00092",
            'cr-delegation',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00093",
            'Délégation d’enquête',
          ),
          content: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00094",
            'Délivrée par le juge d’instruction. OPJ commis pour actes déterminés, sous contrôle du juge. Respect strict du mandat.',
          ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00095",
                  'Qui délivre la commission rogatoire ?',
                ),
                options: [
                  'PR',
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00096",
                    'Juge d’instruction',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00097",
                    'OPJ en chef',
                  ),
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                    "f00098",
                    'Préfet',
                  ),
                ],
                answerIndex: 1,
              ),
            ],
          ),
        ),
      ],
    ),
    _Section(
      id: 'co',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
        "f00099",
        'Criminalité organisée',
      ),
      icon: Icons.security_rounded,
      chapters: [
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00100",
            'co-derog',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00101",
            'Mesures dérogatoires',
          ),
          content: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00102",
            'GAV jusqu’à 96h, perquisitions de nuit possibles, techniques spéciales (infiltration, surveillances).',
          ),
          quiz: _Quiz(
            questions: [
              _Question(
                q: ScolariteText.value(
                  "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
                  "f00103",
                  'Durée maximale de GAV en criminalité organisée :',
                ),
                options: ['24h', '48h', '96h', '72h'],
                answerIndex: 2,
              ),
            ],
          ),
        ),
      ],
    ),
    _Section(
      id: 'cas',
      title: ScolariteText.value(
        "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
        "f00104",
        'Cas particuliers',
      ),
      icon: Icons.cases_rounded,
      chapters: [
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00105",
            'cas-mci',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00106",
            'Mort cause inconnue',
          ),
          content: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00107",
            'Art. 74 et 80-4 CPP : enquête sur les causes, transport sur les lieux, constatations/réquisitions, autopsie si nécessaire.',
          ),
        ),
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00108",
            'cas-disparition',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00109",
            'Disparitions inquiétantes',
          ),
          content: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00110",
            'Art. 74-1 CPP : disparition flagrante et inquiétante, investigations immédiates, moyens adaptés.',
          ),
        ),
        _Chapter(
          id: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00111",
            'cas-grievement',
          ),
          title: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00112",
            'Personnes grièvement blessées',
          ),
          content: ScolariteText.value(
            "lib/content/gpx_scolarite/shared/procedure_penale_page.dart",
            "f00113",
            'Art. 74 al.6 CPP : cause inconnue/suspecte, constatations urgentes, préservation des preuves.',
          ),
        ),
      ],
    ),
  ];
}
