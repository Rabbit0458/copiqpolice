import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:copiqpolice/core/services/quiz_history_service.dart';

/// ----------------------------
/// Helpers (score + labels)
/// ----------------------------
Color scoreColor(BuildContext context, int percent) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  if (percent >= 80) {
    return isDark ? const Color(0xFF37D67A) : const Color(0xFF17A34A); // vert
  }
  if (percent >= 50) {
    return isDark ? const Color(0xFFFFB020) : const Color(0xFFF59E0B); // orange
  }
  return isDark ? const Color(0xFFFF5A6A) : const Color(0xFFEF4444); // rouge
}

String scoreLabel(int percent) {
  if (percent >= 80) return 'Excellent';
  if (percent >= 50) return 'Correct';
  return 'À revoir';
}

/// ----------------------------
/// UI constants
/// ----------------------------
const double kRadiusLg = 22;
const double kRadiusMd = 18;
const double kPillRadius = 999;

enum DetailsSection { overview, themes, history }

enum HistorySort { recent, best, worst }

/// ----------------------------
/// Page
/// ----------------------------
class DetailsPage extends StatefulWidget {
  final String uid;
  const DetailsPage({super.key, required this.uid});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final QuizHistoryService service;
  late Future<List<QuizAttempt>> _future;

  DetailsSection _section = DetailsSection.overview;
  HistorySort _sort = HistorySort.recent;

  bool _historyExpanded = false;
  static const int _historyPreviewCount = 10;

