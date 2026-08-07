import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pa_exam_progress_calculator.dart';
import 'pa_exam_progress_models.dart';
import 'pa_exam_progress_service.dart';
import 'pa_exam_progress_source_registry.dart';

typedef ProgressModuleMetaResolver = PaProgressModuleMeta Function(String key);

class PaExamProgressPage extends StatefulWidget {
  const PaExamProgressPage({
    super.key,
    required this.onStart,
    this.dataSource,
    this.subtitle = 'Ta progression vers la sélection de Policier Adjoint',
    this.emptyMessage =
        'Termine un premier entraînement PA pour débloquer tes statistiques, ta régularité et tes recommandations.',
    this.moduleMetaResolver = paModuleMeta,
  });
  final VoidCallback onStart;
  final PaExamProgressDataSource? dataSource;
  final String subtitle;
  final String emptyMessage;
  final ProgressModuleMetaResolver moduleMetaResolver;

  @override
  State<PaExamProgressPage> createState() => _PaExamProgressPageState();
}

class _PaExamProgressPageState extends State<PaExamProgressPage> {
  late final PaExamProgressDataSource _service =
      widget.dataSource ?? PaExamProgressService();
  final _calculator = const PaExamProgressCalculator();
  PaProgressLoadResult? _result;
  PaProgressSnapshot? _cached;
  bool _refreshing = false;
  PaProgressPeriod _period = PaProgressPeriod.thirtyDays;
  PaProgressHistorySort _sort = PaProgressHistorySort.recent;
  int _historyLimit = 8;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    if (_refreshing) return;
    if (refresh) setState(() => _refreshing = true);
    final result = await _service.load();
    if (!mounted) return;
    setState(() {
      _result = result;
      if (result is PaProgressLoaded) _cached = result.snapshot;
      _refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    if (result == null && _cached == null) return const _ProgressSkeleton();
    if (result is PaProgressSignedOut) {
      return _ProgressState(
        icon: Icons.lock_outline_rounded,
        title: 'Connecte-toi pour suivre ta progression',
        message:
            'Tes résultats sont personnels et synchronisés avec ton compte COP’IQ.',
        action: 'Réessayer',
        onPressed: _load,
      );
    }
    if (result is PaProgressLoadFailure && _cached == null) {
      return _ProgressState(
        icon: Icons.cloud_off_rounded,
        title: 'Progression indisponible',
        message: result.message,
        action: 'Réessayer',
        onPressed: _load,
      );
    }
    final snapshot = result is PaProgressLoaded ? result.snapshot : _cached!;
    if (snapshot.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _load(refresh: true),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            _Header(
              onRefresh: () => _load(refresh: true),
              refreshing: _refreshing,
              subtitle: widget.subtitle,
            ),
            const SizedBox(height: 52),
            _EmptyProgress(
              onStart: widget.onStart,
              message: widget.emptyMessage,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _load(refresh: true),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxWidth < 360 ? 14.0 : 20.0;
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(horizontal, 16, horizontal, 120),
            children: [
              _Header(
                onRefresh: () => _load(refresh: true),
                refreshing: _refreshing,
                subtitle: widget.subtitle,
              ),
              if (snapshot.partialWarning != null) ...[
                const SizedBox(height: 12),
                _WarningBanner(snapshot.partialWarning!),
              ],
              const SizedBox(height: 18),
              _GlobalCard(snapshot: snapshot),
              const SizedBox(height: 12),
              _QuickStats(snapshot: snapshot),
              const SizedBox(height: 22),
              _SectionTitle(
                title: 'Objectif du jour',
                icon: Icons.flag_rounded,
              ),
              const SizedBox(height: 10),
              _DailyGoalCard(
                snapshot: snapshot,
                onEdit: () => _editGoal(snapshot.dailyGoal),
                onStart: widget.onStart,
              ),
              const SizedBox(height: 22),
              const _SectionTitle(
                title: 'Ma régularité',
                icon: Icons.calendar_month_rounded,
              ),
              const SizedBox(height: 10),
              _ActivityCalendar(days: snapshot.days),
              const SizedBox(height: 22),
              _SectionTitle(
                title: 'Mon évolution',
                icon: Icons.show_chart_rounded,
                trailing: _PeriodSelector(
                  value: _period,
                  onChanged: (value) => setState(() => _period = value),
                ),
              ),
              const SizedBox(height: 10),
              _TrendCard(
                points: _calculator.trendForPeriod(
                  snapshot.trend,
                  _period,
                  DateTime.now(),
                ),
                calculator: _calculator,
              ),
              const SizedBox(height: 22),
              const _SectionTitle(
                title: 'Mes matières',
                icon: Icons.grid_view_rounded,
              ),
              const SizedBox(height: 10),
              ...snapshot.subjects.map(
                (subject) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SubjectCard(
                    subject: subject,
                    onOpen: () => _openRoute(subject.route),
                    moduleMetaResolver: widget.moduleMetaResolver,
                  ),
                ),
              ),
              if (snapshot.recommendation case final recommendation?) ...[
                const SizedBox(height: 12),
                const _SectionTitle(
                  title: 'Priorité recommandée',
                  icon: Icons.auto_awesome_rounded,
                ),
                const SizedBox(height: 10),
                _RecommendationCard(
                  recommendation: recommendation,
                  onOpen: () => _openRoute(recommendation.subject.route),
                ),
              ],
              if (snapshot.placement case final placement?) ...[
                const SizedBox(height: 22),
                const _SectionTitle(
                  title: 'Depuis ton positionnement',
                  icon: Icons.workspace_premium_rounded,
                ),
                const SizedBox(height: 10),
                _PlacementCard(
                  placement: placement,
                  currentPercent: snapshot.globalPercent,
                ),
              ],
              if (snapshot.errors.isNotEmpty) ...[
                const SizedBox(height: 22),
                const _SectionTitle(
                  title: 'Axes à renforcer',
                  icon: Icons.school_rounded,
                ),
                const SizedBox(height: 10),
                _ErrorsCard(
                  errors: snapshot.errors.take(3).toList(),
                  moduleMetaResolver: widget.moduleMetaResolver,
                ),
              ],
              const SizedBox(height: 22),
              _SectionTitle(
                title: 'Activités récentes',
                icon: Icons.history_rounded,
                trailing: _HistorySort(
                  value: _sort,
                  onChanged: (value) => setState(() => _sort = value),
                ),
              ),
              const SizedBox(height: 10),
              ..._sorted(snapshot.activities)
                  .take(_historyLimit)
                  .map(
                    (activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ActivityTile(
                        activity: activity,
                        onOpen: () => _openRoute(activity.route),
                      ),
                    ),
                  ),
              if (_historyLimit < snapshot.activities.length)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    foregroundColor: const Color(0xFF175D86),
                    side: BorderSide(
                      color: const Color(0xFF175D86).withValues(alpha: .28),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: GoogleFonts.instrumentSans(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onPressed: () => setState(() => _historyLimit += 10),
                  child: const Text('Voir plus'),
                ),
            ],
          );
        },
      ),
    );
  }

  List<PaProgressActivity> _sorted(List<PaProgressActivity> source) {
    final values = [...source];
    switch (_sort) {
      case PaProgressHistorySort.recent:
        values.sort((a, b) => b.finishedAt.compareTo(a.finishedAt));
      case PaProgressHistorySort.best:
        values.sort((a, b) => b.percent.compareTo(a.percent));
      case PaProgressHistorySort.weakest:
        values.sort((a, b) => a.percent.compareTo(b.percent));
    }
    return values;
  }

  void _openRoute(String? route) {
    if (route == null || route.isEmpty) return;
    Navigator.of(context).pushNamed(route);
  }

  Future<void> _editGoal(int current) async {
    var selected = current;
    final value = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ton objectif quotidien',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$selected quiz par jour',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Slider(
                  value: selected.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '$selected',
                  onChanged: (v) => setSheetState(() => selected = v.round()),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  style: _primaryButtonStyle(context),
                  onPressed: () => Navigator.pop(context, selected),
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (value == null) return;
    await _service.saveDailyGoal(value);
    await _load(refresh: true);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onRefresh,
    required this.refreshing,
    required this.subtitle,
  });
  final VoidCallback onRefresh;
  final bool refreshing;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mon suivi',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: GoogleFonts.instrumentSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _muted(context),
              ),
            ),
          ],
        ),
      ),
      Semantics(
        button: true,
        label: 'Actualiser la progression',
        child: IconButton.filledTonal(
          onPressed: refreshing ? null : onRefresh,
          icon: refreshing
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh_rounded),
        ),
      ),
    ],
  );
}

