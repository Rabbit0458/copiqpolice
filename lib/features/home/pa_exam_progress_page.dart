import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/learning_answer_history_service.dart';
import '../../core/services/notifications_service.dart';

import 'copiq_coach_engine.dart';
import 'copiq_coach_preferences_service.dart';
import 'official_competition_calendar_service.dart';
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
    this.coachTrack = 'pa',
  });
  final VoidCallback onStart;
  final PaExamProgressDataSource? dataSource;
  final String subtitle;
  final String emptyMessage;
  final ProgressModuleMetaResolver moduleMetaResolver;
  final String coachTrack;

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
  final _coach = const CopiqCoachEngine();

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
              const _SectionTitle(
                title: 'Coach COP’IQ',
                icon: Icons.psychology_alt_rounded,
              ),
              const SizedBox(height: 10),
              _CoachCard(
                plan: _coach.build(snapshot, DateTime.now()),
                onCorrectErrors: () => _openErrorTraining(snapshot),
                onDashboard: () => _openCoachDashboard(snapshot),
                onPriority: () => _openRoute(
                  _coach.build(snapshot, DateTime.now()).priority?.route,
                ),
              ),
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
              if (snapshot.wrongAnswerHistory.isNotEmpty) ...[
                const SizedBox(height: 22),
                const _SectionTitle(
                  title: "Mon carnet d'erreurs",
                  icon: Icons.fact_check_rounded,
                ),
                const SizedBox(height: 6),
                Text(
                  'Retrouve tes erreurs, comprends la correction et révise la notion associée.',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: _muted(context),
                  ),
                ),
                const SizedBox(height: 10),
                ..._errorEntries(snapshot)
                    .take(5)
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ErrorNotebookTile(
                          entry: entry,
                          onReviewModule: () =>
                              _openRoute(entry.activity.route),
                        ),
                      ),
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

  List<_ErrorNotebookEntry> _errorEntries(PaProgressSnapshot snapshot) {
    final entries = <_ErrorNotebookEntry>[];
    for (final activity in snapshot.activities) {
      for (final answer in activity.answers) {
        if (!answer.isCorrect) {
          entries.add(_ErrorNotebookEntry(activity: activity, answer: answer));
        }
      }
    }
    entries.sort(
      (a, b) => (b.answer.answeredAt ?? b.activity.finishedAt).compareTo(
        a.answer.answeredAt ?? a.activity.finishedAt,
      ),
    );
    return entries;
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

  Future<void> _openErrorTraining(PaProgressSnapshot snapshot) async {
    final entries = _errorEntries(snapshot);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: .88,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
            children: [
              Text(
                'Corriger mes erreurs',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Une séance personnalisée construite avec tes réponses réelles.',
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w700,
                  color: _muted(context),
                ),
              ),
              const SizedBox(height: 18),
              if (entries.isEmpty)
                const _Card(
                  child: Text('Aucune erreur à réviser pour le moment.'),
                )
              else
                ...entries
                    .take(20)
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ErrorNotebookTile(
                          entry: entry,
                          onReviewModule: () {
                            Navigator.pop(context);
                            _openRoute(entry.activity.route);
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openCoachDashboard(PaProgressSnapshot snapshot) async {
    final plan = _coach.build(snapshot, DateTime.now());
    final preferences = CopiqCoachPreferencesService();
    DateTime? targetDate;
    List<OfficialCompetitionEvent> officialDates = const [];
    try {
      targetDate = await preferences.loadTargetExamDate();
      officialDates = await OfficialCompetitionCalendarService().load(
        widget.coachTrack,
      );
      await preferences.saveWeeklySummary({
        'questions': plan.weekly.questions,
        'active_days': plan.weekly.activeDays,
        'delta': plan.weekly.delta,
        'readiness': plan.readiness.score,
      });
    } catch (_) {}
    if (!mounted) return;
    var query = '';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final searchable = snapshot.activities
              .expand(
                (activity) =>
                    activity.answers.map((answer) => (activity, answer)),
              )
              .where((entry) {
                final needle = query.trim().toLowerCase();
                return needle.isEmpty ||
                    entry.$2.question.toLowerCase().contains(needle) ||
                    entry.$1.moduleLabel.toLowerCase().contains(needle);
              })
              .take(12)
              .toList();
          return SafeArea(
            child: FractionallySizedBox(
              heightFactor: .94,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  Text(
                    'Mon Coach COP’IQ',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Un diagnostic explicable construit uniquement avec ton historique.',
                    style: GoogleFonts.instrumentSans(
                      fontWeight: FontWeight.w700,
                      color: _muted(context),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ReadinessCard(readiness: plan.readiness),
                  const SizedBox(height: 12),
                  _CoachDashboardSection(
                    title: 'Mon concours',
                    icon: Icons.event_available_rounded,
                    children: [
                      Text(
                        targetDate == null
                            ? 'Indique ta date pour adapter le rythme de préparation.'
                            : 'J-${targetDate!.difference(DateTime.now()).inDays.clamp(0, 9999)} avant ton concours.',
                        style: _coachBody(context),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () async {
                            final selected = await showDatePicker(
                              context: context,
                              initialDate:
                                  targetDate ??
                                  DateTime.now().add(const Duration(days: 90)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 1460),
                              ),
                            );
                            if (selected == null) return;
                            await preferences.saveTargetExamDate(selected);
                            setSheetState(() => targetDate = selected);
                          },
                          icon: const Icon(Icons.edit_calendar_rounded),
                          label: const Text('Définir la date'),
                        ),
                      ),
                      if (officialDates.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () async {
                              final selected =
                                  await _selectOfficialCompetitionDate(
                                    officialDates,
                                  );
                              if (selected == null) return;
                              await preferences.saveTargetExamDate(selected);
                              setSheetState(() => targetDate = selected);
                            },
                            icon: const Icon(Icons.verified_rounded),
                            label: const Text(
                              'Choisir une date officielle Police nationale',
                            ),
                          ),
                        ),
                      if (officialDates.isNotEmpty)
                        Text(
                          'Calendrier officiel synchronisé chaque jour. Dates prévisionnelles susceptibles d’être modifiées.',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: _muted(context),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _CoachDashboardSection(
                    title: 'Bilan de la semaine',
                    icon: Icons.calendar_view_week_rounded,
                    children: [
                      Text(
                        '${plan.weekly.questions} questions · ${plan.weekly.activeDays} jours actifs · évolution ${plan.weekly.delta >= 0 ? '+' : ''}${plan.weekly.delta} points',
                        style: _coachBody(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _CoachDashboardSection(
                    title: 'Plan de préparation',
                    icon: Icons.route_rounded,
                    children: [
                      Text(
                        _planningText(snapshot, plan, targetDate),
                        style: _coachBody(context),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Temps enregistré : ${_durationLabel(snapshot.totalDurationSeconds)} · projection à 30 jours : ${_forecast(plan.readiness.score, plan.weekly.delta)} %',
                        style: _coachBody(context),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () async {
                            final allowed = await NotificationsService.I
                                .requestPermissions();
                            if (!allowed) return;
                            await NotificationsService.I.scheduleDailyReminder(
                              title: 'Ton Coach COP’IQ a préparé ta priorité',
                              body:
                                  '${plan.minutes} min aujourd’hui : ${plan.priority?.label ?? 'consolider tes acquis'}.',
                            );
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Rappel personnalisé activé chaque jour à 19 h.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_active_rounded),
                          label: const Text('Activer mon rappel intelligent'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _CoachDashboardSection(
                    title: 'Diagnostic de mes erreurs',
                    icon: Icons.manage_search_rounded,
                    children: plan.causes.entries.isEmpty
                        ? [
                            Text(
                              'Pas encore assez d’erreurs détaillées.',
                              style: _coachBody(context),
                            ),
                          ]
                        : plan.causes.entries
                              .map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    '${_causeLabel(entry.key)} · ${entry.value}',
                                    style: _coachBody(context),
                                  ),
                                ),
                              )
                              .toList(),
                  ),
                  const SizedBox(height: 12),
                  _CoachDashboardSection(
                    title: 'Risque d’oubli',
                    icon: Icons.restore_rounded,
                    children: [
                      Text(
                        plan.forgettingRisks.isEmpty
                            ? 'Aucune notion ancienne à rafraîchir actuellement.'
                            : '${plan.forgettingRisks.length} notion${plan.forgettingRisks.length > 1 ? 's' : ''} maîtrisée${plan.forgettingRisks.length > 1 ? 's' : ''} à revoir prochainement.',
                        style: _coachBody(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _CoachDashboardSection(
                    title: 'Mes pièges récurrents',
                    icon: Icons.warning_amber_rounded,
                    children: plan.recurringQuestions.isEmpty
                        ? [
                            Text(
                              'Aucun piège récurrent détecté.',
                              style: _coachBody(context),
                            ),
                          ]
                        : plan.recurringQuestions
                              .map(
                                (answer) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    answer.question,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    'Bonne réponse : ${answer.correctAnswer}',
                                  ),
                                ),
                              )
                              .toList(),
                  ),
                  const SizedBox(height: 12),
                  _CoachDashboardSection(
                    title: 'Fiches créées depuis mes erreurs',
                    icon: Icons.style_rounded,
                    children: snapshot.wrongAnswerHistory.isEmpty
                        ? [
                            Text(
                              'Les fiches apparaîtront après tes premières réponses.',
                              style: _coachBody(context),
                            ),
                          ]
                        : snapshot.wrongAnswerHistory
                              .take(3)
                              .map(
                                (answer) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    answer.question,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '${answer.correctAnswer}${answer.explanation?.trim().isNotEmpty == true ? '\n${answer.explanation}' : ''}',
                                  ),
                                ),
                              )
                              .toList(),
                  ),
                  const SizedBox(height: 12),
                  _CoachDashboardSection(
                    title: 'Mes réussites pédagogiques',
                    icon: Icons.workspace_premium_rounded,
                    children: plan.badges
                        .map(
                          (badge) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              badge.unlocked
                                  ? Icons.check_circle_rounded
                                  : Icons.lock_outline_rounded,
                              color: badge.unlocked
                                  ? const Color(0xFF16A34A)
                                  : _muted(context),
                            ),
                            title: Text(
                              badge.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            subtitle: Text(badge.description),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (value) => setSheetState(() => query = value),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      labelText: 'Rechercher une notion ou une question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...searchable.map(
                    (entry) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        entry.$2.isCorrect
                            ? Icons.check_circle_outline_rounded
                            : Icons.error_outline_rounded,
                        color: entry.$2.isCorrect
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
                      title: Text(
                        entry.$2.question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(entry.$1.moduleLabel),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: snapshot.answerHistory.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context);
                            _openAdaptiveReview(snapshot, plan);
                          },
                    icon: const Icon(Icons.timer_rounded),
                    label: const Text('Lancer mon examen adaptatif'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => _openCoachConversation(snapshot, plan),
                    icon: const Icon(Icons.forum_rounded),
                    label: const Text('Parler à mon Coach'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Indicateur pédagogique uniquement : il ne garantit pas la réussite au concours.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: _muted(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openAdaptiveReview(
    PaProgressSnapshot snapshot,
    CopiqCoachPlan plan,
  ) async {
    final questions = <PaProgressAnswerDetail>[
      ...plan.dueErrors,
      ...plan.recurringQuestions,
      ...plan.forgettingRisks,
      ...snapshot.wrongAnswerHistory,
    ];
    final unique = <String, PaProgressAnswerDetail>{};
    for (final answer in questions) {
      final key = answer.questionId ?? answer.question.toLowerCase();
      unique.putIfAbsent(key, () => answer);
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          _AdaptiveReviewSheet(questions: unique.values.take(10).toList()),
    );
  }

  Future<DateTime?> _selectOfficialCompetitionDate(
    List<OfficialCompetitionEvent> events,
  ) async {
    final dated = events
        .where((event) => event.startsOn != null)
        .where(
          (event) => !event.startsOn!.isBefore(
            DateTime.now().subtract(const Duration(days: 1)),
          ),
        )
        .toList();
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: FractionallySizedBox(
          heightFactor: .82,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
            children: [
              Text(
                'Calendrier officiel',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Source : Police nationale · mise à jour automatique quotidienne',
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w700,
                  color: _muted(context),
                ),
              ),
              const SizedBox(height: 16),
              if (dated.isEmpty)
                const _Card(
                  child: Text('Aucune échéance future datée actuellement.'),
                )
              else
                ...dated.map(
                  (event) => Semantics(
                    button: true,
                    label:
                        '${event.typeLabel}, ${event.session}, ${event.dateText}',
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () => Navigator.pop(context, event.startsOn),
                        leading: const Icon(Icons.event_available_rounded),
                        title: Text(
                          event.session,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          '${event.region == null ? '' : '${event.region}\n'}${event.dateText}',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _durationLabel(int seconds) {
    if (seconds <= 0) return 'non mesuré';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return hours > 0 ? '${hours} h ${minutes} min' : '$minutes min';
  }

  int _forecast(int readiness, int weeklyDelta) =>
      (readiness + weeklyDelta.clamp(-10, 15) * 2).clamp(0, 100);

  String _planningText(
    PaProgressSnapshot snapshot,
    CopiqCoachPlan plan,
    DateTime? targetDate,
  ) {
    final days = targetDate?.difference(DateTime.now()).inDays;
    final horizon = days == null
        ? 'Définis ta date officielle pour obtenir un calendrier précis.'
        : '$days jours restants : ${days > 90
              ? 'consolidation des bases'
              : days > 30
              ? 'entraînement ciblé'
              : 'simulation et révision finale'}.';
    final weakest = plan.priority?.label ?? 'les fondamentaux';
    return '$horizon Cette semaine : 3 séances sur $weakest, une correction d’erreurs et un examen adaptatif.';
  }

  Future<void> _openCoachConversation(
    PaProgressSnapshot snapshot,
    CopiqCoachPlan plan,
  ) async {
    final prompts = <(String, String)>[
      ('Que dois-je travailler aujourd’hui ?', plan.message),
      (
        'Pourquoi mon score baisse ?',
        plan.weekly.delta < 0
            ? 'Ton score hebdomadaire recule de ${plan.weekly.delta.abs()} points. Commence par ${plan.priority?.label ?? 'ta matière la plus fragile'} et corrige les erreurs récurrentes avant un nouveau quiz.'
            : 'Aucune baisse nette cette semaine. Continue à consolider les notions anciennes pour éviter l’oubli.',
      ),
      (
        'Suis-je prêt pour le concours ?',
        'Ton indice actuel est de ${plan.readiness.score}/100. Il combine connaissances, régularité, vitesse, couverture et mémorisation durable ; ce n’est pas une garantie de réussite.',
      ),
      (
        'Combien de temps travailler ?',
        'Je te recommande ${plan.minutes} minutes aujourd’hui, puis une pause. La qualité et la régularité comptent davantage qu’une longue séance isolée.',
      ),
    ];
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Coach COP’IQ',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choisis une question. Chaque réponse est calculée depuis ton historique personnel.',
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w700,
                  color: _muted(context),
                ),
              ),
              const SizedBox(height: 14),
              ...prompts.map(
                (prompt) => ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    prompt.$1,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(prompt.$2, style: _coachBody(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdaptiveReviewSheet extends StatefulWidget {
  const _AdaptiveReviewSheet({required this.questions});
  final List<PaProgressAnswerDetail> questions;
  @override
  State<_AdaptiveReviewSheet> createState() => _AdaptiveReviewSheetState();
}

class _AdaptiveReviewSheetState extends State<_AdaptiveReviewSheet> {
  var index = 0;
  var revealed = false;
  String? confidence;
  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Aucune question disponible.'),
        ),
      );
    }
    final answer = widget.questions[index];
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: .88,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Examen adaptatif · ${index + 1}/${widget.questions.length}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (index + 1) / widget.questions.length,
              ),
              const SizedBox(height: 28),
              Text(
                answer.question,
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              if (!revealed)
                FilledButton.icon(
                  onPressed: () => setState(() => revealed = true),
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('Afficher la correction'),
                )
              else ...[
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonne réponse',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(answer.correctAnswer, style: _coachBody(context)),
                      if (answer.explanation?.trim().isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        Text(answer.explanation!, style: _coachBody(context)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Avant la correction, tu étais…',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'known', label: Text('Sûr')),
                    ButtonSegment(value: 'hesitant', label: Text('Hésitant')),
                    ButtonSegment(value: 'guess', label: Text('Au hasard')),
                  ],
                  selected: confidence == null ? const {} : {confidence!},
                  emptySelectionAllowed: true,
                  onSelectionChanged: (values) => setState(
                    () => confidence = values.isEmpty ? null : values.first,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () async {
                    if (answer.answerId != null && confidence != null) {
                      await LearningAnswerHistoryService().saveReflection(
                        answerId: answer.answerId!,
                        confidence: confidence!,
                      );
                    }
                    if (index + 1 >= widget.questions.length) {
                      Navigator.pop(context);
                      return;
                    }
                    setState(() {
                      index++;
                      revealed = false;
                      confidence = null;
                    });
                  },
                  child: Text(
                    index + 1 >= widget.questions.length
                        ? 'Terminer la séance'
                        : 'Question suivante',
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

class _CoachCard extends StatelessWidget {
  const _CoachCard({
    required this.plan,
    required this.onCorrectErrors,
    required this.onDashboard,
    required this.onPriority,
  });

  final CopiqCoachPlan plan;
  final VoidCallback onCorrectErrors;
  final VoidCallback onDashboard;
  final VoidCallback onPriority;

  @override
  Widget build(BuildContext context) => _Card(
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.headline,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Séance conseillée · ${plan.minutes} min',
                    style: GoogleFonts.instrumentSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          plan.message,
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (plan.recurringErrors > 0) ...[
          const SizedBox(height: 10),
          Text(
            '${plan.recurringErrors} notion${plan.recurringErrors > 1 ? 's' : ''} demande${plan.recurringErrors > 1 ? 'nt' : ''} une attention régulière.',
            style: GoogleFonts.instrumentSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: _muted(context),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: onCorrectErrors,
              icon: const Icon(Icons.fact_check_rounded),
              label: const Text('Corriger mes erreurs'),
            ),
            if (plan.priority?.route != null)
              OutlinedButton.icon(
                onPressed: onPriority,
                icon: const Icon(Icons.flag_rounded),
                label: const Text('Priorité du jour'),
              ),
            TextButton.icon(
              onPressed: onDashboard,
              icon: const Icon(Icons.insights_rounded),
              label: const Text('Diagnostic complet'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.readiness});
  final CopiqReadiness readiness;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Indice de préparation',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              '${readiness.score}%',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final item in [
          ('Connaissances', readiness.knowledge),
          ('Régularité', readiness.regularity),
          ('Maîtrise durable', readiness.durability),
          ('Rapidité', readiness.speed),
          ('Programme couvert', readiness.coverage),
        ]) ...[
          Row(
            children: [
              Expanded(child: Text(item.$1, style: _caption(context))),
              Text('${item.$2}%'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: item.$2 / 100,
            minHeight: 6,
            borderRadius: BorderRadius.circular(99),
          ),
          const SizedBox(height: 9),
        ],
      ],
    ),
  );
}

class _CoachDashboardSection extends StatelessWidget {
  const _CoachDashboardSection({
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF2563EB)),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    ),
  );
}

TextStyle _coachBody(BuildContext context) => GoogleFonts.instrumentSans(
  fontSize: 13.5,
  height: 1.45,
  fontWeight: FontWeight.w700,
  color: _muted(context),
);

String _causeLabel(CopiqErrorCause cause) => switch (cause) {
  CopiqErrorCause.unknownConcept => 'Notion à apprendre',
  CopiqErrorCause.confusion => 'Confusion entre réponses',
  CopiqErrorCause.inattention => 'Réponse probablement précipitée',
  CopiqErrorCause.tooSlow => 'Temps de réponse à améliorer',
  CopiqErrorCause.forgotten => 'Notion ancienne à réactiver',
};

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
    final mastery = const CopiqCoachEngine().mastery(subject);
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
                    const SizedBox(height: 3),
                    Text(
                      _masteryLabel(mastery),
                      style: GoogleFonts.instrumentSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: color,
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

String _masteryLabel(CopiqMasteryLevel level) => switch (level) {
  CopiqMasteryLevel.discovery => 'À découvrir',
  CopiqMasteryLevel.fragile => 'Fragile',
  CopiqMasteryLevel.progressing => 'En progression',
  CopiqMasteryLevel.mastered => 'Maîtrisé',
};

Future<void> _showActivityReview(
  BuildContext context,
  PaProgressActivity activity,
  VoidCallback onOpen,
) async {
  final wrongAnswers = activity.answers
      .where((answer) => !answer.isCorrect)
      .toList(growable: false);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .72,
      minChildSize: .45,
      maxChildSize: .94,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          Center(
            child: Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: _muted(context).withValues(alpha: .35),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            activity.title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            activity.hasScore
                ? '${activity.correct}/${activity.total} bonnes réponses • ${activity.percent} %'
                : 'Aucune question répondue',
            style: GoogleFonts.instrumentSans(
              fontWeight: FontWeight.w800,
              color: activity.hasScore
                  ? _scoreColor(activity.percent)
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 18),
          if (!activity.hasScore)
            _Card(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Cette tentative est conservée dans ton historique, mais elle n'influence ni ta moyenne, ni ta régularité, ni tes objectifs.",
                style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w700),
              ),
            )
          else if (activity.answers.isEmpty)
            _Card(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Le score de cette ancienne tentative est disponible, mais le détail question par question n'avait pas encore été enregistré.",
                style: GoogleFonts.instrumentSans(fontWeight: FontWeight.w700),
              ),
            )
          else ...[
            Text(
              wrongAnswers.isEmpty
                  ? 'Toutes les réponses sont correctes'
                  : 'À revoir • ${wrongAnswers.length} erreur${wrongAnswers.length > 1 ? 's' : ''}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Toutes les questions • ${activity.answers.length}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            ...activity.answers.asMap().entries.map(
              (answer) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _Card(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            answer.value.isCorrect
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            size: 20,
                            color: answer.value.isCorrect
                                ? const Color(0xFF059669)
                                : const Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${answer.key + 1}. ${answer.value.question}',
                              style: GoogleFonts.instrumentSans(
                                fontWeight: FontWeight.w900,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Ta réponse : ${answer.value.userAnswer}'),
                      const SizedBox(height: 4),
                      Text(
                        'Bonne réponse : ${answer.value.correctAnswer}',
                        style: const TextStyle(
                          color: Color(0xFF059669),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (answer.value.explanation?.trim().isNotEmpty ==
                          true) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            answer.value.explanation!,
                            style: GoogleFonts.instrumentSans(
                              height: 1.45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (activity.route != null) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onOpen();
              },
              icon: const Icon(Icons.school_rounded),
              label: const Text('Revoir ce module'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _ErrorNotebookEntry {
  const _ErrorNotebookEntry({required this.activity, required this.answer});
  final PaProgressActivity activity;
  final PaProgressAnswerDetail answer;
}

class _ErrorNotebookTile extends StatelessWidget {
  const _ErrorNotebookTile({required this.entry, required this.onReviewModule});

  final _ErrorNotebookEntry entry;
  final VoidCallback onReviewModule;

  @override
  Widget build(BuildContext context) => _Card(
    onTap: () => _showErrorDetail(context, entry, onReviewModule),
    padding: const EdgeInsets.all(15),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626).withValues(alpha: .1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.close_rounded, color: Color(0xFFDC2626)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.answer.question,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.instrumentSans(
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${entry.activity.moduleLabel} • ${_ago(entry.answer.answeredAt ?? entry.activity.finishedAt)}',
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

Future<void> _showErrorDetail(
  BuildContext context,
  _ErrorNotebookEntry entry,
  VoidCallback onReviewModule,
) async {
  final answer = entry.answer;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comprendre mon erreur",
            style: GoogleFonts.poppins(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entry.activity.moduleLabel,
            style: GoogleFonts.instrumentSans(
              color: _muted(sheetContext),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          _Card(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  answer.question,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                _AnswerLine(
                  label: 'Ta réponse',
                  value: answer.userAnswer,
                  color: const Color(0xFFDC2626),
                  icon: Icons.close_rounded,
                ),
                const SizedBox(height: 10),
                _AnswerLine(
                  label: 'Bonne réponse',
                  value: answer.correctAnswer,
                  color: const Color(0xFF059669),
                  icon: Icons.check_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Card(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explication',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  answer.explanation?.trim().isNotEmpty == true
                      ? answer.explanation!
                      : "L'explication détaillée n'était pas enregistrée pour cette question. La bonne réponse reste disponible ci-dessus.",
                  style: GoogleFonts.instrumentSans(
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (entry.activity.route != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              style: _primaryButtonStyle(sheetContext),
              onPressed: () {
                Navigator.of(sheetContext).pop();
                onReviewModule();
              },
              icon: const Icon(Icons.school_rounded),
              label: const Text('Revoir cette notion'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: color.withValues(alpha: .18)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 9),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label\n',
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: value),
              ],
            ),
            style: GoogleFonts.instrumentSans(
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
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
    final unanswered = !activity.hasScore;
    final color = unanswered
        ? const Color(0xFF64748B)
        : _scoreColor(activity.percent);
    return _Card(
      onTap: () => _showActivityReview(context, activity, onOpen),
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
              unanswered ? '—' : '${activity.percent}%',
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
                  unanswered
                      ? '${activity.moduleLabel} • Aucune question répondue • ${_ago(activity.finishedAt)}'
                      : '${activity.moduleLabel} • ${activity.correct}/${activity.total} • ${_ago(activity.finishedAt)}',
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