  @override
  void initState() {
    super.initState();
    service = QuizHistoryService(Supabase.instance.client);
    _future = service.fetchAttempts(uid: widget.uid);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = service.fetchAttempts(uid: widget.uid);
    });
    await _future;
  }

  String _ago(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'à l’instant';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    if (diff.inDays < 7) return '${diff.inDays} j';
    final weeks = (diff.inDays / 7).floor();
    return '${weeks} sem';
  }

  List<QuizAttempt> _sortedAttempts(List<QuizAttempt> attempts) {
    final list = [...attempts];

    int dateMs(QuizAttempt a) =>
        (a.finishedAt ??
                a.completedAt ??
                DateTime.fromMillisecondsSinceEpoch(0))
            .millisecondsSinceEpoch;

    switch (_sort) {
      case HistorySort.recent:
        list.sort((a, b) => dateMs(b).compareTo(dateMs(a)));
        return list;
      case HistorySort.best:
        list.sort((a, b) => b.percent.compareTo(a.percent));
        // Tie-breaker: most recent
        list.sort((a, b) {
          final p = b.percent.compareTo(a.percent);
          if (p != 0) return p;
          return dateMs(b).compareTo(dateMs(a));
        });
        return list;
      case HistorySort.worst:
        list.sort((a, b) => a.percent.compareTo(b.percent));
        // Tie-breaker: most recent
        list.sort((a, b) {
          final p = a.percent.compareTo(b.percent);
          if (p != 0) return p;
          return dateMs(b).compareTo(dateMs(a));
        });
        return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails de progression',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w900),
        ),
      ),
      body: FutureBuilder<List<QuizAttempt>>(
        future: _future,
        builder: (context, snap) {
          // Loading skeleton
          if (snap.connectionState != ConnectionState.done) {
            return const _SkeletonDetails();
          }

          // Error state
          if (snap.hasError) {
            return _StateCard(
              icon: Icons.error_outline_rounded,
              title: 'Oups, une erreur est survenue',
              subtitle: '${snap.error}',
              actionLabel: 'Réessayer',
              onAction: _refresh,
            );
          }

          final attempts = snap.data ?? [];

          // Empty state
          if (attempts.isEmpty) {
            return _StateCard(
              icon: Icons.inbox_rounded,
              title: 'Aucun quiz terminé',
              subtitle:
                  'Termine un premier quiz pour voir ta progression et ton historique ici.',
              actionLabel: 'Actualiser',
              onAction: _refresh,
            );
          }

          final global = service.globalPercent(attempts);
          final themes = service.aggregateByTheme(attempts);

          final sortedHistory = _sortedAttempts(attempts);
          final historyVisible = _historyExpanded
              ? sortedHistory
              : sortedHistory.take(_historyPreviewCount).toList();
          final canExpandHistory = sortedHistory.length > _historyPreviewCount;

          final lastAttemptDt = sortedHistory.isNotEmpty
              ? (sortedHistory.first.finishedAt ??
                    sortedHistory.first.completedAt)
              : null;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              children: [
                // Hero / dashboard
                _GlobalHeaderCard(
                  globalPercent: global,
                  totalAttempts: attempts.length,
                  lastAgo: _ago(lastAttemptDt),
                ),
                const SizedBox(height: 12),

                // Section selector (Overview / Themes / History)
                _SectionChips(
                  value: _section,
                  onChanged: (v) => setState(() => _section = v),
                ),
                const SizedBox(height: 12),

                if (_section == DetailsSection.overview) ...[
                  // Overview = themes summary + history preview
                  _SectionTitle('Par thème'),
                  const SizedBox(height: 10),
                  ...themes.map(
                    (th) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ThemeCard(
                        theme: th.theme,
                        avg: th.averagePercent,
                        best: th.bestPercent,
                        count: th.attemptsCount,
                        lastAgo: _ago(th.lastFinishedAt),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('Historique'),
                  const SizedBox(height: 10),
                  _HistorySortRow(
                    value: _sort,
                    onChanged: (s) => setState(() => _sort = s),
                  ),
                  const SizedBox(height: 10),
                  ...historyVisible.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AttemptRow(
                        theme: a.theme,
                        percent: a.percent,
                        correct: a.correctCount,
                        total: a.totalQuestions,
                        ago: _ago(a.finishedAt ?? a.completedAt),
                      ),
                    ),
                  ),
                  if (canExpandHistory) ...[
                    const SizedBox(height: 2),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => setState(
                          () => _historyExpanded = !_historyExpanded,
                        ),
                        icon: Icon(
                          _historyExpanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: t.muted,
                        ),
                        label: Text(
                          _historyExpanded ? 'Afficher moins' : 'Afficher tout',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            color: t.muted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],

                if (_section == DetailsSection.themes) ...[
                  _SectionTitle('Par thème'),
                  const SizedBox(height: 10),
                  ...themes.map(
                    (th) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ThemeCard(
                        theme: th.theme,
                        avg: th.averagePercent,
                        best: th.bestPercent,
                        count: th.attemptsCount,
                        lastAgo: _ago(th.lastFinishedAt),
                      ),
                    ),
                  ),
                ],

                if (_section == DetailsSection.history) ...[
                  _SectionTitle('Historique complet'),
                  const SizedBox(height: 10),
                  _HistorySortRow(
                    value: _sort,
                    onChanged: (s) => setState(() => _sort = s),
                  ),
                  const SizedBox(height: 10),
                  ...sortedHistory.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AttemptRow(
                        theme: a.theme,
                        percent: a.percent,
                        correct: a.correctCount,
                        total: a.totalQuestions,
                        ago: _ago(a.finishedAt ?? a.completedAt),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InlineHint(
                    text:
                        'Astuce : tire vers le bas pour actualiser tes stats.',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ----------------------------
/// Design tokens (local)
/// ----------------------------
class _UiTokens {
  final bool isDark;
  final Color ink;
  final Color muted;
  final Color bgCard;
  final Color border;
  final Color track;

  _UiTokens({
    required this.isDark,
    required this.ink,
    required this.muted,
    required this.bgCard,
    required this.border,
    required this.track,
  });

  static _UiTokens of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? Colors.white : const Color(0xFF111111);
    final muted = ink.withValues(alpha: .62);
    final bgCard = isDark
        ? Colors.white.withValues(alpha: .09)
        : Colors.black.withValues(alpha: .045);
    final border = ink.withValues(alpha: isDark ? .12 : .10);
    final track = ink.withValues(alpha: isDark ? .14 : .10);

    return _UiTokens(
      isDark: isDark,
      ink: ink,
      muted: muted,
      bgCard: bgCard,
      border: border,
      track: track,
    );
  }
}

/// ----------------------------
/// Reusable UI pieces
/// ----------------------------
class _AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? glowColor;
  final bool glow;

  const _AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = kRadiusLg,
    this.glowColor,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    final c = glowColor;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: t.bgCard,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: t.border),
        boxShadow: [
          if (glow && c != null)
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: c.withValues(alpha: t.isDark ? .12 : .10),
            ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w900,
        fontSize: 14,
        color: t.ink,
      ),
    );
  }
}

class _InlineHint extends StatelessWidget {
  final String text;
  const _InlineHint({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        color: t.muted,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// ----------------------------
/// State cards (empty/error)
/// ----------------------------
class _StateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final Future<void> Function() onAction;

  const _StateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        _AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: t.muted),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  color: t.ink,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: t.muted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () => onAction(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    actionLabel,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ----------------------------
/// Section chips
/// ----------------------------
class _SectionChips extends StatelessWidget {
  final DetailsSection value;
  final ValueChanged<DetailsSection> onChanged;

  const _SectionChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);

    Widget chip(DetailsSection v, String label, IconData icon) {
      final selected = value == v;
      return ChoiceChip(
        selected: selected,
        onSelected: (_) => onChanged(v),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: selected ? t.ink : t.muted,
          ),
        ),
        avatar: Icon(icon, size: 18, color: selected ? t.ink : t.muted),
        backgroundColor: t.bgCard,
        selectedColor: t.bgCard,
        side: BorderSide(color: t.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPillRadius),
        ),
        visualDensity: VisualDensity.compact,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip(
          DetailsSection.overview,
          'Vue d’ensemble',
          Icons.dashboard_rounded,
        ),
        chip(DetailsSection.themes, 'Thèmes', Icons.category_rounded),
        chip(DetailsSection.history, 'Historique', Icons.history_rounded),
      ],
    );
  }
}