class _GlobalCard extends StatelessWidget {
  const _GlobalCard({required this.snapshot});
  final PaProgressSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(snapshot.globalPercent);
    return _Card(
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 330;
          final score = Semantics(
            label:
                'Score global ${snapshot.globalPercent} pour cent, ${_scoreLabel(snapshot.globalPercent)}',
            child: SizedBox.square(
              dimension: compact ? 104 : 118,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: snapshot.globalPercent / 100,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: color.withValues(alpha: .12),
                    color: color,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${snapshot.globalPercent}%',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'global',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _muted(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progression générale',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _scoreLabel(snapshot.globalPercent),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${snapshot.activities.length} activités • ${snapshot.totalQuestions} questions',
                style: GoogleFonts.instrumentSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: _muted(context),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Dernière activité ${_ago(snapshot.activities.first.finishedAt)}',
                style: GoogleFonts.instrumentSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _muted(context),
                ),
              ),
            ],
          );
          return compact
              ? Column(
                  children: [
                    score,
                    const SizedBox(height: 14),
                    Align(alignment: Alignment.centerLeft, child: details),
                  ],
                )
              : Row(
                  children: [
                    score,
                    const SizedBox(width: 18),
                    Expanded(child: details),
                  ],
                );
        },
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.snapshot});
  final PaProgressSnapshot snapshot;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 650 ? 4 : 2;
      const gap = 10.0;
      final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
      final items = [
        (
          Icons.local_fire_department_rounded,
          '${snapshot.streakDays} j',
          'Série actuelle',
          const Color(0xFFF97316),
        ),
        (
          Icons.flag_rounded,
          '${snapshot.doneToday}/${snapshot.dailyGoal}',
          'Objectif du jour',
          const Color(0xFF2563EB),
        ),
        (
          Icons.date_range_rounded,
          '${snapshot.doneThisWeek}',
          'Cette semaine',
          const Color(0xFF7C3AED),
        ),
        (
          Icons.task_alt_rounded,
          '${snapshot.totalCorrect}',
          'Bonnes réponses',
          const Color(0xFF16A34A),
        ),
      ];
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: items
            .map(
              (item) => SizedBox(
                width: width,
                child: _StatCard(
                  icon: item.$1,
                  value: item.$2,
                  label: item.$3,
                  color: item.$4,
                ),
              ),
            )
            .toList(),
      );
    },
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => _Card(
    padding: const EdgeInsets.all(13),
    child: SizedBox(
      height: 82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.instrumentSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: _muted(context),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({
    required this.snapshot,
    required this.onEdit,
    required this.onStart,
  });
  final PaProgressSnapshot snapshot;
  final VoidCallback onEdit;
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) {
    final reached = snapshot.doneToday >= snapshot.dailyGoal;
    final progress = (snapshot.doneToday / snapshot.dailyGoal).clamp(0.0, 1.0);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reached
                      ? 'Objectif atteint, bravo !'
                      : '${snapshot.doneToday} quiz sur ${snapshot.dailyGoal}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                tooltip: 'Modifier l’objectif',
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Semantics(
            label:
                'Objectif quotidien atteint à ${(progress * 100).round()} pour cent',
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(99),
              color: reached
                  ? const Color(0xFF16A34A)
                  : const Color(0xFF2563EB),
              backgroundColor: const Color(0xFFE2E8F0),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: _primaryButtonStyle(context),
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                reached
                    ? 'Continuer sur ma lancée'
                    : 'Continuer ma préparation',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCalendar extends StatelessWidget {
  const _ActivityCalendar({required this.days});
  final List<PaProgressDay> days;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Les 28 derniers jours',
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = 6.0;
            final size = math.min(38.0, (constraints.maxWidth - gap * 6) / 7);
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: days.map((day) {
                final count = day.activityCount;
                final color = count == 0
                    ? Theme.of(context).dividerColor.withValues(alpha: .18)
                    : const Color(0xFF2563EB).withValues(
                        alpha: count == 1
                            ? .35
                            : count == 2
                            ? .65
                            : 1,
                      );
                return Semantics(
                  label:
                      '${day.day.day}/${day.day.month} : $count activité${count > 1 ? 's' : ''}',
                  child: Container(
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${day.day.day}',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: count >= 2 ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: const [
            _LegendDot(label: '0', alpha: .12),
            _LegendDot(label: '1', alpha: .35),
            _LegendDot(label: '2', alpha: .65),
            _LegendDot(label: '3+', alpha: 1),
          ],
        ),
      ],
    ),
  );
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.alpha});
  final String label;
  final double alpha;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withValues(alpha: alpha),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 5),
      Text(label),
    ],
  );
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.points, required this.calculator});
  final List<PaProgressTrendPoint> points;
  final PaExamProgressCalculator calculator;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (points.length >= 2)
          Semantics(
            label:
                'Graphique d’évolution de ${points.length} résultats, de ${points.first.percent} à ${points.last.percent} pour cent',
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: CustomPaint(
                painter: _TrendPainter(
                  points: points,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
          )
        else
          const SizedBox(
            height: 100,
            child: Center(
              child: Icon(
                Icons.query_stats_rounded,
                size: 40,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          calculator.trendMessage(points),
          style: GoogleFonts.instrumentSans(
            fontSize: 13,
            height: 1.4,
            fontWeight: FontWeight.w700,
            color: _muted(context),
          ),
        ),
      ],
    ),
  );
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.points, required this.color});
  final List<PaProgressTrendPoint> points;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = color.withValues(alpha: .10)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    if (points.length < 2) return;
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y =
          size.height - (points[i].percent.clamp(0, 100) / 100 * size.height);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.subject,
    required this.onOpen,
    required this.moduleMetaResolver,
  });
  final PaProgressSubject subject;
  final VoidCallback onOpen;
  final ProgressModuleMetaResolver moduleMetaResolver;
  @override
  Widget build(BuildContext context) {
    final meta = moduleMetaResolver(subject.key);
    final color = _scoreColor(subject.averagePercent);
    return _Card(
      onTap: onOpen,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: meta.color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(meta.icon, color: meta.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.label,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${subject.activities} activités • ${_ago(subject.lastActivityAt)}',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: _muted(context),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${subject.averagePercent}%',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: subject.averagePercent / 100,
            minHeight: 7,
            borderRadius: BorderRadius.circular(99),
            color: color,
            backgroundColor: color.withValues(alpha: .12),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text('Dernier ${subject.lastPercent}%', style: _caption(context)),
              const Spacer(),
              Text(
                'Meilleur ${subject.bestPercent}%',
                style: _caption(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.onOpen,
  });
  final PaProgressRecommendation recommendation;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => _Card(
    color: const Color(0xFF2563EB).withValues(
      alpha: Theme.of(context).brightness == Brightness.dark ? .15 : .06,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recommendation.subject.label,
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          recommendation.reason,
          style: GoogleFonts.instrumentSans(
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w700,
            color: _muted(context),
          ),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          style: _primaryButtonStyle(context, compact: true),
          onPressed: onOpen,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('M’entraîner maintenant'),
        ),
      ],
    ),
  );
}