/// ----------------------------
/// Sort row
/// ----------------------------
class _HistorySortRow extends StatelessWidget {
  final HistorySort value;
  final ValueChanged<HistorySort> onChanged;

  const _HistorySortRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);

    Widget pill(HistorySort s, String label, IconData icon) {
      final selected = value == s;
      return ChoiceChip(
        selected: selected,
        onSelected: (_) => onChanged(s),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: selected ? t.ink : t.muted,
          ),
        ),
        avatar: Icon(icon, size: 18, color: selected ? t.ink : t.muted),
        backgroundColor: t.bgCard,
        selectedColor: t.bgCard,
        side: BorderSide(color: t.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPillRadius),
        ),
        visualDensity: VisualDensity.compact,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        pill(HistorySort.recent, 'Récent', Icons.schedule_rounded),
        pill(HistorySort.best, 'Meilleur', Icons.trending_up_rounded),
        pill(HistorySort.worst, 'À revoir', Icons.trending_down_rounded),
      ],
    );
  }
}

/// ----------------------------
/// Global Header Card (upgraded)
/// ----------------------------
class _GlobalHeaderCard extends StatelessWidget {
  final int globalPercent;
  final int totalAttempts;
  final String lastAgo;

  const _GlobalHeaderCard({
    required this.globalPercent,
    required this.totalAttempts,
    required this.lastAgo,
  });

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    final c = scoreColor(context, globalPercent);

    return _AppCard(
      radius: kRadiusLg,
      glow: globalPercent >= 80,
      glowColor: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note générale',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              color: t.ink,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Big % badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: t.isDark ? .14 : .10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.withValues(alpha: .30)),
                ),
                child: Text(
                  '$globalPercent%',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: c,
                    fontSize: 18,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProgressBar(
                      value: (globalPercent / 100).clamp(0.0, 1.0),
                      color: c,
                      height: 10,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _StatusChip(percent: globalPercent),
                        Text(
                          '$totalAttempts quiz terminés',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: t.muted,
                            fontSize: 12,
                          ),
                        ),
                        if (lastAgo.isNotEmpty)
                          Text(
                            '• Dernier : $lastAgo',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: t.muted,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;

  const _ProgressBar({
    required this.value,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(kPillRadius),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: t.track,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final int percent;
  const _StatusChip({required this.percent});

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    final c = scoreColor(context, percent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: t.isDark ? .14 : .10),
        borderRadius: BorderRadius.circular(kPillRadius),
        border: Border.all(color: c.withValues(alpha: .25)),
      ),
      child: Text(
        scoreLabel(percent),
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w900,
          color: c,
          fontSize: 12,
          height: 1,
        ),
      ),
    );
  }
}

/// ----------------------------
/// Theme card (with icon + cleaner pills)
/// ----------------------------
class _ThemeCard extends StatelessWidget {
  final String theme;
  final int avg;
  final int best;
  final int count;
  final String lastAgo;

  const _ThemeCard({
    required this.theme,
    required this.avg,
    required this.best,
    required this.count,
    required this.lastAgo,
  });