class _PlacementCard extends StatelessWidget {
  const _PlacementCard({required this.placement, required this.currentPercent});
  final PaPlacementBaseline placement;
  final int currentPercent;
  @override
  Widget build(BuildContext context) {
    final delta = currentPercent - placement.percent;
    return _Card(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: .12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(
              '${placement.percent}%',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF7C3AED),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ton point de départ',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  delta >= 0
                      ? '+$delta points depuis ton positionnement'
                      : 'Écart actuel : $delta points',
                  style: GoogleFonts.instrumentSans(
                    fontWeight: FontWeight.w700,
                    color: delta >= 0
                        ? const Color(0xFF15803D)
                        : _muted(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorsCard extends StatelessWidget {
  const _ErrorsCard({required this.errors, required this.moduleMetaResolver});
  final List<PaProgressErrorSummary> errors;
  final ProgressModuleMetaResolver moduleMetaResolver;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      children: errors.map((error) {
        final rate = error.totalCount == 0
            ? 0
            : (error.wrongCount / error.totalCount * 100).round();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Icon(
                moduleMetaResolver(error.moduleKey).icon,
                color: const Color(0xFFDC2626),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  error.moduleLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${error.wrongCount} erreurs • $rate%',
                style: GoogleFonts.instrumentSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _muted(context),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity, required this.onOpen});
  final PaProgressActivity activity;
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(activity.percent);
    return _Card(
      onTap: onOpen,
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${activity.percent}%',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${activity.moduleLabel} • ${activity.correct}/${activity.total} • ${_ago(activity.finishedAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _muted(context),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon, this.trailing});
  final String title;
  final IconData icon;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 21, color: const Color(0xFF2563EB)),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w900),
        ),
      ),
      if (trailing != null) trailing!,
    ],
  );
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.value, required this.onChanged});
  final PaProgressPeriod value;
  final ValueChanged<PaProgressPeriod> onChanged;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Choisir la période du graphique',
    child: _FilterChip(
      label: switch (value) {
        PaProgressPeriod.sevenDays => '7 jours',
        PaProgressPeriod.thirtyDays => '30 jours',
        PaProgressPeriod.all => 'Tout',
      },
      onTap: () async {
        final selected = await _showPremiumPicker<PaProgressPeriod>(
          context,
          title: 'Période d’analyse',
          subtitle: 'Adapte la courbe à la période que tu veux comparer.',
          selected: value,
          options: const [
            _PickerOption(
              PaProgressPeriod.sevenDays,
              '7 derniers jours',
              Icons.bolt_rounded,
            ),
            _PickerOption(
              PaProgressPeriod.thirtyDays,
              '30 derniers jours',
              Icons.calendar_view_month_rounded,
            ),
            _PickerOption(
              PaProgressPeriod.all,
              'Depuis le début',
              Icons.all_inclusive_rounded,
            ),
          ],
        );
        if (selected != null) onChanged(selected);
      },
    ),
  );
}

class _HistorySort extends StatelessWidget {
  const _HistorySort({required this.value, required this.onChanged});
  final PaProgressHistorySort value;
  final ValueChanged<PaProgressHistorySort> onChanged;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Trier les activités récentes',
    child: _FilterChip(
      label: switch (value) {
        PaProgressHistorySort.recent => 'Récentes',
        PaProgressHistorySort.best => 'Meilleurs scores',
        PaProgressHistorySort.weakest => 'À renforcer',
      },
      icon: Icons.swap_vert_rounded,
      onTap: () async {
        final selected = await _showPremiumPicker<PaProgressHistorySort>(
          context,
          title: 'Trier les activités',
          subtitle: 'Choisis l’ordre qui t’aide le mieux à progresser.',
          selected: value,
          options: const [
            _PickerOption(
              PaProgressHistorySort.recent,
              'Plus récentes',
              Icons.schedule_rounded,
            ),
            _PickerOption(
              PaProgressHistorySort.best,
              'Meilleurs scores',
              Icons.workspace_premium_rounded,
            ),
            _PickerOption(
              PaProgressHistorySort.weakest,
              'Priorités à renforcer',
              Icons.trending_up_rounded,
            ),
          ],
        );
        if (selected != null) onChanged(selected);
      },
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onTap, this.icon});
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: .72),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: .28),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.calendar_today_rounded,
              size: 16,
              color: const Color(0xFF2563EB),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ),
      ),
    ),
  );
}