  IconData _iconForTheme(String t) {
    final s = t.toLowerCase();

    if (s.contains('histoire')) return Icons.account_balance_rounded;
    if (s.contains('déont') || s.contains('deont')) return Icons.gavel_rounded;
    if (s.contains('hiér') || s.contains('hier')) return Icons.groups_rounded;
    if (s.contains('proc')) return Icons.description_rounded;
    if (s.contains('code')) return Icons.policy_rounded;
    if (s.contains('sec')) return Icons.security_rounded;

    return Icons.book_rounded;
    // (Tu peux enrichir le mapping facilement)
  }

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    final cAvg = scoreColor(context, avg);

    return _AppCard(
      padding: const EdgeInsets.all(12),
      radius: kRadiusMd,
      glow: avg >= 80,
      glowColor: cAvg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon bubble
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: t.ink.withValues(alpha: t.isDark ? .06 : .04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: t.border),
                ),
                child: Icon(_iconForTheme(theme), color: t.muted),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  theme,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: t.ink,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ProgressBar(
            value: (avg / 100).clamp(0.0, 1.0),
            color: cAvg,
            height: 8,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniPill(label: 'Moy.', value: '$avg%', color: cAvg),
              const SizedBox(width: 8),
              _MiniPill(
                label: 'Best',
                value: '$best%',
                color: scoreColor(context, best),
              ),
              const Spacer(),
              Text(
                '$count quiz${lastAgo.isNotEmpty ? ' • $lastAgo' : ''}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: t.muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: t.isDark ? .14 : .10),
        borderRadius: BorderRadius.circular(kPillRadius),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Text(
        '$label $value',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w900,
          color: color,
          fontSize: 12,
          height: 1,
        ),
      ),
    );
  }
}

/// ----------------------------
/// Attempt row (polished)
/// ----------------------------
class _AttemptRow extends StatelessWidget {
  final String theme;
  final int percent;
  final int correct;
  final int total;
  final String ago;

  const _AttemptRow({
    required this.theme,
    required this.percent,
    required this.correct,
    required this.total,
    required this.ago,
  });

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    final c = scoreColor(context, percent);

    return _AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      radius: kRadiusMd,
      glow: percent >= 80,
      glowColor: c,
      child: Row(
        children: [
          // % badge
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: c.withValues(alpha: t.isDark ? .16 : .12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.withValues(alpha: .30)),
            ),
            child: Center(
              child: Text(
                '$percent%',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  color: c,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  theme,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: t.ink,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),

                _ProgressBar(
                  value: (percent / 100).clamp(0.0, 1.0),
                  color: c,
                  height: 6,
                ),

                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '$correct / $total',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: t.muted,
                        fontSize: 12,
                      ),
                    ),
                    if (ago.isNotEmpty)
                      Text(
                        '• $ago',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: t.muted,
                          fontSize: 12,
                        ),
                      ),
                    Text(
                      '• ${scoreLabel(percent)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: t.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: t.muted),
        ],
      ),
    );
  }
}

/// ----------------------------
/// Skeleton loading (no dependency)
/// ----------------------------
class _SkeletonDetails extends StatelessWidget {
  const _SkeletonDetails();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: const [
        _SkeletonCard(height: 110, radius: kRadiusLg),
        SizedBox(height: 12),
        _SkeletonRowChips(),
        SizedBox(height: 12),
        _SkeletonCard(height: 92, radius: kRadiusMd),
        SizedBox(height: 10),
        _SkeletonCard(height: 92, radius: kRadiusMd),
        SizedBox(height: 10),
        _SkeletonCard(height: 92, radius: kRadiusMd),
        SizedBox(height: 16),
        _SkeletonCard(height: 86, radius: kRadiusMd),
        SizedBox(height: 10),
        _SkeletonCard(height: 86, radius: kRadiusMd),
      ],
    );
  }
}

class _SkeletonRowChips extends StatelessWidget {
  const _SkeletonRowChips();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _SkeletonPill()),
        SizedBox(width: 8),
        Expanded(child: _SkeletonPill()),
        SizedBox(width: 8),
        Expanded(child: _SkeletonPill()),
      ],
    );
  }
}

class _SkeletonPill extends StatelessWidget {
  const _SkeletonPill();

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: t.ink.withValues(alpha: t.isDark ? .07 : .05),
        borderRadius: BorderRadius.circular(kPillRadius),
        border: Border.all(color: t.border),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double height;
  final double radius;

  const _SkeletonCard({required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    final t = _UiTokens.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: t.ink.withValues(alpha: t.isDark ? .07 : .05),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: t.border),
      ),
    );
  }
}