class _PickerOption<T> {
  const _PickerOption(this.value, this.label, this.icon);
  final T value;
  final String label;
  final IconData icon;
}

Future<T?> _showPremiumPicker<T>(
  BuildContext context, {
  required String title,
  required String subtitle,
  required T selected,
  required List<_PickerOption<T>> options,
}) => showModalBottomSheet<T>(
  context: context,
  useSafeArea: true,
  showDragHandle: false,
  backgroundColor: Colors.transparent,
  barrierColor: Colors.black.withValues(alpha: .38),
  builder: (sheetContext) {
    final theme = Theme.of(sheetContext);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.dividerColor.withValues(alpha: .24)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: .55),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.instrumentSans(
              fontSize: 13.5,
              height: 1.35,
              fontWeight: FontWeight.w600,
              color: _muted(sheetContext),
            ),
          ),
          const SizedBox(height: 18),
          ...options.map((option) {
            final active = option.value == selected;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Semantics(
                selected: active,
                button: true,
                child: Material(
                  color: active
                      ? const Color(0xFF2563EB).withValues(alpha: .10)
                      : theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: .44,
                        ),
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: () => Navigator.pop(sheetContext, option.value),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 58),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: active
                              ? const Color(0xFF2563EB).withValues(alpha: .35)
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF2563EB)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              option.icon,
                              size: 20,
                              color: active
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option.label,
                              style: GoogleFonts.instrumentSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: active
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    key: ValueKey('selected'),
                                    color: Color(0xFF2563EB),
                                  )
                                : const Icon(
                                    Icons.chevron_right_rounded,
                                    key: ValueKey('idle'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  },
);

ButtonStyle _primaryButtonStyle(BuildContext context, {bool compact = false}) =>
    FilledButton.styleFrom(
      minimumSize: Size(compact ? 0 : double.infinity, compact ? 44 : 50),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 18 : 22,
        vertical: compact ? 11 : 14,
      ),
      backgroundColor: const Color(0xFF175D86),
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFF175D86).withValues(alpha: .35),
      textStyle: GoogleFonts.instrumentSans(
        fontSize: compact ? 13.5 : 15,
        fontWeight: FontWeight.w800,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    );

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: .12),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner(this.message);
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF59E0B).withValues(alpha: .12),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline_rounded, color: Color(0xFFB45309)),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.instrumentSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _EmptyProgress extends StatelessWidget {
  const _EmptyProgress({required this.onStart, required this.message});
  final VoidCallback onStart;
  final String message;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withValues(alpha: .10),
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Icon(
          Icons.insights_rounded,
          size: 42,
          color: Color(0xFF2563EB),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        'Commence ta progression',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 8),
      Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.instrumentSans(
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w600,
          color: _muted(context),
        ),
      ),
      const SizedBox(height: 22),
      FilledButton.icon(
        style: _primaryButtonStyle(context),
        onPressed: onStart,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('Commencer un entraînement'),
      ),
    ],
  );
}

class _ProgressState extends StatelessWidget {
  const _ProgressState({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String message;
  final String action;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 90, 24, 120),
    children: [
      Icon(icon, size: 58, color: const Color(0xFF64748B)),
      const SizedBox(height: 18),
      Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 8),
      Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.instrumentSans(
          fontSize: 14,
          height: 1.45,
          color: _muted(context),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: SizedBox(
          width: 220,
          child: FilledButton(
            style: _primaryButtonStyle(context),
            onPressed: onPressed,
            child: Text(action),
          ),
        ),
      ),
    ],
  );
}

class _ProgressSkeleton extends StatelessWidget {
  const _ProgressSkeleton();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
    children: const [
      _Skeleton(height: 55),
      SizedBox(height: 18),
      _Skeleton(height: 154),
      SizedBox(height: 12),
      Row(
        children: [
          Expanded(child: _Skeleton(height: 108)),
          SizedBox(width: 10),
          Expanded(child: _Skeleton(height: 108)),
        ],
      ),
      SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _Skeleton(height: 108)),
          SizedBox(width: 10),
          Expanded(child: _Skeleton(height: 108)),
        ],
      ),
      SizedBox(height: 22),
      _Skeleton(height: 150),
      SizedBox(height: 12),
      _Skeleton(height: 220),
    ],
  );
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.height});
  final double height;
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: Theme.of(context).dividerColor.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

Color _muted(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: .62);
TextStyle _caption(BuildContext context) => GoogleFonts.instrumentSans(
  fontSize: 11.5,
  fontWeight: FontWeight.w700,
  color: _muted(context),
);
Color _scoreColor(int value) => value >= 80
    ? const Color(0xFF16A34A)
    : value >= 60
    ? const Color(0xFF2563EB)
    : value >= 40
    ? const Color(0xFFF59E0B)
    : const Color(0xFFDC2626);
String _scoreLabel(int value) => value >= 90
    ? 'Excellente maîtrise'
    : value >= 75
    ? 'Bonne maîtrise'
    : value >= 60
    ? 'Niveau encourageant'
    : value >= 40
    ? 'En progression'
    : 'Bases à renforcer';
String _ago(DateTime value) {
  final difference = DateTime.now().difference(value);
  if (difference.inMinutes < 2) return 'à l’instant';
  if (difference.inHours < 1) return 'il y a ${difference.inMinutes} min';
  if (difference.inDays < 1) return 'il y a ${difference.inHours} h';
  if (difference.inDays < 7) return 'il y a ${difference.inDays} j';
  return 'le ${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
